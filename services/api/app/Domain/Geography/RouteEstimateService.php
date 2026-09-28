<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * One driving route for the supplier the Buyer selected, from the active origin. Membership was already
 * decided by PostGIS; a route is never requested for every marker and never changes radius membership.
 * Cache keys contain only opaque versions (origin, destination address version, preference), so an origin
 * or store-address change naturally misses the cache. The client applies a response only when the echoed
 * request_version and origin_version still match its current selection.
 */
final class RouteEstimateService
{
    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly PublicVendorProjection $vendors,
        private readonly DirectorySupplierService $directory,
        private readonly RouteProvider $routes,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function estimate(Request $request, array $input): array
    {
        $scope = $this->scopes->forBuyer($this->profiles->idFor($request), $input);
        [$destination, $destinationVersion] = $this->destination($scope, (string) $input['tier'], (string) $input['supplier_id']);
        $straightLine = (int) round((float) $destination->distance_meters);
        if ((float) $destination->distance_meters > $scope->membershipMeters()) {
            throw new AuthenticationException('SUPPLIER_OUTSIDE_RADIUS', 'This supplier is outside the selected radius. Refresh the map.', 422, ['straight_line_meters' => $straightLine]);
        }
        $preference = config('services.google_maps.routes.routing_preference') === 'TRAFFIC_UNAWARE' ? 'TRAFFIC_UNAWARE' : 'TRAFFIC_AWARE';
        $key = hash('sha256', 'route|v1|'.$scope->originVersion.'|'.$input['tier'].'|'.$input['supplier_id'].'|'.$destinationVersion.'|'.$preference);
        $base = ['request_version' => (string) $input['request_version'], 'origin_version' => $scope->originVersion, 'tier' => (string) $input['tier'], 'supplier_id' => (string) $input['supplier_id'], 'straight_line_meters' => $straightLine];

        $cached = DB::table('route_cache_entries')->where('cache_key_hash', $key)->where('kind', 'ROUTE')->where('expires_at', '>', now())->first();
        if ($cached !== null) {
            $payload = json_decode((string) $cached->payload, true);
            if (is_array($payload)) {
                return $base + $payload + ['cached' => true];
            }
        }
        try {
            $route = $this->routes->drive((float) $scope->latitude, (float) $scope->longitude, (float) $destination->latitude, (float) $destination->longitude);
        } catch (GeographyProviderUnavailable $unavailable) {
            throw new AuthenticationException('ROUTE_UNAVAILABLE', 'Driving time is unavailable right now. Straight-line distance is shown instead.', 503, ['straight_line_meters' => $straightLine, 'reason' => $unavailable->reason, 'request_version' => $base['request_version']]);
        }
        if ($route === null) {
            throw new AuthenticationException('ROUTE_NOT_FOUND', 'No driving route was found to this supplier.', 422, ['straight_line_meters' => $straightLine, 'request_version' => $base['request_version']]);
        }
        $payload = $route + ['computed_at' => now()->toIso8601String()];
        $ttl = max(1, min(1440, (int) config('services.google_maps.routes.cache_ttl_minutes', 10)));
        DB::table('route_cache_entries')->upsert([['id' => (string) Str::uuid7(), 'cache_key_hash' => $key, 'kind' => 'ROUTE', 'provider' => 'GOOGLE',
            'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'expires_at' => now()->addMinutes($ttl), 'created_at' => now(), 'updated_at' => now()]],
            ['cache_key_hash'], ['payload', 'expires_at', 'created_at', 'updated_at']);

        return $base + $payload + ['cached' => false];
    }

    /** @return array{0: object, 1: string} */
    private function destination(GeographyScope $scope, string $tier, string $supplierId): array
    {
        $distance = 'ST_Distance(%s, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography) AS distance_meters';
        if ($tier === SupplierDiscoveryService::TIER_VERIFIED) {
            $row = Str::isUuid($supplierId) ? $this->vendors->members()->where('o.id', $supplierId)
                ->selectRaw('av.id AS version_id, av.latitude, av.longitude, '.sprintf($distance, 'av.location'), [$scope->longitude, $scope->latitude])->first() : null;
        } else {
            $row = Str::isUuid($supplierId) ? $this->directory->visible()->where('d.id', $supplierId)
                ->selectRaw("d.google_place_id || ':' || d.refreshed_at AS version_id, d.latitude, d.longitude, ".sprintf($distance, 'd.location'), [$scope->longitude, $scope->latitude])->first() : null;
        }
        if ($row === null) {
            throw new AuthenticationException('SUPPLIER_NOT_FOUND', 'This supplier is no longer available. Refresh the map.', 404);
        }

        return [$row, (string) $row->version_id];
    }
}
