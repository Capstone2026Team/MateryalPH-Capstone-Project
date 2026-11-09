<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use Illuminate\Support\Facades\DB;

/** Called only after order authorization. A fleet image must be referenced by this order's frozen terms. */
final class OrderVehicleImages
{
    public function file(string $orderId, string $fileId): ?object
    {
        $order = DB::table('orders')->where('id', $orderId)->first(['vendor_organization_id', 'fulfillment_method']);
        if ($order === null || $order->fulfillment_method !== 'DELIVERY') {
            return null;
        }
        $confirmed = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot');
        $terms = is_string($confirmed) ? json_decode($confirmed, true) : [];
        $ids = array_column(array_column($terms['vehicles'] ?? [], 'configuration'), 'image_file_id');
        // Before confirmation, expose only the vehicle profile frozen in the submitted order estimate.
        if ($confirmed === null) {
            $submitted = DB::table('order_snapshots')->where('order_id', $orderId)->where('version', 1)->value('snapshot');
            $snapshot = is_string($submitted) ? json_decode($submitted, true) : [];
            $estimate = $snapshot['delivery_estimate'] ?? $snapshot['system_estimate']['delivery'] ?? [];
            $ids = array_column(array_column($estimate['estimate']['options'] ?? [], 'vehicle_details'), 'image_file_id');
        }
        if (! in_array($fileId, $ids, true)) {
            return null;
        }

        return DB::table('files')->where('id', $fileId)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $order->vendor_organization_id)
            ->where('purpose', 'VEHICLE_IMAGE')->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')
            ->whereIn('content_type', ['image/jpeg', 'image/png', 'image/webp'])->first();
    }
}
