<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderStates;
use Illuminate\Support\Facades\DB;

/** Operational vehicle allocation within the immutable Buyer-approved arrangement. The caller locks the organization. */
final class DeliveryAssignments
{
    /** @return list<array<string, mixed>> */
    public function vehicles(object $order): array
    {
        $snapshot = json_decode((string) DB::table('order_delivery_snapshots')->where('order_id', $order->id)->value('snapshot'), true);
        /** @var list<array<string, mixed>> $vehicles */
        $vehicles = $snapshot['vehicles'] ?? [];

        return collect($vehicles)->map(function (array $accepted, int $index) use ($order): array {
            $vehicle = DB::table('vendor_vehicles')->where('id', $accepted['vehicle_id'] ?? null)->where('vendor_organization_id', $order->vendor_organization_id)->first();
            $busy = $vehicle === null ? 0 : (int) DB::table('order_fulfillment_assignments as a')->join('orders as o', 'o.id', '=', 'a.order_id')
                ->where('a.vehicle_id', $vehicle->id)->whereNull('a.ended_at')->where('a.order_id', '<>', $order->id)
                ->whereNotIn('o.fulfillment_state', ['DELIVERED', 'PICKED_UP', 'COMPLETED', 'CANCELLED'])
                ->whereNotIn('o.order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->sum('a.number_of_vehicles');
            $slots = max(0, (int) ($vehicle->number_available ?? 0) - $busy);
            $count = (int) ($accepted['number_of_vehicles'] ?? 1);
            $available = $vehicle !== null && $vehicle->active && $vehicle->available && $vehicle->removed_at === null && $slots >= $count;

            return ['vehicle_index' => $index, 'vehicle_id' => $accepted['vehicle_id'] ?? null, 'name' => $accepted['configuration']['name'] ?? 'Accepted vehicle',
                'vehicle_type' => $accepted['configuration']['vehicle_type'] ?? null, 'number_of_vehicles' => $count, 'total_vehicle_trips' => (int) ($accepted['total_vehicle_trips'] ?? 1),
                'available' => $available, 'unavailable_reason' => $available ? null : ($busy > 0 ? 'Already allocated to another active delivery.' : 'The accepted vehicle is inactive, unavailable or removed.')];
        })->values()->all();
    }

    /** @return array<string, mixed> */
    public function requireVehicle(object $order, int $index): array
    {
        $vehicle = $this->vehicles($order)[$index] ?? null;
        if ($vehicle === null) {
            throw new AuthenticationException('VEHICLE_NOT_IN_ACCEPTED_ARRANGEMENT', 'Select a vehicle from the accepted arrangement. Changing it requires Buyer-approved revision.', 422);
        }
        if (! $vehicle['available']) {
            throw new AuthenticationException('DELIVERY_VEHICLE_REQUIRED', (string) $vehicle['unavailable_reason'], 422);
        }

        return $vehicle;
    }
}
