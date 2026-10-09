<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * FIN-10 Admin finance queues and KPIs (DEMO — No real funds or BIR filing). Gross and net GMV are shown beside, and
 * never combined with, assessed CWT, commission, platform revenue, collected cash and receivables: a CWT amount is never
 * platform revenue and a collected fee is not counted as revenue again after its EARNED posting. The remittance and
 * evidence queues are read projections that link to the existing decision points (finance review items, overlap
 * resolution, Vendor Verification review); they add no second approval engine. Taxpayer identifiers stay masked.
 */
final class FinanceOperationsService
{
    private const PER_PAGE = 25;

    public function __construct(private readonly FinanceAccess $access) {}

    /** @return array<string, mixed> */
    public function kpis(Request $request, ?string $from = null, ?string $to = null): array
    {
        $this->access->admin($request, 'finance.view');
        $end = CarbonImmutable::parse($to ?? CarbonImmutable::now('Asia/Manila')->toDateString(), 'Asia/Manila')->endOfDay();
        $start = CarbonImmutable::parse($from ?? $end->subDays(29)->toDateString(), 'Asia/Manila')->startOfDay();
        $utc = [$start->setTimezone('UTC'), $end->setTimezone('UTC')];
        $gmv = DB::table('analytics_order_facts')->where('environment', 'TEST')->whereBetween('confirmed_on', [$start->toDateString(), $end->toDateString()])
            ->selectRaw('COALESCE(SUM(gross_value_centavos), 0) AS gross, COALESCE(SUM(net_value_centavos), 0) AS net')->first();
        $cwt = DB::table('remittance_assessments')->where('calculation_state', 'POSTED')->whereBetween('created_at', $utc)
            ->selectRaw('COALESCE(SUM(withheld_centavos), 0) AS assessed, COALESCE(SUM(reported_withheld_centavos), 0) AS reported')->first();
        $earned = DB::table('fee_assessments')->where('state', 'EARNED')->whereBetween('earned_at', $utc)->selectRaw('COALESCE(SUM(earned_centavos), 0) AS earned, COALESCE(SUM(credited_centavos), 0) AS credited')->first();
        $revenue = DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)->where('account_code', 'FEE_REVENUE')->whereBetween('occurred_at', $utc)
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'CREDIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS revenue")->value('revenue');
        $feeVat = DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)->where('account_code', 'OUTPUT_VAT')->whereBetween('occurred_at', $utc)
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'CREDIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS vat")->value('vat');
        $statements = DB::table('fee_statements')->whereIn('state', ['ISSUED', 'PARTIALLY_PAID', 'PAID'])
            ->selectRaw('COALESCE(SUM(charges_centavos - credits_centavos), 0) AS billed, COALESCE(SUM(paid_centavos), 0) AS collected, COALESCE(SUM(outstanding_centavos), 0) AS receivable,
                COALESCE(SUM(outstanding_centavos) FILTER (WHERE due_on < ?), 0) AS overdue', [CarbonImmutable::now('Asia/Manila')->toDateString()])->first();
        $item = static fn (string $key, string $label, int $value, string $definition): array => ['key' => $key, 'label' => $label, 'value_centavos' => $value, 'definition' => $definition];

        return ['label' => 'DEMO — No real funds or BIR filing', 'scenario' => 'DEMO_PLATFORM_WITHHOLDER — simulation; production responsibility UNCONFIRMED',
            'period' => ['from' => $start->toDateString(), 'to' => $end->toDateString()],
            'commerce' => [
                $item('gross_gmv', 'Gross GMV', (int) $gmv->gross, 'Confirmed order value before cancellations and refunds, excluding the Buyer processing fee (TEST marketplace facts).'),
                $item('net_gmv', 'Net GMV', (int) $gmv->net, 'Gross GMV less cancelled and refunded commercial value.'),
            ],
            'finance' => [
                $item('assessed_cwt', 'Assessed CWT (simulated)', (int) $cwt->assessed, 'Posted FIN-05 withholding W. Never platform revenue and never subtracted from GMV.'),
                $item('reported_deductions', 'Provider-reported deductions', (int) $cwt->reported, 'Imported simulated deductions reconciled against assessments; never a second deduction.'),
                $item('earned_commission', 'Earned commission', (int) $earned->earned, '2% of completed materials value after discounts, excluding materials VAT, earned only at COMPLETED.'),
                $item('fee_credits', 'Approved fee credits', (int) $earned->credited, 'Reviewed fee credits for refunded completed materials.'),
                $item('platform_revenue', 'Platform revenue (fee, ex-VAT)', (int) $revenue, 'FEE_REVENUE postings net of credits. Collected payments are not counted again.'),
                $item('fee_vat', 'Output VAT on fees', (int) $feeVat, 'VAT portion of earned fees, separate from revenue.'),
                $item('billed', 'Issued commission bills', (int) $statements->billed, 'Approved statement charges less credits.'),
                $item('collected', 'Collected fee payments', (int) $statements->collected, 'Verified platform-fee payments (TEST).'),
                $item('receivables', 'Outstanding receivables', (int) $statements->receivable, 'Issued, unpaid statement balances. A late fee is a receivable task, never a Buyer cancellation or withheld refund.'),
                $item('overdue', 'Overdue receivables', (int) $statements->overdue, 'Outstanding balances past their due date.'),
            ],
            'counts' => ['unreconciled_remittances' => DB::table('remittance_assessments')->where('reconciliation_state', 'RECONCILIATION_EXCEPTION')->count(),
                'pending_certificates' => DB::table('tax_certificates')->where('verification_state', '<>', 'VERIFIED')->count(),
                'draft_statements' => DB::table('fee_statements')->where('state', 'DRAFT')->count(),
                'open_tax_adjustments' => DB::table('tax_adjustments')->whereIn('state', ['ADJUSTMENT_REQUIRED', 'UNDER_REVIEW', 'APPROVED'])->count()]];
    }

    /**
     * Remittance reconciliation queue: FIN-05 components, threshold before/after and the separate deduction-evidence
     * and reconciliation states. Exceptions are resolved through their finance work item.
     *
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function remittances(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('remittance_assessments as r')->join('orders as o', 'o.id', '=', 'r.order_id')->join('vendor_organizations as v', 'v.id', '=', 'o.vendor_organization_id')
            ->when($filters['reconciliation_state'] ?? null, fn (Builder $q, string $state) => $q->where('r.reconciliation_state', $state))
            ->when($filters['calculation_state'] ?? null, fn (Builder $q, string $state) => $q->where('r.calculation_state', $state))
            ->when($filters['deduction_evidence_state'] ?? null, fn (Builder $q, string $state) => $q->where('r.deduction_evidence_state', $state));
        $total = (clone $query)->count();
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        $rows = $query->orderByRaw("CASE r.reconciliation_state WHEN 'RECONCILIATION_EXCEPTION' THEN 0 WHEN 'PENDING' THEN 1 ELSE 2 END")->orderByDesc('r.created_at')
            ->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['r.*', 'o.reference', 'v.store_name']);

        return ['items' => $rows->map(static fn (object $row): array => ['id' => (string) $row->id, 'order_reference' => (string) $row->reference, 'vendor_name' => (string) $row->store_name,
            'environment' => (string) $row->environment, 'taxpayer_key_suffix' => substr((string) $row->taxpayer_key_hash, -6), 'scenario' => $row->withholding_scenario,
            'components' => ['collections_centavos' => (int) $row->collections_centavos, 'refunds_centavos' => (int) $row->refunds_centavos, 'discounts_refunded_centavos' => (int) $row->discounts_refunded_centavos,
                'vat_refunded_centavos' => (int) $row->vat_refunded_centavos, 'provider_charge_centavos' => (int) $row->provider_charge_centavos, 'gross_basis_centavos' => (int) $row->gross_basis_centavos,
                'withheld_centavos' => (int) $row->withheld_centavos, 'reported_withheld_centavos' => $row->reported_withheld_centavos === null ? null : (int) $row->reported_withheld_centavos],
            'threshold_status_before' => $row->threshold_status_before, 'threshold_status_after' => $row->threshold_status_after,
            'g_effective_before_centavos' => $row->g_effective_before_centavos === null ? null : (int) $row->g_effective_before_centavos,
            'g_effective_after_centavos' => $row->g_effective_after_centavos === null ? null : (int) $row->g_effective_after_centavos,
            'calculation_state' => (string) $row->calculation_state, 'deduction_evidence_state' => (string) $row->deduction_evidence_state, 'reconciliation_state' => (string) $row->reconciliation_state,
            'review_item_id' => DB::table('finance_review_items')->where('source_id', $row->id)->where('state', 'OPEN')->value('id'), 'reason' => (string) $row->assessment_reason,
            'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String()])->all(),
            'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total, 'label' => 'DEMO — No real funds or BIR filing']];
    }

    /**
     * Tax evidence queue (relief declarations and other FIN-04 evidence) with its review state. The decision itself is
     * made in the Vendor Verification case by authorized reviewers; this view links there.
     *
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function evidence(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('tax_evidence as e')->join('vendor_tax_profile_versions as tv', 'tv.id', '=', 'e.vendor_tax_profile_version_id')
            ->join('vendor_tax_profiles as p', 'p.id', '=', 'tv.vendor_tax_profile_id')->join('vendor_organizations as v', 'v.id', '=', 'p.vendor_organization_id')
            ->when($filters['review_state'] ?? null, fn (Builder $q, string $state) => $q->where('e.review_state', $state));
        $total = (clone $query)->count();
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        $rows = $query->orderByRaw("CASE e.review_state WHEN 'PENDING' THEN 0 ELSE 1 END")->orderBy('e.created_at')->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)
            ->get(['e.id', 'e.evidence_type', 'e.origin', 'e.valid_from', 'e.valid_until', 'e.review_state', 'e.reviewed_at', 'e.created_at', 'tv.version', 'tv.taxable_year', 'v.id as organization_id', 'v.store_name']);

        return ['items' => $rows->map(static fn (object $row): array => ['id' => (string) $row->id, 'evidence_type' => (string) $row->evidence_type, 'origin' => (string) $row->origin,
            'valid_from' => $row->valid_from, 'valid_until' => $row->valid_until, 'review_state' => (string) $row->review_state, 'reviewed_at' => $row->reviewed_at === null ? null : CarbonImmutable::parse((string) $row->reviewed_at)->toIso8601String(),
            'tax_profile_version' => (int) $row->version, 'taxable_year' => $row->taxable_year === null ? null : (int) $row->taxable_year, 'vendor' => ['id' => (string) $row->organization_id, 'name' => (string) $row->store_name],
            'decision_href' => '/vendor-verification/'.$row->organization_id, 'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String(),
            'note' => 'A declaration intention is not relief. Missing optional relief evidence applies standard withholding.'])->all(),
            'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total]];
    }
}
