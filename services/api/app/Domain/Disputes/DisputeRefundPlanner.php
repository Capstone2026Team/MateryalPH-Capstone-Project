<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Finance\Money;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\CancellationRefundPlanner;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * FIN-07 amounts of a concluded money award, from the original frozen allocations and never from current listing
 * values:
 *
 *   line cap        each affected line's original payable less refunds already allocated to it
 *   partial award   0 < A ≤ Σ affected-line caps and ≤ what is still refundable; split across the affected lines by
 *                   largest remainder; each part reverses its line's original VAT and discount proportionally
 *   full award      every Buyer-paid amount still refundable, including NRPC and the disclosed processing fee
 *                   (a full award follows Vendor fault, so the Buyer is made whole)
 *   online first    each original online payment, capped by its capture less successful and in-flight refunds
 *                   (a partial award never consumes the processing fee); any remainder is cash the Buyer paid the
 *                   Vendor directly, returned through an evidenced Vendor reimbursement
 *   commission      the returned VAT-exclusive materials value feeds a separate fee-credit review
 *
 * Vendor CWT, commission and provider deductions never reduce the Buyer's award. An award never pays twice: the
 * amount already awarded on earlier executed decisions of the same case is subtracted first.
 */
final class DisputeRefundPlanner
{
    private const PURPOSE_ORDER = ['FULL_ORDER_PAYMENT', 'ORDER_BALANCE_PAYMENT', 'NRPC_ASSURANCE_PAYMENT'];

    public function __construct(private readonly CancellationRefundPlanner $cash) {}

    /**
     * @param  list<string>  $affectedLineIds
     * @return array<string, mixed>
     */
    public function plan(object $order, object $case, string $outcome, ?int $amountCentavos, array $affectedLineIds): array
    {
        $snapshot = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->first();
        $lines = $snapshot === null ? collect() : DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->orderBy('order_line_id')->get();
        $payments = DB::table('payments')->where('order_id', $order->id)->where('state', 'PAID')->where('late_capture', false)->whereIn('purpose', self::PURPOSE_ORDER)
            ->orderBy('paid_at')->orderBy('id')->get()->sortBy(static fn (object $payment): int => (int) array_search($payment->purpose, self::PURPOSE_ORDER, true))->values();
        $balances = [];
        foreach ($payments as $payment) {
            $prior = DB::table('refunds')->where('source_payment_id', $payment->id)->whereIn('state', ['REFUND_PENDING', 'REFUNDED']);
            $balances[(string) $payment->id] = [
                'payment' => $payment,
                'balance' => max(0, (int) $payment->total_centavos - (int) (clone $prior)->sum('amount_centavos')),
                'fee_left' => max(0, (int) $payment->processing_fee_centavos - (int) (clone $prior)->sum('processing_fee_centavos')),
            ];
        }
        $cashLeft = max(0, $this->cash->cashCollected((string) $order->id) - (int) DB::table('physical_reimbursements')->where('order_id', $order->id)->sum('amount_centavos'));
        $online = 0;
        foreach ($balances as $row) {
            $online += $row['balance'];
        }
        $alreadyAwarded = self::awardedSoFar((string) $case->id);

        if ($outcome === 'FULL_REFUND') {
            $selected = $lines;
            $target = $online + $cashLeft;
            $parts = [];
            foreach ($lines as $line) {
                $parts[(string) $line->order_line_id] = max(0, (int) $line->ordinary_payable_centavos - (int) $line->refund_allocated_centavos);
            }
        } else {
            $selected = $lines->filter(static fn (object $line): bool => in_array((string) $line->order_line_id, $affectedLineIds, true))->values();
            if ($selected->isEmpty()) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Select the affected lines for a partial award.', 422, ['affected_line_ids' => ['Select at least one affected line.']]);
            }
            $caps = [];
            foreach ($selected as $line) {
                $caps[(string) $line->order_line_id] = max(0, (int) $line->ordinary_payable_centavos - (int) $line->refund_allocated_centavos);
            }
            $requested = (int) $amountCentavos;
            if ($requested <= 0) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Enter the awarded amount.', 422, ['amount_centavos' => ['Enter an amount above zero.']]);
            }
            // The award is the case total: an appeal that raises it pays only the difference, and never more than
            // the affected lines' original amounts or what remains on them after every earlier refund.
            $original = (int) $selected->sum(static fn (object $line): int => (int) $line->ordinary_payable_centavos);
            $target = max(0, $requested - $alreadyAwarded);
            if ($requested > $original || $target > array_sum($caps)) {
                throw new AuthenticationException('AWARD_EXCEEDS_LINES', 'A partial award cannot exceed the original amount of the affected lines less earlier refunds.', 422,
                    ['amount_centavos' => ['At most ₱'.number_format((min($original, array_sum($caps) + $alreadyAwarded)) / 100, 2).' can be awarded on the affected lines.']]);
            }
            $parts = $target === 0 ? array_map(static fn (): int => 0, $caps) : Money::allocate($target, $caps);
            if ($target > $online - array_sum(array_column($balances, 'fee_left')) + $cashLeft) {
                throw new AuthenticationException('AWARD_EXCEEDS_REFUNDABLE', 'The award is more than the Buyer paid that is still refundable.', 422);
            }
        }
        if ($outcome === 'FULL_REFUND' && $target <= 0) {
            throw new AuthenticationException('NOTHING_REFUNDABLE', 'Every amount the Buyer paid on this order has already been refunded.', 409);
        }

        $lineAllocation = self::lineAllocation($selected, $parts);
        $plan = ['online' => [], 'cash_reimbursement_centavos' => 0, 'already_awarded_centavos' => $alreadyAwarded];
        $remaining = $target;
        foreach ($balances as $paymentId => $row) {
            if ($remaining <= 0) {
                break;
            }
            $available = $outcome === 'FULL_REFUND' ? $row['balance'] : max(0, $row['balance'] - $row['fee_left']);
            $take = min($remaining, $available);
            if ($take <= 0) {
                continue;
            }
            $fee = $outcome === 'FULL_REFUND' ? min($row['fee_left'], $take) : 0;
            $plan['online'][] = ['payment_id' => $paymentId, 'purpose' => (string) $row['payment']->purpose, 'refund_centavos' => $take, 'processing_fee_centavos' => $fee,
                'principal_centavos' => $take - $fee, 'captured_centavos' => (int) $row['payment']->total_centavos, 'prior_allocated_centavos' => (int) $row['payment']->total_centavos - $row['balance']];
            $remaining -= $take;
        }
        $plan['cash_reimbursement_centavos'] = min($remaining, $cashLeft);
        $remaining -= $plan['cash_reimbursement_centavos'];
        if ($remaining > 0) {
            throw new AuthenticationException('AWARD_EXCEEDS_REFUNDABLE', 'The award is more than the Buyer paid that is still refundable.', 422);
        }

        return $plan + [
            'outcome' => $outcome, 'awarded_centavos' => $target, 'lines' => $lineAllocation,
            'returned_exclusive_centavos' => array_sum(array_map(static fn (array $line): int => $line['payable_centavos'] - $line['vat_centavos'], $lineAllocation)),
            'online_refund_total_centavos' => array_sum(array_column($plan['online'], 'refund_centavos')),
            'excludes' => ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING', 'PROVIDER_SETTLEMENT_DEDUCTIONS'],
        ];
    }

    /** Refund instructions and cash reimbursements already created by earlier executed decisions of this case. */
    public static function awardedSoFar(string $caseId): int
    {
        $online = (int) DB::table('refunds')->where('dispute_case_id', $caseId)->whereIn('state', ['REFUND_PENDING', 'REFUNDED'])->sum('amount_centavos');
        $cash = (int) DB::table('physical_reimbursements as p')->join('dispute_decisions as d', 'd.id', '=', 'p.dispute_decision_id')->where('d.dispute_case_id', $caseId)->sum('p.amount_centavos');

        return $online + $cash;
    }

    /**
     * @param  Collection<int, object>  $lines
     * @param  array<string, int>  $parts
     * @return list<array{order_line_id: string, payable_centavos: int, vat_centavos: int, discount_centavos: int}>
     */
    private static function lineAllocation(Collection $lines, array $parts): array
    {
        $allocation = [];
        foreach ($lines as $line) {
            $part = $parts[(string) $line->order_line_id] ?? 0;
            $payable = (int) $line->ordinary_payable_centavos;
            if ($part <= 0 || $payable <= 0) {
                continue;
            }
            $allocation[] = ['order_line_id' => (string) $line->order_line_id, 'payable_centavos' => $part,
                'vat_centavos' => Money::proportion($part, (int) $line->vat_centavos, $payable), 'discount_centavos' => Money::proportion($part, (int) $line->discount_centavos, $payable)];
        }

        return $allocation;
    }
}
