<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;

final class TaxCalendar
{
    public const FORMS = ['2307', '0619-E', '1601-EQ', 'QAP', '1604-E', 'ANNUAL_ALPHALIST'];

    public const SOURCE = 'FIN-08 non-eFPS demo v1; RR 11-2018 and RMC 55-2026. External filing requires current BIR calendar review.';

    /** @return array{start: string, end: string, nominal_due: string} */
    public static function period(string $form, string $start): array
    {
        $date = CarbonImmutable::parse($start, 'Asia/Manila')->startOfDay();
        if (! in_array($form, self::FORMS, true) || $date->day !== 1) {
            throw new AuthenticationException('INVALID_TAX_PERIOD', 'Select the first day of a calendar reporting period.', 422);
        }
        if ($form === '0619-E') {
            if ($date->month % 3 === 0) {
                throw new AuthenticationException('INVALID_TAX_PERIOD', '0619-E support covers the first two calendar months of a quarter.', 422);
            }
            $end = $date->endOfMonth();
            $due = $date->addMonth()->day(10);
        } elseif (in_array($form, ['1604-E', 'ANNUAL_ALPHALIST'], true)) {
            if ($date->month !== 1) {
                throw new AuthenticationException('INVALID_TAX_PERIOD', 'Annual packages use the calendar year, starting January 1.', 422);
            }
            $end = $date->endOfYear();
            $due = $date->addYear()->month(3);
        } else {
            if (! in_array($date->month, [1, 4, 7, 10], true)) {
                throw new AuthenticationException('INVALID_TAX_PERIOD', 'Quarterly packages start January, April, July or October.', 422);
            }
            $end = $date->addMonths(2)->endOfMonth();
            $due = $form === '2307' ? $date->addMonths(3)->day(20) : $date->addMonths(3)->endOfMonth();
        }

        return ['start' => $date->toDateString(), 'end' => $end->toDateString(), 'nominal_due' => $due->toDateString()];
    }

    public static function atc(string $entity, string $payeeClass, string $date): ?string
    {
        // This rule version covers the synchronized demo. Older records require their historical ATC version.
        if ($date < '2025-05-20' || ! in_array($payeeClass, ['INDIVIDUAL', 'NON_INDIVIDUAL', 'CORPORATION', 'CORPORATE', 'PARTNERSHIP', 'COOPERATIVE'], true)) {
            return null;
        }
        $prefix = $payeeClass === 'INDIVIDUAL' ? 'WI' : 'WC';

        return match ($entity) {
            'DEMO_PLATFORM_WITHHOLDER' => $prefix.'820',
            'DEMO_PROVIDER_WITHHOLDER' => $prefix.'830',
            default => null,
        };
    }
}
