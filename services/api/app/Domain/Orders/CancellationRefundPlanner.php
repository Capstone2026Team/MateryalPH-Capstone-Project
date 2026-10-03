<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * FIN-07 cancellation amounts, computed server-side from the original frozen allocations, never from current
 * listing values or a reconstructed total:
 *
 *   online refund per original payment = capture − successful/in-flight refunds of that payment − retained NRPC share
 *   Vendor cause                       retained NRPC = 0 (forfeited); every Buyer-paid order amount is refunded
 *   eligible Buyer cause in PROCESSING retained NRPC = the accepted N only with Vendor preparation evidence
 *   processing fee                     refunded too: no nonreturnable-fee disclosure exists (project default)
 *   cash already collected             evidenced Vendor reimbursement, never a Refund API call
 *   uncollected physical balance       released as "No longer due", never "Refunded"
 *
 * Line refunds consume each line's original payable and VAT less its frozen NRPC principal/VAT when NRPC is
 * retained, so a discount or VAT is never deducted twice. Vendor CWT, commission and provider deductions never
 * reduce a Buyer refund target.
 */
final class CancellationRefundPlanner
{
    /** @return array<string, mixed> */
    public function plan(object $order, string $cause, bool $retainNrpc): array
    {
        $snapshot = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->first();
        $lines = $snapshot === null ? collect() : DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->orderBy('order_line_id')->get();
        $retain = $cause === 'BUYER' && $retainNrpc && $snapshot !== null ? (int) $snapshot->nrpc_centavos : 0;
        $online = [];
        foreach (DB::table('payments')->where('order_id', $order->id)->where('state', 'PAID')->where('late_capture', false)
            ->whereIn('purpose', ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT'])->orderBy('paid_at')->orderBy('id')->get() as $payment) {
            $online[] = $this->forPayment($payment, $snapshot, $lines, $retain);
        }
        $cash = $this->cashCollected((string) $order->id);
        $unpaid = $order->payment_method === 'ONLINE' ? 0 : $this->remainingObligation((string) $order->id);
        $total = array_sum(array_column($online, 'refund_centavos'));

        return [
            'cause' => $cause, 'nrpc_retained_centavos' => array_sum(array_column($online, 'retained_centavos')), 'nrpc_accepted_centavos' => $snapshot === null ? 0 : (int) $snapshot->nrpc_centavos,
            'online' => $online, 'online_refund_total_centavos' => $total, 'cash_reimbursement_centavos' => $cash, 'released_unpaid_centavos' => $unpaid,
            'paid_total_centavos' => array_sum(array_column($online, 'captured_centavos')) + $cash,
            'excludes' => ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING', 'PROVIDER_SETTLEMENT_DEDUCTIONS'],
        ];
    }

    /**
     * @param  Collection<int, object>  $lines
     * @return array<string, mixed>
     */
    private function forPayment(object $payment, ?object $snapshot, $lines, int $retain): array
    {
        $captured = (int) $payment->total_centavos;
        $fee = (int) $payment->processing_fee_centavos;
        $principal = (int) $payment->principal_centavos;
        $prior = (int) DB::table('refunds')->where('source_payment_id', $payment->id)->whereIn('state', ['REFUND_PENDING', 'REFUNDED'])->sum('amount_centavos');
        $allocation = ['lines' => [], 'delivery_centavos' => 0, 'processing_fee_centavos' => $fee];
        $retained = 0;
        if ($payment->purpose === 'FULL_ORDER_PAYMENT') {
            $retained = min($retain, $principal);
            foreach ($lines as $line) {
                $keep = $retained > 0 ? (int) $line->nrpc_principal_centavos : 0;
                $keepVat = $retained > 0 ? (int) $line->nrpc_vat_centavos : 0;
                $allocation['lines'][] = ['order_line_id' => (string) $line->order_line_id, 'payable_centavos' => (int) $line->ordinary_payable_centavos - $keep,
                    'vat_centavos' => (int) $line->vat_centavos - $keepVat, 'discount_centavos' => (int) $line->discount_centavos, 'retained_nrpc_centavos' => $keep, 'retained_nrpc_vat_centavos' => $keepVat];
            }
            $allocation['delivery_centavos'] = (int) ($snapshot->delivery_centavos ?? 0);
        } elseif ($payment->purpose === 'NRPC_ASSURANCE_PAYMENT') {
            // The assurance principal is N itself; when retained only its processing fee returns.
            $retained = min($retain, $principal);
            foreach ($lines as $line) {
                if ((int) $line->nrpc_principal_centavos > 0) {
                    $allocation['lines'][] = ['order_line_id' => (string) $line->order_line_id, 'payable_centavos' => $retained > 0 ? 0 : (int) $line->nrpc_principal_centavos,
                        'vat_centavos' => $retained > 0 ? 0 : (int) $line->nrpc_vat_centavos, 'discount_centavos' => 0,
                        'retained_nrpc_centavos' => $retained > 0 ? (int) $line->nrpc_principal_centavos : 0, 'retained_nrpc_vat_centavos' => $retained > 0 ? (int) $line->nrpc_vat_centavos : 0];
                }
            }
        } else {
            // An online balance collection never contains NRPC; its frozen materials/delivery/VAT split returns whole.
            $breakdown = json_decode((string) $payment->amount_breakdown, true) ?: [];
            $allocation['delivery_centavos'] = (int) ($breakdown['delivery_allocated_centavos'] ?? 0);
            $allocation['balance'] = ['materials_centavos' => (int) ($breakdown['materials_allocated_centavos'] ?? $principal), 'vat_centavos' => (int) ($breakdown['vat_allocated_centavos'] ?? 0)];
        }
        $target = max(0, $captured - $retained);
        $refund = min($target, max(0, $captured - $prior));

        return [
            'payment_id' => (string) $payment->id, 'purpose' => (string) $payment->purpose, 'channel_code' => $payment->channel_code,
            'channel_name' => DB::table('payment_channel_fee_versions')->where('id', $payment->channel_fee_version_id)->value('display_name'),
            'captured_centavos' => $captured, 'prior_allocated_centavos' => $prior, 'retained_centavos' => $retained, 'refund_centavos' => $refund,
            'principal_centavos' => max(0, $refund - $fee), 'processing_fee_centavos' => min($fee, $refund), 'capped_by_prior_refunds' => $refund < $target, 'allocation' => $allocation,
        ];
    }

    /** Cash recorded by the Vendor (corrections replace their source), which only a Vendor reimbursement can return. */
    public function cashCollected(string $orderId): int
    {
        $records = DB::table('physical_payment_records')->where('order_id', $orderId)->whereIn('record_kind', ['COLLECTION', 'CORRECTION'])->where('amount_centavos', '>', 0)->get();
        $superseded = $records->pluck('original_record_id')->filter()->all();

        return (int) $records->reject(static fn (object $row): bool => in_array($row->id, $superseded, true))->sum('amount_centavos');
    }

    public function remainingObligation(string $orderId): int
    {
        $latest = DB::table('physical_payment_records')->where('order_id', $orderId)->orderBy('remaining_obligation_centavos')->orderByDesc('recorded_at')->first();

        return $latest === null || $latest->state === 'CANCELLED_UNPAID' ? 0 : (int) $latest->remaining_obligation_centavos;
    }
}
