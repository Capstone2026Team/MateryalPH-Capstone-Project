<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Vendors\DeliveryRecommendationService;

/**
 * Builds the delivery load for a child order from its frozen line snapshots and confirmed quantities, and the
 * route from the store's current address version to the order's frozen vehicle endpoint. The intended
 * destination and the alternate drop-off stay separate; the alternate is the endpoint only for a declared
 * heavy-vehicle restriction. Advisory output is never a confirmation.
 */
final class OrderDeliveryPlanner
{
    public function __construct(private readonly DeliveryPreviewService $preview, private readonly DeliveryRecommendationService $recommendations) {}

    /** @return array<string, mixed> The order's frozen destination snapshot. */
    public static function destination(object $order): array
    {
        $destination = json_decode((string) ($order->destination ?? '{}'), true);

        return is_array($destination) ? $destination : [];
    }

    /** @return array<string, mixed>|null the endpoint point, or null for Self-Pickup */
    public static function endpoint(object $order): ?array
    {
        $destination = self::destination($order);
        if (($destination['type'] ?? null) !== 'DELIVERY') {
            return null;
        }

        return $destination['heavy_vehicle_restriction'] === 'YES' ? $destination['alternate_drop_off'] : $destination['intended'];
    }

    /**
     * Route lookup, made before any database lock.
     *
     * @return array<string, mixed>
     */
    public function route(object $order): array
    {
        $endpoint = self::endpoint($order);
        if ($endpoint === null) {
            throw new AuthenticationException('DELIVERY_NOT_APPLICABLE', 'This is a Self-Pickup order.', 409);
        }
        $route = $this->preview->routeFromStore((string) $order->vendor_organization_id, ['latitude' => (float) $endpoint['latitude'], 'longitude' => (float) $endpoint['longitude'], 'address_id' => (string) $endpoint['address_id']]);
        if (is_string($route)) {
            throw new AuthenticationException('DELIVERY_ROUTE_UNAVAILABLE', $route === 'ROUTE_NOT_FOUND' ? 'No driving route to the vehicle drop-off was found. Decline or contact the Buyer.' : 'The delivery route could not be confirmed right now. Retry in a moment.', $route === 'ROUTE_NOT_FOUND' ? 422 : 503, ['reason' => $route]);
        }

        return $route;
    }

    /**
     * @param  list<object>  $lines
     * @param  array<string, string>  $quantities  line id => confirmed quantity
     * @param  array<string, mixed>  $route
     * @return array<string, mixed>
     */
    public function load(object $order, array $lines, array $quantities, array $route, bool $siteAccessConfirmed, bool $heavyAccessConfirmed): array
    {
        $destination = self::destination($order);
        $restricted = ($destination['heavy_vehicle_restriction'] ?? 'NO') === 'YES';
        $endpoint = self::endpoint($order);
        $describe = static fn (?array $point): ?array => $point === null ? null : ['latitude' => (float) $point['latitude'], 'longitude' => (float) $point['longitude'],
            'label' => $point['label'] ?? null, 'formatted_address' => $point['formatted_address'] ?? null, 'location_id' => $point['location_id'] ?? null, 'kind' => $point['kind'] ?? null];
        $groups = [];
        foreach ($lines as $line) {
            $quantity = StockAvailability::quantity($quantities[(string) $line->id] ?? $line->quantity);
            if (bccomp($quantity, '0', 4) <= 0) {
                continue;
            }
            $snapshot = json_decode((string) $line->snapshot, true);
            $groups[] = DeliveryPreviewService::loadGroupFor((string) $line->id, $quantity, is_array($snapshot) && is_array($snapshot['load'] ?? null) ? $snapshot['load'] + ['weight_kg' => null, 'length_cm' => null, 'width_cm' => null, 'height_cm' => null] : ['weight_kg' => null, 'length_cm' => null, 'width_cm' => null, 'height_cm' => null]);
        }
        $load = [
            'distance_meters' => (int) $route['distance_meters'], 'route_source' => (string) ($route['source'] ?? 'GOOGLE_ROUTES'),
            'heavy_vehicle_restriction' => $restricted, 'intended_location' => $describe($destination['intended'] ?? null),
            'route_destination' => ['latitude' => (float) $endpoint['latitude'], 'longitude' => (float) $endpoint['longitude']],
            'site_access_confirmed' => $siteAccessConfirmed, 'heavy_vehicle_access_confirmed' => $heavyAccessConfirmed, 'groups' => $groups,
        ];
        if ($restricted) {
            $load['alternative_drop_off'] = $describe($destination['alternate_drop_off'] ?? null);
        }

        return $load;
    }

    /**
     * Advisory vehicle options for the Vendor's confirmation workspace. Coordinates never leave the server.
     *
     * @param  array<string, mixed>  $load
     * @param  array<string, mixed>  $route
     * @param  list<object>  $lines
     * @return array<string, mixed>
     */
    public function advise(object $order, array $load, array $route, array $lines): array
    {
        $vehicles = $this->recommendations->eligibleVehicles((string) $order->vendor_organization_id);
        $evaluation = $this->recommendations->evaluate($vehicles, $load);
        $names = [];
        foreach ($lines as $line) {
            $snapshot = json_decode((string) $line->snapshot, true);
            $names[(string) $line->id] = is_array($snapshot) ? (string) ($snapshot['display_name'] ?? '') : '';
        }
        $distance = (int) $load['distance_meters'];
        $vehicleView = static fn (array $vehicle): array => [
            'vehicle_id' => (string) $vehicle['id'], 'name' => (string) $vehicle['name'], 'vehicle_category' => $vehicle['vehicle_category'] ?? null, 'vehicle_type' => (string) $vehicle['vehicle_type'],
            'custom_type_name' => $vehicle['custom_type_name'] ?? null, 'brand' => $vehicle['brand'] ?? null, 'number_available' => (int) $vehicle['number_available'],
            'capacity_kg' => (string) $vehicle['capacity_kg'], 'mixer_capacity_m3' => $vehicle['mixer_capacity_m3'] === null ? null : (string) $vehicle['mixer_capacity_m3'],
            'heavy_classification' => (string) $vehicle['heavy_classification'], 'maximum_distance_km' => (int) $vehicle['maximum_distance_km'],
            'base_fee_centavos' => (int) $vehicle['base_fee_centavos'], 'per_km_centavos' => (int) $vehicle['per_km_centavos'],
            'per_trip_centavos' => DeliveryRecommendationService::feePerTripCentavos((int) $vehicle['base_fee_centavos'], (int) $vehicle['per_km_centavos'], $distance),
            'within_range' => $distance <= (int) $vehicle['maximum_distance_km'] * 1000, 'rate_version' => (int) $vehicle['rate_version'], 'configuration_version' => (int) $vehicle['configuration_version'],
        ];
        $destination = self::destination($order);

        return [
            'advisory' => true, 'status' => $evaluation['status'], 'reason' => $evaluation['reason'],
            'route' => ['distance_meters' => $distance, 'duration_seconds' => (int) ($route['duration_seconds'] ?? 0), 'basis' => DeliveryPreviewService::ROUTE_BASIS, 'source' => (string) ($route['source'] ?? 'GOOGLE_ROUTES')],
            'endpoint' => ['kind' => $destination['vehicle_endpoint'] ?? null, 'heavy_vehicle_restriction' => $destination['heavy_vehicle_restriction'] ?? null,
                'intended' => self::publicPoint($destination['intended'] ?? null), 'alternate_drop_off' => self::publicPoint($destination['alternate_drop_off'] ?? null)],
            'groups' => array_map(static fn (array $group): array => [
                'key' => (string) $group['key'], 'label' => $names[(string) $group['key']] ?? (string) $group['key'], 'status' => (string) $group['status'],
                'manual_review_reasons' => $group['manual_review_reasons'] ?? [],
                'candidates' => array_map(static fn (array $candidate): array => $vehicleView($candidate['vehicle']) + [
                    'number_of_vehicles' => (int) $candidate['number_of_vehicles'], 'total_vehicle_trips' => (int) $candidate['total_vehicle_trips'],
                    'estimated_charge_centavos' => (int) $candidate['estimated_charge_centavos'], 'limiting_factor' => (string) $candidate['limiting_factor'],
                ], $group['candidates'] ?? []),
            ], $evaluation['groups']),
            'eligible_vehicles' => array_map($vehicleView, $vehicles),
            'fee_formula' => ['calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION, 'rounding' => DeliveryRecommendationService::FEE_ROUNDING, 'final_fee_rule' => 'SUM_PER_TRIP_FEE_TIMES_TRIPS'],
            'notice' => 'Advisory only. You confirm the vehicles, trips, drop-off, date and final fee; the Buyer approves them before payment.',
        ];
    }

    /**
     * A Buyer/Vendor-safe point: label and formatted address, never coordinates.
     *
     * @param  array<string, mixed>|null  $point
     * @return array<string, mixed>|null
     */
    public static function publicPoint(?array $point): ?array
    {
        return $point === null ? null : ['location_id' => $point['location_id'] ?? null, 'label' => $point['label'] ?? null, 'kind' => $point['kind'] ?? null, 'formatted_address' => $point['formatted_address'] ?? null];
    }
}
