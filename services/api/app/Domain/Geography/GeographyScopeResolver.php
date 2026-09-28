<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * MAT-01 scope resolution shared by Buyer discovery, Explore and later Materials Analytics.
 *
 * Buyer: an owned, non-archived saved location or finite Philippine coordinates (never persisted here),
 * falling back to the primary saved location. Vendor: always the authenticated organization's own current
 * store point; any caller-supplied origin is rejected so a market request cannot centre on a competitor.
 * Admin: a versioned PSGC area or the whole Philippines, with no 50 km ceiling.
 */
final class GeographyScopeResolver
{
    /** Request keys that would let a Vendor pick an arbitrary or competitor-centred origin. */
    public const VENDOR_FORBIDDEN_ORIGIN_KEYS = ['latitude', 'longitude', 'location_id', 'origin', 'origin_latitude', 'origin_longitude', 'vendor_id', 'organization_id', 'store_id', 'competitor_id'];

    /** @param array<string, mixed> $input */
    public function forBuyer(string $buyerProfileId, array $input): GeographyScope
    {
        $radius = RadiusPolicy::assertAllowed($input['radius_km'] ?? DB::table('buyer_profiles')->where('id', $buyerProfileId)->value('discovery_radius_km') ?? RadiusPolicy::BUYER_DEFAULT_KM);
        $hasCoordinates = array_key_exists('latitude', $input) || array_key_exists('longitude', $input);
        $locationId = $input['location_id'] ?? null;
        if ($hasCoordinates && $locationId !== null) {
            throw new AuthenticationException('ORIGIN_AMBIGUOUS', 'Send either a saved location or map coordinates, not both.', 422);
        }
        if ($hasCoordinates) {
            [$latitude, $longitude] = PhilippineBounds::assert($input['latitude'] ?? null, $input['longitude'] ?? null);
            $kind = in_array($input['origin_source'] ?? null, ['DEVICE', 'MAP_PIN', 'SEARCH'], true) ? (string) $input['origin_source'] : 'MAP_PIN';

            return new GeographyScope('BUYER', 'RADIUS', $kind, $latitude, $longitude, $radius, $this->version(sprintf('pt:%.5f,%.5f', $latitude, $longitude)));
        }
        $location = $this->ownedLocation($buyerProfileId, is_string($locationId) ? $locationId : null);

        return new GeographyScope('BUYER', 'RADIUS', 'SAVED_LOCATION', (float) $location->latitude, (float) $location->longitude, $radius,
            $this->version('loc:'.$location->address_id), (string) $location->id, $location->label === null ? null : (string) $location->label);
    }

    /** @param array<string, mixed> $input */
    public function forVendor(string $organizationId, array $input): GeographyScope
    {
        foreach (self::VENDOR_FORBIDDEN_ORIGIN_KEYS as $key) {
            if (array_key_exists($key, $input)) {
                throw new AuthenticationException('ORIGIN_NOT_PERMITTED', 'Vendor market scope always uses your own verified store location.', 422, ['field' => $key]);
            }
        }
        $radius = RadiusPolicy::assertAllowed($input['radius_km'] ?? RadiusPolicy::VENDOR_DEFAULT_KM);
        $point = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')
            ->where('a.vendor_organization_id', $organizationId)->whereNotNull('v.location')
            ->first(['v.id', 'v.latitude', 'v.longitude']);
        if ($point === null) {
            throw new AuthenticationException('STORE_LOCATION_UNAVAILABLE', 'Your verified store location is not available yet.', 409);
        }

        return new GeographyScope('VENDOR', 'RADIUS', 'OWN_STORE', (float) $point->latitude, (float) $point->longitude, $radius, $this->version('store:'.$point->id));
    }

    public function forAdmin(?string $psgcCode, ?string $psgcVersionId = null): GeographyScope
    {
        $version = $psgcVersionId === null
            ? DB::table('psgc_versions')->where('status', 'ACTIVE')->value('id')
            : DB::table('psgc_versions')->where('id', $psgcVersionId)->whereIn('status', ['ACTIVE', 'RETIRED'])->value('id');
        if ($version === null) {
            throw new AuthenticationException('PSGC_VERSION_UNAVAILABLE', 'No imported PSGC version is available for this scope.', 422);
        }
        if ($psgcCode !== null && ! DB::table('psgc_areas')->where('psgc_version_id', $version)->where('code', $psgcCode)->exists()) {
            throw new AuthenticationException('PSGC_AREA_UNKNOWN', 'Choose a PSGC area from the selected version.', 422);
        }

        return new GeographyScope('ADMIN', 'PSGC', $psgcCode === null ? 'PHILIPPINES' : 'PSGC_AREA', null, null, null,
            $this->version('psgc:'.$version.':'.($psgcCode ?? 'PH')), psgcVersionId: (string) $version, psgcCode: $psgcCode);
    }

    private function ownedLocation(string $buyerProfileId, ?string $locationId): object
    {
        $query = DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')
            ->where('bl.buyer_profile_id', $buyerProfileId)->whereNull('bl.archived_at')->whereNotNull('a.location');
        $location = $locationId === null
            ? $query->where('bl.is_primary', true)->first(['bl.id', 'bl.label', 'bl.address_id', 'a.latitude', 'a.longitude'])
            : $query->where('bl.id', $locationId)->first(['bl.id', 'bl.label', 'bl.address_id', 'a.latitude', 'a.longitude']);
        if ($location === null && $locationId !== null) {
            throw new AuthenticationException('LOCATION_NOT_FOUND', 'This saved location is unavailable.', 404);
        }
        if ($location === null) {
            throw new AuthenticationException('ORIGIN_REQUIRED', 'Choose a location first: use your device location, search an address or drop a pin.', 422);
        }

        return $location;
    }

    private function version(string $identity): string
    {
        return substr(hash_hmac('sha256', $identity, (string) config('app.key')), 0, 32);
    }
}
