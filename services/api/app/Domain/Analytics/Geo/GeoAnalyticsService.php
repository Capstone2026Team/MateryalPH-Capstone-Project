<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Settings\PlatformSettings;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Philippine Geographic Marketplace Analytics read model (analytics.view_aggregates). Every number comes from the
 * daily fact tables, never from raw orders at request time. The selected PSGC area filters the whole response;
 * transaction filters (procurement type, category, material, fulfillment, payment, order state) apply to order-derived
 * metrics only and are reported as not applicable to supply, registered Buyers, activity, response time and listed-price
 * history. Person-derived cells pass through DisclosureControl before serialization, so a suppressed value never
 * leaves the server; storefront Vendor counts are public and shown as is. No response contains coordinates.
 */
final class GeoAnalyticsService
{
    public const DATASETS = ['TEST' => 'TEST — Recorded Test Marketplace Activity', 'DEMO' => 'DEMO — Simulated Marketplace Data'];

    public const TRANSACTION_FILTERS = ['procurement_type', 'category_id', 'material_id', 'fulfillment_method', 'payment_method', 'order_state'];

    public const DEFINITIONS = [
        'vendor_count' => 'Active Tier 2 storefronts (active account and Store Activation) placed at their verified business address, as of the latest daily snapshot on or before the end date. Not suppressed: storefronts are public.',
        'registered_buyers' => 'Active Buyer accounts placed at their current primary saved location, as of the latest daily snapshot on or before the end date. Buyers without a primary location are counted as unresolved geography.',
        'gross_gmv' => 'Sum of confirmed Vendor child-order value (materials, NRPC and delivery) for Online, COD and In-Store Payment orders first confirmed in the period. Excludes the Buyer processing fee; measured before cancellations and refunds.',
        'net_gmv' => 'Gross GMV minus the value of orders finalized as cancelled and minus completed Dispute-Conclusion refunds and confirmed dispute reimbursements (principal only), never below zero per order.',
        'order_volume' => 'Count of confirmed Vendor child orders first confirmed in the period.',
        'fulfillment_rate' => 'Numerator: confirmed, non-cancelled orders whose expected fulfillment date falls in the period and that were completed on or before the end date. Denominator: confirmed, non-cancelled orders whose expected fulfillment date falls in the period.',
        'cancellation_rate' => 'Numerator: orders first confirmed in the period that were finalized as cancelled. Denominator: orders first confirmed in the period.',
        'dispute_rate' => 'Numerator: orders first confirmed in the period with at least one transaction dispute. Denominator: orders first confirmed in the period.',
        'response_time' => 'From an inquiry, Work Package request, order request or counter-offer becoming available to the Vendor until the first human Vendor reply or quotation publication. Automated messages and auto-accept never count; auto-accepted requests are excluded. Attributed to the Vendor business address. Mean, median and 90th percentile over answered requests.',
        'active_users' => 'Distinct Buyers who submitted an order, accepted or countered a quotation or offer, or confirmed or reported fulfillment; distinct Vendor users who published or revised a quotation, manually decided or revised an order, recorded fulfillment or cancelled. App opens, page views, automated jobs and auto-accept never count. DAU: the end date; WAU: 7 days; MAU: 30 days ending on the end date.',
        'demand' => 'Confirmed order lines attributed to the Project site, delivery site or pickup store. Order count counts orders containing the category or material; value sums line payable amounts; quantity uses the material canonical unit and only lines with an approved unit conversion. Not an official government market statistic.',
        'timezone' => 'Dates use Asia/Manila. Facts are rebuilt daily from the transactional records; the last aggregation time is shown.',
    ];

    public function __construct(private readonly AdminAccess $access, private readonly PsgcHierarchy $psgc) {}

    /**
     * @param  list<string>  $extra
     * @return array<string, mixed>
     */
    public static function rules(array $extra = []): array
    {
        return [
            'dataset' => ['sometimes', Rule::in(['TEST', 'DEMO'])], 'area' => ['sometimes', 'nullable', 'string', 'regex:/^[0-9]{10}$/'],
            'from' => ['sometimes', 'date_format:Y-m-d'], 'to' => ['sometimes', 'date_format:Y-m-d'], 'granularity' => ['sometimes', Rule::in(['DAY', 'WEEK', 'MONTH'])],
            'procurement_type' => ['sometimes', Rule::in(['ITEM_BASED', 'PROJECT_BASED'])], 'category_id' => ['sometimes', 'uuid'], 'material_id' => ['sometimes', 'uuid'],
            'fulfillment_method' => ['sometimes', Rule::in(['DELIVERY', 'PICKUP'])], 'payment_method' => ['sometimes', Rule::in(['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'])],
            'order_state' => ['sometimes', Rule::in(['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED', 'CANCELLED'])],
            ...(in_array('measure', $extra, true) ? ['measure' => ['sometimes', Rule::in(['ORDER_COUNT', 'QUANTITY', 'VALUE'])]] : []),
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function dashboard(Request $request, array $input): array
    {
        $context = $this->context($request, $input);
        $k = DisclosureControl::current();
        $orders = $this->orderAggregate($context, $this->orders($context));
        $responses = $this->responseAggregate($this->scoped(DB::table('analytics_response_facts as f'), $context, 'available_on'));
        $activity = $this->activityAggregate($context);
        $presence = $this->presenceAggregate($context);
        $parentName = $context['area']['name'];
        $kpis = [
            'vendor_count' => ['value' => $presence['vendors'], 'suppressed' => false, 'reason' => null],
            'registered_buyers' => $this->cell($presence['buyers'], $presence['buyers'], $k, $parentName),
            'gross_gmv_centavos' => $this->cell($orders['gross'], $orders['persons'], $k, $parentName),
            'net_gmv_centavos' => $this->cell($orders['net'], $orders['persons'], $k, $parentName),
            'order_volume' => $this->cell($orders['volume'], $orders['persons'], $k, $parentName),
            'fulfillment_rate' => $this->rate($orders['fulfilled'], $orders['due'], $orders['due_persons'], $k, $parentName),
            'cancellation_rate' => $this->rate($orders['cancelled'], $orders['volume'], $orders['persons'], $k, $parentName),
            'dispute_rate' => $this->rate($orders['disputed'], $orders['volume'], $orders['persons'], $k, $parentName),
            'response_time' => $k->suppressed($responses['persons']) ? ['suppressed' => true, 'reason' => $k->message(DisclosureControl::PRIMARY, $parentName), 'mean_seconds' => null, 'median_seconds' => null,
                'p90_seconds' => null, 'answered' => null, 'unanswered' => null] : ['suppressed' => false, 'reason' => null] + $responses['values'],
            'active_users' => array_map(fn (array $values): array => array_map(fn (int $count): array => $this->cell($count, $count, $k, $parentName), $values), $activity),
        ];

        return [
            'scope' => $this->scope($context),
            'dataset' => $this->dataset($context['environment']),
            'period' => ['from' => $context['from'], 'to' => $context['to'], 'granularity' => $context['granularity']],
            'filters' => $context['filters'],
            'filter_applicability' => $this->applicability(),
            'disclosure' => ['minimum_persons' => $k->minimumPersons, 'method' => 'ROLL_UP_TO_PARENT', 'description' => 'Person-derived cells with fewer than '.$k->minimumPersons.' distinct Buyers or users are suppressed and counted in the parent total.'],
            'kpis' => $kpis,
            'trends' => $this->trends($context, $k),
            'activity_trend' => $this->activityTrend($context, $k),
            'children' => $this->children($context, $k),
            'unresolved' => $this->unresolved($context),
            'definitions' => self::DEFINITIONS,
        ];
    }

    /**
     * Category or material demand heatmap: child areas × the top demand columns of the selection.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function demand(Request $request, array $input): array
    {
        $context = $this->context($request, $input);
        $measure = (string) ($input['measure'] ?? 'ORDER_COUNT');
        if (! in_array($measure, ['ORDER_COUNT', 'QUANTITY', 'VALUE'], true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose order count, quantity or value.', 422);
        }
        if ($measure === 'QUANTITY' && empty($context['filters']['material_id'])) {
            throw new AuthenticationException('QUANTITY_NEEDS_MATERIAL', 'Quantity is comparable only for one canonical material. Choose a material first.', 422);
        }
        $k = DisclosureControl::current();
        $byMaterial = ! empty($context['filters']['category_id']) || ! empty($context['filters']['material_id']);
        $dimension = $byMaterial ? 'l.material_id' : 'l.material_category_id';
        $childColumn = 'f.'.PsgcHierarchy::childColumn($context['depth']);
        $lines = fn (): Builder => $this->orders($context)->join('analytics_order_line_facts as l', 'l.analytics_order_fact_id', '=', 'f.id')->whereNotNull($dimension);
        $columns = $lines()->groupBy($dimension)->orderByRaw('SUM(l.value_centavos) DESC')->limit(8)->selectRaw($dimension.' AS dimension')->pluck('dimension')->map(static fn (mixed $id): string => (string) $id)->all();
        $names = $byMaterial ? DB::table('materials')->whereIn('id', $columns)->pluck('name', 'id') : DB::table('material_categories')->whereIn('id', $columns)->pluck('name', 'id');
        $unit = $measure === 'QUANTITY' ? DB::table('materials as m')->join('units as u', 'u.id', '=', 'm.canonical_unit_id')->where('m.id', $context['filters']['material_id'])->value('u.name') : null;
        $aggregate = match ($measure) {
            'ORDER_COUNT' => 'COUNT(DISTINCT f.id)',
            'VALUE' => 'COALESCE(SUM(l.value_centavos), 0)',
            default => 'COALESCE(SUM(l.normalized_quantity), 0)',
        };
        $cells = $columns === [] ? collect() : $lines()->whereIn($dimension, $columns)->groupBy($childColumn, $dimension)
            ->selectRaw($childColumn.' AS area, '.$dimension.' AS dimension, '.$aggregate.' AS measure, COUNT(DISTINCT f.buyer_key) AS persons')->get();
        $excluded = $measure === 'QUANTITY' ? $lines()->whereNull('l.normalized_quantity')->count() : 0;
        $children = $this->psgc->children($context['area']['code']);
        $rows = [];
        foreach ($children as $child) {
            $rows[$child['code']] = ['code' => $child['code'], 'name' => $child['name'], 'level' => $child['level'], 'cells' => []];
        }
        foreach ($columns as $column) {
            $persons = [];
            foreach ($children as $child) {
                $persons[$child['code']] = (int) ($cells->first(fn (object $cell): bool => (string) $cell->area === $child['code'] && (string) $cell->dimension === $column)->persons ?? 0);
            }
            $reasons = $k->siblings($persons);
            foreach ($children as $child) {
                $cell = $cells->first(fn (object $c): bool => (string) $c->area === $child['code'] && (string) $c->dimension === $column);
                $reason = $reasons[$child['code']] ?? null;
                $rows[$child['code']]['cells'][] = ['column' => $column, 'value' => $reason === null ? ($cell === null ? 0 : ($measure === 'QUANTITY' ? (string) $cell->measure : (int) $cell->measure)) : null,
                    'suppressed' => $reason !== null, 'reason' => $k->message($reason, $context['area']['name'])];
            }
        }

        return ['scope' => $this->scope($context), 'dataset' => $this->dataset($context['environment']), 'measure' => $measure, 'unit' => $unit,
            'dimension' => $byMaterial ? 'MATERIAL' : 'CATEGORY', 'columns' => array_map(static fn (string $id): array => ['id' => $id, 'name' => (string) ($names[$id] ?? 'Unmapped')], $columns),
            'rows' => array_values($rows), 'not_comparable_lines' => $excluded, 'definition' => self::DEFINITIONS['demand']];
    }

    /**
     * Children of the selected area (or regions) with simplified boundary GeoJSON for the map. Properties carry codes
     * and names only.
     *
     * @return array<string, mixed>
     */
    public function boundaries(Request $request, ?string $areaCode): array
    {
        $this->authorize($request);
        $version = $this->psgc->requireVersion();
        if ($areaCode !== null) {
            $this->psgc->requireArea($areaCode);
        }
        $children = $this->psgc->children($areaCode);
        $geometry = DB::table('psgc_boundaries as b')->join('psgc_areas as a', 'a.id', '=', 'b.psgc_area_id')->where('a.psgc_version_id', $version->id)
            ->whereIn('a.code', array_column($children, 'code'))->whereNotNull('b.simplified_geojson')->pluck('b.simplified_geojson', 'a.code');
        $features = [];
        foreach ($children as $child) {
            $shape = $geometry[$child['code']] ?? null;
            if ($shape !== null) {
                $features[] = ['type' => 'Feature', 'id' => $child['code'], 'properties' => ['code' => $child['code'], 'name' => $child['name'], 'level' => $child['level']], 'geometry' => json_decode((string) $shape, true)];
            }
        }

        return ['type' => 'FeatureCollection', 'features' => $features, 'missing_codes' => array_values(array_diff(array_column($children, 'code'), array_map('strval', $geometry->keys()->all()))),
            'psgc_version' => ['id' => (string) $version->id, 'label' => (string) $version->version]];
    }

    /**
     * Rows for an authorized export: KPIs and the child-area table after suppression, with the dataset label.
     *
     * @param  array<string, mixed>  $filters
     * @return array{rows: list<list<string|int|null>>, versions: array<string, mixed>}
     */
    public function exportRows(Request $request, array $filters): array
    {
        $data = $this->dashboard($request, $filters);
        $rows = [[$data['dataset']['label']], ['Scope', $data['scope']['label']], ['Period', $data['period']['from'].' to '.$data['period']['to'].' (Asia/Manila)'],
            ['Small-cell rule', $data['disclosure']['description']], ['Area', 'Level', 'Vendors', 'Registered Buyers', 'Gross GMV PHP', 'Net GMV PHP', 'Orders', 'Fulfillment %', 'Cancellation %', 'Dispute %', 'Suppression']];
        foreach ($data['children'] as $child) {
            $rows[] = [$child['name'], $child['level_label'], $child['vendor_count'], $child['registered_buyers']['value'], self::money($child['gross_gmv_centavos']['value']), self::money($child['net_gmv_centavos']['value']),
                $child['order_volume']['value'], $child['fulfillment_rate']['percent'], $child['cancellation_rate']['percent'], $child['dispute_rate']['percent'], $child['suppression_note']];
        }
        $rows[] = ['Unresolved geography (not placed at this level)', null, $data['unresolved']['vendors'], $data['unresolved']['registered_buyers'], null, null, $data['unresolved']['orders'], null, null, null, null];

        return ['rows' => $rows, 'versions' => ['dataset' => $data['dataset'], 'scope' => $data['scope']['code'], 'filters' => $data['filters'], 'period' => $data['period'], 'disclosure_minimum' => $data['disclosure']['minimum_persons']]];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private function context(Request $request, array $input): array
    {
        $this->authorize($request);
        $environment = in_array($input['dataset'] ?? 'TEST', ['TEST', 'DEMO'], true) ? (string) ($input['dataset'] ?? 'TEST') : 'TEST';
        $code = isset($input['area']) && $input['area'] !== '' ? (string) $input['area'] : null;
        $area = $code === null ? ['code' => null, 'name' => 'Philippines', 'level' => null] : $this->psgc->requireArea($code);
        $latest = DB::table('analytics_geo_runs')->where('environment', $environment)->where('state', 'PUBLISHED')->max('through_date');
        $to = isset($input['to']) ? CarbonImmutable::parse((string) $input['to']) : CarbonImmutable::parse((string) ($latest ?? CarbonImmutable::now('Asia/Manila')->toDateString()));
        $from = isset($input['from']) ? CarbonImmutable::parse((string) $input['from']) : $to->subDays(29);
        if ($from->greaterThan($to) || $from->diffInDays($to) > 365) {
            throw new AuthenticationException('ANALYTICS_DATE_RANGE_INVALID', 'Choose a start date on or before the end date, within 366 days.', 422);
        }
        $filters = [];
        foreach (self::TRANSACTION_FILTERS as $key) {
            if (isset($input[$key]) && $input[$key] !== '') {
                $filters[$key] = (string) $input[$key];
            }
        }

        return ['environment' => $environment, 'area' => ['code' => $area['code'], 'name' => $area['name'], 'level' => $area['level']], 'depth' => $this->psgc->depth($code),
            'from' => $from->toDateString(), 'to' => $to->toDateString(), 'granularity' => in_array($input['granularity'] ?? 'DAY', ['DAY', 'WEEK', 'MONTH'], true) ? (string) ($input['granularity'] ?? 'DAY') : 'DAY',
            'filters' => $filters];
    }

    private function authorize(Request $request): void
    {
        if (! PlatformSettings::current()->flag('geo_analytics')) {
            throw new AuthenticationException('GEO_ANALYTICS_UNAVAILABLE', 'Geographic analytics is turned off in Platform Settings.', 503);
        }
        $this->access->require($request, 'analytics.view_aggregates');
    }

    /** @param array<string, mixed> $context */
    private function orders(array $context): Builder
    {
        $query = $this->scoped(DB::table('analytics_order_facts as f'), $context, 'confirmed_on');
        foreach (['procurement_type', 'fulfillment_method', 'payment_method', 'order_state'] as $key) {
            if (isset($context['filters'][$key])) {
                $query->where('f.'.$key, $context['filters'][$key]);
            }
        }
        foreach (['category_id' => 'material_category_id', 'material_id' => 'material_id'] as $key => $column) {
            if (isset($context['filters'][$key])) {
                $query->whereExists(fn (Builder $q) => $q->selectRaw('1')->from('analytics_order_line_facts as x')->whereColumn('x.analytics_order_fact_id', 'f.id')->where('x.'.$column, $context['filters'][$key]));
            }
        }

        return $query;
    }

    /** @param array<string, mixed> $context */
    private function scoped(Builder $query, array $context, ?string $dateColumn): Builder
    {
        $query->where('f.environment', $context['environment']);
        $column = PsgcHierarchy::selectionColumn($context['depth']);
        if ($column !== null) {
            $query->where('f.'.$column, $context['area']['code']);
        }
        if ($dateColumn !== null) {
            $query->whereBetween('f.'.$dateColumn, [$context['from'], $context['to']]);
        }

        return $query;
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array<string, int>
     */
    private function orderAggregate(array $context, Builder $orders): array
    {
        $row = (clone $orders)->selectRaw('COUNT(*) AS volume, COUNT(DISTINCT f.buyer_key) AS persons, COALESCE(SUM(f.gross_value_centavos), 0) AS gross, COALESCE(SUM(f.net_value_centavos), 0) AS net,
            COUNT(*) FILTER (WHERE f.cancelled) AS cancelled, COUNT(*) FILTER (WHERE f.disputed) AS disputed')->first();
        $due = $this->dueOrders($context)->selectRaw('COUNT(*) AS due, COUNT(*) FILTER (WHERE f.completed_on IS NOT NULL AND f.completed_on <= ?) AS fulfilled, COUNT(DISTINCT f.buyer_key) AS persons', [$context['to']])->first();

        return ['volume' => (int) $row->volume, 'persons' => (int) $row->persons, 'gross' => (int) $row->gross, 'net' => (int) $row->net, 'cancelled' => (int) $row->cancelled,
            'disputed' => (int) $row->disputed, 'due' => (int) $due->due, 'fulfilled' => (int) $due->fulfilled, 'due_persons' => (int) $due->persons];
    }

    /**
     * Orders due for fulfillment in the period (fulfillment-rate denominator), with the same non-date filters.
     *
     * @param  array<string, mixed>  $context
     */
    private function dueOrders(array $context): Builder
    {
        return $this->orders(['from' => '0001-01-01', 'to' => '9999-12-31'] + $context)->where('f.cancelled', false)->whereBetween('f.due_on', [$context['from'], $context['to']]);
    }

    /** @return array{persons: int, values: array<string, int|null>} */
    private function responseAggregate(Builder $responses): array
    {
        $row = $responses->selectRaw('COUNT(DISTINCT f.buyer_key) AS persons, COUNT(f.responded_at) AS answered, COUNT(*) - COUNT(f.responded_at) AS unanswered,
            ROUND(AVG(f.response_seconds)) AS mean, ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY f.response_seconds)) AS median,
            ROUND(percentile_cont(0.9) WITHIN GROUP (ORDER BY f.response_seconds)) AS p90')->first();

        return ['persons' => (int) $row->persons, 'values' => ['mean_seconds' => $row->mean === null ? null : (int) $row->mean, 'median_seconds' => $row->median === null ? null : (int) $row->median,
            'p90_seconds' => $row->p90 === null ? null : (int) $row->p90, 'answered' => (int) $row->answered, 'unanswered' => (int) $row->unanswered]];
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array{buyer: array{dau: int, wau: int, mau: int}, vendor: array{dau: int, wau: int, mau: int}}
     */
    private function activityAggregate(array $context): array
    {
        $end = CarbonImmutable::parse($context['to']);
        $result = [];
        foreach (['BUYER' => 'buyer', 'VENDOR' => 'vendor'] as $audience => $key) {
            $base = $this->scoped(DB::table('analytics_activity_facts as f'), $context, null)->where('f.audience', $audience);
            $row = (clone $base)->selectRaw('COUNT(DISTINCT f.actor_key) FILTER (WHERE f.activity_on = ?) AS dau, COUNT(DISTINCT f.actor_key) FILTER (WHERE f.activity_on BETWEEN ? AND ?) AS wau,
                COUNT(DISTINCT f.actor_key) FILTER (WHERE f.activity_on BETWEEN ? AND ?) AS mau', [$end->toDateString(), $end->subDays(6)->toDateString(), $end->toDateString(), $end->subDays(29)->toDateString(), $end->toDateString()])->first();
            $result[$key] = ['dau' => (int) $row->dau, 'wau' => (int) $row->wau, 'mau' => (int) $row->mau];
        }

        return $result;
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array{vendors: int, buyers: int, snapshot_on: ?string}
     */
    private function presenceAggregate(array $context): array
    {
        $snapshot = DB::table('analytics_presence_facts')->where('environment', $context['environment'])->where('snapshot_on', '<=', $context['to'])->max('snapshot_on');
        if ($snapshot === null) {
            return ['vendors' => 0, 'buyers' => 0, 'snapshot_on' => null];
        }
        $row = $this->scoped(DB::table('analytics_presence_facts as f'), $context, null)->where('f.snapshot_on', $snapshot)
            ->selectRaw("COUNT(*) FILTER (WHERE f.audience = 'VENDOR') AS vendors, COUNT(*) FILTER (WHERE f.audience = 'BUYER') AS buyers")->first();

        return ['vendors' => (int) $row->vendors, 'buyers' => (int) $row->buyers, 'snapshot_on' => (string) $snapshot];
    }

    /**
     * @param  array<string, mixed>  $context
     * @return list<array<string, mixed>>
     */
    private function trends(array $context, DisclosureControl $k): array
    {
        $bucket = match ($context['granularity']) {
            'WEEK' => "date_trunc('week', f.confirmed_on)::date",
            'MONTH' => "date_trunc('month', f.confirmed_on)::date",
            default => 'f.confirmed_on',
        };
        $rows = $this->orders($context)->groupByRaw($bucket)->orderByRaw($bucket)->selectRaw($bucket.' AS bucket, COUNT(*) AS volume, COUNT(DISTINCT f.buyer_key) AS persons,
            COALESCE(SUM(f.gross_value_centavos), 0) AS gross, COALESCE(SUM(f.net_value_centavos), 0) AS net')->get()->keyBy(fn (object $row): string => (string) $row->bucket);
        $series = [];
        $cursor = CarbonImmutable::parse($context['from']);
        $cursor = match ($context['granularity']) {
            'WEEK' => $cursor->startOfWeek(),
            'MONTH' => $cursor->startOfMonth(),
            default => $cursor,
        };
        $end = CarbonImmutable::parse($context['to']);
        $guard = 0;
        while ($cursor->lessThanOrEqualTo($end) && $guard++ < 400) {
            $key = $cursor->toDateString();
            $row = $rows->get($key);
            $persons = (int) ($row->persons ?? 0);
            $hidden = $k->suppressed($persons);
            // Missing buckets are real zeros (no confirmed orders), not gaps: facts cover every confirmed order.
            $series[] = ['bucket' => $key, 'gross_gmv_centavos' => $hidden ? null : (int) ($row->gross ?? 0), 'net_gmv_centavos' => $hidden ? null : (int) ($row->net ?? 0),
                'order_volume' => $hidden ? null : (int) ($row->volume ?? 0), 'suppressed' => $hidden, 'reason' => $hidden ? $k->message(DisclosureControl::PRIMARY, $context['area']['name']) : null];
            $cursor = match ($context['granularity']) {
                'WEEK' => $cursor->addWeek(),
                'MONTH' => $cursor->addMonth(),
                default => $cursor->addDay(),
            };
        }

        return $series;
    }

    /**
     * Daily DAU, rolling 7-day WAU and rolling 30-day MAU for Buyers and Vendor users across the period.
     *
     * @param  array<string, mixed>  $context
     * @return list<array<string, mixed>>
     */
    private function activityTrend(array $context, DisclosureControl $k): array
    {
        $column = PsgcHierarchy::selectionColumn($context['depth']);
        $bindings = [$context['from'], $context['to'], $context['environment']];
        $areaSql = '';
        if ($column !== null) {
            $areaSql = ' AND f.'.$column.' = ?';
            $bindings[] = $context['area']['code'];
        }
        $rows = DB::select("SELECT d::date AS day, f.audience,
                COUNT(DISTINCT f.actor_key) FILTER (WHERE f.activity_on = d::date) AS dau,
                COUNT(DISTINCT f.actor_key) FILTER (WHERE f.activity_on > d::date - 7) AS wau,
                COUNT(DISTINCT f.actor_key) AS mau
            FROM generate_series(?::date, ?::date, interval '1 day') AS d
            JOIN analytics_activity_facts f ON f.environment = ? AND f.activity_on > d::date - 30 AND f.activity_on <= d::date$areaSql
            GROUP BY d, f.audience ORDER BY d", $bindings);
        $byDay = [];
        foreach ($rows as $row) {
            $byDay[(string) $row->day][(string) $row->audience] = ['dau' => (int) $row->dau, 'wau' => (int) $row->wau, 'mau' => (int) $row->mau];
        }
        $series = [];
        $cursor = CarbonImmutable::parse($context['from']);
        $end = CarbonImmutable::parse($context['to']);
        while ($cursor->lessThanOrEqualTo($end)) {
            $day = $cursor->toDateString();
            $point = ['date' => $day];
            foreach (['BUYER' => 'buyer', 'VENDOR' => 'vendor'] as $audience => $key) {
                foreach (['dau', 'wau', 'mau'] as $metric) {
                    $value = $byDay[$day][$audience][$metric] ?? 0;
                    $point[$key.'_'.$metric] = $k->suppressed($value) ? null : $value;
                }
            }
            $series[] = $point;
            $cursor = $cursor->addDay();
        }

        return $series;
    }

    /**
     * The synchronized table and map values for each child area, with per-family sibling suppression.
     *
     * @param  array<string, mixed>  $context
     * @return list<array<string, mixed>>
     */
    private function children(array $context, DisclosureControl $k): array
    {
        $children = $this->psgc->children($context['area']['code']);
        if ($children === []) {
            return [];
        }
        $column = 'f.'.PsgcHierarchy::childColumn($context['depth']);
        $orders = $this->orders($context)->groupBy($column)->selectRaw($column.' AS code, COUNT(*) AS volume, COUNT(DISTINCT f.buyer_key) AS persons, COALESCE(SUM(f.gross_value_centavos), 0) AS gross,
            COALESCE(SUM(f.net_value_centavos), 0) AS net, COUNT(*) FILTER (WHERE f.cancelled) AS cancelled, COUNT(*) FILTER (WHERE f.disputed) AS disputed')->get()->keyBy('code');
        $due = $this->dueOrders($context)->groupBy($column)->selectRaw($column.' AS code, COUNT(*) AS due, COUNT(*) FILTER (WHERE f.completed_on IS NOT NULL AND f.completed_on <= ?) AS fulfilled', [$context['to']])->get()->keyBy('code');
        $snapshot = DB::table('analytics_presence_facts')->where('environment', $context['environment'])->where('snapshot_on', '<=', $context['to'])->max('snapshot_on');
        $presence = $snapshot === null ? collect() : $this->scoped(DB::table('analytics_presence_facts as f'), $context, null)->where('f.snapshot_on', $snapshot)->groupBy($column)
            ->selectRaw($column." AS code, COUNT(*) FILTER (WHERE f.audience = 'VENDOR') AS vendors, COUNT(*) FILTER (WHERE f.audience = 'BUYER') AS buyers")->get()->keyBy('code');
        $responses = $this->scoped(DB::table('analytics_response_facts as f'), $context, 'available_on')->groupBy($column)->selectRaw($column.' AS code, COUNT(DISTINCT f.buyer_key) AS persons,
            ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY f.response_seconds)) AS median')->get()->keyBy('code');
        $orderReasons = $k->siblings(array_combine(array_column($children, 'code'), array_map(fn (array $c): int => (int) ($orders->get($c['code'])->persons ?? 0), $children)));
        $buyerReasons = $k->siblings(array_combine(array_column($children, 'code'), array_map(fn (array $c): int => (int) ($presence->get($c['code'])->buyers ?? 0), $children)));
        $responseReasons = $k->siblings(array_combine(array_column($children, 'code'), array_map(fn (array $c): int => (int) ($responses->get($c['code'])->persons ?? 0), $children)));
        $parent = $context['area']['name'];
        $rows = [];
        foreach ($children as $child) {
            $code = $child['code'];
            $o = $orders->get($code);
            $d = $due->get($code);
            $orderReason = $orderReasons[$code] ?? null;
            $buyerReason = $buyerReasons[$code] ?? null;
            $responseReason = $responseReasons[$code] ?? null;
            $hide = static fn (?string $reason, mixed $value): mixed => $reason === null ? $value : null;
            $rate = static function (?string $reason, int $numerator, int $denominator): array {
                return $reason !== null ? ['percent' => null, 'numerator' => null, 'denominator' => null]
                    : ['percent' => $denominator === 0 ? null : bcdiv(bcmul((string) $numerator, '100', 4), (string) $denominator, 2), 'numerator' => $numerator, 'denominator' => $denominator];
            };
            $notes = array_values(array_filter([$k->message($orderReason, $parent), $buyerReason !== null && $buyerReason !== $orderReason ? 'Registered Buyers: '.$k->message($buyerReason, $parent) : null]));
            $rows[] = ['code' => $code, 'name' => $child['name'], 'level' => $child['level'], 'level_label' => PsgcHierarchy::levelLabel($child['level']),
                'drillable' => $this->psgc->children($code) !== [], 'vendor_count' => (int) ($presence->get($code)->vendors ?? 0),
                'registered_buyers' => ['value' => $hide($buyerReason, (int) ($presence->get($code)->buyers ?? 0)), 'suppressed' => $buyerReason !== null],
                'gross_gmv_centavos' => ['value' => $hide($orderReason, (int) ($o->gross ?? 0)), 'suppressed' => $orderReason !== null],
                'net_gmv_centavos' => ['value' => $hide($orderReason, (int) ($o->net ?? 0)), 'suppressed' => $orderReason !== null],
                'order_volume' => ['value' => $hide($orderReason, (int) ($o->volume ?? 0)), 'suppressed' => $orderReason !== null],
                'fulfillment_rate' => $rate($orderReason, (int) ($d->fulfilled ?? 0), (int) ($d->due ?? 0)),
                'cancellation_rate' => $rate($orderReason, (int) ($o->cancelled ?? 0), (int) ($o->volume ?? 0)),
                'dispute_rate' => $rate($orderReason, (int) ($o->disputed ?? 0), (int) ($o->volume ?? 0)),
                'median_response_seconds' => $responseReason !== null || ($responses->get($code)->median ?? null) === null ? null : (int) $responses->get($code)->median,
                'response_suppressed' => $responseReason !== null,
                'suppressed' => $orderReason !== null, 'suppression_reason' => $orderReason, 'suppression_note' => $notes === [] ? null : implode(' ', $notes)];
        }

        return $rows;
    }

    /**
     * Records inside the selection that cannot be placed one level down (missing or partial PSGC reference).
     *
     * @param  array<string, mixed>  $context
     * @return array<string, int>
     */
    private function unresolved(array $context): array
    {
        $column = 'f.'.PsgcHierarchy::childColumn($context['depth']);
        $leaf = $this->psgc->children($context['area']['code']) === [];
        $snapshot = DB::table('analytics_presence_facts')->where('environment', $context['environment'])->where('snapshot_on', '<=', $context['to'])->max('snapshot_on');
        $presence = $snapshot === null || $leaf ? null : $this->scoped(DB::table('analytics_presence_facts as f'), $context, null)->where('f.snapshot_on', $snapshot)->whereNull($column)
            ->selectRaw("COUNT(*) FILTER (WHERE f.audience = 'VENDOR') AS vendors, COUNT(*) FILTER (WHERE f.audience = 'BUYER') AS buyers")->first();

        return ['orders' => $leaf ? 0 : $this->orders($context)->whereNull($column)->count(), 'vendors' => (int) ($presence->vendors ?? 0), 'registered_buyers' => (int) ($presence->buyers ?? 0),
            'responses' => $leaf ? 0 : $this->scoped(DB::table('analytics_response_facts as f'), $context, 'available_on')->whereNull($column)->count(),
            'activity' => $leaf ? 0 : $this->scoped(DB::table('analytics_activity_facts as f'), $context, 'activity_on')->whereNull($column)->count()];
    }

    /** @return array<string, mixed> */
    private function cell(int $value, int $persons, DisclosureControl $k, string $parent): array
    {
        $hidden = $k->suppressed($persons);

        return ['value' => $hidden ? null : $value, 'suppressed' => $hidden, 'reason' => $hidden ? $k->message(DisclosureControl::PRIMARY, $parent) : null];
    }

    /** @return array<string, mixed> */
    private function rate(int $numerator, int $denominator, int $persons, DisclosureControl $k, string $parent): array
    {
        if ($k->suppressed($persons)) {
            return ['percent' => null, 'numerator' => null, 'denominator' => null, 'suppressed' => true, 'reason' => $k->message(DisclosureControl::PRIMARY, $parent)];
        }

        return ['percent' => $denominator === 0 ? null : bcdiv(bcmul((string) $numerator, '100', 4), (string) $denominator, 2), 'numerator' => $numerator, 'denominator' => $denominator, 'suppressed' => false, 'reason' => null];
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array<string, mixed>
     */
    private function scope(array $context): array
    {
        $version = $this->psgc->version();
        $path = $context['area']['code'] === null ? [] : $this->psgc->path((string) $context['area']['code']);
        $breadcrumbs = [['code' => null, 'name' => 'Philippines', 'level' => null], ...array_map(static fn (array $step): array => ['code' => $step['code'], 'name' => $step['name'], 'level' => $step['level']], $path)];
        $children = $this->psgc->children($context['area']['code']);

        return ['code' => $context['area']['code'], 'name' => $context['area']['name'], 'level' => $context['area']['level'], 'level_label' => PsgcHierarchy::levelLabel($context['area']['level']),
            'label' => $context['area']['code'] === null ? 'Philippines' : $context['area']['name'].' ('.PsgcHierarchy::levelLabel($context['area']['level']).')', 'breadcrumbs' => $breadcrumbs,
            'children_label' => match ($context['depth']) {
                0 => 'Regions',
                1 => 'Provinces and independent cities',
                default => 'Cities and municipalities',
            }, 'drillable' => $children !== [],
            'psgc_version' => $version === null ? null : ['id' => (string) $version->id, 'label' => (string) $version->version, 'effective_on' => (string) $version->effective_on]];
    }

    /** @return array<string, mixed> */
    private function dataset(string $environment): array
    {
        $run = DB::table('analytics_geo_runs')->where('environment', $environment)->where('state', 'PUBLISHED')->orderByDesc('published_at')->first();

        return ['environment' => $environment, 'label' => self::DATASETS[$environment], 'demo' => $environment === 'DEMO',
            'last_aggregated_at' => $run?->published_at === null ? null : CarbonImmutable::parse((string) $run->published_at)->toIso8601String(),
            'through_date' => $run?->through_date, 'revision' => $run === null ? null : (int) $run->revision, 'available' => $run !== null];
    }

    /** @return list<array<string, mixed>> */
    private function applicability(): array
    {
        $order = ['GROSS_GMV', 'NET_GMV', 'ORDER_VOLUME', 'FULFILLMENT_RATE', 'CANCELLATION_RATE', 'DISPUTE_RATE', 'DEMAND'];
        $out = [];
        foreach (self::TRANSACTION_FILTERS as $filter) {
            $out[] = ['filter' => $filter, 'applies_to' => $order, 'not_applicable_to' => ['VENDOR_COUNT', 'REGISTERED_BUYERS', 'ACTIVE_USERS', 'RESPONSE_TIME', 'MATERIALS_ANALYTICS_PRICES'],
                'note' => 'Transaction filters never change listed-price observations, supply counts, active users or response time.'];
        }

        return [['filter' => 'area', 'applies_to' => ['ALL'], 'not_applicable_to' => [], 'note' => 'The selected PSGC area filters the whole dashboard, including Materials Analytics.'],
            ['filter' => 'period', 'applies_to' => ['ALL'], 'not_applicable_to' => [], 'note' => 'Counts use the latest daily snapshot on or before the end date.'], ...$out];
    }

    private static function money(?int $centavos): ?string
    {
        return $centavos === null ? null : ($centavos < 0 ? '-' : '').intdiv(abs($centavos), 100).'.'.str_pad((string) (abs($centavos) % 100), 2, '0', STR_PAD_LEFT);
    }
}
