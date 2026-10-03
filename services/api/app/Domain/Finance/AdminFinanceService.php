<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\PaymentChannelCatalog;
use App\Domain\Payments\PaymentPresenter;
use App\Domain\Payments\PaymentReconciliationService;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Admin finance APIs on the existing finance.* permissions: the payment log, the finance work queue (reconciliation
 * exceptions, payment mismatches, late captures, unresolved overlap, threshold adjustments, base reviews, overdue
 * statements, fee-credit proposals), FIN-04A accumulators with their status history, statements and the TEST
 * channel fee schedule. Review decisions keep preparer and reviewer distinct. Raw TINs never appear; the masked
 * value and the taxpayer key suffix are shown instead.
 */
final class AdminFinanceService
{
    public const PER_PAGE = 25;

    public function __construct(
        private readonly FinanceAccess $access,
        private readonly WithholdingThresholdService $threshold,
        private readonly StatementService $statements,
        private readonly CommissionService $commission,
        private readonly PaymentChannelCatalog $channels,
        private readonly PaymentPresenter $presenter,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function payments(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('payments as p')->leftJoin('orders as o', 'o.id', '=', 'p.order_id')->leftJoin('fee_statements as s', 's.id', '=', 'p.fee_statement_id')
            ->leftJoin('vendor_organizations as v', 'v.id', '=', 'p.vendor_organization_id')
            ->when($filters['state'] ?? null, fn (Builder $q, string $state) => $q->where('p.state', $state))
            ->when($filters['purpose'] ?? null, fn (Builder $q, string $purpose) => $q->where('p.purpose', $purpose))
            ->when($filters['evidence_origin'] ?? null, fn (Builder $q, string $origin) => $q->where('p.evidence_origin', $origin))
            ->when($filters['reconciliation_state'] ?? null, fn (Builder $q, string $state) => $q->where('p.reconciliation_state', $state))
            ->orderByDesc('p.created_at')->select(['p.*', 'o.reference as order_reference', 's.statement_reference', 'v.store_name']);

        return $this->page($query, (int) ($filters['page'] ?? 1), fn (object $row): array => $this->presenter->attempt($row, false) + [
            'reference' => (string) ($row->order_reference ?? $row->statement_reference ?? ''), 'vendor_name' => (string) ($row->store_name ?? ''),
            'reconciliation_state' => (string) $row->reconciliation_state, 'gateway_mode' => (string) $row->gateway_mode, 'late_capture' => (bool) $row->late_capture,
            'account_scope' => (string) $row->account_scope, 'provider_session_reference' => $row->provider_session_id === null ? null : '…'.substr((string) $row->provider_session_id, -6),
        ]);
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function reviewItems(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('finance_review_items as i')->leftJoin('vendor_organizations as v', 'v.id', '=', 'i.vendor_organization_id')
            ->where('i.state', $filters['state'] ?? 'OPEN')->when($filters['kind'] ?? null, fn (Builder $q, string $kind) => $q->where('i.kind', $kind))
            ->orderByDesc('i.created_at')->select(['i.*', 'v.store_name']);

        return $this->page($query, (int) ($filters['page'] ?? 1), static fn (object $row): array => [
            'id' => (string) $row->id, 'kind' => (string) $row->kind, 'state' => (string) $row->state, 'reason_code' => (string) $row->reason_code, 'summary' => (string) $row->summary,
            'vendor' => $row->vendor_organization_id === null ? null : ['id' => (string) $row->vendor_organization_id, 'name' => (string) ($row->store_name ?? '')],
            'source_type' => (string) $row->source_type, 'source_id' => (string) $row->source_id, 'expected' => json_decode((string) $row->expected, true) ?: (object) [],
            'reported' => json_decode((string) $row->reported, true) ?: (object) [], 'resolution' => $row->resolution, 'created_at' => self::iso($row->created_at), 'resolved_at' => self::iso($row->resolved_at),
        ]);
    }

    public function resolveItem(Request $request, string $itemId, string $resolution): void
    {
        $adminId = $this->access->admin($request, 'finance.record_external_evidence');
        DB::transaction(function () use ($request, $itemId, $resolution, $adminId): void {
            $item = DB::table('finance_review_items')->where('id', Str::isUuid($itemId) ? $itemId : '00000000-0000-0000-0000-000000000000')->lockForUpdate()->first();
            if ($item === null || $item->state !== 'OPEN') {
                throw new AuthenticationException('REVIEW_ITEM_NOT_OPEN', 'This finance work item is not open.', 409);
            }
            if (in_array($item->kind, ['FEE_CREDIT_PROPOSAL', 'OVERLAP_UNRESOLVED'], true)) {
                throw new AuthenticationException('REVIEW_ITEM_NEEDS_DECISION', 'Resolve this item through its approval or overlap decision.', 409);
            }
            DB::table('finance_review_items')->where('id', $itemId)->update(['state' => 'RESOLVED', 'resolution' => mb_substr($resolution, 0, 2000), 'resolved_by_user_id' => $adminId, 'resolved_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'FINANCE_REVIEW_ITEM_RESOLVED', 'FINANCE_REVIEW_ITEM', $itemId, after: ['kind' => $item->kind, 'reason_code' => $item->reason_code]);
        });
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function accumulators(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('vendor_withholding_accumulators as a')->join('vendor_organizations as v', 'v.id', '=', 'a.organization_id')
            ->when($filters['status'] ?? null, fn (Builder $q, string $status) => $q->where('a.withholding_status', $status))
            ->when($filters['taxable_year'] ?? null, fn (Builder $q, int|string $year) => $q->where('a.taxable_year', (int) $year))
            ->orderByDesc('a.updated_at')->select(['a.*', 'v.store_name']);

        return $this->page($query, (int) ($filters['page'] ?? 1), fn (object $row): array => $this->accumulatorView($row));
    }

    /** @return array<string, mixed> */
    public function accumulator(Request $request, string $accumulatorId): array
    {
        $this->access->admin($request, 'finance.view');
        $row = Str::isUuid($accumulatorId) ? DB::table('vendor_withholding_accumulators as a')->join('vendor_organizations as v', 'v.id', '=', 'a.organization_id')->where('a.id', $accumulatorId)->first(['a.*', 'v.store_name']) : null;
        if ($row === null) {
            throw new AuthenticationException('ACCUMULATOR_NOT_FOUND', 'This withholding record is unavailable.', 404);
        }
        $profile = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as tv', 'tv.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $row->organization_id)
            ->first(['tv.tin_last4', 'tv.taxpayer_key_last4', 'tv.tax_details', 'tv.taxable_year']);
        $details = is_string($profile?->tax_details) ? (json_decode($profile->tax_details, true) ?: []) : [];

        return $this->accumulatorView($row) + [
            'tax_profile' => ['tin_masked' => $profile?->tin_last4 === null ? null : '•••-•••-'.substr((string) $profile->tin_last4, -3), 'taxpayer_key_suffix' => $profile?->taxpayer_key_last4,
                'declaration_year' => $details['declaration_year'] ?? $profile?->taxable_year, 'receipt_reference_present' => ! empty($details['receipt_reference']),
                'outside_platform_scope' => $details['outside_platform_period'] ?? null, 'outside_platform_as_of' => $details['outside_platform_as_of'] ?? null],
            'events' => DB::table('vendor_withholding_status_events')->where('accumulator_id', $row->id)->orderBy('occurred_at')->get()
                ->map(static fn (object $event): array => ['from_status' => $event->from_status, 'to_status' => (string) $event->to_status, 'reason_code' => (string) $event->reason_code,
                    'g_before_centavos' => (int) $event->g_before_centavos, 'g_after_centavos' => (int) $event->g_after_centavos, 'actor_type' => (string) $event->actor_type,
                    'assessment_id' => $event->assessment_id, 'evidence_id' => $event->evidence_id, 'occurred_at' => self::iso($event->occurred_at)])->all(),
            'assessments' => DB::table('remittance_assessments as r')->join('orders as o', 'o.id', '=', 'r.order_id')->where('r.accumulator_id', $row->id)->orderByDesc('r.created_at')->limit(50)
                ->get(['r.id', 'o.reference', 'r.gross_basis_centavos', 'r.withheld_centavos', 'r.threshold_status_before', 'r.threshold_status_after', 'r.g_effective_before_centavos',
                    'r.g_effective_after_centavos', 'r.calculation_state', 'r.deduction_evidence_state', 'r.reconciliation_state', 'r.created_at'])
                ->map(static fn (object $a): array => ['id' => (string) $a->id, 'order_reference' => (string) $a->reference, 'gross_basis_centavos' => (int) $a->gross_basis_centavos,
                    'withheld_centavos' => (int) $a->withheld_centavos, 'threshold_status_before' => $a->threshold_status_before, 'threshold_status_after' => $a->threshold_status_after,
                    'g_effective_before_centavos' => (int) $a->g_effective_before_centavos, 'g_effective_after_centavos' => (int) $a->g_effective_after_centavos,
                    'calculation_state' => (string) $a->calculation_state, 'deduction_evidence_state' => (string) $a->deduction_evidence_state, 'reconciliation_state' => (string) $a->reconciliation_state,
                    'created_at' => self::iso($a->created_at)])->all(),
        ];
    }

    /**
     * @param  array{overlap_centavos: int, lock_version: int, reason: string}  $input
     * @return array<string, mixed>
     */
    public function resolveOverlap(Request $request, string $accumulatorId, array $input): array
    {
        $adminId = $this->access->admin($request, 'finance.review_tax');
        $this->threshold->resolveOverlap($accumulatorId, (int) $input['overlap_centavos'], (int) $input['lock_version'], $adminId, $input['reason'], (string) ($request->attributes->get('correlation_id') ?? Str::uuid7()));
        $this->audit->account($request, 'WITHHOLDING_OVERLAP_RESOLVED', 'WITHHOLDING_ACCUMULATOR', $accumulatorId, after: ['overlap_centavos' => (int) $input['overlap_centavos']], reason: $input['reason']);

        return $this->accumulator($request, $accumulatorId);
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function statementsList(Request $request, array $filters): array
    {
        $this->access->admin($request, 'finance.view');
        $query = DB::table('fee_statements as s')->join('vendor_organizations as v', 'v.id', '=', 's.vendor_organization_id')
            ->when($filters['state'] ?? null, fn (Builder $q, string $state) => $q->where('s.state', $state))->orderByDesc('s.period_start')->orderByDesc('s.created_at')->select(['s.*', 'v.store_name']);

        return $this->page($query, (int) ($filters['page'] ?? 1), static fn (object $row): array => VendorFinanceService::statementView($row) + ['vendor_name' => (string) $row->store_name,
            'line_count' => DB::table('fee_statement_lines')->where('fee_statement_id', $row->id)->count(), 'approved_at' => self::iso($row->approved_at)]);
    }

    public function draftStatements(Request $request): int
    {
        $this->access->admin($request, 'finance.approve_statements');

        return $this->statements->draftMonthly(CarbonImmutable::now());
    }

    /** @return array<string, mixed> */
    public function approveStatement(Request $request, string $statementId, int $lockVersion): array
    {
        $adminId = $this->access->admin($request, 'finance.approve_statements');
        $statement = $this->statements->approve($statementId, $adminId, $lockVersion);
        $this->audit->account($request, 'FEE_STATEMENT_APPROVED', 'FEE_STATEMENT', $statementId, after: ['state' => $statement->state, 'due_on' => $statement->due_on]);

        return VendorFinanceService::statementView($statement);
    }

    /** @param array{fee_assessment_id: string, returned_exclusive_centavos: int, reason: string} $input */
    public function proposeFeeCredit(Request $request, array $input): string
    {
        $adminId = $this->access->admin($request, 'finance.review_tax');
        $id = $this->commission->proposeCredit($input['fee_assessment_id'], (int) $input['returned_exclusive_centavos'], $input['reason'], $adminId);
        $this->audit->account($request, 'FEE_CREDIT_PROPOSED', 'FINANCE_REVIEW_ITEM', $id, after: ['fee_assessment_id' => $input['fee_assessment_id']]);

        return $id;
    }

    public function approveFeeCredit(Request $request, string $proposalId): string
    {
        $adminId = $this->access->admin($request, 'finance.approve_statements');
        $id = $this->commission->approveCredit($proposalId, $adminId, (string) ($request->attributes->get('correlation_id') ?? Str::uuid7()));
        $this->audit->account($request, 'FEE_CREDIT_APPROVED', 'FEE_ADJUSTMENT', $id);

        return $id;
    }

    /** @return list<array<string, mixed>> */
    public function channelFees(Request $request): array
    {
        $this->access->admin($request, 'finance.view');

        return array_map(static fn (object $row): array => ['code' => (string) $row->channel_code, 'display_name' => (string) $row->display_name, 'kind' => (string) $row->channel_kind,
            'version' => (int) $row->version, 'rate_ppm' => (int) $row->rate_ppm, 'fixed_centavos' => (int) $row->fixed_centavos, 'fee_vat_basis_points' => (int) $row->fee_vat_basis_points,
            'rate_includes_vat' => (bool) $row->rate_includes_vat, 'refund_supported' => (bool) $row->refund_supported, 'enabled' => (bool) $row->enabled, 'disabled_reason' => $row->disabled_reason,
            'source_type' => (string) $row->source_type, 'source_reference' => (string) $row->source_reference, 'effective_from' => self::iso($row->effective_from)], $this->channels->versions());
    }

    /** @return array<string, int> */
    public function runReconciliation(Request $request): array
    {
        $this->access->admin($request, 'finance.view');
        $counts = app(PaymentReconciliationService::class)->sweep();
        $this->audit->account($request, 'PAYMENT_RECONCILIATION_RUN', 'PAYMENT', null, after: $counts);

        return $counts;
    }

    /** @return array<string, mixed> */
    private function accumulatorView(object $row): array
    {
        $threshold = (int) $row->threshold_centavos;
        $effective = (int) $row->g_effective_centavos;

        return ['id' => (string) $row->id, 'vendor' => ['id' => (string) $row->organization_id, 'name' => (string) ($row->store_name ?? '')], 'environment' => (string) $row->environment,
            'taxpayer_key_suffix' => substr((string) $row->taxpayer_key, -6), 'taxable_year' => (int) $row->taxable_year, 'threshold_centavos' => $threshold,
            'g_accumulated_centavos' => (int) $row->g_accumulated_centavos, 'g_external_declared_centavos' => (int) $row->g_external_declared_centavos,
            'g_external_overlap_centavos' => (int) $row->g_external_overlap_centavos, 'g_effective_centavos' => $effective, 'remaining_allowance_centavos' => max(0, $threshold - $effective),
            'external_overlap_state' => (string) $row->external_overlap_state, 'status' => (string) $row->withholding_status, 'status_label' => VendorFinanceService::statusLabel((string) $row->withholding_status),
            'reason_code' => (string) $row->status_reason_code, 'breached' => $row->crossed_at !== null, 'crossed_at' => self::iso($row->crossed_at),
            'prior_year_total_centavos' => $row->prior_year_total_centavos === null ? null : (int) $row->prior_year_total_centavos, 'lock_version' => (int) $row->lock_version, 'demo' => true];
    }

    /**
     * @param  callable(object): array<string, mixed>  $present
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    private function page(Builder $query, int $page, callable $present): array
    {
        $page = max(1, min(1000, $page));
        $total = (clone $query)->count();
        $rows = $query->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get();

        return ['items' => $rows->map($present)->values()->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total]];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
