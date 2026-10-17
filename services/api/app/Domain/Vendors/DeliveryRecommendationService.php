<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Database\Query\Builder;
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
    public const CALCULATION_VERSION = 'delivery-advisory.v5';

    public const FEE_ROUNDING = 'per-trip.base-plus-km.half-up.v1';

    /** Delivery fee = (base + per-km × distance) × trips + mobilization × (trucks or trips, as the Vendor configured). */
    public const FEE_RULE = 'SUM_PER_TRIP_FEE_TIMES_TRIPS_PLUS_MOBILIZATION';

    /** Owner decision (2026-10-16): each Vendor chooses whether its mixer mobilization fee is per truck dispatched or per trip. */
    public const MOBILIZATION_BASES = ['PER_TRUCK', 'PER_TRIP'];

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
        $vehicles = $this->configuredVehiclesQuery($organizationId)->select('v.*')->orderBy('v.id')->get();
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
            $result[] = $row + ['vehicle_version_id' => $version?->id, 'rate_version_id' => $rate->id, 'rate_version' => (int) $rate->version, 'base_fee_centavos' => (int) $rate->base_fee_centavos, 'per_km_centavos' => (int) $rate->per_km_centavos,
                'mobilization_fee_centavos' => (int) $rate->mobilization_fee_centavos, 'mobilization_basis' => $rate->mobilization_basis, 'maximum_distance_km' => min((int) $coverage, (int) $rate->maximum_distance_km)];
        }

        return $result;
    }

    /** The same complete registered-vehicle predicate is used for setup, recommendations and new-order eligibility. */
    public function configuredVehiclesQuery(?string $organizationId = null): Builder
    {
        return DB::table('vendor_vehicles as v')
            ->when($organizationId !== null, fn (Builder $query) => $query->where('v.vendor_organization_id', $organizationId))
            ->where('v.active', true)->where('v.available', true)->whereNull('v.removed_at')
            ->where('v.number_available', '>', 0)->where('v.capacity_kg', '>', 0)->whereRaw("TRIM(v.name) <> ''")
            ->whereIn('v.heavy_classification', ['HEAVY', 'NOT_HEAVY'])
            ->where(function (Builder $query): void {
                foreach (VehicleConfiguration::TYPES as $category => $types) {
                    $query->orWhere(fn (Builder $type) => $type->where('v.vehicle_category', $category)->whereIn('v.vehicle_type', $types));
                }
            })
            ->where(fn (Builder $query) => $query->where('v.vehicle_type', '!=', 'CUSTOM')->orWhereRaw("TRIM(v.custom_type_name) <> ''"))
            ->where(fn (Builder $query) => $query
                ->where(fn (Builder $mixer) => $mixer->where('v.vehicle_type', 'CONCRETE_MIXER')->where('v.mixer_capacity_m3', '>', 0))
                ->orWhere(fn (Builder $cargo) => $cargo->where('v.vehicle_type', '!=', 'CONCRETE_MIXER')
                    ->where('v.cargo_length_m', '>', 0)->where('v.cargo_width_m', '>', 0)->where('v.cargo_height_m', '>', 0)))
            ->whereExists(fn (Builder $query) => $query->selectRaw('1')->from('files as image')->whereColumn('image.id', 'v.image_file_id')
                ->where('image.owner_type', 'VENDOR_ORGANIZATION')->whereColumn('image.owner_id', 'v.vendor_organization_id')
                ->where('image.purpose', 'VEHICLE_IMAGE')->where('image.scan_state', 'CLEAN'))
            ->whereExists(fn (Builder $query) => $query->selectRaw('1')->from('vehicle_rate_versions as rate')
                ->whereRaw('rate.id = (SELECT latest.id FROM vehicle_rate_versions AS latest WHERE latest.vendor_vehicle_id = v.id AND latest.effective_at <= ? ORDER BY latest.version DESC LIMIT 1)', [now()])
                ->where('rate.base_fee_centavos', '>=', 0)->where('rate.per_km_centavos', '>=', 0)->where('rate.maximum_distance_km', '>', 0));
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
            'MANUAL_REVIEW_REQUIRED' => 'The load needs manual review. The Vendor must check the measurements and fit, then confirm vehicles, trips and the formula fee.',
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
     * The disclosed formula charge for one vehicle selection: the per-trip fee for every trip, plus the Vendor's
     * mixer mobilization fee once per truck dispatched (PER_TRUCK) or once per trip (PER_TRIP). A rate without a
     * mobilization fee charges none. Returns null when the amount cannot be represented.
     *
     * @param  array<string, mixed>  $vehicle  an eligible vehicle with its current rate fields
     * @return array{base_fee_centavos: int, per_km_centavos: int, per_trip_centavos: int, trips: int, trip_total_centavos: int, mobilization_fee_centavos: int, mobilization_basis: ?string, mobilization_units: int, mobilization_total_centavos: int, total_centavos: int, rounding: string}|null
     */
    public static function charge(array $vehicle, int $vehicles, int $trips, int $distanceMeters): ?array
    {
        $perTrip = self::feePerTripCentavos((int) $vehicle['base_fee_centavos'], (int) $vehicle['per_km_centavos'], $distanceMeters);
        $mobilization = (int) ($vehicle['mobilization_fee_centavos'] ?? 0);
        $basis = $mobilization > 0 && in_array($vehicle['mobilization_basis'] ?? null, self::MOBILIZATION_BASES, true) ? (string) $vehicle['mobilization_basis'] : null;
        $units = $basis === null ? 0 : ($basis === 'PER_TRIP' ? $trips : $vehicles);
        if (($perTrip > 0 && $trips > intdiv(PHP_INT_MAX, $perTrip)) || ($mobilization > 0 && $units > intdiv(PHP_INT_MAX, $mobilization))) {
            return null;
        }
        $tripTotal = $perTrip * $trips;
        $mobilizationTotal = $basis === null ? 0 : $mobilization * $units;
        if ($tripTotal > PHP_INT_MAX - $mobilizationTotal) {
            return null;
        }

        return ['base_fee_centavos' => (int) $vehicle['base_fee_centavos'], 'per_km_centavos' => (int) $vehicle['per_km_centavos'], 'per_trip_centavos' => $perTrip, 'trips' => $trips,
            'trip_total_centavos' => $tripTotal, 'mobilization_fee_centavos' => $basis === null ? 0 : $mobilization, 'mobilization_basis' => $basis, 'mobilization_units' => $units,
            'mobilization_total_centavos' => $mobilizationTotal, 'total_centavos' => $tripTotal + $mobilizationTotal, 'rounding' => self::FEE_ROUNDING];
    }

    /**
     * Vehicles that an Owner/Manager may select after recording a manual load review. A dimensional
     * advisory may be reviewed manually; availability, compatibility, payload, range and access still apply.
     *
     * @param  list<array<string, mixed>>  $vehicles
     * @param  array<string, mixed>  $group
     * @param  array<string, mixed>  $load
     * @return list<array<string, mixed>>
     */
    public function manualReviewVehicles(array $vehicles, array $group, array $load): array
    {
        if ($group['status'] !== 'MANUAL_REVIEW_REQUIRED') {
            return [];
        }
        $checked = $group['checked'];

        return array_values(array_filter($vehicles, static function (array $vehicle) use ($group, $checked, $load): bool {
            if (self::vehicleExclusionReasons($vehicle, $group, $load) !== []) {
                return false;
            }
            $weight = (float) ($checked['weight_kg'] ?? 0);
            $count = (int) ($checked['unit_count'] ?? 0);

            return $count < 1 || $weight <= 0 || $weight / $count <= (float) $vehicle['capacity_kg'];
        }));
    }

    /**
     * Minimum trips for the known payload and mixer volume; cargo fit is recorded in the manual review.
     *
     * @param  array<string, mixed>  $vehicle
     * @param  array<string, mixed>  $group
     */
    public static function manualReviewMinimumTrips(array $vehicle, array $group): int
    {
        $checked = $group['checked'];
        $count = (int) ($checked['unit_count'] ?? 0);
        $weight = (float) ($checked['weight_kg'] ?? 0);
        $capacity = (float) $vehicle['capacity_kg'];
        $byWeight = $count > 0 && $weight > 0
            ? (int) ceil($count / max(1, floor($capacity / ($weight / $count))))
            : (int) ceil($weight / $capacity);
        $byVolume = ($vehicle['vehicle_type'] ?? null) === 'CONCRETE_MIXER'
            ? (int) ceil((float) ($checked['volume_m3'] ?? 0) / (float) $vehicle['mixer_capacity_m3']) : 0;

        return max(1, $byWeight, $byVolume);
    }

    /**
     * @param  array<string, mixed>  $vehicle
     * @param  array<string, mixed>  $group
     * @param  array<string, mixed>  $load
     * @return list<string>
     */
    private static function vehicleExclusionReasons(array $vehicle, array $group, array $load): array
    {
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
        if ((int) $load['distance_meters'] > (int) ($vehicle['maximum_distance_km'] ?? 0) * 1000) {
            $reasons[] = 'OUT_OF_RANGE';
        }
        if (($vehicle['heavy_classification'] ?? null) === 'HEAVY' && ! $load['heavy_vehicle_access_confirmed']) {
            $reasons[] = 'HEAVY_ACCESS_NOT_CONFIRMED';
        }
        if ((($vehicle['vehicle_type'] ?? null) === 'CONCRETE_MIXER') !== (($group['material_kind'] ?? null) === self::READY_MIXED_CONCRETE)) {
            $reasons[] = 'INCOMPATIBLE_LOAD';
        }

        return array_values(array_unique($reasons));
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
            $reasons = self::vehicleExclusionReasons($vehicle, $group, $load);
            $mixer = ($vehicle['vehicle_type'] ?? null) === 'CONCRETE_MIXER';
            if ($reasons !== []) {
                $excluded[] = ['vehicle_id' => $vehicle['id'] ?? null, 'reasons' => array_values(array_unique($reasons))];

                continue;
            }
            $weight = (float) $group['weight_kg'];
            $volumePlan = null;
            if ($mixer) {
                $volume = (float) $group['volume_m3'];
                $byWeight = (int) ceil($weight / (float) $vehicle['capacity_kg']);
                $byVolume = (int) ceil($volume / (float) $vehicle['mixer_capacity_m3']);
                $trips = max($byWeight, $byVolume);
                $limiting = $byVolume >= $byWeight ? 'VOLUME' : 'WEIGHT';
                $perTrip = ['volume_m3' => (float) $vehicle['mixer_capacity_m3'], 'weight_kg' => (float) $vehicle['capacity_kg']];
                // A full load is limited by drum volume and by payload at this concrete's density; the last trip carries the rest.
                $fullLoad = min((float) $vehicle['mixer_capacity_m3'], (float) $vehicle['capacity_kg'] * $volume / $weight);
                $volumePlan = ['total_m3' => round($volume, 3), 'full_load_m3' => round($fullLoad, 3), 'full_trips' => $trips - 1, 'last_trip_m3' => round($volume - $fullLoad * ($trips - 1), 3)];
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
            $fee = self::charge($vehicle, $vehicleCount, $trips, $distance);
            if ($fee === null) {
                $excluded[] = ['vehicle_id' => $vehicle['id'] ?? null, 'reasons' => ['FEE_OUT_OF_RANGE']];

                continue;
            }
            $candidates[] = [
                'group_key' => $key, 'vehicle' => $vehicle, 'vehicle_id' => $vehicle['id'] ?? null, 'vehicle_version_id' => $vehicle['vehicle_version_id'] ?? null, 'rate_version_id' => $vehicle['rate_version_id'],
                'number_of_vehicles' => $vehicleCount, 'total_vehicle_trips' => $trips, 'trip_rounds' => (int) ceil($trips / $vehicleCount),
                'capacity_per_trip' => $perTrip, 'volume_plan' => $volumePlan, 'limiting_factor' => $limiting, 'distance_meters' => $distance,
                'fee' => $fee, 'estimated_charge_centavos' => $fee['total_centavos'],
            ];
        }

        // Owner decision (2026-10-12): an automatic dimensional-fit rejection can be reviewed manually.
        // It never becomes a proven fit or a Buyer estimate; the confirmed snapshot records the review.
        if ($candidates === [] && array_any($excluded, static fn (array $vehicle): bool => in_array('DIMENSIONS_INSUFFICIENT', $vehicle['reasons'], true))) {
            $manual = $summary + ['status' => 'MANUAL_REVIEW_REQUIRED', 'manual_review_reasons' => ['UNIT_DIMENSIONS_REQUIRE_MANUAL_REVIEW'], 'candidates' => [], 'excluded' => $excluded];
            if ($this->manualReviewVehicles($vehicles, $manual, $load) !== []) {
                return $manual;
            }
        }

        // Recommend the lowest formula fee among vehicles that passed every fit/access check.
        // Ties prefer fewer trips, then fewer vehicles; the opaque ID makes the result stable.
        usort($candidates, static fn (array $a, array $b): int => [$a['estimated_charge_centavos'], $a['total_vehicle_trips'], $a['number_of_vehicles'], $a['vehicle_id']]
            <=> [$b['estimated_charge_centavos'], $b['total_vehicle_trips'], $b['number_of_vehicles'], $b['vehicle_id']]);

        return $summary + ['status' => $candidates === [] ? 'NO_ELIGIBLE_VEHICLE' : 'CANDIDATES_AVAILABLE', 'manual_review_reasons' => [], 'candidates' => $candidates, 'excluded' => $excluded];
    }
}
