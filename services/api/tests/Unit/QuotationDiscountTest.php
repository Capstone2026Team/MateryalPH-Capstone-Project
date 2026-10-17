<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Finance\FinancialCalculator;
use App\Domain\Finance\Money;
use App\Domain\Finance\VendorDiscount;
use App\Domain\Identity\AuthenticationException;
use PHPUnit\Framework\TestCase;

final class QuotationDiscountTest extends TestCase
{
    public function test_materials_discount_changes_materials_vat_and_keeps_delivery_separate(): void
    {
        $assessment = VendorDiscount::assess(['scope' => 'MATERIALS', 'percent' => '10'], 11200, 5000, true);
        $money = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 11200, 'tax_category' => 'VAT_12']], $assessment['deduction_centavos'], 5000);
        self::assertSame(['MATERIALS', '10.00', 11200, 1120], array_values($assessment));
        self::assertSame([10080, 1080, 5000, 15080], [$money['materials_payable_centavos'], $money['materials_vat_centavos'], $money['delivery_centavos'], $money['commercial_total_centavos']]);
    }

    public function test_delivery_discount_does_not_reduce_materials_vat_or_commission(): void
    {
        $assessment = VendorDiscount::assess(['scope' => 'DELIVERY', 'percent' => '10'], 11200, 5000, true);
        $money = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 11200, 'tax_category' => 'VAT_12']], 0, 5000 - $assessment['deduction_centavos']);
        self::assertSame([11200, 1200, 0, 4500, 15700], [$money['materials_payable_centavos'], $money['materials_vat_centavos'], $money['vendor_discount_centavos'], $money['delivery_centavos'], $money['commercial_total_centavos']]);
        self::assertSame(200, Money::commission($money['materials_exclusive_centavos']));
    }

    public function test_half_cent_deductions_round_half_up_and_full_delivery_discount_is_supported(): void
    {
        self::assertSame(1, VendorDiscount::assess(['scope' => 'DELIVERY', 'percent' => '10'], 100, 5, true)['deduction_centavos']);
        self::assertSame(5000, VendorDiscount::assess(['scope' => 'DELIVERY', 'percent' => '100.00'], 11200, 5000, true)['deduction_centavos']);
    }

    public function test_invalid_percentages_are_rejected_without_rounding_or_clamping(): void
    {
        foreach (['-1', '100.01', '1.001', '1e1', ''] as $percent) {
            try {
                VendorDiscount::assess(['scope' => 'MATERIALS', 'percent' => $percent], 10000, 5000, true);
                self::fail('An invalid discount was accepted.');
            } catch (AuthenticationException) {
                self::assertTrue(true);
            }
        }
    }

    public function test_delivery_discount_is_unavailable_for_self_pickup(): void
    {
        $this->expectException(AuthenticationException::class);
        VendorDiscount::assess(['scope' => 'DELIVERY', 'percent' => '10'], 10000, 0, false);
    }

    public function test_materials_discount_must_leave_a_positive_subtotal(): void
    {
        $this->expectException(AuthenticationException::class);
        VendorDiscount::assess(['scope' => 'MATERIALS', 'percent' => '100'], 10000, 5000, true);
    }
}
