<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Inventory\StockConfirmationPolicy;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * MAT-02 shared current-offer predicate, used by Marketplace Discoverability, current Explore counts,
 * current offer lists and the daily capture. An eligible offer is one listing variant of an active Tier 2
 * organization whose listing is ACTIVE and publishable, meets any required product compliance, carries a
 * current finite positive ordinary public price with a permitted tax classification, and has confirmed,
 * non-stale inventory with a positive quantity available to sell. Exact quantities never leave this query.
 */
final class EligibleOfferQuery
{
    public const VERSION = 'mat02.eligible-offer.v1';

    public const COUNT_TTL_SECONDS = 60;

    public const GENERATION_KEY = 'mat02:eligibility-generation';

    /**
     * Eligible variant rows (alias v) with their listing (l), organization (o), inventory (i) and current
     * ordinary price (pv). Pass organization ids to scope the relation; null means every organization.
     *
     * @param  list<string>|null  $organizationIds
     */
    public function variants(?array $organizationIds = null): Builder
    {
        $query = DB::table('listing_variants as v')
            ->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->join('vendor_organizations as o', 'o.id', '=', 'l.vendor_organization_id')
            ->join('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->join('listing_price_versions as pv', fn ($join) => $join->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'));
        if ($organizationIds !== null) {
            $query->whereIn('l.vendor_organization_id', $organizationIds === [] ? ['00000000-0000-0000-0000-000000000000'] : $organizationIds);
        }

        return $this->constrain($query);
    }

    /** Constrains a vendor_listings query (alias l) to listings with at least one eligible variant. */
    public function constrainListings(Builder $listings): Builder
    {
        return $listings->whereExists(fn (Builder $variant) => $this->constrain($variant->selectRaw('1')->from('listing_variants as v')
            ->join('vendor_listings as el', 'el.id', '=', 'v.vendor_listing_id')
            ->join('vendor_organizations as o', 'o.id', '=', 'el.vendor_organization_id')
            ->join('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->join('listing_price_versions as pv', fn ($join) => $join->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
            ->whereColumn('el.id', 'l.id'), 'el'));
    }

    /**
     * Current distinct Vendor and listing counts. Multiple variants never inflate the listing count and
     * duplicate offers never give one Vendor more weight. Short-lived cached values are labelled with their
     * capture time and invalidated by eligibility-change outbox events.
     *
     * @param  list<string>|null  $organizationIds
     * @return array{vendors: int, listings: int, current_as_of: string, eligibility_version: string}
     */
    public function currentCounts(?array $organizationIds = null): array
    {
        $scope = $organizationIds === null ? 'all' : hash('sha256', implode(',', array_unique($organizationIds)));
        $key = 'mat02:counts:'.self::generation().':'.$scope;

        return Cache::remember($key, self::COUNT_TTL_SECONDS, function () use ($organizationIds): array {
            $row = $this->variants($organizationIds)->selectRaw('COUNT(DISTINCT l.vendor_organization_id) AS vendors, COUNT(DISTINCT l.id) AS listings')->first();

            return ['vendors' => (int) ($row->vendors ?? 0), 'listings' => (int) ($row->listings ?? 0), 'current_as_of' => now()->toIso8601String(), 'eligibility_version' => self::VERSION];
        });
    }

    /**
     * Current eligible offers with their MAT-03 source versions for a later immutable daily observation.
     * Quantities are deliberately absent; the stock confirmation instant is the only inventory field.
     *
     * @param  list<string>|null  $organizationIds
     * @return list<array<string, mixed>>
     */
    public function currentOffers(?array $organizationIds = null, int $limit = 500): array
    {
        $rows = $this->variants($organizationIds)
            ->leftJoin('listing_comparable_assignments as ca', fn ($join) => $join->on('ca.listing_variant_id', '=', 'v.id')->whereNull('ca.effective_until')->where('ca.mapping_state', 'APPROVED'))
            ->leftJoin('material_comparable_group_versions as gv', 'gv.id', '=', 'ca.material_comparable_group_version_id')
            ->orderBy('l.vendor_organization_id')->orderBy('v.id')->limit(max(1, min($limit, 5000)))
            ->get(['v.id as listing_variant_id', 'l.id as vendor_listing_id', 'l.vendor_organization_id', 'pv.id as listing_price_version_id', 'pv.version as price_version', 'pv.effective_at as price_effective_at', 'pv.amount_centavos', 'pv.tax_category', 'ca.material_comparable_group_version_id', 'gv.conversion_version', 'i.confirmed_at as stock_confirmed_at']);

        return $rows->map(static fn (object $row): array => [
            'listing_variant_id' => $row->listing_variant_id, 'vendor_listing_id' => $row->vendor_listing_id, 'vendor_organization_id' => $row->vendor_organization_id,
            'listing_price_version_id' => $row->listing_price_version_id, 'price_version' => (int) $row->price_version, 'price_effective_at' => $row->price_effective_at,
            'ordinary_payable_centavos' => (int) $row->amount_centavos, 'tax_category' => $row->tax_category,
            'comparable_group_version_id' => $row->material_comparable_group_version_id, 'unit_conversion_version' => $row->conversion_version,
            'comparability_rule_version' => $row->material_comparable_group_version_id === null ? null : ComparableMappingService::MAPPING_RULE,
            'stock_confirmed_at' => $row->stock_confirmed_at, 'eligibility_version' => self::VERSION,
        ])->all();
    }

    public static function generation(): int
    {
        return (int) Cache::get(self::GENERATION_KEY, 1);
    }

    /** Invalidates every cached current count at once; bounded to one counter regardless of scopes. */
    public static function invalidate(): void
    {
        if (! Cache::add(self::GENERATION_KEY, 2)) {
            Cache::increment(self::GENERATION_KEY);
        }
    }

    private function constrain(Builder $query, string $listingAlias = 'l'): Builder
    {
        return ListingTaxPolicy::constrainAllowed($query
            ->where('o.account_status', 'ACTIVE')->where('o.store_activation_status', 'ACTIVE')->whereNull('o.activation_hold_code')
            ->where($listingAlias.'.status', 'ACTIVE')->whereNull($listingAlias.'.removed_at')
            ->where(fn (Builder $compliance) => $compliance->where($listingAlias.'.regulated', false)->orWhere($listingAlias.'.compliance_status', 'VERIFIED'))
            ->where('v.active', true)
            ->where('pv.effective_at', '<=', now())->where('pv.amount_centavos', '>', 0)
            ->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0')
            ->whereNotNull('i.confirmed_at')->where('i.confirmed_at', '>', now()->subDays(StockConfirmationPolicy::HIDE_AFTER_DAYS)), 'pv.tax_category', 'o.id');
    }
}
