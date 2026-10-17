<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Ready-Mixed Concrete (owner decisions 2026-10-16): mixer-only Site Delivery, volume against Mixer Capacity,
 * one variant per Required PSI, Vendor-chosen mobilization basis, and the free site inspection request.
 */
final class ReadyMixedConcreteTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
    }

    public function test_ready_mixed_concrete_is_its_own_cubic_meter_material_with_a_required_psi(): void
    {
        $material = DB::table('materials as m')->join('material_categories as c', 'c.id', '=', 'm.material_category_id')->join('units as u', 'u.id', '=', 'm.canonical_unit_id')
            ->where('m.code', 'READY_MIXED_CONCRETE')->first(['m.id', 'm.regulated', 'c.code as category', 'u.code as unit']);
        self::assertSame(['READY_MIXED_CONCRETE', 'CUM', false], [$material->category, $material->unit, (bool) $material->regulated]);
        $psi = DB::table('technical_attribute_definitions as d')->join('material_categories as c', 'c.id', '=', 'd.material_category_id')
            ->where('c.code', 'READY_MIXED_CONCRETE')->where('d.code', 'compressive_strength_psi')->first(['d.required', 'd.value_type', 'd.comparability_key']);
        self::assertSame([true, 'ENUM', true], [(bool) $psi->required, $psi->value_type, (bool) $psi->comparability_key]);
        // Bagged cement keeps its own category, unit and ordinary cargo attributes.
        self::assertSame('BAG', DB::table('materials as m')->join('units as u', 'u.id', '=', 'm.canonical_unit_id')->where('m.code', 'PORTLAND_CEMENT')->value('u.code'));
    }

    public function test_publishing_needs_a_mixer_psi_and_weight_per_cubic_meter_but_no_cargo_dimensions(): void
    {
        [$store, $owner] = $this->activeStore('Batching Plant', false, true);
        $this->signInStoreMember($owner);
        $listing = $this->draftConcrete('RMC-A', [['psi' => '3000'], ['psi' => null]]);
        $blockers = array_column($this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertOk()->json('data.blockers'), 'key');
        self::assertContains('delivery_vehicle', $blockers, 'No mixer is configured yet.');
        self::assertContains('technical_attributes.compressive_strength_psi', $blockers);
        self::assertNotContains('variants.0.weight_kg', $blockers, 'Cargo dimensions are not required for ready-mixed concrete.');

        $this->placeStore($store->id, 1000);
        $this->mixer($store->id);
        [$first, $second] = $this->variantIds($listing);
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $this->lock($listing), 'variants' => [
            ['id' => $first] + $this->concreteVariant('RMC-A-1', '3000'), array_replace(['id' => $second] + $this->concreteVariant('RMC-A-2', '4000'), ['weight_kg' => null])]])->assertOk();
        self::assertSame(['variants.1.weight_kg'], array_column($this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data.blockers'), 'key'));
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $this->lock($listing), 'variants' => [
            ['id' => $first] + $this->concreteVariant('RMC-A-1', '3000'), ['id' => $second] + $this->concreteVariant('RMC-A-2', '4000')]])->assertOk();
        $this->publish($listing)->assertOk();
        // A PSI outside the allowed classes is rejected at save.
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $this->lock($listing), 'variants' => [['id' => $first] + $this->concreteVariant('RMC-A-1', '3100')]])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
    }

    public function test_an_other_label_ready_mix_product_must_use_the_canonical_material(): void
    {
        [, $owner] = $this->activeStore('Label Plant', false, true);
        $this->signInStoreMember($owner);
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Ready mix concrete', 'vendor_sku' => 'OTHER-RMC'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $reasons = collect($this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data.blockers'))->where('key', 'material')->pluck('reason')->implode(' ');
        self::assertStringContainsString('Ready-mixed concrete', $reasons);
        self::assertStringContainsString('Concrete Mixer Truck', $reasons);
    }

    public function test_mobilization_is_a_vendor_chosen_mixer_rate_and_is_versioned(): void
    {
        [$store, $owner] = $this->activeStore('Rate Plant', false, true);
        $this->signInStoreMember($owner);
        $image = $this->vehicleImage();
        $box = ['vehicle_category' => 'TRUCK', 'vehicle_type' => 'BOX_TRUCK', 'name' => 'Box truck', 'image_file_id' => $image, 'number_available' => 1, 'capacity_kg' => 1000,
            'cargo_length_m' => 4, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'HEAVY', 'base_fee_centavos' => 50000, 'per_km_centavos' => 2500, 'maximum_distance_km' => 40];
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$box + ['mobilization_fee_centavos' => 100000, 'mobilization_basis' => 'PER_TRUCK']]])
            ->assertUnprocessable()->assertJsonPath('errors.0.details', fn (array $details): bool => isset($details['vehicles.0.mobilization_fee_centavos']));
        $mixer = $this->mixerPayload($image);
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [array_replace($mixer, ['mobilization_basis' => null])]])
            ->assertUnprocessable()->assertJsonPath('errors.0.details', fn (array $details): bool => isset($details['vehicles.0.mobilization_basis']));
        $saved = $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$mixer]])->assertOk()->json('data.0');
        self::assertSame([150000, 'PER_TRUCK'], [$saved['mobilization_fee_centavos'], $saved['mobilization_basis']]);
        $vehicle = (string) DB::table('vendor_vehicles')->where('vendor_organization_id', $store->id)->value('id');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [array_replace($mixer, ['id' => $vehicle, 'lock_version' => $saved['lock_version'], 'mobilization_basis' => 'PER_TRIP'])]])->assertOk();
        $rates = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicle)->orderBy('version')->get(['version', 'mobilization_basis']);
        self::assertSame([[1, 'PER_TRUCK'], [2, 'PER_TRIP']], $rates->map(static fn (object $rate): array => [(int) $rate->version, $rate->mobilization_basis])->all(), 'A basis change appends a rate version; earlier snapshots keep theirs.');
    }

    public function test_ready_mixed_is_site_delivery_only_and_estimated_by_mixer_volume_with_mobilization(): void
    {
        [$store, $owner] = $this->activeStore('Volume Plant', false, true);
        $this->signInStoreMember($owner);
        $this->placeStore($store->id, 1000);
        $this->mixer($store->id);
        $listing = $this->publishedConcrete('RMC-V');
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->connectOnlinePayments($store->id);
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Tower site', 0);

        $details = $this->postJson('/api/v1/buyers/listings/'.$listing.'/details', $this->origin())->assertOk()->json('data');
        self::assertFalse($details['fulfillment']['pickup_available']);
        self::assertSame(['Order volume (m³)', 'compressive_strength_psi', 'CONCRETE_MIXER', true, true], [$details['ready_mixed_concrete']['quantity_label'], $details['ready_mixed_concrete']['strength_attribute'],
            $details['ready_mixed_concrete']['delivery_vehicle'], $details['ready_mixed_concrete']['site_delivery_only'], $details['ready_mixed_concrete']['site_inspection']['available']]);

        $this->cartAdd($listing, '7.5', 'PICKUP')->assertUnprocessable()->assertJsonPath('errors.0.code', 'SITE_DELIVERY_REQUIRED');
        $cart = $this->cartAdd($listing, '7.5')->assertOk()->json('data');
        self::assertSame(['DELIVERY'], $cart['groups'][0]['fulfillment_options']);
        self::assertSame('DELIVERY', $cart['groups'][0]['fulfillment_method']);
        self::assertTrue($cart['groups'][0]['lines'][0]['ready_mixed_concrete']);
        $this->putJson('/api/v1/buyers/cart/vendor-groups/'.$store->id.'/fulfillment', ['lock_version' => $cart['lock_version'], 'fulfillment_method' => 'PICKUP'])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'SITE_DELIVERY_REQUIRED');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $cart['lock_version'], 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'NO'])->assertOk();

        $delivery = $this->postJson('/api/v1/buyers/cart/checkout-preview', ['request_version' => 'rmc'])->assertOk()->json('data.groups.0.delivery');
        self::assertSame('ADVISORY_ESTIMATE', $delivery['status']);
        $option = $delivery['estimate']['options'][0];
        // 7.5 m³ in 6 m³ drums: two trips on two trucks; (₱800 + ₱40 × 4.2 km) per trip plus ₱1,500 per truck.
        self::assertSame(['CONCRETE_MIXER', 2, 2, 'PER_TRUCK', 300000], [$option['vehicle_type'], $option['trips'], $option['vehicles'], $option['mobilization_basis'], $option['mobilization_total_centavos']]);
        self::assertSame((80000 + 16800) * 2 + 300000, $option['fee_centavos']);
        self::assertSame(['total_m3' => 7.5, 'full_load_m3' => 6, 'full_trips' => 1, 'last_trip_m3' => 1.5], $option['volume_plan']);
    }

    public function test_ready_mixed_offers_disappear_while_the_store_has_no_available_mixer(): void
    {
        [$store, $owner] = $this->activeStore('Idle Plant', false, true);
        $this->signInStoreMember($owner);
        $this->placeStore($store->id, 1000);
        $this->mixer($store->id);
        $listing = $this->publishedConcrete('RMC-I');
        $this->buyer();
        $this->postJson('/api/v1/buyers/listings/'.$listing.'/details', $this->origin())->assertOk();
        DB::table('vendor_vehicles')->where('vendor_organization_id', $store->id)->update(['available' => false]);
        $this->postJson('/api/v1/buyers/listings/'.$listing.'/details', $this->origin())->assertNotFound()->assertJsonPath('errors.0.code', 'LISTING_UNAVAILABLE');
    }

    public function test_free_site_inspection_flows_through_the_store_conversation_and_ends_in_a_measured_volume(): void
    {
        [$store, $owner] = $this->activeStore('Inspect Plant', false, true);
        $this->signInStoreMember($owner);
        $this->placeStore($store->id, 1000);
        $this->mixer($store->id);
        $listing = $this->publishedConcrete('RMC-S');
        $variant = (string) DB::table('listing_variants')->where('vendor_listing_id', $listing)->orderBy('sort_order')->value('id');
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Warehouse slab', 0);
        $date = CarbonImmutable::now('Asia/Manila')->addDays(2)->toDateString();
        $payload = ['listing_id' => $listing, 'listing_variant_id' => $variant, 'location_id' => $site, 'preferred_date' => $date, 'notes' => 'Gate code 4417; slab is 12 m by 20 m.'];

        $this->postJson('/api/v1/buyers/site-inspections', array_replace($payload, ['preferred_date' => CarbonImmutable::now('Asia/Manila')->subDay()->toDateString()]), ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $key = (string) Str::uuid7();
        $created = $this->postJson('/api/v1/buyers/site-inspections', $payload, ['Idempotency-Key' => $key])->assertCreated()->json('data');
        self::assertSame($created, $this->postJson('/api/v1/buyers/site-inspections', $payload, ['Idempotency-Key' => $key])->assertCreated()->json('data'), 'A retried request returns the same inspection.');
        $this->postJson('/api/v1/buyers/site-inspections', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'SITE_INSPECTION_ALREADY_OPEN');
        $conversation = $created['conversation_id'];
        self::assertSame($site, json_decode((string) DB::table('conversations')->where('id', $conversation)->value('locked_reference'), true)['destination']['intended']['location_id'], 'The inspected site is the quotation destination.');
        self::assertStringNotContainsString('4417', (string) DB::table('site_inspection_requests')->where('id', $created['id'])->value('buyer_notes_encrypted'), 'Notes are stored encrypted.');
        self::assertSame(0, DB::table('orders')->count(), 'An inspection request creates no order.');

        // Another Buyer cannot see or cancel it.
        $other = $this->buyer();
        $this->getJson('/api/v1/buyers/conversations/'.$conversation)->assertStatus(404);
        $this->signInBuyer($buyer);
        $view = $this->getJson('/api/v1/buyers/conversations/'.$conversation)->assertOk()->json('data.site_inspections.0');
        self::assertSame(['REQUESTED', true, false, 'Gate code 4417; slab is 12 m by 20 m.'], [$view['status'], $view['actions']['cancel'], $view['actions']['schedule'], $view['buyer_notes']]);

        $this->signInStoreMember($owner);
        $inspection = $this->getJson('/api/v1/vendor/conversations/'.$conversation)->assertOk()->json('data.site_inspections.0');
        self::assertSame([true, true, false], [$inspection['actions']['schedule'], $inspection['actions']['decline'], $inspection['actions']['complete']]);
        $base = '/api/v1/vendor/conversations/'.$conversation.'/site-inspections/'.$created['id'];
        $this->postJson($base.'/complete', ['lock_version' => 1, 'measured_volume_m3' => '7.5'])->assertConflict()->assertJsonPath('errors.0.code', 'SITE_INSPECTION_CLOSED');
        $this->postJson($base.'/schedule', ['lock_version' => 1, 'scheduled_for' => now()->subHour()->toIso8601String()])->assertUnprocessable();
        $this->postJson($base.'/schedule', ['lock_version' => 1, 'scheduled_for' => now()->addDays(2)->toIso8601String(), 'note' => 'Our engineer will call ahead.'])->assertOk()
            ->assertJsonPath('data.site_inspections.0.status', 'SCHEDULED');
        $this->postJson($base.'/schedule', ['lock_version' => 1, 'scheduled_for' => now()->addDays(3)->toIso8601String()])->assertConflict()->assertJsonPath('errors.0.code', 'SITE_INSPECTION_VERSION_CONFLICT');
        $this->postJson($base.'/complete', ['lock_version' => 2, 'measured_volume_m3' => '0'])->assertUnprocessable();
        $done = $this->postJson($base.'/complete', ['lock_version' => 2, 'measured_volume_m3' => '7.5', 'note' => 'Slab 12 × 20 m at 0.3 m plus waste.'])->assertOk()->json('data.site_inspections.0');
        self::assertSame(['COMPLETED', '7.500'], [$done['status'], $done['measured_volume_m3']]);
        self::assertStringContainsString('Estimated volume: 7.5 m³', (string) DB::table('messages')->where('conversation_id', $conversation)->orderByDesc('id')->value('body'));
        self::assertGreaterThanOrEqual(2, DB::table('notifications')->where('user_id', $buyer->id)->where('category', 'MESSAGES')->where('title', 'Site inspection update')->count(), 'Scheduled and completed both notify the Buyer.');
        self::assertGreaterThanOrEqual(1, DB::table('notifications')->where('user_id', $owner->id)->where('title', 'Site inspection requested')->count());

        // The Buyer may request again and cancel; a closed request accepts no further action.
        $this->signInBuyer($buyer);
        $second = $this->postJson('/api/v1/buyers/site-inspections', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/conversations/'.$conversation.'/site-inspections/'.$second.'/cancel', ['lock_version' => 1])->assertOk()->assertJsonPath('data.site_inspections.0.status', 'CANCELLED');
        $this->postJson('/api/v1/buyers/conversations/'.$conversation.'/site-inspections/'.$second.'/cancel', ['lock_version' => 2])->assertConflict()->assertJsonPath('errors.0.code', 'SITE_INSPECTION_CLOSED');
        unset($other);
    }

    public function test_site_inspection_is_only_for_ready_mixed_concrete_and_fulfillment_staff_cannot_decide(): void
    {
        [$store, $owner] = $this->activeStore('Mixed Yard', false, true);
        $this->signInStoreMember($owner);
        $this->placeStore($store->id, 1000);
        $this->mixer($store->id);
        $concrete = $this->publishedConcrete('RMC-F');
        $blocks = $this->publishableListing('CHB-F');
        $this->publish($blocks)->assertOk();
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Site', 0);
        $date = CarbonImmutable::now('Asia/Manila')->addDay()->toDateString();
        $this->postJson('/api/v1/buyers/site-inspections', ['listing_id' => $blocks, 'location_id' => $site, 'preferred_date' => $date], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'SITE_INSPECTION_UNAVAILABLE');
        $created = $this->postJson('/api/v1/buyers/site-inspections', ['listing_id' => $concrete, 'location_id' => $site, 'preferred_date' => $date], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $staff = User::query()->findOrFail((int) DB::table('vendor_memberships')->where('vendor_organization_id', $store->id)->where('role', 'FULFILLMENT')->value('user_id'));
        $this->signInStoreMember($staff);
        // Fulfillment Staff are not part of the sales conversation, so its existence is not disclosed.
        $this->postJson('/api/v1/vendor/conversations/'.$created['conversation_id'].'/site-inspections/'.$created['id'].'/decline', ['lock_version' => 1, 'reason' => 'Outside our batching schedule.'])
            ->assertNotFound();
        self::assertSame('REQUESTED', DB::table('site_inspection_requests')->where('id', $created['id'])->value('status'));
    }

    // ── Helpers ────────────────────────────────────────────────────────────────────────────────────

    /** @return array<string, mixed> */
    private function origin(): array
    {
        return ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 5];
    }

    /** @param list<array{psi: ?string}> $variants */
    private function draftConcrete(string $sku, array $variants): string
    {
        $material = DB::table('materials')->where('code', 'READY_MIXED_CONCRETE')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Ready-mixed concrete '.$sku, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Batched to order.'])->assertOk();
        $rows = [];
        foreach ($variants as $index => $variant) {
            $rows[] = $this->concreteVariant($sku.'-'.($index + 1), $variant['psi']);
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => $rows])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Mixer pouring concrete'])->assertCreated();

        return $listing;
    }

    /** @return array<string, mixed> */
    private function concreteVariant(string $sku, ?string $psi): array
    {
        $unit = DB::table('units')->where('code', 'CUM')->value('id');

        return ['sku' => $sku, 'label' => $psi === null ? 'Unrated' : $psi.' PSI', 'unit_id' => $unit, 'pack_quantity' => '1', 'price_centavos' => 520000, 'tax_category' => 'NON_VAT',
            'weight_kg' => '2400', 'quantity_on_hand' => '60', 'attributes' => $psi === null ? [] : ['compressive_strength_psi' => $psi]];
    }

    private function publishedConcrete(string $sku): string
    {
        $listing = $this->draftConcrete($sku, [['psi' => '3000'], ['psi' => '4000']]);
        self::assertSame([], $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data.blockers'));
        $this->publish($listing)->assertOk();

        return $listing;
    }

    private function publish(string $listing): TestResponse
    {
        return $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => $this->lock($listing)], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    /** @return list<string> */
    private function variantIds(string $listing): array
    {
        return DB::table('listing_variants')->where('vendor_listing_id', $listing)->orderBy('sort_order')->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
    }

    private function lock(string $listing): int
    {
        return (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version');
    }

    private function cartAdd(string $listing, string $quantity, ?string $fulfillment = null): TestResponse
    {
        $variant = (string) DB::table('listing_variants')->where('vendor_listing_id', $listing)->orderBy('sort_order')->value('id');
        $price = (string) DB::table('listing_price_versions')->where('listing_variant_id', $variant)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->value('id');

        return $this->postJson('/api/v1/buyers/cart/items', array_filter(['listing_variant_id' => $variant, 'expected_price_version_id' => $price, 'quantity' => $quantity, 'fulfillment_method' => $fulfillment]) + $this->origin(),
            ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    private function vehicleImage(): string
    {
        return (string) $this->post('/api/v1/vendor/fleet/vehicle-images', ['file' => UploadedFile::fake()->image('mixer.png')])->assertCreated()->json('data.file_id');
    }

    /** @return array<string, mixed> */
    private function mixerPayload(string $image): array
    {
        return ['vehicle_category' => 'TRUCK', 'vehicle_type' => 'CONCRETE_MIXER', 'name' => 'Transit mixer', 'brand' => 'Isuzu', 'image_file_id' => $image, 'number_available' => 2,
            'capacity_kg' => 24000, 'mixer_capacity_m3' => 6, 'heavy_classification' => 'HEAVY', 'base_fee_centavos' => 80000, 'per_km_centavos' => 4000, 'maximum_distance_km' => 40,
            'mobilization_fee_centavos' => 150000, 'mobilization_basis' => 'PER_TRUCK', 'active' => true, 'available' => true];
    }

    private function mixer(string $organizationId): void
    {
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->mixerPayload($this->vehicleImage())]])->assertOk();
        // The fixture activates stores without onboarding requirement rows; a fleet save reopens the profile.
        DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => 'COMPLETED']);
    }

    private function connectOnlinePayments(string $organizationId): void
    {
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => 'test-sub-'.Str::random(8),
            'connection_status' => 'CONNECTED_TEST', 'capabilities' => json_encode(['test_account_provisioned' => true]), 'provider_associated_at' => now(), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
    }

    private function savedLocation(User $buyer, string $label, float $meters, float $bearing = 0): string
    {
        $buyerId = $this->buyerProfileId($buyer);
        $point = DB::selectOne('SELECT ST_Y(p::geometry) AS latitude, ST_X(p::geometry) AS longitude, ST_AsText(p) AS wkt FROM (SELECT ST_Project(ST_SetSRID(ST_MakePoint(?::float8, ?::float8), 4326)::geography, ?::float8, radians(?::float8)) AS p) projected',
            [$this->originLongitude, $this->originLatitude, $meters, $bearing]);
        $addressId = (string) Str::uuid7();
        DB::statement('INSERT INTO addresses (id, owner_type, owner_id, label, formatted_address, latitude, longitude, location, psgc_resolution, source, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ST_GeogFromText(?), ?, ?, now(), now())',
            [$addressId, 'BUYER_PROFILE', $buyerId, $label, $label.', Quezon City', round((float) $point->latitude, 7), round((float) $point->longitude, 7), 'SRID=4326;'.$point->wkt, 'UNRESOLVED', 'MAP_PIN']);
        $locationId = (string) Str::uuid7();
        DB::table('buyer_locations')->insert(['id' => $locationId, 'buyer_profile_id' => $buyerId, 'address_id' => $addressId, 'label' => $label, 'location_kind' => 'PROJECT_SITE', 'is_primary' => false, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);

        return $locationId;
    }
}
