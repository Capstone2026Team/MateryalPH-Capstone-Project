<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-03 fee-assessment lifecycle for one order and fee-policy version. The accepted snapshot creates one
 * ESTIMATED assessment of money(E × 0.02); only a COMPLETED order earns it, exactly once, through the
 * completion event contract; an order that closes without a completed sale cancels it. Payment, Vendor
 * confirmation and dispatch never earn a fee. Delivery, processing fees, VAT and NRPC deposits are never in
 * the basis because the basis is the frozen materials-exclusive value E.
 */
final class FeeAssessmentService
{
    public const BASIS_POINTS = 200;

    public function __construct(private readonly OutboxPublisher $outbox) {}

    /** Records the ESTIMATED assessment for a newly frozen financial snapshot. Returns the assessment id. */
    public function estimate(object $order, string $financialSnapshotId, ?string $feePolicyVersionId, int $exclusiveCentavos, string $correlationId): ?string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Fee assessments are recorded inside the acceptance transaction.');
        }
        if ($feePolicyVersionId === null) {
            // No approved fee policy in force: the order still proceeds; finance review creates the assessment.
            return null;
        }
        $existing = DB::table('fee_assessments')->where('order_id', $order->id)->where('fee_policy_version_id', $feePolicyVersionId)->value('id');
        if ($existing !== null) {
            return (string) $existing;
        }
        $target = Money::commission($exclusiveCentavos, self::BASIS_POINTS);
        $id = (string) Str::uuid7();
        DB::table('fee_assessments')->insert([
            'id' => $id, 'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id, 'financial_snapshot_id' => $financialSnapshotId,
            'fee_policy_version_id' => $feePolicyVersionId, 'commission_basis_centavos' => $exclusiveCentavos, 'commission_basis_points' => self::BASIS_POINTS,
            'earned_centavos' => 0, 'earned_target_centavos' => $target, 'state' => 'ESTIMATED',
            'calculation_hash' => hash('sha256', $order->id.'|'.$feePolicyVersionId.'|'.$financialSnapshotId.'|'.$exclusiveCentavos.'|'.self::BASIS_POINTS),
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->event($id, (string) $order->id, 'ESTIMATED', (string) $order->order_state, $target, $correlationId);

        return $id;
    }

    /**
     * Completion-event contract for the later fulfillment phase: earns the ESTIMATED assessment once, and only
     * for a COMPLETED order. A retry returns the already-earned amount without a second event.
     */
    public function earnOnCompletion(string $orderId, string $correlationId): int
    {
        return DB::transaction(function () use ($orderId, $correlationId): int {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            if ($order === null || $order->order_state !== 'COMPLETED') {
                throw new AuthenticationException('FEE_NOT_EARNABLE', 'A commission is earned only when the order is completed.', 409);
            }
            $assessment = DB::table('fee_assessments')->where('order_id', $orderId)->orderByDesc('created_at')->lockForUpdate()->first();
            if ($assessment === null) {
                throw new AuthenticationException('FEE_ASSESSMENT_MISSING', 'This order has no fee assessment to earn.', 409);
            }
            if ($assessment->state === 'EARNED') {
                return (int) $assessment->earned_centavos;
            }
            if ($assessment->state !== 'ESTIMATED') {
                throw new AuthenticationException('FEE_NOT_EARNABLE', 'A cancelled fee assessment cannot be earned.', 409);
            }
            DB::table('fee_assessments')->where('id', $assessment->id)->update(['state' => 'EARNED', 'earned_centavos' => (int) $assessment->earned_target_centavos, 'earned_at' => now(), 'updated_at' => now()]);
            $this->event((string) $assessment->id, $orderId, 'EARNED', 'COMPLETED', (int) $assessment->earned_target_centavos, $correlationId);
            app(CommissionService::class)->postEarning($assessment, (int) $assessment->earned_target_centavos, $correlationId);

            return (int) $assessment->earned_target_centavos;
        });
    }

    /** An accepted order that closes without a completed sale cancels its estimate; there is no fee. */
    public function cancelForClosedOrder(object $order, string $closingState, string $correlationId): void
    {
        foreach (DB::table('fee_assessments')->where('order_id', $order->id)->where('state', 'ESTIMATED')->lockForUpdate()->get() as $assessment) {
            DB::table('fee_assessments')->where('id', $assessment->id)->update(['state' => 'CANCELLED', 'earned_target_centavos' => 0, 'updated_at' => now()]);
            $this->event((string) $assessment->id, (string) $order->id, 'CANCELLED', $closingState, 0, $correlationId);
        }
    }

    private function event(string $assessmentId, string $orderId, string $type, string $orderState, int $amount, string $correlationId): void
    {
        DB::table('fee_assessment_events')->insert(['id' => (string) Str::uuid7(), 'fee_assessment_id' => $assessmentId, 'order_id' => $orderId, 'event_type' => $type,
            'order_state' => $orderState, 'amount_centavos' => $amount, 'correlation_id' => $correlationId, 'created_at' => now()]);
        $this->outbox->publish('FEE_ASSESSMENT_'.$type, 'ORDER', $orderId, ['fee_assessment_id' => $assessmentId, 'order_id' => $orderId, 'amount_centavos' => $amount, 'order_state' => $orderState]);
    }
}
