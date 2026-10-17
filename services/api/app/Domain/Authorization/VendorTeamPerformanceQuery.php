<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Analytics\Dashboard\VendorDashboardInsights;
use App\Domain\Disputes\DisputeRules;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Team Tracking statistics for one member, chosen by the member's current fixed role. Every figure reads records that
 * already store the actual actor (Vendor workflow, Attribution Rules); nothing is estimated. Peso values need
 * finance.view (Owner only), matching the Dashboard, Earnings and Product Analytics.
 */
final class VendorTeamPerformanceQuery
{
    private const TIMEZONE = 'Asia/Manila';

    private const TREND_DAILY_MAX_DAYS = 92;

    /** Work areas each fixed role covers; a role never reports another role's work. */
    private const GROUPS = [
        'OWNER' => ['sales', 'quotations', 'orders', 'disputes', 'inventory', 'fulfillment'],
        'STORE_MANAGER' => ['sales', 'quotations', 'orders', 'disputes', 'inventory', 'fulfillment'],
        'STORE_STAFF' => ['sales', 'quotations', 'orders', 'disputes', 'inventory'],
        'CUSTOMER_SERVICE' => ['sales', 'quotations', 'orders', 'disputes'],
        'INVENTORY' => ['inventory'],
        'FULFILLMENT' => ['fulfillment'],
    ];

    /** The daily series shown for each role. */
    private const TREND = ['OWNER' => 'ACTIONS', 'STORE_MANAGER' => 'ACTIONS', 'STORE_STAFF' => 'SALES', 'CUSTOMER_SERVICE' => 'SALES', 'INVENTORY' => 'INVENTORY_UPDATES', 'FULFILLMENT' => 'HANDOVERS'];

    private const HANDOVERS = ['DELIVERED', 'PICKED_UP'];

    private const MILESTONES = ['PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'TRIP_DISPATCHED'];

    private const ACTIVE_FULFILLMENT = ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'];

    private const INVENTORY_ACTIONS = '^(CATALOG_|INVENTORY_|AUTO_ACCEPT_|PRODUCT_COMPLIANCE_)';

    /*
     * Sales Attribution: a quotation order belongs to whoever handled the inquiry when the Buyer accepted it (the
     * assignment active at that moment, else the conversation's handler); any other order belongs to the person who
     * manually confirmed it. Auto-accepted orders have no human sales owner.
     */
    private const SALES_OWNER = <<<'SQL'
COALESCE(
 CASE WHEN o.quotation_version_id IS NOT NULL THEN COALESCE(
  (SELECT ca.assigned_user_id FROM quotation_versions qv JOIN quotations q ON q.id = qv.quotation_id JOIN conversation_assignments ca ON ca.conversation_id = q.conversation_id
    WHERE qv.id = o.quotation_version_id AND ca.created_at <= o.created_at AND (ca.ended_at IS NULL OR ca.ended_at > o.created_at) ORDER BY ca.created_at DESC, ca.id DESC LIMIT 1),
  (SELECT c.handler_user_id FROM quotation_versions qv JOIN quotations q ON q.id = qv.quotation_id JOIN conversations c ON c.id = q.conversation_id WHERE qv.id = o.quotation_version_id)) END,
 (SELECT vc.actor_user_id FROM vendor_confirmations vc WHERE vc.order_id = o.id AND vc.source = 'MANUAL' AND vc.state IN ('CONFIRMED', 'REVISED') ORDER BY vc.created_at, vc.id LIMIT 1))
SQL;

    private const CONFIRMED_AT = "(SELECT MIN(h.created_at) FROM order_status_history h WHERE h.order_id = o.id AND h.state_family = 'ORDER' AND h.to_state = 'CONFIRMED')";

    public function __construct(private readonly VendorTeamActivityQuery $activity) {}

    /** @return array<string, mixed> */
    public function read(Request $request, AccountAccess $access): array
    {
        $scope = $this->activity->scope($request, $access);
        $input = $request->validate(['member_id' => ['required', 'uuid']] + PortalDateRange::rules($request));
        $member = $this->activity->member($scope, (string) $input['member_id']);
        $organization = (string) $scope['organization_id'];
        $user = (int) $member->user_id;
        $role = (string) $member->role;
        $period = array_intersect_key($input, array_flip(['from', 'to']));
        $money = in_array('finance.view', $scope['permissions'], true);
        $actions = $this->activity->events($scope)->where('a.actor_user_id', $user);
        $totals = PortalDateRange::apply(clone $actions, 'a.created_at', $period)->selectRaw('count(*) AS total, count(*) FILTER (WHERE a.succeeded) AS succeeded')->first();

        $data = ['member_id' => (string) $member->id, 'role' => $role, 'timezone' => self::TIMEZONE, 'sales_value_visible' => $money]
            + $period + ['activity' => ['total' => (int) $totals->total, 'succeeded' => (int) $totals->succeeded, 'unsuccessful' => (int) $totals->total - (int) $totals->succeeded]];
        foreach (self::GROUPS[$role] ?? [] as $group) {
            $data[$group] = match ($group) {
                'sales' => $this->sales($organization, $user, $period, $money),
                'quotations' => $this->quotations($organization, $user, $period),
                'orders' => $this->confirmations($organization, $user, $period),
                'disputes' => $this->disputes($organization, $user, $period),
                'inventory' => $this->inventory($organization, $user, $period),
                'fulfillment' => $this->fulfillment($organization, $user, $period),
            };
        }
        $metric = self::TREND[$role] ?? 'ACTIONS';
        $data['trend'] = $this->trend($metric, match ($metric) {
            'SALES' => [$this->sold($organization, $user), 's.sold_at'],
            'INVENTORY_UPDATES' => [$this->inventoryActions($organization, $user)->where('succeeded', true), 'created_at'],
            'HANDOVERS' => [$this->milestones($organization, $user)->whereIn('fm.event_type', self::HANDOVERS), 'fm.occurred_at'],
            default => [$actions, 'a.created_at'],
        }, $period, CarbonImmutable::parse((string) $member->created_at));

        return $data;
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, mixed>
     */
    private function sales(string $organization, int $user, array $period, bool $money): array
    {
        $row = PortalDateRange::apply($this->sold($organization, $user), 's.sold_at', $period)
            ->selectRaw("count(*) AS orders, count(*) FILTER (WHERE s.order_state = 'COMPLETED') AS completed, count(*) FILTER (WHERE s.order_state = 'CANCELLED') AS cancelled, COALESCE(sum(s.materials_centavos), 0) AS value")->first();

        return ['orders' => (int) $row->orders, 'completed' => (int) $row->completed, 'cancelled' => (int) $row->cancelled]
            + ($money ? ['value_centavos' => (int) $row->value] : [])
            + $this->conversationWork($organization, $user, 'SALES', $period);
    }

    /** Orders attributed to the member that reached confirmation, dated by their first confirmation. */
    private function sold(string $organization, int $user): Builder
    {
        $orders = DB::table('orders as o')->where('o.vendor_organization_id', $organization)
            ->selectRaw('o.order_state, o.materials_centavos, '.self::SALES_OWNER.' AS sales_user_id, '.self::CONFIRMED_AT.' AS confirmed_at, COALESCE('.self::CONFIRMED_AT.', o.accepted_at, o.created_at) AS sold_at');

        return DB::query()->fromSub($orders, 's')->where('s.sales_user_id', $user)
            ->where(fn (Builder $query) => $query->whereNotNull('s.confirmed_at')->orWhereIn('s.order_state', VendorDashboardInsights::POST_CONFIRMATION));
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, mixed>
     */
    private function conversationWork(string $organization, int $user, string $purpose, array $period): array
    {
        $sent = DB::table('messages as m')->join('conversations as c', 'c.id', '=', 'm.conversation_id')
            ->where('c.vendor_organization_id', $organization)->where('c.purpose', $purpose)->where('m.sender_user_id', $user)->where('m.kind', '!=', 'SYSTEM');
        $counts = PortalDateRange::apply($sent, 'm.sent_at', $period)->selectRaw('count(*) AS messages, count(DISTINCT m.conversation_id) AS conversations')->first();
        $awaiting = DB::table('conversations as c')->where('c.vendor_organization_id', $organization)->where('c.purpose', $purpose)->where('c.state', 'ACTIVE')
            ->whereNull('c.canonical_conversation_id')->where('c.handler_user_id', $user)
            // A fulfillment thread turns read-only when its order closes, so only open orders can still be waiting.
            ->when($purpose === 'FULFILLMENT', fn (Builder $query) => $query->whereIn('c.order_id', DB::table('orders')->whereIn('order_state', [...self::ACTIVE_FULFILLMENT, 'DELIVERED', 'PICKED_UP'])->select('id')))
            ->whereRaw("(SELECT m.public_sender->>'role' FROM messages m WHERE m.conversation_id = c.id AND m.kind <> 'SYSTEM' ORDER BY m.sent_at DESC, m.id DESC LIMIT 1) = 'BUYER'")->count();

        return ['conversations' => (int) $counts->conversations, 'messages' => (int) $counts->messages, 'awaiting_reply' => $awaiting, 'reply' => $this->replyTime($organization, $user, $purpose, $period)];
    }

    /**
     * Elapsed time from the first unanswered Buyer message to the first Vendor reply after it, credited to whoever sent
     * that reply. System notices and messages without a recorded sender role neither open nor answer a wait.
     *
     * @param  array<string, string>  $period
     * @return array<string, int|null>
     */
    private function replyTime(string $organization, int $user, string $purpose, array $period): array
    {
        $bindings = [$organization, $purpose, $user, $user];
        $window = '';
        if (isset($period['from'])) {
            $window .= ' AND r.sent_at >= ?';
            $bindings[] = CarbonImmutable::parse($period['from'], self::TIMEZONE)->startOfDay()->setTimezone('UTC');
        }
        if (isset($period['to'])) {
            $window .= ' AND r.sent_at < ?';
            $bindings[] = CarbonImmutable::parse($period['to'], self::TIMEZONE)->startOfDay()->addDay()->setTimezone('UTC');
        }
        $row = DB::selectOne(<<<SQL
WITH thread AS (
  SELECT m.conversation_id, m.sender_user_id, m.sent_at, m.public_sender->>'role' = 'BUYER' AS from_buyer,
    SUM(CASE WHEN m.public_sender->>'role' <> 'BUYER' THEN 1 ELSE 0 END) OVER (PARTITION BY m.conversation_id ORDER BY m.sent_at, m.id ROWS UNBOUNDED PRECEDING) AS answered
  FROM messages m JOIN conversations c ON c.id = m.conversation_id
  WHERE c.vendor_organization_id = ? AND c.purpose = ? AND m.kind <> 'SYSTEM' AND m.public_sender->>'role' IS NOT NULL
    AND EXISTS (SELECT 1 FROM messages own WHERE own.conversation_id = m.conversation_id AND own.sender_user_id = ? AND own.kind <> 'SYSTEM')
), asked AS (
  SELECT conversation_id, answered, MIN(sent_at) AS asked_at FROM thread WHERE from_buyer GROUP BY conversation_id, answered
), waits AS (
  SELECT EXTRACT(EPOCH FROM r.sent_at - a.asked_at) AS seconds FROM asked a
  JOIN thread r ON r.conversation_id = a.conversation_id AND NOT r.from_buyer AND r.answered = a.answered + 1
  WHERE r.sender_user_id = ?{$window}
)
SELECT count(*) AS measured, round(avg(seconds)) AS average, round(percentile_cont(0.5) WITHIN GROUP (ORDER BY seconds)) AS median FROM waits
SQL, $bindings);

        return ['measured' => (int) $row->measured, 'average_seconds' => $row->average === null ? null : (int) $row->average, 'median_seconds' => $row->median === null ? null : (int) $row->median];
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, int>
     */
    private function quotations(string $organization, int $user, array $period): array
    {
        $drafts = DB::table('quotation_events as e')->join('quotations as q', 'q.id', '=', 'e.quotation_id')
            ->where('q.vendor_organization_id', $organization)->where('e.actor_user_id', $user)->where('e.event_type', 'DRAFT_SAVED');
        $published = DB::table('quotation_versions as v')->join('quotations as q', 'q.id', '=', 'v.quotation_id')
            ->where('q.vendor_organization_id', $organization)->where('v.created_by_user_id', $user)->whereNotNull('v.published_at');
        $accepted = DB::table('orders as o')->join('quotation_versions as v', 'v.id', '=', 'o.quotation_version_id')
            ->where('o.vendor_organization_id', $organization)->where('v.created_by_user_id', $user);

        return [
            'drafts' => (int) PortalDateRange::apply($drafts, 'e.created_at', $period)->distinct()->count('e.quotation_id'),
            'published' => PortalDateRange::apply($published, 'v.published_at', $period)->count(),
            'accepted' => PortalDateRange::apply($accepted, 'o.created_at', $period)->count(),
        ];
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, int>
     */
    private function confirmations(string $organization, int $user, array $period): array
    {
        $query = DB::table('vendor_confirmations as vc')->join('orders as o', 'o.id', '=', 'vc.order_id')
            ->where('o.vendor_organization_id', $organization)->where('vc.actor_user_id', $user)->where('vc.source', 'MANUAL');
        $row = PortalDateRange::apply($query, 'vc.created_at', $period)
            ->selectRaw("count(*) FILTER (WHERE vc.state = 'CONFIRMED') AS confirmed, count(*) FILTER (WHERE vc.state = 'REVISED') AS revised, count(*) FILTER (WHERE vc.state = 'DECLINED') AS declined")->first();

        return ['confirmed' => (int) $row->confirmed, 'revised' => (int) $row->revised, 'declined' => (int) $row->declined];
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, int>
     */
    private function disputes(string $organization, int $user, array $period): array
    {
        $cases = fn (): Builder => DB::table('dispute_cases as d')->join('orders as o', 'o.id', '=', 'd.order_id')
            ->where('o.vendor_organization_id', $organization)->where('d.vendor_handler_user_id', $user);
        $handled = PortalDateRange::apply($cases(), 'd.created_at', $period);

        return [
            'handled' => (clone $handled)->count(),
            'resolved' => $handled->whereIn('d.status', DisputeRules::CONCLUDED)->count(),
            'open' => $cases()->whereIn('d.status', DisputeRules::ACTIVE)->count(),
        ];
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, int>
     */
    private function inventory(string $organization, int $user, array $period): array
    {
        $row = PortalDateRange::apply($this->inventoryActions($organization, $user), 'created_at', $period)->selectRaw(<<<'SQL'
count(*) FILTER (WHERE succeeded AND action = 'INVENTORY_ROW_UPDATED') AS stock_updates,
count(*) FILTER (WHERE succeeded AND action = 'INVENTORY_STOCK_CONFIRMED') AS stock_confirmations,
count(*) FILTER (WHERE succeeded AND action = 'CATALOG_LISTING_CREATED') AS listings_created,
count(*) FILTER (WHERE succeeded AND action LIKE 'CATALOG\_%' AND action <> 'CATALOG_LISTING_CREATED') AS listing_updates,
count(*) FILTER (WHERE succeeded AND action = 'PRODUCT_COMPLIANCE_SUBMITTED') AS compliance_submissions,
count(*) FILTER (WHERE succeeded AND action LIKE 'AUTO\_ACCEPT\_%') AS allotment_updates,
count(*) FILTER (WHERE NOT succeeded) AS unsuccessful
SQL)->first();

        return array_map('intval', (array) $row);
    }

    private function inventoryActions(string $organization, int $user): Builder
    {
        return DB::table('audit_logs')->where('vendor_organization_id', $organization)->where('actor_user_id', $user)->whereRaw('action ~ ?', [self::INVENTORY_ACTIONS]);
    }

    /**
     * @param  array<string, string>  $period
     * @return array<string, mixed>
     */
    private function fulfillment(string $organization, int $user, array $period): array
    {
        $assignments = fn (): Builder => DB::table('order_fulfillment_assignments as fa')->join('orders as o', 'o.id', '=', 'fa.order_id')
            ->where('o.vendor_organization_id', $organization)->where('fa.user_id', $user);
        $handovers = "fm.event_type IN ('".implode("', '", self::HANDOVERS)."')";
        $row = PortalDateRange::apply($this->milestones($organization, $user), 'fm.occurred_at', $period)->selectRaw(
            "count(*) FILTER (WHERE fm.event_type IN ('".implode("', '", self::MILESTONES)."')) AS milestones, count(*) FILTER (WHERE {$handovers}) AS handovers,"
            ." count(*) FILTER (WHERE {$handovers} AND o.expected_fulfillment_date IS NOT NULL) AS on_time_measured,"
            ." count(*) FILTER (WHERE {$handovers} AND (fm.occurred_at AT TIME ZONE '".self::TIMEZONE."')::date <= o.expected_fulfillment_date) AS on_time,"
            ." count(*) FILTER (WHERE fm.event_type = 'VEHICLE_ISSUE_REPORTED') AS vehicle_issues")->first();
        $proofs = DB::table('fulfillment_proofs as p')->join('fulfillments as f', 'f.id', '=', 'p.fulfillment_id')->join('orders as o', 'o.id', '=', 'f.order_id')
            ->where('o.vendor_organization_id', $organization)->where('p.actor_user_id', $user);

        return [
            'assigned' => (int) PortalDateRange::apply($assignments(), 'fa.created_at', $period)->distinct()->count('fa.order_id'),
            'active' => (int) $assignments()->whereNull('fa.ended_at')->whereIn('o.order_state', self::ACTIVE_FULFILLMENT)->distinct()->count('fa.order_id'),
            'handovers' => (int) $row->handovers, 'on_time' => (int) $row->on_time, 'on_time_measured' => (int) $row->on_time_measured,
            'milestones' => (int) $row->milestones, 'proofs' => PortalDateRange::apply($proofs, 'p.created_at', $period)->count(), 'vehicle_issues' => (int) $row->vehicle_issues,
        ] + $this->conversationWork($organization, $user, 'FULFILLMENT', $period);
    }

    private function milestones(string $organization, int $user): Builder
    {
        return DB::table('fulfillment_milestones as fm')->join('fulfillments as f', 'f.id', '=', 'fm.fulfillment_id')->join('orders as o', 'o.id', '=', 'f.order_id')
            ->where('o.vendor_organization_id', $organization)->where('fm.actor_user_id', $user);
    }

    /**
     * The role's main series by Asia/Manila day, or by calendar month past 92 days. Without a start date the series
     * begins when the member joined; it never runs past today.
     *
     * @param  array{0: Builder, 1: string}  $source
     * @param  array<string, string>  $period
     * @return array<string, mixed>
     */
    private function trend(string $metric, array $source, array $period, CarbonImmutable $joined): array
    {
        $today = CarbonImmutable::now(self::TIMEZONE)->startOfDay();
        $end = isset($period['to']) ? CarbonImmutable::parse($period['to'], self::TIMEZONE)->startOfDay() : $today;
        $end = $end->greaterThan($today) ? $today : $end;
        $start = isset($period['from']) ? CarbonImmutable::parse($period['from'], self::TIMEZONE)->startOfDay() : $joined->setTimezone(self::TIMEZONE)->startOfDay();
        $start = $start->greaterThan($end) ? $end : $start;
        $monthly = (int) $start->diffInDays($end) + 1 > self::TREND_DAILY_MAX_DAYS;
        [$query, $column] = $source;
        $bucket = "to_char(date_trunc('".($monthly ? 'month' : 'day')."', {$column} AT TIME ZONE '".self::TIMEZONE."'), 'YYYY-MM-DD')";
        $values = PortalDateRange::apply(clone $query, DB::raw($column), ['from' => $start->toDateString(), 'to' => $end->toDateString()])
            ->selectRaw("{$bucket} AS bucket, count(*) AS value")->groupByRaw('1')->pluck('value', 'bucket');
        $points = [];
        for ($cursor = $monthly ? $start->startOfMonth() : $start; $cursor->lessThanOrEqualTo($end); $cursor = $monthly ? $cursor->addMonth() : $cursor->addDay()) {
            $points[] = ['date' => $cursor->toDateString(), 'value' => (int) ($values[$cursor->toDateString()] ?? 0)];
        }

        return ['metric' => $metric, 'granularity' => $monthly ? 'MONTH' : 'DAY', 'from' => $start->toDateString(), 'to' => $end->toDateString(), 'points' => $points];
    }
}
