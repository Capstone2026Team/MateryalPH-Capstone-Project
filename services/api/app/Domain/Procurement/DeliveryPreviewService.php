<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\DeliveryRecommendationService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Site Delivery preview for one Vendor group. The vehicle endpoint is the intended destination, or the
 * alternate drop-off when the Buyer declared a heavy-vehicle restriction; both stay labelled. Coverage is the
 * Vendor's stated straight-line area from its store point; the fee basis is the road route from the store to
 * the vehicle endpoint. Vehicle count, trips and fee come from the Phase 5 advisory service and are always an
 * ESTIMATE: the authorized confirmed offer exists only after Owner/Manager confirmation (Phase 8), so
 * confirmed_offer is null here. Missing measurements or no eligible vehicle stay a manual-review state; an
 * endpoint outside coverage or an unconfirmable route is a blocker, never a made-up distance or zero fee.
 */
final class DeliveryPreviewService
{
    public const ROUTE_BASIS = 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF';

    /** The advisory service evaluates at most 20 load groups; a larger mixed load is reviewed by the Vendor. */
    public const MAX_LOAD_GROUPS = 20;

    public function __construct(private readonly RouteProvider $routes, private readonly DeliveryRecommendationService $recommendations) {}

    /** @return array<string, mixed> The delivery block for a Self-Pickup group, with the same fields as a preview. */
    public static function notApplicable(): array
    {
        return ['status' => 'NOT_APPLICABLE', 'issues' => [], 'endpoint' => null, 'route' => null, 'straight_line_meters' => null, 'coverage_km' => null,
            'estimate' => null, 'manual_review_reasons' => [], 'confirmed_offer' => null, 'calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION, 'notice' => null];
    }

    /**
     * @param  array<string, mixed>  $destination  CartService::destination() including _points
     * @param  list<array<string, mixed>>  $lines  valid cart lines of this group
     * @return array<string, mixed>
     */
    public function preview(string $organizationId, array $destination, array $lines): array
    {
        $base = ['status' => 'ACTION_REQUIRED', 'issues' => [], 'endpoint' => $destination['vehicle_endpoint'], 'route' => null, 'straight_line_meters' => null, 'coverage_km' => null,
            'estimate' => null, 'manual_review_reasons' => [], 'confirmed_offer' => null, 'calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION,
            'notice' => 'Estimate only. The Vendor confirms vehicles, trips, the drop-off and the final delivery fee before you pay.'];
        $points = $destination['_points'];
        $restriction = (string) $destination['heavy_vehicle_restriction'];
        $issue = match (true) {
            $points['intended'] === null => ['DESTINATION_REQUIRED', 'Choose where this delivery is going.'],
            ! $points['intended']['active'] => ['DESTINATION_UNAVAILABLE', 'The chosen delivery location was removed. Choose it again or pick another; it is never replaced automatically.'],
            $restriction === 'UNANSWERED' => ['HEAVY_ACCESS_ANSWER_REQUIRED', 'Tell us whether you know of a heavy-vehicle restriction at the site.'],
            $restriction === 'YES' && ($points['alternate'] === null || ! $points['alternate']['active']) => ['ALTERNATE_DROP_OFF_REQUIRED', 'Choose an alternative drop-off that delivery vehicles can reach.'],
            default => null,
        };
        if ($issue !== null) {
            return array_replace($base, ['issues' => [['code' => $issue[0], 'severity' => CartService::ACTION_REQUIRED, 'message' => $issue[1]]]]);
        }
        $endpoint = $restriction === 'YES' ? $points['alternate'] : $points['intended'];
        $store = DB::table('vendor_addresses as va')->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')->where('va.vendor_organization_id', $organizationId)->whereNotNull('av.location')
            ->selectRaw('av.id, av.latitude, av.longitude, ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography) AS straight_line', [$endpoint['longitude'], $endpoint['latitude']])->first();
        $coverage = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->max('maximum_distance_km');
        if ($store === null || $coverage === null) {
            return array_replace($base, ['status' => 'BLOCKED', 'issues' => [['code' => 'DELIVERY_NOT_OFFERED', 'severity' => CartService::BLOCKING, 'message' => 'This store is not offering Site Delivery right now. Choose Self-Pickup if available.']]]);
        }
        $straight = (int) round((float) $store->straight_line);
        $base['straight_line_meters'] = $straight;
        $base['coverage_km'] = (int) $coverage;
        if ((float) $store->straight_line > (int) $coverage * 1000 + RadiusPolicy::BOUNDARY_TOLERANCE_METERS) {
            return array_replace($base, ['status' => 'BLOCKED', 'issues' => [['code' => 'OUTSIDE_DELIVERY_COVERAGE', 'severity' => CartService::BLOCKING,
                'message' => sprintf('The vehicle drop-off is %s km from the store, beyond its %d km delivery area. Choose another drop-off or Self-Pickup.', number_format($straight / 1000, 1), (int) $coverage)]]]);
        }
        $route = $this->route((string) $store->id, (float) $store->latitude, (float) $store->longitude, $endpoint);
        if (is_string($route)) {
            return array_replace($base, ['status' => 'BLOCKED', 'issues' => [['code' => $route, 'severity' => CartService::BLOCKING,
                'message' => $route === 'ROUTE_NOT_FOUND' ? 'No driving route to the vehicle drop-off was found. Choose another drop-off or Self-Pickup.' : 'The delivery route could not be confirmed right now. Retry, or choose Self-Pickup.']]]);
        }
        $base['route'] = $route;
        if (count($lines) > self::MAX_LOAD_GROUPS) {
            return array_replace($base, ['status' => 'MANUAL_REVIEW', 'manual_review_reasons' => ['TOO_MANY_LOAD_GROUPS'], 'issues' => [['code' => 'DELIVERY_MANUAL_REVIEW', 'severity' => CartService::INFO,
                'message' => 'The Vendor must review this load manually. Vehicles, trips and the delivery fee will be shown after the Vendor confirms.']]]);
        }
        $load = [
            'distance_meters' => $route['distance_meters'], 'route_source' => 'GOOGLE_ROUTES',
            'heavy_vehicle_restriction' => $restriction === 'YES',
            'intended_location' => ['latitude' => $points['intended']['latitude'], 'longitude' => $points['intended']['longitude']],
            'route_destination' => ['latitude' => $endpoint['latitude'], 'longitude' => $endpoint['longitude']],
            // The Buyer answered the restriction question; the declared endpoint is the one vehicles use.
            'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true,
            'groups' => array_map(fn (array $line): array => $this->loadGroup($line), $lines),
        ];
        if ($restriction === 'YES') {
            $load['alternative_drop_off'] = ['latitude' => $endpoint['latitude'], 'longitude' => $endpoint['longitude']];
        }
        $result = $this->recommendations->evaluate($this->recommendations->eligibleVehicles($organizationId), $load);
        if ($result['status'] !== 'CANDIDATES_AVAILABLE') {
            $reasons = $result['status'] === 'NO_ELIGIBLE_VEHICLE' ? ['NO_ELIGIBLE_VEHICLE'] : [];
            foreach ($result['groups'] as $group) {
                array_push($reasons, ...($group['manual_review_reasons'] ?? []));
            }

            return array_replace($base, ['status' => 'MANUAL_REVIEW', 'manual_review_reasons' => array_values(array_unique($reasons)), 'issues' => [['code' => 'DELIVERY_MANUAL_REVIEW', 'severity' => CartService::INFO,
                'message' => 'The Vendor must review this load manually. Vehicles, trips and the delivery fee will be shown after the Vendor confirms.']]]);
        }

        return array_replace($base, ['status' => 'ADVISORY_ESTIMATE', 'estimate' => $this->summarize($result['groups'])]);
    }

    /**
     * One load group per cart line: identical units of ordinary cargo with the variant's own per-unit weight
     * and dimensions. Unknown values stay unknown so the advisory service names the manual-review reason.
     *
     * @param  array<string, mixed>  $line
     * @return array<string, mixed>
     */
    private function loadGroup(array $line): array
    {
        return self::loadGroupFor((string) $line['id'], (string) $line['quantity'], $line['load']);
    }

    /**
     * One ordinary-cargo load group for a quantity of identical units; unknown measurements stay unknown.
     *
     * @param  array{weight_kg: ?string, length_cm: ?string, width_cm: ?string, height_cm: ?string}  $load
     * @return array<string, mixed>
     */
    public static function loadGroupFor(string $key, string $quantity, array $load): array
    {
        $whole = bccomp($quantity, bcadd($quantity, '0', 0), 4) === 0;
        $cm = static fn (?string $value): ?float => $value === null ? null : (float) $value / 100;

        return ['key' => $key, 'material_kind' => DeliveryRecommendationService::CARGO,
            'weight_kg' => $load['weight_kg'] === null ? null : (float) bcmul((string) $load['weight_kg'], $quantity, 4),
            'unit_count' => $whole ? (int) $quantity : null,
            'length_m' => $cm($load['length_cm']), 'width_m' => $cm($load['width_cm']), 'height_m' => $cm($load['height_cm'])];
    }

    /**
     * Road route from the store's current verified address version to a vehicle endpoint, with the same cache
     * and basis as the preview. Returns ROUTE_UNAVAILABLE / ROUTE_NOT_FOUND / STORE_ADDRESS_UNAVAILABLE on failure.
     *
     * @param  array{latitude: float, longitude: float, address_id: string}  $endpoint
     * @return array<string, mixed>|string
     */
    public function routeFromStore(string $organizationId, array $endpoint): array|string
    {
        $store = DB::table('vendor_addresses as va')->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')->where('va.vendor_organization_id', $organizationId)
            ->whereNotNull('av.location')->first(['av.id', 'av.latitude', 'av.longitude']);
        if ($store === null) {
            return 'STORE_ADDRESS_UNAVAILABLE';
        }
        $route = $this->route((string) $store->id, (float) $store->latitude, (float) $store->longitude, $endpoint);

        return is_array($route) ? $route + ['store_address_version_id' => (string) $store->id] : $route;
    }

    /**
     * Range across the advisory alternatives per load group; no single vehicle is chosen for the Vendor.
     *
     * @param  list<array<string, mixed>>  $groups
     * @return array<string, mixed>
     */
    private function summarize(array $groups): array
    {
        $summary = ['fee_min_centavos' => 0, 'fee_max_centavos' => 0, 'trips_min' => 0, 'trips_max' => 0, 'vehicles_min' => 0, 'vehicles_max' => 0, 'options' => []];
        foreach ($groups as $group) {
            $fees = array_column($group['candidates'], 'estimated_charge_centavos');
            $trips = array_column($group['candidates'], 'total_vehicle_trips');
            $vehicles = array_column($group['candidates'], 'number_of_vehicles');
            $summary['fee_min_centavos'] += min($fees);
            $summary['fee_max_centavos'] += max($fees);
            $summary['trips_min'] += min($trips);
            $summary['trips_max'] += max($trips);
            $summary['vehicles_min'] += min($vehicles);
            $summary['vehicles_max'] += max($vehicles);
            foreach ($group['candidates'] as $candidate) {
                $vehicle = $candidate['vehicle'];
                $summary['options'][] = ['load_key' => (string) $group['key'], 'vehicle_name' => (string) $vehicle['name'], 'vehicle_type' => (string) $vehicle['vehicle_type'],
                    'vehicles' => (int) $candidate['number_of_vehicles'], 'trips' => (int) $candidate['total_vehicle_trips'], 'fee_centavos' => (int) $candidate['estimated_charge_centavos'],
                    'fee_per_trip_centavos' => (int) $candidate['fee']['per_trip_centavos']];
            }
        }

        return $summary;
    }

    /**
     * @param  array{latitude: float, longitude: float, address_id: string}  $endpoint
     * @return array<string, mixed>|string route payload, or ROUTE_UNAVAILABLE / ROUTE_NOT_FOUND
     */
    private function route(string $storeVersionId, float $latitude, float $longitude, array $endpoint): array|string
    {
        $key = hash('sha256', 'route|delivery|v1|'.$storeVersionId.'|'.$endpoint['address_id']);
        $cached = DB::table('route_cache_entries')->where('cache_key_hash', $key)->where('kind', 'ROUTE')->where('expires_at', '>', now())->first();
        $payload = $cached === null ? null : json_decode((string) $cached->payload, true);
        if (is_array($payload)) {
            return $payload + ['cached' => true];
        }
        try {
            $route = $this->routes->drive($latitude, $longitude, $endpoint['latitude'], $endpoint['longitude']);
        } catch (GeographyProviderUnavailable) {
            return 'ROUTE_UNAVAILABLE';
        }
        if ($route === null) {
            return 'ROUTE_NOT_FOUND';
        }
        $payload = ['distance_meters' => (int) $route['distance_meters'], 'duration_seconds' => (int) $route['duration_seconds'], 'basis' => self::ROUTE_BASIS, 'source' => 'GOOGLE_ROUTES', 'computed_at' => now()->toIso8601String()];
        $ttl = max(1, min(1440, (int) config('services.google_maps.routes.cache_ttl_minutes', 10)));
        DB::table('route_cache_entries')->upsert([['id' => (string) Str::uuid7(), 'cache_key_hash' => $key, 'kind' => 'ROUTE', 'provider' => 'GOOGLE',
            'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'expires_at' => now()->addMinutes($ttl), 'created_at' => now(), 'updated_at' => now()]],
            ['cache_key_hash'], ['payload', 'expires_at', 'created_at', 'updated_at']);

        return $payload + ['cached' => false];
    }
}
