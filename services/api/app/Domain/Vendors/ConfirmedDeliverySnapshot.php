<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

/**
 * Called inside the future order-acceptance transaction, after its canonical state transition and price
 * confirmation. No HTTP endpoint or dispatch side effect. Only the Owner or Store Manager confirms the
 * commercial vehicle arrangement. The confirmed fee must equal the approved formula for the confirmed
 * vehicles, trips and endpoint distance (approved by the project owner on 2026-09-28), so no undisclosed
 * charge can be added. The snapshot freezes vehicle, rate and address versions; later edits never change it.
 */
final class ConfirmedDeliverySnapshot
{
    public function __construct(private AccountAccess $access, private DeliveryRecommendationService $recommendations) {}

    /**
     * @param  array<string, mixed>  $load
     * @param  list<array{vehicle_id: string, number_of_vehicles: int, total_vehicle_trips: int, group_key?: string}>  $selection
     */
    public function record(User $actor, string $orderId, array $load, array $selection, int $finalChargeCentavos, string $arrangement, string $fulfillmentDate, ?string $manualReviewNote = null): string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Delivery snapshots must be recorded in the order acceptance transaction.');
        }
        $scope = $this->access->resolve($actor);
        if ($actor->account_type !== 'VENDOR' || ! in_array('vehicles.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Owner or Store Manager can confirm the delivery arrangement.', 403);
        }
        $organizationId = (string) $scope['organization_id'];
        $order = DB::table('orders')->where('id', $orderId)->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
        if ($order === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The order is unavailable.', 404);
        }
        $today = CarbonImmutable::now('Asia/Manila')->toDateString();
        Validator::make(['selection' => $selection, 'charge' => $finalChargeCentavos, 'arrangement' => $arrangement, 'fulfillment_date' => $fulfillmentDate, 'manual_review_note' => $manualReviewNote], [
            'selection' => ['required', 'array', 'min:1', 'max:20'], 'selection.*.vehicle_id' => ['required', 'uuid'],
            'selection.*.number_of_vehicles' => ['required', 'integer', 'min:1'], 'selection.*.total_vehicle_trips' => ['required', 'integer', 'min:1'],
            'selection.*.group_key' => ['sometimes', 'string', 'max:40'],
            'charge' => ['required', 'integer', 'min:0'], 'arrangement' => ['required', 'string', 'max:2000'],
            'fulfillment_date' => ['required', 'date_format:Y-m-d', 'after_or_equal:'.$today],
            'manual_review_note' => ['nullable', 'string', 'min:10', 'max:2000'],
        ])->validate();
        // Serialize against fleet and onboarding configuration edits and preserve immutable rate references.
        DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
        $evaluation = $this->recommendations->recommend($organizationId, $load);
        if (! in_array($evaluation['status'], ['CANDIDATES_AVAILABLE', 'MANUAL_REVIEW_REQUIRED'], true)) {
            throw new AuthenticationException('DELIVERY_ROUTE_REQUIRED', (string) $evaluation['reason'], 422, ['status' => $evaluation['status']]);
        }
        $groups = [];
        foreach ($evaluation['groups'] as $group) {
            $groups[$group['key']] = $group;
        }
        $manual = $evaluation['status'] === 'MANUAL_REVIEW_REQUIRED';
        if ($manual && ($manualReviewNote === null || trim($manualReviewNote) === '')) {
            throw new AuthenticationException('DELIVERY_MANUAL_REVIEW_REQUIRED', 'Record the manual load review before confirming vehicles for this delivery.', 422, ['reasons' => array_values(array_unique(array_merge(...array_map(static fn (array $group): array => $group['manual_review_reasons'], $evaluation['groups']))))]);
        }
        $eligible = [];
        foreach ($this->recommendations->eligibleVehicles($organizationId) as $vehicle) {
            $eligible[$vehicle['id']] = $vehicle;
        }
        $distance = (int) $load['distance_meters'];
        $fractions = [];
        $chosen = [];
        $computed = 0;
        $firstGroup = (string) array_key_first($groups);
        foreach ($selection as $item) {
            $groupKey = (string) ($item['group_key'] ?? $firstGroup);
            $group = $groups[$groupKey] ?? null;
            $vehicle = $eligible[$item['vehicle_id']] ?? null;
            if ($group === null || $vehicle === null || $item['number_of_vehicles'] > (int) $vehicle['number_available'] || $item['total_vehicle_trips'] < $item['number_of_vehicles']) {
                throw new AuthenticationException('DELIVERY_VEHICLE_INELIGIBLE', 'Select eligible available vehicles and valid trip counts.', 422);
            }
            $candidate = null;
            foreach ($group['candidates'] as $option) {
                if ($option['vehicle_id'] === $item['vehicle_id']) {
                    $candidate = $option;
                }
            }
            if ($group['status'] === 'MANUAL_REVIEW_REQUIRED') {
                // Manual fallback: capacity cannot be proven, but the vehicle must still be eligible, compatible and in range.
                if ($distance > (int) $vehicle['maximum_distance_km'] * 1000 || ($vehicle['heavy_classification'] === 'HEAVY' && ! $load['heavy_vehicle_access_confirmed']) || (($vehicle['vehicle_type'] === 'CONCRETE_MIXER') !== (($group['material_kind'] ?? null) === DeliveryRecommendationService::READY_MIXED_CONCRETE))) {
                    throw new AuthenticationException('DELIVERY_VEHICLE_INELIGIBLE', 'Select eligible available vehicles and valid trip counts.', 422);
                }
                $fractions[$groupKey] = 1.0;
            } elseif ($candidate === null) {
                throw new AuthenticationException('DELIVERY_VEHICLE_INELIGIBLE', 'Select eligible available vehicles and valid trip counts.', 422);
            } else {
                // Each candidate's trip requirement covers this entire homogeneous group; a sum of fractions is conservative.
                $fractions[$groupKey] = ($fractions[$groupKey] ?? 0.0) + $item['total_vehicle_trips'] / $candidate['total_vehicle_trips'];
            }
            $perTrip = DeliveryRecommendationService::feePerTripCentavos((int) $vehicle['base_fee_centavos'], (int) $vehicle['per_km_centavos'], $distance);
            $computed += $perTrip * $item['total_vehicle_trips'];
            $configuration = DB::table('vendor_vehicle_versions')->where('id', $vehicle['vehicle_version_id'])->value('configuration');
            $chosen[] = [
                'group_key' => $groupKey, 'vehicle_id' => $vehicle['id'], 'vehicle_version_id' => $vehicle['vehicle_version_id'], 'configuration_version' => (int) $vehicle['configuration_version'],
                'configuration' => is_string($configuration) ? json_decode($configuration, true, flags: JSON_THROW_ON_ERROR) : null,
                'rate_version_id' => $vehicle['rate_version_id'], 'rate_version' => $vehicle['rate_version'], 'base_fee_centavos' => (int) $vehicle['base_fee_centavos'], 'per_km_centavos' => (int) $vehicle['per_km_centavos'],
                'number_of_vehicles' => $item['number_of_vehicles'], 'total_vehicle_trips' => $item['total_vehicle_trips'], 'per_trip_centavos' => $perTrip, 'trip_total_centavos' => $perTrip * $item['total_vehicle_trips'],
            ];
        }
        foreach ($groups as $key => $group) {
            if (($fractions[$key] ?? 0.0) < 1) {
                throw new AuthenticationException('DELIVERY_CAPACITY_INSUFFICIENT', 'Confirm enough vehicles and trips for the load.', 422, ['group_key' => $key]);
            }
        }
        if ($computed !== $finalChargeCentavos) {
            throw new AuthenticationException('DELIVERY_FEE_CHANGED', 'The delivery fee must equal the disclosed formula for the confirmed vehicles and trips. Review the current fee and confirm again.', 409, ['computed_charge_centavos' => $computed]);
        }
        $basis = $manual ? 'MANUAL_REVIEW' : 'ADVISORY_CONFIRMED';
        $id = (string) Str::uuid7();
        DB::table('order_delivery_snapshots')->insert([
            'id' => $id, 'order_id' => $orderId, 'vendor_organization_id' => $organizationId, 'confirmed_by_user_id' => $actor->getKey(),
            'snapshot' => json_encode([
                'vehicles' => $chosen, 'groups' => array_map(static fn (array $group): array => array_diff_key($group, ['candidates' => true, 'excluded' => true]), array_values($groups)),
                'intended_location' => $evaluation['intended_location'], 'alternative_drop_off' => $evaluation['alternative_drop_off'], 'drop_off' => $evaluation['drop_off'],
                'endpoint' => $evaluation['endpoint'], 'heavy_vehicle_restriction' => $evaluation['heavy_vehicle_restriction'],
                'distance_meters' => $distance, 'route_source' => $evaluation['route_source'], 'fulfillment_date' => $fulfillmentDate, 'arrangement' => $arrangement,
                'basis' => $basis, 'manual_review_note' => $manual ? trim((string) $manualReviewNote) : null,
                'calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION, 'fee_rounding' => DeliveryRecommendationService::FEE_ROUNDING,
                'final_charge_centavos' => $finalChargeCentavos, 'confirmed_by' => ['user_id' => $actor->getKey(), 'role' => $scope['role']], 'confirmed_at' => now()->toIso8601String(),
            ], JSON_THROW_ON_ERROR),
            'final_charge_centavos' => $finalChargeCentavos, 'fulfillment_date' => $fulfillmentDate,
            'calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION, 'basis' => $basis, 'created_at' => now(),
        ]);

        return $id;
    }
}
