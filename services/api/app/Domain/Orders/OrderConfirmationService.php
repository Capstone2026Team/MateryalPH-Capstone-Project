<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryLedgerWriter;
use App\Domain\Inventory\InventoryLocks;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Projects\ProjectInquiryService;
use App\Domain\Vendors\ConfirmedDeliverySnapshot;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Manual Vendor confirmation, permitted revision, manual NRPC and decline of an Item-Based child order.
 *
 * One PostgreSQL transaction locks the organization, the order, then every affected inventory and policy row
 * in ascending order; it revalidates the current store state (activation, restriction, public profile/media),
 * online payment capability, every line's listing and tax classification, stock, and — for Site Delivery — the
 * current vehicle and rate configuration through ConfirmedDeliverySnapshot. Every confirmed line is then
 * hard-reserved, or nothing is. A revision may lower quantities or add an order-level Vendor discount; it never
 * raises a price. NRPC is manual only, needs amount, reason, affected lines and the current NRPC Terms version,
 * and is never introduced after the Buyer accepted the order. Site Delivery always returns to the Buyer to
 * approve the confirmed drop-off, vehicles, trips and fee before payment.
 */
final class OrderConfirmationService
{
    public const BUYER_RESPONSE_HOURS = 24;

    public const DECLINE_REASONS = ['STOCK_UNAVAILABLE', 'OPERATIONAL_INABILITY', 'DELIVERY_INABILITY', 'COMPLIANCE_RESTRICTION', 'BUYER_AGREEMENT', 'OTHER'];

    public function __construct(
        private readonly OrderAccess $access,
        private readonly OrderCommercial $commercial,
        private readonly OrderEligibility $eligibility,
        private readonly OrderDeliveryPlanner $planner,
        private readonly OrderTransitionService $transitions,
        private readonly OrderAcceptance $acceptance,
        private readonly OrderNotifier $notifier,
        private readonly NrpcTerms $terms,
        private readonly InventoryLocks $locks,
        private readonly InventoryLedgerWriter $ledger,
        private readonly ConfirmedDeliverySnapshot $deliverySnapshots,
        private readonly OutboxPublisher $outbox,
        private readonly AuditRecorder $audit,
        private readonly CatalogAccess $idempotency,
    ) {}

    /**
     * Advisory vehicle options for the Vendor, using the confirmed quantities being considered.
     *
     * @param  array{lines?: list<array{order_line_id: string, confirmed_quantity: string}>}  $input
     * @return array<string, mixed>
     */
    public function deliveryPlan(Request $request, string $orderId, array $input): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CONFIRM, 'Order confirmation is not available to your role.');
        $order = $this->access->vendorOrder($scope, $orderId);
        if ($order->fulfillment_method !== 'DELIVERY' || $order->order_state !== OrderStates::AWAITING_VENDOR_CONFIRMATION) {
            throw new AuthenticationException('DELIVERY_PLAN_UNAVAILABLE', 'Delivery options are available only for a Site Delivery request awaiting your confirmation.', 409);
        }
        $lines = $this->commercial->lines((string) $order->id);
        $quantities = isset($input['lines']) ? $this->quantities($lines, $input['lines']) : [];
        $route = $this->planner->route($order);

        return $this->planner->advise($order, $this->planner->load($order, $lines, $quantities, $route, true, true), $route, $lines);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return string the order id
     */
    public function confirm(Request $request, string $orderId, array $input): string
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CONFIRM, 'Order confirmation is not available to your role.');
        $preview = $this->access->vendorOrder($scope, $orderId);
        $key = $this->idempotency->requireIdempotencyKey($request);
        $lines = $this->commercial->lines((string) $preview->id);
        $quantities = $this->quantities($lines, $input['lines']);
        $discount = (int) ($input['vendor_discount_centavos'] ?? 0);
        $changes = OrderCommercial::changes($lines, $quantities, $discount);
        $nrpcInput = $input['nrpc'] ?? null;
        if ($changes !== []) {
            $this->access->require($scope, OrderAccess::REVISE, 'Only the Owner, Store Manager or Store Staff can publish a revision that changes the amount payable.');
        }
        if ($nrpcInput !== null) {
            $this->access->require($scope, OrderAccess::SET_NRPC, 'Only the Owner, Store Manager or Store Staff can propose an NRPC.');
        }
        if ($preview->fulfillment_method === 'DELIVERY') {
            $this->access->require($scope, OrderAccess::CONFIRM_DELIVERY, 'Only the Owner or Store Manager can confirm the delivery vehicles, trips and fee.');
        }
        $terms = $nrpcInput === null ? null : $this->terms->current();
        if ($nrpcInput !== null && ($terms === null || $terms['content'] === null)) {
            throw new AuthenticationException('NRPC_TERMS_UNAVAILABLE', 'The current NRPC Terms are unavailable, so an NRPC cannot be proposed right now.', 503);
        }
        // Network lookups happen before any lock.
        $route = $preview->fulfillment_method === 'DELIVERY' ? $this->planner->route($preview) : null;
        $actor = OrderActor::vendor($request, $scope['role']);

        DB::transaction(function () use ($request, $scope, $orderId, $input, $key, $lines, $quantities, $discount, $changes, $nrpcInput, $terms, $route, $actor): void {
            $projectOrder = DB::table('orders')->where('id', $orderId)->first(['work_package_id']);
            if ($projectOrder->work_package_id !== null) {
                $projectId = DB::table('work_packages')->where('id', $projectOrder->work_package_id)->value('project_id');
                DB::table('projects')->where('id', $projectId)->lockForUpdate()->first();
                DB::table('work_packages')->where('id', $projectOrder->work_package_id)->lockForUpdate()->first();
            }
            $organization = DB::table('vendor_organizations')->where('id', $scope['organization_id'])->lockForUpdate()->first();
            if ($this->idempotency->replayed($request, 'ORDER_VENDOR_CONFIRM', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            $this->assertPending($order, (int) $input['lock_version']);
            if ($order->procurement_type === 'PROJECT_BASED' && ! DB::table('store_profiles')->where('vendor_organization_id', $order->vendor_organization_id)->where('bulk_capability', true)->exists()) {
                throw new AuthenticationException('PROJECT_VENDOR_INELIGIBLE', 'Bulk capability is required to confirm new Project-Based work. Accepted obligations are retained.', 409);
            }
            $blockers = $this->eligibility->storeBlockers($organization);
            if ($blockers !== []) {
                throw new AuthenticationException('STORE_NOT_ELIGIBLE', 'This store cannot accept new orders right now. Existing accepted orders are unaffected.', 409, ['blockers' => $blockers]);
            }
            if ($order->payment_method === 'ONLINE' && ! $this->eligibility->onlinePaymentReady((string) $order->vendor_organization_id)) {
                throw new AuthenticationException('PAYMENT_CAPABILITY_UNAVAILABLE', 'Online payment is not available for this store right now. Reconnect payments before confirming.', 409);
            }
            $confirmed = array_values(array_filter($lines, static fn (object $line): bool => bccomp($quantities[(string) $line->id], '0', 4) > 0));
            $lineBlockers = $this->eligibility->lineBlockers((string) $order->vendor_organization_id, array_combine(array_map(static fn (object $line): string => (string) $line->listing_variant_id, $confirmed), array_map(static fn (object $line): string => (string) $line->tax_category, $confirmed)));
            if ($lineBlockers !== []) {
                throw new AuthenticationException('LINE_NOT_ELIGIBLE', 'Some lines can no longer be sold as ordered. Set them to 0 to propose a revision, or decline the order.', 409,
                    ['lines' => array_map(static fn (object $line): array => ['order_line_id' => (string) $line->id, 'reason' => $lineBlockers[(string) $line->listing_variant_id]], array_values(array_filter($confirmed, static fn (object $line): bool => isset($lineBlockers[(string) $line->listing_variant_id]))))]);
            }
            $locked = $this->locks->lockForAcceptance(array_map(static fn (object $line): string => (string) $line->listing_variant_id, $confirmed));
            $short = [];
            foreach ($confirmed as $line) {
                $item = $locked['inventory'][(string) $line->listing_variant_id] ?? null;
                $available = $item === null ? '0.0000' : StockAvailability::availableToSell(StockAvailability::quantity($item->quantity_on_hand), StockAvailability::quantity($item->hard_reserved_quantity));
                if (bccomp($quantities[(string) $line->id], $available, 4) > 0) {
                    $short[] = ['order_line_id' => (string) $line->id, 'available_to_sell' => $available];
                }
            }
            if ($short !== []) {
                throw new AuthenticationException('STOCK_INSUFFICIENT', 'Available stock is lower than a confirmed quantity. Nothing was reserved; lower the quantity to propose a revision.', 409, ['lines' => $short]);
            }

            [$delivery, $deliverySummary, $fulfillmentDate] = $this->fulfillment($request, $order, $lines, $quantities, $input, $route);
            $nrpc = $nrpcInput === null ? null : ['amount_centavos' => (int) $nrpcInput['amount_centavos'], 'allocations' => $this->nrpcAllocations($nrpcInput['lines'])];
            $commercial = $this->commercial->compute($lines, $quantities, $discount, $delivery, $nrpc);
            foreach ($confirmed as $line) {
                $this->ledger->reserve($locked['inventory'][(string) $line->listing_variant_id], $quantities[(string) $line->id], $actor->userId, (string) $order->id, (string) $line->id);
            }
            $snapshot = $this->commercial->record($order, 'VENDOR_CONFIRMED', [
                'fulfillment_method' => (string) $order->fulfillment_method, 'payment_method' => (string) $order->payment_method, 'fulfillment_date' => $fulfillmentDate,
                'lines' => array_map(fn (object $line): array => ['order_line_id' => (string) $line->id, 'requested_quantity' => StockAvailability::quantity($line->quantity),
                    'confirmed_quantity' => $quantities[(string) $line->id]] + OrderCommercial::unitPriceFor($line, bccomp($quantities[(string) $line->id], '0', 4) > 0 ? $quantities[(string) $line->id] : StockAvailability::quantity($line->quantity)), $lines),
                'changes' => $changes, 'delivery' => $deliverySummary,
                'nrpc' => $nrpc === null ? null : ['amount_centavos' => $nrpc['amount_centavos'], 'reason' => trim((string) $nrpcInput['reason']), 'allocations' => $nrpc['allocations'], 'terms_version_id' => $terms['id']],
            ], $commercial, $actor);
            $nrpcRecordId = $nrpc === null ? null : $this->recordNrpc($order, $snapshot, $commercial, trim((string) $nrpcInput['reason']), (string) $terms['id'], $actor);
            if ($order->procurement_type === 'PROJECT_BASED' && $order->work_package_version_id !== null) {
                $supplied = array_map(static function (object $line) use ($quantities): array {
                    return ['quantity' => $quantities[(string) $line->id], 'unit_id' => $line->unit_id] + json_decode($line->snapshot, true);
                }, $lines);
                app(ProjectInquiryService::class)->acceptedMissing(DB::table('work_packages')->where('id', $order->work_package_id)->first(), $supplied);
            }
            DB::table('vendor_confirmations')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'actor_role' => $actor->role,
                'state' => $changes === [] ? 'CONFIRMED' : 'REVISED', 'source' => 'MANUAL', 'order_snapshot_version' => (int) $snapshot->version,
                'payload' => json_encode(['changes' => $changes, 'nrpc_record_id' => $nrpcRecordId, 'delivery_snapshot_id' => $deliverySummary['snapshot_id'] ?? null], JSON_THROW_ON_ERROR),
                'created_at' => now(), 'updated_at' => now()]);
            DB::table('orders')->where('id', $order->id)->update([
                'confirmation_source' => 'MANUAL', 'current_snapshot_version' => (int) $snapshot->version, 'expected_fulfillment_date' => $fulfillmentDate, 'vendor_response_due_at' => null,
                'materials_centavos' => $commercial['materials_payable_centavos'], 'vendor_discount_centavos' => $discount, 'delivery_centavos' => $commercial['delivery_centavos'],
                'nrpc_centavos' => $commercial['nrpc_centavos'], 'commercial_total_centavos' => $commercial['commercial_total_centavos'], 'updated_at' => now(),
            ]);
            $order = DB::table('orders')->where('id', $order->id)->first();
            $buyerDecision = $changes !== [] || $order->fulfillment_method === 'DELIVERY' || $order->procurement_type === 'PROJECT_BASED';
            if ($buyerDecision || $nrpc !== null) {
                $due = CarbonImmutable::now()->addHours(self::BUYER_RESPONSE_HOURS);
                $next = $buyerDecision ? OrderStates::AWAITING_BUYER_APPROVAL : OrderStates::AWAITING_NRPC_ACCEPTANCE;
                $order = $this->transitions->apply($order, [OrderStates::ORDER => $next], $actor, $changes !== [] ? 'VENDOR_REVISED' : 'VENDOR_CONFIRMED', null, ['buyer_response_due_at' => $due], (int) $snapshot->version);
                $this->notifier->buyer($order, 'Review order '.$order->reference,
                    ($next === OrderStates::AWAITING_BUYER_APPROVAL ? 'The Vendor confirmed your order with '.($changes !== [] ? 'changes' : 'the delivery arrangement').' for your approval.' : 'The Vendor proposed a Non-Recoverable Preparation Cost for your review.')
                    .' Respond by '.$due->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Philippine time) or the reserved stock is released.');
            } else {
                $order = $this->acceptance->accept($order, $snapshot, $commercial, null, $actor, 'VENDOR_CONFIRMED');
            }
            $this->outbox->publish('ORDER_VENDOR_CONFIRMED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'snapshot_version' => (int) $snapshot->version, 'revised' => $changes === [] ? 'false' : 'true']);
            if ($nrpcRecordId !== null) {
                $this->outbox->publish('NRPC_PROPOSED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'nrpc_record_id' => $nrpcRecordId]);
            }
            $this->audit->account($request, $changes === [] ? 'ORDER_CONFIRMED' : 'ORDER_REVISED', 'ORDER', (string) $order->id, after: ['snapshot_version' => (int) $snapshot->version,
                'changes' => count($changes), 'nrpc_centavos' => (int) $commercial['nrpc_centavos'], 'delivery_centavos' => $commercial['delivery_centavos'], 'order_state' => $order->order_state]);
            $this->idempotency->claim($request, 'ORDER_VENDOR_CONFIRM', $key, $orderId, 200);
        });

        return $orderId;
    }

    /** @param array{lock_version: int, reason_code: string, reason: string} $input */
    public function decline(Request $request, string $orderId, array $input): string
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CONFIRM, 'Declining an order is not available to your role.');
        $key = $this->idempotency->requireIdempotencyKey($request);
        $actor = OrderActor::vendor($request, $scope['role']);
        DB::transaction(function () use ($request, $scope, $orderId, $input, $key, $actor): void {
            $order = $this->access->vendorOrder($scope, $orderId, true);
            if ($this->idempotency->replayed($request, 'ORDER_VENDOR_DECLINE', $key, $orderId)) {
                return;
            }
            $this->assertPending($order, (int) $input['lock_version']);
            $reason = trim($input['reason']);
            DB::table('vendor_confirmations')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'actor_role' => $actor->role,
                'state' => 'DECLINED', 'source' => 'MANUAL', 'reason_code' => $input['reason_code'], 'reason' => $reason, 'order_snapshot_version' => (int) $order->current_snapshot_version,
                'created_at' => now(), 'updated_at' => now()]);
            // Nothing is reserved before confirmation, so a decline releases no stock.
            $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::DECLINED], $actor, 'VENDOR_'.$input['reason_code'], $reason, ['vendor_response_due_at' => null]);
            $this->notifier->buyer($order, 'Order '.$order->reference.' was declined', 'The Vendor could not fulfil this request. Reason: '.$reason.' You were not charged.');
            $this->audit->account($request, 'ORDER_DECLINED', 'ORDER', (string) $order->id, after: ['reason_code' => $input['reason_code']], reason: $reason);
            $this->idempotency->claim($request, 'ORDER_VENDOR_DECLINE', $key, $orderId, 200);
        });

        return $orderId;
    }

    private function assertPending(object $order, int $lockVersion): void
    {
        if ($order->order_state !== OrderStates::AWAITING_VENDOR_CONFIRMATION) {
            throw new AuthenticationException('ORDER_STATE_CONFLICT', 'This order is no longer awaiting your confirmation. Refresh to see its current state.', 409, ['current_state' => $order->order_state]);
        }
        if ((int) $order->lock_version !== $lockVersion) {
            throw new AuthenticationException('STALE_VERSION', 'This order changed since you opened it. Review the current request and confirm again.', 409, ['current_lock_version' => (int) $order->lock_version]);
        }
        if ($order->vendor_response_due_at !== null && CarbonImmutable::parse((string) $order->vendor_response_due_at)->lessThanOrEqualTo(now())) {
            throw new AuthenticationException('RESPONSE_WINDOW_CLOSED', 'The 24-hour response window for this request has ended.', 409);
        }
    }

    /**
     * Every line must be answered exactly once with 0 ≤ confirmed ≤ requested in the unit's precision, and at
     * least one line must remain.
     *
     * @param  list<object>  $lines
     * @param  list<array{order_line_id: string, confirmed_quantity: string|int}>  $answers
     * @return array<string, string>
     */
    private function quantities(array $lines, array $answers): array
    {
        $byId = [];
        foreach ($answers as $answer) {
            $byId[(string) $answer['order_line_id']] = is_int($answer['confirmed_quantity']) ? (string) $answer['confirmed_quantity'] : trim((string) $answer['confirmed_quantity']);
        }
        $errors = [];
        $quantities = [];
        foreach ($lines as $index => $line) {
            $value = $byId[(string) $line->id] ?? null;
            unset($byId[(string) $line->id]);
            $snapshot = json_decode((string) $line->snapshot, true);
            $precision = is_array($snapshot) ? (int) ($snapshot['unit_precision'] ?? 4) : 4;
            if ($value === null || preg_match('/^\d{1,7}(\.\d{1,4})?$/', $value) !== 1) {
                $errors['lines.'.$index.'.confirmed_quantity'][] = 'Enter a confirmed quantity of zero or more.';

                continue;
            }
            $quantity = StockAvailability::quantity($value);
            if (bccomp($quantity, StockAvailability::quantity($line->quantity), 4) > 0) {
                $errors['lines.'.$index.'.confirmed_quantity'][] = 'A confirmed quantity cannot exceed the requested quantity.';
            } elseif (bccomp($quantity, bcadd($quantity, '0', max(0, min(4, $precision))), 4) !== 0) {
                $errors['lines.'.$index.'.confirmed_quantity'][] = $precision <= 0 ? 'This item is sold in whole units.' : 'Use at most '.$precision.' decimal places.';
            }
            $quantities[(string) $line->id] = $quantity;
        }
        if ($byId !== []) {
            $errors['lines'][] = 'Answer only this order\'s lines.';
        }
        if ($errors === [] && array_filter($quantities, static fn (string $quantity): bool => bccomp($quantity, '0', 4) > 0) === []) {
            $errors['lines'][] = 'At least one line must keep a quantity. To confirm nothing, decline the order instead.';
        }
        if ($errors !== []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, $errors);
        }

        return $quantities;
    }

    /**
     * @param  list<object>  $lines
     * @param  array<string, string>  $quantities
     * @param  array<string, mixed>  $input
     * @param  array<string, mixed>|null  $route
     * @return array{0: int, 1: array<string, mixed>, 2: string}
     */
    private function fulfillment(Request $request, object $order, array $lines, array $quantities, array $input, ?array $route): array
    {
        $today = CarbonImmutable::now('Asia/Manila')->toDateString();
        if ($order->fulfillment_method === 'PICKUP') {
            $date = (string) ($input['pickup']['ready_date'] ?? '');
            if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date) !== 1 || $date < $today) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['pickup.ready_date' => ['Choose a ready-for-pickup date from today onward.']]);
            }

            return [0, ['type' => 'PICKUP', 'ready_date' => $date], $date];
        }
        $delivery = $input['delivery'] ?? null;
        if (! is_array($delivery)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['delivery' => ['Confirm the vehicles, trips, date and final delivery fee.']]);
        }
        if (! ($delivery['access_confirmed'] ?? false)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['delivery.access_confirmed' => ['Confirm that the drop-off is accessible for the chosen vehicles.']]);
        }
        $load = $this->planner->load($order, $lines, $quantities, (array) $route, true, (bool) ($delivery['heavy_vehicle_access_confirmed'] ?? false));
        $snapshotId = $this->deliverySnapshots->record($request->user(), (string) $order->id, $load, $delivery['vehicles'], (int) $delivery['final_fee_centavos'], (string) $delivery['arrangement'],
            (string) $delivery['fulfillment_date'], isset($delivery['manual_review_note']) ? (string) $delivery['manual_review_note'] : null);

        return [(int) $delivery['final_fee_centavos'], ['type' => 'DELIVERY', 'snapshot_id' => $snapshotId, 'final_fee_centavos' => (int) $delivery['final_fee_centavos'], 'fulfillment_date' => (string) $delivery['fulfillment_date']], (string) $delivery['fulfillment_date']];
    }

    /**
     * @param  list<array{order_line_id: string, principal_centavos: int}>  $lines
     * @return array<string, int>
     */
    private function nrpcAllocations(array $lines): array
    {
        $allocations = [];
        foreach ($lines as $line) {
            $allocations[(string) $line['order_line_id']] = ($allocations[(string) $line['order_line_id']] ?? 0) + (int) $line['principal_centavos'];
        }

        return $allocations;
    }

    /** @param array<string, mixed> $commercial */
    private function recordNrpc(object $order, object $snapshot, array $commercial, string $reason, string $termsVersionId, OrderActor $actor): string
    {
        $id = (string) Str::uuid7();
        DB::table('nrpc_records')->insert(['id' => $id, 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'actor_role' => $actor->role, 'state' => 'PROPOSED', 'reason' => $reason,
            'amount_centavos' => (int) $commercial['nrpc_centavos'], 'eligible_subtotal_centavos' => (int) $commercial['nrpc_eligible_subtotal_centavos'], 'agreement_version_id' => $termsVersionId,
            'order_snapshot_version' => (int) $snapshot->version, 'payload' => json_encode(['calculation_version' => $commercial['calculation_version']], JSON_THROW_ON_ERROR),
            'created_at' => now(), 'updated_at' => now()]);
        foreach ($commercial['lines'] as $line) {
            if ($line['nrpc_principal_centavos'] > 0) {
                DB::table('nrpc_line_allocations')->insert(['id' => (string) Str::uuid7(), 'nrpc_record_id' => $id, 'order_line_id' => $line['line_id'], 'principal_centavos' => $line['nrpc_principal_centavos'],
                    'line_payable_centavos' => $line['payable_centavos'], 'vat_centavos' => $line['nrpc_vat_centavos'], 'created_at' => now()]);
            }
        }

        return $id;
    }
}
