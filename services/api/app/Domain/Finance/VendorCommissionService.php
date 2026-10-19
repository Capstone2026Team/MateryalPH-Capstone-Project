<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Vendors\StoreActivationGate;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Owner-scoped monitoring from the same assessments, allocations and confirmed refunds used by Admin. */
final class VendorCommissionService
{
    public function __construct(private readonly FinanceAccess $access) {}

    /** @return array{data: array<string, mixed>, meta: array<string, mixed>} */
    public function monitor(Request $request, int $page): array
    {
        $owner = $this->access->owner($request);
        $organizationId = $owner['organization_id'];
        $assessments = DB::table('fee_assessments')->where('fee_assessments.vendor_organization_id', $organizationId);
        $totals = (clone $assessments)->selectRaw("COALESCE(SUM(CASE WHEN state = 'ESTIMATED' THEN earned_target_centavos ELSE 0 END), 0) AS estimated,
            COALESCE(SUM(earned_centavos), 0) AS earned, COALESCE(SUM(credited_centavos), 0) AS credited,
            COALESCE(SUM(CASE WHEN state = 'EARNED' AND billed_at IS NULL THEN earned_centavos - credited_centavos ELSE 0 END), 0) AS unbilled")->first();
        $statements = DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->where('environment', FinancialSnapshotService::ENVIRONMENT)
            ->selectRaw("COALESCE(SUM(outstanding_centavos) FILTER (WHERE state IN ('ISSUED','PARTIALLY_PAID')), 0) AS outstanding,
                COALESCE(SUM(outstanding_centavos) FILTER (WHERE state IN ('ISSUED','PARTIALLY_PAID') AND due_on < ?), 0) AS overdue,
                COALESCE(SUM(outstanding_centavos) FILTER (WHERE state = 'DRAFT'), 0) AS draft", [CarbonImmutable::now('Asia/Manila')->toDateString()])->first();
        $collected = (int) CommissionService::collections($organizationId)->sum('a.amount_centavos');
        $refunded = (int) CommissionService::feeRefunds($organizationId)->sum('r.amount_centavos');
        $total = (clone $assessments)->count();

        return ['data' => ['current_policy' => CommissionPolicyService::present(CommissionPolicyService::current()), 'next_policy' => CommissionPolicyService::present(CommissionPolicyService::next()),
            'terms_accepted' => app(StoreActivationGate::class)->commissionAccepted($organizationId, $owner['user_id']),
            'summary' => ['estimated_centavos' => (int) $totals->estimated, 'earned_centavos' => (int) $totals->earned, 'credited_centavos' => (int) $totals->credited,
                'net_earned_centavos' => (int) $totals->earned - (int) $totals->credited, 'unbilled_centavos' => (int) $totals->unbilled, 'draft_centavos' => (int) $statements->draft,
                'outstanding_centavos' => (int) $statements->outstanding, 'overdue_centavos' => (int) $statements->overdue,
                'collected_centavos' => $collected, 'refunded_centavos' => $refunded, 'net_collected_centavos' => $collected - $refunded],
            'assessments' => $assessments->join('orders as o', 'o.id', '=', 'fee_assessments.order_id')->orderByDesc('fee_assessments.created_at')->orderByDesc('fee_assessments.id')
                ->forPage($page, 20)->get(['fee_assessments.*', 'o.reference'])->map(static fn (object $row): array => [
                    'id' => (string) $row->id, 'order_reference' => (string) $row->reference, 'state' => (string) $row->state,
                    'commission_basis_centavos' => (int) $row->commission_basis_centavos, 'commission_basis_points' => (int) $row->commission_basis_points,
                    'estimated_centavos' => $row->state === 'ESTIMATED' ? (int) $row->earned_target_centavos : 0,
                    'earned_centavos' => (int) $row->earned_centavos, 'credited_centavos' => (int) $row->credited_centavos,
                    'net_centavos' => (int) $row->earned_centavos - (int) $row->credited_centavos, 'dispute_hold' => (bool) $row->dispute_hold,
                    'earned_at' => $row->earned_at === null ? null : CarbonImmutable::parse((string) $row->earned_at)->toIso8601String(),
                ])->all()], 'meta' => ['page' => $page, 'per_page' => 20, 'total' => $total, 'has_more' => $page * 20 < $total]];
    }
}
