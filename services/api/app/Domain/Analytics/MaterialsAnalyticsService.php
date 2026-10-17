<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Procurement\ScopedOfferQuery;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * The one MAT-01–MAT-07 calculation service shared by Buyer, Vendor and Admin. It filters the selected published runs
 * by exact comparable group, scope (recorded store point within the inclusive radius, or recorded PSGC codes), dataset
 * and exact dates; deduplicates each Vendor per group and date (latest published ordinary-price effective time, then
 * ascending variant id); and takes the equal-Vendor arithmetic mean at NUMERIC precision (8 dp). A Vendor request
 * removes its own organization before any averaging or counting. Results are internal: they include participant sets
 * that only the audience serializers decide whether to expose (they never expose identities to a Vendor).
 *
 * change_percent = ((end_average − start_average) / start_average) × 100 on unrounded means, displayed half-up at 2 dp.
 */
final class MaterialsAnalyticsService
{
    public const PER_PAGE = 20;

    public const MAX_PER_PAGE = 50;

    public const CURRENT_TTL_SECONDS = 60;

    public const HISTORY_TTL_SECONDS = 86400;

    public function __construct(private readonly ScopedOfferQuery $offers) {}

    /**
     * Candidate comparable groups for the list, filtered and paginated by offset cursor.
     *
     * @return array{groups: list<object>, next_cursor: ?string, total: int}
     */
    public function groups(AnalyticsRequest $request, ?string $cursor, int $perPage): array
    {
        $ids = Cache::remember($request->cacheKey('candidates').':'.EligibleOfferQuery::generation(), self::CURRENT_TTL_SECONDS, fn (): array => $this->candidateIds($request));
        if ($ids === []) {
            return ['groups' => [], 'next_cursor' => null, 'total' => 0];
        }
        $query = $this->groupMetadata()->whereIn('cg.id', $ids);
        if (isset($request->filters['category_id'])) {
            $query->where('m.material_category_id', $request->filters['category_id']);
        }
        $term = trim((string) ($request->filters['q'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $term).'%';
            $query->where(fn (Builder $q) => $q->where('cg.display_name', 'ilike', $like)->orWhere('m.name', 'ilike', $like)->orWhere('gv.brand', 'ilike', $like));
        }
        $total = (clone $query)->count();
        $offset = self::decodeCursor($cursor);
        $groups = $query->orderBy('mc.sort_order')->orderBy('mc.name')->orderBy('m.name')->orderBy('cg.display_name')->orderBy('cg.id')->offset($offset)->limit($perPage)->get()->all();

        return ['groups' => $groups, 'next_cursor' => $offset + $perPage < $total ? base64_encode((string) ($offset + $perPage)) : null, 'total' => $total];
    }

    public function group(string $groupId): object
    {
        $group = $this->groupMetadata()->where('cg.id', $groupId)->first();
        if ($group === null) {
            throw new AuthenticationException('MATERIAL_GROUP_NOT_FOUND', 'This comparable material is unavailable.', 404);
        }

        return $group;
    }

    /** @return list<object> Other active comparable variants of the same canonical material (the variant selector). */
    public function siblings(object $group): array
    {
        return $this->groupMetadata()->where('cg.material_id', $group->material_id)->orderBy('cg.display_name')->orderBy('cg.id')->limit(50)->get()->all();
    }

    /**
     * Daily points for the given groups and dates: date => group => {vendors, average (8 dp), vendor_ids}. A date with no
     * published run is absent from 'published'; a published date with no in-scope observation has no group entry.
     *
     * @param  list<string>  $groupIds
     * @param  list<string>  $dates
     * @return array{published: array<string, true>, points: array<string, array<string, array{vendors: int, average: string, vendor_ids: list<string>}>>, snapshot: ?array<string, mixed>}
     */
    public function points(AnalyticsRequest $request, array $groupIds, array $dates): array
    {
        if ($groupIds === [] || $dates === []) {
            return ['published' => [], 'points' => [], 'snapshot' => null];
        }
        sort($groupIds);
        $key = $request->cacheKey('points').':'.hash('sha256', implode(',', $groupIds).'|'.implode(',', $dates));

        return Cache::remember($key, self::HISTORY_TTL_SECONDS, function () use ($request, $groupIds, $dates): array {
            $runs = DB::table('analytics_published_runs as p')->join('analytics_refresh_runs as r', 'r.id', '=', 'p.analytics_refresh_run_id')->where('p.kind', AnalyticsDataset::KIND)
                ->where('p.environment', $request->dataset['environment'])->where('p.dataset_id', $request->dataset['dataset_id'])->whereIn('p.snapshot_date', $dates)
                ->get(['p.snapshot_date', 'r.id', 'r.revision', 'r.observed_at'])->keyBy(static fn (object $run): string => (string) $run->snapshot_date);
            $published = array_fill_keys($runs->keys()->all(), true);
            $points = [];
            if ($runs->isNotEmpty()) {
                $deduped = DB::table('price_observations as po')->join('analytics_published_runs as p', 'p.analytics_refresh_run_id', '=', 'po.analytics_refresh_run_id')
                    ->whereIn('po.analytics_refresh_run_id', $runs->pluck('id'))->whereIn('po.comparable_group_id', $groupIds)
                    ->selectRaw('DISTINCT ON (po.analytics_refresh_run_id, po.comparable_group_id, po.vendor_organization_id) p.snapshot_date, po.comparable_group_id, po.vendor_organization_id, po.normalized_php_price')
                    ->orderBy('po.analytics_refresh_run_id')->orderBy('po.comparable_group_id')->orderBy('po.vendor_organization_id')->orderByDesc('po.price_effective_at')->orderBy('po.listing_variant_id');
                $this->constrainObservationScope($deduped, $request);
                $rows = DB::query()->fromSub($deduped, 'd')->groupBy('d.snapshot_date', 'd.comparable_group_id')
                    ->selectRaw('d.snapshot_date, d.comparable_group_id, count(*) AS vendors, round(sum(d.normalized_php_price) / count(*), 8) AS average, array_to_json(array_agg(d.vendor_organization_id::text ORDER BY d.vendor_organization_id)) AS vendor_ids')
                    ->get();
                foreach ($rows as $row) {
                    $points[(string) $row->snapshot_date][(string) $row->comparable_group_id] = ['vendors' => (int) $row->vendors, 'average' => (string) $row->average, 'vendor_ids' => json_decode((string) $row->vendor_ids, true) ?: []];
                }
            }
            $latest = $runs->sortKeys()->last();

            return ['published' => $published, 'points' => $points,
                'snapshot' => $latest === null ? null : ['date' => (string) $latest->snapshot_date, 'observed_at' => CarbonImmutable::parse((string) $latest->observed_at)->toIso8601String(), 'revision' => (int) $latest->revision]];
        });
    }

    /**
     * Current MAT-02 counts per group within the scope (a Vendor's competitors only), cached for 60 seconds and
     * invalidated by eligibility changes.
     *
     * @param  list<string>  $groupIds
     * @return array{as_of: string, groups: array<string, array{vendors: int, listings: int}>, not_yet_comparable: int}
     */
    public function current(AnalyticsRequest $request, array $groupIds): array
    {
        sort($groupIds);
        $key = $request->cacheKey('current').':'.EligibleOfferQuery::generation().':'.hash('sha256', implode(',', $groupIds));

        return Cache::remember($key, self::CURRENT_TTL_SECONDS, function () use ($request, $groupIds): array {
            $counts = [];
            if ($groupIds !== []) {
                $query = ComparableMappingService::joinComparable($this->currentScope($request))->whereIn('cg.id', $groupIds)->where('gv.review_state', 'APPROVED')
                    ->whereRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' IS NOT NULL')
                    ->groupBy('cg.id')->selectRaw('cg.id AS group_id, count(DISTINCT o.id) AS vendors, count(DISTINCT l.id) AS listings');
                foreach ($query->get() as $row) {
                    $counts[(string) $row->group_id] = ['vendors' => (int) $row->vendors, 'listings' => (int) $row->listings];
                }
            }
            $unmapped = ComparableMappingService::joinComparable($this->currentScope($request))->whereNull('ca.id')->distinct()->count('l.id');

            return ['as_of' => now()->toIso8601String(), 'groups' => $counts, 'not_yet_comparable' => (int) $unmapped];
        });
    }

    /**
     * The requesting Vendor's own current comparable price per group (one per group by the MAT-03 rule). This is a
     * separate authorized value and never enters a competitor aggregate.
     *
     * @param  list<string>  $groupIds
     * @return array<string, array<string, mixed>>
     */
    public function ownOffers(string $organizationId, array $groupIds): array
    {
        if ($groupIds === []) {
            return [];
        }
        $rows = ComparableMappingService::joinComparable(app(EligibleOfferQuery::class)->variants([$organizationId]))->whereIn('cg.id', $groupIds)->where('gv.review_state', 'APPROVED')
            ->whereRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' IS NOT NULL')
            ->selectRaw('DISTINCT ON (cg.id) cg.id AS group_id, l.id AS listing_id, v.id AS variant_id, l.display_name, v.label AS variant_label, pv.amount_centavos, pv.tax_category, pv.effective_at, '.ComparableMappingService::NORMALIZED_PRICE_SQL.' AS normalized')
            ->orderBy('cg.id')->orderByDesc('pv.effective_at')->orderBy('v.id')->get();
        $own = [];
        foreach ($rows as $row) {
            $own[(string) $row->group_id] = ['listing_id' => (string) $row->listing_id, 'variant_id' => (string) $row->variant_id, 'display_name' => (string) $row->display_name, 'variant_label' => $row->variant_label,
                'price_centavos' => (int) $row->amount_centavos, 'normalized_php' => (string) $row->normalized, 'tax_category' => (string) $row->tax_category,
                'price_as_of' => CarbonImmutable::parse((string) $row->effective_at)->toIso8601String()];
        }

        return $own;
    }

    /**
     * Buyer current public offers for one group within the Buyer's radius, cheapest per canonical unit first.
     *
     * @return array{items: list<array<string, mixed>>, next_cursor: ?string, total: int, as_of: string}
     */
    public function buyerOffers(AnalyticsRequest $request, string $groupId, ?string $cursor, int $perPage): array
    {
        [$distanceSql, $distanceBindings] = ScopedOfferQuery::distanceSql($request->scope);
        $query = ComparableMappingService::joinComparable($this->offers->within($request->scope))->where('cg.id', $groupId)->where('gv.review_state', 'APPROVED')
            ->whereRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' IS NOT NULL');
        $total = (clone $query)->count();
        $offset = self::decodeCursor($cursor);
        $rows = $query->selectRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' AS normalized')->selectRaw($distanceSql.' AS distance_meters', $distanceBindings)
            ->addSelect(['o.id as vendor_id', 'p.public_store_name', 'l.id as listing_id', 'l.display_name', 'v.id as variant_id', 'v.label as variant_label', 'pv.amount_centavos', 'pv.tax_category', 'pv.effective_at',
                'i.quantity_on_hand', 'i.hard_reserved_quantity', 'i.reorder_level'])
            ->orderBy('normalized')->orderBy('distance_meters')->orderBy('v.id')->offset($offset)->limit($perPage)->get();

        return ['items' => $rows->map(static fn (object $row): array => [
            'vendor_id' => (string) $row->vendor_id, 'store_name' => (string) $row->public_store_name, 'listing_id' => (string) $row->listing_id, 'variant_id' => (string) $row->variant_id,
            'display_name' => (string) $row->display_name, 'variant_label' => $row->variant_label, 'price_centavos' => (int) $row->amount_centavos,
            'normalized_php' => self::display((string) $row->normalized), 'tax_category' => (string) $row->tax_category, 'tax_label' => ListingPublicFacts::vatLabel((string) $row->tax_category),
            'availability' => StockAvailability::label(StockAvailability::availableToSell((string) $row->quantity_on_hand, (string) $row->hard_reserved_quantity), $row->reorder_level === null ? null : (string) $row->reorder_level),
            'distance_meters' => (int) round((float) $row->distance_meters), 'price_as_of' => CarbonImmutable::parse((string) $row->effective_at)->toIso8601String(),
        ])->all(), 'next_cursor' => $offset + $perPage < $total ? base64_encode((string) ($offset + $perPage)) : null, 'total' => $total, 'as_of' => now()->toIso8601String()];
    }

    /**
     * Point status for one audience. Buyer/Admin: OK (≥2), LIMITED_DATA (exactly 1), NO_LOCAL_OBSERVATIONS, MISSING_DAY.
     * Vendor: OK (≥3 competitors), SUPPRESSED (fewer, including none — the count is never revealed), MISSING_DAY.
     *
     * @param  array{vendors: int, average: string, vendor_ids: list<string>}|null  $point
     */
    public static function pointStatus(string $audience, bool $published, ?array $point): string
    {
        if (! $published) {
            return 'MISSING_DAY';
        }
        $vendors = $point['vendors'] ?? 0;
        if ($audience === 'VENDOR') {
            return $vendors >= 3 ? 'OK' : 'SUPPRESSED';
        }

        return match (true) {
            $vendors >= 2 => 'OK',
            $vendors === 1 => 'LIMITED_DATA',
            default => 'NO_LOCAL_OBSERVATIONS',
        };
    }

    /**
     * MAT-04 trend between the exact endpoints, or a null percentage with its reason.
     *
     * @param  array{vendors: int, average: string, vendor_ids: list<string>}|null  $start
     * @param  array{vendors: int, average: string, vendor_ids: list<string>}|null  $end
     * @return array{change_percent: ?string, direction: ?string, reason: ?string, composition_changed: ?bool}
     */
    public static function trend(?array $start, ?array $end, int $minimumVendors, bool $startPublished = true, bool $endPublished = true): array
    {
        $reasonCode = $minimumVendors >= 3 ? 'INSUFFICIENT_COMPETITOR_DATA' : 'INSUFFICIENT_LOCAL_DATA';
        if (! $startPublished || ! $endPublished) {
            return ['change_percent' => null, 'direction' => null, 'reason' => 'MISSING_ENDPOINT_SNAPSHOT', 'composition_changed' => null];
        }
        if ($start === null || $end === null || $start['vendors'] < $minimumVendors || $end['vendors'] < $minimumVendors) {
            return ['change_percent' => null, 'direction' => null, 'reason' => $reasonCode, 'composition_changed' => null];
        }
        if (bccomp($start['average'], '0', 8) <= 0) {
            return ['change_percent' => null, 'direction' => null, 'reason' => 'ZERO_BASELINE', 'composition_changed' => null];
        }
        $raw = bcmul(bcdiv(bcsub($end['average'], $start['average'], 12), $start['average'], 12), '100', 12);
        $display = ComparableMappingService::roundHalfUp($raw, 2);
        if (bccomp($display, '0', 2) === 0) {
            $display = '0.00';
        }
        $startIds = $start['vendor_ids'];
        $endIds = $end['vendor_ids'];
        sort($startIds);
        sort($endIds);

        return ['change_percent' => $display, 'direction' => match (bccomp($display, '0', 2)) {
            1 => 'INCREASING', -1 => 'DECREASING', default => 'NO_MATERIAL_CHANGE'
        },
            'reason' => null, 'composition_changed' => $startIds !== $endIds];
    }

    /** Half-up two-decimal PHP display of an 8-dp mean. */
    public static function display(string $value): string
    {
        return ComparableMappingService::roundHalfUp($value, 2);
    }

    public static function decodeCursor(?string $cursor): int
    {
        if ($cursor === null || $cursor === '') {
            return 0;
        }
        $decoded = base64_decode($cursor, true);
        if ($decoded === false || ! ctype_digit($decoded) || (int) $decoded > 100000) {
            throw new AuthenticationException('CURSOR_INVALID', 'Reload the list to continue.', 422);
        }

        return (int) $decoded;
    }

    /** @return list<string> groups with in-scope history inside the window or a current in-scope offer */
    private function candidateIds(AnalyticsRequest $request): array
    {
        $ids = [];
        if ($request->window->start !== null) {
            $history = DB::table('price_observations as po')->join('analytics_published_runs as p', 'p.analytics_refresh_run_id', '=', 'po.analytics_refresh_run_id')
                ->where('p.kind', AnalyticsDataset::KIND)->where('p.environment', $request->dataset['environment'])->where('p.dataset_id', $request->dataset['dataset_id'])
                ->whereBetween('p.snapshot_date', [$request->window->start, $request->window->end])->whereNotNull('po.comparable_group_id');
            // A Vendor list keeps its own groups; competitor-only groups are decided later from suppressed endpoints.
            $this->constrainObservationScope($history, $request, false);
            $ids = $history->distinct()->pluck('po.comparable_group_id')->map(static fn (mixed $id): string => (string) $id)->all();
        }
        $current = ComparableMappingService::joinComparable($request->audience === 'VENDOR' ? $this->offers->within($request->scope) : $this->currentScope($request))
            ->whereNotNull('cg.id')->where('gv.review_state', 'APPROVED')->distinct()->pluck('cg.id')->map(static fn (mixed $id): string => (string) $id)->all();

        return array_values(array_unique([...$ids, ...$current]));
    }

    private function groupMetadata(): Builder
    {
        return DB::table('material_comparable_groups as cg')->join('material_comparable_group_versions as gv', 'gv.id', '=', 'cg.current_version_id')
            ->join('materials as m', 'm.id', '=', 'cg.material_id')->join('material_categories as mc', 'mc.id', '=', 'm.material_category_id')->join('units as u', 'u.id', '=', 'gv.canonical_unit_id')
            ->where('cg.status', 'ACTIVE')->where('gv.review_state', 'APPROVED')
            ->select(['cg.id', 'cg.code', 'cg.display_name', 'cg.material_id', 'm.name as material_name', 'm.description as material_description', 'mc.id as category_id', 'mc.code as category_code',
                'mc.name as category_name', 'gv.brand', 'gv.model', 'gv.controlled_specification', 'u.code as unit_code', 'u.name as unit_name']);
    }

    /** Current eligible offers in the request's scope; a Vendor scope excludes its own organization. */
    private function currentScope(AnalyticsRequest $request): Builder
    {
        if ($request->scope->kind === 'PSGC') {
            $query = $this->offers->anywhere();
            if ($request->scope->psgcCode !== null) {
                $codes = self::psgcSubtree($request->scope->psgcCode, (string) $request->scope->psgcVersionId);
                $query->where(fn (Builder $q) => $q->whereIn('av.city_code', $codes)->orWhereIn('av.province_code', $codes));
            }

            return $query;
        }
        $query = $this->offers->within($request->scope);
        if ($request->audience === 'VENDOR') {
            $query->where('o.id', '<>', $request->ownOrganizationId);
        }

        return $query;
    }

    private function constrainObservationScope(Builder $observations, AnalyticsRequest $request, bool $excludeOwn = true): void
    {
        if ($request->scope->kind === 'PSGC') {
            if ($request->scope->psgcCode !== null) {
                $code = $request->scope->psgcCode;
                $observations->where(fn (Builder $q) => $q->where('po.psgc_region_code', $code)->orWhere('po.psgc_province_code', $code)->orWhere('po.psgc_city_code', $code));
            }
        } else {
            $observations->whereRaw('ST_DWithin(po.store_location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)', [$request->scope->longitude, $request->scope->latitude, $request->scope->membershipMeters()]);
        }
        if ($excludeOwn && $request->audience === 'VENDOR') {
            $observations->where('po.vendor_organization_id', '<>', $request->ownOrganizationId);
        }
    }

    /** @return list<string> the area code and every descendant code in that PSGC version */
    private static function psgcSubtree(string $code, string $versionId): array
    {
        return array_map(static fn (object $row): string => (string) $row->code, DB::select(
            'WITH RECURSIVE tree AS (SELECT id, code FROM psgc_areas WHERE psgc_version_id = ? AND code = ? UNION ALL SELECT a.id, a.code FROM psgc_areas a JOIN tree t ON a.parent_id = t.id) SELECT code FROM tree',
            [$versionId, $code]));
    }
}
