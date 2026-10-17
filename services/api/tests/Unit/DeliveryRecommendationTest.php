<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\DeliveryRecommendationService;
use Illuminate\Validation\ValidationException;
use Tests\TestCase;

final class DeliveryRecommendationTest extends TestCase
{
    /** @return array<string, mixed> */
    private function vehicle(): array
    {
        return ['id' => 'vehicle', 'vehicle_category' => 'TRUCK', 'vehicle_type' => 'BOX_TRUCK', 'name' => 'Cargo truck', 'active' => true, 'number_available' => 2, 'capacity_kg' => 1000, 'cargo_length_m' => 4, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'HEAVY', 'image_file_id' => 'image', 'rate_version_id' => 'rate', 'base_fee_centavos' => 10000, 'per_km_centavos' => 100, 'maximum_distance_km' => 50];
    }

    /** @return array<string, mixed> */
    private function load(): array
    {
        return ['material_kind' => 'CARGO', 'weight_kg' => 1500, 'unit_count' => 3, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1, 'distance_meters' => 12500, 'heavy_vehicle_restriction' => false, 'intended_location' => ['latitude' => 14, 'longitude' => 121], 'route_destination' => ['latitude' => 14, 'longitude' => 121], 'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
    }

    public function test_cargo_uses_capacity_trips_and_integer_money_without_dispatch(): void
    {
        $result = app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $this->load());
        self::assertTrue($result['advisory']);
        self::assertTrue($result['vendor_confirmation_required']);
        self::assertSame(2, $result['candidates'][0]['total_vehicle_trips']);
        self::assertSame(2, $result['candidates'][0]['number_of_vehicles']);
        self::assertSame(22500, $result['candidates'][0]['estimated_charge_centavos']);
    }

    public function test_recommendation_prefers_lowest_eligible_fee_then_fewer_trips_and_stable_vehicle_id(): void
    {
        $cheap = array_replace($this->vehicle(), ['id' => 'cheap', 'base_fee_centavos' => 5000]);
        $large = array_replace($this->vehicle(), ['id' => 'large', 'capacity_kg' => 2000, 'base_fee_centavos' => 11250]);
        $tie = array_replace($large, ['id' => 'another-large']);
        $ineligible = array_replace($cheap, ['id' => 'unavailable', 'available' => false, 'base_fee_centavos' => 0]);
        $service = app(DeliveryRecommendationService::class);
        $first = $service->evaluate([$this->vehicle(), $large, $cheap, $ineligible], $this->load());
        self::assertSame(['large', 'cheap', 'vehicle'], array_column($first['groups'][0]['candidates'], 'vehicle_id'));
        self::assertSame(12500, $first['groups'][0]['candidates'][0]['estimated_charge_centavos']);
        // Both alternatives cost 12,500; carrying the whole load in one trip wins.
        self::assertSame(1, $first['groups'][0]['candidates'][0]['total_vehicle_trips']);
        $forward = $service->evaluate([$large, $tie], $this->load());
        $reverse = $service->evaluate([$tie, $large], $this->load());
        self::assertSame('another-large', $forward['groups'][0]['candidates'][0]['vehicle_id']);
        self::assertSame($forward['groups'][0]['candidates'], $reverse['groups'][0]['candidates']);
    }

    public function test_mixer_uses_concrete_volume_and_weight_but_never_bagged_cement(): void
    {
        $vehicle = array_replace($this->vehicle(), ['vehicle_type' => 'CONCRETE_MIXER', 'mixer_capacity_m3' => 6, 'capacity_kg' => 24000, 'cargo_length_m' => null, 'cargo_width_m' => null, 'cargo_height_m' => null]);
        $load = array_replace($this->load(), ['material_kind' => 'READY_MIXED_CONCRETE', 'volume_m3' => 25, 'weight_kg' => 60000]);
        $result = app(DeliveryRecommendationService::class)->evaluate([$vehicle], $load);
        self::assertSame(5, $result['candidates'][0]['total_vehicle_trips']);
        self::assertSame(3, $result['candidates'][0]['trip_rounds']);
        self::assertSame([], app(DeliveryRecommendationService::class)->evaluate([$vehicle], $this->load())['candidates']);
        self::assertSame([], app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load)['candidates']);
    }

    public function test_ineligible_capacity_distance_availability_and_access_fail_closed(): void
    {
        foreach ([['active' => false], ['number_available' => 0], ['vehicle_category' => null], ['image_file_id' => null], ['cargo_length_m' => 0.5], ['maximum_distance_km' => 10], ['capacity_kg' => 400]] as $change) {
            self::assertSame([], app(DeliveryRecommendationService::class)->evaluate([array_replace($this->vehicle(), $change)], $this->load())['candidates']);
        }
        self::assertSame([], app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], array_replace($this->load(), ['heavy_vehicle_access_confirmed' => false]))['candidates']);
    }

    public function test_dimensional_weight_requires_explicit_factor(): void
    {
        $load = array_replace($this->load(), ['weight_kg' => 30]);
        self::assertSame(1, app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load)['candidates'][0]['total_vehicle_trips']);
        $load['dimensional_kg_per_m3'] = 1000;
        self::assertSame(3, app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load)['candidates'][0]['total_vehicle_trips']);
    }

    public function test_alternative_drop_off_requires_matching_route_and_keeps_intended_location(): void
    {
        $load = array_replace($this->load(), ['heavy_vehicle_restriction' => true, 'alternative_drop_off' => ['latitude' => 15, 'longitude' => 121]]);
        self::assertSame([], app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load)['candidates']);
        $load['route_destination'] = $load['alternative_drop_off'];
        $result = app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load);
        self::assertSame($load['intended_location'], $result['intended_location']);
        self::assertSame($load['alternative_drop_off'], $result['drop_off']);
        self::assertCount(1, $result['candidates']);
    }

    public function test_restriction_cannot_omit_alternative_drop_off(): void
    {
        $this->expectException(ValidationException::class);
        app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], array_replace($this->load(), ['heavy_vehicle_restriction' => true]));
    }

    public function test_bagged_cement_is_ordinary_cargo_and_returns_disclosed_trip_components(): void
    {
        // 40 kg bags: payload, not the summed volume, limits each trip.
        $bags = ['material_kind' => 'CARGO', 'weight_kg' => 2000, 'unit_count' => 50, 'length_m' => 0.6, 'width_m' => 0.4, 'height_m' => 0.15];
        $result = app(DeliveryRecommendationService::class)->evaluate([$this->vehicle(), $this->mixer()], $this->grouped([$bags]));
        self::assertSame('CANDIDATES_AVAILABLE', $result['status']);
        self::assertFalse($result['dispatch']);
        self::assertCount(1, $result['candidates']);
        $candidate = $result['candidates'][0];
        self::assertSame(['units' => 25, 'weight_kg' => 1000.0], $candidate['capacity_per_trip']);
        self::assertSame('WEIGHT', $candidate['limiting_factor']);
        self::assertSame(2, $candidate['total_vehicle_trips']);
        self::assertSame(['base_fee_centavos' => 10000, 'per_km_centavos' => 100, 'per_trip_centavos' => 11250, 'trips' => 2, 'trip_total_centavos' => 22500,
            'mobilization_fee_centavos' => 0, 'mobilization_basis' => null, 'mobilization_units' => 0, 'mobilization_total_centavos' => 0,
            'total_centavos' => 22500, 'rounding' => DeliveryRecommendationService::FEE_ROUNDING], $candidate['fee']);
        self::assertSame([['vehicle_id' => 'mixer', 'reasons' => ['INCOMPATIBLE_LOAD']]], $result['groups'][0]['excluded']);
        self::assertNull($candidate['volume_plan']);
    }

    public function test_mixer_plans_full_loads_and_last_trip_from_ordered_volume(): void
    {
        // 7.5 m³ at 2,400 kg/m³ in 6 m³ drums with 24 t payload: one full load and a 1.5 m³ second trip.
        $concrete = ['material_kind' => 'READY_MIXED_CONCRETE', 'weight_kg' => 18000, 'volume_m3' => 7.5];
        $candidate = app(DeliveryRecommendationService::class)->evaluate([$this->mixer()], $this->grouped([$concrete]))['candidates'][0];
        self::assertSame(2, $candidate['total_vehicle_trips']);
        self::assertSame('VOLUME', $candidate['limiting_factor']);
        self::assertSame(['total_m3' => 7.5, 'full_load_m3' => 6.0, 'full_trips' => 1, 'last_trip_m3' => 1.5], $candidate['volume_plan']);
        // A payload below one drum of this concrete makes weight the limit and shrinks each load.
        $light = array_replace($this->mixer(), ['capacity_kg' => 7200]);
        $limited = app(DeliveryRecommendationService::class)->evaluate([$light], $this->grouped([$concrete]))['candidates'][0];
        self::assertSame(3, $limited['total_vehicle_trips']);
        self::assertSame('WEIGHT', $limited['limiting_factor']);
        self::assertSame(['total_m3' => 7.5, 'full_load_m3' => 3.0, 'full_trips' => 2, 'last_trip_m3' => 1.5], $limited['volume_plan']);
    }

    public function test_mixer_mobilization_follows_the_vendor_chosen_basis(): void
    {
        // 25 m³ in 6 m³ drums = 5 trips on 2 available trucks.
        $concrete = ['material_kind' => 'READY_MIXED_CONCRETE', 'weight_kg' => 60000, 'volume_m3' => 25];
        $service = app(DeliveryRecommendationService::class);
        $perTruck = $service->evaluate([array_replace($this->mixer(), ['mobilization_fee_centavos' => 150000, 'mobilization_basis' => 'PER_TRUCK'])], $this->grouped([$concrete]))['candidates'][0];
        self::assertSame([5, 2], [$perTruck['total_vehicle_trips'], $perTruck['number_of_vehicles']]);
        self::assertSame(['PER_TRUCK', 2, 300000], [$perTruck['fee']['mobilization_basis'], $perTruck['fee']['mobilization_units'], $perTruck['fee']['mobilization_total_centavos']]);
        self::assertSame(11250 * 5 + 300000, $perTruck['estimated_charge_centavos']);
        $perTrip = $service->evaluate([array_replace($this->mixer(), ['mobilization_fee_centavos' => 150000, 'mobilization_basis' => 'PER_TRIP'])], $this->grouped([$concrete]))['candidates'][0];
        self::assertSame(11250 * 5 + 150000 * 5, $perTrip['estimated_charge_centavos']);
        // No fee, or a fee without a recognised basis, adds nothing.
        foreach ([['mobilization_fee_centavos' => 0, 'mobilization_basis' => null], ['mobilization_fee_centavos' => 150000, 'mobilization_basis' => 'PER_DAY']] as $rate) {
            self::assertSame(11250 * 5, $service->evaluate([array_replace($this->mixer(), $rate)], $this->grouped([$concrete]))['candidates'][0]['estimated_charge_centavos']);
        }
        self::assertSame(11250 * 3 + 150000 * 2, DeliveryRecommendationService::charge(array_replace($this->mixer(), ['mobilization_fee_centavos' => 150000, 'mobilization_basis' => 'PER_TRUCK']), 2, 3, 12500)['total_centavos'] ?? null);
    }

    public function test_mixed_ready_mixed_and_ordinary_loads_stay_separate_groups(): void
    {
        $concrete = ['material_kind' => 'READY_MIXED_CONCRETE', 'weight_kg' => 14400, 'volume_m3' => 6];
        $blocks = ['material_kind' => 'CARGO', 'weight_kg' => 600, 'unit_count' => 50, 'length_m' => 0.4, 'width_m' => 0.2, 'height_m' => 0.2];
        $result = app(DeliveryRecommendationService::class)->evaluate([$this->vehicle(), $this->mixer()], $this->grouped([$concrete, $blocks]));
        self::assertContains('GROUPS_CARRIED_SEPARATELY', $result['limitations']);
        self::assertSame(['group-1', 'group-2'], array_column($result['groups'], 'key'));
        self::assertSame('mixer', $result['groups'][0]['candidates'][0]['vehicle_id']);
        self::assertSame(1, $result['groups'][0]['candidates'][0]['total_vehicle_trips']);
        self::assertSame('vehicle', $result['groups'][1]['candidates'][0]['vehicle_id']);
    }

    public function test_missing_measurements_or_unknown_conversions_require_named_manual_review(): void
    {
        $service = app(DeliveryRecommendationService::class);
        $cases = [
            [['material_kind' => 'CARGO', 'unit_count' => 10, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1], ['WEIGHT_UNKNOWN']],
            [['material_kind' => 'CARGO', 'weight_kg' => 100, 'unit_count' => 10], ['UNIT_DIMENSIONS_UNKNOWN']],
            [['material_kind' => 'CARGO', 'weight_kg' => 100, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1], ['UNIT_COUNT_UNKNOWN']],
            [['material_kind' => 'READY_MIXED_CONCRETE', 'weight_kg' => 100], ['VOLUME_UNKNOWN']],
            [['material_kind' => 'CARGO', 'weight_kg' => 100, 'unit_count' => 1, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1, 'dimensional_weight' => ['formula_version' => 'CUSTOM', 'kg_per_m3' => 200]], ['DIMENSIONAL_FORMULA_UNKNOWN']],
            [['weight_kg' => 100], ['MATERIAL_KIND_UNKNOWN']],
        ];
        foreach ($cases as [$group, $reasons]) {
            $result = $service->evaluate([$this->vehicle()], $this->grouped([$group]));
            self::assertSame('MANUAL_REVIEW_REQUIRED', $result['status']);
            self::assertSame($reasons, $result['groups'][0]['manual_review_reasons']);
            self::assertSame([], $result['candidates'], 'Unknown measurements never produce a zero load or zero fee.');
        }
    }

    public function test_automatic_dimension_failure_allows_manual_review_without_a_proven_fit_or_estimate(): void
    {
        $service = app(DeliveryRecommendationService::class);
        $load = array_replace($this->load(), ['weight_kg' => 20, 'unit_count' => 1, 'length_m' => 2.31, 'width_m' => 3.23, 'height_m' => 1231.23]);
        $result = $service->evaluate([$this->vehicle()], $load);
        self::assertSame('MANUAL_REVIEW_REQUIRED', $result['status']);
        self::assertSame(['UNIT_DIMENSIONS_REQUIRE_MANUAL_REVIEW'], $result['groups'][0]['manual_review_reasons']);
        self::assertSame(['DIMENSIONS_INSUFFICIENT'], $result['groups'][0]['excluded'][0]['reasons']);
        self::assertSame([], $result['candidates']);
        self::assertSame([$this->vehicle()], $service->manualReviewVehicles([$this->vehicle()], $result['groups'][0], $load));

        foreach ([['available' => false], ['maximum_distance_km' => 10], ['capacity_kg' => 10], ['vehicle_type' => 'CONCRETE_MIXER', 'mixer_capacity_m3' => 6]] as $change) {
            self::assertSame([], $service->manualReviewVehicles([array_replace($this->vehicle(), $change)], $result['groups'][0], $load));
        }
        self::assertSame([], $service->manualReviewVehicles([$this->vehicle()], $result['groups'][0], array_replace($load, ['heavy_vehicle_access_confirmed' => false])));
        self::assertSame('NO_ELIGIBLE_VEHICLE', $service->evaluate([array_replace($this->vehicle(), ['capacity_kg' => 10])], $load)['status']);
    }

    public function test_manual_review_trip_counts_cover_known_indivisible_payload_and_mixer_volume(): void
    {
        self::assertSame(4, DeliveryRecommendationService::manualReviewMinimumTrips($this->vehicle(), ['checked' => ['weight_kg' => 2400, 'unit_count' => 4]]));
        self::assertSame(5, DeliveryRecommendationService::manualReviewMinimumTrips($this->mixer(), ['checked' => ['weight_kg' => 60000, 'volume_m3' => 25]]));
        self::assertSame(1, DeliveryRecommendationService::manualReviewMinimumTrips($this->vehicle(), ['checked' => []]));
    }

    public function test_versioned_dimensional_weight_is_advisory_and_never_replaces_the_payload_check(): void
    {
        $light = ['material_kind' => 'CARGO', 'weight_kg' => 30, 'unit_count' => 3, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1];
        $service = app(DeliveryRecommendationService::class);
        self::assertSame(1, $service->evaluate([$this->vehicle()], $this->grouped([$light]))['candidates'][0]['total_vehicle_trips']);
        $withFormula = $light + ['dimensional_weight' => ['formula_version' => 'DIM-KG-PER-M3.v1', 'kg_per_m3' => 400]];
        self::assertSame(2, $service->evaluate([$this->vehicle()], $this->grouped([$withFormula]))['candidates'][0]['total_vehicle_trips']);
    }

    public function test_insufficient_payload_count_availability_range_and_multiple_trips(): void
    {
        $service = app(DeliveryRecommendationService::class);
        $heavy = ['material_kind' => 'CARGO', 'weight_kg' => 1200, 'unit_count' => 1, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1];
        $excluded = static fn (array $result): array => $result['groups'][0]['excluded'][0]['reasons'];
        self::assertSame(['PAYLOAD_INSUFFICIENT'], $excluded($service->evaluate([$this->vehicle()], $this->grouped([$heavy]))));
        self::assertSame(['DIMENSIONS_INSUFFICIENT'], $excluded($service->evaluate([$this->vehicle()], $this->grouped([array_replace($heavy, ['weight_kg' => 10, 'length_m' => 5])]))));
        self::assertSame(['VEHICLE_UNAVAILABLE'], $excluded($service->evaluate([array_replace($this->vehicle(), ['available' => false])], $this->grouped([array_replace($heavy, ['weight_kg' => 10])]))));
        self::assertSame(['VEHICLE_INCOMPLETE'], $excluded($service->evaluate([array_replace($this->vehicle(), ['number_available' => 0])], $this->grouped([array_replace($heavy, ['weight_kg' => 10])]))));
        self::assertSame(['OUT_OF_RANGE'], $excluded($service->evaluate([$this->vehicle()], $this->grouped([array_replace($heavy, ['weight_kg' => 10])], 50001))));

        // Twelve 400 kg units fit two per 1,000 kg trip: six trips shared by two vehicles over three rounds.
        $many = $service->evaluate([$this->vehicle()], $this->grouped([['material_kind' => 'CARGO', 'weight_kg' => 4800, 'unit_count' => 12, 'length_m' => 1, 'width_m' => 1, 'height_m' => 1]]));
        self::assertSame(['total' => 6, 'vehicles' => 2, 'rounds' => 3], ['total' => $many['candidates'][0]['total_vehicle_trips'], 'vehicles' => $many['candidates'][0]['number_of_vehicles'], 'rounds' => $many['candidates'][0]['trip_rounds']]);
    }

    public function test_alternative_drop_off_is_the_endpoint_and_distance_basis_while_the_site_is_kept(): void
    {
        $load = array_replace($this->load(), ['heavy_vehicle_restriction' => true, 'alternative_drop_off' => ['latitude' => 15, 'longitude' => 121], 'route_destination' => ['latitude' => 15, 'longitude' => 121], 'distance_meters' => 20000]);
        $result = app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], $load);
        self::assertSame('ALTERNATIVE_DROP_OFF', $result['endpoint']);
        self::assertSame(['latitude' => 14, 'longitude' => 121], $result['intended_location']);
        self::assertSame(['latitude' => 15, 'longitude' => 121], $result['alternative_drop_off']);
        self::assertSame(20000, $result['candidates'][0]['distance_meters']);
        self::assertSame(DeliveryRecommendationService::feePerTripCentavos(10000, 100, 20000), $result['candidates'][0]['fee']['per_trip_centavos']);
        self::assertSame('ROUTE_REQUIRED', app(DeliveryRecommendationService::class)->evaluate([$this->vehicle()], array_replace($load, ['route_destination' => ['latitude' => 14, 'longitude' => 121]]))['status']);
    }

    /** @return array<string, mixed> */
    private function mixer(): array
    {
        return array_replace($this->vehicle(), ['id' => 'mixer', 'vehicle_type' => 'CONCRETE_MIXER', 'mixer_capacity_m3' => 6, 'capacity_kg' => 24000, 'cargo_length_m' => null, 'cargo_width_m' => null, 'cargo_height_m' => null]);
    }

    /**
     * @param  list<array<string, mixed>>  $groups
     * @return array<string, mixed>
     */
    private function grouped(array $groups, int $distance = 12500): array
    {
        return ['groups' => $groups, 'distance_meters' => $distance, 'heavy_vehicle_restriction' => false, 'intended_location' => ['latitude' => 14, 'longitude' => 121], 'route_destination' => ['latitude' => 14, 'longitude' => 121], 'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
    }
}
