<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

/** Called inside the future order-acceptance transaction, after its canonical state transition and price confirmation. No HTTP endpoint or dispatch side effect. */
final class ConfirmedDeliverySnapshot
{
    public function __construct(private AccountAccess $access, private DeliveryRecommendationService $recommendations) {}

    /** @param array<string, mixed> $load
     * @param  list<array{vehicle_id: string, number_of_vehicles: int, total_vehicle_trips: int}>  $selection
     */
    public function record(User $actor, string $orderId, array $load, array $selection, int $finalChargeCentavos, string $arrangement): string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Delivery snapshots must be recorded in the order acceptance transaction.');
        }
        $scope = $this->access->resolve($actor);
        if ($actor->account_type !== 'VENDOR' || ! in_array('orders.confirm', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot confirm this delivery arrangement.', 403);
        }
        $organizationId = (string) $scope['organization_id'];
        $order = DB::table('orders')->where('id', $orderId)->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
        if ($order === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The order is unavailable.', 404);
        }
        Validator::make(['selection' => $selection, 'charge' => $finalChargeCentavos, 'arrangement' => $arrangement], [
            'selection' => ['required', 'array', 'min:1'], 'selection.*.vehicle_id' => ['required', 'uuid', 'distinct'],
            'selection.*.number_of_vehicles' => ['required', 'integer', 'min:1'], 'selection.*.total_vehicle_trips' => ['required', 'integer', 'min:1'],
            'charge' => ['required', 'integer', 'min:0'], 'arrangement' => ['required', 'string', 'max:2000'],
        ])->validate();
        // Serialize against onboarding configuration edits and preserve immutable rate references.
        DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
        $evaluation = $this->recommendations->recommend($organizationId, $load);
        $candidates = [];
        foreach ($evaluation['candidates'] as $candidate) {
            $candidates[$candidate['vehicle']['id']] = $candidate;
        }
        $chosen = [];
        $fraction = 0.0;
        foreach ($selection as $item) {
            $candidate = $candidates[$item['vehicle_id']] ?? null;
            if ($candidate === null || $item['number_of_vehicles'] > $candidate['vehicle']['number_available'] || $item['total_vehicle_trips'] < $item['number_of_vehicles']) {
                throw new AuthenticationException('DELIVERY_VEHICLE_INELIGIBLE', 'Select eligible available vehicles and valid trip counts.', 422);
            }
            // Each candidate's trip requirement covers this entire homogeneous load; a sum of fractions is conservative.
            $fraction += $item['total_vehicle_trips'] / $candidate['total_vehicle_trips'];
            $chosen[] = ['vehicle' => $candidate['vehicle'], 'number_of_vehicles' => $item['number_of_vehicles'], 'total_vehicle_trips' => $item['total_vehicle_trips']];
        }
        if ($fraction < 1) {
            throw new AuthenticationException('DELIVERY_CAPACITY_INSUFFICIENT', 'Confirm enough vehicles and trips for the load.', 422);
        }
        $id = (string) Str::uuid7();
        DB::table('order_delivery_snapshots')->insert(['id' => $id, 'order_id' => $orderId, 'vendor_organization_id' => $organizationId, 'confirmed_by_user_id' => $actor->getKey(), 'snapshot' => json_encode(['vehicles' => $chosen, 'intended_location' => $evaluation['intended_location'], 'drop_off' => $evaluation['drop_off'], 'heavy_vehicle_restriction' => $evaluation['heavy_vehicle_restriction'], 'distance_meters' => $load['distance_meters'], 'arrangement' => $arrangement, 'final_charge_centavos' => $finalChargeCentavos], JSON_THROW_ON_ERROR), 'final_charge_centavos' => $finalChargeCentavos, 'created_at' => now()]);

        return $id;
    }
}
