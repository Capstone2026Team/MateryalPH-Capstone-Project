<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderStates;
use App\Domain\Payments\RefundService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Executes an enforceable decision and tracks its remedies until each reaches a terminal state (FIN-07):
 *
 *   money award      exactly one DISPUTE_CONCLUSION refund instruction per decision version and original online
 *                    payment (unique index), REFUND_PENDING with its provider request queued after commit; any
 *                    cash portion is a separate VENDOR_REIMBURSEMENT_PENDING record; the affected lines' original
 *                    VAT and discount allocations are consumed once; posted withholding opens a tax review and a
 *                    filed return is never amended automatically; the commission gets a reviewed credit proposal
 *   replacement      a REPLACEMENT remedy the Vendor fulfils and the Buyer (or a reasoned Admin review) confirms
 *   full award       before handover the order is cancelled instead of completed
 *   sanctions        a warning and a confirmed metric event take effect; restriction, suspension and ban are
 *                    recorded and referred to User Management Staff (approved by the project owner on 2026-10-04)
 *
 * The case is not RESOLVED until every required refund, reimbursement and replacement is complete and no appeal can
 * still be filed. The Admin never holds, redirects or disburses money; refunds return only to the original method.
 */
final class DisputeRemedyService
{
    /** Remedies that must be complete before the case can resolve; a fee-credit review never blocks the Buyer. */
    public const BLOCKING = ['ONLINE_REFUND', 'CASH_REIMBURSEMENT', 'REPLACEMENT'];

    public function __construct(
        private readonly DisputeRefundPlanner $planner,
        private readonly RefundService $refunds,
        private readonly RemittanceAssessmentService $assessments,
        private readonly DisputeFeeCredits $feeCredits,
        private readonly DisputeOrderSync $orders,
        private readonly DisputeTimeline $timeline,
        private readonly DisputeNotifier $notifier,
    ) {}

    /**
     * Applies the decision's remedies once. The caller holds the order and case row locks.
     *
     * @return array{order: object, case: object}
     */
    public function execute(object $order, object $case, object $decision, OrderActor $actor): array
    {
        if (DB::table('dispute_events')->where('dispute_case_id', $case->id)->where('event_type', 'DECISION_ENFORCEABLE')->whereRaw("payload->>'decision_id' = ?", [(string) $decision->id])->exists()) {
            // Already carried out: only the conclusion may still be pending (for example the appeal window lapsed).
            return $this->evaluate($order, $case, $actor);
        }
        $this->timeline->append($case, 'DECISION_ENFORCEABLE', $actor, $actor->source === 'SYSTEM' && $actor->userId === null ? 'SYSTEM' : self::party($actor),
            $decision->kind === 'MUTUAL_AGREEMENT' ? 'The agreement is final and its remedy is now being carried out.' : 'The decision is final and its remedy is now being carried out.',
            ['decision_id' => (string) $decision->id, 'version' => (int) $decision->version, 'outcome' => (string) $decision->outcome]);
        $outcome = (string) $decision->outcome;
        if (in_array($outcome, DisputeRules::MONEY_OUTCOMES, true)) {
            $order = $this->award($order, $case, $decision, $actor);
        } elseif ($outcome === 'REPLACEMENT') {
            $this->remedy($case, $decision, 'REPLACEMENT', 0, 'replacement:'.$decision->id, $actor, ['note' => 'The Vendor provides the replacement; the Buyer confirms receipt.']);
            $this->notifier->vendor($case, 'Replacement required — case '.$case->reference, 'Provide the replacement for this case and record it on the case. The Buyer confirms receipt before the case resolves.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
        }
        $this->sanctions($case, $decision, $actor);
        $case = DB::table('dispute_cases')->where('id', $case->id)->first();
        $case = $this->refreshRemedyState($case);

        return $this->evaluate($order, $case, $actor);
    }

    /**
     * Resolves the case when every blocking remedy is complete and no appeal can still be filed. The caller holds the
     * order and case row locks.
     *
     * @return array{order: object, case: object}
     */
    public function evaluate(object $order, object $case, OrderActor $actor): array
    {
        if (! in_array($case->status, [DisputeRules::DECIDED, DisputeRules::MUTUAL_RESOLUTION], true) || $case->current_decision_id === null) {
            return ['order' => $order, 'case' => $case];
        }
        $decision = DB::table('dispute_decisions')->where('id', $case->current_decision_id)->first();
        $executed = DB::table('dispute_events')->where('dispute_case_id', $case->id)->where('event_type', 'DECISION_ENFORCEABLE')->whereRaw("payload->>'decision_id' = ?", [(string) $decision->id])->exists();
        if (! $executed || $case->remedy_state === 'PENDING' || $case->remedy_state === 'FAILED') {
            return ['order' => $order, 'case' => $case];
        }
        $appealClosed = $decision->kind !== 'ADMIN_DECISION' || DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->exists()
            || ($case->appeal_due_at !== null && CarbonImmutable::parse((string) $case->appeal_due_at)->lessThanOrEqualTo(CarbonImmutable::now()));
        if (! $appealClosed) {
            return ['order' => $order, 'case' => $case];
        }
        $final = $decision->outcome === 'INCONCLUSIVE' ? DisputeRules::CLOSED_INCONCLUSIVE : DisputeRules::RESOLVED;
        DB::table('dispute_cases')->where('id', $case->id)->update(['status' => $final, 'concluded_at' => now(), 'mutual_resolution_due_at' => null, 'clarification_due_at' => null,
            'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
        $case = DB::table('dispute_cases')->where('id', $case->id)->first();
        $order = $this->orders->concluded($order, $case, $final, $actor);
        $this->timeline->append($case, $final === DisputeRules::RESOLVED ? 'CASE_RESOLVED' : 'CASE_CLOSED_INCONCLUSIVE', $actor, $actor->userId === null ? 'SYSTEM' : self::party($actor),
            $final === DisputeRules::RESOLVED ? 'The decision and every required remedy are complete.' : 'The evidence was insufficient for a fault determination. The case is closed with monitoring.');
        $message = $final === DisputeRules::RESOLVED ? 'Case '.$case->reference.' is resolved: the decision and its remedy are complete.' : 'Case '.$case->reference.' closed as inconclusive.';
        $this->notifier->buyer($case, 'Case '.$case->reference.' concluded', $message);
        $this->notifier->vendor($case, 'Case '.$case->reference.' concluded', $message);

        return ['order' => $order, 'case' => DB::table('dispute_cases')->where('id', $case->id)->first()];
    }

    /** Provider progress of a DISPUTE_CONCLUSION refund, inside the refund transaction that holds the order lock. */
    public function refundChanged(object $order, object $refund, OrderActor $actor): object
    {
        if ($refund->dispute_case_id === null) {
            return $order;
        }
        $case = DB::table('dispute_cases')->where('id', $refund->dispute_case_id)->lockForUpdate()->first();
        $remedy = DB::table('dispute_remedies')->where('dispute_case_id', $case->id)->where('kind', 'ONLINE_REFUND')->whereRaw("payload->>'refund_id' = ?", [(string) $refund->id])->first();
        if ($remedy === null) {
            return $order;
        }
        $target = match ($refund->state) {
            'REFUNDED' => 'COMPLETED', 'REFUND_FAILED' => 'FAILED', default => 'PENDING'
        };
        if ($remedy->state !== $target && $remedy->state !== 'COMPLETED') {
            DB::table('dispute_remedies')->where('id', $remedy->id)->update(['state' => $target, 'completed_at' => $target === 'COMPLETED' ? now() : null,
                'note' => match ($target) {
                    'COMPLETED' => 'Processed by the payment provider to the original payment method.', 'FAILED' => 'The provider refund failed; it stays open for an authorized retry.', default => 'Refund retried; waiting for the provider.'
                },
                'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
            $this->timeline->append($case, 'REFUND_UPDATED', OrderActor::system($actor->correlationId), 'SYSTEM', match ($target) {
                'COMPLETED' => 'The payment provider processed the Dispute-Conclusion Refund. Arrival time depends on the payment channel.',
                'FAILED' => 'The Dispute-Conclusion Refund failed and stays open for an authorized retry. The Buyer is not asked to pay again.',
                default => 'The Dispute-Conclusion Refund was retried and is waiting for the provider.',
            }, ['refund_id' => (string) $refund->id, 'state' => (string) $refund->state, 'amount_centavos' => (int) $refund->amount_centavos]);
        }
        $case = $this->refreshRemedyState(DB::table('dispute_cases')->where('id', $case->id)->first());

        return $this->evaluate($order, $case, OrderActor::system($actor->correlationId))['order'];
    }

    /** A dispute cash reimbursement was confirmed by the Buyer or by a reasoned Admin review. The caller holds the order lock. */
    public function reimbursementConfirmed(object $order, object $reimbursement, OrderActor $actor): object
    {
        if ($reimbursement->dispute_decision_id === null) {
            return $order;
        }
        $caseId = DB::table('dispute_decisions')->where('id', $reimbursement->dispute_decision_id)->value('dispute_case_id');
        $case = DB::table('dispute_cases')->where('id', $caseId)->lockForUpdate()->first();
        $remedy = DB::table('dispute_remedies')->where('dedupe_key', 'reimbursement:'.$reimbursement->id)->first();
        if ($case === null || $remedy === null || $remedy->state === 'COMPLETED') {
            return $order;
        }
        DB::table('dispute_remedies')->where('id', $remedy->id)->update(['state' => 'COMPLETED', 'completed_at' => now(), 'note' => 'Cash reimbursement confirmed.', 'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
        $this->timeline->append($case, 'REMEDY_COMPLETED', $actor, self::party($actor), 'The Vendor\'s cash reimbursement was confirmed.', ['remedy_id' => (string) $remedy->id, 'kind' => 'CASH_REIMBURSEMENT']);

        return $this->evaluate($order, $this->refreshRemedyState(DB::table('dispute_cases')->where('id', $case->id)->first()), $actor)['order'];
    }

    /** Recomputes the case's remedy summary from its blocking remedies. */
    public function refreshRemedyState(object $case): object
    {
        $states = DB::table('dispute_remedies')->where('dispute_case_id', $case->id)->whereIn('kind', self::BLOCKING)->pluck('state')->all();
        $state = match (true) {
            $states === [] => 'NONE',
            in_array('FAILED', $states, true) => 'FAILED',
            in_array('PENDING', $states, true) => 'PENDING',
            default => 'COMPLETED',
        };
        if ($case->remedy_state !== $state) {
            DB::table('dispute_cases')->where('id', $case->id)->update(['remedy_state' => $state, 'updated_at' => now()]);
        }

        return DB::table('dispute_cases')->where('id', $case->id)->first();
    }

    /**
     * @param  array<string, mixed>  $payload
     */
    public function remedy(object $case, object $decision, string $kind, int $amount, string $dedupe, OrderActor $actor, array $payload = []): string
    {
        $id = (string) Str::uuid7();
        $inserted = DB::table('dispute_remedies')->insertOrIgnore(['id' => $id, 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'PENDING',
            'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'dispute_decision_id' => $decision->id, 'kind' => $kind, 'amount_centavos' => $amount, 'dedupe_key' => $dedupe,
            'created_at' => now(), 'updated_at' => now()]);
        if ($inserted === 0) {
            return (string) DB::table('dispute_remedies')->where('dedupe_key', $dedupe)->value('id');
        }
        $this->timeline->append($case, 'REMEDY_CREATED', $actor, $actor->userId === null ? 'SYSTEM' : self::party($actor), self::remedyText($kind, $amount), ['remedy_id' => $id, 'kind' => $kind, 'amount_centavos' => $amount] + $payload);

        return $id;
    }

    private function award(object $order, object $case, object $decision, OrderActor $actor): object
    {
        $allocation = json_decode((string) ($decision->allocation ?? '{}'), true) ?: [];
        try {
            $plan = $this->planner->plan($order, $case, (string) $decision->outcome, (int) $decision->awarded_centavos, array_values(array_map('strval', $allocation['affected_line_ids'] ?? [])));
        } catch (AuthenticationException $exception) {
            // A changed balance never silently drops the award: it stays a visible failed remedy for Admin review.
            $this->remedy($case, $decision, 'ONLINE_REFUND', (int) $decision->awarded_centavos, 'award-failed:'.$decision->id, $actor, ['planning_error' => $exception->errorCode]);
            DB::table('dispute_remedies')->where('dedupe_key', 'award-failed:'.$decision->id)->update(['state' => 'FAILED', 'note' => mb_substr($exception->getMessage(), 0, 500), 'updated_at' => now()]);

            return $order;
        }
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
            $inserted = DB::table('refunds')->insertOrIgnore(['id' => $refundId, 'target_type' => 'ORDER', 'order_id' => $order->id, 'source_payment_id' => $payment->id, 'trigger' => 'DISPUTE_CONCLUSION',
                'amount_centavos' => $amount, 'principal_centavos' => $amount - $fee, 'processing_fee_centavos' => $fee, 'source_captured_centavos' => (int) $payment->total_centavos,
                'prior_allocated_centavos' => (int) $payment->total_centavos - $balance, 'state' => 'REFUND_PENDING', 'idempotency_key' => 'dispute:'.$decision->id.':'.$payment->id,
                'environment' => 'TEST', 'evidence_origin' => $payment->evidence_origin, 'reason_code' => 'DISPUTE_'.$decision->outcome, 'requested_at' => now(),
                'dispute_case_id' => $case->id, 'dispute_decision_id' => $decision->id,
                'allocation' => json_encode(['dispute_case_id' => (string) $case->id, 'decision_version' => (int) $decision->version, 'payment_purpose' => (string) $payment->purpose,
                    'principal_centavos' => $amount - $fee, 'processing_fee_centavos' => $fee], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted === 0) {
                continue;
            }
            $this->refunds->event((object) ['id' => $refundId, 'attempt_number' => 1, 'state' => null], 'REFUND_PENDING', 'SYSTEM', null, $actor->correlationId);
            $this->remedy($case, $decision, 'ONLINE_REFUND', $amount, 'refund:'.$refundId, $actor, ['refund_id' => $refundId, 'payment_purpose' => (string) $payment->purpose]);
            $this->taxReview($case, $payment, $refundId, $amount);
            $this->refunds->queue($refundId, $actor->correlationId);
        }
        if ($plan['cash_reimbursement_centavos'] > 0) {
            $collection = DB::table('physical_payment_records')->where('order_id', $order->id)->whereIn('record_kind', ['COLLECTION', 'CORRECTION'])->where('amount_centavos', '>', 0)
                ->orderByDesc('recorded_at')->orderByDesc('id')->value('id');
            $reimbursementId = (string) Str::uuid7();
            DB::table('physical_reimbursements')->insertOrIgnore(['id' => $reimbursementId, 'refund_id' => null, 'physical_payment_record_id' => $collection, 'recorded_by_user_id' => null,
                'amount_centavos' => $plan['cash_reimbursement_centavos'], 'method' => (string) $order->payment_method, 'state' => 'VENDOR_REIMBURSEMENT_PENDING', 'order_id' => $order->id,
                'dispute_decision_id' => $decision->id, 'created_at' => now(), 'updated_at' => now()]);
            $reimbursementId = (string) DB::table('physical_reimbursements')->where('dispute_decision_id', $decision->id)->value('id');
            $this->remedy($case, $decision, 'CASH_REIMBURSEMENT', (int) $plan['cash_reimbursement_centavos'], 'reimbursement:'.$reimbursementId, $actor, ['reimbursement_id' => $reimbursementId]);
        }
        if ($snapshotId !== null) {
            $this->allocate((string) $snapshotId, (string) $decision->id, $plan['lines']);
        }
        $handoverPending = in_array($order->order_state, [OrderStates::CONFIRMED, OrderStates::PROCESSING, ...OrderStates::HANDOVER_STAGE], true);
        if ($decision->outcome === 'FULL_REFUND' && $handoverPending) {
            $order = $this->orders->cancelBeforeHandover($order, $case, $actor);
            $this->timeline->append($case, 'ORDER_HOLD_CHANGED', $actor, $actor->userId === null ? 'SYSTEM' : self::party($actor), 'The full award ended the order before handover: the reservation was released and no commission is earned.');
        } else {
            $this->feeCredits->record($case, (string) $decision->id, (int) $plan['returned_exclusive_centavos'], $actor);
        }
        $order = $this->refunds->syncOrder(DB::table('orders')->where('id', $order->id)->first(), $actor, 'DISPUTE_CONCLUSION');
        $peso = static fn (int $centavos): string => '₱'.number_format($centavos / 100, 2);
        $parts = [];
        if ($plan['online_refund_total_centavos'] > 0) {
            $parts[] = 'A Dispute-Conclusion Refund of '.$peso((int) $plan['online_refund_total_centavos']).' to your original payment method was initiated. It is confirmed only after the payment provider processes it.';
        }
        if ($plan['cash_reimbursement_centavos'] > 0) {
            $parts[] = 'The '.$peso((int) $plan['cash_reimbursement_centavos']).' you paid the Vendor directly will be reimbursed by the Vendor; confirm it on the order when you receive it.';
        }
        $this->notifier->buyer($case, 'Refund awarded — case '.$case->reference, implode(' ', $parts));
        $this->notifier->vendor($case, 'Refund awarded — case '.$case->reference, 'A refund was awarded on this case. Online amounts return to the Buyer\'s original payment method'
            .($plan['cash_reimbursement_centavos'] > 0 ? '; reimburse the cash collected and record the evidence on the order.' : '.'), ['OWNER', 'STORE_MANAGER']);

        return $order;
    }

    /**
     * @param  list<array{order_line_id: string, payable_centavos: int, vat_centavos: int, discount_centavos: int}>  $lines
     */
    private function allocate(string $snapshotId, string $decisionId, array $lines): void
    {
        foreach ($lines as $line) {
            $inserted = DB::table('financial_allocations')->insertOrIgnore(['id' => (string) Str::uuid7(), 'financial_snapshot_id' => $snapshotId, 'allocation_type' => 'REFUND_LINE', 'source_type' => 'DISPUTE_DECISION',
                'source_id' => $decisionId, 'target_type' => 'ORDER_LINE', 'target_id' => $line['order_line_id'], 'amount_centavos' => $line['payable_centavos'],
                'basis' => json_encode(['vat_centavos' => $line['vat_centavos'], 'discount_centavos' => $line['discount_centavos']], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted > 0) {
                DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshotId)->where('order_line_id', $line['order_line_id'])
                    ->update(['refund_allocated_centavos' => DB::raw('refund_allocated_centavos + '.$line['payable_centavos']), 'updated_at' => now()]);
            }
        }
    }

    private function taxReview(object $case, object $payment, string $refundId, int $amount): void
    {
        foreach (DB::table('remittance_assessments')->where('payment_id', $payment->id)->where('calculation_state', 'POSTED')->pluck('id') as $assessmentId) {
            $this->assessments->openAdjustmentForRefund((string) $assessmentId, $refundId, $amount,
                'Case '.$case->reference.' awarded a Dispute-Conclusion Refund after this collection was assessed. Review the posted withholding; a refund never amends a filed return or recovers tax automatically.',
                'DISPUTE_REFUND_AFTER_ASSESSMENT');
        }
    }

    private function sanctions(object $case, object $decision, OrderActor $actor): void
    {
        $sanctions = json_decode((string) ($decision->sanctions ?? '{}'), true) ?: [];
        foreach ($sanctions['actions'] ?? [] as $action) {
            $subjectType = $action['subject'] === 'BUYER' ? 'BUYER' : 'VENDOR_ORGANIZATION';
            $state = $action['action'] === 'WARNING' ? 'EFFECTIVE' : 'REFERRED';
            $inserted = DB::table('enforcement_actions')->insertOrIgnore(['id' => (string) Str::uuid7(), 'dispute_case_id' => $case->id, 'dispute_decision_id' => $decision->id,
                'subject_type' => $subjectType, 'subject_id' => $subjectType === 'BUYER' ? $case->buyer_profile_id : $case->vendor_organization_id, 'action' => $action['action'], 'state' => $state,
                'reason' => mb_substr((string) $action['reason'], 0, 2000), 'scope' => mb_substr((string) ($action['scope'] ?? 'Marketplace activity'), 0, 160),
                'duration_days' => $action['duration_days'] ?? null, 'restoration_condition' => $action['restoration_condition'] ?? null, 'effective_at' => $state === 'EFFECTIVE' ? now() : null,
                'issued_by_user_id' => $decision->actor_user_id, 'issued_role' => $decision->actor_role, 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted === 0) {
                continue;
            }
            $this->timeline->append($case, 'SANCTION_RECORDED', $actor, $actor->userId === null ? 'SYSTEM' : self::party($actor),
                $state === 'EFFECTIVE' ? 'A warning was recorded.' : self::sanctionLabel((string) $action['action']).' was recorded and referred to User Management Staff, who apply account restrictions.',
                ['subject' => $subjectType, 'action' => $action['action'], 'state' => $state]);
            $text = $state === 'EFFECTIVE' ? 'A warning was recorded on case '.$case->reference.': '.$action['reason']
                : self::sanctionLabel((string) $action['action']).' was recommended on case '.$case->reference.' and referred for account review. You will be told before any restriction takes effect.';
            if ($subjectType === 'BUYER') {
                $this->notifier->buyer($case, 'Account notice — case '.$case->reference, $text);
            } else {
                $this->notifier->vendor($case, 'Store notice — case '.$case->reference, $text, ['OWNER']);
            }
        }
        if (is_string($sanctions['metric_event'] ?? null) && in_array($sanctions['metric_event'], DisputeRules::METRIC_EVENTS, true)) {
            // A confirmed event for the scoring service to recalculate from; never an arbitrary score change.
            $inserted = DB::table('metric_events')->insertOrIgnore(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $case->vendor_organization_id, 'metric' => $sanctions['metric_event'],
                'source_id' => $decision->id, 'value' => '1.0000', 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted > 0) {
                $this->timeline->append($case, 'SANCTION_RECORDED', $actor, $actor->userId === null ? 'SYSTEM' : self::party($actor), 'A confirmed metric event was recorded for the Vendor score: '.strtolower(str_replace('_', ' ', $sanctions['metric_event'])).'.',
                    ['metric_event' => $sanctions['metric_event']]);
            }
        }
    }

    public static function party(OrderActor $actor): string
    {
        return match ($actor->source) {
            'BUYER' => 'BUYER', 'VENDOR' => 'VENDOR', default => $actor->userId === null ? 'SYSTEM' : 'ADMIN'
        };
    }

    private static function sanctionLabel(string $action): string
    {
        return match ($action) {
            'TEMPORARY_RESTRICTION' => 'A temporary restriction', 'SUSPENSION' => 'A suspension', 'PERMANENT_BAN' => 'A permanent ban', default => 'A warning'
        };
    }

    private static function remedyText(string $kind, int $amount): string
    {
        $peso = '₱'.number_format($amount / 100, 2);

        return match ($kind) {
            'ONLINE_REFUND' => 'Dispute-Conclusion Refund of '.$peso.' to the original payment method initiated.',
            'CASH_REIMBURSEMENT' => 'Vendor cash reimbursement of '.$peso.' required, with evidence and the Buyer\'s confirmation.',
            'REPLACEMENT' => 'Replacement required from the Vendor and confirmed by the Buyer.',
            default => 'Remedy recorded.',
        };
    }

    /** Pesos for notices. */
    public static function pesos(int $centavos): string
    {
        return WithholdingThresholdService::pesos($centavos);
    }
}
