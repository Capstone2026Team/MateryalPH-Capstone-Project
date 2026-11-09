<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use Illuminate\Support\Facades\DB;

/** Only projected into an authorized Vendor order detail, never lists or analytics. */
final class OrderLocationMap
{
    /** @return array{store: ?array{latitude: float, longitude: float, label: string}, destination: ?array{latitude: float, longitude: float, label: string}} */
    public function present(object $order): array
    {
        $store = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')
            ->where('a.vendor_organization_id', $order->vendor_organization_id)->first(['v.latitude', 'v.longitude', 'v.formatted_address']);
        $endpoint = OrderDeliveryPlanner::endpoint($order);
        $saved = OrderDeliveryPlanner::destination($order);
        // Historical pickup snapshots have no coordinates: never pin a different current store address.
        if ($order->fulfillment_method === 'PICKUP' && isset($saved['store_address']) && $saved['store_address'] !== $store?->formatted_address) {
            $store = null;
        }

        return [
            'store' => $store === null || $store->latitude === null || $store->longitude === null ? null : [
                'latitude' => (float) $store->latitude, 'longitude' => (float) $store->longitude, 'label' => (string) $store->formatted_address,
            ],
            'destination' => $endpoint === null || ! isset($endpoint['latitude'], $endpoint['longitude']) ? null : [
                'latitude' => (float) $endpoint['latitude'], 'longitude' => (float) $endpoint['longitude'], 'label' => (string) ($endpoint['formatted_address'] ?? $endpoint['label'] ?? 'Delivery drop-off'),
            ],
        ];
    }
}
