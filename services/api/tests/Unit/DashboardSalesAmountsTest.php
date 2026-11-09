<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Analytics\Dashboard\DashboardSalesAmounts;
use PHPUnit\Framework\TestCase;

final class DashboardSalesAmountsTest extends TestCase
{
    public function test_online_and_confirmed_cash_refunds_reduce_earnings_and_reconcile(): void
    {
        $amounts = DashboardSalesAmounts::forOrder(100000, false, 12500, 7500);
        self::assertSame(['gross' => 100000, 'net' => 80000, 'refunds' => 20000, 'cancellation_deductions' => 0], $amounts);
        self::assertSame($amounts['gross'], $amounts['net'] + $amounts['refunds'] + $amounts['cancellation_deductions']);
    }

    public function test_cancelled_orders_remove_only_the_value_not_already_counted_as_a_refund(): void
    {
        foreach ([0, 20000, 100000] as $refund) {
            $amounts = DashboardSalesAmounts::forOrder(100000, true, $refund, 0);
            self::assertSame(0, $amounts['net']);
            self::assertSame($refund, $amounts['refunds']);
            self::assertSame(100000 - $refund, $amounts['cancellation_deductions']);
            self::assertSame(100000, $amounts['net'] + $amounts['refunds'] + $amounts['cancellation_deductions']);
        }
    }

    public function test_refund_deductions_cannot_exceed_the_confirmed_sale_value(): void
    {
        self::assertSame(['gross' => 10000, 'net' => 0, 'refunds' => 10000, 'cancellation_deductions' => 0],
            DashboardSalesAmounts::forOrder(10000, false, 9000, 3000));
        self::assertSame(['gross' => 0, 'net' => 0, 'refunds' => 0, 'cancellation_deductions' => 0],
            DashboardSalesAmounts::forOrder(0, false, 0, 0));
    }

    public function test_period_totals_reconcile_even_when_a_later_day_has_no_activity(): void
    {
        $days = [DashboardSalesAmounts::forOrder(3298275, false, 236000, 0),
            DashboardSalesAmounts::forOrder(188745, true, 0, 0), DashboardSalesAmounts::forOrder(0, false, 0, 0)];
        self::assertSame(3487020, array_sum(array_column($days, 'gross')));
        self::assertSame(3062275, array_sum(array_column($days, 'net')));
        self::assertSame(236000, array_sum(array_column($days, 'refunds')));
        self::assertSame(188745, array_sum(array_column($days, 'cancellation_deductions')));
    }
}
