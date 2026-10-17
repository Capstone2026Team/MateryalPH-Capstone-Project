<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Dashboard;

use App\Domain\Analytics\Mining\AssociationRules;
use App\Domain\Analytics\Mining\Dbscan;
use App\Domain\Analytics\Mining\KMeans;
use App\Domain\Analytics\Mining\VendorRiskClassifier;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Scores\ScoreQueries;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Vendor Dashboard read model. It reads the Vendor organization's own records only, resolved from the database on every
 * request, and every section is gated by a grant the role matrix already holds: store-wide order measures need
 * `orders.confirm` (Owner, Store Manager, Store Staff, Customer Service), peso values need `finance.view` (Owner only,
 * because Earnings and revenue summaries are Owner-only), scores need `scores.view_store`, stock needs `inventory.view`
 * and cases need `portal.disputes`. A role without a grant receives the section as null, never a redacted copy.
 *
 * Money is integer centavos. Dates are Asia/Manila calendar days. A confirmed order is one that first reached CONFIRMED,
 * valued like the Admin GMV: Vendor child-order value (materials, NRPC, delivery) before cancellations and refunds,
 * excluding the Buyer processing fee. Scores, rates and badge metrics come from the Score service rather than a second
 * formula. Mining output (forecast, segments, unusual days, co-ordered materials) is descriptive and never changes a
 * score, a price, a ranking or an enforcement decision. Storefront visits are not recorded anywhere in the platform,
 * so no visit figure exists or is implied; product views live in VendorProductAnalytics.
 */
final class VendorDashboardInsights
{
    public const PERIODS = [7, 30, 90];

    public const TIMEZONE = 'Asia/Manila';

    /** Days of daily history the forecast, anomaly and basket mining read, regardless of the displayed period. */
    private const HISTORY_DAYS = 90;

    private const FORECAST_DAYS = 7;

    /** Days with at least one order before a trend or forecast is offered. */
    private const MIN_ACTIVE_DAYS = 7;

    public const POST_CONFIRMATION = ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED'];

    private const OPEN_STATES = ['AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'AWAITING_PAYMENT', 'CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'DISPUTED', 'CANCELLATION_REQUESTED'];

    private const IN_FULFILLMENT = ['CONFIRMED', 'PROCESSING'];

    private const SEGMENT_LABELS = [2 => ['High demand', 'Low demand'], 3 => ['High demand', 'Moderate demand', 'Low demand'], 4 => ['High demand', 'Above-average demand', 'Below-average demand', 'Low demand']];

    public function __construct(private readonly AccountAccess $access, private readonly ScoreQueries $scores) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed>
     */
    public function build(Request $request, ?int $days, array $filters = []): array
    {
        if ($days !== null && ! in_array($days, self::PERIODS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a period of 7, 30 or 90 days.', 422);
        }
        $user = $request->user();
        if ($user === null || $user->account_type !== 'VENDOR') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot open the Vendor Dashboard.', 403);
        }
        $scope = $this->access->resolve($user);
        if (! is_string($scope['organization_id'])) {
            throw new AuthenticationException('MEMBERSHIP_NOT_ACTIVE', 'Your membership does not permit access.', 403);
        }
        $organizationId = $scope['organization_id'];
        $has = static fn (string $permission): bool => in_array($permission, $scope['permissions'], true);
        $access = ['orders' => $has('orders.confirm'), 'sales_value' => $has('finance.view'), 'performance' => $has('scores.view_store'), 'stock' => $has('inventory.view'),
            'disputes' => $has('portal.disputes'), 'assigned_fulfillment' => $scope['role'] === 'FULFILLMENT'];

        $currentDay = CarbonImmutable::now(self::TIMEZONE)->startOfDay();
        $today = isset($filters['to']) ? CarbonImmutable::parse((string) $filters['to'], self::TIMEZONE)->startOfDay() : $currentDay;
        $earliest = DB::table('orders')->where('vendor_organization_id', $organizationId)->min('created_at');
        $firstDay = $earliest === null ? $today : CarbonImmutable::parse((string) $earliest)->setTimezone(self::TIMEZONE)->startOfDay();
        $from = isset($filters['from']) ? CarbonImmutable::parse((string) $filters['from'], self::TIMEZONE)->startOfDay()
            : ($days !== null ? $today->subDays($days - 1) : ($firstDay->lessThan($today) ? $firstDay : $today));
        if ($from->greaterThan($today) || $today->greaterThan($currentDay)) {
            throw new AuthenticationException('ANALYTICS_DATE_RANGE_INVALID', 'Choose dates on or before today, with the start on or before the end.', 422);
        }
        $days = (int) $from->diffInDays($today) + 1;
        $context = ['organization' => $organizationId, 'today' => $today, 'days' => $days, 'from' => $from, 'previous_from' => $from->subDays($days), 'sales' => $access['sales_value']];

        $orders = $access['orders'] ? $this->orders($context) : null;
        $performance = $access['performance'] ? $this->performance($request) : null;
        $stock = $access['stock'] ? $this->stock($organizationId) : null;
        $disputes = $access['disputes'] ? $this->disputes($context) : null;

        return [
            'generated_at' => CarbonImmutable::now()->toIso8601String(),
            'period' => ['days' => $days, 'from' => $context['from']->toDateString(), 'to' => $today->toDateString(), 'timezone' => self::TIMEZONE],
            'access' => $access,
            'definitions' => self::DEFINITIONS,
            'orders' => $orders,
            'performance' => $performance,
            'stock' => $stock,
            'disputes' => $disputes,
            'actions' => $this->actions($context, $access, $orders, $stock, $disputes, (int) $user->getKey()),
            'traffic' => ['store_visits' => ['tracked' => false, 'reason' => 'MateryalPH does not record storefront visits, so none are shown. Product views are in Store Performance → Product analytics.']],
        ];
    }

    public const DEFINITIONS = [
        'gross_sales' => 'Value of all Vendor child orders first confirmed in the period (materials, NRPC and delivery), before any deduction for cancellations, returns or refunds, and excluding the Buyer processing fee. Net sales shows what remains after them. An internal operational view, not a tax invoice or accounting record.',
        'net_sales' => 'Gross sales less cancelled orders and refunds already paid back to Buyers (dispute conclusions and other completed refunds).',
        'order_volume' => 'Count of Vendor child orders first confirmed in the period.',
        'fulfillment_rate' => 'Confirmed, non-cancelled orders whose expected fulfillment date falls in the period and that were completed by the end date, divided by all such orders.',
        'cancellation_rate' => 'Orders first confirmed in the period that were finalized as cancelled (any cause), divided by orders first confirmed in the period. The Vendor-caused rate used for scoring appears under Performance.',
        'dispute_rate' => 'Orders first confirmed in the period with at least one transaction dispute, divided by orders first confirmed in the period.',
        'response_time' => 'From an order request reaching the store to the first human decision. Auto-accepted orders and automated messages are excluded. Mean, median and 90th percentile over requests in the period.',
        'forecast' => 'A least-squares trend plus a weekday pattern fitted to up to 90 days of daily history, with a 95% prediction band. It is an estimate for planning, not a commitment, a score or a price.',
        'segments' => 'K-Means groups products with similar demand in the period (orders, distinct Buyers and, for the Owner, value). Groups describe patterns only.',
        'unusual_days' => 'DBSCAN marks days whose order pattern sits apart from the store’s usual days. Unusual is not wrong.',
        'basket_rules' => 'Apriori finds materials that appear together in the same confirmed order more often than chance (lift above 1) in the last 90 days, across at least two distinct Buyers.',
        'classification' => 'A fixed decision tree over the System Workflow’s published thresholds. It is an indicator only and changes no score, badge, ranking or sanction.',
    ];

    /**
     * @param  array<string, mixed>  $context
     * @return array<string, mixed>
     */
    private function orders(array $context): array
    {
        /** @var CarbonImmutable $today */
        $today = $context['today'];
        $historyFrom = $today->subDays(max(self::HISTORY_DAYS, 2 * $context['days']) - 1);
        $confirmed = DB::table('order_status_history')->where('state_family', 'ORDER')->where('to_state', 'CONFIRMED')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS confirmed_at');
        $confirmedOn = "(COALESCE(h.confirmed_at, o.accepted_at, o.created_at) AT TIME ZONE '".self::TIMEZONE."')::date";
        $rows = DB::table('orders as o')->leftJoinSub($confirmed, 'h', 'h.order_id', '=', 'o.id')->where('o.vendor_organization_id', $context['organization'])
            ->where(fn ($query) => $query->whereNotNull('h.confirmed_at')->orWhereIn('o.order_state', self::POST_CONFIRMATION))
            ->whereRaw($confirmedOn.' >= ?', [$historyFrom->toDateString()])->whereRaw($confirmedOn.' <= ?', [$today->toDateString()])
            ->get(['o.id', 'o.buyer_profile_id', 'o.order_state', 'o.procurement_type', 'o.fulfillment_method', 'o.payment_method', 'o.commercial_total_centavos', 'o.expected_fulfillment_date', 'o.closed_at',
                DB::raw($confirmedOn.' AS confirmed_on')]);
        $ids = $rows->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
        $refunded = [];
        $disputed = [];
        foreach (array_chunk($ids, 1000) as $chunk) {
            foreach (DB::table('refunds')->whereIn('order_id', $chunk)->where('target_type', 'ORDER')->where('state', 'REFUNDED')->where('trigger', '<>', 'CANCELLATION')
                ->groupBy('order_id')->selectRaw('order_id, SUM(COALESCE(principal_centavos, amount_centavos)) AS total')->get() as $refund) {
                $refunded[(string) $refund->order_id] = (int) $refund->total;
            }
            foreach (DB::table('dispute_cases')->whereIn('order_id', $chunk)->distinct()->pluck('order_id') as $orderId) {
                $disputed[(string) $orderId] = true;
            }
        }

        $byDay = [];
        $facts = [];
        foreach ($rows as $row) {
            $cancelled = $row->order_state === 'CANCELLED';
            // Gross sales is the whole confirmed order value before any deduction for returns, refunds or cancellations
            // (approved by the project owner on 2026-10-16); Net sales is what remains after them.
            $gross = (int) $row->commercial_total_centavos;
            $net = $cancelled ? 0 : $gross - min($gross, $refunded[(string) $row->id] ?? 0);
            $day = (string) $row->confirmed_on;
            $byDay[$day]['orders'] = ($byDay[$day]['orders'] ?? 0) + 1;
            $byDay[$day]['gross'] = ($byDay[$day]['gross'] ?? 0) + $gross;
            $byDay[$day]['net'] = ($byDay[$day]['net'] ?? 0) + $net;
            $byDay[$day]['buyers'][(string) $row->buyer_profile_id] = true;
            $facts[] = ['id' => (string) $row->id, 'day' => $day, 'gross' => $gross, 'net' => $net, 'cancelled' => $cancelled, 'disputed' => isset($disputed[(string) $row->id]), 'state' => (string) $row->order_state,
                'procurement' => (string) $row->procurement_type, 'fulfillment' => (string) $row->fulfillment_method, 'payment' => (string) $row->payment_method, 'buyer' => (string) $row->buyer_profile_id,
                'due' => $row->expected_fulfillment_date === null ? null : (string) $row->expected_fulfillment_date,
                'completed_on' => $row->order_state === 'COMPLETED' && $row->closed_at !== null ? CarbonImmutable::parse((string) $row->closed_at)->setTimezone(self::TIMEZONE)->toDateString() : null];
        }
        $requests = $this->requestsByDay($context['organization'], $historyFrom);

        $sales = (bool) $context['sales'];
        $history = [];
        for ($cursor = $today->subDays(self::HISTORY_DAYS - 1); $cursor->lessThanOrEqualTo($today); $cursor = $cursor->addDay()) {
            $history[] = $cursor->toDateString();
        }
        $orderSeries = array_map(static fn (string $date): float => (float) ($byDay[$date]['orders'] ?? 0), $history);
        $salesSeries = array_map(static fn (string $date): float => (float) ($byDay[$date]['gross'] ?? 0), $history);
        $orderForecast = DashboardForecast::analyze($orderSeries, $history, $today, false, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS);
        $salesForecast = $sales ? DashboardForecast::analyze($salesSeries, $history, $today, true, self::FORECAST_DAYS, self::MIN_ACTIVE_DAYS) : null;
        $orderTrend = $orderForecast['trend'];
        $salesTrend = $salesForecast['trend'] ?? null;

        $window = [];
        for ($cursor = $context['from']; $cursor->lessThanOrEqualTo($today); $cursor = $cursor->addDay()) {
            $window[] = $cursor->toDateString();
        }
        $historyOffsets = array_flip($history);
        $series = [];
        foreach ($window as $i => $date) {
            $series[] = ['date' => $date, 'orders' => $byDay[$date]['orders'] ?? 0, 'order_requests' => $requests[$date] ?? 0,
                'orders_average' => $orderTrend['moving_average'][$historyOffsets[$date] ?? -1] ?? null,
                'gross_sales_centavos' => $sales ? ($byDay[$date]['gross'] ?? 0) : null, 'net_sales_centavos' => $sales ? ($byDay[$date]['net'] ?? 0) : null,
                'sales_average_centavos' => $sales && $salesTrend !== null && ($salesTrend['moving_average'][$historyOffsets[$date] ?? -1] ?? null) !== null ? (int) round($salesTrend['moving_average'][$historyOffsets[$date]]) : null];
        }

        $current = array_values(array_filter($facts, static fn (array $f): bool => $f['day'] >= $context['from']->toDateString()));
        $previous = array_values(array_filter($facts, static fn (array $f): bool => $f['day'] >= $context['previous_from']->toDateString() && $f['day'] < $context['from']->toDateString()));
        $totals = static fn (array $set): array => ['orders' => count($set), 'gross' => array_sum(array_column($set, 'gross')), 'net' => array_sum(array_column($set, 'net'))];
        $now = $totals($current);
        $before = $totals($previous);
        $due = array_filter($facts, fn (array $f): bool => ! $f['cancelled'] && $f['due'] !== null && $f['due'] >= $context['from']->toDateString() && $f['due'] <= $today->toDateString());
        $fulfilled = array_filter($due, static fn (array $f): bool => $f['completed_on'] !== null && $f['completed_on'] <= $today->toDateString());
        $kpis = [
            'order_volume' => $this->delta($now['orders'], $before['orders']),
            'gross_sales_centavos' => $sales ? $this->delta($now['gross'], $before['gross']) : null,
            'net_sales_centavos' => $sales ? $this->delta($now['net'], $before['net']) : null,
            'average_order_value_centavos' => $sales ? ['value' => $now['orders'] === 0 ? null : (int) round($now['gross'] / $now['orders']), 'previous' => $before['orders'] === 0 ? null : (int) round($before['gross'] / $before['orders'])] : null,
            'fulfillment_rate' => $this->rate(count($fulfilled), count($due)),
            'cancellation_rate' => $this->rate(count(array_filter($current, static fn (array $f): bool => $f['cancelled'])), count($current)),
            'dispute_rate' => $this->rate(count(array_filter($current, static fn (array $f): bool => $f['disputed'])), count($current)),
            'response_time' => $this->responseTime($context),
        ];

        return ['kpis' => $kpis, 'series' => $series, 'forecast' => ['horizon_days' => self::FORECAST_DAYS, 'orders' => $orderForecast['summary'], 'sales' => $salesForecast['summary'] ?? null], 'pipeline' => $this->pipeline($context['organization']),
            'incoming' => $this->incoming($context['organization']), 'funnel' => $this->funnel($context, count($current), count(array_filter($current, static fn (array $f): bool => $f['state'] === 'COMPLETED'))),
            'mix' => ['procurement' => $this->mix($current, 'procurement'), 'fulfillment' => $this->mix($current, 'fulfillment'), 'payment' => $this->mix($current, 'payment')],
            'products' => $this->products($context, $current, $facts),
            'unusual_days' => $this->unusualDays($history, $byDay, $sales)];
    }

    /** @return array<string, int> */
    private function requestsByDay(string $organizationId, CarbonImmutable $from): array
    {
        $out = [];
        foreach (DB::table('orders')->where('vendor_organization_id', $organizationId)->whereNotNull('submitted_at')->where('submitted_at', '>=', $from->setTimezone('UTC'))
            ->selectRaw("(submitted_at AT TIME ZONE '".self::TIMEZONE."')::date AS day, COUNT(*) AS total")->groupByRaw("(submitted_at AT TIME ZONE '".self::TIMEZONE."')::date")->get() as $row) {
            $out[(string) $row->day] = (int) $row->total;
        }

        return $out;
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

    /**
     * @param  array<string, mixed>  $context
     * @return array<string, int|null>
     */
    private function responseTime(array $context): array
    {
        $first = DB::table('order_status_history')->where('state_family', 'ORDER')->where('source', 'VENDOR')->whereNotNull('actor_user_id')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS responded_at');
        $seconds = 'CASE WHEN r.responded_at IS NULL THEN NULL ELSE GREATEST(0, EXTRACT(EPOCH FROM (r.responded_at - o.submitted_at))) END';
        $row = DB::table('orders as o')->leftJoinSub($first, 'r', 'r.order_id', '=', 'o.id')->where('o.vendor_organization_id', $context['organization'])->whereNotNull('o.submitted_at')
            ->where('o.submitted_at', '>=', $context['from']->setTimezone('UTC'))->where('o.submitted_at', '<', $context['today']->addDay()->setTimezone('UTC'))->whereNull('o.quotation_version_id')
            ->where(fn ($query) => $query->whereNull('o.confirmation_source')->orWhere('o.confirmation_source', '<>', 'AUTO_ACCEPT'))
            ->whereExists(fn ($query) => $query->selectRaw('1')->from('order_status_history as s')->whereColumn('s.order_id', 'o.id')->where('s.to_state', 'AWAITING_VENDOR_CONFIRMATION'))
            ->selectRaw("COUNT(r.responded_at) AS answered, COUNT(*) - COUNT(r.responded_at) AS unanswered, ROUND(AVG($seconds)) AS mean,
                ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY $seconds)) AS median, ROUND(percentile_cont(0.9) WITHIN GROUP (ORDER BY $seconds)) AS p90")->first();

        return ['mean_seconds' => $row->mean === null ? null : (int) $row->mean, 'median_seconds' => $row->median === null ? null : (int) $row->median, 'p90_seconds' => $row->p90 === null ? null : (int) $row->p90,
            'answered' => (int) $row->answered, 'unanswered' => (int) $row->unanswered];
    }

    /** @return list<array{state: string, count: int}> */
    private function pipeline(string $organizationId): array
    {
        $counts = DB::table('orders')->where('vendor_organization_id', $organizationId)->whereIn('order_state', self::OPEN_STATES)->groupBy('order_state')->selectRaw('order_state, COUNT(*) AS total')->pluck('total', 'order_state');

        return array_map(static fn (string $state): array => ['state' => $state, 'count' => (int) ($counts[$state] ?? 0)], self::OPEN_STATES);
    }

    /** @return list<array<string, mixed>> */
    private function incoming(string $organizationId): array
    {
        return DB::table('orders as o')->where('o.vendor_organization_id', $organizationId)->where('o.order_state', 'AWAITING_VENDOR_CONFIRMATION')->orderBy('o.vendor_response_due_at')->orderBy('o.id')->limit(5)
            ->get(['o.id', 'o.reference', 'o.procurement_type', 'o.fulfillment_method', 'o.commercial_total_centavos', 'o.vendor_response_due_at', 'o.submitted_at'])
            ->map(static fn (object $order): array => ['order_id' => (string) $order->id, 'reference' => (string) $order->reference, 'procurement_type' => (string) $order->procurement_type, 'fulfillment_method' => (string) $order->fulfillment_method,
                'line_count' => DB::table('order_lines')->where('order_id', $order->id)->count(), 'total_centavos' => (int) $order->commercial_total_centavos,
                'submitted_at' => $order->submitted_at === null ? null : CarbonImmutable::parse((string) $order->submitted_at)->toIso8601String(),
                'due_at' => $order->vendor_response_due_at === null ? null : CarbonImmutable::parse((string) $order->vendor_response_due_at)->toIso8601String()])->all();
    }

    /**
     * Demand funnel from records the platform really holds: inquiries, quotations, order requests, confirmations and completions.
     *
     * @param  array<string, mixed>  $context
     * @return list<array{key: string, label: string, count: int}>
     */
    private function funnel(array $context, int $confirmed, int $completed): array
    {
        $from = $context['from']->setTimezone('UTC');
        $inquiries = DB::table('conversations')->where('purpose', 'SALES')->where('vendor_organization_id', $context['organization'])->where('created_at', '>=', $from)->where('created_at', '<', $context['today']->addDay()->setTimezone('UTC'))->count();
        $quotations = DB::table('quotation_events as e')->join('quotations as q', 'q.id', '=', 'e.quotation_id')->where('q.vendor_organization_id', $context['organization'])->where('e.event_type', 'PUBLISHED')->where('e.created_at', '>=', $from)->where('e.created_at', '<', $context['today']->addDay()->setTimezone('UTC'))->count();
        $requests = DB::table('orders')->where('vendor_organization_id', $context['organization'])->whereNotNull('submitted_at')->where('submitted_at', '>=', $from)->where('submitted_at', '<', $context['today']->addDay()->setTimezone('UTC'))->count();

        return [['key' => 'INQUIRIES', 'label' => 'Buyer inquiries', 'count' => $inquiries], ['key' => 'QUOTATIONS', 'label' => 'Quotations published', 'count' => $quotations],
            ['key' => 'ORDER_REQUESTS', 'label' => 'Order requests', 'count' => $requests], ['key' => 'CONFIRMED', 'label' => 'Orders confirmed', 'count' => $confirmed], ['key' => 'COMPLETED', 'label' => 'Orders completed', 'count' => $completed]];
    }

    /**
     * @param  list<array<string, mixed>>  $set
     * @return list<array{key: string, count: int}>
     */
    private function mix(array $set, string $field): array
    {
        $counts = array_count_values(array_column($set, $field));
        arsort($counts);

        return array_map(static fn (string $key, int $count): array => ['key' => $key, 'count' => $count], array_keys($counts), array_values($counts));
    }

    /**
     * Top products, category share, demand segments (K-Means) and co-ordered materials (Apriori).
     *
     * @param  array<string, mixed>  $context
     * @param  list<array<string, mixed>>  $current
     * @param  list<array<string, mixed>>  $facts
     * @return array<string, mixed>
     */
    private function products(array $context, array $current, array $facts): array
    {
        $sales = (bool) $context['sales'];
        $lines = $this->lines(array_column($facts, 'id'));
        $currentIds = array_flip(array_column($current, 'id'));
        $historyFrom = $context['today']->subDays(self::HISTORY_DAYS - 1)->toDateString();
        $historyIds = array_flip(array_column(array_filter($facts, static fn (array $f): bool => $f['day'] >= $historyFrom && ! $f['cancelled']), 'id'));

        $products = [];
        $categories = [];
        $baskets = [];
        foreach ($lines as $line) {
            $key = $line['listing'];
            if (isset($currentIds[$line['order']])) {
                $products[$key] ??= ['name' => $line['name'], 'category' => $line['category'], 'orders' => [], 'buyers' => [], 'value' => 0];
                $products[$key]['orders'][$line['order']] = true;
                $products[$key]['buyers'][$line['buyer']] = true;
                $products[$key]['value'] += $line['value'];
                $categories[$line['category']] ??= ['orders' => [], 'value' => 0];
                $categories[$line['category']]['orders'][$line['order']] = true;
                $categories[$line['category']]['value'] += $line['value'];
            }
            if (isset($historyIds[$line['order']])) {
                $baskets[$line['order']]['items'][] = $line['name'];
                $baskets[$line['order']]['owner'] = $line['buyer'];
            }
        }
        $ranked = array_map(static fn (array $p): array => ['name' => $p['name'], 'category' => $p['category'], 'orders' => count($p['orders']), 'buyers' => count($p['buyers']), 'value_centavos' => $p['value']], array_values($products));
        usort($ranked, static fn (array $a, array $b): int => $sales ? [$b['value_centavos'], $b['orders'], $a['name']] <=> [$a['value_centavos'], $a['orders'], $b['name']] : [$b['orders'], $b['buyers'], $a['name']] <=> [$a['orders'], $a['buyers'], $b['name']]);
        $strip = static fn (array $row): array => $sales ? $row : ['value_centavos' => null] + $row;
        $categoryRows = [];
        foreach ($categories as $name => $category) {
            $categoryRows[] = ['category' => (string) $name, 'orders' => count($category['orders']), 'value_centavos' => $sales ? $category['value'] : null];
        }
        usort($categoryRows, static fn (array $a, array $b): int => $sales ? [$b['value_centavos'], $a['category']] <=> [$a['value_centavos'], $b['category']] : [$b['orders'], $a['category']] <=> [$a['orders'], $b['category']]);

        return ['top' => array_map($strip, array_slice($ranked, 0, 5)), 'categories' => array_slice($categoryRows, 0, 6), 'segments' => $this->segments($ranked, $sales),
            'basket_rules' => $this->basketRules(array_values($baskets))];
    }

    /**
     * @param  list<array{items: list<string>, owner: string}>  $baskets
     * @return array{baskets: int, rules: list<array<string, mixed>>, window_days: int}
     */
    private function basketRules(array $baskets): array
    {
        $mined = AssociationRules::mine($baskets, 2, 0.3, 2, 6);

        return ['baskets' => $mined['baskets'], 'rules' => array_map(static fn (array $rule): array => array_diff_key($rule, ['owners' => true]), $mined['rules']), 'window_days' => self::HISTORY_DAYS];
    }

    /**
     * @param  list<string>  $orderIds
     * @return list<array{order: string, buyer: string, listing: string, name: string, category: string, value: int}>
     */
    private function lines(array $orderIds): array
    {
        $out = [];
        foreach (array_chunk($orderIds, 1000) as $chunk) {
            $rows = DB::table('order_lines as l')->join('orders as o', 'o.id', '=', 'l.order_id')->leftJoin('listing_variants as lv', 'lv.id', '=', 'l.listing_variant_id')
                ->leftJoin('vendor_listings as v', 'v.id', '=', DB::raw('COALESCE(l.vendor_listing_id, lv.vendor_listing_id)'))->leftJoin('material_categories as c', 'c.id', '=', 'v.material_category_id')
                ->whereIn('l.order_id', $chunk)->get(['l.order_id', 'o.buyer_profile_id', 'l.payable_centavos', 'v.id as listing_id', 'v.display_name', 'c.name as category_name']);
            foreach ($rows as $row) {
                $out[] = ['order' => (string) $row->order_id, 'buyer' => (string) $row->buyer_profile_id, 'listing' => (string) ($row->listing_id ?? 'unlisted'), 'name' => (string) ($row->display_name ?? 'Unlisted material'),
                    'category' => (string) ($row->category_name ?? 'Uncategorized'), 'value' => (int) $row->payable_centavos];
            }
        }

        return $out;
    }

    /**
     * @param  list<array{name: string, category: string, orders: int, buyers: int, value_centavos: int}>  $ranked
     * @return array<string, mixed>
     */
    private function segments(array $ranked, bool $sales): array
    {
        if (count($ranked) < 4) {
            return ['state' => 'INSUFFICIENT_DATA', 'reason' => 'At least four products with orders in the period are needed to group them.', 'k' => null, 'silhouette' => null, 'features' => [], 'segments' => [], 'points' => []];
        }
        $features = $sales ? ['Orders', 'Distinct Buyers', 'Value'] : ['Orders', 'Distinct Buyers'];
        $points = array_map(static fn (array $p): array => $sales ? [$p['orders'], $p['buyers'], $p['value_centavos']] : [$p['orders'], $p['buyers']], $ranked);
        $result = KMeans::best($points, 2, 4);
        $labels = self::SEGMENT_LABELS[$result['k']] ?? [];
        // Rank segments by their centroid's order count so the label always matches the demand the group shows.
        $order = array_keys($result['centroids']);
        usort($order, static fn (int $a, int $b): int => [$result['centroids'][$b][0], $a] <=> [$result['centroids'][$a][0], $b]);
        $labelOf = [];
        foreach ($order as $position => $segment) {
            $labelOf[$segment] = $labels[$position] ?? 'Segment '.($segment + 1);
        }
        $segments = [];
        foreach ($result['centroids'] as $index => $centroid) {
            $members = array_values(array_filter(array_keys($result['assignments']), static fn (int $i): bool => $result['assignments'][$i] === $index));
            $segments[] = ['id' => $index, 'label' => $labelOf[$index], 'size' => $result['sizes'][$index], 'average_orders' => round($centroid[0], 1), 'average_buyers' => round($centroid[1], 1),
                'average_value_centavos' => $sales ? (int) round($centroid[2]) : null, 'examples' => array_map(static fn (int $i): string => $ranked[$i]['name'], array_slice($members, 0, 3))];
        }
        usort($segments, static fn (array $a, array $b): int => $b['average_orders'] <=> $a['average_orders']);

        return ['state' => 'OK', 'reason' => null, 'k' => $result['k'], 'silhouette' => $result['silhouette'], 'features' => $features, 'segments' => $segments,
            'points' => array_map(static fn (array $p, int $segment): array => ['name' => $p['name'], 'orders' => $p['orders'], 'buyers' => $p['buyers'], 'segment' => $labelOf[$segment]], array_slice($ranked, 0, 60), array_slice($result['assignments'], 0, 60))];
    }

    /**
     * @param  list<string>  $history
     * @param  array<string, array<string, mixed>>  $byDay
     * @return array<string, mixed>
     */
    private function unusualDays(array $history, array $byDay, bool $sales): array
    {
        $days = array_values(array_filter($history, static fn (string $date): bool => ($byDay[$date]['orders'] ?? 0) > 0));
        if (count($days) < 8) {
            return ['state' => 'INSUFFICIENT_DATA', 'days' => [], 'epsilon' => null];
        }
        $points = array_map(static fn (string $date): array => [$byDay[$date]['orders'], $sales ? $byDay[$date]['gross'] : count($byDay[$date]['buyers'])], $days);
        $result = Dbscan::run($points, 3);

        return ['state' => 'OK', 'epsilon' => $result['epsilon'], 'days' => array_map(static fn (int $i): array => ['date' => $days[$i], 'orders' => $byDay[$days[$i]]['orders'],
            'gross_sales_centavos' => $sales ? $byDay[$days[$i]]['gross'] : null], $result['noise'])];
    }

    /** @return array<string, mixed> */
    private function performance(Request $request): array
    {
        $performance = $this->scores->vendorPerformance($request);
        $scores = [];
        foreach ($performance['scores'] as $score) {
            $scores[(string) $score['key']] = $score;
        }
        $rates = $performance['operations']['rates'] ?? null;
        $classification = VendorRiskClassifier::classify(['vps' => ($scores['VPS']['published'] ?? false) ? (string) $scores['VPS']['value'] : null, 'ohs' => ($scores['OHS']['published'] ?? false) ? (string) $scores['OHS']['value'] : null,
            'rates' => is_array($rates) ? array_map('strval', $rates) : null]);

        return ['calculated' => $performance['calculated'], 'as_of' => $performance['as_of'], 'label' => $performance['label'], 'scores' => $performance['scores'], 'badge_metrics' => $performance['badge_metrics'],
            'operations' => $performance['operations'], 'history' => $performance['history'], 'classification' => $classification, 'badges' => array_values(array_filter($performance['badges'], static fn (array $badge): bool => $badge['status'] === 'EARNED'))];
    }

    /** @return array<string, mixed> */
    private function stock(string $organizationId): array
    {
        $base = fn () => DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('v.active', true);
        $available = 'i.quantity_on_hand - i.hard_reserved_quantity';
        $summary = $base()->selectRaw("COUNT(*) AS variants, COUNT(*) FILTER (WHERE i.id IS NULL OR $available <= 0) AS out_of_stock,
            COUNT(*) FILTER (WHERE $available > 0 AND i.reorder_level IS NOT NULL AND $available <= i.reorder_level) AS limited_stock")->first();
        $attention = $base()->whereRaw("(i.id IS NULL OR $available <= 0 OR (i.reorder_level IS NOT NULL AND $available <= i.reorder_level))")
            ->orderByRaw("COALESCE($available, 0)")->orderBy('l.display_name')->limit(5)
            ->get(['l.display_name', 'v.label', 'i.quantity_on_hand', 'i.hard_reserved_quantity', 'i.reorder_level', DB::raw('i.id IS NULL AS untracked')]);
        $variants = (int) $summary->variants;
        $out = (int) $summary->out_of_stock;
        $limited = (int) $summary->limited_stock;

        return ['variants' => $variants, 'in_stock' => max(0, $variants - $out - $limited), 'limited_stock' => $limited, 'out_of_stock' => $out,
            'attention' => $attention->map(static fn (object $row): array => ['name' => (string) $row->display_name, 'variant' => $row->label === null ? null : (string) $row->label,
                'available' => $row->untracked ? '0' : (string) ((float) $row->quantity_on_hand - (float) $row->hard_reserved_quantity), 'reorder_level' => $row->reorder_level === null ? null : (string) $row->reorder_level,
                'status' => $row->untracked || ((float) $row->quantity_on_hand - (float) $row->hard_reserved_quantity) <= 0 ? 'OUT_OF_STOCK' : 'LIMITED_STOCK'])->all()];
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array<string, mixed>
     */
    private function disputes(array $context): array
    {
        $cases = fn () => DB::table('dispute_cases as c')->join('orders as o', 'o.id', '=', 'c.order_id')->where('o.vendor_organization_id', $context['organization']);
        $since = $context['from']->setTimezone('UTC');
        $open = (clone $cases())->whereIn('c.status', DisputeRules::ACTIVE);
        $awaiting = (clone $cases())->where('c.status', DisputeRules::OPEN_AWAITING_RESPONSE);
        $byDay = [];
        foreach ((clone $cases())->where('c.created_at', '>=', $since)->where('c.created_at', '<', $context['today']->addDay()->setTimezone('UTC'))->selectRaw("(c.created_at AT TIME ZONE '".self::TIMEZONE."')::date AS day, COUNT(*) AS total")->groupByRaw("(c.created_at AT TIME ZONE '".self::TIMEZONE."')::date")->get() as $row) {
            $byDay[(string) $row->day] = (int) $row->total;
        }
        $series = [];
        for ($cursor = $context['from']; $cursor->lessThanOrEqualTo($context['today']); $cursor = $cursor->addDay()) {
            $series[] = ['date' => $cursor->toDateString(), 'cases' => $byDay[$cursor->toDateString()] ?? 0];
        }
        $oldest = (clone $awaiting)->min('c.response_due_at');

        return ['open' => (clone $open)->count(), 'awaiting_response' => (clone $awaiting)->count(), 'next_response_due_at' => $oldest === null ? null : CarbonImmutable::parse((string) $oldest)->toIso8601String(),
            'filed_in_period' => array_sum($byDay), 'series' => $series,
            'issue_types' => (clone $cases())->where('c.created_at', '>=', $since)->where('c.created_at', '<', $context['today']->addDay()->setTimezone('UTC'))->groupBy('c.issue_type')->orderByRaw('COUNT(*) DESC')->orderBy('c.issue_type')->selectRaw('c.issue_type AS key, COUNT(*) AS count')->get()
                ->map(static fn (object $row): array => ['key' => (string) $row->key, 'count' => (int) $row->count])->all(),
            'statuses' => (clone $cases())->whereIn('c.status', DisputeRules::ACTIVE)->groupBy('c.status')->orderByRaw('COUNT(*) DESC')->orderBy('c.status')->selectRaw('c.status AS key, COUNT(*) AS count')->get()
                ->map(static fn (object $row): array => ['key' => (string) $row->key, 'count' => (int) $row->count])->all(),
            'fulfillment_issues' => DB::table('fulfillment_issues as i')->join('orders as o', 'o.id', '=', 'i.order_id')->where('o.vendor_organization_id', $context['organization'])->where('i.created_at', '>=', $since)->where('i.created_at', '<', $context['today']->addDay()->setTimezone('UTC'))->count(),
            'validated_returns' => DB::table('metric_events')->where('vendor_organization_id', $context['organization'])->where('metric', 'VALIDATED_DEFECT_RETURN')->where('occurred_at', '>=', $since)->where('occurred_at', '<', $context['today']->addDay()->setTimezone('UTC'))->count()];
    }

    /**
     * Work waiting for this role. A count appears only when the role holds the grant that lets it act on the item.
     *
     * @param  array<string, mixed>  $context
     * @param  array<string, bool>  $access
     * @param  array<string, mixed>|null  $orders
     * @param  array<string, mixed>|null  $stock
     * @param  array<string, mixed>|null  $disputes
     * @return list<array{key: string, label: string, count: int, severity: string, href: string, detail: string|null}>
     */
    private function actions(array $context, array $access, ?array $orders, ?array $stock, ?array $disputes, int $userId): array
    {
        $items = [];
        $today = CarbonImmutable::now(self::TIMEZONE)->toDateString();
        if ($orders !== null) {
            $awaiting = DB::table('orders')->where('vendor_organization_id', $context['organization'])->where('order_state', 'AWAITING_VENDOR_CONFIRMATION');
            $due = (clone $awaiting)->min('vendor_response_due_at');
            $items[] = ['key' => 'ORDER_CONFIRMATION', 'label' => 'Order requests awaiting your decision', 'count' => (clone $awaiting)->count(), 'severity' => 'ACTION', 'href' => '/orders',
                'detail' => $due === null ? null : 'Earliest response due '.CarbonImmutable::parse((string) $due)->setTimezone(self::TIMEZONE)->format('M j, g:i A').' (Asia/Manila)'];
            $overdue = DB::table('orders')->where('vendor_organization_id', $context['organization'])->whereIn('order_state', self::IN_FULFILLMENT)->whereNotNull('expected_fulfillment_date')->where('expected_fulfillment_date', '<', $today)->count();
            $items[] = ['key' => 'FULFILLMENT_OVERDUE', 'label' => 'Orders past their expected fulfillment date', 'count' => $overdue, 'severity' => $overdue > 0 ? 'ALERT' : 'ACTION', 'href' => '/orders', 'detail' => null];
            $dueToday = DB::table('orders')->where('vendor_organization_id', $context['organization'])->whereIn('order_state', self::IN_FULFILLMENT)->where('expected_fulfillment_date', $today)->count();
            $items[] = ['key' => 'FULFILLMENT_DUE_TODAY', 'label' => 'Orders due for fulfillment today', 'count' => $dueToday, 'severity' => 'ACTION', 'href' => '/orders', 'detail' => null];
        }
        if ($access['assigned_fulfillment']) {
            $assigned = DB::table('order_fulfillment_assignments as a')->join('orders as o', 'o.id', '=', 'a.order_id')->where('a.user_id', $userId)->whereNull('a.ended_at')->where('o.vendor_organization_id', $context['organization'])
                ->whereIn('o.order_state', [...self::IN_FULFILLMENT, 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'])->count();
            $items[] = ['key' => 'ASSIGNED_FULFILLMENT', 'label' => 'Orders assigned to you', 'count' => $assigned, 'severity' => 'ACTION', 'href' => '/orders', 'detail' => null];
        }
        if ($disputes !== null) {
            $items[] = ['key' => 'DISPUTE_RESPONSE', 'label' => 'Cases awaiting your response', 'count' => (int) $disputes['awaiting_response'], 'severity' => (int) $disputes['awaiting_response'] > 0 ? 'ALERT' : 'ACTION', 'href' => '/disputes',
                'detail' => $disputes['next_response_due_at'] === null ? null : 'Earliest response due '.CarbonImmutable::parse((string) $disputes['next_response_due_at'])->setTimezone(self::TIMEZONE)->format('M j, g:i A').' (Asia/Manila)'];
        }
        if ($stock !== null) {
            $items[] = ['key' => 'OUT_OF_STOCK', 'label' => 'Variants out of stock', 'count' => (int) $stock['out_of_stock'], 'severity' => (int) $stock['out_of_stock'] > 0 ? 'ALERT' : 'ACTION', 'href' => '/products/inventory', 'detail' => null];
            $items[] = ['key' => 'LIMITED_STOCK', 'label' => 'Variants at or below reorder level', 'count' => (int) $stock['limited_stock'], 'severity' => 'ACTION', 'href' => '/products/inventory', 'detail' => null];
        }

        return $items;
    }
}
