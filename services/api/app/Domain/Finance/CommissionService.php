<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Payments\RefundService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-03 commission arithmetic and credits beyond the ESTIMATED → EARNED lifecycle in FeeAssessmentService.
 *
 *   earned fee        = money(E_completed × 0.02), E = completed, non-refunded materials value excluding VAT
 *   partial return    target = money((E − returned E) × 0.02); credit = original target − new target
 *   full reversal     consumes every remaining fee centavo
 *   DEMO_VAT_12       fee VAT = money(fee × 12 / 112); revenue = fee − VAT (DEMO_NONVAT: no fee VAT)
 *
 * A credit is prepared by one finance user and approved by a different one; it never edits the earned source
 * amount, posts a reversing ledger batch and is billed as a credit line on the next statement (or recorded as an
 * audited payable when the original statement was already paid). Commission is never deducted from a remittance.
 */
final class CommissionService
{
    public function __construct(private readonly FinancialLedgerService $ledger, private readonly OutboxPublisher $outbox) {}

    /** @return array{target_centavos: int, credit_centavos: int} */
    public static function creditTarget(int $originalExclusiveCentavos, int $originalTargetCentavos, int $alreadyCreditedCentavos, int $returnedExclusiveCentavos): array
    {
        if ($returnedExclusiveCentavos < 0 || $returnedExclusiveCentavos > $originalExclusiveCentavos) {
            throw new \InvalidArgumentException('Returned value must be within the original exclusive materials value.');
        }
        $remaining = $originalExclusiveCentavos - $returnedExclusiveCentavos;
        $target = $remaining === 0 ? 0 : Money::commission($remaining);
        $credit = max(0, $originalTargetCentavos - $alreadyCreditedCentavos - $target);

        return ['target_centavos' => $target, 'credit_centavos' => $credit];
    }

    /** @return array{fee_centavos: int, vat_centavos: int, revenue_centavos: int} */
    public static function feeVat(int $feeCentavos, ?string $profile = null): array
    {
        $profile ??= (string) (config('finance.platform_tax_profile') ?: 'DEMO_NONVAT');
        $vat = $profile === 'DEMO_VAT_12' ? Money::proportion($feeCentavos, 12, 112) : 0;

        return ['fee_centavos' => $feeCentavos, 'vat_centavos' => $vat, 'revenue_centavos' => $feeCentavos - $vat];
    }

    /** Posts the PLATFORM_FEE earning batch once per earned assessment, inside the earning transaction. */
    public function postEarning(object $assessment, int $earnedCentavos, string $correlationId): void
    {
        $split = self::feeVat($earnedCentavos);
        $source = ['FEE_ASSESSMENT', (string) $assessment->id];
        $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_EARNED', 'PLATFORM_FEE:EARNED:'.$assessment->id, [
            FinancialLedgerService::debit('FEE_RECEIVABLE', $earnedCentavos, ...$source),
            FinancialLedgerService::credit('FEE_REVENUE', $split['revenue_centavos'], ...$source),
            FinancialLedgerService::credit('OUTPUT_VAT', $split['vat_centavos'], ...$source),
        ], $correlationId);
    }

    /**
     * A finance user prepares a credit proposal for an EARNED assessment (returned exclusive value after
     * completion). The proposal waits for a different approver.
     */
    public function proposeCredit(string $assessmentId, int $returnedExclusiveCentavos, string $reason, int $preparerUserId): string
    {
        return DB::transaction(function () use ($assessmentId, $returnedExclusiveCentavos, $reason, $preparerUserId): string {
            $assessment = DB::table('fee_assessments')->where('id', $assessmentId)->lockForUpdate()->first();
            if ($assessment === null || $assessment->state !== 'EARNED') {
                throw new AuthenticationException('FEE_CREDIT_NOT_AVAILABLE', 'Only an earned commission can be credited.', 409);
            }
            $computed = self::creditTarget((int) $assessment->commission_basis_centavos, (int) $assessment->earned_target_centavos, (int) $assessment->credited_centavos, $returnedExclusiveCentavos);
            if ($computed['credit_centavos'] <= 0) {
                throw new AuthenticationException('FEE_CREDIT_NOT_AVAILABLE', 'This return does not reduce the earned commission.', 422);
            }
            $id = (string) Str::uuid7();
            DB::table('finance_review_items')->insert(['id' => $id, 'environment' => 'TEST', 'kind' => 'FEE_CREDIT_PROPOSAL', 'vendor_organization_id' => $assessment->vendor_organization_id,
                'source_type' => 'FEE_ASSESSMENT', 'source_id' => $assessmentId, 'reason_code' => 'RETURNED_MATERIALS', 'summary' => mb_substr($reason, 0, 2000),
                'expected' => json_encode(['returned_exclusive_centavos' => $returnedExclusiveCentavos, 'target_before_centavos' => (int) $assessment->earned_target_centavos - (int) $assessment->credited_centavos,
                    'target_after_centavos' => $computed['target_centavos'], 'credit_centavos' => $computed['credit_centavos'], 'prepared_by_user_id' => $preparerUserId], JSON_THROW_ON_ERROR),
                'reported' => json_encode([], JSON_THROW_ON_ERROR), 'state' => 'OPEN', 'dedupe_key' => 'FEE_CREDIT_PROPOSAL:'.$id, 'created_at' => now(), 'updated_at' => now()]);

            return $id;
        });
    }

    /** A different finance user approves the proposal: one fee_adjustment, a reversing ledger batch, no rewrite. */
    public function approveCredit(string $proposalId, int $approverUserId, string $correlationId): string
    {
        return DB::transaction(function () use ($proposalId, $approverUserId, $correlationId): string {
            $proposal = DB::table('finance_review_items')->where('id', $proposalId)->where('kind', 'FEE_CREDIT_PROPOSAL')->lockForUpdate()->first();
            if ($proposal === null || $proposal->state !== 'OPEN') {
                throw new AuthenticationException('FEE_CREDIT_NOT_AVAILABLE', 'This credit proposal is not open.', 409);
            }
            $values = json_decode((string) $proposal->expected, true) ?: [];
            if ((int) ($values['prepared_by_user_id'] ?? 0) === $approverUserId) {
                throw new AuthenticationException('PREPARER_REVIEWER_SAME', 'A different finance user must approve this credit.', 403);
            }
            $assessment = DB::table('fee_assessments')->where('id', $proposal->source_id)->lockForUpdate()->first();
            $computed = self::creditTarget((int) $assessment->commission_basis_centavos, (int) $assessment->earned_target_centavos, (int) $assessment->credited_centavos, (int) $values['returned_exclusive_centavos']);
            if ($computed['credit_centavos'] <= 0) {
                throw new AuthenticationException('FEE_CREDIT_NOT_AVAILABLE', 'This commission was already credited.', 409);
            }
            $adjustmentId = (string) Str::uuid7();
            $before = (int) $assessment->earned_target_centavos - (int) $assessment->credited_centavos;
            DB::table('fee_adjustments')->insert(['id' => $adjustmentId, 'fee_assessment_id' => $assessment->id, 'kind' => 'CREDIT', 'amount_centavos' => $computed['credit_centavos'],
                'target_fee_before_centavos' => $before, 'target_fee_after_centavos' => $computed['target_centavos'], 'reason' => (string) $proposal->summary,
                'prepared_by_user_id' => (int) $values['prepared_by_user_id'], 'approved_by_user_id' => $approverUserId, 'approved_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $credited = (int) $assessment->credited_centavos + $computed['credit_centavos'];
            DB::table('fee_assessments')->where('id', $assessment->id)->update(['credited_centavos' => $credited,
                'credited_state' => $credited >= (int) $assessment->earned_centavos ? 'CREDITED' : 'PARTIALLY_CREDITED', 'updated_at' => now()]);
            $paid = DB::table('fee_statement_lines as l')->join('fee_statements as s', 's.id', '=', 'l.fee_statement_id')->where('l.fee_assessment_id', $assessment->id)->where('s.state', 'PAID')->exists();
            $split = self::feeVat($computed['credit_centavos']);
            $source = ['FEE_ADJUSTMENT', $adjustmentId];
            $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_CREDIT', 'PLATFORM_FEE:CREDIT:'.$adjustmentId, [
                FinancialLedgerService::debit('FEE_REVENUE', $split['revenue_centavos'], ...$source), FinancialLedgerService::debit('OUTPUT_VAT', $split['vat_centavos'], ...$source),
                FinancialLedgerService::credit($paid ? 'FEE_REFUND_PAYABLE' : 'FEE_RECEIVABLE', $computed['credit_centavos'], ...$source),
            ], $correlationId, $approverUserId, 'FINANCE_REVIEWER');
            if ($paid) {
                // FIN-07 PLATFORM_FEE target: refund through the original fee captures only; never another party's funds.
                $adjustment = DB::table('fee_adjustments')->where('id', $adjustmentId)->first();
                $covered = app(RefundService::class)->createFeeCreditRefunds($adjustment, $assessment, $correlationId);
                if ($covered < $computed['credit_centavos']) {
                    app(WithholdingThresholdService::class)->reviewItem('TEST', (string) $assessment->vendor_organization_id, 'PAID_FEE_CREDIT_PAYABLE', $adjustmentId, 'CREDIT_ON_PAID_STATEMENT',
                        'A fee credit applies to an already paid statement and no supported original fee capture covers ₱'.WithholdingThresholdService::pesos($computed['credit_centavos'] - $covered).'. Record the audited payable.',
                        ['credit_centavos' => $computed['credit_centavos'], 'refund_covered_centavos' => $covered], [], 'FEE_ADJUSTMENT');
                }
            }
            DB::table('finance_review_items')->where('id', $proposalId)->update(['state' => 'RESOLVED', 'resolution' => 'Approved as fee adjustment '.$adjustmentId, 'resolved_by_user_id' => $approverUserId, 'resolved_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('FEE_CREDIT_APPROVED', 'FEE_ADJUSTMENT', $adjustmentId, ['fee_adjustment_id' => $adjustmentId, 'credit_centavos' => $computed['credit_centavos']]);

            return $adjustmentId;
        });
    }
}
