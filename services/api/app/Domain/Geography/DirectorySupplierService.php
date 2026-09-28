<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Tier 1 Directory Suppliers from Google Places. Informational only: no listings, messages, orders, reviews,
 * payments, VPS or storefront. Search results are cached per bounded search cell and every stored record
 * expires within the configured target (hard ceiling 30 days); expired content is never served. A verified
 * Tier 2 store claiming the same Place ID suppresses the Tier 1 record.
 */
final class DirectorySupplierService
{
    public const ATTRIBUTION = ['provider' => 'GOOGLE', 'text' => 'Source: Google Maps. Directory information may be outdated.'];

    /** Bumped whenever the Place Details field mask changes so older cached payloads are never reused. */
    public const DETAILS_FIELDS_VERSION = 'details.v1';

    public function __construct(private readonly PlacesProvider $places) {}

    /**
     * Directory rows inside the exact scope radius, refreshing uncached search cells first.
     *
     * @return array{rows: list<object>, status: string, as_of: ?string}
     */
    public function within(GeographyScope $scope): array
    {
        $cells = $this->cells($scope);
        $missing = array_values(array_filter($cells, fn (array $cell): bool => ! DB::table('place_cache_entries')->where('cache_key_hash', $cell['key'])->where('kind', 'SEARCH_CELL')->where('expires_at', '>', now())->exists()));
        $status = 'AVAILABLE';
        if ($missing !== []) {
            try {
                $this->store($missing, $this->places->nearby(array_map(static fn (array $cell): array => array_intersect_key($cell, array_flip(['latitude', 'longitude', 'radius_meters'])), $missing)));
            } catch (GeographyProviderUnavailable $unavailable) {
                $status = $unavailable->reason === 'NOT_CONFIGURED' ? 'NOT_CONFIGURED' : 'UNAVAILABLE';
            }
        }
        $rows = $this->visible()->whereRaw('ST_DWithin(d.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)', [$scope->longitude, $scope->latitude, $scope->membershipMeters()])
            ->selectRaw('d.id, d.name, d.formatted_address, d.primary_type, d.latitude, d.longitude, d.refreshed_at, ST_Distance(d.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography) AS distance_meters', [$scope->longitude, $scope->latitude])
            ->get()->all();
        if ($status !== 'AVAILABLE' && $rows !== []) {
            $status = 'CACHED';
        }
        $asOf = collect($rows)->min('refreshed_at');

        return ['rows' => $rows, 'status' => $status, 'as_of' => $asOf === null ? null : Carbon::parse((string) $asOf)->toIso8601String()];
    }

    /** @return array<string, mixed> */
    public function details(string $directorySupplierId): array
    {
        $row = Str::isUuid($directorySupplierId) ? $this->visible()->where('d.id', $directorySupplierId)->first(['d.id', 'd.google_place_id', 'd.name', 'd.formatted_address', 'd.latitude', 'd.longitude', 'd.refreshed_at']) : null;
        if ($row === null) {
            throw new AuthenticationException('DIRECTORY_SUPPLIER_NOT_FOUND', 'This Directory Supplier is no longer available. Refresh the map.', 404);
        }
        $key = hash('sha256', 'details|'.self::DETAILS_FIELDS_VERSION.'|'.$row->google_place_id);
        $cached = DB::table('place_cache_entries')->where('cache_key_hash', $key)->where('kind', 'PLACE_DETAILS')->where('expires_at', '>', now())->first();
        $details = $cached === null ? null : json_decode((string) $cached->payload, true);
        $fetchedAt = $cached?->updated_at;
        if (! is_array($details)) {
            try {
                $details = $this->places->details((string) $row->google_place_id);
            } catch (GeographyProviderUnavailable $unavailable) {
                throw new AuthenticationException('PLACES_UNAVAILABLE', 'Directory details are temporarily unavailable. Verified Vendors remain available.', 503, ['reason' => $unavailable->reason]);
            }
            if ($details === null) {
                throw new AuthenticationException('DIRECTORY_SUPPLIER_NOT_FOUND', 'Google no longer lists this place. Refresh the map.', 404);
            }
            $fetchedAt = now();
            DB::table('place_cache_entries')->upsert([['id' => (string) Str::uuid7(), 'cache_key_hash' => $key, 'kind' => 'PLACE_DETAILS', 'provider' => 'GOOGLE',
                'payload' => json_encode($details, JSON_THROW_ON_ERROR), 'expires_at' => now()->addHours($this->ttlHours()), 'created_at' => now(), 'updated_at' => now()]],
                ['cache_key_hash'], ['payload', 'expires_at', 'created_at', 'updated_at']);
        }
        $actions = array_values(array_filter([
            ($details['national_phone'] ?? null) !== null ? 'CALL' : null,
            'OPEN_IN_MAPS',
            ($details['website_uri'] ?? null) !== null ? 'WEBSITE' : null,
            'SHARE',
        ]));

        return [
            'result_id' => (string) $row->id,
            'tier' => 'DIRECTORY_SUPPLIER',
            'tier_label' => 'Directory Supplier',
            'name' => (string) ($details['name'] ?? $row->name),
            'formatted_address' => $details['formatted_address'] ?? $row->formatted_address,
            'marker' => ['latitude' => round((float) $row->latitude, 5), 'longitude' => round((float) $row->longitude, 5)],
            'public_phone' => $details['national_phone'] ?? null,
            'website_uri' => $details['website_uri'] ?? null,
            'google_maps_uri' => $details['google_maps_uri'] ?? null,
            'opening_hours' => array_values($details['weekday_descriptions'] ?? []),
            'google_rating' => ($details['rating'] ?? null) === null ? null : ['source' => 'GOOGLE', 'label' => 'Google rating', 'value' => number_format((float) $details['rating'], 1, '.', ''), 'count' => $details['user_rating_count'] ?? null],
            'attribution' => self::ATTRIBUTION,
            'fetched_at' => Carbon::parse((string) $fetchedAt)->toIso8601String(),
            'actions' => $actions,
        ];
    }

    /** Unexpired, unsuppressed Directory Supplier rows (alias d). */
    public function visible(): Builder
    {
        return DB::table('directory_suppliers as d')
            ->where('d.expires_at', '>', now())->whereNotNull('d.location')
            ->where(fn (Builder $claim) => $claim->whereNull('d.claimed_vendor_organization_id')->orWhereNotExists(fn (Builder $tier2) => $tier2->selectRaw('1')->from('vendor_organizations as co')
                ->whereColumn('co.id', 'd.claimed_vendor_organization_id')->where('co.store_activation_status', 'ACTIVE')))
            ->whereNotExists(fn (Builder $tier2) => $tier2->selectRaw('1')->from('addresses as a')->join('vendor_organizations as vo', 'vo.id', '=', 'a.owner_id')
                ->where('a.owner_type', 'VENDOR_ORGANIZATION')->where('a.is_current', true)->where('vo.store_activation_status', 'ACTIVE')
                ->whereColumn('a.provider_place_id', 'd.google_place_id'));
    }

    /**
     * Bounded search cells: a centre circle (half the radius) plus a ring of overlapping circles (55% of the
     * radius) centred at 65% of the radius, capped by configuration (one circle when capped at 1). With the
     * default six ring cells every point up to the radius boundary lies inside a cell. A provider search returns
     * at most 20 places per cell, so a single circle only ever showed the places nearest the centre; the ring
     * spreads results across the whole radius. Cell centres are rounded (~1 km, covered by the padding) so
     * nearby Buyers share cache entries; the exact scope radius is applied afterwards with ST_DWithin. This
     * improves coverage but is not a census.
     *
     * @return list<array{key: string, latitude: float, longitude: float, radius_meters: int}>
     */
    public function cells(GeographyScope $scope): array
    {
        $latitude = round((float) $scope->latitude, 2);
        $longitude = round((float) $scope->longitude, 2);
        $radius = $scope->radiusMeters();
        $maximum = max(1, min(7, (int) config('services.google_maps.places.max_search_cells', 7)));
        $pad = 1600;
        $ring = $maximum > 1;
        $circles = [[$latitude, $longitude, $ring ? (int) ($radius / 2) + $pad : min(50000, $radius + $pad)]];
        if ($ring) {
            for ($index = 0; $index < $maximum - 1; $index++) {
                $bearing = deg2rad($index * 360 / ($maximum - 1));
                $distance = $radius * 0.65;
                $circles[] = [
                    $latitude + rad2deg($distance * cos($bearing) / 6371000),
                    $longitude + rad2deg($distance * sin($bearing) / (6371000 * cos(deg2rad($latitude)))),
                    min(50000, (int) ($radius * 0.55) + $pad),
                ];
            }
        }
        $types = implode(',', (array) config('services.google_maps.places.included_types', []));

        return array_map(static fn (array $circle, int $index): array => [
            'key' => hash('sha256', 'cell|v2|'.$latitude.'|'.$longitude.'|'.$radius.'|'.$index.'|'.$types),
            'latitude' => round($circle[0], 6), 'longitude' => round($circle[1], 6), 'radius_meters' => $circle[2],
        ], $circles, array_keys($circles));
    }

    /**
     * @param  list<array{key: string, latitude: float, longitude: float, radius_meters: int}>  $cells
     * @param  list<array{place_id: string, name: string, latitude: float, longitude: float, formatted_address: ?string, primary_type: ?string, business_status: ?string}>  $places
     */
    private function store(array $cells, array $places): void
    {
        $expires = now()->addHours($this->ttlHours());
        DB::transaction(function () use ($cells, $places, $expires): void {
            foreach ($places as $place) {
                if (! PhilippineBounds::contains($place['latitude'], $place['longitude'])) {
                    continue;
                }
                DB::statement('INSERT INTO directory_suppliers (id, google_place_id, name, formatted_address, latitude, longitude, location, primary_type, business_status, refreshed_at, expires_at, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?, ?, now(), ?, now(), now())
                    ON CONFLICT (google_place_id) DO UPDATE SET name = EXCLUDED.name, formatted_address = EXCLUDED.formatted_address, latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude,
                    location = EXCLUDED.location, primary_type = EXCLUDED.primary_type, business_status = EXCLUDED.business_status, refreshed_at = now(), expires_at = EXCLUDED.expires_at, updated_at = now()', [
                    (string) Str::uuid7(), $place['place_id'], $place['name'], $place['formatted_address'], $place['latitude'], $place['longitude'], $place['longitude'], $place['latitude'],
                    $place['primary_type'], $place['business_status'], $expires,
                ]);
            }
            foreach ($cells as $cell) {
                DB::table('place_cache_entries')->upsert([['id' => (string) Str::uuid7(), 'cache_key_hash' => $cell['key'], 'kind' => 'SEARCH_CELL', 'provider' => 'GOOGLE',
                    'payload' => json_encode(['result_count' => count($places)], JSON_THROW_ON_ERROR), 'expires_at' => $expires, 'created_at' => now(), 'updated_at' => now()]],
                    ['cache_key_hash'], ['payload', 'expires_at', 'created_at', 'updated_at']);
            }
        });
    }

    private function ttlHours(): int
    {
        return max(1, min(720, (int) config('services.google_maps.places.cache_ttl_hours', 168)));
    }
}
