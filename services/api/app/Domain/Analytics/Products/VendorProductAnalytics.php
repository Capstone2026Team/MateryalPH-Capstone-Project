<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Products;

use App\Domain\Analytics\Dashboard\DashboardForecast;
use App\Domain\Analytics\Dashboard\VendorDashboardInsights;
use App\Domain\Analytics\Mining\AssociationRules;
use App\Domain\Analytics\Mining\Dbscan;
use App\Domain\Analytics\Mining\KMeans;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Vendor Product Analytics read model (requested and approved by the project owner on 2026-10-10). It reads the Vendor
 * organization's own records only, resolved on every request, and needs `catalog.manage` (Owner, Store Manager, Store
 * Staff, Inventory Staff). Peso values need `finance.view` (Owner only), matching the Dashboard and Earnings.
 *
 * Measures:
 * - A product view is one signed-in Buyer opening the listing's Product Details on one Asia/Manila day (listing_view_days).
 * - Orders are Vendor child orders first confirmed in the period that contain the product, valued by line payable amount.
 *   A cancelled order, or one whose payment was fully refunded (refund state REFUNDED), is left out, so refunded money is
 *   never counted as sold; a partial refund keeps the order at its full line value. Earnings' Commercial sales follows the same rule;
 *   the Dashboard's Gross sales is counted before refunds.
 * - View-to-order conversion is the share of the product's distinct viewers in the period who also placed an order request
 *   containing it in the period. "Top performing" ranks by the Wilson 95% lower bound of that share, so a product with a
 *   handful of views is not ranked above one with a long, steady record.
 *
 * Mining output (views forecast, K-Means product segments, DBSCAN unusual days, Apriori co-ordered products) and every
 * suggestion are planning aids built from data-derived comparisons only; they never change a price, a listing, a score,
 * a ranking or a sanction, and no Buyer identity, location or exact Buyer count per order leaves this class.
 */
final class VendorProductAnalytics
{
    public const PERIODS = [7, 30, 90];

    public const SORTS = ['views', 'orders', 'conversion', 'value'];

    public const PER_PAGE = 20;

    public const SUMMARY_LIMIT = 50;

    public const MAX_RANGE_DAYS = 366;

    private const TIMEZONE = 'Asia/Manila';

    /** Days of daily history the forecast, unusual-day and co-ordering mining read, regardless of the displayed period. */
    private const HISTORY_DAYS = 90;

    private const FORECAST_DAYS = 7;

    /** Days with at least one view before a views forecast is offered (the Dashboard rule for orders). */
    private const MIN_ACTIVE_DAYS = 7;

    private const TOP = 5;

    private const MAX_SUGGESTIONS = 8;

    /** z for a two-sided 95% interval. */
    private const Z = 1.96;

    private const PRIORITY = ['HIGH' => 0, 'MEDIUM' => 1, 'LOW' => 2];

    public const DEFINITIONS = [
        'views' => 'Product views: one signed-in Buyer opening a product’s Product Details on one Asia/Manila day counts once, however many times they open it that day. Vendors see counts only, never who viewed.',
        'viewers' => 'Distinct Buyers who viewed the product at least once in the period.',
        'orders' => 'Vendor child orders first confirmed in the period that contain the product. A cancelled order, or one whose payment was fully refunded, is not counted, because the money went back to the Buyer.',
        'value' => 'Line value of those orders (Owner only), by the same rule as Commercial sales in Earnings. Cancelled and fully refunded orders are excluded; a partial refund is not deducted from the line value. An internal operational view, not a tax invoice or accounting record.',
        'conversion' => 'View-to-order conversion: the product’s distinct viewers in the period who also placed an order request containing it in the period, divided by its distinct viewers.',
        'top_selling' => 'Products ranked by order value (Owner) or by confirmed orders (other roles) in the period.',
        'top_performing' => 'Products ranked by the Wilson 95% lower bound of view-to-order conversion, so a product with few views is not ranked above one with a long, steady record.',
        'most_viewed' => 'Products ranked by product views in the period.',
        'categories' => 'Views, orders and (Owner) value summed by material category in the period.',
        'forecast' => 'A least-squares trend plus a weekday pattern fitted to up to 90 days of daily product views, with a 95% prediction band. It needs at least seven days with views and is an estimate for planning only.',
        'segments' => 'K-Means groups products with similar views, conversion and orders in the period (standardized, number of groups chosen by the best silhouette score). Group names compare each group’s centre with the store average.',
        'basket_rules' => 'Apriori finds products that appear together in the same confirmed order more often than chance (lift above 1) in the last 90 days, across at least two distinct Buyers.',
        'unusual_days' => 'DBSCAN marks days whose views and orders sit apart from the product’s usual days. Unusual is not wrong.',
        'suggestions' => 'Planning suggestions built from the measures above, comparing products only with your own store’s data. Nothing changes until you act.',
        'stock' => 'Out of stock: no active variant has stock available to sell (on hand − hard reserved). Limited stock: a variant is at or below the reorder level you set.',
    ];

    public function __construct(private readonly AccountAccess $access) {}

    /**
     * @param  array<string, mixed>  $filters  days|from|to, sort, page
     * @return array<string, mixed>
     */
    public function overview(Request $request, array $filters): array
    {
        $scope = $this->scope($request);
        $period = $this->period($filters);
        $sales = $scope['sales'];
        $facts = $this->facts($scope['organization'], $period, null);
        $rows = $this->rows($facts, $sales);
        $segments = $this->segments($rows);
        foreach ($segments['membership'] as $listingId => $label) {
            $rows[$listingId]['segment'] = $label;
        }
        $rules = $this->basketRules($facts);
        $storeViews = $this->dailyStoreViews($facts);
        $forecast = DashboardForecast::analyze(array_values($storeViews['history']), array_keys($storeViews['history']), $period['to'], false, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS)['summary'];

        $current = $facts['store'];
        $viewed = count(array_filter($rows, static fn (array $row): bool => $row['views'] > 0));
        $sort = in_array($filters['sort'] ?? null, self::SORTS, true) ? (string) $filters['sort'] : 'views';
        if ($sort === 'value' && ! $sales) {
            $sort = 'orders';
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $ordered = $this->sorted($rows, $sort, $sales);
        $total = count($ordered);

        return [
            'generated_at' => CarbonImmutable::now()->toIso8601String(),
            'period' => $this->periodView($period),
            'access' => ['sales_value' => $sales],
            'definitions' => self::DEFINITIONS,
            'tracking' => ['views_since' => $facts['views_since']],
            'kpis' => [
                'views' => $this->delta($current['views'], $current['previous_views']),
                'viewers' => $this->delta($current['viewers'], $current['previous_viewers']),
                'products_viewed' => ['value' => $viewed, 'total' => count($rows)],
                'orders' => $this->delta($current['orders'], $current['previous_orders']),
                'conversion' => $this->rate($current['converted'], $current['viewers']),
                'value_centavos' => $sales ? $this->delta($current['value'], $current['previous_value']) : null,
            ],
            'series' => array_map(static fn (string $date): array => ['date' => $date, 'views' => $storeViews['window'][$date] ?? 0, 'orders' => count($facts['orders_by_day'][$date] ?? []),
                'value_centavos' => $sales ? ($facts['value_by_day'][$date] ?? 0) : null], $period['dates']),
            'forecast' => ['horizon_days' => self::FORECAST_DAYS, 'views' => $forecast],
            'top_selling' => array_slice($this->sorted(array_filter($rows, static fn (array $row): bool => $row['orders'] > 0), $sales ? 'value' : 'orders', $sales), 0, self::TOP),
            'top_performing' => array_slice($this->sorted(array_filter($rows, static fn (array $row): bool => $row['converted'] > 0), 'conversion', $sales), 0, self::TOP),
            'most_viewed' => array_slice($this->sorted(array_filter($rows, static fn (array $row): bool => $row['views'] > 0), 'views', $sales), 0, self::TOP),
            'categories' => $this->categories($rows, $sales),
            'segments' => array_diff_key($segments, ['membership' => true, 'kinds' => true, 'members' => true]),
            'basket_rules' => ['baskets' => $rules['baskets'], 'rules' => $rules['rules'], 'window_days' => self::HISTORY_DAYS],
            'suggestions' => array_slice($this->suggestions($rows, $current, $segments, $rules, $forecast, null), 0, self::MAX_SUGGESTIONS),
            'products' => ['items' => array_slice($ordered, ($page - 1) * self::PER_PAGE, self::PER_PAGE),
                'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'last_page' => max(1, (int) ceil($total / self::PER_PAGE)), 'sort' => $sort]],
        ];
    }

    /**
     * @param  array<string, mixed>  $filters  days|from|to
     * @return array<string, mixed>
     */
    public function product(Request $request, string $listingId, array $filters): array
    {
        $scope = $this->scope($request);
        $listing = Str::isUuid($listingId) ? DB::table('vendor_listings as l')->leftJoin('material_categories as c', 'c.id', '=', 'l.material_category_id')->where('l.id', $listingId)
            ->where('l.vendor_organization_id', $scope['organization'])->whereNull('l.removed_at')->first(['l.id', 'l.display_name', 'l.vendor_sku', 'l.status', 'c.name as category_name']) : null;
        if ($listing === null) {
            throw new AuthenticationException('LISTING_NOT_FOUND', 'This product is not in your store.', 404);
        }
        $period = $this->period($filters);
        $sales = $scope['sales'];
        $facts = $this->facts($scope['organization'], $period, null);
        $rows = $this->rows($facts, $sales);
        $segments = $this->segments($rows);
        foreach ($segments['membership'] as $id => $label) {
            $rows[$id]['segment'] = $label;
        }
        // A draft that was never published has no Buyer activity; it still opens with zero measures.
        $row = $rows[$listingId] ?? $this->emptyRow($listingId, $listing, $sales);
        $rules = $this->basketRules($facts);
        $name = $row['name'];
        $productRules = array_values(array_filter($rules['rules'], static fn (array $rule): bool => in_array($name, $rule['antecedent'], true) || in_array($name, $rule['consequent'], true)));

        $history = [];
        for ($cursor = $period['to']->subDays(self::HISTORY_DAYS - 1); $cursor->lessThanOrEqualTo($period['to']); $cursor = $cursor->addDay()) {
            $history[$cursor->toDateString()] = (float) ($facts['views_by_listing_day'][$listingId][$cursor->toDateString()] ?? 0);
        }
        $forecast = DashboardForecast::analyze(array_values($history), array_keys($history), $period['to'], false, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS)['summary'];
        $ordersByDay = [];
        $valueByDay = [];
        foreach ($facts['lines'] as $line) {
            if ($line['listing'] === $listingId) {
                $ordersByDay[$line['day']][$line['order']] = true;
                $valueByDay[$line['day']] = ($valueByDay[$line['day']] ?? 0) + $line['value'];
            }
        }

        return [
            'generated_at' => CarbonImmutable::now()->toIso8601String(),
            'period' => $this->periodView($period),
            'access' => ['sales_value' => $sales],
            'definitions' => self::DEFINITIONS,
            'tracking' => ['views_since' => $facts['views_since']],
            'product' => self::present($row),
            'kpis' => [
                'views' => $this->delta($row['views'], $row['previous_views']),
                'viewers' => $this->delta($row['viewers'], $row['previous_viewers']),
                'orders' => $this->delta($row['orders'], $row['previous_orders']),
                'buyers' => $row['buyers'],
                'conversion' => $this->rate($row['converted'], $row['viewers']),
                'store_conversion' => $this->rate($facts['store']['converted'], $facts['store']['viewers']),
                'value_centavos' => $sales ? $this->delta((int) $row['value_centavos'], $row['previous_value']) : null,
                'products' => count($rows),
            ],
            'series' => array_map(static fn (string $date): array => ['date' => $date, 'views' => (int) ($facts['views_by_listing_day'][$listingId][$date] ?? 0), 'orders' => count($ordersByDay[$date] ?? []),
                'value_centavos' => $sales ? ($valueByDay[$date] ?? 0) : null], $period['dates']),
            'forecast' => ['horizon_days' => self::FORECAST_DAYS, 'views' => $forecast],
            'unusual_days' => $this->unusualDays($history, $ordersByDay),
            'basket_rules' => ['baskets' => $rules['baskets'], 'rules' => $productRules, 'window_days' => self::HISTORY_DAYS],
            'suggestions' => $this->suggestions($rows, $facts['store'], $segments, ['baskets' => $rules['baskets'], 'rules' => $productRules, 'names' => $rules['names']], $forecast, $listingId),
        ];
    }

    /**
     * Compact per-listing measures for the My Products list.
     *
     * @param  list<string>  $listingIds
     * @param  array<string, mixed>  $filters  days
     * @return array<string, mixed>
     */
    public function summaries(Request $request, array $listingIds, array $filters): array
    {
        $scope = $this->scope($request);
        $ids = array_values(array_unique(array_filter($listingIds, static fn (string $id): bool => Str::isUuid($id))));
        if (count($ids) > self::SUMMARY_LIMIT) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Request analytics for up to '.self::SUMMARY_LIMIT.' products at a time.', 422);
        }
        $period = $this->period(['days' => $filters['days'] ?? 30]);
        $owned = $ids === [] ? [] : DB::table('vendor_listings')->whereIn('id', $ids)->where('vendor_organization_id', $scope['organization'])->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
        $facts = $this->facts($scope['organization'], $period, $owned);
        $items = [];
        foreach ($owned as $id) {
            $views = (int) array_sum(array_intersect_key($facts['views_by_listing_day'][$id] ?? [], array_flip($period['dates'])));
            $previous = $facts['previous_views_by_listing'][$id] ?? 0;
            $viewers = $facts['viewers_by_listing'][$id] ?? 0;
            $orders = [];
            foreach ($facts['lines'] as $line) {
                if ($line['listing'] === $id && $line['in_period']) {
                    $orders[$line['order']] = true;
                }
            }
            $items[] = ['listing_id' => $id, 'views' => $views, 'previous_views' => $previous, 'views_change_percent' => $this->delta($views, $previous)['change_percent'], 'viewers' => $viewers,
                'orders' => count($orders), 'conversion' => $this->rate($facts['converted_by_listing'][$id] ?? 0, $viewers),
                'daily_views' => array_map(static fn (string $date): int => (int) ($facts['views_by_listing_day'][$id][$date] ?? 0), $period['dates'])];
        }

        return ['period' => $this->periodView($period), 'items' => $items];
    }

    /** @return array{organization: string, sales: bool} */
    private function scope(Request $request): array
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'VENDOR') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot open Product Analytics.', 403);
        }
        $scope = $this->access->resolve($user);
        if (! is_string($scope['organization_id'])) {
            throw new AuthenticationException('MEMBERSHIP_NOT_ACTIVE', 'Your membership does not permit access.', 403);
        }
        if (! in_array('catalog.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PRODUCT_ANALYTICS_DENIED', 'Product analytics is available to roles that manage products.', 403);
        }

        return ['organization' => $scope['organization_id'], 'sales' => in_array('finance.view', $scope['permissions'], true)];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{from: CarbonImmutable, to: CarbonImmutable, days: int, previous_from: CarbonImmutable, dates: list<string>}
     */
    private function period(array $filters): array
    {
        $days = isset($filters['days']) ? (int) $filters['days'] : 30;
        if (! in_array($days, self::PERIODS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a period of 7, 30 or 90 days.', 422);
        }
        $today = CarbonImmutable::now(self::TIMEZONE)->startOfDay();
        $to = isset($filters['to']) ? CarbonImmutable::parse((string) $filters['to'], self::TIMEZONE)->startOfDay() : $today;
        $from = isset($filters['from']) ? CarbonImmutable::parse((string) $filters['from'], self::TIMEZONE)->startOfDay() : $to->subDays($days - 1);
        if ($from->greaterThan($to) || $to->greaterThan($today)) {
            throw new AuthenticationException('ANALYTICS_DATE_RANGE_INVALID', 'Choose dates on or before today, with the start on or before the end.', 422);
        }
        $length = (int) $from->diffInDays($to) + 1;
        if ($length > self::MAX_RANGE_DAYS) {
            throw new AuthenticationException('ANALYTICS_DATE_RANGE_INVALID', 'Choose a range of up to '.self::MAX_RANGE_DAYS.' days.', 422);
        }
        $dates = [];
        for ($cursor = $from; $cursor->lessThanOrEqualTo($to); $cursor = $cursor->addDay()) {
            $dates[] = $cursor->toDateString();
        }

        return ['from' => $from, 'to' => $to, 'days' => $length, 'previous_from' => $from->subDays($length), 'dates' => $dates];
    }

    /**
     * @param  array{from: CarbonImmutable, to: CarbonImmutable, days: int}  $period
     * @return array<string, mixed>
     */
    private function periodView(array $period): array
    {
        return ['days' => $period['days'], 'from' => $period['from']->toDateString(), 'to' => $period['to']->toDateString(), 'timezone' => self::TIMEZONE];
    }

    /**
     * Every raw fact the views read, gathered once per request from the store's own records.
     *
     * @param  array{from: CarbonImmutable, to: CarbonImmutable, days: int, previous_from: CarbonImmutable, dates: list<string>}  $period
     * @param  list<string>|null  $only  limit to these listings (My Products rows)
     * @return array<string, mixed>
     */
    private function facts(string $organizationId, array $period, ?array $only): array
    {
        $from = $period['from']->toDateString();
        $to = $period['to']->toDateString();
        $previousFrom = $period['previous_from']->toDateString();
        $historyStart = $period['to']->subDays(self::HISTORY_DAYS - 1);
        $historyFrom = $historyStart->lessThan($period['previous_from']) ? $historyStart->toDateString() : $previousFrom;
        $fromUtc = $period['from']->setTimezone('UTC');
        $endUtc = $period['to']->addDay()->setTimezone('UTC');
        $views = fn (): Builder => DB::table('listing_view_days')->where('vendor_organization_id', $organizationId)->when($only !== null, fn (Builder $query) => $query->whereIn('vendor_listing_id', $only ?? []));

        $listings = $only !== null && $only === [] ? collect() : DB::table('vendor_listings as l')->leftJoin('material_categories as c', 'c.id', '=', 'l.material_category_id')
            ->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('l.publication_version', '>', 0)
            ->when($only !== null, fn (Builder $query) => $query->whereIn('l.id', $only ?? []))
            ->get(['l.id', 'l.display_name', 'l.vendor_sku', 'l.status', 'c.name as category_name']);
        $stock = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, COUNT(*) AS variants, COUNT(*) FILTER (WHERE i.id IS NOT NULL AND i.quantity_on_hand - i.hard_reserved_quantity > 0) AS available,
                COUNT(*) FILTER (WHERE i.id IS NOT NULL AND i.quantity_on_hand - i.hard_reserved_quantity > 0 AND i.reorder_level IS NOT NULL AND i.quantity_on_hand - i.hard_reserved_quantity <= i.reorder_level) AS limited')
            ->get()->keyBy('vendor_listing_id');

        $viewsByListingDay = [];
        foreach ($views()->whereBetween('view_date', [$historyFrom, $to])->groupBy('vendor_listing_id', 'view_date')->selectRaw('vendor_listing_id, view_date, COUNT(*) AS total')->get() as $row) {
            $viewsByListingDay[(string) $row->vendor_listing_id][substr((string) $row->view_date, 0, 10)] = (int) $row->total;
        }
        $previousViews = [];
        foreach ($viewsByListingDay as $listingId => $byDay) {
            foreach ($byDay as $day => $total) {
                if ($day >= $previousFrom && $day < $from) {
                    $previousViews[$listingId] = ($previousViews[$listingId] ?? 0) + $total;
                }
            }
        }
        $distinct = fn (string $start, string $end): array => $views()->whereBetween('view_date', [$start, $end])->groupBy('vendor_listing_id')
            ->selectRaw('vendor_listing_id, COUNT(DISTINCT buyer_profile_id) AS total')->pluck('total', 'vendor_listing_id')->map(static fn (mixed $value): int => (int) $value)->all();
        $previousTo = $period['from']->subDay()->toDateString();
        $requested = static fn (Builder $query) => $query->selectRaw('1')->from('order_lines as ol')->join('orders as oo', 'oo.id', '=', 'ol.order_id')->leftJoin('listing_variants as olv', 'olv.id', '=', 'ol.listing_variant_id')
            ->whereColumn('oo.buyer_profile_id', 'v.buyer_profile_id')->whereRaw('COALESCE(ol.vendor_listing_id, olv.vendor_listing_id) = v.vendor_listing_id')
            ->where('oo.vendor_organization_id', $organizationId)->whereNotNull('oo.submitted_at')->where('oo.submitted_at', '>=', $fromUtc)->where('oo.submitted_at', '<', $endUtc);
        $converted = DB::table('listing_view_days as v')->where('v.vendor_organization_id', $organizationId)->whereBetween('v.view_date', [$from, $to])
            ->when($only !== null, fn (Builder $query) => $query->whereIn('v.vendor_listing_id', $only ?? []))->whereExists($requested);
        $convertedByListing = (clone $converted)->groupBy('v.vendor_listing_id')->selectRaw('v.vendor_listing_id, COUNT(DISTINCT v.buyer_profile_id) AS total')->pluck('total', 'vendor_listing_id')
            ->map(static fn (mixed $value): int => (int) $value)->all();
        $store = ['views' => 0, 'previous_views' => 0,
            'viewers' => (int) $views()->whereBetween('view_date', [$from, $to])->distinct()->count('buyer_profile_id'),
            'previous_viewers' => (int) $views()->whereBetween('view_date', [$previousFrom, $previousTo])->distinct()->count('buyer_profile_id'),
            'converted' => (int) (clone $converted)->distinct()->count('v.buyer_profile_id'), 'orders' => 0, 'previous_orders' => 0, 'value' => 0, 'previous_value' => 0];
        foreach ($viewsByListingDay as $byDay) {
            foreach ($byDay as $day => $total) {
                if ($day >= $from) {
                    $store['views'] += $total;
                } elseif ($day >= $previousFrom) {
                    $store['previous_views'] += $total;
                }
            }
        }

        $confirmed = DB::table('order_status_history')->where('state_family', 'ORDER')->where('to_state', 'CONFIRMED')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS confirmed_at');
        $confirmedOn = "(COALESCE(h.confirmed_at, o.accepted_at, o.created_at) AT TIME ZONE '".self::TIMEZONE."')::date";
        $lineRows = DB::table('order_lines as l')->join('orders as o', 'o.id', '=', 'l.order_id')->leftJoinSub($confirmed, 'h', 'h.order_id', '=', 'o.id')->leftJoin('listing_variants as lv', 'lv.id', '=', 'l.listing_variant_id')
            ->where('o.vendor_organization_id', $organizationId)->where('o.refund_state', '<>', 'REFUNDED')->where('o.order_state', '<>', 'CANCELLED')
            ->where(fn (Builder $query) => $query->whereNotNull('h.confirmed_at')->orWhereIn('o.order_state', VendorDashboardInsights::POST_CONFIRMATION))
            ->whereRaw($confirmedOn.' >= ?', [$historyFrom])->whereRaw($confirmedOn.' <= ?', [$to])
            ->when($only !== null, fn (Builder $query) => $query->whereIn(DB::raw('COALESCE(l.vendor_listing_id, lv.vendor_listing_id)'), $only ?? []))
            ->get(['l.order_id', 'o.buyer_profile_id', 'o.order_state', 'l.payable_centavos', DB::raw('COALESCE(l.vendor_listing_id, lv.vendor_listing_id) AS listing_id'), DB::raw($confirmedOn.' AS confirmed_on')]);
        $lines = [];
        $ordersByDay = [];
        $valueByDay = [];
        $currentOrders = [];
        $previousOrders = [];
        foreach ($lineRows as $row) {
            if ($row->listing_id === null) {
                continue;
            }
            $day = substr((string) $row->confirmed_on, 0, 10);
            $line = ['order' => (string) $row->order_id, 'buyer' => (string) $row->buyer_profile_id, 'listing' => (string) $row->listing_id, 'value' => (int) $row->payable_centavos,
                'day' => $day, 'cancelled' => $row->order_state === 'CANCELLED', 'in_period' => $day >= $from, 'in_previous' => $day >= $previousFrom && $day < $from];
            $lines[] = $line;
            if ($line['in_period']) {
                $ordersByDay[$day][$line['order']] = true;
                $valueByDay[$day] = ($valueByDay[$day] ?? 0) + $line['value'];
                $currentOrders[$line['order']] = true;
                $store['value'] += $line['value'];
            } elseif ($line['in_previous']) {
                $previousOrders[$line['order']] = true;
                $store['previous_value'] += $line['value'];
            }
        }
        $store['orders'] = count($currentOrders);
        $store['previous_orders'] = count($previousOrders);
        $since = $views()->min('view_date');

        return ['listings' => $listings->keyBy('id')->all(), 'stock' => $stock->all(), 'views_by_listing_day' => $viewsByListingDay, 'previous_views_by_listing' => $previousViews,
            'viewers_by_listing' => $distinct($from, $to), 'previous_viewers_by_listing' => $distinct($previousFrom, $previousTo), 'converted_by_listing' => $convertedByListing,
            'lines' => $lines, 'orders_by_day' => $ordersByDay, 'value_by_day' => $valueByDay, 'store' => $store, 'period' => $period,
            'views_since' => $since === null ? null : substr((string) $since, 0, 10)];
    }

    /**
     * One row per published product in the store, with its period measures and ranks.
     *
     * @param  array<string, mixed>  $facts
     * @return array<string, array<string, mixed>>
     */
    private function rows(array $facts, bool $sales): array
    {
        $rows = [];
        foreach ($facts['listings'] as $id => $listing) {
            $rows[(string) $id] = $this->emptyRow((string) $id, $listing, $sales);
        }
        $from = $facts['period']['from']->toDateString();
        $orders = [];
        foreach ($facts['lines'] as $line) {
            if (! isset($rows[$line['listing']])) {
                continue;
            }
            if ($line['in_period']) {
                $orders[$line['listing']]['orders'][$line['order']] = true;
                $orders[$line['listing']]['buyers'][$line['buyer']] = true;
                $orders[$line['listing']]['value'] = ($orders[$line['listing']]['value'] ?? 0) + $line['value'];
            } elseif ($line['in_previous']) {
                $orders[$line['listing']]['previous'][$line['order']] = true;
                $orders[$line['listing']]['previous_value'] = ($orders[$line['listing']]['previous_value'] ?? 0) + $line['value'];
            }
        }
        foreach ($rows as $id => &$row) {
            $views = 0;
            foreach ($facts['views_by_listing_day'][$id] ?? [] as $day => $total) {
                if ($day >= $from) {
                    $views += $total;
                }
            }
            $viewers = $facts['viewers_by_listing'][$id] ?? 0;
            $converted = min($viewers, $facts['converted_by_listing'][$id] ?? 0);
            $stock = $facts['stock'][$id] ?? null;
            $row['views'] = $views;
            $row['previous_views'] = $facts['previous_views_by_listing'][$id] ?? 0;
            $row['views_change_percent'] = $this->delta($views, $row['previous_views'])['change_percent'];
            $row['viewers'] = $viewers;
            $row['previous_viewers'] = $facts['previous_viewers_by_listing'][$id] ?? 0;
            $row['converted'] = $converted;
            $row['conversion'] = $this->rate($converted, $viewers);
            $row['conversion_lower_bound'] = self::wilson($converted, $viewers);
            $row['orders'] = count($orders[$id]['orders'] ?? []);
            $row['previous_orders'] = count($orders[$id]['previous'] ?? []);
            $row['buyers'] = count($orders[$id]['buyers'] ?? []);
            $row['value_centavos'] = $sales ? (int) ($orders[$id]['value'] ?? 0) : null;
            $row['previous_value'] = $sales ? (int) ($orders[$id]['previous_value'] ?? 0) : 0;
            $row['stock_status'] = $stock === null || (int) $stock->available === 0 ? 'OUT_OF_STOCK' : ((int) $stock->limited > 0 ? 'LIMITED_STOCK' : 'IN_STOCK');
        }
        unset($row);
        foreach (['views' => 'rank_views', 'orders' => 'rank_orders'] as $measure => $rank) {
            $position = 0;
            foreach ($this->sorted($rows, $measure, $sales) as $sortedRow) {
                $rows[$sortedRow['listing_id']][$rank] = $sortedRow[$measure] > 0 ? ++$position : null;
            }
        }

        return $rows;
    }

    /** @return array<string, mixed> */
    private function emptyRow(string $id, ?object $listing, bool $sales): array
    {
        return ['listing_id' => $id, 'name' => $listing === null ? 'Product no longer listed' : (string) $listing->display_name, 'sku' => $listing === null ? null : (string) $listing->vendor_sku,
            'category' => $listing === null || $listing->category_name === null ? 'Uncategorized' : (string) $listing->category_name, 'status' => $listing === null ? null : (string) $listing->status,
            'stock_status' => 'OUT_OF_STOCK', 'views' => 0, 'previous_views' => 0, 'views_change_percent' => null, 'viewers' => 0, 'previous_viewers' => 0, 'converted' => 0,
            'conversion' => $this->rate(0, 0), 'conversion_lower_bound' => null, 'orders' => 0, 'previous_orders' => 0, 'buyers' => 0, 'value_centavos' => $sales ? 0 : null, 'previous_value' => 0,
            'segment' => null, 'rank_views' => null, 'rank_orders' => null];
    }

    /**
     * @param  array<string, array<string, mixed>>  $rows
     * @return list<array<string, mixed>>
     */
    private function sorted(array $rows, string $measure, bool $sales): array
    {
        $list = array_values($rows);
        $key = static fn (array $row): array => match ($measure) {
            'value' => [$sales ? (int) $row['value_centavos'] : 0, $row['orders'], $row['views']],
            'orders' => [$row['orders'], $row['buyers'], $row['views']],
            'conversion' => [$row['conversion_lower_bound'] ?? -1.0, $row['viewers'], $row['orders']],
            default => [$row['views'], $row['viewers'], $row['orders']],
        };
        usort($list, static fn (array $a, array $b): int => [$key($b), $a['name'], $a['listing_id']] <=> [$key($a), $b['name'], $b['listing_id']]);

        return array_map(self::present(...), $list);
    }

    /**
     * The response shape of one product row: internal comparison fields stay server-side.
     *
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    private static function present(array $row): array
    {
        return array_diff_key($row, ['previous_viewers' => true, 'previous_value' => true]);
    }

    /**
     * @param  array<string, mixed>  $facts
     * @return array{history: array<string, float>, window: array<string, int>}
     */
    private function dailyStoreViews(array $facts): array
    {
        $byDay = [];
        foreach ($facts['views_by_listing_day'] as $days) {
            foreach ($days as $day => $total) {
                $byDay[$day] = ($byDay[$day] ?? 0) + $total;
            }
        }
        $history = [];
        $to = $facts['period']['to'];
        for ($cursor = $to->subDays(self::HISTORY_DAYS - 1); $cursor->lessThanOrEqualTo($to); $cursor = $cursor->addDay()) {
            $history[$cursor->toDateString()] = (float) ($byDay[$cursor->toDateString()] ?? 0);
        }

        return ['history' => $history, 'window' => $byDay];
    }

    /**
     * @param  array<string, array<string, mixed>>  $rows
     * @return list<array{category: string, views: int, orders: int, value_centavos: int|null}>
     */
    private function categories(array $rows, bool $sales): array
    {
        $out = [];
        foreach ($rows as $row) {
            if ($row['views'] === 0 && $row['orders'] === 0) {
                continue;
            }
            $out[$row['category']] ??= ['category' => $row['category'], 'views' => 0, 'orders' => 0, 'value_centavos' => $sales ? 0 : null];
            $out[$row['category']]['views'] += $row['views'];
            $out[$row['category']]['orders'] += $row['orders'];
            if ($sales) {
                $out[$row['category']]['value_centavos'] += (int) $row['value_centavos'];
            }
        }
        $list = array_values($out);
        usort($list, static fn (array $a, array $b): int => [$b['value_centavos'] ?? 0, $b['orders'], $b['views'], $a['category']] <=> [$a['value_centavos'] ?? 0, $a['orders'], $a['views'], $b['category']]);

        return array_slice($list, 0, 6);
    }

    /**
     * K-Means over products with any activity: views, conversion % and orders. Group names compare the group centre
     * with the plain average of the clustered products, so a name always describes what the group shows.
     *
     * @param  array<string, array<string, mixed>>  $rows
     * @return array<string, mixed>
     */
    private function segments(array $rows): array
    {
        $active = array_values(array_filter($rows, static fn (array $row): bool => $row['views'] > 0 || $row['orders'] > 0));
        $features = ['Product views', 'Conversion %', 'Orders'];
        if (count($active) < 4) {
            return ['state' => 'INSUFFICIENT_DATA', 'reason' => 'At least four products with views or orders in the period are needed to group them.', 'k' => null, 'silhouette' => null,
                'features' => [], 'segments' => [], 'points' => [], 'mean_conversion_percent' => null, 'membership' => [], 'kinds' => [], 'members' => []];
        }
        $conversion = static fn (array $row): float => $row['viewers'] === 0 ? 0.0 : $row['converted'] / $row['viewers'] * 100;
        $points = array_map(static fn (array $row): array => [$row['views'], $conversion($row), $row['orders']], $active);
        $result = KMeans::best($points, 2, 4);
        $meanViews = array_sum(array_column($points, 0)) / count($points);
        $meanConversion = array_sum(array_column($points, 1)) / count($points);
        $labelOf = [];
        $used = [];
        $kinds = [];
        foreach ($result['centroids'] as $index => $centroid) {
            $popular = $centroid[0] >= $meanViews;
            $converting = $centroid[1] >= $meanConversion;
            $kind = $popular ? ($converting ? 'POPULAR_CONVERTING' : 'VIEWED_NOT_ORDERED') : ($converting ? 'CONVERTS_WHEN_FOUND' : 'LOW_VISIBILITY');
            $base = ['POPULAR_CONVERTING' => 'Popular and converting', 'VIEWED_NOT_ORDERED' => 'Viewed but rarely ordered', 'CONVERTS_WHEN_FOUND' => 'Converts when found', 'LOW_VISIBILITY' => 'Low visibility'][$kind];
            $used[$base] = ($used[$base] ?? 0) + 1;
            $labelOf[$index] = $used[$base] === 1 ? $base : $base.' ('.$used[$base].')';
            $kinds[$index] = $kind;
        }
        $segments = [];
        $membership = [];
        foreach ($result['centroids'] as $index => $centroid) {
            $members = array_values(array_filter(array_keys($result['assignments']), static fn (int $i): bool => $result['assignments'][$i] === $index));
            usort($members, static fn (int $a, int $b): int => [$active[$b]['views'], $active[$b]['orders']] <=> [$active[$a]['views'], $active[$a]['orders']]);
            foreach ($members as $i) {
                $membership[$active[$i]['listing_id']] = $labelOf[$index];
            }
            $segments[] = ['id' => $index, 'label' => $labelOf[$index], 'kind' => $kinds[$index], 'size' => $result['sizes'][$index], 'average_views' => round($centroid[0], 1), 'average_conversion_percent' => round($centroid[1], 1),
                'average_orders' => round($centroid[2], 1), 'examples' => array_map(static fn (int $i): string => $active[$i]['name'], array_slice($members, 0, 3)),
                'listing_ids' => array_map(static fn (int $i): string => $active[$i]['listing_id'], $members)];
        }
        usort($segments, static fn (array $a, array $b): int => [$b['average_views'], $b['average_conversion_percent']] <=> [$a['average_views'], $a['average_conversion_percent']]);

        return ['state' => 'OK', 'reason' => null, 'k' => $result['k'], 'silhouette' => $result['silhouette'], 'features' => $features,
            'segments' => array_map(static fn (array $segment): array => array_diff_key($segment, ['listing_ids' => true]), $segments),
            'points' => array_map(static fn (array $row, int $segment): array => ['listing_id' => $row['listing_id'], 'name' => $row['name'], 'views' => $row['views'], 'conversion_percent' => round($conversion($row), 1),
                'orders' => $row['orders'], 'segment' => $labelOf[$segment]], array_slice($active, 0, 60), array_slice($result['assignments'], 0, 60)),
            'membership' => $membership, 'kinds' => array_combine(array_column($segments, 'label'), array_column($segments, 'kind')),
            'members' => array_combine(array_column($segments, 'label'), array_column($segments, 'listing_ids')), 'mean_conversion_percent' => round($meanConversion, 1)];
    }

    /**
     * Apriori over the last 90 days of confirmed, non-cancelled orders; a rule needs two orders from two distinct Buyers.
     *
     * @param  array<string, mixed>  $facts
     * @return array{baskets: int, rules: list<array<string, mixed>>, names: array<string, string>}
     */
    private function basketRules(array $facts): array
    {
        $historyFrom = $facts['period']['to']->subDays(self::HISTORY_DAYS - 1)->toDateString();
        $names = [];
        foreach ($facts['listings'] as $id => $listing) {
            $names[(string) $id] = (string) $listing->display_name;
        }
        $baskets = [];
        foreach ($facts['lines'] as $line) {
            if ($line['cancelled'] || $line['day'] < $historyFrom) {
                continue;
            }
            $baskets[$line['order']]['items'][] = $names[$line['listing']] ?? 'Product no longer listed';
            $baskets[$line['order']]['owner'] = $line['buyer'];
        }
        $mined = AssociationRules::mine(array_values($baskets), 2, 0.3, 2, 6);

        return ['baskets' => $mined['baskets'], 'rules' => array_map(static fn (array $rule): array => array_diff_key($rule, ['owners' => true]), $mined['rules']), 'names' => array_flip($names)];
    }

    /**
     * @param  array<string, float>  $history  views per day, oldest first
     * @param  array<string, array<string, true>>  $ordersByDay
     * @return array<string, mixed>
     */
    private function unusualDays(array $history, array $ordersByDay): array
    {
        $days = array_values(array_filter(array_keys($history), static fn (string $date): bool => $history[$date] > 0 || isset($ordersByDay[$date])));
        if (count($days) < 8) {
            return ['state' => 'INSUFFICIENT_DATA', 'epsilon' => null, 'days' => []];
        }
        $result = Dbscan::run(array_map(static fn (string $date): array => [$history[$date], count($ordersByDay[$date] ?? [])], $days), 3);

        return ['state' => 'OK', 'epsilon' => $result['epsilon'], 'days' => array_map(static fn (int $i): array => ['date' => $days[$i], 'views' => (int) $history[$days[$i]], 'orders' => count($ordersByDay[$days[$i]] ?? [])], $result['noise'])];
    }

    /**
     * Planning suggestions. Each one names the measure and technique behind it; every comparison is with the store's own
     * products or with a level the Vendor set (reorder level), never an invented threshold.
     *
     * @param  array<string, array<string, mixed>>  $rows
     * @param  array<string, int>  $store
     * @param  array<string, mixed>  $segments
     * @param  array{baskets: int, rules: list<array<string, mixed>>, names?: array<string, string>}  $rules
     * @param  array<string, mixed>  $forecast
     * @return list<array<string, mixed>>
     */
    private function suggestions(array $rows, array $store, array $segments, array $rules, array $forecast, ?string $only): array
    {
        $items = [];
        $storeRate = $this->rate($store['converted'], $store['viewers'])['percent'];
        $product = static fn (array $row): array => ['listing_id' => $row['listing_id'], 'product' => $row['name']];
        $byViews = $this->sorted($rows, 'views', false);
        foreach ($byViews as $row) {
            if ($only !== null && $row['listing_id'] !== $only) {
                continue;
            }
            if ($row['stock_status'] === 'OUT_OF_STOCK' && ($row['views'] > 0 || $row['orders'] > 0) && $row['status'] !== null) {
                $items[] = ['key' => 'RESTOCK_VIEWED:'.$row['listing_id'], 'kind' => 'RESTOCK_VIEWED', 'priority' => 'HIGH', 'title' => 'Restock '.$row['name'],
                    'detail' => sprintf('%d Buyer%s viewed it in this period, but no variant has stock available to sell.', $row['viewers'], $row['viewers'] === 1 ? '' : 's'),
                    'technique' => 'Product views × stock status (available = on hand − hard reserved).', 'href' => '/products/inventory'] + $product($row);
            } elseif ($row['stock_status'] === 'LIMITED_STOCK' && ($row['views'] > 0 || $row['orders'] > 0)) {
                $items[] = ['key' => 'REORDER_SOON:'.$row['listing_id'], 'kind' => 'REORDER_SOON', 'priority' => 'MEDIUM', 'title' => 'Reorder '.$row['name'].' soon',
                    'detail' => sprintf('A variant is at or below your reorder level while Buyers are still viewing (%d views) and ordering (%d orders) it.', $row['views'], $row['orders']),
                    'technique' => 'Product views and orders × the reorder level you set.', 'href' => '/products/inventory'] + $product($row);
            }
        }
        if (($segments['state'] ?? null) === 'OK') {
            foreach ($segments['members'] as $label => $members) {
                $kind = $segments['kinds'][$label] ?? null;
                if (! in_array($kind, ['VIEWED_NOT_ORDERED', 'CONVERTS_WHEN_FOUND'], true)) {
                    continue;
                }
                foreach (array_slice(array_values(array_filter($members, static fn (string $id): bool => $only === null || $id === $only)), 0, 2) as $id) {
                    $row = $rows[$id] ?? null;
                    if ($row === null || $row['viewers'] === 0) {
                        continue;
                    }
                    $rate = $row['conversion']['percent'] ?? '0.00';
                    $items[] = $kind === 'VIEWED_NOT_ORDERED'
                        ? ['key' => 'LOW_CONVERSION:'.$id, 'kind' => 'LOW_CONVERSION', 'priority' => 'MEDIUM', 'title' => 'Turn views of '.$row['name'].' into orders',
                            'detail' => sprintf('%d Buyers viewed it but %d ordered (%s%%; store %s%%). Compare your price in Materials Analytics and check its photos, specifications and stock.', $row['viewers'], $row['converted'], $rate, $storeRate ?? '0.00'),
                            'technique' => 'K-Means segment “'.$label.'”: views above and conversion below your store average.', 'href' => '/products/'.$id] + $product($row)
                        : ['key' => 'CONVERTS_WHEN_FOUND:'.$id, 'kind' => 'CONVERTS_WHEN_FOUND', 'priority' => 'LOW', 'title' => 'Keep '.$row['name'].' ready to sell',
                            'detail' => sprintf('Buyers who open it often order it (%s%%; store %s%%), but few see it (%d views). Keep it in stock with complete photos and details, and offer it in quotations.', $rate, $storeRate ?? '0.00', $row['views']),
                            'technique' => 'K-Means segment “'.$label.'”: conversion above and views below your store average.', 'href' => '/performance/products/'.$id] + $product($row);
                }
            }
        }
        $names = $rules['names'] ?? [];
        foreach (array_slice($rules['rules'], 0, $only === null ? 2 : 3) as $rule) {
            $first = (string) ($rule['antecedent'][0] ?? '');
            $listingId = $names[$first] ?? null;
            $items[] = ['key' => 'BUNDLE:'.implode('+', $rule['antecedent']).'>'.implode('+', $rule['consequent']), 'kind' => 'BUNDLE', 'priority' => 'MEDIUM',
                'title' => 'Stock '.implode(' + ', $rule['antecedent']).' with '.implode(' + ', $rule['consequent']),
                'detail' => sprintf('%d%% of orders with %s also include %s (%.2f× more often than chance, %d orders). Keep them in stock together and offer them together in quotations.',
                    (int) round($rule['confidence'] * 100), implode(' + ', $rule['antecedent']), implode(' + ', $rule['consequent']), $rule['lift'], $rule['support_count']),
                'technique' => 'Apriori association rule over the last 90 days of confirmed orders.', 'href' => $listingId === null ? '/performance?tab=products' : '/performance/products/'.$listingId,
                'listing_id' => $listingId, 'product' => $listingId === null ? null : $first];
        }
        if ($only === null && $store['views'] > 0) {
            $unseen = array_values(array_filter($rows, static fn (array $row): bool => $row['status'] === 'ACTIVE' && $row['views'] === 0));
            if ($unseen !== []) {
                $items[] = ['key' => 'NOT_VIEWED', 'kind' => 'NOT_VIEWED', 'priority' => 'LOW', 'title' => sprintf('%d active product%s had no views', count($unseen), count($unseen) === 1 ? '' : 's'),
                    'detail' => 'No Buyer opened '.implode(', ', array_slice(array_column($unseen, 'name'), 0, 3)).(count($unseen) > 3 ? ' and others' : '').' in this period. Check stock confirmation, price, photos and PS/ICC evidence so they can appear in Buyer search.',
                    'technique' => 'Product views compared across your active listings.', 'href' => '/products?status=ACTIVE', 'listing_id' => null, 'product' => null];
            }
        }
        if (($forecast['state'] ?? null) === 'OK' && in_array($forecast['direction'], ['INCREASING', 'DECREASING'], true)) {
            $rising = $forecast['direction'] === 'INCREASING';
            $change = $forecast['change_percent'] === null ? '' : sprintf(' (%+.1f%% over the history)', $forecast['change_percent']);
            $items[] = ['key' => 'VIEWS_TREND', 'kind' => $rising ? 'VIEWS_RISING' : 'VIEWS_FALLING', 'priority' => $rising ? 'MEDIUM' : 'LOW',
                'title' => ($rising ? 'Views are rising' : 'Views are falling').$change,
                'detail' => sprintf('About %s views are expected in the next %d days. %s', number_format((float) ($forecast['expected_total'] ?? 0), 0), self::FORECAST_DAYS,
                    $rising ? 'Check stock for your most-viewed products before demand arrives.' : 'Review prices and listing details of products whose views dropped.'),
                'technique' => 'Least-squares trend plus weekday pattern (95% band) on daily views.', 'href' => $only === null ? '/products/inventory' : '/products/'.$only,
                'listing_id' => $only, 'product' => $only === null ? null : ($rows[$only]['name'] ?? null)];
        }
        usort($items, static fn (array $a, array $b): int => self::PRIORITY[$a['priority']] <=> self::PRIORITY[$b['priority']]);

        return $items;
    }

    /** @return array{value: int, previous: int, change_percent: float|null} */
    private function delta(int $value, int $previous): array
    {
        return ['value' => $value, 'previous' => $previous, 'change_percent' => $previous === 0 ? null : round(($value - $previous) / $previous * 100, 1)];
    }

    /** @return array{percent: string|null, numerator: int, denominator: int} */
    private function rate(int $numerator, int $denominator): array
    {
        return ['percent' => $denominator === 0 ? null : bcdiv(bcmul((string) $numerator, '100', 4), (string) $denominator, 2), 'numerator' => $numerator, 'denominator' => $denominator];
    }

    /** Wilson score interval lower bound (95%) of successes / trials; null without trials. */
    public static function wilson(int $successes, int $trials): ?float
    {
        if ($trials <= 0) {
            return null;
        }
        $p = $successes / $trials;
        $z2 = self::Z * self::Z;
        $centre = $p + $z2 / (2 * $trials);
        $margin = self::Z * sqrt(($p * (1 - $p) + $z2 / (4 * $trials)) / $trials);

        return round(max(0.0, ($centre - $margin) / (1 + $z2 / $trials)), 4);
    }
}
