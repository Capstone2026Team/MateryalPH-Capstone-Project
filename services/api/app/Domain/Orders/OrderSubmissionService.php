<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Finance\Money;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Procurement\CartService;
use App\Domain\Procurement\CheckoutPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Vendors\NewProcurementAvailability;
use Carbon\CarbonImmutable;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Item-Based order submission. One parent checkout holds one child order request per selected Vendor group;
 * each child snapshots its lines (listing, variant, unit, applied price version, frozen volume tiers, tax
 * classification, displayed image) and the intended destination, heavy-vehicle answer and alternate drop-off
 * separately. Submission never reserves stock. A retry with the same Idempotency-Key returns the same checkout;
 * the same key with a different request is a conflict. After the submission commits, each child order gets one
 * all-or-nothing auto-accept attempt; a failure leaves that complete order for manual Vendor review.
 */
final class OrderSubmissionService
{
    public const VENDOR_RESPONSE_HOURS = 24;

    public const MAX_GROUPS = 20;

    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly CartService $carts,
        private readonly CheckoutPreviewService $preview,
        private readonly ListingPublicFacts $facts,
        private readonly NewProcurementAvailability $availability,
        private readonly OrderTransitionService $transitions,
        private readonly OrderCommercial $commercial,
        private readonly OrderNotifier $notifier,
        private readonly AutoAcceptService $autoAccept,
        private readonly OutboxPublisher $outbox,
        private readonly AuditRecorder $audit,
        private readonly CatalogAccess $idempotency,
    ) {}

    /**
     * @param  array{cart_lock_version: int, vendor_ids: list<string>, split_confirmed?: bool}  $input
     * @return array{checkout: array<string, mixed>, replayed: bool}
     */
    public function submit(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $key = $this->idempotency->requireIdempotencyKey($request);
        $vendorIds = array_values(array_unique(array_map('strval', $input['vendor_ids'])));
        sort($vendorIds);
        $requestHash = hash_hmac('sha256', json_encode(['cart' => (int) $input['cart_lock_version'], 'vendors' => $vendorIds, 'split' => (bool) ($input['split_confirmed'] ?? false)], JSON_THROW_ON_ERROR), (string) config('app.key'));
        $scopedKey = hash('sha256', 'checkout|'.$buyerId.'|'.$key);
        if (($existing = $this->replay($scopedKey, $requestHash)) !== null) {
            return ['checkout' => $this->present($existing), 'replayed' => true];
        }

        // Route and advisory delivery lookups happen before any lock is taken.
        $preview = $this->preview->preview($request, []);
        $groups = [];
        foreach ($preview['groups'] as $group) {
            $groups[(string) $group['vendor']['id']] = $group;
        }
        $problems = [];
        foreach ($vendorIds as $vendorId) {
            $group = $groups[$vendorId] ?? null;
            if ($group === null) {
                $problems[$vendorId] = ['status' => 'NOT_IN_CART', 'issues' => []];
            } elseif ($group['status'] !== 'READY' || ! $this->onlineAvailable($group)) {
                $problems[$vendorId] = ['status' => $group['status'], 'issues' => array_column($group['issues'], 'code')];
            }
        }
        if ($problems !== []) {
            throw new AuthenticationException('CHECKOUT_GROUP_NOT_READY', 'Some Vendor groups need attention before they can be submitted. Nothing was ordered.', 409, ['groups' => $problems]);
        }
        if (count($vendorIds) < count($groups) && ! ($input['split_confirmed'] ?? false)) {
            throw new AuthenticationException('SPLIT_CONFIRMATION_REQUIRED', 'Confirm that only the selected Vendor groups are submitted; the others stay in your cart.', 422, ['split_confirmed' => ['Confirm the split to continue.']]);
        }

        try {
            $checkoutId = DB::transaction(function () use ($request, $input, $buyerId, $vendorIds, $groups, $scopedKey, $requestHash): string {
                $cart = $this->carts->cart($buyerId, true);
                if (($existing = $this->replay($scopedKey, $requestHash)) !== null) {
                    return (string) $existing->id;
                }
                if ((int) $cart->lock_version !== (int) $input['cart_lock_version']) {
                    throw new AuthenticationException('CART_VERSION_CONFLICT', 'Your cart changed on another screen or device. Review the latest checkout and submit again.', 409, ['current_lock_version' => (int) $cart->lock_version]);
                }
                $actor = OrderActor::buyer($request);
                $checkoutId = (string) Str::uuid7();
                DB::table('checkout_groups')->insert(['id' => $checkoutId, 'buyer_profile_id' => $buyerId, 'reference' => $this->reference('CHK'), 'state' => 'SUBMITTED',
                    'idempotency_key' => $scopedKey, 'request_hash' => $requestHash, 'cart_id' => $cart->id, 'submitted_by_user_id' => $actor->userId, 'submitted_at' => now(),
                    'created_at' => now(), 'updated_at' => now()]);
                $lines = array_values(array_filter($this->carts->lines((string) $cart->id), static fn (array $line): bool => ! $line['saved_for_later']));
                $destination = $this->carts->destination($cart);
                foreach ($vendorIds as $vendorId) {
                    $this->availability->assertAvailable($vendorId);
                    $vendorLines = array_values(array_filter($lines, static fn (array $line): bool => $line['vendor_id'] === $vendorId));
                    $this->assertUnchanged($vendorLines);
                    $orderId = $this->createOrder($checkoutId, $buyerId, $vendorId, $groups[$vendorId], $vendorLines, $destination, $cart, $actor);
                    DB::table('checkout_vendor_groups')->insert(['id' => (string) Str::uuid7(), 'checkout_group_id' => $checkoutId, 'vendor_organization_id' => $vendorId, 'order_id' => $orderId, 'created_at' => now(), 'updated_at' => now()]);
                    DB::table('cart_items')->whereIn('id', array_column($vendorLines, 'id'))->delete();
                    DB::table('cart_vendor_groups')->where('cart_id', $cart->id)->where('vendor_organization_id', $vendorId)->delete();
                }
                DB::table('carts')->where('id', $cart->id)->update(['lock_version' => (int) $cart->lock_version + 1, 'updated_at' => now()]);
                $this->audit->account($request, 'CHECKOUT_SUBMITTED', 'CHECKOUT_GROUP', $checkoutId, after: ['vendor_groups' => count($vendorIds)]);

                return $checkoutId;
            });
        } catch (QueryException $exception) {
            // A concurrent retry with the same key committed first; return that checkout instead of a duplicate.
            $existing = $this->replay($scopedKey, $requestHash);
            if ($existing === null) {
                throw $exception;
            }
            $checkoutId = (string) $existing->id;
        }

        foreach (DB::table('checkout_vendor_groups')->where('checkout_group_id', $checkoutId)->orderBy('vendor_organization_id')->pluck('order_id') as $orderId) {
            try {
                $this->autoAccept->attempt((string) $orderId, $request);
            } catch (Throwable $exception) {
                // The order request stays with the Vendor for manual review; the submission itself succeeded.
                report($exception);
            }
        }

        return ['checkout' => $this->present(DB::table('checkout_groups')->where('id', $checkoutId)->first()), 'replayed' => false];
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $checkoutId): array
    {
        $checkout = Str::isUuid($checkoutId) ? DB::table('checkout_groups')->where('id', $checkoutId)->where('buyer_profile_id', $this->profiles->idFor($request))->first() : null;
        if ($checkout === null) {
            throw new AuthenticationException('CHECKOUT_NOT_FOUND', 'This checkout is unavailable.', 404);
        }

        return $this->present($checkout);
    }

    /**
     * The parent status is derived from its child orders and never replaces them.
     *
     * @return array<string, mixed>
     */
    public function present(object $checkout): array
    {
        $orders = DB::table('checkout_vendor_groups as g')->join('orders as o', 'o.id', '=', 'g.order_id')->join('store_profiles as s', 's.vendor_organization_id', '=', 'o.vendor_organization_id')
            ->where('g.checkout_group_id', $checkout->id)->orderBy('s.public_store_name')->orderBy('o.id')
            ->get(['o.id', 'o.reference', 'o.vendor_organization_id', 's.public_store_name', 'o.order_state', 'o.payment_state', 'o.fulfillment_method', 'o.payment_method', 'o.confirmation_source',
                'o.materials_centavos', 'o.delivery_centavos', 'o.commercial_total_centavos', 'o.vendor_response_due_at', 'o.payment_expires_at']);
        $states = $orders->pluck('order_state')->all();

        return [
            'id' => (string) $checkout->id, 'reference' => (string) $checkout->reference, 'submitted_at' => CarbonImmutable::parse((string) ($checkout->submitted_at ?? $checkout->created_at))->toIso8601String(),
            'derived_status' => match (true) {
                $states === [] => 'EMPTY',
                count(array_intersect($states, OrderStates::PENDING_ACCEPTANCE)) > 0 => 'AWAITING_CONFIRMATIONS',
                in_array(OrderStates::AWAITING_PAYMENT, $states, true) => 'AWAITING_PAYMENT',
                default => 'CHILD_ORDERS_UPDATED',
            },
            'orders' => $orders->map(static fn (object $order): array => [
                'id' => (string) $order->id, 'reference' => (string) $order->reference, 'vendor' => ['id' => (string) $order->vendor_organization_id, 'name' => (string) $order->public_store_name],
                'order_state' => (string) $order->order_state, 'payment_state' => (string) $order->payment_state, 'fulfillment_method' => (string) $order->fulfillment_method,
                'payment_method' => (string) $order->payment_method, 'confirmation_source' => $order->confirmation_source,
                'materials_centavos' => (int) $order->materials_centavos, 'delivery_centavos' => $order->delivery_centavos === null ? null : (int) $order->delivery_centavos,
                'commercial_total_centavos' => (int) $order->commercial_total_centavos,
                'vendor_response_due_at' => $order->vendor_response_due_at === null ? null : CarbonImmutable::parse((string) $order->vendor_response_due_at)->toIso8601String(),
                'payment_expires_at' => $order->payment_expires_at === null ? null : CarbonImmutable::parse((string) $order->payment_expires_at)->toIso8601String(),
            ])->all(),
            'notice' => 'Each Vendor reviews its own order request. Nothing is charged until a Vendor confirms and you accept the final amount.',
        ];
    }

    private function replay(string $scopedKey, string $requestHash): ?object
    {
        $existing = DB::table('checkout_groups')->where('idempotency_key', $scopedKey)->first();
        if ($existing !== null && ! hash_equals((string) $existing->request_hash, $requestHash)) {
            throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a changed checkout.', 409);
        }

        return $existing;
    }

    /** @param array<string, mixed> $group */
    private function onlineAvailable(array $group): bool
    {
        foreach ($group['payment_methods'] as $method) {
            if ($method['method'] === 'ONLINE' && $method['available']) {
                return true;
            }
        }

        return false;
    }

    /** @param list<array<string, mixed>> $lines */
    private function assertUnchanged(array $lines): void
    {
        foreach ($lines as $line) {
            $blocking = array_filter($line['issues'], static fn (array $issue): bool => $issue['severity'] !== CartService::INFO);
            if ($line['current'] === null || $blocking !== []) {
                throw new AuthenticationException('CHECKOUT_CHANGED', 'A price, availability or listing changed while you were checking out. Review the checkout and submit again.', 409, ['line_id' => $line['id']]);
            }
        }
    }

    /**
     * @param  array<string, mixed>  $group
     * @param  list<array<string, mixed>>  $lines
     * @param  array<string, mixed>  $destination
     */
    private function createOrder(string $checkoutId, string $buyerId, string $vendorId, array $group, array $lines, array $destination, object $cart, OrderActor $actor): string
    {
        $method = (string) $group['fulfillment_method'];
        $orderId = (string) Str::uuid7();
        $variantIds = array_column($lines, 'variant_id');
        $facts = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
            ->join('units as u', 'u.id', '=', 'v.unit_id')->leftJoin('materials as m', 'm.id', '=', 'p.material_id')->leftJoin('material_categories as c', 'c.id', '=', 'l.material_category_id')
            ->whereIn('v.id', $variantIds)->get(['v.id', 'v.sku', 'v.unit_id', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm', 'u.precision', 'l.vendor_sku', 'l.regulated',
                'l.compliance_status', 'l.current_compliance_submission_id', 'l.publication_version', 'p.brand', 'm.name as material_name', 'c.name as category_name'])->keyBy('id');
        $tiers = $this->facts->volumeTiers($variantIds);
        $materials = 0;
        $rows = [];
        foreach ($lines as $index => $line) {
            $fact = $facts->get($line['variant_id']);
            $quantity = StockAvailability::quantity($line['quantity']);
            $unit = (int) $line['current']['applied_unit_price_centavos'];
            $gross = Money::lineAmount($quantity, $unit);
            $materials += $gross;
            $rows[] = [
                'id' => (string) Str::uuid7(), 'order_id' => $orderId, 'line_number' => $index + 1, 'listing_variant_id' => $line['variant_id'], 'vendor_listing_id' => $line['listing_id'],
                'unit_id' => $fact->unit_id, 'quantity' => $quantity, 'unit_price_centavos' => $unit, 'discount_centavos' => 0,
                'included_vat_centavos' => Money::includedVat($gross, (string) $line['current']['tax_category']), 'payable_centavos' => $gross, 'tax_category' => $line['current']['tax_category'],
                'listing_price_version_id' => $line['current']['price_version_id'], 'applied_price_version_id' => $line['current']['applied_price_version_id'],
                'ordinary_unit_price_centavos' => (int) $line['current']['unit_price_centavos'],
                'volume_tiers' => json_encode($tiers[$line['variant_id']] ?? [], JSON_THROW_ON_ERROR),
                'snapshot' => json_encode([
                    'display_name' => $line['display_name'], 'variant_label' => $line['variant_label'], 'sku' => $fact->sku, 'vendor_sku' => $fact->vendor_sku,
                    'unit_code' => $line['unit_code'], 'unit_name' => $line['unit_name'], 'unit_precision' => (int) $fact->precision, 'quantity_step' => $line['quantity_step'],
                    'brand' => $fact->brand, 'material' => $fact->material_name, 'category' => $fact->category_name, 'image' => $line['image'],
                    'regulated' => (bool) $fact->regulated, 'compliance_status' => $fact->compliance_status, 'compliance_submission_id' => $fact->current_compliance_submission_id,
                    'publication_version' => (int) $fact->publication_version, 'stock_label_at_submission' => $line['current']['stock_label'],
                    'volume_tier_applied' => (bool) $line['current']['volume_tier_applied'],
                    'load' => ['weight_kg' => $fact->weight_kg === null ? null : (string) $fact->weight_kg, 'length_cm' => $fact->length_cm === null ? null : (string) $fact->length_cm,
                        'width_cm' => $fact->width_cm === null ? null : (string) $fact->width_cm, 'height_cm' => $fact->height_cm === null ? null : (string) $fact->height_cm],
                ], JSON_THROW_ON_ERROR),
                'created_at' => now(), 'updated_at' => now(),
            ];
        }
        $delivery = $method === 'PICKUP' ? 0 : null;
        $now = CarbonImmutable::now();
        DB::table('orders')->insert([
            'id' => $orderId, 'reference' => $this->reference('ORD'), 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $vendorId, 'checkout_group_id' => $checkoutId,
            'procurement_type' => 'ITEM_BASED', 'order_state' => OrderStates::AWAITING_VENDOR_CONFIRMATION, 'payment_state' => 'NOT_REQUIRED', 'refund_state' => 'NOT_REQUESTED',
            'fulfillment_state' => 'NOT_STARTED', 'dispute_state' => 'NONE', 'fulfillment_method' => $method, 'payment_method' => 'ONLINE',
            'materials_centavos' => $materials, 'vendor_discount_centavos' => 0, 'delivery_centavos' => $delivery, 'nrpc_centavos' => 0, 'commercial_total_centavos' => $materials + (int) $delivery,
            'submitted_at' => $now, 'vendor_response_due_at' => $now->addHours(self::VENDOR_RESPONSE_HOURS), 'current_snapshot_version' => 1,
            'destination' => json_encode($this->destination($method, $destination, $group), JSON_THROW_ON_ERROR),
            'access_instructions_encrypted' => $method === 'DELIVERY' ? $cart->access_instructions_encrypted : null,
            'lock_version' => 1, 'created_at' => $now, 'updated_at' => $now,
        ]);
        DB::table('order_lines')->insert($rows);
        $order = DB::table('orders')->where('id', $orderId)->first();
        $commercial = $this->commercial->compute($this->commercial->lines($orderId), [], 0, $delivery);
        $this->commercial->record($order, 'SUBMITTED', [
            'fulfillment_method' => $method, 'payment_method' => 'ONLINE',
            'delivery_estimate' => $method === 'DELIVERY' ? array_intersect_key($group['delivery'], array_flip(['status', 'estimate', 'route', 'endpoint', 'manual_review_reasons', 'calculation_version'])) : null,
            'lines' => array_map(static fn (array $row): array => ['order_line_id' => $row['id'], 'line_number' => $row['line_number'], 'quantity' => $row['quantity'], 'unit_price_centavos' => $row['unit_price_centavos']], $rows),
        ], $commercial, $actor);
        $this->transitions->opened($order, $actor);
        $this->outbox->publish('ORDER_SUBMITTED', 'ORDER', $orderId, ['order_id' => $orderId, 'vendor_organization_id' => $vendorId, 'checkout_group_id' => $checkoutId]);
        $this->notifier->vendor($order, 'New order request '.$order->reference, 'A Buyer submitted an order request. Confirm, revise or decline it by '.CarbonImmutable::parse((string) $order->vendor_response_due_at)->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Philippine time).');

        return $orderId;
    }

    /**
     * The intended destination and any alternate drop-off are kept as separate labelled references; the vehicle
     * endpoint is the alternate only when the Buyer declared a heavy-vehicle restriction.
     *
     * @param  array<string, mixed>  $destination
     * @param  array<string, mixed>  $group
     * @return array<string, mixed>
     */
    private function destination(string $method, array $destination, array $group): array
    {
        if ($method === 'PICKUP') {
            return ['type' => 'PICKUP', 'store_address' => $group['pickup']['address'] ?? null];
        }
        $point = static function (?array $described, ?array $point): ?array {
            if ($described === null || $point === null) {
                return null;
            }

            return ['location_id' => $described['location_id'], 'label' => $described['label'], 'kind' => $described['kind'], 'formatted_address' => $described['formatted_address'],
                'address_id' => $point['address_id'], 'latitude' => $point['latitude'], 'longitude' => $point['longitude']];
        };

        return [
            'type' => 'DELIVERY',
            'intended' => $point($destination['intended'], $destination['_points']['intended']),
            'heavy_vehicle_restriction' => $destination['heavy_vehicle_restriction'],
            'alternate_drop_off' => $destination['heavy_vehicle_restriction'] === 'YES' ? $point($destination['alternate_drop_off'], $destination['_points']['alternate']) : null,
            'vehicle_endpoint' => $destination['vehicle_endpoint'],
            'labels' => $destination['labels'],
        ];
    }

    private function reference(string $prefix): string
    {
        return $prefix.'-'.CarbonImmutable::now('Asia/Manila')->format('Y').'-'.Str::upper(Str::random(8));
    }
}
