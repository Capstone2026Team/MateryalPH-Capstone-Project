<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/** Internal advisory use case. Callers must authorize the Vendor and obtain an authoritative route to the selected drop-off point. */
final class DeliveryRecommendationService
{
    /** @return list<array<string, mixed>> */
    public function eligibleVehicles(string $organizationId): array
    {
        $coverage = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->value('maximum_distance_km');
        $method = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method');
        if (! in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true) || ! is_numeric($coverage) || (float) $coverage <= 0) {
            return [];
        }
        $vehicles = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->where('active', true)->orderBy('id')->get();
        $result = [];
        foreach ($vehicles as $vehicle) {
            $rate = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicle->id)->where('effective_at', '<=', now())->orderByDesc('version')->first();
            $image = DB::table('files')->where('id', $vehicle->image_file_id)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('purpose', 'VEHICLE_IMAGE')->where('scan_state', 'CLEAN')->exists();
            $row = (array) $vehicle;
            if ($rate === null || ! $image || ! self::complete($row)) {
                continue;
            }
            if ((int) $rate->base_fee_centavos < 0 || (int) $rate->per_km_centavos < 0 || (int) $rate->maximum_distance_km <= 0) {
                continue;
            }
            $result[] = $row + ['rate_version_id' => $rate->id, 'base_fee_centavos' => (int) $rate->base_fee_centavos, 'per_km_centavos' => (int) $rate->per_km_centavos, 'maximum_distance_km' => min((int) $coverage, (int) $rate->maximum_distance_km)];
        }

        return $result;
    }

    /** @param array<string, mixed> $vehicle */
    public static function complete(array $vehicle): bool
    {
        $type = (string) ($vehicle['vehicle_type'] ?? '');
        $category = (string) ($vehicle['vehicle_category'] ?? '');
        if (! ($vehicle['active'] ?? false) || (int) ($vehicle['number_available'] ?? 0) < 1 || (float) ($vehicle['capacity_kg'] ?? 0) <= 0 || trim((string) ($vehicle['name'] ?? '')) === '' || ! in_array($type, VehicleConfiguration::TYPES[$category] ?? [], true) || ! in_array($vehicle['heavy_classification'] ?? '', ['HEAVY', 'NOT_HEAVY'], true)) {
            return false;
        }
        if ($type === 'CUSTOM' && trim((string) ($vehicle['custom_type_name'] ?? '')) === '') {
            return false;
        }
        if ($type === 'CONCRETE_MIXER') {
            return (float) ($vehicle['mixer_capacity_m3'] ?? 0) > 0;
        }

        return (float) ($vehicle['cargo_length_m'] ?? 0) > 0 && (float) ($vehicle['cargo_width_m'] ?? 0) > 0 && (float) ($vehicle['cargo_height_m'] ?? 0) > 0;
    }

    /**
     * Distances and constraints refer to the applicable drop-off, not necessarily the project location.
     * Cargo is a set of identical independently transportable units. Heterogeneous loads must be assessed separately.
     *
     * @param  array<string, mixed>  $load
     * @return array<string, mixed>
     */
    public function recommend(string $organizationId, array $load): array
    {
        return $this->evaluate($this->eligibleVehicles($organizationId), $load);
    }

    /** @param list<array<string, mixed>> $vehicles
     * @param  array<string, mixed>  $load
     * @return array<string, mixed>
     */
    public function evaluate(array $vehicles, array $load): array
    {
        Validator::make($load, [
            'material_kind' => ['required', 'in:CARGO,READY_MIXED_CONCRETE'],
            'weight_kg' => ['required', 'numeric', 'gt:0', 'max:1000000000'],
            'volume_m3' => ['required_if:material_kind,READY_MIXED_CONCRETE', 'numeric', 'gt:0', 'max:1000000000'],
            'unit_count' => ['required_if:material_kind,CARGO', 'integer', 'min:1', 'max:1000000'],
            'length_m' => ['required_if:material_kind,CARGO', 'numeric', 'gt:0', 'max:1000'],
            'width_m' => ['required_if:material_kind,CARGO', 'numeric', 'gt:0', 'max:1000'],
            'height_m' => ['required_if:material_kind,CARGO', 'numeric', 'gt:0', 'max:1000'],
            'dimensional_kg_per_m3' => ['sometimes', 'numeric', 'gt:0', 'max:1000000'],
            'distance_meters' => ['required', 'integer', 'min:0', 'max:50000'],
            'heavy_vehicle_restriction' => ['required', 'boolean'],
            'intended_location' => ['required', 'array'],
            'intended_location.latitude' => ['required', 'numeric', 'between:-90,90'],
            'intended_location.longitude' => ['required', 'numeric', 'between:-180,180'],
            'alternative_drop_off' => ['required_if:heavy_vehicle_restriction,true', 'array'],
            'alternative_drop_off.latitude' => ['required_with:alternative_drop_off', 'numeric', 'between:-90,90'],
            'alternative_drop_off.longitude' => ['required_with:alternative_drop_off', 'numeric', 'between:-180,180'],
            'route_destination' => ['required', 'array'],
            'route_destination.latitude' => ['required', 'numeric', 'between:-90,90'],
            'route_destination.longitude' => ['required', 'numeric', 'between:-180,180'],
            'site_access_confirmed' => ['required', 'boolean'],
            'heavy_vehicle_access_confirmed' => ['required', 'boolean'],
        ])->validate();
        $dropOff = $load['heavy_vehicle_restriction'] ? $load['alternative_drop_off'] : $load['intended_location'];
        $base = ['advisory' => true, 'vendor_confirmation_required' => true, 'intended_location' => $load['intended_location'], 'drop_off' => $dropOff, 'heavy_vehicle_restriction' => $load['heavy_vehicle_restriction'], 'candidates' => []];
        if (! $load['site_access_confirmed'] || (float) $dropOff['latitude'] !== (float) $load['route_destination']['latitude'] || (float) $dropOff['longitude'] !== (float) $load['route_destination']['longitude']) {
            return $base + ['reason' => 'Confirm access and obtain a route to the applicable drop-off point.'];
        }
        $candidates = [];
        foreach ($vehicles as $vehicle) {
            if (! self::complete($vehicle) || empty($vehicle['image_file_id']) || empty($vehicle['rate_version_id']) || ! isset($vehicle['base_fee_centavos'], $vehicle['per_km_centavos']) || (int) $vehicle['base_fee_centavos'] < 0 || (int) $vehicle['per_km_centavos'] < 0 || (int) $load['distance_meters'] > (int) ($vehicle['maximum_distance_km'] ?? 0) * 1000 || ($vehicle['heavy_classification'] === 'HEAVY' && ! $load['heavy_vehicle_access_confirmed'])) {
                continue;
            }
            $mixer = $vehicle['vehicle_type'] === 'CONCRETE_MIXER';
            if ($mixer !== ($load['material_kind'] === 'READY_MIXED_CONCRETE')) {
                continue;
            }
            $weight = (float) $load['weight_kg'];
            if ($mixer) {
                $trips = (int) ceil(max($weight / (float) $vehicle['capacity_kg'], (float) $load['volume_m3'] / (float) $vehicle['mixer_capacity_m3']));
            } else {
                $count = (int) $load['unit_count'];
                // Conservative axis-aligned packing; never infer rotation or that indivisible units can be split.
                $slots = floor((float) $vehicle['cargo_length_m'] / (float) $load['length_m']) * floor((float) $vehicle['cargo_width_m'] / (float) $load['width_m']) * floor((float) $vehicle['cargo_height_m'] / (float) $load['height_m']);
                $unitWeight = $weight / $count;
                if (isset($load['dimensional_kg_per_m3'])) {
                    $unitWeight = max($unitWeight, (float) $load['length_m'] * (float) $load['width_m'] * (float) $load['height_m'] * (float) $load['dimensional_kg_per_m3']);
                }
                $unitsPerTrip = min($slots, floor((float) $vehicle['capacity_kg'] / $unitWeight));
                if ($unitsPerTrip < 1) {
                    continue;
                }
                $trips = (int) ceil($count / $unitsPerTrip);
            }
            $count = min($trips, (int) $vehicle['number_available']);
            $feePerTrip = (int) $vehicle['base_fee_centavos'] + intdiv((int) $vehicle['per_km_centavos'] * (int) $load['distance_meters'] + 500, 1000);
            if ($feePerTrip > 0 && $trips > intdiv(PHP_INT_MAX, $feePerTrip)) {
                continue;
            }
            $candidates[] = ['vehicle' => $vehicle, 'number_of_vehicles' => $count, 'total_vehicle_trips' => $trips, 'trip_rounds' => (int) ceil($trips / $count), 'estimated_charge_centavos' => $feePerTrip * $trips, 'distance_meters' => (int) $load['distance_meters']];
        }
        // Present alternatives without imposing an unapproved commercial ranking rule.
        $base['candidates'] = $candidates;

        return $base + ['reason' => $candidates === [] ? 'No eligible configured vehicle meets the supplied constraints.' : 'Vendor must confirm vehicles, trips, access and the final charge.'];
    }
}
