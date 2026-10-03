<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;

/**
 * FIN-02 commercial amounts for one Vendor child order, in integer centavos.
 *
 *   gross_i   = money(quantity_i × unit price_i)
 *   discount  = the order-level Vendor discount, allocated to lines by largest remainder on gross, ties by line id
 *   L_i       = gross_i − discount_i                       (payable, VAT-inclusive)
 *   V_i       = money(L_i × 12 / 112) for VAT_12, else 0
 *   M = Σ L_i,  V = Σ V_i,  E = M − V,  D = confirmed delivery (separate, never in V)
 *   N         = NRPC, 0 < N ≤ Σ L of its affected lines, allocated as explicit per-line principals summing to N;
 *               the NRPC share of each line's VAT is money(V_i × principal_i / L_i), the rest stays with the balance
 *
 * NRPC is part of M, never added on top. Commission and merchant withholding are Vendor-side and never appear
 * in a Buyer amount. There is no platform NRPC cap beyond the prepared-material integrity limit.
 */
final class FinancialCalculator
{
    public const VERSION = 'fin02.order.v1';

    public const PAYMENT_METHODS = ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'];

    /**
     * @param  list<array{line_id: string, quantity: string, unit_price_centavos: int, tax_category: string}>  $lines  lines with a positive quantity
     * @param  array{amount_centavos: int, allocations: array<string, int>}|null  $nrpc  principal per affected line id
     * @return array<string, mixed>
     */
    public static function commercial(array $lines, int $vendorDiscountCentavos, ?int $deliveryCentavos, ?array $nrpc = null): array
    {
        if ($lines === []) {
            throw self::invalid('lines', 'At least one line must keep a quantity above zero.');
        }
        usort($lines, static fn (array $a, array $b): int => strcmp($a['line_id'], $b['line_id']));
        $gross = [];
        foreach ($lines as $line) {
            if (bccomp($line['quantity'], '0', 4) <= 0) {
                throw self::invalid('lines', 'Only lines with a quantity above zero are priced.');
            }
            $gross[$line['line_id']] = Money::lineAmount($line['quantity'], $line['unit_price_centavos']);
        }
        $grossTotal = array_sum($gross);
        if ($vendorDiscountCentavos < 0 || $vendorDiscountCentavos >= $grossTotal) {
            throw self::invalid('vendor_discount_centavos', 'A discount must be zero or more and lower than the materials subtotal.');
        }
        if ($deliveryCentavos !== null && $deliveryCentavos < 0) {
            throw self::invalid('delivery', 'The delivery amount cannot be negative.');
        }
        $discounts = Money::allocate($vendorDiscountCentavos, $gross);
        $computed = [];
        foreach ($lines as $line) {
            $id = $line['line_id'];
            $payable = $gross[$id] - $discounts[$id];
            $vat = Money::includedVat($payable, $line['tax_category']);
            $computed[$id] = [
                'line_id' => $id, 'quantity' => $line['quantity'], 'unit_price_centavos' => $line['unit_price_centavos'], 'tax_category' => $line['tax_category'],
                'gross_centavos' => $gross[$id], 'discount_centavos' => $discounts[$id], 'payable_centavos' => $payable, 'vat_centavos' => $vat,
                'exclusive_centavos' => $payable - $vat, 'nrpc_principal_centavos' => 0, 'nrpc_vat_centavos' => 0,
            ];
        }
        $materials = array_sum(array_column($computed, 'payable_centavos'));
        $vatTotal = array_sum(array_column($computed, 'vat_centavos'));
        $nrpcAmount = 0;
        $eligible = null;
        if ($nrpc !== null) {
            [$nrpcAmount, $eligible] = self::applyNrpc($computed, $nrpc);
        }

        return [
            'calculation_version' => self::VERSION,
            'currency' => 'PHP',
            'lines' => array_values($computed),
            'materials_gross_centavos' => $grossTotal,
            'vendor_discount_centavos' => $vendorDiscountCentavos,
            'materials_payable_centavos' => $materials,
            'materials_vat_centavos' => $vatTotal,
            'materials_exclusive_centavos' => $materials - $vatTotal,
            'delivery_centavos' => $deliveryCentavos,
            'nrpc_centavos' => $nrpcAmount,
            'nrpc_eligible_subtotal_centavos' => $eligible,
            'commercial_total_centavos' => $deliveryCentavos === null ? null : $materials + $deliveryCentavos,
            'rounding' => ['discount_allocation' => 'largest-remainder.gross.line-id', 'vat' => 'half-up.L*12/112', 'nrpc_vat' => 'half-up.line-vat*principal/L.remainder-to-balance'],
        ];
    }

    /**
     * Buyer amounts for each payment case. $processingFeeCentavos is the disclosed channel fee for the online
     * collection; null means the channel is not chosen yet and the online amount stays pending.
     *
     * @param  array<string, mixed>  $commercial  result of commercial() with a known delivery amount
     * @return array<string, mixed>
     */
    public static function paymentMatrix(array $commercial, string $paymentMethod, ?int $processingFeeCentavos): array
    {
        if (! in_array($paymentMethod, self::PAYMENT_METHODS, true)) {
            throw new \InvalidArgumentException('Unknown payment method.');
        }
        if ($commercial['commercial_total_centavos'] === null) {
            throw new \InvalidArgumentException('The delivery amount must be confirmed before payment amounts exist.');
        }
        if ($processingFeeCentavos !== null && $processingFeeCentavos < 0) {
            throw new \InvalidArgumentException('A processing fee cannot be negative.');
        }
        $total = (int) $commercial['commercial_total_centavos'];
        $nrpc = (int) $commercial['nrpc_centavos'];
        if ($paymentMethod === 'ONLINE') {
            $purpose = 'FULL_ORDER_PAYMENT';
            $online = $total;
        } elseif ($nrpc > 0) {
            // COD / In-Store with NRPC: the accepted NRPC is an online assurance payment credited to the balance.
            $purpose = 'NRPC_ASSURANCE_PAYMENT';
            $online = $nrpc;
        } else {
            $purpose = null;
            $online = 0;
        }
        $feeApplies = $online > 0;
        $fee = $feeApplies ? $processingFeeCentavos : 0;

        return [
            'payment_method' => $paymentMethod,
            'purpose' => $purpose,
            'commercial_total_centavos' => $total,
            'online_principal_centavos' => $online,
            'processing_fee' => ['status' => ! $feeApplies ? 'NOT_APPLICABLE' : ($fee === null ? 'PENDING_PAYMENT_CHANNEL' : 'QUOTED'), 'amount_centavos' => $fee],
            'amount_due_online_centavos' => $fee === null ? null : $online + $fee,
            // The fee paid on an NRPC assurance payment is never credited as material principal.
            'physical_balance_centavos' => $total - $online,
            'nrpc_within_order_value' => true,
        ];
    }

    /**
     * @param  array<string, array<string, mixed>>  $computed
     * @param  array{amount_centavos: int, allocations: array<string, int>}  $nrpc
     * @return array{0: int, 1: int}
     */
    private static function applyNrpc(array &$computed, array $nrpc): array
    {
        $amount = $nrpc['amount_centavos'];
        if ($amount <= 0) {
            throw self::invalid('nrpc.amount_centavos', 'Enter an NRPC amount above zero.');
        }
        if ($nrpc['allocations'] === []) {
            throw self::invalid('nrpc.lines', 'Choose the prepared lines the NRPC applies to.');
        }
        $eligible = 0;
        $sum = 0;
        foreach ($nrpc['allocations'] as $lineId => $principal) {
            if (! isset($computed[$lineId])) {
                throw self::invalid('nrpc.lines', 'An NRPC line must be one of this order\'s confirmed lines.');
            }
            if ($principal <= 0 || $principal > $computed[$lineId]['payable_centavos']) {
                throw self::invalid('nrpc.lines', 'Each NRPC line amount must be above zero and within that line\'s payable value.');
            }
            $eligible += $computed[$lineId]['payable_centavos'];
            $sum += $principal;
        }
        if ($amount > $eligible) {
            throw self::invalid('nrpc.amount_centavos', 'The NRPC cannot exceed the payable value of the prepared lines it covers.');
        }
        if ($sum !== $amount) {
            throw self::invalid('nrpc.lines', 'The NRPC line amounts must add up exactly to the NRPC amount.');
        }
        foreach ($nrpc['allocations'] as $lineId => $principal) {
            $line = &$computed[$lineId];
            $line['nrpc_principal_centavos'] = $principal;
            $line['nrpc_vat_centavos'] = $line['vat_centavos'] === 0 ? 0 : Money::proportion($line['vat_centavos'], $principal, $line['payable_centavos']);
            unset($line);
        }

        return [$amount, $eligible];
    }

    private static function invalid(string $field, string $message): AuthenticationException
    {
        return new AuthenticationException('FINANCIAL_RULE_VIOLATION', 'Review the order amounts.', 422, [$field => [$message]]);
    }
}
