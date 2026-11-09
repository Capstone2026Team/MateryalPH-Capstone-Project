<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Finance\CommissionService;
use App\Domain\Orders\OrderActor;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Executed dispute awards automatically reduce earned commission using the original rate and cumulative
 * VAT-exclusive returned materials. Estimates wait until completion; cancelled orders never earn a credit.
 * Legacy FEE_CREDIT_REVIEW remedies remain readable, with explicit system processing and source references.
 */
final class DisputeFeeCredits
{
    public function __construct(private readonly CommissionService $commission) {}

    public function record(object $case, string $decisionId, int $returnedExclusiveCentavos, OrderActor $actor): void
    {
        if ($returnedExclusiveCentavos <= 0) {
            return;
        }
        $assessment = DB::table('fee_assessments')->where('order_id', $case->order_id)->orderByDesc('created_at')->first();
        if ($assessment === null || $assessment->state === 'CANCELLED') {
            return;
        }
        $remedyId = (string) Str::uuid7();
        DB::table('dispute_remedies')->insertOrIgnore(['id' => $remedyId, 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'PENDING',
            'payload' => json_encode(['fee_assessment_id' => (string) $assessment->id], JSON_THROW_ON_ERROR), 'dispute_decision_id' => $decisionId, 'kind' => 'FEE_CREDIT_REVIEW',
            'amount_centavos' => $returnedExclusiveCentavos, 'dedupe_key' => 'fee-credit:'.$decisionId, 'created_at' => now(), 'updated_at' => now()]);
        if ($assessment->state === 'EARNED') {
            $this->applyPending((string) $case->order_id, $actor);
        }
    }

    /** Apply authoritative awards once. Order locking serializes awards, completion and recovery. */
    public function applyPending(string $orderId, OrderActor $actor): void
    {
        DB::transaction(function () use ($orderId, $actor): void {
            DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $remedies = $this->unprocessed()->where('c.order_id', $orderId)->orderBy('r.created_at')->orderBy('r.id')->get(['r.*']);
            // Preserve the manual approval lock order when retiring a legacy, source-linked proposal.
            $proposalIds = [];
            foreach ($remedies as $remedy) {
                if (preg_match('/^Fee-credit proposal ([0-9a-f-]{36}) awaits a different finance reviewer\.$/i', (string) $remedy->note, $match)) {
                    $proposalIds[(string) $remedy->id] = $match[1];
                }
            }
            $proposals = DB::table('finance_review_items')->whereIn('id', array_values($proposalIds))->orderBy('id')->lockForUpdate()->get()->keyBy('id');
            $assessment = DB::table('fee_assessments')->where('order_id', $orderId)->orderByDesc('created_at')->lockForUpdate()->first();
            if ($assessment === null || $assessment->state !== 'EARNED') {
                return;
            }
            foreach ($remedies as $remedy) {
                $cumulative = (int) DB::table('dispute_remedies as r')->join('dispute_cases as c', 'c.id', '=', 'r.dispute_case_id')->where('c.order_id', $orderId)
                    ->where('r.kind', 'FEE_CREDIT_REVIEW')->where('r.state', 'COMPLETED')->whereExists(fn ($q) => $q->selectRaw('1')->from('commission_credit_executions as x')->whereColumn('x.dispute_remedy_id', 'r.id'))->sum('r.amount_centavos');
                $returned = min($cumulative + (int) $remedy->amount_centavos, (int) $assessment->commission_basis_centavos);
                $adjustmentId = $this->commission->creditDisputeRemedy($assessment, $remedy, $returned, $actor->correlationId);
                $result = $adjustmentId === null ? 'No further commission credit is due.' : 'Commission credit applied automatically: '.$adjustmentId;
                DB::table('commission_credit_executions')->insert(['dispute_remedy_id' => $remedy->id, 'fee_assessment_id' => $assessment->id, 'created_at' => now()]);
                DB::table('dispute_remedies')->where('id', $remedy->id)->update(['state' => 'COMPLETED', 'note' => $result,
                    'completed_at' => $remedy->completed_at ?? now(), 'recorded_role' => 'SYSTEM',
                    'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
                $proposal = $proposals->get($proposalIds[(string) $remedy->id] ?? '');
                if ($proposal !== null && $proposal->state === 'OPEN' && $proposal->kind === 'FEE_CREDIT_PROPOSAL' && (string) $proposal->source_id === (string) $assessment->id) {
                    DB::table('finance_review_items')->where('id', $proposal->id)->update(['state' => 'RESOLVED', 'resolution' => $result,
                        'resolved_by_user_id' => null, 'resolved_at' => now(), 'updated_at' => now()]);
                }
                $assessment = DB::table('fee_assessments')->where('id', $assessment->id)->first();
            }
        }, 3);
    }

    /** Bounded recovery also consumes existing proposal-backed awards without rewriting past adjustments. */
    public function recover(): int
    {
        $orders = $this->unprocessed()->whereExists(fn ($q) => $q->selectRaw('1')->from('fee_assessments as f')
            ->whereColumn('f.order_id', 'c.order_id')->where('f.state', 'EARNED'))
            ->orderBy('r.created_at')->orderBy('r.id')->limit(500)->pluck('c.order_id')->unique();
        foreach ($orders as $orderId) {
            $this->applyPending((string) $orderId, OrderActor::system());
        }

        return $orders->count();
    }

    private function unprocessed(): Builder
    {
        return DB::table('dispute_remedies as r')->join('dispute_cases as c', 'c.id', '=', 'r.dispute_case_id')
            ->where('r.kind', 'FEE_CREDIT_REVIEW')->whereIn('r.state', ['PENDING', 'COMPLETED'])->whereNotExists(fn ($q) => $q->selectRaw('1')->from('commission_credit_executions as x')->whereColumn('x.dispute_remedy_id', 'r.id'))
            ->whereExists(fn ($q) => $q->selectRaw('1')->from('dispute_events as e')->whereColumn('e.dispute_case_id', 'r.dispute_case_id')
                ->where('e.event_type', 'DECISION_ENFORCEABLE')->whereRaw("e.payload->>'decision_id' = r.dispute_decision_id::text"));
    }
}
