<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Fulfillment\FulfillmentRecords;
use App\Domain\Fulfillment\ReceiptService;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderRelease;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Order-side effects of a case, inside the caller's transaction with the order row locked (order before case):
 *
 *   filing       the DISPUTE family opens; the order itself becomes DISPUTED only while it awaits receipt, which
 *                pauses the 48-hour auto-confirmation (a pre-handover case leaves fulfillment running; a completed
 *                order stays COMPLETED); the commission assessment gets a dispute hold without changing its state
 *   handover     a DELIVERED/PICKED_UP milestone recorded during an active case moves the order to DISPUTED
 *   case state   the order's DISPUTE family mirrors the case through the shared state machine
 *   conclusion   the hold is released; a DISPUTED order completes (commission earned, then any fee-credit review)
 *   full award   before handover the order is cancelled: reservation released, the estimated commission cancelled
 *
 * Order states changed here were approved by the project owner on 2026-10-04.
 */
final class DisputeOrderSync
{
    public function __construct(
        private readonly OrderTransitionService $transitions,
        private readonly FulfillmentRecords $records,
        private readonly OrderRelease $release,
        private readonly FulfillmentThreadService $threads,
    ) {}

    public function opened(object $order, object $case, OrderActor $actor): object
    {
        $changes = [OrderStates::DISPUTE => DisputeRules::OPEN_AWAITING_RESPONSE];
        if (in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true)) {
            $changes[OrderStates::ORDER] = 'DISPUTED';
        }
        $order = $this->transitions->apply($order, $changes, $actor, 'DISPUTE_FILED', 'Case '.$case->reference);
        if ($order->order_state === 'DISPUTED') {
            $this->pauseReceipt($order, $actor, (string) $case->id);
        }
        DB::table('fee_assessments')->where('order_id', $order->id)->where('dispute_hold', false)->update(['dispute_hold' => true, 'dispute_hold_at' => now(), 'updated_at' => now()]);

        return $order;
    }

    /** Called by the fulfillment service right after a handover proof is recorded. */
    public function afterHandover(object $order, OrderActor $actor): object
    {
        if (! in_array($order->dispute_state, DisputeRules::ACTIVE, true) || ! in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true)) {
            return $order;
        }
        $order = $this->transitions->apply($order, [OrderStates::ORDER => 'DISPUTED'], $actor, 'DISPUTE_ACTIVE_AT_HANDOVER');
        $this->pauseReceipt($order, $actor, (string) DB::table('dispute_cases')->where('order_id', $order->id)->whereIn('status', DisputeRules::ACTIVE)->value('id'));

        return $order;
    }

    public function mirror(object $order, string $caseState, OrderActor $actor, string $reasonCode): object
    {
        if ($order->dispute_state === $caseState) {
            return $order;
        }

        return $this->transitions->apply($order, [OrderStates::DISPUTE => $caseState], $actor, $reasonCode);
    }

    public function concluded(object $order, object $case, string $finalState, OrderActor $actor): object
    {
        $order = $this->mirror($order, $finalState, $actor, $finalState === DisputeRules::RESOLVED ? 'DISPUTE_RESOLVED' : 'DISPUTE_CLOSED_INCONCLUSIVE');
        DB::table('fee_assessments')->where('order_id', $order->id)->where('dispute_hold', true)->update(['dispute_hold' => false, 'dispute_hold_at' => null, 'updated_at' => now()]);
        if ($order->order_state === 'DISPUTED') {
            $fulfillment = $this->records->ensure($order);
            $order = app(ReceiptService::class)->complete($order, $fulfillment, $actor, 'DISPUTE_CONCLUSION');
        }

        return $order;
    }

    /** A full award before handover ends the order: no goods change hands and no commission is earned. */
    public function cancelBeforeHandover(object $order, object $case, OrderActor $actor): object
    {
        if (! in_array($order->order_state, [OrderStates::CONFIRMED, OrderStates::PROCESSING, ...OrderStates::HANDOVER_STAGE], true)) {
            return $order;
        }
        $this->release->closeOpenAttempts((string) $order->id, $actor, 'DISPUTE_FULL_REFUND');
        $this->release->release($order, OrderStates::CANCELLED, 'DISPUTE_FULL_REFUND', $actor);
        $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::CANCELLED], $actor, 'DISPUTE_FULL_REFUND', 'Case '.$case->reference.' awarded a full refund before handover.');
        $fulfillment = $this->records->ensure($order);
        $this->records->update($fulfillment, ['state' => 'CANCELLED', 'auto_confirm_due_at' => null, 'auto_confirm_paused_at' => null, 'auto_confirm_remaining_seconds' => null]);
        $this->records->event($fulfillment, 'CANCELLED', $actor, ['dispute_case_id' => (string) $case->id], 'CANCELLED');
        $this->threads->close($order, $actor->userId, OrderStates::CANCELLED);

        return $order;
    }

    private function pauseReceipt(object $order, OrderActor $actor, string $caseId): void
    {
        $fulfillment = $this->records->ensure($order);
        if ($fulfillment->auto_confirm_due_at === null) {
            return;
        }
        $remaining = max(0, (int) CarbonImmutable::now()->diffInSeconds(CarbonImmutable::parse((string) $fulfillment->auto_confirm_due_at), false));
        $this->records->update($fulfillment, ['auto_confirm_due_at' => null, 'auto_confirm_paused_at' => now(), 'auto_confirm_remaining_seconds' => $remaining]);
        $this->records->event($fulfillment, 'AUTO_CONFIRM_PAUSED', $actor, ['dispute_case_id' => $caseId, 'remaining_seconds' => $remaining]);
    }
}
