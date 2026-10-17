<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Settings\PlatformSettings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** FIN-11. NRPC is part of principal. Vendor deductions never enter these disjoint Buyer buckets. */
final class ProjectBudget
{
    /** @return array{pending: int, actual: int, recovery: int} */
    public static function orderBuckets(string $state, bool $accepted, int $cost, int $paid, int $recovered, int $retained): array
    {
        if (in_array($state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
            $net = max(0, $paid - $recovered);

            return ['pending' => 0, 'actual' => min($net, $retained), 'recovery' => max(0, $net - $retained)];
        }
        if ($state === 'COMPLETED') {
            return ['pending' => 0, 'actual' => max(0, $cost - $recovered), 'recovery' => 0];
        }

        return ['pending' => $accepted ? max(0, $cost - $recovered) : 0, 'actual' => 0, 'recovery' => 0];
    }

    /** Owner decision 2026-10-12: every non-cancelled Work Package budget, Draft included, is deducted from the Project budget. */
    public static function allocated(string $projectId, ?string $exceptPackageId = null): int
    {
        return (int) DB::table('work_packages')->where('project_id', $projectId)->where('status', '<>', 'CANCELLED')
            ->when($exceptPackageId !== null, fn ($query) => $query->where('id', '<>', $exceptPackageId))->sum('budget_centavos');
    }

    /** Allocations never exceed the Project budget. Callers hold the Project row lock. */
    public static function assertAllocation(object $project, ?string $packageId, int $budget): void
    {
        $unallocated = (int) $project->budget_centavos - self::allocated((string) $project->id, $packageId);
        if ($budget > $unallocated) {
            throw new AuthenticationException('WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT', 'This Work Package budget is more than the unallocated Project budget.', 422,
                ['unallocated_centavos' => max(0, $unallocated), 'requested_centavos' => $budget]);
        }
    }

    /** The versioned Platform Setting projects.budget_warning_percent (approved default 90%). */
    public static function warningPercent(): int
    {
        return PlatformSettings::current()->int('projects.budget_warning_percent');
    }

    /** @return array<string, int|string|bool> */
    public static function buckets(int $budget, int $pending, int $actual, int $recovery): array
    {
        $committed = $pending + $actual + $recovery;

        return ['budget_centavos' => $budget, 'pending_centavos' => $pending, 'actual_centavos' => $actual, 'awaiting_recovery_centavos' => $recovery,
            'committed_centavos' => $committed, 'remaining_centavos' => $budget - $committed,
            'utilization_percent' => $budget === 0 ? ($committed > 0 ? '100.01' : '0.00') : bcdiv(bcmul((string) $committed, '100'), (string) $budget, 2),
            'warning' => $committed * 100 >= $budget * self::warningPercent() && ($budget > 0 || $committed > 0),
            'label' => $committed > $budget ? 'OVER_BUDGET' : ($committed === $budget ? 'WITHIN_BUDGET' : 'UNDER_BUDGET')];
    }

    /** @return array<string, mixed> */
    public function metrics(object $project, ?object $package = null, ?string $excludeOrder = null): array
    {
        $orders = DB::table('orders as o')->join('work_packages as w', 'w.id', '=', 'o.work_package_id')->where('w.project_id', $project->id);
        if ($package !== null) {
            $orders->where('w.id', $package->id);
        }
        if ($excludeOrder !== null) {
            $orders->where('o.id', '<>', $excludeOrder);
        }
        $pending = $actual = $recovery = $confirmations = 0;
        foreach ($orders->get(['o.*']) as $order) {
            $payments = DB::table('payments')->where('order_id', $order->id)->whereIn('purpose', ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT']);
            $fee = (int) (clone $payments)->where('state', 'PAID')->sum('processing_fee_centavos');
            $pendingFees = (clone $payments)->where('state', 'PENDING')->orderByDesc('created_at')->get()->unique('purpose');
            foreach ($pendingFees as $payment) {
                if (! (clone $payments)->where('purpose', $payment->purpose)->where('state', 'PAID')->exists()) {
                    $fee += (int) $payment->processing_fee_centavos;
                }
            }
            $paid = (int) (clone $payments)->where('state', 'PAID')->sum('total_centavos');
            $physical = DB::table('physical_payment_records')->where('order_id', $order->id)->whereIn('state', ['PARTIALLY_RECORDED', 'PHYSICAL_PAYMENT_RECORDED'])->whereIn('record_kind', ['COLLECTION', 'CORRECTION'])->get();
            // Correction records replace their source, rather than becoming a second collection.
            $superseded = $physical->pluck('original_record_id')->filter()->all();
            $paid += (int) $physical->reject(fn (object $row): bool => in_array($row->id, $superseded, true))->sum('amount_centavos');
            $recovered = (int) DB::table('refunds')->where('order_id', $order->id)->where('target_type', 'ORDER')->where('state', 'REFUNDED')
                ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('physical_reimbursements as r')->whereColumn('r.refund_id', 'refunds.id'))->sum('amount_centavos');
            $recovered += (int) DB::table('physical_reimbursements as r')->join('physical_payment_records as p', 'p.id', '=', 'r.physical_payment_record_id')->where('p.order_id', $order->id)->where('r.state', 'REIMBURSEMENT_CONFIRMED')->sum('r.amount_centavos');
            $retained = (int) DB::table('cancellation_decisions')->where('order_id', $order->id)->where('state', 'APPROVED')->selectRaw("COALESCE(SUM((payload->>'retained_centavos')::bigint),0) AS amount")->value('amount');
            $cost = (int) $order->commercial_total_centavos + $fee;
            $buckets = self::orderBuckets($order->order_state, $order->accepted_at !== null, $cost, $paid, $recovered, $retained);
            $pending += $buckets['pending'];
            $actual += $buckets['actual'];
            $recovery += $buckets['recovery'];
            if ($order->accepted_at === null && ! in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
                $confirmations++;
            }
        }
        $budget = (int) ($package->budget_centavos ?? $project->budget_centavos);
        $allocated = self::allocated((string) $project->id);

        return self::buckets($budget, $pending, $actual, $recovery) + ['allocated_centavos' => $allocated, 'unallocated_centavos' => (int) $project->budget_centavos - $allocated,
            'pending_confirmation_count' => $confirmations, 'processing_fee_status' => 'PENDING_PAYMENT_CHANNEL_UNTIL_QUOTED'];
    }

    /** Call under Project then Work Package locks. Pending confirmations are not committed spend. */
    public function wouldExceed(object $package, int $amount, ?string $orderId = null): bool
    {
        $project = DB::table('projects')->where('id', $package->project_id)->first();
        $p = $this->metrics($project, excludeOrder: $orderId);
        $w = $this->metrics($project, $package, $orderId);

        return (int) $project->budget_centavos < $p['committed_centavos'] + $amount || (int) $package->budget_centavos < $w['committed_centavos'] + $amount;
    }

    /** Must run under project then package locks before accepting a purchase.
     * @param array<string, mixed> $input */
    public function guard(Request $request, object $package, int $amount, array $input, ?string $orderId = null): void
    {
        $project = DB::table('projects')->where('id', $package->project_id)->lockForUpdate()->first();
        $p = $this->metrics($project, excludeOrder: $orderId);
        $w = $this->metrics($project, $package, $orderId);
        $over = max(0, $p['committed_centavos'] + $amount - $project->budget_centavos, $w['committed_centavos'] + $amount - $package->budget_centavos);
        if ($orderId !== null && (($p['committed_centavos'] + $amount) * 100 >= (int) $project->budget_centavos * self::warningPercent() || ($w['committed_centavos'] + $amount) * 100 >= (int) $package->budget_centavos * self::warningPercent())) {
            app(OrderNotifier::class)->buyer(DB::table('orders')->where('id', $orderId)->first(), 'Project budget warning', 'This purchase reaches at least '.self::warningPercent().'% of the Project or Work Package budget. Review the disjoint committed-spend breakdown.');
        }
        if ($over === 0) {
            return;
        }
        $reason = trim((string) ($input['budget_override_reason'] ?? ''));
        if (mb_strlen($reason) < 10 || mb_strlen($reason) > 2000) {
            throw new AuthenticationException('BUDGET_OVERRIDE_REQUIRED', 'This purchase exceeds the Project or Work Package budget. Write a reason to continue.', 422,
                ['overage_centavos' => $over, 'project' => $p, 'work_package' => $w]);
        }
        DB::table('budget_overrides')->insert(['id' => (string) Str::uuid7(), 'project_id' => $project->id, 'work_package_id' => $package->id,
            'buyer_user_id' => $request->user()->id, 'order_id' => $orderId, 'overage_centavos' => $over, 'reason' => $reason,
            'snapshot' => json_encode(['project' => $p, 'work_package' => $w, 'purchase_centavos' => $amount, 'version_id' => $package->current_version_id], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        app(ProjectService::class)->record($request, 'PROJECT_BUDGET_OVERRIDE_RECORDED', $package->id);
    }
}
