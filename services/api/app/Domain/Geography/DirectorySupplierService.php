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

    public function __construct(private readonly PlacesProvider $places) {}

    /**
     * Directory rows inside the exact scope radius, refreshing uncached search cells first.
     *
     * @return array{rows: list<object>, status: string, as_of: ?string}
     */
    public function within(GeographyScope $scope): array
    {
        $cells = $this->cells($scope);
        $cached = DB::table('place_cache_entries')->whereIn('cache_key_hash', array_column($cells, 'key'))
            ->where('kind', 'SEARCH_CELL')->where('expires_at', '>', now())->pluck('cache_key_hash')->flip()->all();
        $missing = array_values(array_filter($cells, static fn (array $cell): bool => ! isset($cached[$cell['key']])));
        $status = 'AVAILABLE';
        if ($missing !== []) {
            try {
                // Keep successful cells if a later batch hits a provider limit; failed cells stay
                // uncached and can be retried. No transaction spans a provider request.
                foreach (array_chunk($missing, 16) as $batch) {
                    $places = $this->places->nearby(array_map(static fn (array $cell): array => array_intersect_key($cell, array_flip(['latitude', 'longitude', 'radius_meters'])), $batch));
                    $this->store($batch, $places);
                }
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
        // Details include photos/reviews: fetch on demand and never persist the provider payload.
        try {
            $details = $this->places->details((string) $row->google_place_id);
        } catch (GeographyProviderUnavailable $unavailable) {
            throw new AuthenticationException('PLACES_UNAVAILABLE', 'Directory details are temporarily unavailable. Verified Vendors remain available.', 503, ['reason' => $unavailable->reason]);
        }
        if ($details === null) {
            throw new AuthenticationException('DIRECTORY_SUPPLIER_NOT_FOUND', 'Google no longer lists this place. Refresh the map.', 404);
        }
        $fetchedAt = now();
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
            'name' => $details['name'],
            'formatted_address' => $details['formatted_address'] ?? $row->formatted_address,
            'marker' => ['latitude' => round((float) $row->latitude, 5), 'longitude' => round((float) $row->longitude, 5)],
            'public_phone' => $details['national_phone'] ?? null,
            'website_uri' => $details['website_uri'] ?? null,
            'google_maps_uri' => $details['google_maps_uri'] ?? null,
            'open_now' => $details['open_now'] ?? null,
            'next_close_time' => $details['next_close_time'] ?? null,
            'photos' => $details['photos'] ?? [],
            'reviews' => $details['reviews'] ?? [],
            'attributes' => $details['attributes'] ?? [],
            'provider_attributions' => $details['provider_attributions'] ?? [],
            'opening_hours' => $details['weekday_descriptions'],
            'google_rating' => ($details['rating'] ?? null) === null ? null : ['source' => 'GOOGLE', 'label' => 'Google rating', 'value' => number_format((float) $details['rating'], 1, '.', ''), 'count' => $details['user_rating_count'] ?? null],
            'attribution' => self::ATTRIBUTION,
            'fetched_at' => Carbon::parse((string) $fetchedAt)->toIso8601String(),
            'actions' => $actions,
        ];
    }

    /** @return array<string, mixed> */
    public function thumbnail(string $directorySupplierId): array
    {
        $row = Str::isUuid($directorySupplierId) ? $this->visible()->where('d.id', $directorySupplierId)->first(['d.google_place_id']) : null;
        if ($row === null) {
            throw new AuthenticationException('DIRECTORY_SUPPLIER_NOT_FOUND', 'This Directory Supplier is no longer available. Refresh the map.', 404);
        }
        try {
            return $this->places->thumbnail((string) $row->google_place_id);
        } catch (GeographyProviderUnavailable $unavailable) {
            throw new AuthenticationException('PLACES_UNAVAILABLE', 'The supplier photo is temporarily unavailable.', 503, ['reason' => $unavailable->reason]);
        }
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
     * A radius-aware grid of overlapping circles. Start with 10 km squares, including every square
     * intersecting the selected circle. If the configured budget is smaller, enlarge the squares;
     * never truncate the grid and silently omit the outer area. Exact membership remains PostGIS.
     * Coordinates are snapped only for shared cache keys and covered by padding. Upstream ranking
     * and the 20-result cap still prevent any claim of complete supplier coverage.
     *
     * @return list<array{key: string, latitude: float, longitude: float, radius_meters: int}>
     */
    public function cells(GeographyScope $scope): array
    {
        $radius = $scope->radiusMeters();
        $maximum = max(1, min(121, (int) config('services.google_maps.places.max_search_cells', 121)));
        $latitude = round((float) $scope->latitude, 2);
        $longitude = round((float) $scope->longitude, 2);
        $spacing = 10000.0;
        do {
            $circles = [];
            $steps = (int) ceil($radius / $spacing + 0.5);
            for ($y = -$steps; $y <= $steps; $y++) {
                for ($x = -$steps; $x <= $steps; $x++) {
                    // Distance to the nearest point of the square, not just its centre.
                    if (hypot(max(0, abs($x * $spacing) - $spacing / 2), max(0, abs($y * $spacing) - $spacing / 2)) > $radius) {
                        continue;
                    }
                    $circles[] = [
                        $latitude + rad2deg($y * $spacing / 6371000),
                        $longitude + rad2deg($x * $spacing / (6371000 * cos(deg2rad($latitude)))),
                        min(50000, (int) ceil($spacing / sqrt(2)) + 1600),
                    ];
                }
            }
            $spacing *= 1.25;
        } while (count($circles) > $maximum);
        if (count($circles) === 1) {
            // Preserve the exact origin at 50 km: Google's maximum circle cannot be padded.
            $circles = [[(float) $scope->latitude, (float) $scope->longitude, $radius]];
        }
        $types = implode(',', (array) config('services.google_maps.places.included_types', []));

        return array_map(static fn (array $circle): array => [
            'key' => hash('sha256', 'cell|v3|'.implode('|', $circle).'|'.$types),
            'latitude' => round($circle[0], 6), 'longitude' => round($circle[1], 6), 'radius_meters' => $circle[2],
        ], $circles);
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
