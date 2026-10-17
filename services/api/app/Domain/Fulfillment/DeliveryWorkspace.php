<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderDeliveryPlanner;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderQueries;
use App\Domain\Orders\OrderStates;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

final class DeliveryWorkspace
{
    public function __construct(private readonly OrderAccess $access, private readonly OrderQueries $orders) {}

    /** @param array<string, mixed> $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function listing(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, 'portal.fulfillment', 'The Fulfillment workspace is available only to Fulfillment Staff.');
        $query = DB::table('orders as o')->join('order_fulfillment_assignments as a', 'a.order_id', '=', 'o.id')
            ->where('o.vendor_organization_id', $scope['organization_id'])->where('a.user_id', $request->user()->id)->whereNull('a.ended_at')
            ->whereNotIn('o.order_state', [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, ...OrderStates::CLOSED_BEFORE_FULFILLMENT]);
        $status = $filters['status'] ?? 'ALL';
        if ($status === 'PENDING') {
            $query->whereIn('o.fulfillment_state', ['NOT_STARTED', 'PROCESSING', 'READY_FOR_PICKUP']);
        } elseif ($status === 'OUT_FOR_DELIVERY') {
            $query->where('o.fulfillment_state', 'OUT_FOR_DELIVERY');
        } elseif ($status === 'DELIVERED') {
            $query->whereIn('o.fulfillment_state', ['DELIVERED', 'PICKED_UP']);
        } elseif ($status === 'ISSUES') {
            $query->whereExists(fn ($issue) => $issue->selectRaw('1')->from('fulfillment_milestones as m')->whereColumn('m.order_id', 'o.id')->where('m.event_type', 'VEHICLE_ISSUE_REPORTED'))
                ->whereNotIn('o.fulfillment_state', ['DELIVERED', 'PICKED_UP', 'COMPLETED']);
        }
        $term = trim((string) ($filters['q'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], mb_strtolower($term)).'%';
            $query->where(fn ($search) => $search->whereRaw('lower(o.reference) like ?', [$like])->orWhereExists(fn ($buyer) => $buyer->selectRaw('1')->from('buyer_profiles as b')
                ->join('user_profiles as p', 'p.user_id', '=', 'b.user_id')->whereColumn('b.id', 'o.buyer_profile_id')->whereRaw('lower(p.full_name) like ?', [$like])));
        }
        $total = (clone $query)->count();
        $page = (int) ($filters['page'] ?? 1);
        if (($filters['sort'] ?? 'SCHEDULED') === 'NEWEST') {
            $query->orderByDesc('a.created_at');
        } else {
            $query->orderBy('o.expected_fulfillment_date');
        }
        $ids = $query->orderBy('o.id')->forPage($page, 20)->pluck('o.id');

        return ['items' => $ids->map(fn (string $id): array => $this->orders->vendorDetail($request, $id))->all(),
            'meta' => ['page' => $page, 'per_page' => 20, 'total' => $total, 'has_more' => $page * 20 < $total]];
    }

    public function acknowledge(Request $request, string $orderId): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, 'portal.fulfillment', 'Only the assigned Fulfillment Staff can acknowledge this assignment.');
        $key = app(CatalogAccess::class)->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $key): void {
            DB::table('vendor_organizations')->where('id', $scope['organization_id'])->lockForUpdate()->first();
            $request->user()->refresh();
            $current = $this->access->vendorScope($request);
            $this->access->require($current, 'portal.fulfillment', 'Only Fulfillment Staff acknowledge their assignment.');
            $order = $this->access->vendorOrder($current, $orderId, true);
            if (app(CatalogAccess::class)->replayed($request, 'FULFILLMENT_ACKNOWLEDGE', $key, $orderId)) {
                return;
            }
            $assignment = DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->first();
            if ($assignment->acknowledged_at === null) {
                DB::table('order_fulfillment_assignments')->where('id', $assignment->id)->update(['acknowledged_at' => now(), 'updated_at' => now()]);
                $records = app(FulfillmentRecords::class);
                $records->event($records->ensure($order), 'ASSIGNMENT_ACKNOWLEDGED', OrderActor::vendor($request, $scope['role']), [], 'ACK:'.$assignment->id);
                app(AuditRecorder::class)->account($request, 'DELIVERY_ASSIGNMENT_ACKNOWLEDGED', 'ORDER', $orderId);
                app(OrderNotifier::class)->vendor($order, 'Assignment acknowledged: '.$order->reference, 'The assigned staff acknowledged the fulfillment assignment.', ['OWNER', 'STORE_MANAGER']);
            }
            app(CatalogAccess::class)->claim($request, 'FULFILLMENT_ACKNOWLEDGE', $key, $orderId, 200);
        });
    }

    /** Current store to the frozen, accepted endpoint. No device tracking or commercial recalculation.
     * @return array<string, mixed>
     */
    public function route(Request $request, string $orderId): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Delivery directions are restricted to fulfillment personnel.');
        $order = $this->access->vendorOrder($scope, $orderId);
        $endpoint = OrderDeliveryPlanner::endpoint($order);
        $store = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')
            ->where('a.vendor_organization_id', $order->vendor_organization_id)->whereNotNull('v.location')->first(['v.id', 'v.latitude', 'v.longitude', 'v.formatted_address']);
        if ($endpoint === null || $store === null) {
            throw new AuthenticationException('DELIVERY_LOCATION_UNAVAILABLE', 'A confirmed delivery destination and registered store location are required.', 422);
        }
        $cacheKey = 'delivery-route:'.hash('sha256', $orderId.'|'.$store->id.'|'.json_encode($endpoint, JSON_THROW_ON_ERROR));
        $ttlSeconds = max(1, min(1440, (int) config('services.google_maps.routes.cache_ttl_minutes', 10))) * 60;
        try {
            $route = Cache::remember($cacheKey, $ttlSeconds, function () use ($store, $endpoint): ?array {
                $route = app(RouteProvider::class)->drive((float) $store->latitude, (float) $store->longitude, (float) $endpoint['latitude'], (float) $endpoint['longitude']);

                return $route === null ? null : $route + ['computed_at' => now()->toIso8601String()];
            });
        } catch (GeographyProviderUnavailable) {
            throw new AuthenticationException('ROUTE_UNAVAILABLE', 'Delivery directions are temporarily unavailable. Retry or open navigation.', 503);
        }
        $request->user()->refresh();
        $this->access->vendorOrder($this->access->vendorScope($request), $orderId);
        if ($route === null) {
            throw new AuthenticationException('ROUTE_NOT_FOUND', 'No driving route was found for this delivery destination.', 422);
        }

        return $route + ['origin' => ['latitude' => (float) $store->latitude, 'longitude' => (float) $store->longitude, 'label' => (string) $store->formatted_address],
            'destination' => ['latitude' => (float) $endpoint['latitude'], 'longitude' => (float) $endpoint['longitude'], 'label' => (string) ($endpoint['formatted_address'] ?? $endpoint['address_text'] ?? $endpoint['label'] ?? 'Confirmed drop-off')]];
    }
}
