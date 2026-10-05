<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Disputes\DisputeRules;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Projects append-only metric events from authoritative facts only — the order status history, fulfillment
 * milestones, Phase 12 non-fulfillment events, concluded dispute decisions and sales messages — never from a client
 * claim or a manual score. Each event is unique on (metric, source id) so replays insert nothing new. Store hours are
 * never read: response time is wall-clock time, so a schedule edit cannot change CRR or any other metric.
 *
 *   ORDER_CONFIRMED          an order first reached CONFIRMED (NFR and ODR denominator: eligible confirmed orders)
 *   FULFILLMENT_DISPATCHED   first READY_FOR_PICKUP or OUT_FOR_DELIVERY; value 1 = after the Vendor-confirmed date (LSR)
 *   ORDER_FULFILLED          Self-Pickup made ready / Site Delivery delivered; value 1 = on or before that date (FRR, RR base)
 *   ORDER_COMPLETED          the order reached COMPLETED; details carry its canonical categories (Most Ordered, Trusted)
 *   VENDOR_NON_FULFILLMENT   a Vendor-caused cancellation (Phase 12) or a confirmed dispute finding (NFR numerator)
 *   VALIDATED_DEFECT_RETURN  a validated defect, wrong-item or incomplete-order return finding (RR numerator)
 *   ORDER_DEFECT             a concluded Buyer case decided for the Buyer: replacement or refund (ODR numerator)
 *   MISREPRESENTED_LISTING   a confirmed listing violation (LVD)
 *   INQUIRY                  one Buyer sales inquiry episode; value 1 = first human reply or quotation within 12 hours
 */
final class MetricEventProjector
{
    public const HUMAN_MESSAGE_KINDS = ['TEXT', 'PRODUCT', 'TEXT_WITH_PRODUCT'];

    public const DEFECT_OUTCOMES = ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND'];

    /** @return array<string, int> inserted events per metric */
    public function project(CarbonImmutable $now, int $lookbackDays = 120): array
    {
        // Query bindings drop the offset, so every instant is compared in UTC.
        $now = $now->setTimezone('UTC');
        $since = $now->subDays($lookbackDays);
        $counts = [];
        $add = function (string $metric, int $inserted) use (&$counts): void {
            $counts[$metric] = ($counts[$metric] ?? 0) + $inserted;
        };

        foreach (DB::table('order_status_history as h')->join('orders as o', 'o.id', '=', 'h.order_id')->where('h.state_family', 'ORDER')->whereIn('h.to_state', ['CONFIRMED', 'COMPLETED'])
            ->where('h.created_at', '>=', $since)->where('h.created_at', '<=', $now)->orderBy('h.created_at')->get(['h.order_id', 'h.to_state', 'h.created_at', 'o.vendor_organization_id']) as $row) {
            $details = null;
            if ($row->to_state === 'COMPLETED') {
                $details = ['category_ids' => DB::table('order_lines as ol')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                    ->where('ol.order_id', $row->order_id)->whereNotNull('l.material_category_id')->distinct()->orderBy('l.material_category_id')->pluck('l.material_category_id')->map(static fn (mixed $id): string => (string) $id)->all()];
            }
            $add($row->to_state === 'CONFIRMED' ? 'ORDER_CONFIRMED' : 'ORDER_COMPLETED', $this->insert((string) $row->vendor_organization_id, $row->to_state === 'CONFIRMED' ? 'ORDER_CONFIRMED' : 'ORDER_COMPLETED',
                (string) $row->order_id, (string) $row->order_id, $row->created_at, '1', 'ORDER_STATUS_HISTORY', $details));
        }

        $milestones = DB::table('fulfillment_milestones as m')->join('orders as o', 'o.id', '=', 'm.order_id')->whereNotNull('o.expected_fulfillment_date')
            ->whereIn('m.event_type', ['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED'])->where('m.occurred_at', '>=', $since)->where('m.occurred_at', '<=', $now)
            ->orderBy('m.occurred_at')->orderBy('m.id')->get(['m.order_id', 'm.event_type', 'm.occurred_at', 'o.vendor_organization_id', 'o.expected_fulfillment_date', 'o.fulfillment_method']);
        foreach ($milestones as $milestone) {
            $localDate = CarbonImmutable::parse((string) $milestone->occurred_at)->setTimezone('Asia/Manila')->toDateString();
            $late = $localDate > (string) $milestone->expected_fulfillment_date;
            $details = ['expected_fulfillment_date' => (string) $milestone->expected_fulfillment_date, 'local_date' => $localDate, 'milestone' => $milestone->event_type];
            if (in_array($milestone->event_type, ['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'], true)) {
                $add('FULFILLMENT_DISPATCHED', $this->insert((string) $milestone->vendor_organization_id, 'FULFILLMENT_DISPATCHED', (string) $milestone->order_id, (string) $milestone->order_id,
                    $milestone->occurred_at, $late ? '1' : '0', 'FULFILLMENT_MILESTONE', $details));
            }
            $fulfills = ($milestone->fulfillment_method === 'DELIVERY' && $milestone->event_type === 'DELIVERED') || ($milestone->fulfillment_method !== 'DELIVERY' && $milestone->event_type === 'READY_FOR_PICKUP');
            if ($fulfills) {
                $add('ORDER_FULFILLED', $this->insert((string) $milestone->vendor_organization_id, 'ORDER_FULFILLED', (string) $milestone->order_id, (string) $milestone->order_id,
                    $milestone->occurred_at, $late ? '0' : '1', 'FULFILLMENT_MILESTONE', $details));
            }
        }

        foreach (DB::table('nfr_events')->where('occurred_at', '>=', $since)->where('occurred_at', '<=', $now)->get() as $event) {
            $add('VENDOR_NON_FULFILLMENT', $this->insert((string) $event->vendor_organization_id, 'VENDOR_NON_FULFILLMENT', (string) $event->id, (string) $event->order_id,
                $event->occurred_at, '1', 'CANCELLATION_DECISION', ['reason_code' => $event->reason_code]));
        }

        $defects = DB::table('dispute_cases as c')->join('dispute_decisions as d', 'd.id', '=', 'c.current_decision_id')->whereIn('c.status', DisputeRules::CONCLUDED)
            ->where('c.filed_by_party', 'BUYER')->whereIn('d.outcome', self::DEFECT_OUTCOMES)->whereNotNull('c.concluded_at')->where('c.concluded_at', '>=', $since)->where('c.concluded_at', '<=', $now)
            ->get(['c.id', 'c.order_id', 'c.vendor_organization_id', 'c.concluded_at', 'c.issue_type', 'd.outcome']);
        foreach ($defects as $case) {
            $add('ORDER_DEFECT', $this->insert((string) $case->vendor_organization_id, 'ORDER_DEFECT', (string) $case->id, (string) $case->order_id, $case->concluded_at, '1', 'DISPUTE_DECISION',
                ['issue_type' => $case->issue_type, 'outcome' => $case->outcome]));
        }

        $add('INQUIRY', $this->projectInquiries($now, $since));

        return $counts;
    }

    /**
     * Inquiry episodes per sales conversation: a Buyer human message opens an episode when none is open; the first
     * human Vendor reply or published quotation closes it. Follow-up Buyer messages before a reply belong to the same
     * episode (no duplicates). An episode is recorded once answered or once 12 hours pass unanswered; a still-open
     * episode younger than 12 hours is left for a later run. Automated system messages never count as a reply.
     */
    private function projectInquiries(CarbonImmutable $now, CarbonImmutable $since): int
    {
        $inserted = 0;
        $conversations = DB::table('conversations as c')->join('buyer_profiles as b', 'b.id', '=', 'c.buyer_profile_id')->where('c.purpose', 'SALES')->where('c.state', 'ACTIVE')
            ->whereExists(fn ($q) => $q->selectRaw('1')->from('messages as m')->whereColumn('m.conversation_id', 'c.id')->where('m.sent_at', '>=', $since))
            ->orderBy('c.id')->get(['c.id', 'c.vendor_organization_id', 'b.user_id as buyer_user_id']);
        foreach ($conversations as $conversation) {
            $events = DB::table('messages')->where('conversation_id', $conversation->id)->where('sent_at', '>=', $since)->where('sent_at', '<=', $now)
                ->whereIn('kind', self::HUMAN_MESSAGE_KINDS)->orderBy('sent_at')->orderBy('id')->get(['id', 'sender_user_id', 'sent_at'])
                ->map(static fn (object $m): array => ['id' => (string) $m->id, 'buyer' => (int) $m->sender_user_id === (int) $conversation->buyer_user_id, 'at' => CarbonImmutable::parse((string) $m->sent_at)])
                ->concat(DB::table('quotation_versions as v')->join('quotations as q', 'q.id', '=', 'v.quotation_id')->where('q.conversation_id', $conversation->id)->whereNotNull('v.published_at')
                    ->where('v.published_at', '>=', $since)->where('v.published_at', '<=', $now)->get(['v.id', 'v.published_at'])
                    ->map(static fn (object $v): array => ['id' => (string) $v->id, 'buyer' => false, 'at' => CarbonImmutable::parse((string) $v->published_at)]))
                ->sortBy(static fn (array $event): string => $event['at']->format('Y-m-d H:i:s.u').$event['id'])->values();
            $open = null;
            foreach ($events as $event) {
                if ($event['buyer']) {
                    $open ??= $event;

                    continue;
                }
                if ($open !== null) {
                    $within = $event['at']->lessThanOrEqualTo($open['at']->addHours(ScoreRules::RESPONSE_HOURS));
                    $inserted += $this->insert((string) $conversation->vendor_organization_id, 'INQUIRY', $open['id'], null, $open['at'], $within ? '1' : '0', 'SALES_MESSAGE',
                        ['response_seconds' => $open['at']->diffInSeconds($event['at'])]);
                    $open = null;
                }
            }
            if ($open !== null && $now->greaterThan($open['at']->addHours(ScoreRules::RESPONSE_HOURS))) {
                $inserted += $this->insert((string) $conversation->vendor_organization_id, 'INQUIRY', $open['id'], null, $open['at'], '0', 'SALES_MESSAGE', ['response_seconds' => null]);
            }
        }

        return $inserted;
    }

    /** @param array<string, mixed>|null $details */
    private function insert(string $organizationId, string $metric, string $sourceId, ?string $orderId, mixed $occurredAt, string $value, string $sourceKind, ?array $details): int
    {
        return DB::table('metric_events')->insertOrIgnore([
            'id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'metric' => $metric, 'source_id' => $sourceId, 'order_id' => $orderId,
            'occurred_at' => CarbonImmutable::parse((string) $occurredAt)->setTimezone('UTC'), 'value' => $value, 'environment' => 'TEST', 'source_kind' => $sourceKind,
            'details' => $details === null ? null : json_encode($details, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now(),
        ]);
    }
}
