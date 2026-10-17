<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Dashboard;

use App\Domain\Analytics\Mining\TimeSeriesAnalysis;
use Carbon\CarbonImmutable;

/** One response shape for every dashboard forecast, Vendor and Admin alike. */
final class DashboardForecast
{
    /**
     * @param  array<string, mixed>  $trend  a TimeSeriesAnalysis result
     * @param  list<string>  $dates  the calendar day of every input value, oldest first
     * @return array<string, mixed>
     */
    public static function summarize(array $trend, array $dates, CarbonImmutable $lastDay, bool $money): array
    {
        $number = static fn (float $value): int|float => $money ? (int) round($value) : round($value, 1);

        return ['state' => $trend['state'], 'observed_days' => $trend['observed'], 'direction' => $trend['direction'], 'change_percent' => $trend['change_percent'], 'r_squared' => $trend['r_squared'],
            'weekday_strength' => $trend['seasonality']['strength'] ?? null,
            'expected_total' => $trend['forecast'] === [] ? null : $number(array_sum(array_column($trend['forecast'], 'value'))),
            'points' => array_map(static fn (array $p): array => ['date' => $lastDay->addDays($p['step'])->toDateString(), 'value' => $number($p['value']), 'lower' => $number($p['lower']), 'upper' => $number($p['upper'])], $trend['forecast']),
            'anomalies' => array_map(static fn (array $a): array => ['date' => $dates[$a['index']], 'value' => $number($a['value']), 'expected' => $number($a['expected']), 'deviation' => $a['deviation']], $trend['anomalies'])];
    }

    /**
     * @param  list<float|null>  $values
     * @param  list<string>  $dates
     * @return array{trend: array<string, mixed>, summary: array<string, mixed>}
     */
    public static function analyze(array $values, array $dates, CarbonImmutable $lastDay, bool $money, int $horizon, int $minActiveDays): array
    {
        $trend = TimeSeriesAnalysis::analyze($values, $horizon, minNonZero: $minActiveDays);

        return ['trend' => $trend, 'summary' => self::summarize($trend, $dates, $lastDay, $money)];
    }
}
