<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Dashboard;

use App\Domain\Analytics\Geo\DisclosureControl;
use App\Domain\Analytics\Geo\GeoAnalyticsService;
use App\Domain\Analytics\Geo\PsgcHierarchy;
use App\Domain\Analytics\Mining\AssociationRules;
use App\Domain\Analytics\Mining\Dbscan;
use App\Domain\Analytics\Mining\KMeans;
use App\Domain\Analytics\Mining\VendorRiskClassifier;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Scores\PublicScores;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Admin Dashboard read model. Marketplace charts and mining are built from the same disclosure-controlled geographic
 * read model the Marketplace Analytics page uses, so a suppressed cell is a gap here too and a small group can never be
 * recovered from a forecast, a segment or a rule. Each section needs its own permission and is null without it:
 * `analytics.view_aggregates` for the marketplace, category and area sections and `scores.view` for Vendor health.
 *
 * Mining is descriptive only. Forecasts are planning estimates, segments and outlier areas are patterns, association
 * rules are co-occurrence in past orders (never causation or a Buyer-level recommendation) and the Vendor class is an
 * indicator built from the System Workflow's own thresholds: none of it changes a score, badge, ranking, fee or
 * sanction, and an Admin still decides every enforcement action with a recorded reason.
 */
final class AdminDashboardInsights
{
    public const PERIODS = [30, 90];

    private const FORECAST_DAYS = 7;

    /** Days with at least one order before a trend or forecast is offered. */
    private const MIN_ACTIVE_DAYS = 7;

    private const AREA_LABELS = [2 => ['Established markets', 'Emerging markets'], 3 => ['Established markets', 'Developing markets', 'Emerging markets'], 4 => ['Leading markets', 'Established markets', 'Developing markets', 'Emerging markets']];

    public function __construct(private readonly AdminAccess $access, private readonly GeoAnalyticsService $geo, private readonly PsgcHierarchy $psgc) {}

    /**
     * @param  array{dataset?: string, area?: string|null, days?: int|string, from?: string, to?: string}  $input
     * @return array<string, mixed>
     */
    public function build(Request $request, array $input): array
    {
        $actor = $this->access->actor($request);
        $days = (int) ($input['days'] ?? 30);
        if (! in_array($days, self::PERIODS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a period of 30 or 90 days.', 422);
        }
        $has = static fn (string $permission): bool => in_array($permission, $actor['permissions'], true);
        $access = ['marketplace' => $has('analytics.view_aggregates'), 'vendor_health' => $has('scores.view')];
        $dataset = ($input['dataset'] ?? 'TEST') === 'DEMO' ? 'DEMO' : 'TEST';
        $area = isset($input['area']) && $input['area'] !== '' ? (string) $input['area'] : null;

        $marketplace = null;
        $unavailable = null;
        if ($access['marketplace']) {
            try {
                $marketplace = $this->marketplace($request, $dataset, $area, $days, $input);
            } catch (AuthenticationException $exception) {
                if ($exception->errorCode === 'GEO_ANALYTICS_UNAVAILABLE') {
                    $unavailable = 'Geographic analytics is turned off in Platform Settings.';
                } else {
                    throw $exception;
                }
            }
        }

        return ['generated_at' => CarbonImmutable::now()->toIso8601String(), 'access' => $access, 'definitions' => self::DEFINITIONS, 'marketplace' => $marketplace, 'marketplace_unavailable_reason' => $unavailable,
            'vendor_health' => $access['vendor_health'] ? $this->vendorHealth() : null];
    }

    public const DEFINITIONS = [
        'forecast' => 'A least-squares trend plus a weekday pattern fitted to the daily series shown, with a 95% prediction band. Suppressed days are gaps and are not fitted. It is a planning estimate, not a target, a score or a promise.',
        'area_segments' => 'K-Means groups areas with similar supply and demand (Vendors, registered Buyers, orders and GMV). Areas with a suppressed cell are left out. Groups describe patterns, not rankings of merit.',
        'unusual_areas' => 'DBSCAN marks areas whose supply and demand sit apart from all the others. Unusual is not wrong.',
        'recruitment_signals' => 'Areas with confirmed orders and the most orders per active Vendor placed there. It supports Vendor recruitment decisions and is not an official market statistic.',
        'category_rules' => 'Apriori finds categories that appear together in the same confirmed order more often than chance (lift above 1). A rule needs the minimum number of distinct Buyers set in Platform Settings. Co-occurrence is not causation.',
        'vendor_classification' => 'A fixed decision tree over the System Workflow’s published thresholds (VPS below 3.00, OHS below 2.50, the OHS penalty bands and the sample gates). It is an indicator only and creates no flag, warning or sanction.',
    ];

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private function marketplace(Request $request, string $dataset, ?string $area, int $days, array $input): array
    {
        $latest = DB::table('analytics_geo_runs')->where('environment', $dataset)->where('state', 'PUBLISHED')->max('through_date');
        $to = CarbonImmutable::parse((string) ($input['to'] ?? $latest ?? CarbonImmutable::now('Asia/Manila')->toDateString()));
        $from = isset($input['from']) ? CarbonImmutable::parse((string) $input['from']) : $to->subDays($days - 1);
        $days = (int) $from->diffInDays($to) + 1;
        $filters = ['dataset' => $dataset, 'from' => $from->toDateString(), 'to' => $to->toDateString(), 'granularity' => 'DAY'] + ($area === null ? [] : ['area' => $area]);
        $data = $this->geo->dashboard($request, $filters);

        $trends = $data['trends'];
        $gross = array_map(static fn (array $point): ?float => $point['gross_gmv_centavos'] === null ? null : (float) $point['gross_gmv_centavos'], $trends);
        $volume = array_map(static fn (array $point): ?float => $point['order_volume'] === null ? null : (float) $point['order_volume'], $trends);
        $dates = array_column($trends, 'bucket');
        $grossForecast = DashboardForecast::analyze($gross, $dates, $to, true, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS);
        $volumeForecast = DashboardForecast::analyze($volume, $dates, $to, false, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS);
        $grossTrend = $grossForecast['trend'];
        $volumeTrend = $volumeForecast['trend'];
        $series = [];
        foreach ($trends as $i => $point) {
            $series[] = ['date' => $point['bucket'], 'gross_gmv_centavos' => $point['gross_gmv_centavos'], 'net_gmv_centavos' => $point['net_gmv_centavos'], 'order_volume' => $point['order_volume'], 'suppressed' => $point['suppressed'],
                'gross_average_centavos' => $grossTrend['moving_average'][$i] === null ? null : (int) round($grossTrend['moving_average'][$i]), 'volume_average' => $volumeTrend['moving_average'][$i]];
        }
        $activity = array_map(static fn (array $point): array => ['date' => $point['date'], 'buyer_dau' => $point['buyer_dau'], 'vendor_dau' => $point['vendor_dau'], 'buyer_mau' => $point['buyer_mau'], 'vendor_mau' => $point['vendor_mau']], $data['activity_trend']);

        return ['scope' => $data['scope'], 'dataset' => $data['dataset'], 'period' => $data['period'] + ['days' => $days], 'disclosure' => $data['disclosure'], 'kpis' => $data['kpis'], 'series' => $series,
            'forecast' => ['horizon_days' => self::FORECAST_DAYS, 'gross_gmv' => $grossForecast['summary'], 'order_volume' => $volumeForecast['summary']], 'activity' => $activity,
            'areas' => $this->areas($data), 'categories' => $this->categories($dataset, $area, $from, $to)];
    }

    /**
     * Area segments (K-Means), unusual areas (DBSCAN) and recruitment signals over the disclosure-controlled child rows.
     *
     * @param  array<string, mixed>  $data
     * @return array<string, mixed>
     */
    private function areas(array $data): array
    {
        $rows = [];
        $excluded = 0;
        foreach ($data['children'] as $child) {
            $values = [$child['vendor_count'], $child['registered_buyers']['value'], $child['order_volume']['value'], $child['gross_gmv_centavos']['value']];
            if (in_array(null, $values, true)) {
                $excluded++;

                continue;
            }
            if (array_sum($values) === 0) {
                continue;
            }
            $rows[] = ['code' => (string) $child['code'], 'name' => (string) $child['name'], 'vendors' => (int) $values[0], 'buyers' => (int) $values[1], 'orders' => (int) $values[2], 'gmv' => (int) $values[3]];
        }
        $base = ['children_label' => $data['scope']['children_label'], 'considered' => count($rows), 'excluded_suppressed' => $excluded, 'features' => ['Active Vendors', 'Registered Buyers', 'Orders', 'Gross GMV']];
        if (count($rows) < 4) {
            return $base + ['state' => 'INSUFFICIENT_DATA', 'reason' => 'At least four areas with visible supply or demand are needed to group them.', 'k' => null, 'segments' => [], 'silhouette' => null, 'unusual' => [], 'recruitment' => [], 'points' => []];
        }
        $points = array_map(static fn (array $r): array => [$r['vendors'], $r['buyers'], $r['orders'], $r['gmv']], $rows);
        $result = KMeans::best($points, 2, 4);
        $labels = self::AREA_LABELS[$result['k']] ?? [];
        $order = array_keys($result['centroids']);
        usort($order, static fn (int $a, int $b): int => [$result['centroids'][$b][2], $a] <=> [$result['centroids'][$a][2], $b]);
        $labelOf = [];
        foreach ($order as $position => $segment) {
            $labelOf[$segment] = $labels[$position] ?? 'Segment '.($segment + 1);
        }
        $segments = [];
        foreach ($result['centroids'] as $index => $centroid) {
            $members = array_values(array_filter(array_keys($result['assignments']), static fn (int $i): bool => $result['assignments'][$i] === $index));
            usort($members, static fn (int $a, int $b): int => [$rows[$b]['orders'], $rows[$a]['name']] <=> [$rows[$a]['orders'], $rows[$b]['name']]);
            $segments[] = ['id' => $index, 'label' => $labelOf[$index], 'size' => $result['sizes'][$index], 'average_vendors' => round($centroid[0], 1), 'average_buyers' => round($centroid[1], 1),
                'average_orders' => round($centroid[2], 1), 'average_gmv_centavos' => (int) round($centroid[3]), 'examples' => array_map(static fn (int $i): string => $rows[$i]['name'], array_slice($members, 0, 4))];
        }
        usort($segments, static fn (array $a, array $b): int => $b['average_orders'] <=> $a['average_orders']);
        $outliers = Dbscan::run($points, 3);
        $recruitment = array_values(array_filter($rows, static fn (array $r): bool => $r['orders'] > 0));
        usort($recruitment, static fn (array $a, array $b): int => [$b['orders'] / max(1, $b['vendors']), $a['name']] <=> [$a['orders'] / max(1, $a['vendors']), $b['name']]);

        return $base + ['state' => 'OK', 'reason' => null, 'k' => $result['k'], 'silhouette' => $result['silhouette'], 'segments' => $segments,
            'unusual' => array_map(static fn (int $i): array => ['code' => $rows[$i]['code'], 'name' => $rows[$i]['name'], 'vendors' => $rows[$i]['vendors'], 'orders' => $rows[$i]['orders'], 'gmv_centavos' => $rows[$i]['gmv']], $outliers['noise']),
            'recruitment' => array_map(static fn (array $r): array => ['code' => $r['code'], 'name' => $r['name'], 'vendors' => $r['vendors'], 'orders' => $r['orders'], 'orders_per_vendor' => round($r['orders'] / max(1, $r['vendors']), 1)], array_slice($recruitment, 0, 5)),
            'points' => array_map(static fn (array $r, int $segment): array => ['name' => $r['name'], 'vendors' => $r['vendors'], 'orders' => $r['orders'], 'segment' => $labelOf[$segment]], $rows, $result['assignments'])];
    }

    /**
     * Category demand and category association rules, both behind the small-cell rule.
     *
     * @return array<string, mixed>
     */
    private function categories(string $dataset, ?string $area, CarbonImmutable $from, CarbonImmutable $to): array
    {
        $k = DisclosureControl::current();
        $query = DB::table('analytics_order_facts as f')->join('analytics_order_line_facts as l', 'l.analytics_order_fact_id', '=', 'f.id')->where('f.environment', $dataset)
            ->whereBetween('f.confirmed_on', [$from->toDateString(), $to->toDateString()])->whereNotNull('l.material_category_id');
        $column = PsgcHierarchy::selectionColumn($this->psgc->depth($area));
        if ($column !== null) {
            $query->where('f.'.$column, $area);
        }
        $rows = $query->get(['f.id', 'f.buyer_key', 'l.material_category_id']);
        $names = DB::table('material_categories')->whereIn('id', $rows->pluck('material_category_id')->unique()->all())->pluck('name', 'id');
        $orders = [];
        $baskets = [];
        foreach ($rows as $row) {
            $category = (string) $row->material_category_id;
            $orders[$category]['orders'][(string) $row->id] = true;
            $orders[$category]['buyers'][(string) $row->buyer_key] = true;
            $baskets[(string) $row->id]['items'][] = $category;
            $baskets[(string) $row->id]['owner'] = (string) $row->buyer_key;
        }
        $demand = [];
        $suppressed = 0;
        foreach ($orders as $category => $entry) {
            if ($k->suppressed(count($entry['buyers']))) {
                $suppressed++;

                continue;
            }
            $demand[] = ['category' => (string) ($names[$category] ?? 'Unmapped'), 'orders' => count($entry['orders'])];
        }
        usort($demand, static fn (array $a, array $b): int => [$b['orders'], $a['category']] <=> [$a['orders'], $b['category']]);
        $mined = AssociationRules::mine(array_values($baskets), $k->minimumPersons, 0.3, $k->minimumPersons, 8);
        $rules = array_map(static fn (array $rule): array => ['antecedent' => array_map(static fn (string $id): string => (string) ($names[$id] ?? 'Unmapped'), $rule['antecedent']),
            'consequent' => array_map(static fn (string $id): string => (string) ($names[$id] ?? 'Unmapped'), $rule['consequent'])] + array_diff_key($rule, ['antecedent' => true, 'consequent' => true, 'owners' => true]), $mined['rules']);

        return ['demand' => array_slice($demand, 0, 8), 'suppressed_categories' => $suppressed, 'rules' => $rules, 'baskets' => $mined['baskets'], 'minimum_buyers' => $k->minimumPersons];
    }

    /** @return array<string, mixed> */
    private function vendorHealth(): array
    {
        $latest = DB::table('score_snapshots')->selectRaw('DISTINCT ON (vendor_organization_id) vendor_organization_id, vps, ohs, components, sample_counts')->orderBy('vendor_organization_id')->orderByDesc('window_ends_on');
        $vendors = DB::table('vendor_organizations as o')->leftJoinSub($latest, 's', 's.vendor_organization_id', '=', 'o.id')->where('o.account_status', 'ACTIVE')->where('o.store_activation_status', 'ACTIVE')
            ->orderBy('o.store_name')->orderBy('o.id')->get(['o.id', 'o.store_name', 's.vps', 's.ohs', 's.components', 's.sample_counts']);
        $labels = [VendorRiskClassifier::HEALTHY => 'Healthy', VendorRiskClassifier::WATCH => 'Watch', VendorRiskClassifier::BELOW => 'Below workflow watch level', VendorRiskClassifier::BUILDING => 'New Vendor — Building Track Record'];
        $counts = array_fill_keys(array_keys($labels), 0);
        $attention = [];
        $clusterable = [];
        foreach ($vendors as $vendor) {
            $components = $vendor->components === null ? [] : (json_decode((string) $vendor->components, true) ?: []);
            $rates = $components['operations']['rates'] ?? null;
            $vps = $vendor->vps === null ? null : PublicScores::round((string) $vendor->vps);
            $ohs = $vendor->ohs === null ? null : PublicScores::round((string) $vendor->ohs);
            $result = VendorRiskClassifier::classify(['vps' => $vps, 'ohs' => $ohs, 'rates' => is_array($rates) ? array_map('strval', $rates) : null]);
            $counts[$result['class']]++;
            if (in_array($result['class'], [VendorRiskClassifier::BELOW, VendorRiskClassifier::WATCH], true)) {
                $attention[] = ['vendor_id' => (string) $vendor->id, 'store_name' => (string) $vendor->store_name, 'class' => $result['class'], 'label' => $result['label'], 'vps' => $vps, 'ohs' => $ohs, 'reasons' => $result['path']];
            }
            $samples = $vendor->sample_counts === null ? [] : (json_decode((string) $vendor->sample_counts, true) ?: []);
            if ($vps !== null && $ohs !== null) {
                $clusterable[] = ['name' => (string) $vendor->store_name, 'vps' => (float) $vps, 'ohs' => (float) $ohs, 'completed' => (int) ($samples['completed_orders_90_days'] ?? 0)];
            }
        }
        usort($attention, static fn (array $a, array $b): int => [$a['class'] === VendorRiskClassifier::BELOW ? 0 : 1, (float) ($a['vps'] ?? 6), $a['store_name']] <=> [$b['class'] === VendorRiskClassifier::BELOW ? 0 : 1, (float) ($b['vps'] ?? 6), $b['store_name']]);

        return ['total' => count($vendors), 'classes' => array_map(static fn (string $key): array => ['key' => $key, 'label' => $labels[$key], 'count' => $counts[$key]], array_keys($labels)),
            'attention' => array_slice($attention, 0, 8), 'segments' => $this->vendorSegments($clusterable)];
    }

    /**
     * @param  list<array{name: string, vps: float, ohs: float, completed: int}>  $vendors
     * @return array<string, mixed>
     */
    private function vendorSegments(array $vendors): array
    {
        $features = ['VPS', 'OHS', 'Completed orders (90 days)'];
        if (count($vendors) < 4) {
            return ['state' => 'INSUFFICIENT_DATA', 'reason' => 'At least four Vendors with a published VPS are needed to group them.', 'considered' => count($vendors), 'features' => $features, 'k' => null, 'segments' => [], 'silhouette' => null];
        }
        $result = KMeans::best(array_map(static fn (array $v): array => [$v['vps'], $v['ohs'], $v['completed']], $vendors), 2, 4);
        $labels = [2 => ['Higher performing, higher volume', 'Lower performing, lower volume'], 3 => ['Higher performing, higher volume', 'Middle group', 'Lower performing, lower volume'],
            4 => ['Highest scoring', 'Upper-middle group', 'Lower-middle group', 'Lowest scoring']][$result['k']] ?? [];
        $order = array_keys($result['centroids']);
        usort($order, static fn (int $a, int $b): int => [$result['centroids'][$b][0], $a] <=> [$result['centroids'][$a][0], $b]);
        $labelOf = [];
        foreach ($order as $position => $segment) {
            $labelOf[$segment] = $labels[$position] ?? 'Segment '.($segment + 1);
        }
        $segments = [];
        foreach ($result['centroids'] as $index => $centroid) {
            $segments[] = ['id' => $index, 'label' => $labelOf[$index], 'size' => $result['sizes'][$index], 'average_vps' => round($centroid[0], 2), 'average_ohs' => round($centroid[1], 2), 'average_completed_orders' => round($centroid[2], 1)];
        }
        usort($segments, static fn (array $a, array $b): int => $b['average_vps'] <=> $a['average_vps']);

        return ['state' => 'OK', 'reason' => null, 'considered' => count($vendors), 'features' => $features, 'k' => $result['k'], 'silhouette' => $result['silhouette'], 'segments' => $segments];
    }
}
