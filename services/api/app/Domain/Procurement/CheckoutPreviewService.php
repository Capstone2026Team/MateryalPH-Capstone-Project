<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Finance\FinancialSnapshotService;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Payments\PaymentMethodPolicy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Checkout preview: one child group per Vendor, each revalidated independently for listing state, price
 * version, availability label, destination and serviceability, delivery/pickup capability and payment-method
 * eligibility. A stale or blocked result is reported inline on the affected group; the rest of the cart stays
 * intact and previewable. The preview never creates an order, hold or reservation and never writes the cart.
 */
final class CheckoutPreviewService
{
    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly CartService $carts,
        private readonly DeliveryPreviewService $delivery,
        private readonly FinancialSnapshotService $finance,
        private readonly PublicVendorProjection $vendors,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function preview(Request $request, array $input): array
    {
        $cart = $this->carts->cart($this->profiles->idFor($request));
        $lines = array_values(array_filter($this->carts->lines((string) $cart->id), static fn (array $line): bool => ! $line['saved_for_later']));
        $destination = $this->carts->destination($cart);
        $vendorIds = array_values(array_unique(array_map(static fn (array $line): string => $line['vendor_id'], $lines)));
        $choices = DB::table('cart_vendor_groups')->where('cart_id', $cart->id)->pluck('fulfillment_method', 'vendor_organization_id');
        $summaries = $this->vendors->summaries($vendorIds);
        $discoverable = $vendorIds === [] ? [] : $this->vendors->members()->whereIn('o.id', $vendorIds)->pluck('o.id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();
        $online = $vendorIds === [] ? [] : DB::table('vendor_payment_accounts')->whereIn('vendor_organization_id', $vendorIds)->where('connection_status', 'CONNECTED_TEST')
            ->pluck('vendor_organization_id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();
        $groups = [];
        foreach ($vendorIds as $vendorId) {
            $groupLines = array_values(array_filter($lines, static fn (array $line): bool => $line['vendor_id'] === $vendorId));
            $groups[] = $this->group($vendorId, $groupLines, $summaries[$vendorId] ?? null, isset($discoverable[$vendorId]), isset($online[$vendorId]), $choices[$vendorId] ?? null, $destination);
        }
        $count = static fn (string $status): int => count(array_filter($groups, static fn (array $group): bool => $group['status'] === $status));
        unset($destination['_points']);

        return [
            'request_version' => $input['request_version'] ?? null,
            'cart_lock_version' => (int) $cart->lock_version,
            'current_as_of' => now()->toIso8601String(),
            'calculation_version' => FinancialSnapshotService::PREVIEW_VERSION,
            'destination' => $destination,
            'groups' => $groups,
            'summary' => [
                'group_count' => count($groups), 'ready_groups' => $count('READY'), 'action_required_groups' => $count('ACTION_REQUIRED'), 'blocked_groups' => $count('BLOCKED'),
                'requires_split_confirmation' => $count('READY') > 0 && $count('READY') < count($groups),
                'creates_orders' => false, 'reserves_stock' => false,
                'notice' => 'Checkout creates a separate order request for each Vendor. Nothing is reserved or charged until each Vendor confirms and you accept the final amount.',
            ],
        ];
    }

    /**
     * @param  list<array<string, mixed>>  $lines
     * @param  array<string, mixed>|null  $vendor
     * @param  array<string, mixed>  $destination
     * @return array<string, mixed>
     */
    private function group(string $vendorId, array $lines, ?array $vendor, bool $discoverable, bool $online, ?string $choice, array $destination): array
    {
        $issues = [];
        $store = DB::table('store_profiles')->where('vendor_organization_id', $vendorId)->first(['public_store_name', 'fulfillment_method', 'vacation_mode']);
        $options = CartService::fulfillmentOptions((string) ($store->fulfillment_method ?? ''));
        if (! $discoverable || $vendor === null) {
            $issues[] = ['code' => 'VENDOR_UNAVAILABLE', 'severity' => CartService::BLOCKING, 'message' => 'This store is not accepting new orders right now. Your other Vendor groups are unaffected.'];
        } elseif ($vendor['vacation_mode']) {
            $issues[] = ['code' => 'VENDOR_PAUSED', 'severity' => CartService::BLOCKING, 'message' => 'This store has paused new procurement (Vacation Mode).'];
        }
        $method = $choice ?? (count($options) === 1 ? $options[0] : null);
        if ($method === null) {
            $issues[] = ['code' => 'FULFILLMENT_REQUIRED', 'severity' => CartService::ACTION_REQUIRED, 'message' => 'Choose Site Delivery or Self-Pickup for this store.'];
        } elseif (! in_array($method, $options, true)) {
            $issues[] = ['code' => 'FULFILLMENT_NOT_OFFERED', 'severity' => CartService::ACTION_REQUIRED, 'message' => 'This store no longer offers the selected fulfillment method. Choose another.'];
        }
        $valid = array_values(array_filter($lines, static fn (array $line): bool => $line['current'] !== null));
        $delivery = DeliveryPreviewService::notApplicable();
        if ($method === 'DELIVERY' && in_array('DELIVERY', $options, true) && $valid !== []) {
            $delivery = $this->delivery->preview($vendorId, $destination, $valid);
            array_push($issues, ...$delivery['issues']);
        }
        $payment = app(PaymentMethodPolicy::class)->options($vendorId, $method, $online);
        if (array_filter($payment, static fn (array $option): bool => $option['available']) === []) {
            $issues[] = ['code' => 'PAYMENT_METHOD_UNAVAILABLE', 'severity' => CartService::BLOCKING, 'message' => 'This store cannot accept a payment method for this order yet.'];
        }
        $range = match ($delivery['status']) {
            'ADVISORY_ESTIMATE' => ['status' => 'ESTIMATE', 'min_centavos' => $delivery['estimate']['fee_min_centavos'], 'max_centavos' => $delivery['estimate']['fee_max_centavos']],
            'NOT_APPLICABLE' => ['status' => 'NOT_APPLICABLE', 'min_centavos' => 0, 'max_centavos' => 0],
            default => ['status' => 'PENDING_VENDOR_REVIEW', 'min_centavos' => null, 'max_centavos' => null],
        };
        $amounts = $this->finance->previewChildOrder(array_map(static fn (array $line): array => ['line_id' => $line['id'], 'quantity' => $line['quantity'],
            'unit_price_centavos' => $line['current']['applied_unit_price_centavos'], 'tax_category' => $line['current']['tax_category']], $valid), $range);
        $lineIssues = array_merge(...array_map(static fn (array $line): array => $line['issues'], $lines));
        $all = array_merge($issues, $lineIssues);

        return [
            'vendor' => ['id' => $vendorId, 'name' => $vendor['public_store_name'] ?? (string) ($store->public_store_name ?? 'Store unavailable'), 'logo_url' => $vendor['logo_url'] ?? null,
                'address' => $vendor['address'] ?? null, 'open_status' => $vendor['open_status'] ?? null],
            'fulfillment_method' => $method,
            'fulfillment_options' => $options,
            'status' => $this->carts->worst($all),
            'issues' => $issues,
            'lines' => array_map(static fn (array $line): array => array_diff_key($line, ['load' => true]), $lines),
            'delivery' => $delivery,
            'pickup' => $method === 'PICKUP' ? ['address' => $vendor['address'] ?? null, 'open_status' => $vendor['open_status'] ?? null,
                'notice' => 'The Vendor confirms the ready-for-pickup date before you pay. Store hours are informational.'] : null,
            'payment_methods' => $payment,
            'amounts' => $amounts,
        ];
    }
}
