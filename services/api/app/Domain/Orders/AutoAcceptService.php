<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\AutoAcceptGate;
use App\Domain\Inventory\AutoAcceptPolicyService;
use App\Domain\Inventory\InventoryLedgerWriter;
use App\Domain\Inventory\InventoryLocks;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Operations\OutboxPublisher;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Item-Based auto-accept for one child order. In one transaction it locks the organization, the order, every
 * affected inventory row and every policy row in deterministic order, rechecks the complete order and either
 * accepts all of it — immutable AUTO_ACCEPTED version, hard reservations, allotment consumption with pause at
 * zero, frozen financial snapshot — or changes nothing and routes the whole order to manual review with its
 * reasons. Never for Project-Based, NRPC, Site Delivery (the Owner/Manager must confirm vehicles, trips and the
 * fee) or a store without a configured ready-for-pickup lead time. Public hours are never an input.
 */
final class AutoAcceptService
{
    public const RULE_VERSION = 'auto-accept.order.v1';

    public function __construct(
        private readonly InventoryLocks $locks,
        private readonly InventoryLedgerWriter $ledger,
        private readonly AutoAcceptPolicyService $policies,
        private readonly OrderEligibility $eligibility,
        private readonly OrderCommercial $commercial,
        private readonly OrderAcceptance $acceptance,
        private readonly OrderNotifier $notifier,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** @return array{accepted: bool, reasons: list<array{code: string, listing_variant_id: ?string}>} */
    public function attempt(string $orderId, ?Request $request = null): array
    {
        $actor = OrderActor::autoAccept($request);
        try {
            return DB::transaction(fn (): array => $this->evaluate($orderId, $actor));
        } catch (AuthenticationException $exception) {
            // A concurrent change won the locks between the checks and the writes; nothing partial remains.
            return DB::transaction(fn (): array => $this->routeToManual($orderId, [['code' => $exception->errorCode, 'listing_variant_id' => null]], $actor));
        }
    }

    /** @return array{accepted: bool, reasons: list<array{code: string, listing_variant_id: ?string}>} */
    private function evaluate(string $orderId, OrderActor $actor): array
    {
        $vendorId = DB::table('orders')->where('id', $orderId)->value('vendor_organization_id');
        if ($vendorId === null) {
            return ['accepted' => false, 'reasons' => [['code' => 'ORDER_NOT_FOUND', 'listing_variant_id' => null]]];
        }
        $organization = DB::table('vendor_organizations')->where('id', $vendorId)->lockForUpdate()->first();
        $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
        if ($order->order_state !== OrderStates::AWAITING_VENDOR_CONFIRMATION || $order->confirmation_source !== null) {
            return ['accepted' => false, 'reasons' => [['code' => 'ORDER_NOT_PENDING', 'listing_variant_id' => null]]];
        }
        $reasons = [];
        $reason = static function (string $code, ?string $variantId = null) use (&$reasons): void {
            $reasons[] = ['code' => $code, 'listing_variant_id' => $variantId];
        };
        foreach ($this->eligibility->storeBlockers($organization) as $code) {
            $reason($code);
        }
        if ($order->fulfillment_method !== 'PICKUP') {
            // An advisory delivery suggestion is not a confirmed commercial offer.
            $reason('DELIVERY_REQUIRES_VENDOR_CONFIRMATION');
        }
        $leadDays = DB::table('vendor_inventory_settings')->where('vendor_organization_id', $vendorId)->value('auto_accept_ready_lead_days');
        if ($leadDays === null) {
            $reason('FULFILLMENT_DATE_NOT_CONFIGURED');
        }
        if ($order->payment_method === 'ONLINE' && ! $this->eligibility->onlinePaymentReady((string) $vendorId)) {
            $reason('PAYMENT_CAPABILITY_UNAVAILABLE');
        }
        $lines = $this->commercial->lines($orderId);
        foreach ($this->eligibility->lineBlockers((string) $vendorId, array_combine(array_map(static fn (object $line): string => (string) $line->listing_variant_id, $lines), array_map(static fn (object $line): string => (string) $line->tax_category, $lines))) as $variantId => $code) {
            $reason($code, $variantId);
        }
        $locked = $this->locks->lockForAcceptance(array_map(static fn (object $line): string => (string) $line->listing_variant_id, $lines));
        $gate = AutoAcceptGate::evaluate(
            ['procurement_type' => (string) $order->procurement_type, 'nrpc_centavos' => (int) $order->nrpc_centavos, 'commercial_total_centavos' => (int) $order->commercial_total_centavos,
                'lines' => array_map(static fn (object $line): array => ['listing_variant_id' => (string) $line->listing_variant_id, 'quantity' => (string) $line->quantity, 'tax_category' => (string) $line->tax_category], $lines)],
            array_map(static fn (object $policy): array => AutoAcceptPolicyService::present($policy), $locked['policies']),
            array_map(static fn (object $item): string => StockAvailability::availableToSell(StockAvailability::quantity($item->quantity_on_hand), StockAvailability::quantity($item->hard_reserved_quantity)), $locked['inventory']),
        );
        array_push($reasons, ...$gate['reasons']);
        if ($reasons !== []) {
            return $this->routeToManual($orderId, $reasons, $actor, $order);
        }

        $listingNames = [];
        foreach ($lines as $line) {
            $listingNames[(string) $line->listing_variant_id] = (string) (json_decode((string) $line->snapshot, true)['display_name'] ?? 'Listing');
        }
        $versions = [];
        foreach ($lines as $line) {
            $variantId = (string) $line->listing_variant_id;
            $versions[$variantId] = $this->policies->consume($locked['policies'][$variantId], (string) $line->quantity, (string) $vendorId, $listingNames[$variantId]);
            $this->ledger->reserve($locked['inventory'][$variantId], (string) $line->quantity, null, $orderId, (string) $line->id, $versions[$variantId]);
        }
        $readyDate = CarbonImmutable::now('Asia/Manila')->addDays((int) $leadDays)->toDateString();
        $commercial = $this->commercial->compute($lines, [], 0, 0);
        $snapshot = $this->commercial->record($order, 'AUTO_ACCEPTED', [
            'fulfillment_method' => 'PICKUP', 'payment_method' => (string) $order->payment_method, 'fulfillment_date' => $readyDate, 'fulfillment_date_basis' => 'AUTO_ACCEPT_READY_LEAD_DAYS:'.(int) $leadDays,
            'lines' => array_map(static fn (object $line): array => ['order_line_id' => (string) $line->id, 'requested_quantity' => StockAvailability::quantity($line->quantity), 'confirmed_quantity' => StockAvailability::quantity($line->quantity)], $lines),
            'changes' => [], 'auto_accept' => ['rule_version' => self::RULE_VERSION, 'gate_version' => AutoAcceptGate::RULE_VERSION, 'policy_versions' => $versions],
        ], $commercial, $actor);
        $firstVariant = array_key_first($versions);
        $confirmationId = (string) Str::uuid7();
        DB::table('vendor_confirmations')->insert(['id' => $confirmationId, 'order_id' => $orderId, 'actor_user_id' => null, 'actor_role' => $actor->role, 'state' => 'CONFIRMED', 'source' => 'AUTO_ACCEPT',
            'auto_accept_policy_version_id' => $versions[$firstVariant], 'order_snapshot_version' => (int) $snapshot->version, 'payload' => json_encode(['rule_version' => self::RULE_VERSION], JSON_THROW_ON_ERROR),
            'created_at' => now(), 'updated_at' => now()]);
        foreach ($lines as $line) {
            DB::table('vendor_confirmation_policy_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_confirmation_id' => $confirmationId, 'listing_variant_id' => $line->listing_variant_id,
                'auto_accept_policy_version_id' => $versions[(string) $line->listing_variant_id], 'consumed_quantity' => $line->quantity, 'created_at' => now()]);
        }
        DB::table('orders')->where('id', $orderId)->update(['confirmation_source' => 'AUTO_ACCEPT', 'current_snapshot_version' => (int) $snapshot->version, 'expected_fulfillment_date' => $readyDate,
            'vendor_response_due_at' => null, 'auto_accept_outcome' => json_encode(['accepted' => true, 'reasons' => [], 'rule_version' => self::RULE_VERSION, 'evaluated_at' => now()->toIso8601String()], JSON_THROW_ON_ERROR)]);
        $order = DB::table('orders')->where('id', $orderId)->first();
        $order = $this->acceptance->accept($order, $snapshot, $commercial, null, $actor, 'AUTO_ACCEPTED');
        $this->notifier->vendor($order, 'Order '.$order->reference.' was auto-accepted', 'Auto-accept confirmed this Self-Pickup order and reserved its stock. Expected ready date: '.$readyDate.'.');
        $this->outbox->publish('ORDER_AUTO_ACCEPT_EVALUATED', 'ORDER', $orderId, ['order_id' => $orderId, 'accepted' => 'true']);

        return ['accepted' => true, 'reasons' => []];
    }

    /**
     * Records why the complete order goes to manual review. No stock, allotment or commercial version changes.
     *
     * @param  list<array{code: string, listing_variant_id: ?string}>  $reasons
     * @return array{accepted: bool, reasons: list<array{code: string, listing_variant_id: ?string}>}
     */
    private function routeToManual(string $orderId, array $reasons, OrderActor $actor, ?object $lockedOrder = null): array
    {
        $order = $lockedOrder ?? DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
        if ($order === null || $order->order_state !== OrderStates::AWAITING_VENDOR_CONFIRMATION || $order->confirmation_source !== null) {
            return ['accepted' => false, 'reasons' => $reasons];
        }
        $reasons = array_values(array_unique($reasons, SORT_REGULAR));
        DB::table('orders')->where('id', $orderId)->update(['auto_accept_outcome' => json_encode(['accepted' => false, 'routed_to' => 'MANUAL_REVIEW', 'reasons' => $reasons,
            'rule_version' => self::RULE_VERSION, 'evaluated_at' => now()->toIso8601String()], JSON_THROW_ON_ERROR), 'updated_at' => now()]);
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => $actor->role, 'action' => 'ORDER_AUTO_ACCEPT_ROUTED_TO_MANUAL_REVIEW',
            'resource_type' => 'ORDER', 'resource_id' => $orderId, 'vendor_organization_id' => $order->vendor_organization_id, 'before' => '{}',
            'after' => json_encode(['reasons' => array_column($reasons, 'code')], JSON_THROW_ON_ERROR), 'reason' => null, 'correlation_id' => $actor->correlationId, 'succeeded' => true,
            'created_at' => now(), 'updated_at' => now()]);
        $this->outbox->publish('ORDER_AUTO_ACCEPT_EVALUATED', 'ORDER', $orderId, ['order_id' => $orderId, 'accepted' => 'false', 'reasons' => implode(',', array_unique(array_column($reasons, 'code')))]);

        return ['accepted' => false, 'reasons' => $reasons];
    }
}
