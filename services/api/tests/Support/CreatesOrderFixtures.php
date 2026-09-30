<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;

/**
 * Phase 8 fixtures on top of CreatesDiscoveryFixtures: listings published through the real catalog API, carts
 * filled through the Buyer API, orders submitted through /buyers/checkouts and Vendor team members per role.
 */
trait CreatesOrderFixtures
{
    /** @return array<string, mixed> */
    protected function origin(): array
    {
        return ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 5];
    }

    /**
     * @param  list<array{price?: int, qty?: string, tax?: string, weight?: ?string}>  $variants
     */
    protected function orderListing(string $sku, array $variants = [['price' => 1800]]): string
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Listing '.$sku, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, [
            'lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => 'BrandCo', 'manufacturer' => 'Sample Block Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => ['thickness_mm' => '100'],
        ])->assertOk();
        $rows = [];
        foreach ($variants as $index => $variant) {
            $rows[] = ['sku' => $sku.'-V'.($index + 1), 'label' => 'Variant '.($index + 1), 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => '1', 'price_centavos' => $variant['price'] ?? 1800,
                'tax_category' => $variant['tax'] ?? 'NON_VAT', 'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => $variant['qty'] ?? '100'];
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => $rows])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Product photo'])->assertCreated();
        $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();

        return $listing;
    }

    /** @return list<string> */
    protected function variantIds(string $listing): array
    {
        return DB::table('listing_variants')->where('vendor_listing_id', $listing)->where('active', true)->orderBy('sort_order')->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
    }

    protected function addToCart(string $listing, string $quantity, ?string $fulfillment = null, int $variant = 0): void
    {
        $variantId = $this->variantIds($listing)[$variant];
        $price = (string) DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->value('id');
        $this->postJson('/api/v1/buyers/cart/items', array_filter(['listing_variant_id' => $variantId, 'expected_price_version_id' => $price, 'quantity' => $quantity, 'fulfillment_method' => $fulfillment]) + $this->origin(),
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
    }

    /** @param list<string> $vendorIds */
    protected function submitCheckout(array $vendorIds, bool $split = false, ?string $key = null): TestResponse
    {
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->assertOk()->json('data.lock_version');

        return $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => $vendorIds, 'split_confirmed' => $split], ['Idempotency-Key' => $key ?? (string) Str::uuid7()]);
    }

    protected function connectOnlinePayments(string $organizationId): void
    {
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => 'test-sub-'.Str::random(8),
            'connection_status' => 'CONNECTED_TEST', 'capabilities' => json_encode(['test_account_provisioned' => true]), 'provider_associated_at' => now(), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
    }

    protected function addVehicle(string $organizationId): string
    {
        $image = (string) $this->post('/api/v1/vendor/fleet/vehicle-images', ['file' => UploadedFile::fake()->image('truck.png')])->assertCreated()->json('data.file_id');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [['vehicle_category' => 'TRUCK', 'vehicle_type' => 'BOX_TRUCK', 'name' => 'Box truck', 'brand' => 'Isuzu', 'image_file_id' => $image,
            'number_available' => 2, 'capacity_kg' => 1000, 'cargo_length_m' => 4, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'HEAVY',
            'base_fee_centavos' => 50000, 'per_km_centavos' => 2500, 'maximum_distance_km' => 40, 'active' => true, 'available' => true]]])->assertOk();
        // The fixture has no onboarding requirement rows, so the fleet save reopens the profile; restore it.
        DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => 'COMPLETED']);

        return (string) DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->orderByDesc('created_at')->value('id');
    }

    protected function teamMember(VendorOrganization $organization, string $role): User
    {
        return $this->storeMember($organization, $role);
    }

    /** A saved Buyer location projected $meters from the origin on a geodesic bearing. */
    protected function savedLocation(User $buyer, string $label, float $meters, float $bearing = 0, string $kind = 'DELIVERY', bool $primary = false): string
    {
        $buyerId = $this->buyerProfileId($buyer);
        $point = DB::selectOne('SELECT ST_Y(p::geometry) AS latitude, ST_X(p::geometry) AS longitude, ST_AsText(p) AS wkt FROM (SELECT ST_Project(ST_SetSRID(ST_MakePoint(?::float8, ?::float8), 4326)::geography, ?::float8, radians(?::float8)) AS p) projected',
            [$this->originLongitude, $this->originLatitude, $meters, $bearing]);
        $addressId = (string) Str::uuid7();
        DB::statement('INSERT INTO addresses (id, owner_type, owner_id, label, formatted_address, latitude, longitude, location, psgc_resolution, source, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ST_GeogFromText(?), ?, ?, now(), now())',
            [$addressId, 'BUYER_PROFILE', $buyerId, $label, $label.', Quezon City', round((float) $point->latitude, 7), round((float) $point->longitude, 7), 'SRID=4326;'.$point->wkt, 'UNRESOLVED', 'MAP_PIN']);
        $locationId = (string) Str::uuid7();
        DB::table('buyer_locations')->insert(['id' => $locationId, 'buyer_profile_id' => $buyerId, 'address_id' => $addressId, 'label' => $label, 'location_kind' => $kind, 'is_primary' => $primary, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);

        return $locationId;
    }

    /**
     * A discoverable Self-Pickup store with online payments and one published listing.
     *
     * @param  list<array{price?: int, qty?: string, tax?: string}>  $variants
     * @return array{0: VendorOrganization, 1: User, 2: string}
     */
    protected function pickupStore(string $name, array $variants = [['price' => 1800, 'qty' => '20']], float $meters = 1000): array
    {
        [$store, $owner] = $this->activeStore($name, false);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing(Str::upper(Str::slug($name, '')).'-'.Str::upper(Str::random(3)), $variants);
        $this->placeStore($store->id, $meters);
        $this->connectOnlinePayments($store->id);

        return [$store, $owner, $listing];
    }

    /**
     * Submits one Self-Pickup order for the listing as a new Buyer. Returns [buyer, order id].
     *
     * @param  list<array{variant: int, quantity: string}>  $lines
     * @return array{0: User, 1: string}
     */
    protected function pickupOrder(VendorOrganization $store, string $listing, array $lines = [['variant' => 0, 'quantity' => '4']], ?User $buyer = null): array
    {
        if ($buyer === null) {
            $buyer = $this->buyer();
        } else {
            $this->signInBuyer($buyer);
        }
        foreach ($lines as $line) {
            $this->addToCart($listing, $line['quantity'], null, $line['variant']);
        }
        $checkout = $this->submitCheckout([$store->id])->assertCreated();

        return [$buyer, (string) $checkout->json('data.orders.0.id')];
    }

    /** @return array<string, mixed> The Vendor detail as the given member. */
    protected function vendorOrder(User $member, string $orderId): array
    {
        $this->signInStoreMember($member);

        return $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->json('data');
    }

    /**
     * Confirms every line at its requested quantity unless overridden.
     *
     * @param  array<string, string>  $quantities  order line id => confirmed quantity
     * @param  array<string, mixed>  $extra
     */
    protected function confirmOrder(User $member, string $orderId, array $quantities = [], array $extra = [], ?string $key = null): TestResponse
    {
        $detail = $this->vendorOrder($member, $orderId);
        $lines = array_map(static fn (array $line): array => ['order_line_id' => $line['id'], 'confirmed_quantity' => $quantities[$line['id']] ?? $line['requested_quantity']], $detail['lines']);
        $body = ['lock_version' => $detail['lock_version'], 'lines' => $lines] + ($detail['fulfillment_method'] === 'PICKUP' ? ['pickup' => ['ready_date' => CarbonImmutable::now('Asia/Manila')->addDay()->toDateString()]] : []);

        return $this->postJson('/api/v1/vendor/orders/'.$orderId.'/confirm', array_replace($body, $extra), ['Idempotency-Key' => $key ?? (string) Str::uuid7()]);
    }

    /** @return array<string, mixed> */
    protected function buyerOrder(User $buyer, string $orderId): array
    {
        $this->signInBuyer($buyer);

        return $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->json('data');
    }

    protected function activeHolds(string $orderId): int
    {
        return DB::table('inventory_holds')->where('source_type', 'ORDER')->where('source_id', $orderId)->where('state', 'ACTIVE')->count();
    }

    protected function reserved(string $variantId): string
    {
        return (string) DB::table('inventory_items')->where('listing_variant_id', $variantId)->value('hard_reserved_quantity');
    }

    /** Enables auto-accept for a variant with the given allotment and optional caps, plus the pickup lead time. */
    protected function enableAutoAccept(User $owner, string $organizationId, string $variantId, string $allotment, ?string $unitCap = null, ?int $amountCap = null, ?int $leadDays = 1): void
    {
        $this->signInStoreMember($owner);
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variantId, array_filter(['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => $allotment, 'max_unit_count' => $unitCap, 'max_order_amount_centavos' => $amountCap], static fn (mixed $value): bool => $value !== null))->assertOk();
        $settings = $this->getJson('/api/v1/vendor/inventory/settings')->assertOk()->json('data');
        $this->putJson('/api/v1/vendor/inventory/settings', ['lock_version' => $settings['lock_version'], 'reminder_local_time' => '08:00', 'email_reminders' => true, 'auto_accept_ready_lead_days' => $leadDays])->assertOk()
            ->assertJsonPath('data.auto_accept_ready_lead_days', $leadDays);
        DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => 'COMPLETED']);
    }
}
