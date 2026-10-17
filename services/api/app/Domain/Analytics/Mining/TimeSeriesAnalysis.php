<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Mining;

/**
 * Descriptive time-series mining for dashboard charts: a least-squares trend, an additive weekday (or any fixed
 * period) seasonal profile, a forecast with a prediction band and residual anomalies. It is deterministic, has no
 * randomness and no external dependency. Output is an analytical estimate for display only: it never feeds a score,
 * a ranking, a fee, a tax figure or an enforcement decision.
 *
 * A null input value is a gap (missing or suppressed day), never zero: gaps are skipped when fitting and the chart
 * keeps the break.
 */
final class TimeSeriesAnalysis
{
    /** Fewest observed points before a trend, forecast or anomaly is offered; below it the result says so. */
    public const MIN_POINTS = 7;

    /** Two-sided 95% normal quantile used for the prediction band. */
    private const Z_95 = 1.96;

    /** A point further than this many residual standard deviations from its fitted value is flagged. */
    private const ANOMALY_SIGMA = 3.0;

    /** Slope t-statistic that separates a real trend from noise (about 95%). */
    private const SLOPE_T = 2.0;

    /**
     * @param  list<float|int|null>  $values  one value per period, oldest first
     * @return array{
     *     state: string, observed: int, direction: string, slope: float|null, change_percent: float|null, r_squared: float|null,
     *     seasonality: array{period: int, indices: list<float>, strength: float|null}|null,
     *     fitted: list<float|null>, forecast: list<array{step: int, value: float, lower: float, upper: float}>,
     *     anomalies: list<array{index: int, value: float, expected: float, deviation: float}>, moving_average: list<float|null>
     * }
     */
    public static function analyze(array $values, int $horizon = 7, int $period = 7, bool $nonNegative = true, int $movingWindow = 7, int $minNonZero = 0): array
    {
        $n = count($values);
        $observed = [];
        $nonZero = 0;
        foreach ($values as $index => $value) {
            if ($value !== null) {
                $observed[] = [(float) $index, (float) $value];
                $nonZero += (float) $value !== 0.0 ? 1 : 0;
            }
        }
        $count = count($observed);
        $empty = ['state' => 'INSUFFICIENT_DATA', 'observed' => $count, 'direction' => 'UNKNOWN', 'slope' => null, 'change_percent' => null, 'r_squared' => null, 'seasonality' => null,
            'fitted' => array_fill(0, $n, null), 'forecast' => [], 'anomalies' => [], 'moving_average' => self::movingAverage($values, $movingWindow)];
        // $minNonZero keeps a store or market with only a few active days from receiving a "trend" built from zero-filled days.
        if ($count < self::MIN_POINTS || $nonZero < $minNonZero) {
            return $empty;
        }

        // Ordinary least squares on the observed points.
        $meanX = array_sum(array_column($observed, 0)) / $count;
        $meanY = array_sum(array_column($observed, 1)) / $count;
        $sxx = 0.0;
        $sxy = 0.0;
        foreach ($observed as [$x, $y]) {
            $sxx += ($x - $meanX) ** 2;
            $sxy += ($x - $meanX) * ($y - $meanY);
        }
        $slope = $sxx > 0.0 ? $sxy / $sxx : 0.0;
        $intercept = $meanY - $slope * $meanX;

        // Additive seasonal profile from the detrended residuals, only when at least two full cycles exist.
        $indices = array_fill(0, $period, 0.0);
        $seasonal = null;
        if ($period > 1 && $n >= 2 * $period && $count >= 2 * $period) {
            $sums = array_fill(0, $period, 0.0);
            $counts = array_fill(0, $period, 0);
            foreach ($observed as [$x, $y]) {
                $slot = (int) $x % $period;
                $sums[$slot] += $y - ($intercept + $slope * $x);
                $counts[$slot]++;
            }
            foreach ($sums as $slot => $sum) {
                $indices[$slot] = $counts[$slot] > 0 ? $sum / $counts[$slot] : 0.0;
            }
            $centre = array_sum($indices) / $period;
            $indices = array_map(static fn (float $index): float => $index - $centre, $indices);
            $seasonal = ['period' => $period, 'indices' => array_map(static fn (float $index): float => round($index, 2), $indices), 'strength' => null];
        }

        $fit = static fn (float $x): float => $intercept + $slope * $x + $indices[(int) $x % $period];
        $sse = 0.0;
        $sst = 0.0;
        $sseTrendOnly = 0.0;
        foreach ($observed as [$x, $y]) {
            $sse += ($y - $fit($x)) ** 2;
            $sseTrendOnly += ($y - ($intercept + $slope * $x)) ** 2;
            $sst += ($y - $meanY) ** 2;
        }
        $degrees = max(1, $count - 2 - ($seasonal === null ? 0 : $period - 1));
        $sigma = sqrt($sse / $degrees);
        $rSquared = $sst > 0.0 ? max(0.0, 1.0 - $sse / $sst) : null;
        if ($seasonal !== null) {
            $seasonal['strength'] = $sseTrendOnly > 0.0 ? round(max(0.0, 1.0 - $sse / $sseTrendOnly), 4) : null;
        }

        // Slope significance decides the label; a flat or noisy series is "flat", not a manufactured trend.
        $seSlope = $sxx > 0.0 ? sqrt(($sseTrendOnly / max(1, $count - 2)) / $sxx) : 0.0;
        $t = $seSlope > 0.0 ? $slope / $seSlope : 0.0;
        $direction = abs($t) >= self::SLOPE_T ? ($slope > 0 ? 'INCREASING' : 'DECREASING') : 'FLAT';
        $start = $intercept;
        $end = $intercept + $slope * ($n - 1);
        $change = abs($start) > 1e-9 ? ($end - $start) / abs($start) * 100.0 : null;

        $floor = static fn (float $value): float => $value;
        if ($nonNegative) {
            $floor = static fn (float $value): float => max(0.0, $value);
        }
        $fitted = [];
        $anomalies = [];
        foreach ($values as $index => $value) {
            $expected = $floor($fit((float) $index));
            $fitted[] = round($expected, 2);
            if ($value !== null && $sigma > 0.0 && abs((float) $value - $expected) > self::ANOMALY_SIGMA * $sigma) {
                $anomalies[] = ['index' => $index, 'value' => round((float) $value, 2), 'expected' => round($expected, 2), 'deviation' => round(((float) $value - $expected) / $sigma, 2)];
            }
        }
        $forecast = [];
        for ($step = 1; $step <= $horizon; $step++) {
            $x = (float) ($n - 1 + $step);
            $expected = $fit($x);
            $width = self::Z_95 * $sigma * sqrt(1.0 + 1.0 / $count + ($sxx > 0.0 ? (($x - $meanX) ** 2) / $sxx : 0.0));
            $forecast[] = ['step' => $step, 'value' => round($floor($expected), 2), 'lower' => round($floor($expected - $width), 2), 'upper' => round($floor($expected + $width), 2)];
        }

        return ['state' => 'OK', 'observed' => $count, 'direction' => $direction, 'slope' => round($slope, 4), 'change_percent' => $change === null ? null : round($change, 1), 'r_squared' => $rSquared === null ? null : round($rSquared, 4),
            'seasonality' => $seasonal, 'fitted' => $fitted, 'forecast' => $forecast, 'anomalies' => $anomalies, 'moving_average' => self::movingAverage($values, $movingWindow)];
    }

    /**
     * Trailing moving average that ignores gaps; null until the window holds at least one observation.
     *
     * @param  list<float|int|null>  $values
     * @return list<float|null>
     */
    public static function movingAverage(array $values, int $window): array
    {
        $out = [];
        foreach (array_keys($values) as $index) {
            $slice = array_filter(array_slice($values, max(0, $index - $window + 1), min($window, $index + 1)), static fn (mixed $value): bool => $value !== null);
            $out[] = $slice === [] ? null : round(array_sum($slice) / count($slice), 2);
        }

        return $out;
    }
}
