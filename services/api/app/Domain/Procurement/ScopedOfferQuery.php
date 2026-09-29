<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\GeographyScope;
use Illuminate\Database\Query\Builder;

/**
 * MAT-02 eligible offers of the same discoverable Tier 2 stores the map shows (active, DISCOVERABLE,
 * completed public profile, saved store point), limited to one Buyer radius scope with the inclusive
 * ST_DWithin boundary. Aliases: v, l, o, i, pv (EligibleOfferQuery) plus p (store profile) and av (store
 * address version). Adds distance_meters on request. Saved hours never affect membership.
 */
final class ScopedOfferQuery
{
    public function __construct(private readonly EligibleOfferQuery $offers) {}

    public function within(GeographyScope $scope): Builder
    {
        return $this->discoverable($this->offers->variants())
            ->whereRaw('ST_DWithin(av.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)', [$scope->longitude, $scope->latitude, $scope->membershipMeters()]);
    }

    /** The same relation without the radius, used to explain why a known listing is outside the scope. */
    public function anywhere(): Builder
    {
        return $this->discoverable($this->offers->variants());
    }

    /** @return array{0: string, 1: list<float|null>} */
    public static function distanceSql(GeographyScope $scope): array
    {
        return ['ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography)', [$scope->longitude, $scope->latitude]];
    }

    private function discoverable(Builder $variants): Builder
    {
        return $variants
            ->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->join('vendor_addresses as va', 'va.vendor_organization_id', '=', 'o.id')
            ->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')
            ->where('o.marketplace_discoverability_status', 'DISCOVERABLE')
            ->where('p.status', 'COMPLETED')->whereNotNull('av.location');
    }
}
