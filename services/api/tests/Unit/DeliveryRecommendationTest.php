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
        self::assertSame(['base_fee_centavos' => 10000, 'per_km_centavos' => 100, 'per_trip_centavos' => 11250, 'trips' => 2, 'total_centavos' => 22500, 'rounding' => DeliveryRecommendationService::FEE_ROUNDING], $candidate['fee']);
        self::assertSame([['vehicle_id' => 'mixer', 'reasons' => ['INCOMPATIBLE_LOAD']]], $result['groups'][0]['excluded']);
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
