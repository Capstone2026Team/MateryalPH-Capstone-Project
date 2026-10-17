<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Analytics\Mining\AssociationRules;
use App\Domain\Analytics\Mining\Dbscan;
use App\Domain\Analytics\Mining\KMeans;
use App\Domain\Analytics\Mining\TimeSeriesAnalysis;
use App\Domain\Analytics\Mining\VendorRiskClassifier;
use App\Domain\Scores\ScoreRules;
use PHPUnit\Framework\TestCase;

/** Dashboard data-mining rules: deterministic time series, K-Means, DBSCAN, Apriori and the workflow-threshold risk tree. */
final class DashboardMiningTest extends TestCase
{
    public function test_time_series_finds_a_rising_trend_weekday_pattern_and_forecasts_with_a_band(): void
    {
        $weekday = [0.0, 5.0, 8.0, 10.0, 6.0, -12.0, -17.0];
        $values = [];
        for ($i = 0; $i < 56; $i++) {
            $values[] = 100.0 + 2.0 * $i + $weekday[$i % 7] + (($i * 7) % 3 - 1) * 0.5;
        }
        $result = TimeSeriesAnalysis::analyze($values, 7);
        self::assertSame('OK', $result['state']);
        self::assertSame('INCREASING', $result['direction']);
        self::assertEqualsWithDelta(2.0, $result['slope'], 0.05);
        self::assertNotNull($result['seasonality']);
        self::assertGreaterThan(0.5, $result['seasonality']['strength']);
        self::assertCount(7, $result['forecast']);
        $first = $result['forecast'][0];
        self::assertEqualsWithDelta(100.0 + 2.0 * 56 + $weekday[0], $first['value'], 3.0);
        self::assertLessThan($first['value'], $first['lower']);
        self::assertGreaterThan($first['value'], $first['upper']);
        self::assertSame([], $result['anomalies']);
    }

    public function test_time_series_flags_a_spike_skips_gaps_and_refuses_too_little_data(): void
    {
        $values = array_fill(0, 30, 50.0);
        foreach ([0, 3, 6, 9, 12, 15, 18, 21, 24, 27] as $i) {
            $values[$i] += ($i % 2 === 0 ? 1.0 : -1.0);
        }
        $values[14] = null;
        $values[20] = 400.0;
        $result = TimeSeriesAnalysis::analyze($values, 3);
        self::assertSame('OK', $result['state']);
        self::assertContains(20, array_column($result['anomalies'], 'index'));
        self::assertIsFloat($result['fitted'][14], 'Gap positions still receive a fitted value for the chart line.');
        self::assertSame(29, $result['observed']);

        $thin = TimeSeriesAnalysis::analyze([1, 2, null, 4], 3);
        self::assertSame('INSUFFICIENT_DATA', $thin['state']);
        self::assertSame([], $thin['forecast']);
        self::assertSame('UNKNOWN', $thin['direction']);
    }

    public function test_time_series_calls_noise_flat_and_never_forecasts_below_zero(): void
    {
        $noise = [10.0, 12.0, 9.0, 11.0, 10.5, 9.5, 11.5, 10.0, 12.0, 9.0, 11.0, 10.5, 9.5, 11.5];
        self::assertSame('FLAT', TimeSeriesAnalysis::analyze($noise, 3)['direction']);

        $falling = [];
        for ($i = 0; $i < 20; $i++) {
            $falling[] = max(0.0, 40.0 - 3.0 * $i) + ($i % 2);
        }
        foreach (TimeSeriesAnalysis::analyze($falling, 5)['forecast'] as $point) {
            self::assertGreaterThanOrEqual(0.0, $point['lower']);
        }
    }

    public function test_moving_average_ignores_gaps(): void
    {
        self::assertSame([2.0, 3.0, 4.0, 5.0], TimeSeriesAnalysis::movingAverage([2, 4, null, 5], 2));
        self::assertSame([null, 4.0], TimeSeriesAnalysis::movingAverage([null, 4], 2));
    }

    public function test_kmeans_separates_obvious_groups_and_is_deterministic(): void
    {
        $points = [[1, 10], [1.2, 11], [0.9, 9.5], [1.1, 10.4], [9, 100], [9.3, 102], [8.8, 98], [5, 55], [5.2, 54], [4.9, 56]];
        $first = KMeans::best($points, 2, 4);
        $second = KMeans::best($points, 2, 4);
        self::assertSame($first, $second);
        self::assertSame(3, $first['k']);
        self::assertSame($first['assignments'][0], $first['assignments'][3]);
        self::assertSame($first['assignments'][4], $first['assignments'][6]);
        self::assertNotSame($first['assignments'][0], $first['assignments'][4]);
        self::assertNotSame($first['assignments'][7], $first['assignments'][4]);
        self::assertSame(10, array_sum($first['sizes']));
        self::assertGreaterThan(0.7, $first['silhouette']);
        $sorted = $first['sizes'];
        rsort($sorted);
        self::assertSame($sorted, $first['sizes'], 'Segments are ordered largest first so labels are stable.');
    }

    public function test_kmeans_handles_identical_points_and_tiny_inputs(): void
    {
        $same = KMeans::best([[3, 3], [3, 3], [3, 3], [3, 3]], 2, 3);
        self::assertSame(4, array_sum($same['sizes']));
        self::assertSame(['k' => 0, 'assignments' => [], 'centroids' => [], 'sizes' => [], 'silhouette' => null], KMeans::best([]));
        self::assertSame(1, KMeans::best([[1, 2]])['k']);
    }

    public function test_dbscan_marks_only_the_isolated_point_as_noise(): void
    {
        $points = [];
        for ($i = 0; $i < 12; $i++) {
            $points[] = [10 + ($i % 4) * 0.2, 20 + intdiv($i, 4) * 0.2];
        }
        $points[] = [60, 90];
        $result = Dbscan::run($points, 3);
        self::assertSame([12], $result['noise']);
        self::assertSame(1, $result['clusters']);
        self::assertNotNull($result['epsilon']);

        self::assertSame([], Dbscan::run(array_slice($points, 0, 12), 3)['noise']);
        self::assertSame([], Dbscan::run([[1, 1], [2, 2]], 3)['noise']);
    }

    public function test_apriori_reports_support_confidence_lift_and_hides_single_owner_patterns(): void
    {
        $baskets = [];
        for ($i = 0; $i < 6; $i++) {
            $baskets[] = ['items' => ['Cement', 'Sand', 'Gravel'], 'owner' => 'b'.$i];
        }
        for ($i = 6; $i < 9; $i++) {
            $baskets[] = ['items' => ['Cement', 'Sand'], 'owner' => 'b'.$i];
        }
        for ($i = 9; $i < 15; $i++) {
            $baskets[] = ['items' => ['Paint'], 'owner' => 'b'.$i];
        }
        $result = AssociationRules::mine($baskets, 3, 0.5, 3);
        self::assertSame(15, $result['baskets']);
        $rule = collect($result['rules'])->first(static fn (array $r): bool => $r['antecedent'] === ['Gravel'] && $r['consequent'] === ['Sand']);
        self::assertNotNull($rule);
        self::assertSame(6, $rule['support_count']);
        self::assertSame(1.0, $rule['confidence']);
        self::assertSame(round(1.0 / (9 / 15), 2), $rule['lift']);
        self::assertSame(6, $rule['owners']);
        self::assertTrue(collect($result['rules'])->every(static fn (array $r): bool => $r['lift'] > 1.0 && ! in_array('Paint', [...$r['antecedent'], ...$r['consequent']], true)));

        $oneBuyer = array_map(static fn (): array => ['items' => ['A', 'B'], 'owner' => 'only'], range(1, 8));
        self::assertSame([], AssociationRules::mine($oneBuyer, 2, 0.1, 5)['rules']);
        self::assertSame(['baskets' => 0, 'rules' => []], AssociationRules::mine([]));
    }

    public function test_risk_tree_uses_only_workflow_thresholds(): void
    {
        $rates = ['NFR' => '1.00', 'LSR' => '2.00', 'RR' => '1.00', 'ODR' => '0.50'];
        self::assertSame(VendorRiskClassifier::BUILDING, VendorRiskClassifier::classify(['vps' => null, 'ohs' => null, 'rates' => null])['class']);
        self::assertSame(VendorRiskClassifier::HEALTHY, VendorRiskClassifier::classify(['vps' => '4.10', 'ohs' => '5.00', 'rates' => $rates])['class']);
        self::assertSame(VendorRiskClassifier::BELOW, VendorRiskClassifier::classify(['vps' => '2.99', 'ohs' => '4.00', 'rates' => $rates])['class']);
        self::assertSame(VendorRiskClassifier::HEALTHY, VendorRiskClassifier::classify(['vps' => '3.00', 'ohs' => '2.50', 'rates' => $rates])['class'], 'The thresholds are strictly below.');
        self::assertSame(VendorRiskClassifier::BELOW, VendorRiskClassifier::classify(['vps' => null, 'ohs' => '2.49', 'rates' => $rates])['class']);

        $watch = VendorRiskClassifier::classify(['vps' => '4.00', 'ohs' => '4.50', 'rates' => ['NFR' => '2.01'] + $rates]);
        self::assertSame(VendorRiskClassifier::WATCH, $watch['class']);
        self::assertSame('LOW', $watch['bands']['NFR']);
        self::assertSame('NONE', $watch['bands']['LSR']);
        self::assertSame(['NFR' => 'HIGH', 'LSR' => 'MEDIUM', 'RR' => 'LOW', 'ODR' => 'NONE'], ['NFR' => ScoreRules::band('NFR', '10.01'), 'LSR' => ScoreRules::band('LSR', '8.01'), 'RR' => ScoreRules::band('RR', '2.01'), 'ODR' => ScoreRules::band('ODR', '1.00')]);
    }
}
