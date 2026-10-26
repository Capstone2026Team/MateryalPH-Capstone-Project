<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Catalog\QuantityPolicy;
use App\Domain\Catalog\VolumePricing;
use App\Domain\Finance\FinancialCalculator;
use App\Domain\Finance\Money;
use PHPUnit\Framework\TestCase;

final class QuantityPolicyTest extends TestCase
{
    public function test_measured_units_and_packages_have_distinct_quantity_meanings(): void
    {
        foreach (['CUM', 'L', 'US_GAL', 'KG', 'M', 'SQM'] as $code) {
            $policy = QuantityPolicy::fromUnit(['code' => $code]);
            self::assertTrue($policy->valid('1.1250'));
            self::assertFalse($policy->valid('1.1251'));
            self::assertSame('0.001', $policy->step());
            self::assertSame('MEASURED', $policy->toArray()['mode']);
        }
        foreach (['PC', 'BAG', 'GAL', 'BOX', 'ROLL', 'COIL', 'SHEET'] as $code) {
            $policy = QuantityPolicy::fromUnit(['code' => $code, 'precision' => 4]);
            self::assertFalse($policy->valid('1.5'));
            self::assertTrue($policy->valid('2.0000'));
            self::assertSame('1', $policy->step());
        }
    }

    public function test_zero_precision_and_malformed_values_are_not_silently_truncated(): void
    {
        $policy = QuantityPolicy::fromUnit(['code' => 'CUM']);
        foreach (['-1', '1e2', '1.00001', '1..5', '', '0', '0.0000'] as $quantity) {
            self::assertFalse($policy->valid($quantity));
        }
        self::assertTrue($policy->valid('0', true));
        self::assertFalse($policy->valid('-0.001', true));
    }

    public function test_recorded_precision_and_legacy_unit_meanings_survive_missing_metadata(): void
    {
        self::assertSame(0, QuantityPolicy::historical(['unit_code' => 'GAL'])->precision);
        self::assertSame(3, QuantityPolicy::historical(['unit_code' => 'CUM'])->precision);
        self::assertSame(2, QuantityPolicy::historical(['unit_code' => 'L', 'unit_precision' => 2])->precision);
        self::assertSame(4, QuantityPolicy::historical(['unit_code' => 'L', 'quantity_step' => '0.0001'])->precision);
        self::assertSame(0, QuantityPolicy::historical(['unit_code' => 'CUM', 'quantity_step' => '1'])->precision);
        self::assertNull(QuantityPolicy::historical(['unit_code' => 'GAL', 'unit_precision' => 3]));
        self::assertNull(QuantityPolicy::historical(['unit_code' => 'L', 'unit_precision' => 5]));
        $snapshot = ['unit_code' => 'L', 'quantity_policy' => ['mode' => 'MEASURED', 'dimension' => 'VOLUME', 'precision' => 1, 'step' => '0.1']];
        self::assertSame(1, QuantityPolicy::historical($snapshot)->precision);
        self::assertNull(QuantityPolicy::historical(['unit_code' => 'UNKNOWN']));
        self::assertSame('0.1', $snapshot['quantity_policy']['step']);
    }

    public function test_volume_tier_thresholds_follow_the_selling_unit_precision(): void
    {
        $tier = [['minimum_quantity' => '2.5', 'price_centavos' => 90]];
        self::assertSame(['0.minimum_quantity' => ['This selling unit requires a whole number.']], VolumePricing::errors($tier, 100, QuantityPolicy::fromUnit(['code' => 'GAL'])));
        self::assertSame([], VolumePricing::errors($tier, 100, QuantityPolicy::fromUnit(['code' => 'US_GAL'])));
    }

    public function test_money_rounds_each_exact_line_half_up_before_summing_and_allocating(): void
    {
        self::assertSame(0, Money::lineAmount('0.499', 1));
        self::assertSame(1, Money::lineAmount('0.500', 1));
        self::assertSame(1, Money::lineAmount('0.501', 1));
        self::assertSame(100000000000000000, Money::lineAmount('1000000', 100000000000));
        $lines = [
            ['line_id' => 'a', 'quantity' => '1.125', 'unit_price_centavos' => 1801, 'tax_category' => 'VAT_12'],
            ['line_id' => 'b', 'quantity' => '2.5', 'unit_price_centavos' => 1001, 'tax_category' => 'VAT_12'],
        ];
        $money = FinancialCalculator::commercial($lines, 101, 0);
        self::assertSame(Money::lineAmount('1.125', 1801) + Money::lineAmount('2.5', 1001), $money['materials_gross_centavos']);
        self::assertSame($money['materials_gross_centavos'] - 101, $money['materials_payable_centavos']);
        self::assertSame($money, FinancialCalculator::commercial($lines, 101, 0));
        self::assertSame($money['materials_payable_centavos'], array_sum(array_column($money['lines'], 'payable_centavos')));
    }
}
