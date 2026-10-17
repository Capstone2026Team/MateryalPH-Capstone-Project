<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Mining;

/**
 * Density-based outlier detection. Features are z-scored; the neighbourhood radius is not a guess: it is the Tukey
 * upper fence (Q3 + 1.5 × IQR) of every point's distance to its minPts-th nearest neighbour, so ordinary points always
 * sit inside a dense region and only genuinely isolated points become noise. A noise label means "unusual relative to
 * the others", never "wrong" or "at fault".
 */
final class Dbscan
{
    public const NOISE = -1;

    /**
     * @param  list<list<float|int>>  $points
     * @return array{labels: list<int>, clusters: int, noise: list<int>, epsilon: float|null, min_points: int}
     */
    public static function run(array $points, int $minPoints = 3): array
    {
        $n = count($points);
        if ($n <= $minPoints) {
            return ['labels' => array_fill(0, $n, 0), 'clusters' => $n === 0 ? 0 : 1, 'noise' => [], 'epsilon' => null, 'min_points' => $minPoints];
        }
        $z = self::standardize($points);
        $matrix = [];
        foreach ($z as $i => $a) {
            foreach ($z as $j => $b) {
                $matrix[$i][$j] = $i === $j ? 0.0 : self::distance($a, $b);
            }
        }
        $kDistances = [];
        foreach ($matrix as $row) {
            $sorted = $row;
            sort($sorted);
            $kDistances[] = $sorted[$minPoints]; // index 0 is the point itself
        }
        sort($kDistances);
        $q1 = self::quantile($kDistances, 0.25);
        $q3 = self::quantile($kDistances, 0.75);
        $epsilon = max(1e-6, $q3 + 1.5 * ($q3 - $q1));

        $labels = array_fill(0, $n, null);
        $cluster = 0;
        for ($i = 0; $i < $n; $i++) {
            if ($labels[$i] !== null) {
                continue;
            }
            $neighbours = self::region($matrix, $i, $epsilon);
            if (count($neighbours) < $minPoints) {
                $labels[$i] = self::NOISE;

                continue;
            }
            $labels[$i] = $cluster;
            $queue = array_values(array_diff($neighbours, [$i]));
            while ($queue !== []) {
                $j = array_shift($queue);
                if ($labels[$j] === self::NOISE) {
                    $labels[$j] = $cluster;
                }
                if ($labels[$j] !== null) {
                    continue;
                }
                $labels[$j] = $cluster;
                $reach = self::region($matrix, $j, $epsilon);
                if (count($reach) >= $minPoints) {
                    foreach ($reach as $candidate) {
                        if ($labels[$candidate] === null || $labels[$candidate] === self::NOISE) {
                            $queue[] = $candidate;
                        }
                    }
                }
            }
            $cluster++;
        }

        return ['labels' => array_map('intval', $labels), 'clusters' => $cluster, 'noise' => array_keys(array_filter($labels, static fn (mixed $label): bool => $label === self::NOISE)),
            'epsilon' => round($epsilon, 4), 'min_points' => $minPoints];
    }

    /**
     * @param  array<int, array<int, float>>  $matrix
     * @return list<int>
     */
    private static function region(array $matrix, int $i, float $epsilon): array
    {
        return array_keys(array_filter($matrix[$i], static fn (float $distance): bool => $distance <= $epsilon));
    }

    /** @param list<float> $sorted */
    private static function quantile(array $sorted, float $q): float
    {
        $position = $q * (count($sorted) - 1);
        $lower = (int) floor($position);
        $upper = (int) ceil($position);

        return $sorted[$lower] + ($sorted[$upper] - $sorted[$lower]) * ($position - $lower);
    }

    /**
     * @param  list<list<float|int>>  $points
     * @return list<list<float>>
     */
    private static function standardize(array $points): array
    {
        $dimensions = count($points[0]);
        $n = count($points);
        $stats = [];
        for ($d = 0; $d < $dimensions; $d++) {
            $column = array_map(static fn (array $point): float => (float) $point[$d], $points);
            $mean = array_sum($column) / $n;
            $variance = array_sum(array_map(static fn (float $value): float => ($value - $mean) ** 2, $column)) / $n;
            $stats[] = [$mean, $variance > 1e-12 ? sqrt($variance) : 1.0];
        }

        return array_map(static fn (array $point): array => array_map(static fn (int $d): float => ((float) $point[$d] - $stats[$d][0]) / $stats[$d][1], range(0, $dimensions - 1)), $points);
    }

    /**
     * @param  list<float>  $a
     * @param  list<float>  $b
     */
    private static function distance(array $a, array $b): float
    {
        $sum = 0.0;
        foreach ($a as $d => $value) {
            $sum += ($value - $b[$d]) ** 2;
        }

        return sqrt($sum);
    }
}
