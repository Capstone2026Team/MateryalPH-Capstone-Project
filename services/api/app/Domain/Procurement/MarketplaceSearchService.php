<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\MaterialSearch;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScope;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

/**
 * Item-Based marketplace search over MAT-02 eligible Tier 2 offers inside the Buyer's radius. Tier 1
 * directory records are never included. Catalog browsing defaults to Distance; a text query defaults to
 * Best Deal (SRS). Favorites First is a separate explicit sort and never alters Best Deal.
 *
 * Best Price and the SRS Price component compare the MAT-03 normalized price of the same comparable group
 * (same product, variant specification and canonical unit) across every eligible, in-stock offer in the
 * selected radius — independent of the Buyer's other filters, so narrowing a list never changes who is
 * cheapest. Results are one card per listing (its best variant under the active sort, approved 2026-09-29),
 * ordered by a total, deterministic key and paged with a signed keyset cursor so pages never repeat a card.
 */
final class MarketplaceSearchService
{
    public const DEFAULT_PER_PAGE = 20;

    public const MAX_PER_PAGE = 50;

    /** Candidate variant rows scored per request; nearest first when a dense area exceeds it. */
    public const MAX_CANDIDATES = 2000;

    public const SORTS = ['BEST_DEAL', 'DISTANCE', 'PRICE', 'RATING', 'FAVORITES_FIRST', 'DISTANCE_DESC', 'PRICE_DESC', 'RATING_ASC'];

    /** Best Price needs a comparison: at least two Vendors offering the same comparable group in the radius. */
    public const BEST_PRICE_MIN_VENDORS = 2;

    public const FUZZY_THRESHOLD = 0.3;

    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly ScopedOfferQuery $offers,
        private readonly RankingPreferenceService $preferences,
        private readonly ListingPublicFacts $facts,
        private readonly PublicVendorProjection $vendors,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function search(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $scope = $this->scopes->forBuyer($buyerId, $input);
        $text = MaterialSearch::normalize((string) ($input['query'] ?? ''));
        $sort = (string) ($input['sort'] ?? ($text === '' ? 'DISTANCE' : 'BEST_DEAL'));
        ['weights' => $weights, 'personalized' => $personalized] = $this->preferences->effectiveFor($buyerId);
        $favorites = $this->facts->favoriteOrganizations($buyerId);
        $perPage = max(1, min(self::MAX_PER_PAGE, (int) ($input['per_page'] ?? self::DEFAULT_PER_PAGE)));
        $fingerprint = $this->fingerprint($scope, $text, $sort, $weights, $input);
        $after = isset($input['cursor']) ? $this->decodeCursor((string) $input['cursor'], $fingerprint) : null;

        $minima = $this->comparableMinima($scope);
        $rows = $this->candidates($scope, $input, $text, $buyerId)->limit(self::MAX_CANDIDATES + 1)->get()->all();
        $limitReached = count($rows) > self::MAX_CANDIDATES;
        $rows = array_slice($rows, 0, self::MAX_CANDIDATES);
        $ratings = $this->facts->productRatings(array_values(array_unique(array_map(static fn (object $row): string => (string) $row->listing_id, $rows))));
        $vps = $this->facts->vps(array_values(array_unique(array_map(static fn (object $row): string => (string) $row->organization_id, $rows))));

        $listings = [];
        foreach ($rows as $row) {
            $offer = $this->score($row, $scope, $weights, $minima, $ratings, $vps, isset($favorites[(string) $row->organization_id]));
            if ($offer === null || ! $this->passesComputedFilters($offer, $input)) {
                continue;
            }
            $offer['key'] = $this->sortKey($sort, $offer);
            $listingId = $offer['listing_id'];
            if (! isset($listings[$listingId])) {
                $listings[$listingId] = ['headline' => $offer, 'options' => 0];
            } elseif ($offer['key'] < $listings[$listingId]['headline']['key']) {
                $listings[$listingId]['headline'] = $offer;
            }
            $listings[$listingId]['options']++;
        }
        $ordered = array_values($listings);
        usort($ordered, static fn (array $a, array $b): int => $a['headline']['key'] <=> $b['headline']['key']);
        $total = count($ordered);
        if ($after !== null) {
            $ordered = array_values(array_filter($ordered, static fn (array $listing): bool => $listing['headline']['key'] > $after));
        }
        $page = array_slice($ordered, 0, $perPage);
        $hasMore = count($ordered) > $perPage;
        $next = $hasMore && $page !== [] ? $this->encodeCursor($page[count($page) - 1]['headline']['key'], $fingerprint) : null;

        return ['items' => $this->present($page, $scope, $weights), 'meta' => [
            'scope' => $scope->summary(),
            'current_as_of' => now()->toIso8601String(),
            'eligibility_version' => EligibleOfferQuery::VERSION,
            'algorithm_version' => SearchRelevanceScore::ALGORITHM_VERSION,
            'sort' => $sort,
            'default_sort' => $text === '' ? 'DISTANCE' : 'BEST_DEAL',
            'query' => ['text' => $input['query'] ?? null, 'normalized' => $text === '' ? null : $text],
            'ranking' => ['weights' => $weights->values, 'personalized' => $personalized, 'default_weights' => RankingWeights::platformDefault()['weights']->values,
                'tie_breakers' => $this->tieBreakers($sort)],
            'total' => $total,
            'per_page' => $perPage,
            'has_more' => $hasMore,
            'next_cursor' => $next,
            'candidate_limit_reached' => $limitReached,
            'expansion' => $total === 0 ? ['suggested_radius_km' => RadiusPolicy::next((int) $scope->radiusKm), 'requires_confirmation' => true] : null,
            'tier_note' => 'Only Verified Vendor listings can be purchased. Directory Suppliers are never shown as inventory.',
        ]];
    }

    /**
     * Lowest normalized price and distinct Vendor count per comparable group over every eligible offer in scope.
     *
     * @return array<string, array{lowest: string, vendors: int}>
     */
    public function comparableMinima(GeographyScope $scope): array
    {
        $normalized = ComparableMappingService::NORMALIZED_PRICE_SQL;
        $rows = ComparableMappingService::joinComparable($this->offers->within($scope))->whereNotNull('ca.id')
            ->selectRaw("ca.material_comparable_group_version_id AS group_version_id, MIN({$normalized}) AS lowest, COUNT(DISTINCT CASE WHEN ({$normalized}) IS NOT NULL THEN l.vendor_organization_id END) AS vendors")
            ->groupBy('ca.material_comparable_group_version_id')->get();
        $minima = [];
        foreach ($rows as $row) {
            if ($row->lowest !== null) {
                $minima[(string) $row->group_version_id] = ['lowest' => bcadd((string) $row->lowest, '0', 8), 'vendors' => (int) $row->vendors];
            }
        }

        return $minima;
    }

    /**
     * Scored offer for one eligible variant row. Returns null for Out of Stock, which is excluded, not zeroed.
     *
     * @param  array<string, array{lowest: string, vendors: int}>  $minima
     * @param  array<string, array{average: ?string, count: int}>  $ratings
     * @param  array<string, string>  $vps
     * @return array<string, mixed>|null
     */
    public function score(object $row, GeographyScope $scope, RankingWeights $weights, array $minima, array $ratings, array $vps, bool $favorite): ?array
    {
        $label = StockAvailability::label(StockAvailability::quantity($row->available), $row->reorder_level === null ? null : StockAvailability::quantity($row->reorder_level));
        $stock = SearchRelevanceScore::stock($label);
        if ($stock === null) {
            return null;
        }
        $distance = (int) round((float) $row->distance_meters);
        $groupId = $row->group_version_id === null ? null : (string) $row->group_version_id;
        $normalized = $row->normalized_price === null ? null : bcadd((string) $row->normalized_price, '0', 8);
        $group = $groupId === null ? null : ($minima[$groupId] ?? null);
        $comparable = $normalized !== null && $group !== null;
        $rating = $ratings[(string) $row->listing_id] ?? ['average' => null, 'count' => 0];
        $vendorScore = $vps[(string) $row->organization_id] ?? null;
        $components = [
            'distance' => SearchRelevanceScore::distance($distance, $scope->radiusMeters()),
            'price' => SearchRelevanceScore::price($comparable ? $group['lowest'] : null, $comparable ? $normalized : null),
            'vps' => SearchRelevanceScore::vps($vendorScore),
            'stock' => $stock,
            'product_rating' => SearchRelevanceScore::productRating($rating['average']),
        ];
        $basis = [
            'distance' => sprintf('%s km away within a %d km radius (straight line)', number_format($distance / 1000, 1), (int) $scope->radiusKm),
            'price' => $comparable
                ? sprintf('Lowest comparable price ₱%s vs this offer ₱%s per %s', number_format((float) $group['lowest'], 2), number_format((float) $normalized, 2), (string) $row->canonical_unit_code)
                : ($groupId === null ? 'Not Yet Comparable — internal neutral score' : 'No approved unit conversion — internal neutral score'),
            'vps' => $vendorScore === null ? 'New Vendor — internal neutral score, not a public rating' : 'VPS '.number_format((float) $vendorScore, 2).' of 5',
            'stock' => $label === StockAvailability::IN_STOCK ? 'In Stock' : 'Limited Stock',
            'product_rating' => $rating['average'] === null ? 'New — no product ratings yet (internal neutral score)' : sprintf('%s of 5 from %d rating%s', $rating['average'], $rating['count'], $rating['count'] === 1 ? '' : 's'),
        ];
        $srs = SearchRelevanceScore::combine($components, $weights);

        return [
            'row' => $row, 'variant_id' => (string) $row->variant_id, 'listing_id' => (string) $row->listing_id, 'organization_id' => (string) $row->organization_id,
            'distance' => $distance, 'price' => (int) $row->amount_centavos, 'stock_label' => $label, 'favorite' => $favorite, 'rating' => $rating, 'vps' => $vendorScore,
            'srs' => $srs, 'components' => $components, 'basis' => $basis, 'comparable' => $comparable, 'normalized' => $normalized,
            'best_price' => $comparable && $group['vendors'] >= self::BEST_PRICE_MIN_VENDORS && bccomp($normalized, $group['lowest'], 8) === 0,
        ];
    }

    /**
     * @param  array<string, mixed>  $offer
     * @return list<int|string>
     */
    private function sortKey(string $sort, array $offer): array
    {
        $srs = -SearchRelevanceScore::sortInteger($offer['srs']);
        $rated = $offer['rating']['average'] === null;

        return match ($sort) {
            'DISTANCE_DESC' => [-$offer['distance'], $srs, $offer['price'], $offer['listing_id'], $offer['variant_id']],
            'PRICE_DESC' => [-$offer['price'], $offer['distance'], $offer['listing_id'], $offer['variant_id']],
            'RATING_ASC' => [$rated ? 1 : 0, $rated ? 0 : (int) bcmul((string) $offer['rating']['average'], '100', 0), -$offer['rating']['count'], $offer['distance'], $offer['listing_id'], $offer['variant_id']],
            'DISTANCE' => [$offer['distance'], $srs, $offer['price'], $offer['listing_id'], $offer['variant_id']],
            'PRICE' => [$offer['price'], $offer['distance'], $offer['listing_id'], $offer['variant_id']],
            'RATING' => [$rated ? 1 : 0, $rated ? 0 : -(int) bcmul((string) $offer['rating']['average'], '100', 0), -$offer['rating']['count'], $offer['distance'], $offer['listing_id'], $offer['variant_id']],
            'FAVORITES_FIRST' => [$offer['favorite'] ? 0 : 1, $srs, $offer['distance'], $offer['price'], $offer['listing_id'], $offer['variant_id']],
            default => [$srs, $offer['distance'], $offer['price'], $offer['listing_id'], $offer['variant_id']],
        };
    }

    /** @return list<string> */
    private function tieBreakers(string $sort): array
    {
        return match ($sort) {
            'DISTANCE_DESC' => ['distance_desc', 'srs_desc', 'unit_price_asc', 'listing_id_asc'],
            'PRICE_DESC' => ['unit_price_desc', 'distance_asc', 'listing_id_asc'],
            'RATING_ASC' => ['rated_first', 'product_rating_asc', 'rating_count_desc', 'distance_asc', 'listing_id_asc'],
            'DISTANCE' => ['distance_asc', 'srs_desc', 'unit_price_asc', 'listing_id_asc'],
            'PRICE' => ['unit_price_asc', 'distance_asc', 'listing_id_asc'],
            'RATING' => ['rated_first', 'product_rating_desc', 'rating_count_desc', 'distance_asc', 'listing_id_asc'],
            'FAVORITES_FIRST' => ['favorite_first', 'srs_desc', 'distance_asc', 'unit_price_asc', 'listing_id_asc'],
            default => ['srs_desc', 'distance_asc', 'unit_price_asc', 'listing_id_asc'],
        };
    }

    /** @param array<string, mixed> $input */
    private function candidates(GeographyScope $scope, array $input, string $text, string $buyerId): Builder
    {
        [$distanceSql, $distanceBindings] = ScopedOfferQuery::distanceSql($scope);
        $query = ComparableMappingService::joinComparable($this->offers->within($scope))
            ->join('products as pr', 'pr.id', '=', 'l.product_id')
            ->join('units as u', 'u.id', '=', 'v.unit_id')
            ->leftJoin('materials as m', 'm.id', '=', 'pr.material_id')
            ->leftJoin('material_categories as mc', 'mc.id', '=', 'l.material_category_id')
            ->select(['v.id as variant_id', 'l.id as listing_id', 'o.id as organization_id', 'l.display_name', 'l.material_category_id', 'mc.name as category_name', 'pr.brand',
                'v.label as variant_label', 'u.code as unit_code', 'u.name as unit_name', 'v.pack_quantity', 'pv.id as price_version_id', 'pv.version as price_version',
                'pv.amount_centavos', 'pv.tax_category', 'pv.effective_at as price_effective_at', 'i.reorder_level', 'i.confirmed_at as stock_confirmed_at',
                'ca.material_comparable_group_version_id as group_version_id', 'cu.code as canonical_unit_code', 'p.fulfillment_method', 'l.regulated', 'l.compliance_status', 'l.publication_version'])
            ->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available')
            ->selectRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' AS normalized_price')
            ->selectRaw($distanceSql.' AS distance_meters', $distanceBindings)
            ->selectRaw('(SELECT max(d.maximum_distance_km) FROM delivery_service_areas d WHERE d.vendor_organization_id = o.id AND d.active) AS delivery_max_km');
        if ($text !== '') {
            $tokens = array_slice(array_values(array_filter(explode(' ', $text), static fn (string $token): bool => $token !== '')), 0, 8);
            $query->where(function (Builder $match) use ($tokens, $text): void {
                $match->where(function (Builder $all) use ($tokens): void {
                    foreach ($tokens as $token) {
                        $all->whereRaw("lower(concat_ws(' ', l.display_name, pr.brand, pr.model, m.name, v.label, mc.name)) LIKE ? ESCAPE '\\'", ['%'.addcslashes($token, '%_\\').'%']);
                    }
                })
                    ->orWhereRaw('similarity(lower(l.display_name), ?) >= ?', [$text, self::FUZZY_THRESHOLD])
                    ->orWhereRaw('similarity(lower(coalesce(m.name, \'\')), ?) >= ?', [$text, self::FUZZY_THRESHOLD])
                    ->orWhereExists(fn (Builder $alias) => $alias->selectRaw('1')->from('material_aliases as ma')->whereColumn('ma.material_id', 'pr.material_id')
                        ->where(fn (Builder $near) => $near->where('ma.normalized_alias', $text)->orWhereRaw('similarity(ma.normalized_alias, ?) >= ?', [$text, self::FUZZY_THRESHOLD])));
            });
        }
        if (isset($input['category_id'])) {
            $query->where('l.material_category_id', $input['category_id']);
        }
        if (isset($input['brand'])) {
            $query->whereRaw('lower(pr.brand) = ?', [MaterialSearch::normalize((string) $input['brand'])]);
        }
        if (isset($input['variant'])) {
            $query->whereRaw("lower(coalesce(v.label, '')) LIKE ? ESCAPE '\\'", ['%'.addcslashes(MaterialSearch::normalize((string) $input['variant']), '%_\\').'%']);
        }
        if (($input['fulfillment'] ?? null) === 'PICKUP') {
            $query->whereIn('p.fulfillment_method', ['SELF_PICKUP', 'BOTH']);
        } elseif (($input['fulfillment'] ?? null) === 'DELIVERY') {
            $query->whereIn('p.fulfillment_method', ['VENDOR_DELIVERY', 'BOTH']);
        }
        if ((bool) ($input['favorites_only'] ?? false)) {
            $query->whereExists(fn (Builder $favorite) => $favorite->selectRaw('1')->from('favorite_vendors as fv')->whereColumn('fv.vendor_organization_id', 'o.id')->where('fv.buyer_profile_id', $buyerId));
        }
        if (($input['compliance'] ?? null) === 'PS_ICC_VERIFIED') {
            $query->where('l.regulated', true)->where('l.compliance_status', 'VERIFIED');
        }
        if (isset($input['min_price_centavos'])) {
            $query->where('pv.amount_centavos', '>=', (int) $input['min_price_centavos']);
        }
        if (isset($input['max_price_centavos'])) {
            $query->where('pv.amount_centavos', '<=', (int) $input['max_price_centavos']);
        }
        if (isset($input['vendor_id'])) {
            $query->where('o.id', $input['vendor_id']);
        }

        return $query->orderByRaw('distance_meters ASC')->orderBy('v.id');
    }

    /**
     * Filters that need computed values: public stock label and straight-line delivery coverage.
     *
     * @param  array<string, mixed>  $offer
     * @param  array<string, mixed>  $input
     */
    private function passesComputedFilters(array $offer, array $input): bool
    {
        if (($input['availability'] ?? null) === 'IN_STOCK' && $offer['stock_label'] !== StockAvailability::IN_STOCK) {
            return false;
        }
        if (($input['fulfillment'] ?? null) === 'DELIVERY') {
            $maximum = $offer['row']->delivery_max_km;

            return $maximum !== null && $offer['distance'] <= (int) $maximum * 1000;
        }

        return true;
    }

    /**
     * @param  list<array{headline: array<string, mixed>, options: int}>  $page
     * @return list<array<string, mixed>>
     */
    private function present(array $page, GeographyScope $scope, RankingWeights $weights): array
    {
        $listingIds = array_map(static fn (array $listing): string => $listing['headline']['listing_id'], $page);
        $organizationIds = array_values(array_unique(array_map(static fn (array $listing): string => $listing['headline']['organization_id'], $page)));
        $images = $this->facts->images($listingIds);
        $sold = $this->facts->unitsSold($listingIds);
        $summaries = $this->vendors->summaries($organizationIds);
        $items = [];
        foreach ($page as $index => $listing) {
            $offer = $listing['headline'];
            $row = $offer['row'];
            $vendor = $summaries[$offer['organization_id']] ?? null;
            if ($vendor === null) {
                continue;
            }
            $items[] = [
                'listing_id' => $offer['listing_id'], 'variant_id' => $offer['variant_id'], 'rank' => $index + 1,
                'display_name' => (string) $row->display_name, 'brand' => $row->brand, 'category' => $row->material_category_id === null ? null : ['id' => (string) $row->material_category_id, 'name' => $row->category_name],
                'variant_label' => $row->variant_label, 'options_count' => $listing['options'],
                'image' => $images[$offer['listing_id']][0] ?? null,
                'price' => ['unit_price_centavos' => $offer['price'], 'currency' => 'PHP', 'unit_code' => (string) $row->unit_code, 'unit_name' => (string) $row->unit_name,
                    'pack_quantity' => StockAvailability::quantity($row->pack_quantity), 'tax_category' => (string) $row->tax_category, 'vat_label' => ListingPublicFacts::vatLabel((string) $row->tax_category),
                    'price_version_id' => (string) $row->price_version_id, 'effective_at' => Carbon::parse((string) $row->price_effective_at)->toIso8601String()],
                'comparable' => $offer['comparable']
                    ? ['status' => 'COMPARABLE', 'normalized_unit_price' => $offer['normalized'], 'canonical_unit_code' => (string) $row->canonical_unit_code]
                    : ['status' => 'NOT_YET_COMPARABLE', 'normalized_unit_price' => null, 'canonical_unit_code' => null],
                'stock_label' => $offer['stock_label'],
                'stock_confirmed_at' => Carbon::parse((string) $row->stock_confirmed_at)->toIso8601String(),
                'product_rating' => ['average' => $offer['rating']['average'], 'count' => $offer['rating']['count'], 'label' => $offer['rating']['average'] === null ? 'New' : $offer['rating']['average'].' of 5'],
                'units_sold' => $sold[$offer['listing_id']] ?? '0.0000',
                'distance_meters' => $offer['distance'],
                'badges' => array_values(array_filter([$offer['best_price'] ? 'BEST_PRICE' : null, $row->regulated && $row->compliance_status === 'VERIFIED' ? 'PS_ICC_VERIFIED' : null])),
                'is_favorite' => $offer['favorite'],
                'vendor' => ['id' => $vendor['id'], 'name' => $vendor['public_store_name'], 'logo_url' => $vendor['logo_url'], 'score_label' => $vendor['score_label'], 'vacation_mode' => $vendor['vacation_mode']],
                'fulfillment' => [
                    'pickup_available' => in_array($row->fulfillment_method, ['SELF_PICKUP', 'BOTH'], true),
                    'delivery' => $row->delivery_max_km === null || ! in_array($row->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true) ? 'NOT_OFFERED' : ($offer['distance'] <= (int) $row->delivery_max_km * 1000 ? 'WITHIN_STATED_AREA' : 'OUTSIDE_STATED_AREA'),
                    'basis' => 'STRAIGHT_LINE_ADVISORY',
                ],
                'ranking' => ['srs' => SearchRelevanceScore::round($offer['srs'], 2), 'components' => SearchRelevanceScore::explain($offer['components'], $weights, $offer['basis'])],
            ];
        }

        return $items;
    }

    /** @param array<string, mixed> $input */
    private function fingerprint(GeographyScope $scope, string $text, string $sort, RankingWeights $weights, array $input): string
    {
        $filters = array_intersect_key($input, array_flip(['category_id', 'brand', 'variant', 'availability', 'fulfillment', 'favorites_only', 'compliance', 'min_price_centavos', 'max_price_centavos', 'vendor_id', 'per_page']));
        ksort($filters);

        return substr(hash('sha256', implode('|', [$scope->originVersion, (string) $scope->radiusKm, $text, $sort, $weights->fingerprint(), json_encode($filters, JSON_THROW_ON_ERROR)])), 0, 24);
    }

    /** @param list<int|string> $key */
    private function encodeCursor(array $key, string $fingerprint): string
    {
        $payload = rtrim(strtr(base64_encode(json_encode(['k' => $key, 'f' => $fingerprint], JSON_THROW_ON_ERROR)), '+/', '-_'), '=');

        return $payload.'.'.substr(hash_hmac('sha256', $payload, (string) config('app.key')), 0, 32);
    }

    /** @return list<int|string> */
    private function decodeCursor(string $cursor, string $fingerprint): array
    {
        [$payload, $signature] = array_pad(explode('.', $cursor, 2), 2, '');
        $decoded = hash_equals(substr(hash_hmac('sha256', $payload, (string) config('app.key')), 0, 32), $signature)
            ? json_decode((string) base64_decode(strtr($payload, '-_', '+/'), true), true) : null;
        if (! is_array($decoded) || ! is_array($decoded['k'] ?? null) || ($decoded['f'] ?? null) !== $fingerprint) {
            throw new AuthenticationException('CURSOR_INVALID', 'The results changed. Start again from the first page.', 422);
        }

        return array_values($decoded['k']);
    }
}
