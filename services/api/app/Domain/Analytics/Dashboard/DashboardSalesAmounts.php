<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Dashboard;

/** Sales deductions, rather than payment cash flows; cancellation refunds are counted once. */
final class DashboardSalesAmounts
{
    /** @return array{gross: int, net: int, refunds: int, cancellation_deductions: int} */
    public static function forOrder(int $gross, bool $cancelled, int $onlineRefunds, int $cashReimbursements): array
    {
        $refunds = min($gross, $onlineRefunds + $cashReimbursements);
        $cancellationDeductions = $cancelled ? $gross - $refunds : 0;

        return ['gross' => $gross, 'net' => $gross - $refunds - $cancellationDeductions,
            'refunds' => $refunds, 'cancellation_deductions' => $cancellationDeductions];
    }
}
