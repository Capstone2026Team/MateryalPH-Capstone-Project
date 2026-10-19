<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Support\PortalDateRange;
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

    /** Platform earnings ranges up to this many days are charted by day, longer ones by month. */
    private const TREND_DAILY_MAX_DAYS = 92;

    public function __construct(private readonly FinanceAccess $access) {}

    /** @return array<string, mixed> */
    public function kpis(Request $request, ?string $from = null, ?string $to = null): array
    {
        $this->access->admin($request, 'finance.view');
        $filters = array_filter(['from' => $from, 'to' => $to], static fn (?string $date): bool => $date !== null);
        $gmv = PortalDateRange::apply(DB::table('analytics_order_facts')->where('environment', 'TEST'), 'confirmed_on', $filters, true)
            ->selectRaw('COALESCE(SUM(gross_value_centavos), 0) AS gross, COALESCE(SUM(net_value_centavos), 0) AS net')->first();
        $cwt = PortalDateRange::apply(DB::table('remittance_assessments')->where('calculation_state', 'POSTED'), 'created_at', $filters)
            ->selectRaw('COALESCE(SUM(withheld_centavos), 0) AS assessed, COALESCE(SUM(reported_withheld_centavos), 0) AS reported')->first();
        $earned = PortalDateRange::apply(CommissionService::movements(), 'occurred_at', $filters)
            ->selectRaw("COALESCE(SUM(CASE WHEN kind = 'EARNED' THEN amount_centavos ELSE 0 END), 0) AS earned,
                COALESCE(SUM(CASE WHEN kind = 'CREDIT' THEN -amount_centavos ELSE 0 END), 0) AS credited")->first();
        $revenue = PortalDateRange::apply(DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)->where('account_code', 'FEE_REVENUE'), 'occurred_at', $filters)
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'CREDIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS revenue")->value('revenue');
        $feeVat = PortalDateRange::apply(DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)->where('account_code', 'OUTPUT_VAT'), 'occurred_at', $filters)
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'CREDIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS vat")->value('vat');
        $statements = PortalDateRange::apply(DB::table('fee_statements')->whereIn('state', ['ISSUED', 'PARTIALLY_PAID', 'PAID']), 'issued_on', $filters, true)
            ->selectRaw("COALESCE(SUM(GREATEST(0, charges_centavos - credits_centavos)), 0) AS billed, COALESCE(SUM(outstanding_centavos), 0) AS receivable,
                COALESCE(SUM(outstanding_centavos) FILTER (WHERE state IN ('ISSUED', 'PARTIALLY_PAID') AND due_on < ?), 0) AS overdue", [CarbonImmutable::now('Asia/Manila')->toDateString()])->first();
        $collected = (int) PortalDateRange::apply($this->collections(), 'a.allocated_at', $filters)->sum('a.amount_centavos');
        $refunded = (int) PortalDateRange::apply($this->feeRefunds(), 'completed_at', $filters)->sum('amount_centavos');
        $processing = (int) PortalDateRange::apply(DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)->where('account_code', 'PLATFORM_PROCESSING_EXPENSE'), 'occurred_at', $filters)
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'DEBIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS expense")->value('expense');
        $unbilled = (int) PortalDateRange::apply(DB::table('fee_assessments')->where('state', 'EARNED')->whereNull('billed_at'), 'earned_at', $filters)
            ->selectRaw('COALESCE(SUM(GREATEST(0, earned_centavos - credited_centavos)), 0) AS amount')->value('amount');
        $draft = (int) PortalDateRange::apply(DB::table('fee_statements')->where('state', 'DRAFT'), 'issued_on', $filters, true)->sum('outstanding_centavos');
        $item = static fn (string $key, string $label, int $value, string $definition): array => ['key' => $key, 'label' => $label, 'value_centavos' => $value, 'definition' => $definition];
        $trend = $this->trend($filters);

        return ['label' => 'Recorded transactions', 'scenario' => 'Earnings and cash use event dates; debt uses statement issue dates and current balances. Dates are Asia/Manila.',
            'period' => ['from' => $from, 'to' => $to],
            'commerce' => [
                $item('gross_gmv', 'Gross GMV', (int) $gmv->gross, 'Confirmed order value before cancellations and refunds, excluding the Buyer processing fee (TEST marketplace facts).'),
                $item('net_gmv', 'Net GMV', (int) $gmv->net, 'Gross GMV less cancelled and refunded commercial value.'),
            ],
            'finance' => [
                $item('assessed_cwt', 'Assessed CWT (simulated)', (int) $cwt->assessed, 'Posted FIN-05 withholding W. Never platform revenue and never subtracted from GMV.'),
                $item('reported_deductions', 'Provider-reported deductions', (int) $cwt->reported, 'Imported simulated deductions reconciled against assessments; never a second deduction.'),
                $item('earned_commission', 'Total commission earned', (int) $earned->earned, 'Commission at each order’s saved rate, earned at completion in this period before approved credits. Materials after discounts, excluding materials VAT.'),
                $item('fee_credits', 'Approved commission credits', (int) $earned->credited, 'Commission reversals approved in this period. Reduce earnings once, whether unpaid or owed back to the Vendor.'),
                $item('net_commission', 'Net commission earned', (int) $earned->earned - (int) $earned->credited, 'Earnings less approved credits, using the same signed commission movements as Vendor Earnings.'),
                $item('platform_revenue', 'Commission revenue, excluding VAT', (int) $revenue, 'Posted fee revenue after approved credits. Payment collection and refund settlement never recognize revenue again.'),
                $item('processing_expense', 'Platform processing costs', $processing, 'Recorded charges on platform commission payments; Buyer processing fees are separate.'),
                $item('net_platform_earnings', 'Net platform earnings', (int) $revenue - $processing, 'Posted commission revenue after credits and fee VAT, less recorded platform commission payment processing costs.'),
                $item('fee_vat', 'Output VAT on fees', (int) $feeVat, 'VAT portion of earned fees, separate from revenue.'),
                $item('billed', 'Issued commission bills', (int) $statements->billed, 'Approved statement charges less credits.'),
                $item('collected', 'Collected commissions', $collected, 'Verified payments allocated once to commission bills, by collection date. Excludes failed attempts, late captures and unallocated overpayments.'),
                $item('refunded_commissions', 'Refunded commissions', $refunded, 'Confirmed returns of collected commissions, by successful refund date. Pending and failed refunds remain unpaid refund obligations.'),
                $item('net_collected', 'Net collected commissions', $collected - $refunded, 'Collected commission payments less confirmed fee refunds; a cash figure, separate from earned revenue.'),
                $item('pending_commissions', 'Pending commissions', $unbilled + $draft + (int) $statements->receivable, 'Current unpaid earned fees: unbilled earnings, draft bills and issued balances in the selected earning/issue periods. Approved credits are removed.'),
                $item('receivables', 'Outstanding receivables', (int) $statements->receivable, 'Issued, unpaid statement balances. A late fee is a receivable task, never a Buyer cancellation or withheld refund.'),
                $item('overdue', 'Overdue receivables', (int) $statements->overdue, 'Outstanding balances past their due date.'),
            ],
            'counts' => ['unreconciled_remittances' => DB::table('remittance_assessments')->where('reconciliation_state', 'RECONCILIATION_EXCEPTION')->count(),
                'pending_certificates' => DB::table('tax_certificates')->where('verification_state', '<>', 'VERIFIED')->count(),
                'draft_statements' => DB::table('fee_statements')->where('state', 'DRAFT')->count(),
                'pending_commission_credits' => DB::table('finance_review_items')->where('kind', 'FEE_CREDIT_PROPOSAL')->where('state', 'OPEN')->count(),
                'open_tax_adjustments' => DB::table('tax_adjustments')->whereIn('state', ['ADJUSTMENT_REQUIRED', 'UNDER_REVIEW', 'APPROVED'])->count()],
            'trend' => $trend['points'], 'trend_granularity' => $trend['granularity']];
    }

    private function collections(): Builder
    {
        return CommissionService::collections();
    }

    private function feeRefunds(): Builder
    {
        return CommissionService::feeRefunds();
    }

    /** @param array<string, mixed> $filters */
    private function trendQuery(array $filters): Builder
    {
        $commission = PortalDateRange::apply(CommissionService::movements(), 'occurred_at', $filters)
            ->selectRaw("occurred_at, CASE WHEN kind = 'EARNED' THEN amount_centavos ELSE 0 END AS earned_centavos,
                CASE WHEN kind = 'CREDIT' THEN -amount_centavos ELSE 0 END AS credits_centavos, 0::bigint AS collected_centavos, 0::bigint AS refunded_centavos, 0::bigint AS revenue_centavos, 0::bigint AS processing_centavos");
        $collections = PortalDateRange::apply($this->collections(), 'a.allocated_at', $filters)
            ->selectRaw('a.allocated_at AS occurred_at, 0, 0, a.amount_centavos, 0, 0, 0');
        $refunds = PortalDateRange::apply($this->feeRefunds(), 'completed_at', $filters)
            ->selectRaw('completed_at AS occurred_at, 0, 0, 0, amount_centavos, 0, 0');
        $ledger = PortalDateRange::apply(DB::table('financial_ledger_entries')->where('ledger', FinancialLedgerService::PLATFORM_FEE)
            ->whereIn('account_code', ['FEE_REVENUE', 'PLATFORM_PROCESSING_EXPENSE']), 'occurred_at', $filters)
            ->selectRaw("occurred_at, 0, 0, 0, 0,
                CASE WHEN account_code = 'FEE_REVENUE' THEN CASE WHEN direction = 'CREDIT' THEN amount_centavos ELSE -amount_centavos END ELSE 0 END,
                CASE WHEN account_code = 'PLATFORM_PROCESSING_EXPENSE' THEN CASE WHEN direction = 'DEBIT' THEN amount_centavos ELSE -amount_centavos END ELSE 0 END");

        return DB::query()->fromSub($commission->unionAll($collections)->unionAll($refunds)->unionAll($ledger), 'movements');
    }

    /**
     * Movements bucketed by Asia/Manila day when the recorded range spans at most 92 days (empty days filled with zero so
     * the chart keeps an even time axis), otherwise by calendar month (recorded months only, most recent 120).
     *
     * @param  array<string, mixed>  $filters
     * @return array{granularity: string, points: list<array<string, int|string>>}
     */
    private function trend(array $filters): array
    {
        $local = "(occurred_at AT TIME ZONE 'Asia/Manila')::date";
        $bounds = $this->trendQuery($filters)->selectRaw("MIN({$local}) AS first_day, MAX({$local}) AS last_day")->first();
        $start = isset($filters['from']) ? CarbonImmutable::parse((string) $filters['from'], 'Asia/Manila')->startOfDay() : ($bounds->first_day === null ? null : CarbonImmutable::parse((string) $bounds->first_day, 'Asia/Manila'));
        $end = isset($filters['to']) ? CarbonImmutable::parse((string) $filters['to'], 'Asia/Manila')->startOfDay() : ($bounds->last_day === null ? null : CarbonImmutable::parse((string) $bounds->last_day, 'Asia/Manila'));
        $daily = $start !== null && $end !== null && $start->lessThanOrEqualTo($end) && (int) $start->diffInDays($end) + 1 <= self::TREND_DAILY_MAX_DAYS;
        $bucket = $daily ? $local : "date_trunc('month', occurred_at AT TIME ZONE 'Asia/Manila')::date";

        $rows = $this->trendQuery($filters)->selectRaw("{$bucket} AS period, SUM(earned_centavos) AS earned_centavos, SUM(credits_centavos) AS credits_centavos,
            SUM(collected_centavos) AS collected_centavos, SUM(refunded_centavos) AS refunded_centavos, SUM(revenue_centavos - processing_centavos) AS net_earnings_centavos")
            ->groupByRaw($bucket)->orderByDesc('period')->limit(120)->get()->reverse()->values()->map(static fn (object $row): array => [
                'period' => (string) $row->period, 'earned_centavos' => (int) $row->earned_centavos, 'credits_centavos' => (int) $row->credits_centavos,
                'collected_centavos' => (int) $row->collected_centavos, 'refunded_centavos' => (int) $row->refunded_centavos, 'net_earnings_centavos' => (int) $row->net_earnings_centavos,
            ])->keyBy('period');
        if (! $daily) {
            return ['granularity' => 'MONTH', 'points' => $rows->values()->all()];
        }

        $zero = ['earned_centavos' => 0, 'credits_centavos' => 0, 'collected_centavos' => 0, 'refunded_centavos' => 0, 'net_earnings_centavos' => 0];
        $points = [];
        for ($cursor = $start; $cursor->lessThanOrEqualTo($end); $cursor = $cursor->addDay()) {
            $points[] = ['period' => $cursor->toDateString()] + ($rows->get($cursor->toDateString()) ?? $zero);
        }

        return ['granularity' => 'DAY', 'points' => $points];
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
        PortalDateRange::apply($query, 'r.created_at', $filters);
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
        PortalDateRange::apply($query, 'e.created_at', $filters);
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
