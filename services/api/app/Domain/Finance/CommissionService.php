<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Payments\RefundService;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-03 commission arithmetic and credits beyond the ESTIMATED → EARNED lifecycle in FeeAssessmentService.
 *
 *   earned fee        = money(E_completed × saved rate), E = completed, non-refunded materials value excluding VAT
 *   partial return    target = money((E − returned E) × saved rate); credit = original target − new target
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

    public static function collections(?string $organizationId = null): Builder
    {
        return DB::table('fee_payment_allocations as a')->join('payments as p', 'p.id', '=', 'a.payment_id')
            ->where('p.state', 'PAID')->where('p.purpose', 'PLATFORM_FEE_PAYMENT')->where('p.environment', FinancialSnapshotService::ENVIRONMENT)->where('p.late_capture', false)
            ->when($organizationId, fn (Builder $q, string $id) => $q->where('p.vendor_organization_id', $id));
    }

    public static function feeRefunds(?string $organizationId = null): Builder
    {
        return DB::table('refunds as r')->where('r.target_type', 'PLATFORM_FEE')->where('r.state', 'REFUNDED')->where('r.environment', FinancialSnapshotService::ENVIRONMENT)
            ->when($organizationId, fn (Builder $q, string $id) => $q->whereIn('r.source_payment_id', DB::table('payments')->where('vendor_organization_id', $id)->select('id')));
    }

    /** One signed movement per earning or approved credit, shared by both portals; collections never earn it again. */
    public static function movements(?string $organizationId = null): Builder
    {
        $earned = DB::table('fee_assessments')->where('state', 'EARNED')
            ->when($organizationId, fn (Builder $q, string $id) => $q->where('vendor_organization_id', $id))
            ->selectRaw("id AS assessment_id, vendor_organization_id, earned_at AS occurred_at, earned_centavos AS amount_centavos, 'EARNED' AS kind");
        $credits = DB::table('fee_adjustments as a')->join('fee_assessments as f', 'f.id', '=', 'a.fee_assessment_id')->where('a.kind', 'CREDIT')
            ->when($organizationId, fn (Builder $q, string $id) => $q->where('f.vendor_organization_id', $id))
            ->selectRaw("f.id AS assessment_id, f.vendor_organization_id, a.approved_at AS occurred_at, -a.amount_centavos AS amount_centavos, 'CREDIT' AS kind");

        return DB::query()->fromSub($earned->unionAll($credits), 'commission_movements');
    }

    /** @return array{target_centavos: int, credit_centavos: int} */
    public static function creditTarget(int $originalExclusiveCentavos, int $originalTargetCentavos, int $alreadyCreditedCentavos, int $returnedExclusiveCentavos, int $basisPoints = 200): array
    {
        if ($returnedExclusiveCentavos < 0 || $returnedExclusiveCentavos > $originalExclusiveCentavos) {
            throw new \InvalidArgumentException('Returned value must be within the original exclusive materials value.');
        }
        $remaining = $originalExclusiveCentavos - $returnedExclusiveCentavos;
        $target = $remaining === 0 ? 0 : Money::commission($remaining, $basisPoints);
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

    /**
     * Preserve the original posted VAT treatment and consume rounding residue on the final reversal.
     *
     * @return array{vat_centavos: int, revenue_centavos: int}
     */
    public static function creditSplit(int $earned, int $originalVat, int $creditedFee, int $creditedVat, int $credit): array
    {
        $remaining = max(0, $earned - $creditedFee - $credit);
        $targetVat = $originalVat === 0 ? 0 : Money::proportion($remaining, 12, 112);
        $vat = min($credit, max(0, $originalVat - $creditedVat - $targetVat));

        return ['vat_centavos' => $vat, 'revenue_centavos' => $credit - $vat];
    }

    /** Correct historical rounding/tax-treatment differences through balanced compensating postings. */
    public function synchronizeCreditVat(string $correlationId): void
    {
        DB::table('fee_assessments')->where('state', 'EARNED')->where('credited_centavos', '>', 0)->eachById(function (object $row) use ($correlationId): void {
            DB::transaction(function () use ($row, $correlationId): void {
                $assessment = DB::table('fee_assessments')->where('id', $row->id)->lockForUpdate()->first();
                $originalVat = (int) DB::table('financial_ledger_entries')->where('source_type', 'FEE_ASSESSMENT')->where('source_id', $row->id)->where('account_code', 'OUTPUT_VAT')->where('direction', 'CREDIT')->sum('amount_centavos');
                $creditedVat = self::creditedVat((string) $row->id);
                $target = $originalVat === 0 ? 0 : Money::proportion(max(0, (int) $assessment->earned_centavos - (int) $assessment->credited_centavos), 12, 112);
                $difference = $target - ($originalVat - $creditedVat);
                if ($difference === 0) {
                    return;
                }
                $adjustmentId = DB::table('fee_adjustments')->where('fee_assessment_id', $row->id)->where('kind', 'CREDIT')->orderByDesc('approved_at')->orderByDesc('id')->value('id');
                if ($adjustmentId === null) {
                    return;
                }
                $source = ['FEE_ADJUSTMENT', (string) $adjustmentId];
                $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_CREDIT_VAT_CORRECTION', 'PLATFORM_FEE:CREDIT_VAT_CORRECTION:'.$row->id, [
                    FinancialLedgerService::debit($difference > 0 ? 'FEE_REVENUE' : 'OUTPUT_VAT', abs($difference), ...$source),
                    FinancialLedgerService::credit($difference > 0 ? 'OUTPUT_VAT' : 'FEE_REVENUE', abs($difference), ...$source),
                ], $correlationId);
            });
        });
    }

    private static function creditedVat(string $assessmentId): int
    {
        return (int) DB::table('financial_ledger_entries')->where('source_type', 'FEE_ADJUSTMENT')
            ->whereIn('source_id', DB::table('fee_adjustments')->where('fee_assessment_id', $assessmentId)->select('id'))->where('account_code', 'OUTPUT_VAT')
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'DEBIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS amount")->value('amount');
    }

    /** Posts the PLATFORM_FEE earning batch once per earned assessment, inside the earning transaction. */
    public function postEarning(object $assessment, int $earnedCentavos, string $correlationId): void
    {
        if ($earnedCentavos === 0) {
            return;
        }
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
            $computed = self::creditTarget((int) $assessment->commission_basis_centavos, (int) $assessment->earned_target_centavos, (int) $assessment->credited_centavos, $returnedExclusiveCentavos, (int) $assessment->commission_basis_points);
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
            $computed = self::creditTarget((int) $assessment->commission_basis_centavos, (int) $assessment->earned_target_centavos, (int) $assessment->credited_centavos, (int) $values['returned_exclusive_centavos'], (int) $assessment->commission_basis_points);
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
            $adjustment = DB::table('fee_adjustments')->where('id', $adjustmentId)->first();
            $allocation = app(StatementService::class)->applyCredit($adjustment);
            $originalVat = (int) DB::table('financial_ledger_entries')->where('source_type', 'FEE_ASSESSMENT')->where('source_id', $assessment->id)->where('account_code', 'OUTPUT_VAT')->where('direction', 'CREDIT')->sum('amount_centavos');
            $creditedVat = self::creditedVat((string) $assessment->id);
            $split = self::creditSplit((int) $assessment->earned_centavos, $originalVat, (int) $assessment->credited_centavos, $creditedVat, $computed['credit_centavos']);
            $source = ['FEE_ADJUSTMENT', $adjustmentId];
            $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_CREDIT', 'PLATFORM_FEE:CREDIT:'.$adjustmentId, [
                FinancialLedgerService::debit('FEE_REVENUE', $split['revenue_centavos'], ...$source), FinancialLedgerService::debit('OUTPUT_VAT', $split['vat_centavos'], ...$source),
                FinancialLedgerService::credit('FEE_RECEIVABLE', $computed['credit_centavos'] - $allocation['refund_centavos'], ...$source),
                FinancialLedgerService::credit('FEE_REFUND_PAYABLE', $allocation['refund_centavos'], ...$source),
            ], $correlationId, $approverUserId, 'FINANCE_REVIEWER');
            if ($allocation['refund_centavos'] > 0) {
                // FIN-07 PLATFORM_FEE target: refund through the original fee captures only; never another party's funds.
                $covered = app(RefundService::class)->createFeeCreditRefunds($adjustment, $assessment, $correlationId, $allocation['refund_centavos']);
                if ($covered < $allocation['refund_centavos']) {
                    app(WithholdingThresholdService::class)->reviewItem('TEST', (string) $assessment->vendor_organization_id, 'PAID_FEE_CREDIT_PAYABLE', $adjustmentId, 'CREDIT_ON_PAID_STATEMENT',
                        'A fee credit exceeds the unpaid debt and no supported original fee capture covers ₱'.WithholdingThresholdService::pesos($allocation['refund_centavos'] - $covered).'. Record the audited payable.',
                        ['credit_centavos' => $allocation['refund_centavos'], 'refund_covered_centavos' => $covered], [], 'FEE_ADJUSTMENT');
                }
            }
            DB::table('finance_review_items')->where('id', $proposalId)->update(['state' => 'RESOLVED', 'resolution' => 'Approved as fee adjustment '.$adjustmentId, 'resolved_by_user_id' => $approverUserId, 'resolved_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('FEE_CREDIT_APPROVED', 'FEE_ADJUSTMENT', $adjustmentId, ['fee_adjustment_id' => $adjustmentId, 'credit_centavos' => $computed['credit_centavos']]);

            return $adjustmentId;
        });
    }
}
