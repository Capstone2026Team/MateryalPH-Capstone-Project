<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Geography\PsgcResolver;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Daily aggregate facts, refreshed every minute, for Philippine Geographic Marketplace Analytics (TEST marketplace).
 * Each run rebuilds the derived projection idempotently inside one transaction under an advisory lock, then publishes a new revision; a
 * retry simply produces the next revision of the same facts. Facts carry PSGC codes, pseudonymous person keys and
 * integer centavos only: no coordinates, names, contact details or payment data ever enter them. Where an address has
 * no PSGC reference, an imported boundary may place its stored point inside PostgreSQL; the point itself never leaves
 * the database.
 *
 * Definitions (Admin Workflow §2): an order is confirmed when it first reaches CONFIRMED; demand is attributed to the
 * Project site, else the delivery site, else the pickup store. Activity counts only meaningful human actions; app
 * opens, automated jobs and auto-accept never count. Response time runs from an inquiry, Work Package request, order
 * request or counter-offer to the first human Vendor reply or quotation publication; auto-accepted requests are
 * excluded from the response sample.
 */
final class GeoFactsBuilder
{
    public const ENVIRONMENT = 'TEST';

    private const POST_CONFIRMATION = ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED'];

    private const VENDOR_DECISIONS = ['AWAITING_PAYMENT', 'CONFIRMED', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE', 'DECLINED'];

    private const FULFILLMENT_MILESTONES = ['PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP'];

    /** @var array<string, array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}> */
    private array $addressGeo = [];

    /** @var array<string, array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}> */
    private array $vendorGeo = [];

    private ?string $versionId = null;

    private bool $boundaries = false;

    public function __construct(private readonly PsgcHierarchy $psgc) {}

    /** @return array{run_id: string, state: string, revision: int, counts: array<string, int>} */
    public function build(string $trigger = 'SCHEDULE', ?int $userId = null, ?CarbonImmutable $now = null): array
    {
        $now ??= CarbonImmutable::now();
        $through = $now->setTimezone('Asia/Manila')->toDateString();
        $this->prepare();
        $revision = (int) DB::table('analytics_geo_runs')->where('environment', self::ENVIRONMENT)->where('through_date', $through)->max('revision') + 1;
        $runId = (string) Str::uuid7();
        DB::table('analytics_geo_runs')->insert(['id' => $runId, 'environment' => self::ENVIRONMENT, 'through_date' => $through, 'revision' => $revision, 'state' => 'RUNNING',
            'trigger' => $trigger, 'psgc_version_id' => $this->versionId, 'requested_by_user_id' => $userId, 'started_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        try {
            $counts = DB::transaction(function () use ($runId, $through): array {
                DB::statement('SELECT pg_advisory_xact_lock(?)', [crc32('materyalph-geo-facts')]);
                DB::statement('DELETE FROM analytics_order_line_facts WHERE analytics_order_fact_id IN (SELECT id FROM analytics_order_facts WHERE environment = ?)', [self::ENVIRONMENT]);
                foreach (['analytics_order_facts', 'analytics_activity_facts', 'analytics_response_facts'] as $table) {
                    DB::table($table)->where('environment', self::ENVIRONMENT)->delete();
                }
                DB::table('analytics_presence_facts')->where('environment', self::ENVIRONMENT)->where('snapshot_on', $through)->delete();
                $counts = ['orders' => $this->orders($runId), 'activity' => $this->activity($runId), 'responses' => $this->responses($runId), 'presence' => $this->presence($runId, $through)];
                DB::table('analytics_geo_runs')->where('environment', self::ENVIRONMENT)->where('state', 'PUBLISHED')->update(['state' => 'SUPERSEDED', 'updated_at' => now()]);
                DB::table('analytics_geo_runs')->where('id', $runId)->update(['state' => 'PUBLISHED', 'published_at' => now(), 'counts' => json_encode($counts, JSON_THROW_ON_ERROR), 'updated_at' => now()]);

                return $counts;
            });
        } catch (Throwable $exception) {
            report($exception);
            DB::table('analytics_geo_runs')->where('id', $runId)->update(['state' => 'FAILED', 'error_code' => 'AGGREGATION_FAILED', 'updated_at' => now()]);

            return ['run_id' => $runId, 'state' => 'FAILED', 'revision' => $revision, 'counts' => []];
        }

        return ['run_id' => $runId, 'state' => 'PUBLISHED', 'revision' => $revision, 'counts' => $counts];
    }

    /**
     * Rebuilds only today's presence snapshot (active storefronts and registered Buyers by place) under the same lock as
     * the full run. Retained for manual presence recovery; recurring full runs refresh all fact families together.
     * Returns the rows written, or null before the first published run.
     */
    public function refreshPresence(?CarbonImmutable $now = null): ?int
    {
        $runId = DB::table('analytics_geo_runs')->where('environment', self::ENVIRONMENT)->where('state', 'PUBLISHED')->orderByDesc('through_date')->orderByDesc('revision')->value('id');
        if ($runId === null) {
            return null;
        }
        $through = ($now ?? CarbonImmutable::now())->setTimezone('Asia/Manila')->toDateString();
        $this->prepare();

        return DB::transaction(function () use ($runId, $through): int {
            DB::statement('SELECT pg_advisory_xact_lock(?)', [crc32('materyalph-geo-facts')]);
            DB::table('analytics_presence_facts')->where('environment', self::ENVIRONMENT)->where('snapshot_on', $through)->delete();

            return $this->presence((string) $runId, $through);
        });
    }

    private function prepare(): void
    {
        $this->psgc->forget();
        $this->addressGeo = [];
        $this->vendorGeo = [];
        $this->versionId = $this->psgc->version()?->id;
        $this->boundaries = $this->versionId !== null && DB::table('psgc_boundaries as b')->join('psgc_areas as a', 'a.id', '=', 'b.psgc_area_id')
            ->where('a.psgc_version_id', $this->versionId)->whereNotNull('b.geom')->exists();
    }

    public static function personKey(string $kind, string|int $id): string
    {
        return hash_hmac('sha256', 'GEO_'.$kind.'|'.$id, (string) config('app.key'));
    }

    private function orders(string $runId): int
    {
        $confirmed = DB::table('order_status_history')->where('state_family', 'ORDER')->where('to_state', 'CONFIRMED')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS confirmed_at');
        $count = 0;
        DB::table('orders as o')->leftJoinSub($confirmed, 'h', 'h.order_id', '=', 'o.id')
            ->where(fn ($q) => $q->whereNotNull('h.confirmed_at')->orWhereIn('o.order_state', self::POST_CONFIRMATION))
            ->select(['o.*', 'h.confirmed_at'])->orderBy('o.id')
            ->chunk(500, function ($orders) use ($runId, &$count): void {
                foreach ($orders as $order) {
                    $this->orderFact($runId, $order);
                    $count++;
                }
            });

        return $count;
    }

    private function orderFact(string $runId, object $order): void
    {
        [$basis, $geo] = $this->orderGeography($order);
        $gross = (int) $order->commercial_total_centavos;
        $cancelled = $order->order_state === 'CANCELLED';
        $refunded = 0;
        if (! $cancelled) {
            $refunded = (int) DB::table('refunds')->where('order_id', $order->id)->where('target_type', 'ORDER')->where('state', 'REFUNDED')->where('trigger', '<>', 'CANCELLATION')
                ->sum(DB::raw('COALESCE(principal_centavos, amount_centavos)'));
            $refunded += (int) DB::table('physical_reimbursements')->where('order_id', $order->id)->where('state', 'REIMBURSEMENT_CONFIRMED')->whereNotNull('dispute_decision_id')->sum('amount_centavos');
            $refunded = min($gross, $refunded);
        }
        $cancelledValue = $cancelled ? $gross : 0;
        $confirmedAt = CarbonImmutable::parse((string) ($order->confirmed_at ?? $order->accepted_at ?? $order->created_at));
        $factId = (string) Str::uuid7();
        DB::table('analytics_order_facts')->insert(['id' => $factId, 'environment' => self::ENVIRONMENT, 'source_key' => 'order:'.$order->id, 'analytics_geo_run_id' => $runId,
            'confirmed_on' => $confirmedAt->setTimezone('Asia/Manila')->toDateString(), 'buyer_key' => self::personKey('BUYER', (string) $order->buyer_profile_id), 'geo_basis' => $basis,
            'psgc_version_id' => $this->versionId, 'region_code' => $geo['region_code'], 'area_code' => $geo['area_code'], 'locality_code' => $geo['locality_code'], 'geo_resolution' => $geo['resolution'],
            'procurement_type' => (string) $order->procurement_type, 'fulfillment_method' => (string) $order->fulfillment_method, 'payment_method' => (string) $order->payment_method,
            'order_state' => (string) $order->order_state, 'gross_value_centavos' => $gross, 'cancelled_value_centavos' => $cancelledValue, 'refunded_value_centavos' => $refunded,
            'net_value_centavos' => $gross - $cancelledValue - $refunded, 'due_on' => $order->expected_fulfillment_date,
            'completed_on' => $order->order_state === 'COMPLETED' && $order->closed_at !== null ? CarbonImmutable::parse((string) $order->closed_at)->setTimezone('Asia/Manila')->toDateString() : null,
            'cancelled' => $cancelled, 'disputed' => DB::table('dispute_cases')->where('order_id', $order->id)->exists(), 'created_at' => now()]);
        $lines = DB::table('order_lines as l')->leftJoin('listing_variants as lv', 'lv.id', '=', 'l.listing_variant_id')
            ->leftJoin('vendor_listings as v', 'v.id', '=', DB::raw('COALESCE(l.vendor_listing_id, lv.vendor_listing_id)'))
            ->leftJoin('products as p', 'p.id', '=', 'v.product_id')->leftJoin('materials as m', 'm.id', '=', 'p.material_id')
            ->where('l.order_id', $order->id)->get(['l.unit_id', 'l.quantity', 'l.payable_centavos', 'v.material_category_id', 'p.material_id', 'm.canonical_unit_id', 'm.material_category_id as material_category']);
        foreach ($lines as $line) {
            $normalized = null;
            if ($line->material_id !== null && $line->canonical_unit_id !== null) {
                $multiplier = $line->unit_id === $line->canonical_unit_id ? '1' : DB::table('unit_conversions')->where('material_id', $line->material_id)
                    ->where('from_unit_id', $line->unit_id)->where('to_unit_id', $line->canonical_unit_id)->orderByDesc('version')->value('multiplier');
                $normalized = $multiplier === null ? null : bcmul((string) $line->quantity, (string) $multiplier, 4);
            }
            DB::table('analytics_order_line_facts')->insert(['id' => (string) Str::uuid7(), 'analytics_order_fact_id' => $factId, 'material_category_id' => $line->material_category_id ?? $line->material_category,
                'material_id' => $line->material_id, 'unit_id' => $line->unit_id, 'quantity' => $line->quantity, 'normalized_quantity' => $normalized, 'value_centavos' => (int) $line->payable_centavos]);
        }
    }

    /** @return array{0: string, 1: array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}} */
    private function orderGeography(object $order): array
    {
        if ($order->procurement_type === 'PROJECT_BASED' && $order->work_package_id !== null) {
            $site = DB::table('work_packages as w')->join('project_sites as s', 's.project_id', '=', 'w.project_id')->where('w.id', $order->work_package_id)
                ->orderByDesc('s.active')->orderBy('s.created_at')->value('s.address_id');
            if ($site !== null) {
                return ['PROJECT_SITE', $this->address((string) $site)];
            }
        }
        if ($order->fulfillment_method === 'DELIVERY') {
            $destination = json_decode((string) ($order->destination ?? '{}'), true) ?: [];
            $address = $destination['intended']['address_id'] ?? null;

            return ['DELIVERY_SITE', is_string($address) ? $this->address($address) : self::unresolved()];
        }

        return ['PICKUP_STORE', $this->vendor((string) $order->vendor_organization_id)];
    }

    /** @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string} */
    private function address(string $addressId): array
    {
        if (isset($this->addressGeo[$addressId])) {
            return $this->addressGeo[$addressId];
        }
        $row = DB::table('addresses')->where('id', $addressId)->first(['id', 'city_code', 'province_code', 'region_code', 'psgc_code', 'city_municipality', 'province', 'barangay']);
        $geo = $row === null ? self::unresolved() : $this->psgc->place($row->city_code, $row->province_code, $row->region_code, $row->psgc_code);
        if ($geo['resolution'] !== 'RESOLVED' && $row !== null) {
            $geo = $this->byNames($row) ?? $geo;
        }
        if ($geo['resolution'] !== 'RESOLVED' && $row !== null && $this->boundaries) {
            $geo = $this->pointInBoundary('SELECT location::geometry FROM addresses WHERE id = ?', $addressId) ?? $geo;
        }

        return $this->addressGeo[$addressId] = $geo;
    }

    /** @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string} */
    private function vendor(string $organizationId): array
    {
        if (isset($this->vendorGeo[$organizationId])) {
            return $this->vendorGeo[$organizationId];
        }
        $row = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')->where('a.vendor_organization_id', $organizationId)
            ->first(['v.id', 'v.city_code', 'v.province_code', 'v.psgc_code', 'v.city_municipality', 'v.province', 'v.barangay']);
        $geo = $row === null ? self::unresolved() : $this->psgc->place($row->city_code, $row->province_code, null, $row->psgc_code);
        if ($geo['resolution'] !== 'RESOLVED' && $row !== null) {
            $geo = $this->byNames($row) ?? $geo;
        }
        if ($geo['resolution'] !== 'RESOLVED' && $row !== null && $this->boundaries) {
            $geo = $this->pointInBoundary('SELECT location::geometry FROM vendor_address_versions WHERE id = ?', (string) $row->id) ?? $geo;
        }

        return $this->vendorGeo[$organizationId] = $geo;
    }

    /**
     * An address stored with place names but no PSGC codes (for example a pin picked on the map) is placed through the
     * same unique-name match used at onboarding; ambiguous or unmatched names stay unresolved rather than guessed.
     *
     * @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}|null
     */
    private function byNames(object $row): ?array
    {
        $named = (new PsgcResolver)->resolveNames(['city_municipality' => $row->city_municipality, 'province' => $row->province, 'barangay' => $row->barangay]);
        if (($named['psgc_resolution'] ?? 'UNRESOLVED') === 'UNRESOLVED') {
            return null;
        }
        $geo = $this->psgc->place($named['city_code'] ?? null, $named['province_code'] ?? null, $named['region_code'] ?? null);

        return $geo['resolution'] === 'UNRESOLVED' ? null : $geo;
    }

    /** @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}|null */
    private function pointInBoundary(string $pointSql, string $id): ?array
    {
        $code = DB::selectOne("SELECT a.code FROM psgc_boundaries b JOIN psgc_areas a ON a.id = b.psgc_area_id
            WHERE a.psgc_version_id = ? AND a.level IN ('CITY','MUNICIPALITY') AND b.geom IS NOT NULL AND ST_Covers(b.geom, ($pointSql)) LIMIT 1", [$this->versionId, $id])?->code;

        return $code === null ? null : $this->psgc->place((string) $code, null, null);
    }

    private function activity(string $runId): int
    {
        $count = 0;
        $buyers = DB::table('buyer_profiles')->pluck('id', 'user_id');
        $insert = function (string $key, string $audience, int $userId, string $kind, string $at, array $geo) use ($runId, &$count): void {
            DB::table('analytics_activity_facts')->insertOrIgnore(['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'source_key' => $key, 'analytics_geo_run_id' => $runId,
                'activity_on' => CarbonImmutable::parse($at)->setTimezone('Asia/Manila')->toDateString(), 'audience' => $audience, 'actor_key' => self::personKey('USER', $userId),
                'action_kind' => $kind, 'psgc_version_id' => $this->versionId, 'region_code' => $geo['region_code'], 'area_code' => $geo['area_code'],
                'locality_code' => $geo['locality_code'], 'geo_resolution' => $geo['resolution'], 'created_at' => now()]);
            $count++;
        };
        // Human order actions recorded by the transition service; SYSTEM rows (auto-accept, timers) never count.
        $history = DB::table('order_status_history as h')->join('orders as o', 'o.id', '=', 'h.order_id')->whereNotNull('h.actor_user_id')->whereIn('h.source', ['BUYER', 'VENDOR'])
            ->whereIn('h.state_family', ['ORDER', 'FULFILLMENT'])->orderBy('h.id')->get(['h.id', 'h.source', 'h.to_state', 'h.state_family', 'h.actor_user_id', 'h.created_at', 'o.id as order_id',
                'o.procurement_type', 'o.work_package_id', 'o.fulfillment_method', 'o.destination', 'o.vendor_organization_id']);
        foreach ($history as $row) {
            if ($row->source === 'BUYER') {
                $kind = match ($row->to_state) {
                    'AWAITING_VENDOR_CONFIRMATION' => 'ORDER_SUBMITTED',
                    'AWAITING_PAYMENT', 'CONFIRMED' => 'ORDER_TERMS_ACCEPTED',
                    'COMPLETED' => 'RECEIPT_CONFIRMED',
                    default => null,
                };
                if ($kind !== null) {
                    $insert('hist:'.$row->id, 'BUYER', (int) $row->actor_user_id, $kind, (string) $row->created_at, $this->orderGeography($row)[1]);
                }

                continue;
            }
            $kind = $row->to_state === 'CANCELLED' ? 'ORDER_CANCELLED' : (in_array($row->to_state, self::VENDOR_DECISIONS, true) && $row->state_family === 'ORDER' ? 'ORDER_DECIDED'
                : (in_array($row->to_state, self::FULFILLMENT_MILESTONES, true) ? 'FULFILLMENT_RECORDED' : null));
            if ($kind !== null) {
                $insert('hist:'.$row->id, 'VENDOR', (int) $row->actor_user_id, $kind, (string) $row->created_at, $this->vendor((string) $row->vendor_organization_id));
            }
        }
        foreach (DB::table('quotation_events as e')->join('quotations as q', 'q.id', '=', 'e.quotation_id')->whereIn('e.event_type', ['PUBLISHED', 'ACCEPTED', 'COUNTERED'])
            ->orderBy('e.id')->get(['e.id', 'e.event_type', 'e.actor_user_id', 'e.created_at', 'q.vendor_organization_id', 'q.buyer_profile_id']) as $event) {
            if ($event->event_type === 'PUBLISHED') {
                $insert('qe:'.$event->id, 'VENDOR', (int) $event->actor_user_id, 'QUOTATION_PUBLISHED', (string) $event->created_at, $this->vendor((string) $event->vendor_organization_id));
            } elseif (isset($buyers[$event->actor_user_id])) {
                $insert('qe:'.$event->id, 'BUYER', (int) $event->actor_user_id, $event->event_type === 'ACCEPTED' ? 'QUOTATION_ACCEPTED' : 'QUOTATION_COUNTERED', (string) $event->created_at,
                    $this->buyerPrimary((string) $event->buyer_profile_id));
            }
        }
        foreach (DB::table('fulfillment_issues as i')->join('orders as o', 'o.id', '=', 'i.order_id')->orderBy('i.id')->get(['i.id', 'i.reported_by_user_id', 'i.created_at', 'o.procurement_type',
            'o.work_package_id', 'o.fulfillment_method', 'o.destination', 'o.vendor_organization_id']) as $issue) {
            if ($issue->reported_by_user_id !== null && isset($buyers[$issue->reported_by_user_id])) {
                $insert('issue:'.$issue->id, 'BUYER', (int) $issue->reported_by_user_id, 'FULFILLMENT_REPORTED', (string) $issue->created_at, $this->orderGeography($issue)[1]);
            }
        }

        return $count;
    }

    private function responses(string $runId): int
    {
        $count = 0;
        $insert = function (string $key, string $kind, string $buyerProfileId, string $vendorId, CarbonImmutable $available, ?CarbonImmutable $responded) use ($runId, &$count): void {
            $geo = $this->vendor($vendorId);
            DB::table('analytics_response_facts')->insertOrIgnore(['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'source_key' => $key, 'analytics_geo_run_id' => $runId,
                'available_on' => $available->setTimezone('Asia/Manila')->toDateString(), 'request_kind' => $kind, 'buyer_key' => self::personKey('BUYER', $buyerProfileId),
                'psgc_version_id' => $this->versionId, 'region_code' => $geo['region_code'], 'area_code' => $geo['area_code'], 'locality_code' => $geo['locality_code'], 'geo_resolution' => $geo['resolution'],
                'available_at' => $available, 'responded_at' => $responded, 'response_seconds' => $responded === null ? null : max(0, $responded->getTimestamp() - $available->getTimestamp()), 'created_at' => now()]);
            $count++;
        };
        // Order requests awaiting a Vendor decision; auto-accepted requests are excluded from the human sample.
        $first = DB::table('order_status_history')->where('state_family', 'ORDER')->where('source', 'VENDOR')->whereNotNull('actor_user_id')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS responded_at');
        foreach (DB::table('orders as o')->leftJoinSub($first, 'r', 'r.order_id', '=', 'o.id')->whereNotNull('o.submitted_at')->whereNull('o.quotation_version_id')
            ->where(fn ($q) => $q->whereNull('o.confirmation_source')->orWhere('o.confirmation_source', '<>', 'AUTO_ACCEPT'))
            ->whereExists(fn ($q) => $q->selectRaw('1')->from('order_status_history as s')->whereColumn('s.order_id', 'o.id')->where('s.to_state', 'AWAITING_VENDOR_CONFIRMATION'))
            ->orderBy('o.id')->get(['o.id', 'o.buyer_profile_id', 'o.vendor_organization_id', 'o.submitted_at', 'r.responded_at']) as $order) {
            $insert('order:'.$order->id, 'ORDER_REQUEST', (string) $order->buyer_profile_id, (string) $order->vendor_organization_id, CarbonImmutable::parse((string) $order->submitted_at),
                $order->responded_at === null ? null : CarbonImmutable::parse((string) $order->responded_at));
        }
        // Sales conversations: episodes open on a Buyer's human message, a counter-offer or a Work Package request and
        // close on the first human Vendor message or quotation publication.
        foreach (DB::table('conversations')->where('purpose', 'SALES')->orderBy('id')->get(['id', 'buyer_profile_id', 'vendor_organization_id', 'context_type', 'created_at']) as $conversation) {
            $timeline = [];
            foreach (DB::table('messages as m')->join('users as u', 'u.id', '=', 'm.sender_user_id')->where('m.conversation_id', $conversation->id)->where('m.kind', '<>', 'SYSTEM')
                ->get(['m.sent_at', 'u.account_type']) as $message) {
                $timeline[] = [CarbonImmutable::parse((string) $message->sent_at), $message->account_type === 'BUYER' ? 'OPEN:INQUIRY' : ($message->account_type === 'VENDOR' ? 'CLOSE' : 'IGNORE')];
            }
            foreach (DB::table('quotation_events as e')->join('quotations as q', 'q.id', '=', 'e.quotation_id')->where('q.conversation_id', $conversation->id)->whereIn('e.event_type', ['PUBLISHED', 'COUNTERED'])
                ->get(['e.event_type', 'e.created_at']) as $event) {
                $timeline[] = [CarbonImmutable::parse((string) $event->created_at), $event->event_type === 'PUBLISHED' ? 'CLOSE' : 'OPEN:COUNTER_OFFER'];
            }
            usort($timeline, static fn (array $a, array $b): int => $a[0] <=> $b[0]);
            $open = $conversation->context_type === 'PROJECT_BASED' ? ['PACKAGE_REQUEST', CarbonImmutable::parse((string) $conversation->created_at)] : null;
            $episode = 0;
            foreach ($timeline as [$at, $signal]) {
                if (str_starts_with($signal, 'OPEN:') && $open === null) {
                    $open = [substr($signal, 5), $at];
                } elseif ($signal === 'CLOSE' && $open !== null) {
                    $insert('conv:'.$conversation->id.':'.$episode++, $open[0], (string) $conversation->buyer_profile_id, (string) $conversation->vendor_organization_id, $open[1], $at);
                    $open = null;
                }
            }
            if ($open !== null) {
                $insert('conv:'.$conversation->id.':'.$episode, $open[0], (string) $conversation->buyer_profile_id, (string) $conversation->vendor_organization_id, $open[1], null);
            }
        }

        return $count;
    }

    private function presence(string $runId, string $through): int
    {
        $count = 0;
        foreach (DB::table('vendor_organizations')->where('account_status', 'ACTIVE')->where('store_activation_status', 'ACTIVE')->orderBy('id')->pluck('id') as $organizationId) {
            $this->presenceRow($runId, $through, 'VENDOR', self::personKey('VENDOR', (string) $organizationId), $this->vendor((string) $organizationId));
            $count++;
        }
        $primary = DB::table('buyer_locations')->where('is_primary', true)->whereNull('archived_at')->select(['buyer_profile_id', 'address_id']);
        foreach (DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->leftJoinSub($primary, 'l', 'l.buyer_profile_id', '=', 'b.id')
            ->where('u.account_status', 'ACTIVE')->orderBy('b.id')->get(['b.id', 'l.address_id']) as $buyer) {
            $this->presenceRow($runId, $through, 'BUYER', self::personKey('BUYER', (string) $buyer->id), $buyer->address_id === null ? self::unresolved() : $this->address((string) $buyer->address_id));
            $count++;
        }

        return $count;
    }

    /** @param array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string} $geo */
    private function presenceRow(string $runId, string $through, string $audience, string $key, array $geo): void
    {
        DB::table('analytics_presence_facts')->insertOrIgnore(['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'analytics_geo_run_id' => $runId, 'snapshot_on' => $through,
            'audience' => $audience, 'subject_key' => $key, 'psgc_version_id' => $this->versionId, 'region_code' => $geo['region_code'], 'area_code' => $geo['area_code'],
            'locality_code' => $geo['locality_code'], 'geo_resolution' => $geo['resolution'], 'created_at' => now()]);
    }

    /** @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string} */
    private function buyerPrimary(string $buyerProfileId): array
    {
        $address = DB::table('buyer_locations')->where('buyer_profile_id', $buyerProfileId)->where('is_primary', true)->whereNull('archived_at')->value('address_id');

        return $address === null ? self::unresolved() : $this->address((string) $address);
    }

    /** @return array{region_code: null, area_code: null, locality_code: null, resolution: string} */
    private static function unresolved(): array
    {
        return ['region_code' => null, 'area_code' => null, 'locality_code' => null, 'resolution' => 'UNRESOLVED'];
    }
}
