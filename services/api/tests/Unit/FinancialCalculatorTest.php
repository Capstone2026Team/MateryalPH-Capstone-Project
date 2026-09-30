<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Finance\FinancialCalculator;
use App\Domain\Finance\Money;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderStates;
use PHPUnit\Framework\TestCase;

/** FIN-02/FIN-03 arithmetic: FIN-06 worked amounts, rounding, allocation and the payment matrix. */
final class FinancialCalculatorTest extends TestCase
{
    public function test_money_rounds_half_up_to_the_centavo_without_floats(): void
    {
        self::assertSame(1235, Money::lineAmount('1.2345', 1000), '12.345 pesos rounds half-up to 12.35.');
        self::assertSame(1234, Money::lineAmount('1.2344', 1000));
        self::assertSame(3600, Money::includedVat(33600, 'VAT_12'), 'money(33,600 × 12 / 112)');
        self::assertSame(107, Money::includedVat(1000, 'VAT_12'), '107.14… rounds to 107.');
        self::assertSame(0, Money::includedVat(1000, 'VAT_EXEMPT'));
        self::assertSame(0, Money::includedVat(1000, 'VAT_ZERO'));
        self::assertSame(200, Money::commission(10000), 'FIN-06: E=10,000 earns a 200 completion fee.');
        self::assertSame(1, Money::commission(25), '0.5 centavo rounds half-up.');
        self::assertSame(0, Money::commission(24));
    }

    public function test_largest_remainder_allocation_sums_exactly_and_breaks_ties_by_key_order(): void
    {
        self::assertSame(['a' => 34, 'b' => 33, 'c' => 33], Money::allocate(100, ['a' => 1, 'b' => 1, 'c' => 1]), 'Ties go to the first key.');
        self::assertSame(['a' => 8, 'b' => 17, 'c' => 75], Money::allocate(100, ['a' => 1000, 'b' => 2000, 'c' => 9000]));
        foreach ([[1, [7, 3, 9, 11]], [999, [1, 1, 1]], [12345, [333, 777, 1, 4]], [0, [5, 6]]] as [$total, $weights]) {
            $shares = Money::allocate($total, array_combine(array_map(static fn (int $i): string => 'k'.$i, array_keys($weights)), $weights));
            self::assertSame($total, array_sum($shares));
            foreach ($shares as $share) {
                self::assertGreaterThanOrEqual(0, $share);
            }
        }
    }

    public function test_fin06_full_online_vat_inclusive_and_non_vat_cases(): void
    {
        $vat = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 1120000, 'tax_category' => 'VAT_12']], 0, 50000);
        self::assertSame([1120000, 120000, 1000000, 50000, 1170000], [$vat['materials_payable_centavos'], $vat['materials_vat_centavos'], $vat['materials_exclusive_centavos'], $vat['delivery_centavos'], $vat['commercial_total_centavos']]);
        $online = FinancialCalculator::paymentMatrix($vat, 'ONLINE', 10000);
        self::assertSame(['FULL_ORDER_PAYMENT', 1170000, 1180000, 0], [$online['purpose'], $online['online_principal_centavos'], $online['amount_due_online_centavos'], $online['physical_balance_centavos']], 'Pay M + D + F = 11,800.');
        self::assertSame(200 * 100, Money::commission($vat['materials_exclusive_centavos']), 'The fee basis excludes VAT and delivery.');

        $pending = FinancialCalculator::paymentMatrix($vat, 'ONLINE', null);
        self::assertSame(['PENDING_PAYMENT_CHANNEL', null, null], [$pending['processing_fee']['status'], $pending['processing_fee']['amount_centavos'], $pending['amount_due_online_centavos']]);
    }

    public function test_fin06_direct_cash_and_mixed_nrpc_matrix(): void
    {
        $lines = [['line_id' => 'a', 'quantity' => '10', 'unit_price_centavos' => 100000, 'tax_category' => 'NON_VAT']];
        $cash = FinancialCalculator::paymentMatrix(FinancialCalculator::commercial($lines, 0, 50000), 'CASH_ON_DELIVERY', 2000);
        self::assertSame([null, 0, 'NOT_APPLICABLE', 0, 1050000], [$cash['purpose'], $cash['online_principal_centavos'], $cash['processing_fee']['status'], $cash['amount_due_online_centavos'], $cash['physical_balance_centavos']], 'COD pays M + D directly; no processing fee.');

        $mixed = FinancialCalculator::commercial($lines, 0, 50000, ['amount_centavos' => 100000, 'allocations' => ['a' => 100000]]);
        self::assertSame(1000000, $mixed['materials_payable_centavos'], 'NRPC is part of M, not added on top.');
        $matrix = FinancialCalculator::paymentMatrix($mixed, 'CASH_ON_DELIVERY', 2000);
        self::assertSame(['NRPC_ASSURANCE_PAYMENT', 100000, 102000, 950000], [$matrix['purpose'], $matrix['online_principal_centavos'], $matrix['amount_due_online_centavos'], $matrix['physical_balance_centavos']],
            'Pay N + F = 1,020 online; the physical balance is M + D − N = 9,500, the fee never credits principal.');
        $inStore = FinancialCalculator::paymentMatrix(FinancialCalculator::commercial($lines, 0, 0, ['amount_centavos' => 100000, 'allocations' => ['a' => 100000]]), 'IN_STORE', null);
        self::assertSame(['NRPC_ASSURANCE_PAYMENT', 900000, 'PENDING_PAYMENT_CHANNEL'], [$inStore['purpose'], $inStore['physical_balance_centavos'], $inStore['processing_fee']['status']]);
        $onlineNrpc = FinancialCalculator::paymentMatrix($mixed, 'ONLINE', 3000);
        self::assertSame([1050000, 1053000, 0], [$onlineNrpc['online_principal_centavos'], $onlineNrpc['amount_due_online_centavos'], $onlineNrpc['physical_balance_centavos']], 'Online: NRPC is tagged within the paid total.');
    }

    public function test_discount_allocation_precedes_vat_and_nrpc_vat_is_proportional_within_the_line(): void
    {
        $lines = [
            ['line_id' => 'l1', 'quantity' => '1', 'unit_price_centavos' => 1000, 'tax_category' => 'VAT_12'],
            ['line_id' => 'l2', 'quantity' => '1', 'unit_price_centavos' => 2000, 'tax_category' => 'VAT_12'],
            ['line_id' => 'l3', 'quantity' => '3', 'unit_price_centavos' => 3000, 'tax_category' => 'NON_VAT'],
        ];
        $result = FinancialCalculator::commercial($lines, 101, 0, ['amount_centavos' => 1500, 'allocations' => ['l2' => 1000, 'l3' => 500]]);
        $byLine = array_column($result['lines'], null, 'line_id');
        self::assertSame(101, array_sum(array_column($result['lines'], 'discount_centavos')));
        self::assertSame([8, 17, 76], [$byLine['l1']['discount_centavos'], $byLine['l2']['discount_centavos'], $byLine['l3']['discount_centavos']]);
        self::assertSame([Money::includedVat(992, 'VAT_12'), Money::includedVat(1983, 'VAT_12'), 0], [$byLine['l1']['vat_centavos'], $byLine['l2']['vat_centavos'], $byLine['l3']['vat_centavos']], 'VAT uses the discounted payable amount.');
        self::assertSame($result['materials_payable_centavos'] - $result['materials_vat_centavos'], $result['materials_exclusive_centavos'], 'E = M − V');
        self::assertSame(Money::proportion($byLine['l2']['vat_centavos'], 1000, 1983), $byLine['l2']['nrpc_vat_centavos']);
        self::assertLessThanOrEqual($byLine['l2']['vat_centavos'], $byLine['l2']['nrpc_vat_centavos']);
        self::assertSame(0, $byLine['l3']['nrpc_vat_centavos']);
        self::assertSame(1500, array_sum(array_column($result['lines'], 'nrpc_principal_centavos')), 'NRPC principal is counted once.');
        self::assertSame($byLine['l2']['payable_centavos'] + $byLine['l3']['payable_centavos'], $result['nrpc_eligible_subtotal_centavos']);
    }

    public function test_nrpc_and_discount_integrity_limits_have_no_platform_cap(): void
    {
        $lines = [['line_id' => 'a', 'quantity' => '2', 'unit_price_centavos' => 5000, 'tax_category' => 'NON_VAT'], ['line_id' => 'b', 'quantity' => '1', 'unit_price_centavos' => 3000, 'tax_category' => 'NON_VAT']];
        $full = FinancialCalculator::commercial($lines, 0, 0, ['amount_centavos' => 10000, 'allocations' => ['a' => 10000]]);
        self::assertSame(10000, $full['nrpc_centavos'], 'N may equal the whole prepared subtotal of its lines.');
        foreach ([
            [['amount_centavos' => 0, 'allocations' => ['a' => 0]], 'nrpc.amount_centavos'],
            [['amount_centavos' => 10001, 'allocations' => ['a' => 10001]], 'nrpc.lines'],
            [['amount_centavos' => 11001, 'allocations' => ['a' => 8000, 'b' => 3001]], 'nrpc.lines'],
            [['amount_centavos' => 5000, 'allocations' => ['a' => 4000]], 'nrpc.lines'],
            [['amount_centavos' => 1000, 'allocations' => ['zz' => 1000]], 'nrpc.lines'],
            [['amount_centavos' => 1000, 'allocations' => []], 'nrpc.lines'],
        ] as [$nrpc, $field]) {
            try {
                FinancialCalculator::commercial($lines, 0, 0, $nrpc);
                self::fail('Invalid NRPC accepted: '.json_encode($nrpc));
            } catch (AuthenticationException $exception) {
                self::assertSame('FINANCIAL_RULE_VIOLATION', $exception->errorCode);
                self::assertArrayHasKey($field, $exception->details);
            }
        }
        foreach ([13000, -1] as $discount) {
            try {
                FinancialCalculator::commercial($lines, $discount, 0);
                self::fail('A discount must stay below the materials subtotal.');
            } catch (AuthenticationException $exception) {
                self::assertArrayHasKey('vendor_discount_centavos', $exception->details);
            }
        }
    }

    public function test_the_transition_table_keeps_the_five_families_independent(): void
    {
        self::assertTrue(OrderStates::allows(OrderStates::ORDER, null, 'AWAITING_VENDOR_CONFIRMATION'));
        self::assertTrue(OrderStates::allows(OrderStates::ORDER, 'AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL'));
        self::assertTrue(OrderStates::allows(OrderStates::ORDER, 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT'));
        self::assertFalse(OrderStates::allows(OrderStates::ORDER, 'AWAITING_PAYMENT', 'AWAITING_NRPC_ACCEPTANCE'), 'NRPC can never follow acceptance.');
        self::assertFalse(OrderStates::allows(OrderStates::ORDER, 'AWAITING_VENDOR_CONFIRMATION', 'PROCESSING'), 'No preparation before acceptance and payment conditions.');
        self::assertFalse(OrderStates::allows(OrderStates::ORDER, 'EXPIRED', 'AWAITING_PAYMENT'), 'A closed order never reopens.');
        self::assertFalse(OrderStates::allows(OrderStates::ORDER, 'READY_FOR_PICKUP', 'CANCELLED'), 'No Buyer cancellation at READY_FOR_PICKUP.');
        self::assertTrue(OrderStates::allows(OrderStates::PAYMENT, 'NOT_REQUIRED', 'PENDING'));
        self::assertFalse(OrderStates::allows(OrderStates::PAYMENT, 'NOT_REQUIRED', 'PAID'), 'Payment is never PAID without a pending attempt.');
        self::assertFalse(OrderStates::allows(OrderStates::REFUND, 'NOT_REQUESTED', 'REFUNDED'));
        self::assertTrue(OrderStates::allows(OrderStates::DISPUTE, 'NONE', 'OPEN_AWAITING_RESPONSE'));
    }
}
