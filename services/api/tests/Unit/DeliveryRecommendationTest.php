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
}
