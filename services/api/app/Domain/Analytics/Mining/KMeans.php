<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Mining;

/**
 * Deterministic K-Means. Features are z-scored so a count and a percentage weigh equally; the initial centres use
 * farthest-point seeding (no random number generator), so the same data always yields the same segments. The number
 * of segments is chosen by the best mean silhouette. Segments describe patterns for display; they never rank, score
 * or sanction anyone.
 */
final class KMeans
{
    private const MAX_ITERATIONS = 100;

    /**
     * @param  list<list<float|int>>  $points  one feature vector per entity
     * @return array{k: int, assignments: list<int>, centroids: list<list<float>>, sizes: list<int>, silhouette: float|null}
     */
    public static function best(array $points, int $minK = 2, int $maxK = 4): array
    {
        $n = count($points);
        if ($n < 2) {
            return ['k' => $n, 'assignments' => array_fill(0, $n, 0), 'centroids' => $n === 1 ? [array_map('floatval', $points[0])] : [], 'sizes' => $n === 1 ? [1] : [], 'silhouette' => null];
        }
        $best = null;
        for ($k = max(2, $minK); $k <= min($maxK, $n - 1); $k++) {
            $result = self::cluster($points, $k);
            if ($best === null || ($result['silhouette'] ?? -2.0) > ($best['silhouette'] ?? -2.0) + 1e-9) {
                $best = $result;
            }
        }

        return $best ?? self::cluster($points, 1);
    }

    /**
     * @param  list<list<float|int>>  $points
     * @return array{k: int, assignments: list<int>, centroids: list<list<float>>, sizes: list<int>, silhouette: float|null}
     */
    public static function cluster(array $points, int $k): array
    {
        $n = count($points);
        $k = max(1, min($k, $n));
        [$z, $means, $deviations] = self::standardize($points);
        $centres = self::seed($z, $k);
        $assignments = array_fill(0, $n, 0);
        for ($iteration = 0; $iteration < self::MAX_ITERATIONS; $iteration++) {
            $changed = false;
            foreach ($z as $i => $point) {
                $nearest = self::nearest($point, $centres);
                if ($nearest !== $assignments[$i]) {
                    $assignments[$i] = $nearest;
                    $changed = true;
                }
            }
            $centres = self::recompute($z, $assignments, $centres);
            if (! $changed) {
                break;
            }
        }
        // Order segments by size (largest first), ties by the first member, so labels are stable across runs.
        $sizes = array_fill(0, $k, 0);
        $first = array_fill(0, $k, PHP_INT_MAX);
        foreach ($assignments as $i => $cluster) {
            $sizes[$cluster]++;
            $first[$cluster] = min($first[$cluster], $i);
        }
        $order = range(0, $k - 1);
        usort($order, static fn (int $a, int $b): int => [$sizes[$b], $first[$a]] <=> [$sizes[$a], $first[$b]]);
        $rank = array_flip($order);
        $assignments = array_map(static fn (int $cluster): int => $rank[$cluster], $assignments);
        $centroids = [];
        $orderedSizes = [];
        foreach ($order as $cluster) {
            $centroids[] = array_map(static fn (float $value, float $mean, float $deviation): float => round($value * $deviation + $mean, 4), $centres[$cluster], $means, $deviations);
            $orderedSizes[] = $sizes[$cluster];
        }

        return ['k' => $k, 'assignments' => $assignments, 'centroids' => $centroids, 'sizes' => $orderedSizes, 'silhouette' => self::silhouette($z, $assignments, $k)];
    }

    /**
     * @param  list<list<float|int>>  $points
     * @return array{0: list<list<float>>, 1: list<float>, 2: list<float>}
     */
    private static function standardize(array $points): array
    {
        $dimensions = count($points[0] ?? []);
        $n = count($points);
        $means = [];
        $deviations = [];
        for ($d = 0; $d < $dimensions; $d++) {
            $column = array_map(static fn (array $point): float => (float) $point[$d], $points);
            $mean = array_sum($column) / max(1, $n);
            $variance = array_sum(array_map(static fn (float $value): float => ($value - $mean) ** 2, $column)) / max(1, $n);
            $means[] = $mean;
            $deviations[] = $variance > 1e-12 ? sqrt($variance) : 1.0;
        }
        $z = array_map(static fn (array $point): array => array_map(static fn (int $d): float => ((float) $point[$d] - $means[$d]) / $deviations[$d], range(0, max(0, $dimensions - 1))), $points);

        return [$z, $means, $deviations];
    }

    /**
     * @param  list<list<float>>  $z
     * @return list<list<float>>
     */
    private static function seed(array $z, int $k): array
    {
        $dimensions = count($z[0] ?? []);
        $centre = array_map(static fn (int $d): float => array_sum(array_column($z, $d)) / max(1, count($z)), range(0, max(0, $dimensions - 1)));
        // First centre: the point closest to the overall centre; each next: the point farthest from all chosen centres.
        $chosen = [self::nearest($centre, $z)];
        while (count($chosen) < $k) {
            $bestIndex = 0;
            $bestDistance = -1.0;
            foreach ($z as $i => $point) {
                $distance = min(array_map(static fn (int $c): float => self::distance($point, $z[$c]), $chosen));
                if ($distance > $bestDistance + 1e-12) {
                    $bestDistance = $distance;
                    $bestIndex = $i;
                }
            }
            $chosen[] = $bestIndex;
        }

        return array_map(static fn (int $i): array => $z[$i], $chosen);
    }

    /**
     * @param  list<list<float>>  $z
     * @param  list<int>  $assignments
     * @param  list<list<float>>  $previous
     * @return list<list<float>>
     */
    private static function recompute(array $z, array $assignments, array $previous): array
    {
        $dimensions = count($z[0] ?? []);
        $k = count($previous);
        $sums = array_fill(0, $k, array_fill(0, $dimensions, 0.0));
        $counts = array_fill(0, $k, 0);
        foreach ($z as $i => $point) {
            $counts[$assignments[$i]]++;
            foreach ($point as $d => $value) {
                $sums[$assignments[$i]][$d] += $value;
            }
        }
        $centres = [];
        for ($c = 0; $c < $k; $c++) {
            $centres[] = $counts[$c] === 0 ? $previous[$c] : array_map(static fn (float $sum): float => $sum / $counts[$c], $sums[$c]);
        }

        return $centres;
    }

    /**
     * @param  list<float>  $point
     * @param  list<list<float>>  $centres
     */
    private static function nearest(array $point, array $centres): int
    {
        $best = 0;
        $bestDistance = INF;
        foreach ($centres as $i => $centre) {
            $distance = self::distance($point, $centre);
            if ($distance < $bestDistance - 1e-12) {
                $bestDistance = $distance;
                $best = $i;
            }
        }

        return $best;
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

    /**
     * @param  list<list<float>>  $z
     * @param  list<int>  $assignments
     */
    private static function silhouette(array $z, array $assignments, int $k): ?float
    {
        $n = count($z);
        if ($k < 2 || $n < 3) {
            return null;
        }
        $total = 0.0;
        foreach ($z as $i => $point) {
            $own = $assignments[$i];
            $inside = [];
            $outside = [];
            foreach ($z as $j => $other) {
                if ($i === $j) {
                    continue;
                }
                $distance = self::distance($point, $other);
                if ($assignments[$j] === $own) {
                    $inside[] = $distance;
                } else {
                    $outside[$assignments[$j]][] = $distance;
                }
            }
            if ($inside === [] || $outside === []) {
                continue;
            }
            $a = array_sum($inside) / count($inside);
            $b = min(array_map(static fn (array $distances): float => array_sum($distances) / count($distances), $outside));
            $total += max($a, $b) > 0.0 ? ($b - $a) / max($a, $b) : 0.0;
        }

        return round($total / $n, 4);
    }
}
