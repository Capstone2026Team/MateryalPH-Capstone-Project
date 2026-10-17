<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Finance\CommissionService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderActor;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-03/FIN-07 commission consequence of a money award. The awarded VAT-exclusive materials value becomes a
 * fee-credit proposal that a different finance user approves; the earned amount itself is never rewritten.
 *
 *   assessment EARNED     the proposal is created when the award executes
 *   assessment ESTIMATED  a non-blocking FEE_CREDIT_REVIEW remedy waits; completion creates the proposal right after
 *                         the commission is earned (an order that never completes cancels the estimate instead)
 *   assessment CANCELLED  nothing: no commission exists
 *
 * The returned value is cumulative per order, so successive awards never under- or double-credit.
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
            $this->proposePending((string) $case->order_id, $actor);
        }
    }

    /** Turns every pending fee-credit review of an order with an EARNED commission into a reviewed proposal. */
    public function proposePending(string $orderId, OrderActor $actor): void
    {
        $assessment = DB::table('fee_assessments')->where('order_id', $orderId)->orderByDesc('created_at')->first();
        if ($assessment === null || $assessment->state !== 'EARNED') {
            return;
        }
        $pending = DB::table('dispute_remedies as r')->join('dispute_cases as c', 'c.id', '=', 'r.dispute_case_id')->where('c.order_id', $orderId)
            ->where('r.kind', 'FEE_CREDIT_REVIEW')->where('r.state', 'PENDING')->orderBy('r.created_at')->get(['r.*', 'c.reference']);
        foreach ($pending as $remedy) {
            $cumulative = (int) DB::table('dispute_remedies as r')->join('dispute_cases as c', 'c.id', '=', 'r.dispute_case_id')->where('c.order_id', $orderId)
                ->where('r.kind', 'FEE_CREDIT_REVIEW')->where(fn ($query) => $query->where('r.state', 'COMPLETED')->orWhere('r.id', $remedy->id))->sum('r.amount_centavos');
            $returned = min($cumulative, (int) $assessment->commission_basis_centavos);
            $preparer = (int) (DB::table('dispute_decisions')->where('id', $remedy->dispute_decision_id)->value('actor_user_id') ?? 0);
            $note = 'Dispute '.$remedy->reference.' awarded a refund of returned materials (VAT-exclusive ₱'.number_format($returned / 100, 2).' cumulative). Review the commission credit.';
            try {
                $proposalId = $this->commission->proposeCredit((string) $assessment->id, $returned, $note, $preparer);
                $result = 'Fee-credit proposal '.$proposalId.' awaits a different finance reviewer.';
            } catch (AuthenticationException $exception) {
                // Already fully credited or no reduction: the review is complete without a new proposal.
                $result = 'No further commission credit: '.$exception->getMessage();
            }
            DB::table('dispute_remedies')->where('id', $remedy->id)->where('state', 'PENDING')->update(['state' => 'COMPLETED', 'note' => mb_substr($result, 0, 500), 'completed_at' => now(),
                'recorded_role' => $actor->role, 'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
        }
    }
}
