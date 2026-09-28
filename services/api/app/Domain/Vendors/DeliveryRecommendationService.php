<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/**
 * Internal advisory use case. Callers must authorize the Vendor and obtain an authoritative route to the
 * selected drop-off point. Output is never a dispatch, an exact packing plan or a final charge: the Owner or
 * Store Manager confirms vehicles, counts, trips, endpoint, date and the formula fee before Buyer acceptance.
 *
 * A load is one or more groups. Each group is a set of identical, independently transportable units
 * (ordinary cargo, including bagged cement) or a ready-mixed concrete volume. Groups are evaluated and
 * carried separately: a summed box or total volume never proves that a mixed load fits one vehicle.
 * Missing measurements or conversions return named manual-review reasons instead of zero load or fee.
 */
final class DeliveryRecommendationService
{
    public const CALCULATION_VERSION = 'delivery-advisory.v2';

    public const FEE_ROUNDING = 'per-trip.base-plus-km.half-up.v1';

    /** Supported dimensional-weight formulas. A group names its formula version and factor explicitly. */
    public const DIMENSIONAL_FORMULAS = ['DIM-KG-PER-M3.v1'];

    public const CARGO = 'CARGO';

    public const READY_MIXED_CONCRETE = 'READY_MIXED_CONCRETE';

    /** @return list<array<string, mixed>> */
    public function eligibleVehicles(string $organizationId): array
    {
        $coverage = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->value('maximum_distance_km');
        $method = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method');
        if (! in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true) || ! is_numeric($coverage) || (float) $coverage <= 0) {
            return [];
        }
        $vehicles = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->where('active', true)->where('available', true)->whereNull('removed_at')->orderBy('id')->get();
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
            $version = DB::table('vendor_vehicle_versions')->where('vendor_vehicle_id', $vehicle->id)->orderByDesc('version')->first(['id', 'version']);
            $result[] = $row + ['vehicle_version_id' => $version?->id, 'rate_version_id' => $rate->id, 'rate_version' => (int) $rate->version, 'base_fee_centavos' => (int) $rate->base_fee_centavos, 'per_km_centavos' => (int) $rate->per_km_centavos, 'maximum_distance_km' => min((int) $coverage, (int) $rate->maximum_distance_km)];
        }

        return $result;
    }

    /** @param array<string, mixed> $vehicle */
    public static function complete(array $vehicle): bool
    {
        return self::incompleteReason($vehicle) === null;
    }

    /** @param array<string, mixed> $vehicle */
    public static function incompleteReason(array $vehicle): ?string
    {
        $type = (string) ($vehicle['vehicle_type'] ?? '');
        $category = (string) ($vehicle['vehicle_category'] ?? '');
        if (! ($vehicle['active'] ?? false) || ($vehicle['removed_at'] ?? null) !== null) {
            return 'VEHICLE_DISABLED';
        }
        if (! ($vehicle['available'] ?? true)) {
            return 'VEHICLE_UNAVAILABLE';
        }
        if ((int) ($vehicle['number_available'] ?? 0) < 1 || (float) ($vehicle['capacity_kg'] ?? 0) <= 0 || trim((string) ($vehicle['name'] ?? '')) === '' || ! in_array($type, VehicleConfiguration::TYPES[$category] ?? [], true) || ! in_array($vehicle['heavy_classification'] ?? '', ['HEAVY', 'NOT_HEAVY'], true)) {
            return 'VEHICLE_INCOMPLETE';
        }
        if ($type === 'CUSTOM' && trim((string) ($vehicle['custom_type_name'] ?? '')) === '') {
            return 'VEHICLE_INCOMPLETE';
        }
        if ($type === 'CONCRETE_MIXER') {
            return (float) ($vehicle['mixer_capacity_m3'] ?? 0) > 0 ? null : 'VEHICLE_INCOMPLETE';
        }

        return (float) ($vehicle['cargo_length_m'] ?? 0) > 0 && (float) ($vehicle['cargo_width_m'] ?? 0) > 0 && (float) ($vehicle['cargo_height_m'] ?? 0) > 0 ? null : 'VEHICLE_INCOMPLETE';
    }

    /**
     * Distances and constraints refer to the applicable drop-off, not necessarily the project location.
     *
     * @param  array<string, mixed>  $load
     * @return array<string, mixed>
     */
    public function recommend(string $organizationId, array $load): array
    {
        return $this->evaluate($this->eligibleVehicles($organizationId), $load);
    }

    /**
     * @param  list<array<string, mixed>>  $vehicles
     * @param  array<string, mixed>  $load
     * @return array<string, mixed>
     */
    public function evaluate(array $vehicles, array $load): array
    {
        Validator::make($load, [
            'distance_meters' => ['required', 'integer', 'min:0', 'max:1000000'],
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
            'route_source' => ['sometimes', 'string', 'max:32'],
            'site_access_confirmed' => ['required', 'boolean'],
            'heavy_vehicle_access_confirmed' => ['required', 'boolean'],
            'groups' => ['sometimes', 'array', 'min:1', 'max:20'],
        ])->validate();
        $restricted = (bool) $load['heavy_vehicle_restriction'];
        // With a heavy-vehicle restriction the alternative drop-off is the vehicle endpoint and distance basis.
        $dropOff = $restricted ? $load['alternative_drop_off'] : $load['intended_location'];
        $groups = self::groups($load);
        $base = [
            'advisory' => true, 'dispatch' => false, 'vendor_confirmation_required' => true, 'calculation_version' => self::CALCULATION_VERSION, 'fee_rounding' => self::FEE_ROUNDING,
            'intended_location' => $load['intended_location'], 'alternative_drop_off' => $restricted ? $load['alternative_drop_off'] : null,
            'drop_off' => $dropOff, 'endpoint' => $restricted ? 'ALTERNATIVE_DROP_OFF' : 'INTENDED_LOCATION', 'heavy_vehicle_restriction' => $restricted,
            'distance_meters' => (int) $load['distance_meters'], 'route_source' => $load['route_source'] ?? null,
            'limitations' => count($groups) > 1 ? ['ADVISORY_ONLY', 'NO_EXACT_PACKING_GUARANTEE', 'GROUPS_CARRIED_SEPARATELY'] : ['ADVISORY_ONLY', 'NO_EXACT_PACKING_GUARANTEE'],
            'groups' => [], 'candidates' => [],
        ];
        if (! $load['site_access_confirmed']) {
            return $base + ['status' => 'ACCESS_NOT_CONFIRMED', 'reason' => 'Confirm access and obtain a route to the applicable drop-off point.'];
        }
        if ((float) $dropOff['latitude'] !== (float) $load['route_destination']['latitude'] || (float) $dropOff['longitude'] !== (float) $load['route_destination']['longitude']) {
            return $base + ['status' => 'ROUTE_REQUIRED', 'reason' => 'Confirm access and obtain a route to the applicable drop-off point.'];
        }
        $evaluated = [];
        $candidates = [];
        foreach ($groups as $group) {
            $result = $this->evaluateGroup($vehicles, $group, $load);
            $evaluated[] = $result;
            foreach ($result['candidates'] as $candidate) {
                $candidates[] = $candidate;
            }
        }
        $manual = array_values(array_filter($evaluated, static fn (array $group): bool => $group['status'] === 'MANUAL_REVIEW_REQUIRED'));
        $empty = array_values(array_filter($evaluated, static fn (array $group): bool => $group['status'] === 'NO_ELIGIBLE_VEHICLE'));
        $status = $manual !== [] ? 'MANUAL_REVIEW_REQUIRED' : ($empty !== [] ? 'NO_ELIGIBLE_VEHICLE' : 'CANDIDATES_AVAILABLE');
        $reason = match ($status) {
            'MANUAL_REVIEW_REQUIRED' => 'Some measurements are missing. The Vendor must review the load manually and confirm vehicles, trips and the formula fee.',
            'NO_ELIGIBLE_VEHICLE' => 'No eligible configured vehicle meets the supplied constraints.',
            default => 'Vendor must confirm vehicles, trips, access and the final charge.',
        };

        return array_replace($base, ['groups' => $evaluated, 'candidates' => $candidates, 'status' => $status, 'reason' => $reason]);
    }

    /** Formula fee for one vehicle trip: base + per-km × distance, rounded half-up to the centavo. */
    public static function feePerTripCentavos(int $baseFeeCentavos, int $perKmCentavos, int $distanceMeters): int
    {
        return $baseFeeCentavos + intdiv($perKmCentavos * $distanceMeters + 500, 1000);
    }

    /**
     * Normalizes the legacy single-load shape and the explicit group list.
     *
     * @param  array<string, mixed>  $load
     * @return list<array<string, mixed>>
     */
    private static function groups(array $load): array
    {
        if (isset($load['groups']) && is_array($load['groups'])) {
            return array_map(static fn (mixed $group, int|string $index): array => (is_array($group) ? $group : []) + ['key' => 'group-'.((int) $index + 1)], array_values($load['groups']), array_keys(array_values($load['groups'])));
        }
        $group = array_intersect_key($load, array_flip(['material_kind', 'weight_kg', 'volume_m3', 'unit_count', 'length_m', 'width_m', 'height_m', 'dimensional_weight']));
        if (isset($load['dimensional_kg_per_m3'])) {
            $group['dimensional_weight'] = ['formula_version' => 'DIM-KG-PER-M3.v1', 'kg_per_m3' => $load['dimensional_kg_per_m3']];
        }

        return [$group + ['key' => 'group-1']];
    }

    /**
     * @param  list<array<string, mixed>>  $vehicles
     * @param  array<string, mixed>  $group
     * @param  array<string, mixed>  $load
     * @return array<string, mixed>
     */
    private function evaluateGroup(array $vehicles, array $group, array $load): array
    {
        $key = (string) $group['key'];
        $kind = $group['material_kind'] ?? null;
        $missing = [];
        $positive = static fn (mixed $value): bool => is_numeric($value) && is_finite((float) $value) && (float) $value > 0;
        if (! in_array($kind, [self::CARGO, self::READY_MIXED_CONCRETE], true)) {
            $missing[] = 'MATERIAL_KIND_UNKNOWN';
        }
        if (! $positive($group['weight_kg'] ?? null)) {
            $missing[] = 'WEIGHT_UNKNOWN';
        }
        if ($kind === self::READY_MIXED_CONCRETE && ! $positive($group['volume_m3'] ?? null)) {
            $missing[] = 'VOLUME_UNKNOWN';
        }
        if ($kind === self::CARGO) {
            if (! is_numeric($group['unit_count'] ?? null) || (int) $group['unit_count'] < 1 || (float) $group['unit_count'] !== floor((float) $group['unit_count'])) {
                $missing[] = 'UNIT_COUNT_UNKNOWN';
            }
            if (! $positive($group['length_m'] ?? null) || ! $positive($group['width_m'] ?? null) || ! $positive($group['height_m'] ?? null)) {
                $missing[] = 'UNIT_DIMENSIONS_UNKNOWN';
            }
        }
        $dimensional = $group['dimensional_weight'] ?? null;
        if ($dimensional !== null && (! is_array($dimensional) || ! in_array($dimensional['formula_version'] ?? null, self::DIMENSIONAL_FORMULAS, true) || ! $positive($dimensional['kg_per_m3'] ?? null))) {
            $missing[] = 'DIMENSIONAL_FORMULA_UNKNOWN';
        }
        $summary = ['key' => $key, 'material_kind' => $kind, 'checked' => array_intersect_key($group, array_flip(['weight_kg', 'volume_m3', 'unit_count', 'length_m', 'width_m', 'height_m', 'dimensional_weight']))];
        if ($missing !== []) {
            return $summary + ['status' => 'MANUAL_REVIEW_REQUIRED', 'manual_review_reasons' => $missing, 'candidates' => [], 'excluded' => []];
        }
        $candidates = [];
        $excluded = [];
        $distance = (int) $load['distance_meters'];
        foreach ($vehicles as $vehicle) {
            $reasons = [];
            $incomplete = self::incompleteReason($vehicle);
            if ($incomplete !== null) {
                $reasons[] = $incomplete;
            }
            if (empty($vehicle['image_file_id'])) {
                $reasons[] = 'VEHICLE_INCOMPLETE';
            }
            if (empty($vehicle['rate_version_id']) || ! isset($vehicle['base_fee_centavos'], $vehicle['per_km_centavos']) || (int) $vehicle['base_fee_centavos'] < 0 || (int) $vehicle['per_km_centavos'] < 0) {
                $reasons[] = 'RATE_MISSING';
            }
            if ($distance > (int) ($vehicle['maximum_distance_km'] ?? 0) * 1000) {
                $reasons[] = 'OUT_OF_RANGE';
            }
            if (($vehicle['heavy_classification'] ?? null) === 'HEAVY' && ! $load['heavy_vehicle_access_confirmed']) {
                $reasons[] = 'HEAVY_ACCESS_NOT_CONFIRMED';
            }
            $mixer = ($vehicle['vehicle_type'] ?? null) === 'CONCRETE_MIXER';
            if ($mixer !== ($kind === self::READY_MIXED_CONCRETE)) {
                // Mixers carry only ready-mixed concrete; bagged cement and other cargo use ordinary vehicles.
                $reasons[] = 'INCOMPATIBLE_LOAD';
            }
            if ($reasons !== []) {
                $excluded[] = ['vehicle_id' => $vehicle['id'] ?? null, 'reasons' => array_values(array_unique($reasons))];

                continue;
            }
            $weight = (float) $group['weight_kg'];
            if ($mixer) {
                $byWeight = (int) ceil($weight / (float) $vehicle['capacity_kg']);
                $byVolume = (int) ceil((float) $group['volume_m3'] / (float) $vehicle['mixer_capacity_m3']);
                $trips = max($byWeight, $byVolume);
                $limiting = $byVolume >= $byWeight ? 'VOLUME' : 'WEIGHT';
                $perTrip = ['volume_m3' => (float) $vehicle['mixer_capacity_m3'], 'weight_kg' => (float) $vehicle['capacity_kg']];
            } else {
                $count = (int) $group['unit_count'];
                // Conservative axis-aligned fit; never infer rotation or that indivisible units can be split.
                $slots = floor((float) $vehicle['cargo_length_m'] / (float) $group['length_m']) * floor((float) $vehicle['cargo_width_m'] / (float) $group['width_m']) * floor((float) $vehicle['cargo_height_m'] / (float) $group['height_m']);
                $unitWeight = $weight / $count;
                if (is_array($dimensional)) {
                    $unitWeight = max($unitWeight, (float) $group['length_m'] * (float) $group['width_m'] * (float) $group['height_m'] * (float) $dimensional['kg_per_m3']);
                }
                $byWeight = floor((float) $vehicle['capacity_kg'] / $unitWeight);
                $unitsPerTrip = min($slots, $byWeight);
                if ($unitsPerTrip < 1) {
                    $excluded[] = ['vehicle_id' => $vehicle['id'] ?? null, 'reasons' => [$slots < 1 ? 'DIMENSIONS_INSUFFICIENT' : 'PAYLOAD_INSUFFICIENT']];

                    continue;
                }
                $trips = (int) ceil($count / $unitsPerTrip);
                $limiting = $slots <= $byWeight ? 'DIMENSIONS' : 'WEIGHT';
                $perTrip = ['units' => (int) $unitsPerTrip, 'weight_kg' => round($unitsPerTrip * $unitWeight, 4)];
            }
            $vehicleCount = min($trips, (int) $vehicle['number_available']);
            $feePerTrip = self::feePerTripCentavos((int) $vehicle['base_fee_centavos'], (int) $vehicle['per_km_centavos'], $distance);
            if ($feePerTrip > 0 && $trips > intdiv(PHP_INT_MAX, $feePerTrip)) {
                $excluded[] = ['vehicle_id' => $vehicle['id'] ?? null, 'reasons' => ['FEE_OUT_OF_RANGE']];

                continue;
            }
            $candidates[] = [
                'group_key' => $key, 'vehicle' => $vehicle, 'vehicle_id' => $vehicle['id'] ?? null, 'vehicle_version_id' => $vehicle['vehicle_version_id'] ?? null, 'rate_version_id' => $vehicle['rate_version_id'],
                'number_of_vehicles' => $vehicleCount, 'total_vehicle_trips' => $trips, 'trip_rounds' => (int) ceil($trips / $vehicleCount),
                'capacity_per_trip' => $perTrip, 'limiting_factor' => $limiting, 'distance_meters' => $distance,
                'fee' => ['base_fee_centavos' => (int) $vehicle['base_fee_centavos'], 'per_km_centavos' => (int) $vehicle['per_km_centavos'], 'per_trip_centavos' => $feePerTrip, 'trips' => $trips, 'total_centavos' => $feePerTrip * $trips, 'rounding' => self::FEE_ROUNDING],
                'estimated_charge_centavos' => $feePerTrip * $trips,
            ];
        }

        // Alternatives are presented without imposing an unapproved commercial ranking rule.
        return $summary + ['status' => $candidates === [] ? 'NO_ELIGIBLE_VEHICLE' : 'CANDIDATES_AVAILABLE', 'manual_review_reasons' => [], 'candidates' => $candidates, 'excluded' => $excluded];
    }
}
