<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Read-only FIN-05 register. Assessed tax is not evidence of cash held or paid to BIR. */
final class WithholdingRegister
{
    /** Open work plus unqueued source blockers, without creating or resolving records.
     * @return array{items: array<int, array<string, mixed>>, meta: array<string, mixed>}
     */
    public function issues(Request $request, int $page): array
    {
        app(FinanceAccess::class)->admin($request, 'finance.view');
        $work = DB::table('finance_review_items as i')->leftJoin('vendor_organizations as v', 'v.id', '=', 'i.vendor_organization_id')->where('i.state', 'OPEN')
            ->select(['i.id', 'i.kind', 'i.state', 'i.reason_code', 'i.summary', 'i.vendor_organization_id', 'v.store_name', 'i.source_type', 'i.source_id', 'i.expected', 'i.reported', 'i.created_at']);
        $conditions = [
            'TAX_PROFILE_MISSING' => ['a.tax_profile_version_id IS NULL', 'A payment is missing its saved tax profile. Review the Vendor tax details.'],
            'REPORTING_CODE_MISSING' => ['a.reporting_atc IS NULL', 'A payment is missing its BIR reporting code. Review the Vendor tax details.'],
            'CALCULATION_INCOMPLETE' => ["a.calculation_state <> 'POSTED'", 'A payment calculation needs review before filing.'],
            'RECONCILIATION_EXCEPTION' => ["a.reconciliation_state = 'RECONCILIATION_EXCEPTION'", 'A payment does not match its reconciliation checks.'],
            'TAX_ADJUSTMENT_OPEN' => ["EXISTS (SELECT 1 FROM tax_adjustments t WHERE t.remittance_assessment_id = a.id AND t.state NOT IN ('POSTED', 'REJECTED', 'NOT_REQUIRED'))", 'A withholding correction needs review before filing.'],
        ];
        $reasons = $summaries = [];
        foreach ($conditions as $code => [$condition, $summary]) {
            $reasons[] = "WHEN $condition THEN '$code'";
            $summaries[] = "WHEN $condition THEN '$summary'";
        }
        $sources = DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')->join('vendor_organizations as v', 'v.id', '=', 'o.vendor_organization_id')
            ->where('a.environment', 'TEST')->where('a.calculation_state', '<>', 'VOIDED')
            ->whereRaw('('.implode(' OR ', array_column($conditions, 0)).')')
            ->whereNotExists(fn (Builder $q) => $q->selectRaw('1')->from('finance_review_items as i')->where('i.state', 'OPEN')->whereColumn('i.source_id', 'a.id'))
            ->selectRaw("a.id, 'BASE_REVIEW_REQUIRED' AS kind, 'OPEN' AS state, CASE ".implode(' ', $reasons).' END AS reason_code, CASE '.implode(' ', $summaries)." END AS summary,
                o.vendor_organization_id, v.store_name, 'WITHHOLDING_SOURCE' AS source_type, a.id AS source_id, '{}'::jsonb AS expected, '{}'::jsonb AS reported, a.created_at");
        $rows = DB::query()->fromSub($work->unionAll($sources), 'issues')->orderByDesc('created_at')->orderByDesc('id')->paginate(25, ['*'], 'page', $page);

        return ['items' => array_map(static fn (object $row): array => ['id' => $row->id, 'kind' => $row->kind, 'state' => $row->state, 'reason_code' => $row->reason_code, 'summary' => $row->summary,
            'vendor' => $row->vendor_organization_id === null ? null : ['id' => $row->vendor_organization_id, 'name' => $row->store_name],
            'source_type' => $row->source_type, 'source_id' => $row->source_id, 'expected' => json_decode($row->expected, true) ?: (object) [], 'reported' => json_decode($row->reported, true) ?: (object) [],
            'resolution' => null, 'created_at' => CarbonImmutable::parse($row->created_at)->toIso8601String(), 'resolved_at' => null], $rows->items()),
            'meta' => ['has_more' => $rows->hasMorePages(), 'total' => $rows->total(), 'page' => $rows->currentPage()]];
    }

    /** Read-only payment and declaration context; never re-assesses a posted payment.
     * @return array{data: array<string, mixed>, meta: array<string, mixed>}
     */
    public function vendor(Request $request, string $vendorId, string $month, string $entity, int $page): array
    {
        app(FinanceAccess::class)->admin($request, 'finance.view');
        $vendor = DB::table('vendor_organizations')->where('id', $vendorId)->first(['id', 'store_name']);
        if ($vendor === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This Vendor is unavailable.', 404);
        }
        $start = CarbonImmutable::parse($month.'-01', 'Asia/Manila')->startOfDay();
        $end = $start->addMonth();
        $collections = DB::table('remittance_collections')->select('remittance_group_id')->selectRaw('MIN(collected_at) AS collected_at')->groupBy('remittance_group_id');
        $sources = DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')
            ->joinSub($collections, 'c', 'c.remittance_group_id', '=', 'a.remittance_group_id')
            ->where('o.vendor_organization_id', $vendorId)->where('a.environment', 'TEST')
            ->where('a.assigned_withholding_entity', $entity)->where('a.calculation_state', '<>', 'VOIDED')
            ->where('c.collected_at', '>=', $start->utc())->where('c.collected_at', '<', $end->utc());
        $latest = (clone $sources)->orderByDesc('c.collected_at')->orderByDesc('a.id')->first(['a.*']);
        $asOf = $end->subMicrosecond()->min(CarbonImmutable::now());
        $declaration = null;
        $threshold = null;
        if ($latest !== null) {
            $evidence = DB::table('tax_evidence as e')->join('vendor_tax_profile_versions as p', 'p.id', '=', 'e.vendor_tax_profile_version_id')
                ->where('p.taxpayer_key_hash', $latest->taxpayer_key_hash)->where('e.evidence_type', 'TAX_RELIEF_DECLARATION')
                ->where('e.created_at', '<=', $asOf)->where(fn (Builder $q) => $q->whereNull('p.taxable_year')->orWhere('p.taxable_year', $latest->taxable_year ?? $start->year));
            $approved = (clone $evidence)->where('e.review_state', 'APPROVED')->whereNotNull('e.reviewed_at')->where('e.reviewed_at', '<=', $asOf)
                ->where(fn (Builder $q) => $q->whereNull('e.valid_from')->orWhere('e.valid_from', '<=', $asOf->setTimezone('Asia/Manila')->toDateString()))
                ->where(fn (Builder $q) => $q->whereNull('e.valid_until')->orWhere('e.valid_until', '>=', $asOf->setTimezone('Asia/Manila')->toDateString()))
                ->orderByDesc('e.reviewed_at')->first(['e.*']);
            $declaration = $approved ?? $evidence->orderByDesc('e.created_at')->first(['e.*']);
            if ($approved !== null && $latest->accumulator_id !== null) {
                $accumulator = DB::table('vendor_withholding_accumulators')->where('id', $latest->accumulator_id)->where('environment', 'TEST')->first();
                if ($accumulator !== null) {
                    $threshold = ['taxable_year' => (int) $accumulator->taxable_year, 'total_centavos' => (int) $accumulator->g_effective_centavos,
                        'limit_centavos' => (int) $accumulator->threshold_centavos, 'crossed' => $accumulator->crossed_at !== null,
                        'status' => $accumulator->withholding_status];
                }
            }
        }
        $state = $declaration->review_state ?? 'MISSING';
        if ($declaration !== null && $state === 'APPROVED' && ($declaration->reviewed_at === null || CarbonImmutable::parse($declaration->reviewed_at)->greaterThan($asOf))) {
            $state = 'PENDING';
        }
        if ($declaration !== null && $state === 'APPROVED' && $declaration->valid_until !== null && $declaration->valid_until < $asOf->setTimezone('Asia/Manila')->toDateString()) {
            $state = 'EXPIRED';
        }
        if ($declaration !== null && $state === 'APPROVED' && $declaration->valid_from !== null && $declaration->valid_from > $asOf->setTimezone('Asia/Manila')->toDateString()) {
            $state = 'PENDING';
        }
        $rows = (clone $sources)->orderByDesc('c.collected_at')->orderByDesc('a.id')->paginate(25, ['a.id', 'o.reference as order_reference', 'c.collected_at', 'a.collections_centavos', 'a.gross_basis_centavos', 'a.withheld_centavos', 'a.calculation_state'], 'page', $page);

        return ['data' => ['vendor_id' => $vendorId, 'vendor_name' => $vendor->store_name, 'month' => $month, 'withholding_entity' => $entity,
            'declaration_state' => in_array($state, ['MISSING', 'PENDING', 'APPROVED', 'REJECTED', 'EXPIRED'], true) ? $state : 'PENDING',
            'threshold' => $state === 'APPROVED' ? $threshold : null,
            'payments' => array_map(static fn (object $row): array => ['id' => $row->id, 'order_reference' => $row->order_reference,
                'collected_at' => $row->collected_at, 'amount_centavos' => (int) $row->collections_centavos,
                'taxable_centavos' => $row->calculation_state === 'POSTED' ? (int) $row->gross_basis_centavos : null,
                'tax_centavos' => $row->calculation_state === 'POSTED' ? (int) $row->withheld_centavos : null], $rows->items())],
            'meta' => ['has_more' => $rows->hasMorePages(), 'total' => $rows->total(), 'page' => $rows->currentPage()]];
    }

    /** @return array{data: array<string, mixed>, meta: array<string, mixed>} */
    public function month(Request $request, ?string $month, int $page): array
    {
        app(FinanceAccess::class)->admin($request, 'finance.view');
        $sources = DB::table('remittance_assessments as a')
            ->join('orders as o', 'o.id', '=', 'a.order_id')
            ->join('vendor_organizations as v', 'v.id', '=', 'o.vendor_organization_id')
            ->where('a.environment', 'TEST')->where('a.calculation_state', '<>', 'VOIDED');
        if ($month === null) {
            $latest = (clone $sources)->join('remittance_collections as latest', 'latest.remittance_group_id', '=', 'a.remittance_group_id')->max('latest.collected_at');
            $month = ($latest === null ? CarbonImmutable::now('Asia/Manila') : CarbonImmutable::parse($latest)->setTimezone('Asia/Manila'))->format('Y-m');
        }
        $start = CarbonImmutable::parse($month.'-01', 'Asia/Manila')->startOfDay();
        $end = $start->addMonth();
        $sources->whereExists(fn (Builder $q) => $q->selectRaw('1')->from('remittance_collections as c')
            ->whereColumn('c.remittance_group_id', 'a.remittance_group_id')
            ->where('c.collected_at', '>=', $start->utc())->where('c.collected_at', '<', $end->utc()));

        // Keep original assessments visible; reviewed packages apply linked posted corrections separately.
        $posted = "CASE WHEN a.calculation_state = 'POSTED' THEN a.withheld_centavos ELSE 0 END";
        $issues = [
            'CALCULATION_INCOMPLETE' => "a.calculation_state <> 'POSTED'",
            'RECONCILIATION_EXCEPTION' => "a.reconciliation_state = 'RECONCILIATION_EXCEPTION'",
            'TAX_PROFILE_MISSING' => 'a.tax_profile_version_id IS NULL',
            'REPORTING_CODE_MISSING' => 'a.reporting_atc IS NULL',
            'TAX_ADJUSTMENT_OPEN' => "EXISTS (SELECT 1 FROM tax_adjustments t WHERE t.remittance_assessment_id = a.id
                AND t.state NOT IN ('POSTED', 'REJECTED', 'NOT_REQUIRED'))",
        ];
        $review = 'CASE WHEN '.implode(' OR ', $issues).' THEN 1 ELSE 0 END';
        $totals = (clone $sources)->selectRaw("COUNT(DISTINCT v.id) AS vendors, COUNT(*) AS assessments,
            COALESCE(SUM(CASE WHEN a.assigned_withholding_entity = 'DEMO_PLATFORM_WITHHOLDER' THEN ($posted) ELSE 0 END), 0) AS platform_tax,
            COALESCE(SUM(CASE WHEN a.assigned_withholding_entity = 'DEMO_PROVIDER_WITHHOLDER' THEN ($posted) ELSE 0 END), 0) AS provider_tax,
            COALESCE(SUM($review), 0) AS review_required")->first();
        $rows = (clone $sources)->select(['v.id as vendor_id', 'v.store_name as vendor_name', 'a.assigned_withholding_entity as withholding_entity'])
            ->selectRaw("COUNT(*) AS assessments, COALESCE(SUM($posted), 0) AS withheld_centavos, SUM($review) AS review_required");
        $components = ['collections_centavos', 'refunds_centavos', 'delivery_centavos', 'vat_centavos', 'provider_charge_centavos', 'gross_basis_centavos'];
        foreach ($components as $component) {
            $rows->selectRaw("COALESCE(SUM(CASE WHEN a.calculation_state = 'POSTED' THEN a.$component ELSE 0 END), 0) AS $component");
        }
        $rows->selectRaw("COALESCE(SUM(CASE WHEN a.calculation_state = 'POSTED' AND a.effective_rate_basis_points > 0 THEN a.gross_basis_centavos ELSE 0 END), 0) AS taxable_basis_centavos,
            COALESCE(SUM(CASE WHEN a.calculation_state = 'POSTED' AND a.effective_rate_basis_points = 0 THEN a.gross_basis_centavos ELSE 0 END), 0) AS relieved_basis_centavos");
        foreach (array_values($issues) as $index => $condition) {
            $rows->selectRaw("MAX(CASE WHEN $condition THEN 1 ELSE 0 END) AS issue_$index");
        }
        $rows = $rows->groupBy('v.id', 'v.store_name', 'a.assigned_withholding_entity')->orderBy('v.store_name')->orderBy('v.id')->orderBy('a.assigned_withholding_entity')
            ->paginate(25, ['*'], 'page', $page);

        return ['data' => [
            'month' => $month, 'period_start' => $start->toDateString(), 'period_end' => $end->subDay()->toDateString(),
            'environment' => 'TEST', 'assignment_status' => 'UNCONFIRMED',
            'platform_withheld_centavos' => (int) $totals->platform_tax, 'provider_withheld_centavos' => (int) $totals->provider_tax,
            'vendor_count' => (int) $totals->vendors, 'assessment_count' => (int) $totals->assessments, 'review_required' => (int) $totals->review_required,
            'vendors' => array_map(static function (object $row) use ($components, $issues): array {
                $calculation = [];
                foreach ([...$components, 'taxable_basis_centavos', 'relieved_basis_centavos'] as $component) {
                    $calculation[$component] = (int) $row->{$component};
                }
                $filingIssues = [];
                foreach (array_keys($issues) as $index => $code) {
                    if ((int) $row->{'issue_'.$index} > 0) {
                        $filingIssues[] = $code;
                    }
                }

                return [
                    'vendor_id' => (string) $row->vendor_id, 'vendor_name' => (string) $row->vendor_name,
                    'withholding_entity' => (string) $row->withholding_entity, 'assessment_count' => (int) $row->assessments,
                    'withheld_centavos' => (int) $row->withheld_centavos, 'review_required' => (int) $row->review_required,
                    'calculation' => $calculation, 'filing_issues' => $filingIssues,
                ];
            }, $rows->items()),
        ], 'meta' => ['has_more' => $rows->hasMorePages(), 'total' => $rows->total(), 'page' => $rows->currentPage()]];
    }
}
