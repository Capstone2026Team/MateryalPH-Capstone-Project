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
    public function monitor(Request $request, int $page, int $historyPage = 1): array
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
        $now = CarbonImmutable::now('Asia/Manila');
        $yearStart = $now->startOfYear();
        $monthStart = $now->startOfMonth();

        return ['data' => ['current_policy' => CommissionPolicyService::present(CommissionPolicyService::current()), 'next_policy' => CommissionPolicyService::present(CommissionPolicyService::next()),
            'terms_accepted' => app(StoreActivationGate::class)->commissionAccepted($organizationId, $owner['user_id']),
            'annual_payments' => $this->payments($organizationId, $yearStart, $yearStart->addYear(), $yearStart->format('Y')),
            'monthly_payments' => $this->payments($organizationId, $monthStart, $monthStart->addMonth(), $monthStart->format('F Y')),
            'payment_history' => $this->history($organizationId, $yearStart, $historyPage),
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

    /** @return array<string, mixed> */
    private function payments(string $organizationId, CarbonImmutable $start, CarbonImmutable $end, string $label): array
    {
        $collected = (int) CommissionService::collections($organizationId)->where('a.allocated_at', '>=', $start->utc())->where('a.allocated_at', '<', $end->utc())->sum('a.amount_centavos');
        $refunded = (int) CommissionService::feeRefunds($organizationId)->where('r.completed_at', '>=', $start->utc())->where('r.completed_at', '<', $end->utc())->sum('r.amount_centavos');

        return $this->period($start, $end, $label, $collected, $refunded);
    }

    /** Closed years are retained projections of immutable allocations and completed refunds; no reset deletes or rewrites money records.
     * @return array<string, mixed>
     */
    private function history(string $organizationId, CarbonImmutable $yearStart, int $page): array
    {
        $collections = CommissionService::collections($organizationId)->whereNotNull('a.allocated_at')
            ->selectRaw('a.allocated_at AS occurred_at, a.amount_centavos AS collected, 0::bigint AS refunded');
        $refunds = CommissionService::feeRefunds($organizationId)->whereNotNull('r.completed_at')
            ->selectRaw('r.completed_at AS occurred_at, 0::bigint AS collected, r.amount_centavos AS refunded');
        $years = DB::query()->fromSub($collections->unionAll($refunds), 'payment_events')->where('occurred_at', '<', $yearStart->utc())
            ->selectRaw("EXTRACT(YEAR FROM occurred_at AT TIME ZONE 'Asia/Manila')::integer AS year, SUM(collected) AS collected, SUM(refunded) AS refunded")
            ->groupByRaw("EXTRACT(YEAR FROM occurred_at AT TIME ZONE 'Asia/Manila')");
        $total = DB::query()->fromSub(clone $years, 'payment_years')->count();
        $items = $years->orderByDesc('year')->forPage($page, 10)->get()->map(function (object $row): array {
            $start = CarbonImmutable::create((int) $row->year, 1, 1, 0, 0, 0, 'Asia/Manila');

            return $this->period($start, $start->addYear(), (string) $row->year, (int) $row->collected, (int) $row->refunded);
        })->all();

        return ['items' => $items, 'page' => $page, 'per_page' => 10, 'total' => $total, 'has_more' => $page * 10 < $total];
    }

    /** @return array<string, mixed> */
    private function period(CarbonImmutable $start, CarbonImmutable $end, string $label, int $collected, int $refunded): array
    {
        return ['label' => $label, 'starts_on' => $start->toDateString(), 'ends_on' => $end->subDay()->toDateString(), 'resets_at' => $end->toIso8601String(),
            'collected_centavos' => $collected, 'refunded_centavos' => $refunded, 'net_collected_centavos' => $collected - $refunded];
    }
}
