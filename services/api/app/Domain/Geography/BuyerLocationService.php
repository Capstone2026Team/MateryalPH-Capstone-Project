<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\AddressProviderUnavailable;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Buyer saved locations. GPS is optional: device location, a dropped pin and a typed address are complete
 * alternatives, and a provider outage still allows saving a pin with a manually described address. Every
 * save stores the authoritative point plus the best resolved versioned PSGC codes; editing a point appends a
 * new address version so earlier snapshots keep their captured address and geography version.
 */
final class BuyerLocationService
{
    public const MAX_LOCATIONS = 20;

    public const KINDS = ['DELIVERY', 'BUSINESS', 'PROJECT_SITE', 'PICKUP_REFERENCE', 'OTHER'];

    public const RESOLUTION_MINUTES = 30;

    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly AddressGeocoder $geocoder,
        private readonly PsgcResolver $psgc,
        private readonly CatalogAccess $idempotency,
        private readonly AuditRecorder $audit,
        private readonly PlacesProvider $places,
    ) {}

    /** @return list<array{place_id: string, title: string, subtitle: ?string}> */
    public function autocomplete(Request $request, string $query, string $sessionToken): array
    {
        $this->profiles->idFor($request);
        try {
            return $this->places->autocomplete($query, $sessionToken);
        } catch (GeographyProviderUnavailable) {
            throw new AuthenticationException('PLACES_UNAVAILABLE', 'Location suggestions are unavailable. Move the map pin or try again.', 503);
        }
    }

    /**
     * Resolves a pin, device point or typed address into a reviewable preview and a short-lived token that
     * binds the exact result to this Buyer. Nothing is persisted.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function resolve(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $mode = (string) $input['mode'];
        $place = null;
        if ($mode === 'PLACE') {
            try {
                $place = $this->places->locate((string) $input['place_id'], (string) $input['session_token']);
            } catch (GeographyProviderUnavailable) {
                throw new AuthenticationException('PLACES_UNAVAILABLE', 'This location could not be resolved. Move the map pin or try again.', 503);
            }
            if ($place === null) {
                throw new AuthenticationException('ADDRESS_NOT_LOCATED', 'Choose another suggestion or move the map pin.', 422);
            }
            $input['latitude'] = $place['latitude'];
            $input['longitude'] = $place['longitude'];
        }
        if ($mode === 'ADDRESS') {
            $components = ['street' => $this->clean($input['address_line'] ?? null, 200), 'barangay' => $this->clean($input['barangay'] ?? null, 120),
                'city_municipality' => $this->clean($input['city_municipality'] ?? null, 120), 'province' => $this->clean($input['province'] ?? null, 120), 'postal_code' => $this->clean($input['postal_code'] ?? null, 10)];
            $query = implode(', ', array_filter([...array_values($components), 'Philippines']));
            try {
                $located = $this->geocoder->forward($query);
            } catch (AddressProviderUnavailable) {
                throw new AuthenticationException('ADDRESS_PROVIDER_UNAVAILABLE', 'Address search is temporarily unavailable. Drop a pin on the map instead.', 503);
            }
            if ($located === null || ! PhilippineBounds::contains($located['latitude'], $located['longitude'])) {
                throw new AuthenticationException('ADDRESS_NOT_LOCATED', 'We could not locate this address. Check the details or drop a pin on the map.', 422);
            }
            $psgc = is_string($input['city_code'] ?? null) ? $this->psgc->resolveCodes($input['city_code'], is_string($input['barangay_code'] ?? null) ? $input['barangay_code'] : null) : null;
            if ($psgc === null && is_string($input['city_code'] ?? null)) {
                throw new AuthenticationException('PSGC_AREA_UNKNOWN', 'Choose the city or municipality and barangay again from the current PSGC list.', 422);
            }
            $resolved = ['latitude' => $located['latitude'], 'longitude' => $located['longitude'], 'formatted_address' => $located['formatted_address'], 'source' => 'ADDRESS_SEARCH',
                'provider' => 'GOOGLE_MAPS', 'provider_status' => 'AVAILABLE', 'components' => $components,
                'psgc' => $psgc ?? $this->psgc->resolveNames(['city_municipality' => $components['city_municipality'], 'province' => $components['province'], 'barangay' => $components['barangay']])];
        } else {
            [$latitude, $longitude] = PhilippineBounds::assert($input['latitude'] ?? null, $input['longitude'] ?? null);
            $status = 'AVAILABLE';
            try {
                $reverse = $this->geocoder->reverse($latitude, $longitude);
                $status = $reverse === null ? 'NOT_FOUND' : 'AVAILABLE';
            } catch (AddressProviderUnavailable) {
                $reverse = null;
                $status = 'UNAVAILABLE';
            }
            $components = ['street' => $reverse['street'] ?? null, 'barangay' => $reverse['barangay'] ?? null, 'city_municipality' => $reverse['city_municipality'] ?? null,
                'province' => $reverse['province'] ?? null, 'postal_code' => $reverse['postal_code'] ?? null];
            $resolved = ['latitude' => $latitude, 'longitude' => $longitude, 'formatted_address' => $reverse['formatted_address'] ?? null, 'source' => $mode === 'DEVICE' ? 'DEVICE' : 'MAP_PIN',
                'provider' => $reverse === null ? null : 'GOOGLE_MAPS', 'provider_status' => $status, 'components' => $components,
                'psgc' => $reverse === null ? $this->psgc->resolveNames([]) : $this->psgc->resolveNames(['city_municipality' => $components['city_municipality'], 'province' => $components['province'], 'barangay' => $components['barangay']])];
        }
        $resolved['latitude'] = round((float) $resolved['latitude'], 7);
        if ($place !== null) {
            $resolved['formatted_address'] = $place['formatted_address'];
            $resolved['source'] = 'ADDRESS_SEARCH';
            $resolved['provider'] = 'GOOGLE_MAPS';
            $resolved['provider_status'] = 'AVAILABLE';
        }
        $resolved['longitude'] = round((float) $resolved['longitude'], 7);
        $expires = now()->addMinutes(self::RESOLUTION_MINUTES);
        $token = Crypt::encryptString(json_encode(['buyer_profile_id' => $buyerId, 'expires_at' => $expires->timestamp, 'resolution' => $resolved], JSON_THROW_ON_ERROR));

        return $this->preview($resolved) + ['resolution_token' => $token, 'expires_at' => $expires->toIso8601String()];
    }

    /** @return list<array<string, mixed>> */
    public function list(Request $request): array
    {
        $buyerId = $this->profiles->idFor($request);

        return DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')->leftJoin('psgc_versions as pv', 'pv.id', '=', 'a.psgc_version_id')
            ->where('bl.buyer_profile_id', $buyerId)->whereNull('bl.archived_at')
            ->orderByDesc('bl.is_primary')->orderBy('bl.label')->orderBy('bl.id')
            ->get(['bl.*', 'a.formatted_address', 'a.latitude', 'a.longitude', 'a.source', 'a.version as address_version', 'a.street', 'a.barangay', 'a.city_municipality', 'a.province', 'a.postal_code',
                'a.psgc_resolution', 'a.region_code', 'a.province_code', 'a.city_code', 'a.psgc_code', 'pv.version as psgc_version',
                DB::raw('(SELECT r.name FROM psgc_areas r WHERE r.psgc_version_id = a.psgc_version_id AND r.code = a.region_code) AS region_name')])
            ->map(fn (object $row): array => $this->resource($row))->all();
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function create(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $key = $this->idempotency->requireIdempotencyKey($request);
        $resolution = $this->readToken($buyerId, (string) $input['resolution_token']);
        $formatted = $this->formattedAddress($resolution, $input);

        $locationId = DB::transaction(function () use ($request, $buyerId, $key, $resolution, $formatted, $input): string {
            DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first(['id']);
            if ($this->idempotency->replayed($request, 'BUYER_LOCATION_CREATE', $key, $buyerId)) {
                return (string) DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->orderByDesc('created_at')->orderByDesc('id')->value('id');
            }
            $active = DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->whereNull('archived_at')->count();
            if ($active >= self::MAX_LOCATIONS) {
                throw new AuthenticationException('LOCATION_LIMIT_REACHED', 'You can keep up to 20 saved locations. Remove one before adding another.', 409);
            }
            $addressId = $this->insertAddress($buyerId, $resolution, $formatted, (string) $input['label'], 1);
            $locationId = (string) Str::uuid7();
            $primary = $active === 0 || (bool) ($input['make_primary'] ?? false);
            if ($primary) {
                DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->where('is_primary', true)->update(['is_primary' => false, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            }
            DB::table('buyer_locations')->insert(['id' => $locationId, 'buyer_profile_id' => $buyerId, 'address_id' => $addressId, 'is_primary' => $primary] + $this->details($input) + ['lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'BUYER_LOCATION_SAVED', 'BUYER_LOCATION', $locationId, after: ['psgc_resolution' => $resolution['psgc']['psgc_resolution'], 'source' => $resolution['source'], 'primary' => $primary]);
            $this->idempotency->claim($request, 'BUYER_LOCATION_CREATE', $key, $buyerId, 201);

            return $locationId;
        });

        return $this->find($buyerId, $locationId);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function update(Request $request, string $locationId, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $resolution = isset($input['resolution_token']) ? $this->readToken($buyerId, (string) $input['resolution_token']) : null;
        DB::transaction(function () use ($request, $buyerId, $locationId, $input, $resolution): void {
            $location = $this->lockOwned($buyerId, $locationId, (int) $input['lock_version']);
            $update = $this->details($input, partial: true);
            if ($resolution !== null) {
                $old = DB::table('addresses')->where('id', $location->address_id)->first(['version', 'label']);
                DB::table('addresses')->where('id', $location->address_id)->update(['is_current' => false, 'updated_at' => now()]);
                $update['address_id'] = $this->insertAddress($buyerId, $resolution, $this->formattedAddress($resolution, $input), (string) ($input['label'] ?? $location->label ?? $old->label ?? 'Saved location'), (int) $old->version + 1);
            }
            DB::table('buyer_locations')->where('id', $locationId)->update($update + ['lock_version' => (int) $location->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'BUYER_LOCATION_UPDATED', 'BUYER_LOCATION', $locationId, after: ['point_changed' => $resolution !== null, 'fields' => array_keys($update)]);
        });

        return $this->find($buyerId, $locationId);
    }

    /** @return array<string, mixed> */
    public function makePrimary(Request $request, string $locationId, int $lockVersion): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($request, $buyerId, $locationId, $lockVersion): void {
            DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first(['id']);
            $location = $this->lockOwned($buyerId, $locationId, $lockVersion);
            if ($location->is_primary) {
                return;
            }
            DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->where('is_primary', true)->update(['is_primary' => false, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            DB::table('buyer_locations')->where('id', $locationId)->update(['is_primary' => true, 'lock_version' => $lockVersion + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'BUYER_PRIMARY_LOCATION_CHANGED', 'BUYER_LOCATION', $locationId);
        });

        return $this->find($buyerId, $locationId);
    }

    public function archive(Request $request, string $locationId, int $lockVersion): void
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($request, $buyerId, $locationId, $lockVersion): void {
            DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first(['id']);
            $location = $this->lockOwned($buyerId, $locationId, $lockVersion);
            if ($location->is_primary && DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->whereNull('archived_at')->where('id', '<>', $locationId)->exists()) {
                throw new AuthenticationException('PRIMARY_LOCATION_REQUIRED', 'Choose another primary location before removing this one.', 409);
            }
            DB::table('buyer_locations')->where('id', $locationId)->update(['archived_at' => now(), 'is_primary' => false, 'lock_version' => $lockVersion + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'BUYER_LOCATION_REMOVED', 'BUYER_LOCATION', $locationId);
        });
    }

    /** @return array<string, mixed> */
    private function find(string $buyerId, string $locationId): array
    {
        $row = DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')->leftJoin('psgc_versions as pv', 'pv.id', '=', 'a.psgc_version_id')
            ->where('bl.buyer_profile_id', $buyerId)->where('bl.id', $locationId)
            ->first(['bl.*', 'a.formatted_address', 'a.latitude', 'a.longitude', 'a.source', 'a.version as address_version', 'a.street', 'a.barangay', 'a.city_municipality', 'a.province', 'a.postal_code',
                'a.psgc_resolution', 'a.region_code', 'a.province_code', 'a.city_code', 'a.psgc_code', 'pv.version as psgc_version',
                DB::raw('(SELECT r.name FROM psgc_areas r WHERE r.psgc_version_id = a.psgc_version_id AND r.code = a.region_code) AS region_name')]);
        if ($row === null) {
            throw new AuthenticationException('LOCATION_NOT_FOUND', 'This saved location is unavailable.', 404);
        }

        return $this->resource($row);
    }

    private function lockOwned(string $buyerId, string $locationId, int $lockVersion): object
    {
        $location = Str::isUuid($locationId) ? DB::table('buyer_locations')->where('id', $locationId)->where('buyer_profile_id', $buyerId)->whereNull('archived_at')->lockForUpdate()->first() : null;
        if ($location === null) {
            throw new AuthenticationException('LOCATION_NOT_FOUND', 'This saved location is unavailable.', 404);
        }
        if ((int) $location->lock_version !== $lockVersion) {
            throw new AuthenticationException('LOCATION_VERSION_CONFLICT', 'This location changed on another device. Reload it and try again.', 409, ['current_lock_version' => (int) $location->lock_version]);
        }

        return $location;
    }

    /** @param array<string, mixed> $resolution */
    private function insertAddress(string $buyerId, array $resolution, string $formatted, string $label, int $version): string
    {
        $id = (string) Str::uuid7();
        $psgc = $resolution['psgc'];
        DB::table('addresses')->insert([
            'id' => $id, 'owner_type' => 'BUYER_PROFILE', 'owner_id' => $buyerId, 'label' => Str::limit(trim($label), 60, ''), 'formatted_address' => $formatted,
            'street' => $resolution['components']['street'] ?? null, 'barangay' => $psgc['barangay'] ?? $resolution['components']['barangay'] ?? null,
            'city_municipality' => $psgc['city_municipality'] ?? $resolution['components']['city_municipality'] ?? null, 'province' => $psgc['province'] ?? $resolution['components']['province'] ?? null,
            'postal_code' => $resolution['components']['postal_code'] ?? null,
            'latitude' => $resolution['latitude'], 'longitude' => $resolution['longitude'],
            'location' => DB::raw('ST_SetSRID(ST_MakePoint('.(float) $resolution['longitude'].', '.(float) $resolution['latitude'].'), 4326)::geography'),
            'source' => $resolution['source'], 'provider' => $resolution['provider'], 'review_state' => 'NOT_REQUIRED', 'verified' => false, 'version' => $version, 'is_current' => true,
            'psgc_resolution' => $psgc['psgc_resolution'], 'psgc_version_id' => $psgc['psgc_version_id'], 'region_code' => $psgc['region_code'], 'province_code' => $psgc['province_code'],
            'city_code' => $psgc['city_code'], 'psgc_code' => $psgc['psgc_code'], 'psgc_source' => $psgc['psgc_version_id'] === null ? null : 'PSGC_MASTER',
            'created_at' => now(), 'updated_at' => now(),
        ]);

        return $id;
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private function details(array $input, bool $partial = false): array
    {
        $fields = [];
        foreach (['label' => 60, 'contact_name' => 120] as $field => $max) {
            if (! $partial || array_key_exists($field, $input)) {
                $fields[$field] = $this->clean($input[$field] ?? null, $max);
            }
        }
        if (! $partial || array_key_exists('location_kind', $input)) {
            $fields['location_kind'] = $input['location_kind'] ?? 'DELIVERY';
        }
        if (! $partial || array_key_exists('contact_phone_e164', $input)) {
            $fields['contact_phone_e164'] = $input['contact_phone_e164'] ?? null;
        }
        if (! $partial || array_key_exists('site_instructions', $input)) {
            $instructions = $this->clean($input['site_instructions'] ?? null, 500);
            $fields['site_instructions_encrypted'] = $instructions === null ? null : Crypt::encryptString($instructions);
        }

        return $fields;
    }

    /**
     * @param  array<string, mixed>  $resolution
     * @param  array<string, mixed>  $input
     */
    private function formattedAddress(array $resolution, array $input): string
    {
        $manual = $this->clean($input['address_line'] ?? null, 300);
        $formatted = $manual ?? (is_string($resolution['formatted_address'] ?? null) ? $resolution['formatted_address'] : null);
        if ($formatted === null) {
            throw new AuthenticationException('ADDRESS_DESCRIPTION_REQUIRED', 'Describe this location (street, landmark or barangay) because the address could not be looked up.', 422, ['field' => 'address_line']);
        }

        return $formatted;
    }

    /** @return array<string, mixed> */
    private function readToken(string $buyerId, string $token): array
    {
        try {
            $payload = json_decode(Crypt::decryptString($token), true, 32, JSON_THROW_ON_ERROR);
        } catch (DecryptException|\JsonException) {
            $payload = null;
        }
        if (! is_array($payload) || ($payload['buyer_profile_id'] ?? null) !== $buyerId || (int) ($payload['expires_at'] ?? 0) < now()->timestamp || ! is_array($payload['resolution'] ?? null)) {
            throw new AuthenticationException('LOCATION_RESOLUTION_EXPIRED', 'This map location has expired. Choose the location again.', 422);
        }

        return $payload['resolution'];
    }

    /**
     * @param  array<string, mixed>  $resolved
     * @return array<string, mixed>
     */
    private function preview(array $resolved): array
    {
        $psgc = $resolved['psgc'];

        return [
            'formatted_address' => $resolved['formatted_address'],
            'latitude' => round((float) $resolved['latitude'], 6),
            'longitude' => round((float) $resolved['longitude'], 6),
            'source' => $resolved['source'],
            'provider_status' => $resolved['provider_status'],
            'components' => $resolved['components'],
            'psgc' => $this->psgcResource($psgc['psgc_resolution'], $psgc['psgc_version_id'] === null ? null : (string) DB::table('psgc_versions')->where('id', $psgc['psgc_version_id'])->value('version'),
                ['region' => [$psgc['region_code'], $psgc['region']], 'province' => [$psgc['province_code'], $psgc['province']], 'city_municipality' => [$psgc['city_code'], $psgc['city_municipality']], 'barangay' => [$psgc['psgc_code'], $psgc['barangay']]], $psgc['reason'] ?? null),
        ];
    }

    /** @return array<string, mixed> */
    private function resource(object $row): array
    {
        $instructions = null;
        if ($row->site_instructions_encrypted !== null) {
            try {
                $instructions = Crypt::decryptString((string) $row->site_instructions_encrypted);
            } catch (DecryptException) {
                $instructions = null;
            }
        }

        return [
            'id' => (string) $row->id,
            'label' => $row->label,
            'location_kind' => $row->location_kind,
            'is_primary' => (bool) $row->is_primary,
            'formatted_address' => $row->formatted_address,
            'latitude' => round((float) $row->latitude, 6),
            'longitude' => round((float) $row->longitude, 6),
            'source' => $row->source,
            'address_version' => (int) $row->address_version,
            'components' => ['street' => $row->street, 'barangay' => $row->barangay, 'city_municipality' => $row->city_municipality, 'province' => $row->province, 'postal_code' => $row->postal_code],
            'psgc' => $this->psgcResource((string) $row->psgc_resolution, $row->psgc_version,
                ['region' => [$row->region_code, $row->region_name], 'province' => [$row->province_code, $row->province], 'city_municipality' => [$row->city_code, $row->city_municipality], 'barangay' => [$row->psgc_code, $row->barangay]], null),
            'contact_name' => $row->contact_name,
            'contact_phone_e164' => $row->contact_phone_e164,
            'site_instructions' => $instructions,
            'lock_version' => (int) $row->lock_version,
            'updated_at' => Carbon::parse((string) $row->updated_at)->toIso8601String(),
        ];
    }

    /**
     * @param  array<string, array{0: mixed, 1: mixed}>  $levels
     * @return array<string, mixed>
     */
    private function psgcResource(string $resolution, ?string $version, array $levels, ?string $reason): array
    {
        $result = ['resolution' => $resolution, 'version' => $version, 'reason' => $reason];
        foreach ($levels as $level => [$code, $name]) {
            $result[$level] = $code === null ? null : ['code' => (string) $code, 'name' => $name === null ? null : (string) $name];
        }

        return $result;
    }

    private function clean(mixed $value, int $max): ?string
    {
        if (! is_string($value)) {
            return null;
        }
        $value = trim((string) preg_replace('/\s+/u', ' ', strip_tags($value)));

        return $value === '' ? null : mb_substr($value, 0, $max);
    }
}
