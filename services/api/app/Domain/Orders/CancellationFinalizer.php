<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Fulfillment\FulfillmentRecords;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Payments\RefundService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Makes one cancellation final, atomically, inside the caller's transaction with the order row locked (FIN-07):
 *
 *   1. one final decision per order (unique), with cause, decider, reason, retained NRPC and evidence
 *   2. open payment attempts closed; hard reservations released; the ESTIMATED commission cancelled (no fee)
 *   3. an uncollected physical balance released as No longer due; collected cash → VENDOR_REIMBURSEMENT_PENDING
 *   4. exactly one CANCELLATION refund instruction per original online payment (REFUND_PENDING), each capped by its
 *      capture less successful and in-flight refunds, its line/VAT allocation from the original snapshot, and its
 *      provider request queued for immediately after commit
 *   5. an ADJUSTMENT_REQUIRED tax review for every posted remittance assessment of a refunded or retained payment;
 *      posted CWT is never recovered automatically and FIN-04A status is never reset
 *   6. the NFR event for a Vendor cancellation of a confirmed order
 *   7. CANCELLED through the shared state machine, the fulfillment thread read-only, notices and audit
 *
 * A retry finds the existing decision and changes nothing. Filing nothing here ever opens a dispute.
 */
final class CancellationFinalizer
{
    public function __construct(
        private readonly OrderTransitionService $transitions,
        private readonly OrderRelease $release,
        private readonly CancellationRefundPlanner $planner,
        private readonly RefundService $refunds,
        private readonly RemittanceAssessmentService $assessments,
        private readonly FulfillmentRecords $records,
        private readonly FulfillmentThreadService $threads,
        private readonly OrderNotifier $notifier,
        private readonly OutboxPublisher $outbox,
    ) {}

    /**
     * @param  array{cause: string, decided_by: string, decision_code: string, reason_code: ?string, reason: ?string, request_id: ?string, retain_nrpc: bool, evidence_file_id: ?string}  $ctx
     */
    public function finalize(object $order, OrderActor $actor, array $ctx): object
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('A cancellation is finalized only inside the order transaction.');
        }
        $existing = DB::table('cancellation_decisions')->where('order_id', $order->id)->first();
        if ($existing !== null) {
            return $existing;
        }
        $before = (string) $order->order_state;
        $plan = $this->planner->plan($order, $ctx['cause'], $ctx['retain_nrpc']);
        $decisionId = (string) Str::uuid7();
        DB::table('cancellation_decisions')->insert([
            'id' => $decisionId, 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'state' => 'APPROVED', 'reason' => $ctx['reason'] === null ? null : mb_substr($ctx['reason'], 0, 2000),
            'payload' => json_encode(['retained_centavos' => $plan['nrpc_retained_centavos'], 'plan' => $plan], JSON_THROW_ON_ERROR), 'cancellation_request_id' => $ctx['request_id'],
            'cause' => $ctx['cause'], 'decided_by' => $ctx['decided_by'], 'decision_code' => $ctx['decision_code'], 'actor_role' => $actor->role, 'reason_code' => $ctx['reason_code'],
            'order_state_before' => $before, 'nrpc_retained_centavos' => $plan['nrpc_retained_centavos'], 'evidence_file_id' => $ctx['evidence_file_id'],
            'refund_total_centavos' => $plan['online_refund_total_centavos'], 'cash_reimbursement_centavos' => $plan['cash_reimbursement_centavos'],
            'released_unpaid_centavos' => $plan['released_unpaid_centavos'], 'correlation_id' => mb_substr($actor->correlationId, 0, 64), 'created_at' => now(), 'updated_at' => now(),
        ]);
        $reasonCode = $ctx['cause'] === 'VENDOR' ? 'VENDOR_CANCELLATION' : ($before === OrderStates::AWAITING_VENDOR_CONFIRMATION ? 'BUYER_WITHDRAWAL' : 'BUYER_CANCELLATION');
        $this->release->closeOpenAttempts((string) $order->id, $actor, 'ORDER_CANCELLED');
        $this->release->release($order, OrderStates::CANCELLED, $reasonCode, $actor);
        $this->physical($order, $decisionId, $plan);
        $refundIds = $this->createRefunds($order, $decisionId, $plan, $actor);
        $this->taxReview($order, $plan, $refundIds);
        if ($ctx['cause'] === 'VENDOR' && ! in_array($before, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT], true)) {
            DB::table('nfr_events')->insertOrIgnore(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id,
                'cancellation_decision_id' => $decisionId, 'reason_code' => (string) $ctx['reason_code'], 'order_state_before' => $before, 'environment' => 'TEST', 'occurred_at' => now(), 'created_at' => now()]);
        }
        $changes = [OrderStates::ORDER => OrderStates::CANCELLED] + ($order->payment_state === 'PENDING' ? [OrderStates::PAYMENT => 'NOT_REQUIRED'] : []);
        $order = $this->transitions->apply($order, $changes, $actor, $reasonCode, $ctx['reason'], ['vendor_response_due_at' => null, 'buyer_response_due_at' => null, 'payment_expires_at' => null]);
        $order = $this->refunds->syncOrder($order, $actor, 'CANCELLATION');
        $fulfillment = $this->records->ensure($order);
        foreach (DB::table('fulfillment_issues')->where('order_id', $order->id)->where('state', 'OPEN')->get() as $issue) {
            DB::table('fulfillment_issues')->where('id', $issue->id)->update(['state' => 'RESOLVED', 'resolution' => 'ORDER_CANCELLED', 'resolved_at' => now(), 'updated_at' => now()]);
        }
        $this->records->update($fulfillment, ['state' => 'CANCELLED', 'auto_confirm_due_at' => null, 'auto_confirm_paused_at' => null, 'auto_confirm_remaining_seconds' => null]);
        $this->records->event($fulfillment, 'CANCELLED', $actor, ['decision_id' => $decisionId, 'cause' => $ctx['cause']], 'CANCELLED');
        // Notify while the assignment is still current, then end staff access and make the thread read-only.
        $this->notify($order, $ctx, $plan);
        $this->threads->close($order, $actor->userId, OrderStates::CANCELLED);
        $this->outbox->publish('ORDER_CANCELLED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'decision_id' => $decisionId, 'cause' => $ctx['cause']]);

        return DB::table('cancellation_decisions')->where('id', $decisionId)->first();
    }

    /** @param array<string, mixed> $plan */
    private function physical(object $order, string $decisionId, array $plan): void
    {
        if ($order->payment_method === 'ONLINE') {
            return;
        }
        if ($plan['released_unpaid_centavos'] > 0) {
            // An uncollected balance is closed as No longer due; nothing is refunded for money never collected.
            DB::table('physical_payment_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'recorded_by_user_id' => null, 'record_kind' => 'CANCELLATION_RELEASE',
                'method' => (string) $order->payment_method, 'obligation_before_centavos' => $plan['released_unpaid_centavos'], 'amount_centavos' => 0, 'remaining_obligation_centavos' => $plan['released_unpaid_centavos'],
                'state' => 'CANCELLED_UNPAID', 'idempotency_key' => 'cancellation-release:'.$order->id, 'recorded_at' => now(), 'recorded_role' => 'SYSTEM',
                'note' => 'Released when the order was cancelled: no longer due.', 'created_at' => now(), 'updated_at' => now()]);
        }
        if ($plan['cash_reimbursement_centavos'] > 0) {
            $collection = DB::table('physical_payment_records')->where('order_id', $order->id)->whereIn('record_kind', ['COLLECTION', 'CORRECTION'])->where('amount_centavos', '>', 0)
                ->orderByDesc('recorded_at')->orderByDesc('id')->value('id');
            DB::table('physical_reimbursements')->insert(['id' => (string) Str::uuid7(), 'refund_id' => null, 'physical_payment_record_id' => $collection, 'recorded_by_user_id' => null,
                'amount_centavos' => $plan['cash_reimbursement_centavos'], 'method' => (string) $order->payment_method, 'state' => 'VENDOR_REIMBURSEMENT_PENDING', 'order_id' => $order->id,
                'cancellation_decision_id' => $decisionId, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /**
     * @param  array<string, mixed>  $plan
     * @return array<string, string> payment id => refund id
     */
    private function createRefunds(object $order, string $decisionId, array $plan, OrderActor $actor): array
    {
        $created = [];
        $snapshotId = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->value('id');
        foreach ($plan['online'] as $item) {
            $payment = DB::table('payments')->where('id', $item['payment_id'])->lockForUpdate()->first();
            $balance = $this->refunds->refundableBalance($payment);
            $amount = min((int) $item['refund_centavos'], $balance);
            if ($amount <= 0) {
                continue;
            }
            $fee = min((int) $item['processing_fee_centavos'], $amount);
            $refundId = (string) Str::uuid7();
            $inserted = DB::table('refunds')->insertOrIgnore(['id' => $refundId, 'target_type' => 'ORDER', 'order_id' => $order->id, 'source_payment_id' => $payment->id, 'trigger' => 'CANCELLATION',
                'amount_centavos' => $amount, 'principal_centavos' => $amount - $fee, 'processing_fee_centavos' => $fee, 'source_captured_centavos' => (int) $payment->total_centavos,
                'prior_allocated_centavos' => (int) $payment->total_centavos - $balance, 'state' => 'REFUND_PENDING', 'idempotency_key' => 'cancellation:'.$payment->id,
                'environment' => 'TEST', 'evidence_origin' => $payment->evidence_origin, 'reason_code' => 'CANCELLATION_'.$plan['cause'], 'requested_at' => now(),
                'cancellation_decision_id' => $decisionId, 'allocation' => json_encode($item['allocation'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted === 0) {
                continue;
            }
            $this->refunds->event((object) ['id' => $refundId, 'attempt_number' => 1, 'state' => null], 'REFUND_PENDING', 'SYSTEM', null, $actor->correlationId);
            if ($snapshotId !== null) {
                $this->allocate((string) $snapshotId, $refundId, $item['allocation']);
            }
            $this->refunds->queue($refundId, $actor->correlationId);
            $created[(string) $payment->id] = $refundId;
        }

        return $created;
    }

    /**
     * Records the refund's consumption of the original line allocations so later refunds cannot reuse them.
     *
     * @param  array<string, mixed>  $allocation
     */
    private function allocate(string $snapshotId, string $refundId, array $allocation): void
    {
        foreach ($allocation['lines'] ?? [] as $line) {
            if ((int) $line['payable_centavos'] <= 0) {
                continue;
            }
            DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshotId)->where('order_line_id', $line['order_line_id'])
                ->update(['refund_allocated_centavos' => DB::raw('refund_allocated_centavos + '.(int) $line['payable_centavos']), 'updated_at' => now()]);
            DB::table('financial_allocations')->insert(['id' => (string) Str::uuid7(), 'financial_snapshot_id' => $snapshotId, 'allocation_type' => 'REFUND_LINE', 'source_type' => 'REFUND', 'source_id' => $refundId,
                'target_type' => 'ORDER_LINE', 'target_id' => $line['order_line_id'], 'amount_centavos' => (int) $line['payable_centavos'],
                'basis' => json_encode(['vat_centavos' => (int) $line['vat_centavos'], 'discount_centavos' => (int) $line['discount_centavos'], 'retained_nrpc_centavos' => (int) $line['retained_nrpc_centavos']], JSON_THROW_ON_ERROR),
                'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /**
     * @param  array<string, mixed>  $plan
     * @param  array<string, string>  $refundIds
     */
    private function taxReview(object $order, array $plan, array $refundIds): void
    {
        foreach ($plan['online'] as $item) {
            foreach (DB::table('remittance_assessments')->where('payment_id', $item['payment_id'])->where('calculation_state', 'POSTED')->pluck('id') as $assessmentId) {
                $this->assessments->openAdjustmentForRefund((string) $assessmentId, $refundIds[$item['payment_id']] ?? null, (int) $item['refund_centavos'],
                    'Order '.$order->reference.' was cancelled after this collection was assessed. Review the posted withholding; refund success never recovers tax from the BIR automatically'
                    .((int) $item['retained_centavos'] > 0 ? ', and the retained NRPC keeps its original tax record for review.' : '.'));
            }
        }
    }

    /**
     * @param  array{cause: string, decided_by: string, decision_code: string}  $ctx
     * @param  array<string, mixed>  $plan
     */
    private function notify(object $order, array $ctx, array $plan): void
    {
        $peso = static fn (int $centavos): string => '₱'.WithholdingThresholdService::pesos($centavos);
        $parts = [];
        if ($plan['online_refund_total_centavos'] > 0) {
            $parts[] = 'A refund of '.$peso((int) $plan['online_refund_total_centavos']).' to your original payment method was initiated. We confirm it only after the payment provider processes it.';
        }
        if ($plan['nrpc_retained_centavos'] > 0) {
            $parts[] = 'The Vendor substantiated preparation and retains the accepted NRPC of '.$peso((int) $plan['nrpc_retained_centavos']).'.';
        }
        if ($plan['cash_reimbursement_centavos'] > 0) {
            $parts[] = 'The '.$peso((int) $plan['cash_reimbursement_centavos']).' you paid the Vendor directly will be reimbursed by the Vendor; confirm it on the order when you receive it.';
        }
        if ($plan['released_unpaid_centavos'] > 0) {
            $parts[] = $peso((int) $plan['released_unpaid_centavos']).' you had not paid is no longer due.';
        }
        $buyerBody = ($ctx['cause'] === 'VENDOR' ? 'The Vendor cancelled this order. ' : 'Your order was cancelled. ').implode(' ', $parts ?: ['Nothing was charged.']);
        $this->notifier->buyer($order, 'Order '.$order->reference.' cancelled', $buyerBody);
        $this->notifier->vendor($order, 'Order '.$order->reference.' cancelled', ($ctx['cause'] === 'VENDOR'
            ? 'You cancelled this order. Every Buyer-paid amount is refunded, any NRPC is forfeited, the reserved stock was released and the cancellation counts toward your Non-Fulfillment Rate.'
            : 'The Buyer\'s cancellation is final. The reserved stock was released.').($plan['cash_reimbursement_centavos'] > 0 ? ' Reimburse the cash collected and record the evidence on the order.' : ''), ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
        $this->notifier->assignee($order, 'Order '.$order->reference.' cancelled', 'This order was cancelled. Stop preparation; its fulfillment messages are now read-only.');
    }
}
