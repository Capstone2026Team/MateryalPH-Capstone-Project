<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Inventory\AutoAcceptPolicyService;
use App\Domain\Inventory\InventoryLedgerWriter;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Releases an order's hard reservations when it is rejected, expires or is cancelled, inside the caller's
 * transaction with the order row locked (order → inventory ascending → policies ascending). Allotment consumed
 * by auto-accept is returned in whole units, capped at the policy's configured allotment; a pause is never
 * cleared. An ESTIMATED fee assessment is cancelled because no completed sale exists.
 */
final class OrderRelease
{
    public function __construct(
        private readonly InventoryLedgerWriter $ledger,
        private readonly AutoAcceptPolicyService $policies,
        private readonly FeeAssessmentService $fees,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** @return array<string, string> released quantity per listing variant */
    public function release(object $order, string $closingState, string $reasonCode, OrderActor $actor): array
    {
        $released = $this->ledger->releaseOrder((string) $order->id, $reasonCode, $actor->userId);
        if ($released !== [] && $order->confirmation_source === 'AUTO_ACCEPT') {
            foreach (DB::table('auto_accept_policies')->whereIn('listing_variant_id', array_keys($released))->orderBy('id')->lockForUpdate()->get() as $policy) {
                $room = bcsub(bcadd((string) $policy->allotment_quantity, '0', 0), bcadd((string) $policy->remaining_allotment_quantity, '0', 0), 0);
                $restore = bccomp(bcadd($released[(string) $policy->listing_variant_id], '0', 0), $room, 0) < 0 ? bcadd($released[(string) $policy->listing_variant_id], '0', 0) : $room;
                if (bccomp($restore, '0', 0) > 0) {
                    $this->policies->restore($policy, $restore);
                }
            }
        }
        $this->fees->cancelForClosedOrder($order, $closingState, $actor->correlationId);
        if ($released !== []) {
            $this->outbox->publish('INVENTORY_RESERVATION_RELEASED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'reason_code' => $reasonCode, 'lines' => count($released)]);
        }

        return $released;
    }

    /**
     * Closes every open payment attempt of a closing order. The provider session is cancelled after commit; a capture
     * that still arrives later is compensated by a technical refund, never applied to the closed order.
     */
    public function closeOpenAttempts(string $orderId, OrderActor $actor, string $reason): int
    {
        $attempts = DB::table('payments')->where('order_id', $orderId)->whereIn('state', ['CREATING', 'PENDING', 'UNCERTAIN'])->orderBy('id')->lockForUpdate()->get();
        foreach ($attempts as $payment) {
            DB::table('payments')->where('id', $payment->id)->update(['state' => 'EXPIRED', 'expired_at' => now(), 'reconciliation_state' => $payment->provider_session_id === null ? 'PENDING' : 'RECONCILED',
                'lock_version' => (int) $payment->lock_version + 1, 'updated_at' => now()]);
            DB::table('payment_events')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $payment->id, 'state' => 'EXPIRED', 'from_state' => $payment->state, 'source' => 'SYSTEM',
                'correlation_id' => $actor->correlationId, 'safe_payload' => json_encode(['reason' => $reason], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('PAYMENT_SESSION_CANCEL_REQUESTED', 'PAYMENT', (string) $payment->id, ['payment_id' => (string) $payment->id]);
        }

        return $attempts->count();
    }
}
