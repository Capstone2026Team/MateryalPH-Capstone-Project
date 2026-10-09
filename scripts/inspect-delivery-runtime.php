<?php

declare(strict_types=1);

use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Vendors\DeliveryRecommendationService;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Support\Facades\DB;

// Read-only delivery diagnosis for a supplied public SKU. Never output identities, addresses,
// coordinates, exact inventory, credentials, access instructions or provider payloads.
require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

$sku = $argv[1] ?? '';
if ($sku === '' || strlen($sku) > 100) {
    fwrite(STDERR, "Supply the product SKU to inspect.\n");
    exit(1);
}

DB::beginTransaction();
try {
    DB::statement('SET TRANSACTION READ ONLY');
    $rows = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
        ->where('v.sku', $sku)->get(['v.id', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm', 'l.vendor_organization_id']);
    $results = [];
    foreach ($rows as $row) {
        $measurements = array_intersect_key((array) $row, array_flip(['weight_kg', 'length_cm', 'width_cm', 'height_cm']));
        $service = app(DeliveryRecommendationService::class);
        $vehicles = $service->eligibleVehicles((string) $row->vendor_organization_id);
        $carts = DB::table('cart_items as i')->join('carts as c', 'c.id', '=', 'i.cart_id')
            ->where('i.listing_variant_id', $row->id)->where('c.state', 'ACTIVE')->whereNull('i.saved_for_later_at')
            ->orderByDesc('c.updated_at')->limit(5)->get(['i.quantity', 'c.intended_location_id', 'c.alternate_drop_off_location_id', 'c.heavy_vehicle_restriction']);
        $previews = [];
        $point = static function (?string $id): ?array {
            $location = $id === null ? null : DB::table('buyer_locations as b')->join('addresses as a', 'a.id', '=', 'b.address_id')
                ->where('b.id', $id)->first(['a.latitude', 'a.longitude']);

            return $location === null ? null : ['latitude' => (float) $location->latitude, 'longitude' => (float) $location->longitude];
        };
        foreach ($carts as $cart) {
            $endpointId = $cart->heavy_vehicle_restriction === 'YES' ? $cart->alternate_drop_off_location_id : $cart->intended_location_id;
            $addressId = $endpointId === null ? null : DB::table('buyer_locations')->where('id', $endpointId)->value('address_id');
            $storeVersion = DB::table('vendor_addresses')->where('vendor_organization_id', $row->vendor_organization_id)->value('current_version_id');
            $cacheKey = hash('sha256', 'route|delivery|v1|'.$storeVersion.'|'.$addressId);
            $cached = DB::table('route_cache_entries')->where('cache_key_hash', $cacheKey)->where('kind', 'ROUTE')->orderByDesc('updated_at')->first(['payload', 'expires_at']);
            $route = $cached === null ? null : json_decode((string) $cached->payload, true);
            $load = DeliveryPreviewService::loadGroupFor('selected-product', (string) $cart->quantity, $measurements);
            $evaluation = null;
            $intended = $point($cart->intended_location_id);
            $endpoint = $point($endpointId);
            if (isset($route['distance_meters']) && $intended !== null && $endpoint !== null && $cart->heavy_vehicle_restriction !== 'UNANSWERED') {
                $input = ['groups' => [$load], 'distance_meters' => (int) $route['distance_meters'], 'heavy_vehicle_restriction' => $cart->heavy_vehicle_restriction === 'YES',
                    'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true, 'intended_location' => $intended, 'route_destination' => $endpoint];
                if ($cart->heavy_vehicle_restriction === 'YES') {
                    $input['alternative_drop_off'] = $endpoint;
                }
                $raw = $service->evaluate($vehicles, $input);
                $evaluation = ['status' => $raw['status'], 'reason' => $raw['reason'], 'groups' => array_map(static fn (array $g): array => [
                    'status' => $g['status'], 'missing' => $g['manual_review_reasons'] ?? [],
                    'excluded_reasons' => array_map(static fn (array $v): array => $v['reasons'], $g['excluded'] ?? []),
                    'fees_centavos' => array_column($g['candidates'] ?? [], 'estimated_charge_centavos'),
                ], $raw['groups'])];
            }
            $previews[] = ['requested_quantity' => $cart->quantity, 'destination_saved' => $cart->intended_location_id !== null,
                'heavy_vehicle_restriction' => $cart->heavy_vehicle_restriction, 'alternate_saved' => $cart->alternate_drop_off_location_id !== null,
                'cached_route_distance_meters' => $route['distance_meters'] ?? null,
                'cached_route_current' => $cached !== null && strtotime((string) $cached->expires_at) > time(),
                'load' => $load, 'fit_evaluation_using_cached_route' => $evaluation];
        }
        $results[] = ['sku' => $sku, 'product_measurements' => $measurements, 'eligible_vehicle_count' => count($vehicles),
            'vehicles' => array_map(static fn (array $v): array => array_intersect_key($v, array_flip(['vehicle_type', 'capacity_kg', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'base_fee_centavos', 'per_km_centavos', 'maximum_distance_km'])), $vehicles),
            'recent_active_cart_previews' => $previews];
    }
    echo json_encode($results, JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR).PHP_EOL;
} finally {
    DB::rollBack();
}
