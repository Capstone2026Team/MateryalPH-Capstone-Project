<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\PsgcCsvSource;
use App\Domain\Geography\PsgcImporter;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class PhaseSixBuyerDiscoveryTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use RefreshDatabase;

    private FakePlacesProvider $places;

    private FakeRouteProvider $routes;

    private FakeAddressGeocoder $geocoder;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->places = new FakePlacesProvider;
        $this->routes = new FakeRouteProvider;
        $this->geocoder = new FakeAddressGeocoder;
        $this->app->instance(PlacesProvider::class, $this->places);
        $this->app->instance(RouteProvider::class, $this->routes);
        $this->app->instance(AddressGeocoder::class, $this->geocoder);
    }

    public function test_radius_membership_uses_geodesic_st_dwithin_with_an_inclusive_boundary_and_rejects_unsupported_radii(): void
    {
        [$store] = $this->activeStore('Boundary Hardware');
        $this->buyer();

        foreach ([0, 90, 180, 270] as $bearing) {
            $this->placeStore($store->id, 5000, $bearing);
            $this->search()->assertOk()->assertJsonPath('data.0.result_id', $store->id)->assertJsonPath('data.0.distance_meters', 5000);
        }
        $this->placeStore($store->id, 5000.05);
        $this->search()->assertOk()->assertJsonCount(0, 'data');
        $this->placeStore($store->id, 5001);
        $this->search()->assertOk()->assertJsonCount(0, 'data');
        $this->search(['radius_km' => 10])->assertOk()->assertJsonPath('data.0.result_id', $store->id);
        self::assertSame(0, $this->routes->calls, 'Radius membership never requests a driving route.');

        foreach ([7, 0, 60, 100] as $unsupported) {
            $this->search(['radius_km' => $unsupported])->assertStatus(422)->assertJsonPath('errors.0.code', 'RADIUS_UNSUPPORTED');
        }
        $this->putJson('/api/v1/buyers/discovery/preferences', ['radius_km' => 15])->assertStatus(422)->assertJsonPath('errors.0.code', 'RADIUS_UNSUPPORTED');
        $this->search(['latitude' => 35.6, 'longitude' => 139.7])->assertStatus(422)->assertJsonPath('errors.0.code', 'LOCATION_OUTSIDE_PHILIPPINES');
    }

    public function test_expansion_is_offered_but_never_applied_and_50_km_is_the_maximum(): void
    {
        [$near] = $this->activeStore('Near Store');
        [$far] = $this->activeStore('Far Store');
        $this->placeStore($near->id, 1200);
        $this->placeStore($far->id, 8000);
        $buyer = $this->buyer();

        $response = $this->search()->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('meta.scope.radius_km', 5)
            ->assertJsonPath('meta.expansion.suggested_radius_km', 10)
            ->assertJsonPath('meta.expansion.requires_confirmation', true)
            ->assertJsonPath('meta.expansion.reason', 'FEWER_THAN_THREE_VERIFIED_VENDORS');
        self::assertSame([$near->id], array_column($response->json('data'), 'result_id'));
        self::assertSame(5, (int) DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('discovery_radius_km'), 'A suggestion never changes the saved radius.');

        $this->search(['radius_km' => 10])->assertOk()->assertJsonCount(2, 'data');
        $this->search(['radius_km' => 50])->assertOk()->assertJsonPath('meta.expansion.suggested_radius_km', null)->assertJsonPath('meta.expansion.at_maximum', true);
        $this->putJson('/api/v1/buyers/discovery/preferences', ['radius_km' => 10])->assertOk()->assertJsonPath('data.radius_km', 10);
        $this->postJson('/api/v1/buyers/discovery/search', ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude])->assertOk()->assertJsonPath('meta.scope.radius_km', 10);
    }

    public function test_a_renamed_store_stays_consistent_across_map_list_preview_store_profile_and_favorites(): void
    {
        [$store] = $this->activeStore('Sampaloc Lumber');
        $this->placeStore($store->id, 1900);
        $this->buyer();
        self::assertSame('Sampaloc Lumber', $this->search()->json('data.0.name'));
        // The Vendor Setup write path (and its reopen rules) is covered by the Phase 3 suite; here the canonical
        // Public Store Name changes after a Buyer already loaded results, and every read surface must follow it.
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['public_store_name' => 'Sampaloc Lumber Hardware Depot', 'updated_at' => now()]);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['store_name' => 'Sampaloc Lumber Hardware Depot']);
        $this->putJson('/api/v1/buyers/favorite-suppliers/'.$store->id)->assertOk();

        $result = $this->search()->assertOk()->json('data.0');
        self::assertSame('Sampaloc Lumber Hardware Depot', $result['name'], 'Map marker and list row share one result.');
        self::assertTrue($result['is_favorite']);
        $this->search(['favorites_only' => true])->assertOk()->assertJsonPath('data.0.name', 'Sampaloc Lumber Hardware Depot');
        $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertOk()->assertJsonPath('data.public_store_name', 'Sampaloc Lumber Hardware Depot');
        $this->getJson('/api/v1/stores')->assertOk()->assertJsonPath('data.0.public_store_name', 'Sampaloc Lumber Hardware Depot');
        $this->getJson('/api/v1/buyers/favorite-suppliers')->assertOk()->assertJsonPath('data.0.name', 'Sampaloc Lumber Hardware Depot')->assertJsonPath('data.0.currently_discoverable', true);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $store->id, 'legal_name' => 'Sampaloc Lumber Legal Private Corporation']);
    }

    public function test_public_discovery_payloads_exclude_private_vendor_fields_and_buyer_coordinates(): void
    {
        [$store] = $this->activeStore('Privacy Supply');
        $this->placeStore($store->id, 2500, 45);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['registered_name' => 'Hidden Registered Name', 'store_email' => 'private-owner@example.test',
            'identity_id_number_encrypted' => 'encrypted-secret-value', 'identity_id_number_last4' => '9876', 'legal_business_name' => 'Hidden Legal Business']);
        $this->places->places = [['place_id' => 'ChIJprivacyDirectory01', 'name' => 'Corner Hardware', 'latitude' => 14.6030, 'longitude' => 120.9850, 'formatted_address' => 'Quiapo, Manila', 'primary_type' => 'hardware_store', 'business_status' => 'OPERATIONAL']];
        $buyer = $this->buyer();
        $this->putJson('/api/v1/buyers/favorite-suppliers/'.$store->id)->assertOk();

        $bodies = [
            $this->search()->assertOk()->getContent(),
            $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertOk()->getContent(),
            $this->getJson('/api/v1/buyers/favorite-suppliers')->assertOk()->getContent(),
        ];
        foreach ($bodies as $body) {
            foreach (['Legal Private Corporation', 'Hidden Registered Name', 'Hidden Legal Business', 'private-owner@example.test', 'encrypted-secret-value', 'PHASE6TESTSECRET', '14.5995', '120.9842'] as $privateValue) {
                self::assertStringNotContainsString($privateValue, $body, 'Public payload leaked '.$privateValue);
            }
            foreach (['legal_name', 'registered_name', 'legal_business_name', 'store_email', 'identity_id_number_last4', 'identity_id_number_encrypted', 'taxpayer_key_hash', 'tin', 'provider_account_id', 'site_instructions', 'contact_phone_e164'] as $privateKey) {
                self::assertStringNotContainsString('"'.$privateKey.'"', $body, 'Public payload exposed '.$privateKey);
            }
        }
        $meta = $this->search()->json('meta.scope');
        self::assertArrayNotHasKey('latitude', $meta);
        self::assertArrayNotHasKey('longitude', $meta);
        self::assertMatchesRegularExpression('/^[a-f0-9]{32}$/', $meta['origin_version'], 'The origin version is opaque.');
        self::assertSame(0, DB::table('audit_logs')->where('actor_user_id', $buyer->id)->where('after', 'like', '%14.59%')->count());
    }

    public function test_active_stores_without_eligible_offerings_are_excluded_even_with_a_stale_discoverable_flag(): void
    {
        [$empty] = $this->activeStore('Empty Shelves', withListing: false);
        DB::table('vendor_organizations')->where('id', $empty->id)->update(['marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->placeStore($empty->id, 1000);
        [$stocked] = $this->activeStore('Stocked Shelves');
        $this->placeStore($stocked->id, 3000);
        $this->buyer();

        $response = $this->search()->assertOk();
        self::assertSame([$stocked->id], array_column($response->json('data'), 'result_id'));
        $this->postJson('/api/v1/buyers/discovery/routes', ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'radius_km' => 5, 'tier' => 'VERIFIED_VENDOR', 'supplier_id' => $empty->id, 'request_version' => 'sel-1'])
            ->assertNotFound()->assertJsonPath('errors.0.code', 'SUPPLIER_NOT_FOUND');
        $this->putJson('/api/v1/buyers/favorite-suppliers/'.$empty->id)->assertOk();
        $favorite = collect($this->getJson('/api/v1/buyers/favorite-suppliers')->assertOk()->json('data'))->firstWhere('vendor_id', $empty->id);
        self::assertFalse($favorite['currently_discoverable'], 'A saved Favorite without offerings is not shown as eligible.');
    }

    public function test_stale_eligibility_is_revalidated_immediately_and_expired_directory_cache_is_never_served(): void
    {
        [$store] = $this->activeStore('Stale Stock Depot');
        $this->placeStore($store->id, 2000);
        $this->buyer();
        $this->search()->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('meta.eligibility_version', EligibleOfferQuery::VERSION);
        $before = app(EligibleOfferQuery::class)->currentCounts();

        // Stock confirmation ages past the 15-day window before any scheduled re-evaluation runs.
        DB::table('inventory_items')->whereIn('listing_variant_id', DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->where('l.vendor_organization_id', $store->id)->select('v.id'))
            ->update(['confirmed_at' => now()->subDays(16)]);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $store->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->search()->assertOk()->assertJsonCount(0, 'data');
        EligibleOfferQuery::invalidate();
        self::assertSame($before['vendors'] - 1, app(EligibleOfferQuery::class)->currentCounts()['vendors'], 'Cached counts are regenerated after an eligibility event.');

        DB::table('place_cache_entries')->delete();
        $this->places->nearbyCalls = 0;
        $this->places->places = [['place_id' => 'ChIJcacheDirectory0001', 'name' => 'Cached Hardware', 'latitude' => 14.6010, 'longitude' => 120.9850, 'formatted_address' => 'Manila', 'primary_type' => 'hardware_store', 'business_status' => 'OPERATIONAL']];
        $this->search()->assertOk()->assertJsonPath('meta.directory.status', 'AVAILABLE')->assertJsonPath('data.0.name', 'Cached Hardware');
        $this->search()->assertOk();
        self::assertSame(1, $this->places->nearbyCalls, 'A fresh search cell is served from the bounded cache.');

        DB::table('directory_suppliers')->update(['expires_at' => now()->subMinute(), 'refreshed_at' => now()->subDays(8)]);
        DB::table('place_cache_entries')->update(['expires_at' => now()->subMinute()]);
        $this->places->failure = 'TIMEOUT';
        $this->search()->assertOk()->assertJsonCount(0, 'data')->assertJsonPath('meta.directory.status', 'UNAVAILABLE');
        $this->places->failure = null;
        $this->search()->assertOk()->assertJsonPath('data.0.name', 'Cached Hardware');
        self::assertSame(3, $this->places->nearbyCalls, 'Expired cells are re-queried rather than served.');
        $this->artisan('materyalph:geography-cache-prune')->assertSuccessful();
    }

    public function test_schedule_only_changes_leave_discovery_membership_order_and_expansion_unchanged(): void
    {
        [$first, $owner] = $this->activeStore('Alpha Hardware');
        [$second] = $this->activeStore('Beta Hardware');
        $this->placeStore($first->id, 1500);
        $this->placeStore($second->id, 3500);
        $this->buyer();
        $shape = fn (): array => (function (array $json): array {
            return [array_column($json['data'], 'result_id'), array_column($json['data'], 'rank'), $json['meta']['counts'], $json['meta']['expansion']];
        })($this->search()->assertOk()->json());
        $baseline = $shape();

        $profileId = (string) DB::table('store_profiles')->where('vendor_organization_id', $first->id)->value('id');
        app(StoreOperatingSchedule::class)->replaceWeekly($profileId, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));
        self::assertSame($baseline, $shape(), 'All-Closed hours do not remove or re-rank a store.');
        self::assertSame('CLOSED', $this->search()->json('data.0.vendor.open_status.status'));

        DB::table('store_operation_date_overrides')->insert(['id' => (string) Str::uuid7(), 'store_profile_id' => $profileId, 'specific_date' => now('Asia/Manila')->toDateString(), 'is_closed' => false, 'opens_at' => '00:00', 'closes_at' => '23:59', 'created_by_user_id' => $owner->id, 'updated_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        self::assertSame($baseline, $shape());
        self::assertSame('DATE_OVERRIDE', $this->search()->json('data.0.vendor.open_status.basis'));

        DB::table('operating_hours')->where('store_profile_id', $profileId)->delete();
        self::assertSame($baseline, $shape(), 'Unavailable hours never hide a store.');
        self::assertSame('UNAVAILABLE', $this->search()->json('data.0.vendor.open_status.status'));
        $this->getJson('/api/v1/stores/'.$first->id.'/profile')->assertOk()->assertJsonPath('data.hours_status', 'UNAVAILABLE')->assertJsonPath('data.operating_schedule', []);
    }

    public function test_directory_suppliers_are_informational_attributed_and_never_transactional(): void
    {
        [$store] = $this->activeStore('Verified Twin');
        $this->placeStore($store->id, 1000);
        $this->places->places = [
            ['place_id' => 'ChIJdirectoryInside01', 'name' => 'Panda Construction Supply', 'latitude' => 14.6200, 'longitude' => 121.0000, 'formatted_address' => 'Sampaloc, Manila', 'primary_type' => 'hardware_store', 'business_status' => 'OPERATIONAL'],
            ['place_id' => 'ChIJdirectoryOutside1', 'name' => 'Far Away Hardware', 'latitude' => 14.9000, 'longitude' => 121.2000, 'formatted_address' => 'Far', 'primary_type' => 'hardware_store', 'business_status' => 'OPERATIONAL'],
        ];
        $this->places->details['ChIJdirectoryInside01'] = ['place_id' => 'ChIJdirectoryInside01', 'name' => 'Panda Construction Supply', 'formatted_address' => '3682 Redbud Drive, Sampaloc, Manila', 'latitude' => 14.6200, 'longitude' => 121.0000,
            'national_phone' => '(02) 8236 5500', 'website_uri' => 'https://panda.example.test', 'google_maps_uri' => 'https://maps.google.com/?cid=1', 'weekday_descriptions' => ['Monday: 8:30 AM – 5:30 PM'], 'rating' => 4.8, 'user_rating_count' => 120, 'business_status' => 'OPERATIONAL'];
        $this->buyer();

        $items = $this->search()->assertOk()->assertJsonPath('meta.directory.attribution.provider', 'GOOGLE')->json('data');
        self::assertSame(['VERIFIED_VENDOR', 'DIRECTORY_SUPPLIER'], array_column($items, 'tier'), 'Distance order, Far Away Hardware stays outside the radius.');
        $directory = $items[1];
        self::assertSame(['kind' => 'DIRECTORY', 'value' => null, 'text' => 'Directory'], $directory['score_label']);
        self::assertNull($directory['vendor']);
        self::assertFalse($directory['is_favorite']);
        self::assertSame('VERIFIED_VENDOR', $items[0]['tier']);
        self::assertContains($items[0]['score_label']['kind'], ['VPS', 'NEW_VENDOR']);

        $details = $this->getJson('/api/v1/buyers/discovery/directory-suppliers/'.$directory['result_id'])->assertOk()
            ->assertJsonPath('data.tier_label', 'Directory Supplier')
            ->assertJsonPath('data.google_rating.label', 'Google rating')->assertJsonPath('data.google_rating.source', 'GOOGLE')->assertJsonPath('data.google_rating.value', '4.8')
            ->assertJsonPath('data.attribution.provider', 'GOOGLE')->json('data');
        self::assertSame(['CALL', 'OPEN_IN_MAPS', 'WEBSITE', 'SHARE'], $details['actions']);
        foreach (['vps', 'score_label', 'vendor', 'listings', 'cart', 'message', 'order', 'review', 'payment', 'storefront', 'verified'] as $forbidden) {
            self::assertArrayNotHasKey($forbidden, $details, 'Tier 1 details expose no '.$forbidden);
        }
        self::assertStringNotContainsString('VPS', (string) json_encode($details));
        $this->getJson('/api/v1/buyers/discovery/directory-suppliers/'.$directory['result_id']);
        self::assertSame(1, $this->places->detailCalls, 'Place Details are lazy-loaded once and cached within the bound.');

        $this->putJson('/api/v1/buyers/favorite-suppliers/'.$directory['result_id'])->assertStatus(422)->assertJsonPath('errors.0.code', 'FAVORITE_REQUIRES_VERIFIED_VENDOR');
        $this->getJson('/api/v1/stores/'.$directory['result_id'].'/profile')->assertNotFound();
        $this->search(['supplier_type' => 'RETAIL_HARDWARE_STORE'])->assertOk()->assertJsonPath('meta.directory.status', 'FILTERED_OUT')->assertJsonCount(1, 'data');

        DB::table('directory_suppliers')->where('google_place_id', 'ChIJdirectoryInside01')->update(['claimed_vendor_organization_id' => $store->id]);
        self::assertSame(['VERIFIED_VENDOR'], array_column($this->search()->json('data'), 'tier'), 'A verified claim replaces the Tier 1 marker.');
    }

    public function test_provider_timeouts_degrade_to_verified_vendors_and_permitted_cache(): void
    {
        [$store] = $this->activeStore('Resilient Supply');
        $this->placeStore($store->id, 1000);
        $this->buyer();
        $this->places->failure = 'TIMEOUT';
        $this->search()->assertOk()->assertJsonPath('data.0.result_id', $store->id)->assertJsonPath('meta.directory.status', 'UNAVAILABLE');
        $this->places->failure = 'NOT_CONFIGURED';
        $this->search()->assertOk()->assertJsonPath('meta.directory.status', 'NOT_CONFIGURED');

        $this->places->failure = null;
        $this->places->places = [['place_id' => 'ChIJtimeoutDirectory01', 'name' => 'Timeout Hardware', 'latitude' => 14.6000, 'longitude' => 120.9860, 'formatted_address' => 'Manila', 'primary_type' => 'hardware_store', 'business_status' => 'OPERATIONAL']];
        $this->search()->assertOk()->assertJsonPath('meta.directory.status', 'AVAILABLE');
        DB::table('place_cache_entries')->update(['expires_at' => now()->subMinute()]);
        $this->places->failure = 'TIMEOUT';
        $cached = $this->search()->assertOk()->assertJsonPath('meta.directory.status', 'CACHED')->json();
        self::assertNotNull($cached['meta']['directory']['as_of']);
        $directoryId = collect($cached['data'])->firstWhere('tier', 'DIRECTORY_SUPPLIER')['result_id'];
        $this->getJson('/api/v1/buyers/discovery/directory-suppliers/'.$directoryId)->assertStatus(503)->assertJsonPath('errors.0.code', 'PLACES_UNAVAILABLE');
    }

    public function test_one_route_is_requested_for_the_selected_supplier_with_stale_response_guards_and_safe_failures(): void
    {
        [$store] = $this->activeStore('Route Hardware');
        $this->placeStore($store->id, 2500);
        [$outside] = $this->activeStore('Outside Hardware');
        $this->placeStore($outside->id, 9000);
        $this->buyer();
        $originVersion = $this->search()->assertOk()->json('meta.scope.origin_version');
        $request = ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'radius_km' => 5, 'tier' => 'VERIFIED_VENDOR', 'supplier_id' => $store->id, 'request_version' => 'selection-7'];

        $this->postJson('/api/v1/buyers/discovery/routes', $request)->assertOk()
            ->assertJsonPath('data.request_version', 'selection-7')->assertJsonPath('data.origin_version', $originVersion)
            ->assertJsonPath('data.distance_meters', 4200)->assertJsonPath('data.duration_seconds', 1080)->assertJsonPath('data.straight_line_meters', 2500)->assertJsonPath('data.cached', false);
        $this->postJson('/api/v1/buyers/discovery/routes', ['request_version' => 'selection-8'] + $request)->assertOk()->assertJsonPath('data.cached', true)->assertJsonPath('data.request_version', 'selection-8');
        self::assertSame(1, $this->routes->calls);
        self::assertStringNotContainsString('14.59', (string) DB::table('route_cache_entries')->value('cache_key_hash'));

        $this->placeStore($store->id, 2600);
        $this->postJson('/api/v1/buyers/discovery/routes', $request)->assertOk()->assertJsonPath('data.cached', false);
        self::assertSame(2, $this->routes->calls, 'A store address change invalidates the cached route.');

        DB::table('route_cache_entries')->delete();
        $this->routes->failure = 'TIMEOUT';
        $this->postJson('/api/v1/buyers/discovery/routes', $request)->assertStatus(503)->assertJsonPath('errors.0.code', 'ROUTE_UNAVAILABLE')->assertJsonPath('errors.0.details.straight_line_meters', 2600);
        $this->routes->failure = null;
        $this->routes->noRoute = true;
        $this->postJson('/api/v1/buyers/discovery/routes', $request)->assertStatus(422)->assertJsonPath('errors.0.code', 'ROUTE_NOT_FOUND');
        $this->postJson('/api/v1/buyers/discovery/routes', ['supplier_id' => $outside->id] + $request)->assertStatus(422)->assertJsonPath('errors.0.code', 'SUPPLIER_OUTSIDE_RADIUS');
    }

    public function test_saved_locations_work_without_gps_and_store_best_resolved_versioned_psgc(): void
    {
        $user = $this->buyer();
        $this->geocoder->reverse = ['formatted_address' => 'Bagong Silangan, Quezon City, Metro Manila', 'place_id' => 'geo-1', 'street' => null, 'unit' => null, 'barangay' => 'Bagong Silangan', 'city_municipality' => 'Quezon City', 'province' => 'Metro Manila', 'postal_code' => '1119'];

        $unresolved = $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'PIN', 'latitude' => 14.6760, 'longitude' => 121.0437])->assertOk()
            ->assertJsonPath('data.psgc.resolution', 'UNRESOLVED')->assertJsonPath('data.psgc.reason', 'NO_ACTIVE_PSGC_VERSION')->json('data');
        $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $unresolved['resolution_token'], 'label' => 'Warehouse'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()
            ->assertJsonPath('data.psgc.resolution', 'UNRESOLVED')->assertJsonPath('data.is_primary', true);

        $this->importPsgc('2025Q2');
        $resolved = $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'PIN', 'latitude' => 14.6760, 'longitude' => 121.0437])->assertOk()
            ->assertJsonPath('data.psgc.resolution', 'RESOLVED')->assertJsonPath('data.psgc.region.code', '1300000000')->assertJsonPath('data.psgc.city_municipality.code', '1381300000')
            ->assertJsonPath('data.psgc.barangay.code', '1381300001')->assertJsonPath('data.psgc.version', '2025Q2')->json('data');
        $key = (string) Str::uuid7();
        $site = $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $resolved['resolution_token'], 'label' => 'Project site', 'location_kind' => 'PROJECT_SITE', 'site_instructions' => 'Gate code at guard house', 'contact_phone_e164' => '+639171234567'], ['Idempotency-Key' => $key])
            ->assertCreated()->assertJsonPath('data.psgc.version', '2025Q2')->assertJsonPath('data.is_primary', false)->assertJsonPath('data.site_instructions', 'Gate code at guard house')->json('data');
        $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $resolved['resolution_token'], 'label' => 'Project site', 'location_kind' => 'PROJECT_SITE', 'site_instructions' => 'Gate code at guard house', 'contact_phone_e164' => '+639171234567'], ['Idempotency-Key' => $key])
            ->assertCreated()->assertJsonPath('data.id', $site['id']);
        self::assertSame(2, DB::table('buyer_locations')->where('buyer_profile_id', $this->buyerProfileId($user))->count(), 'Retrying a save never duplicates a location.');
        self::assertNotSame('Gate code at guard house', DB::table('buyer_locations')->where('id', $site['id'])->value('site_instructions_encrypted'), 'Site instructions are encrypted at rest.');

        $this->postJson('/api/v1/buyers/discovery/search', ['location_id' => $site['id'], 'radius_km' => 5])->assertOk()->assertJsonPath('meta.scope.origin_kind', 'SAVED_LOCATION')->assertJsonPath('meta.scope.location_id', $site['id']);

        // Manual address and provider failures remain complete alternatives.
        $this->geocoder->forward = ['latitude' => 14.5995, 'longitude' => 120.9842, 'formatted_address' => '629 J Nepomuceno St, Quiapo, Manila', 'place_id' => null];
        $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'ADDRESS', 'address_line' => '629 J Nepomuceno St', 'city_municipality' => 'Manila', 'province' => 'Metro Manila'])->assertOk()
            ->assertJsonPath('data.psgc.resolution', 'RESOLVED')->assertJsonPath('data.psgc.city_municipality.code', '1380600000');
        $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'ADDRESS', 'address_line' => 'Somewhere', 'city_municipality' => 'Atlantis'])->assertOk()->assertJsonPath('data.psgc.resolution', 'UNRESOLVED');
        $this->geocoder->unavailable = true;
        $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'ADDRESS', 'address_line' => '629 J Nepomuceno St', 'city_municipality' => 'Manila'])->assertStatus(503)->assertJsonPath('errors.0.code', 'ADDRESS_PROVIDER_UNAVAILABLE');
        $pin = $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'PIN', 'latitude' => 14.6, 'longitude' => 121.0])->assertOk()
            ->assertJsonPath('data.provider_status', 'UNAVAILABLE')->assertJsonPath('data.formatted_address', null)->assertJsonPath('data.psgc.resolution', 'UNRESOLVED')->json('data');
        $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $pin['resolution_token'], 'label' => 'Pinned'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422)->assertJsonPath('errors.0.code', 'ADDRESS_DESCRIPTION_REQUIRED');
        $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $pin['resolution_token'], 'label' => 'Pinned', 'address_line' => 'Beside the chapel, Sampaloc'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->assertJsonPath('data.formatted_address', 'Beside the chapel, Sampaloc');
        $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'DEVICE', 'latitude' => 1.3521, 'longitude' => 103.8198])->assertStatus(422)->assertJsonPath('errors.0.code', 'LOCATION_OUTSIDE_PHILIPPINES');

        $this->buyer();
        $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $resolved['resolution_token'], 'label' => 'Stolen'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422)->assertJsonPath('errors.0.code', 'LOCATION_RESOLUTION_EXPIRED');
        $this->postJson('/api/v1/buyers/discovery/search', ['location_id' => $site['id'], 'radius_km' => 5])->assertNotFound()->assertJsonPath('errors.0.code', 'LOCATION_NOT_FOUND');
        $this->postJson('/api/v1/buyers/discovery/search', ['radius_km' => 5])->assertStatus(422)->assertJsonPath('errors.0.code', 'ORIGIN_REQUIRED');
        $this->getJson('/api/v1/buyers/locations')->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_location_versions_ownership_primary_rules_and_optimistic_concurrency(): void
    {
        $this->importPsgc('2025Q2');
        $owner = $this->buyer();
        $this->geocoder->reverse = ['formatted_address' => 'City of Manila', 'place_id' => null, 'street' => null, 'unit' => null, 'barangay' => null, 'city_municipality' => 'Manila', 'province' => 'Metro Manila', 'postal_code' => null];
        $token = fn (): string => $this->postJson('/api/v1/buyers/locations/resolve', ['mode' => 'PIN', 'latitude' => 14.5995, 'longitude' => 120.9842])->assertOk()->json('data.resolution_token');
        $home = $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $token(), 'label' => 'Home'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $shop = $this->postJson('/api/v1/buyers/locations', ['resolution_token' => $token(), 'label' => 'Shop', 'make_primary' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->assertJsonPath('data.is_primary', true)->json('data');
        self::assertSame(1, DB::table('buyer_locations')->where('buyer_profile_id', $this->buyerProfileId($owner))->where('is_primary', true)->count());

        $oldAddress = DB::table('buyer_locations')->where('id', $home['id'])->value('address_id');
        $moved = $this->patchJson('/api/v1/buyers/locations/'.$home['id'], ['lock_version' => 2, 'resolution_token' => $token()])->assertOk()->assertJsonPath('data.address_version', 2)->json('data');
        $this->assertDatabaseHas('addresses', ['id' => $oldAddress, 'is_current' => false, 'version' => 1]);
        $this->patchJson('/api/v1/buyers/locations/'.$home['id'], ['lock_version' => 2, 'label' => 'Stale'])->assertStatus(409)->assertJsonPath('errors.0.code', 'LOCATION_VERSION_CONFLICT');
        $this->deleteJson('/api/v1/buyers/locations/'.$shop['id'].'?lock_version=1')->assertStatus(409)->assertJsonPath('errors.0.code', 'PRIMARY_LOCATION_REQUIRED');
        $this->postJson('/api/v1/buyers/locations/'.$home['id'].'/primary', ['lock_version' => $moved['lock_version']])->assertOk()->assertJsonPath('data.is_primary', true);
        $shopVersion = (int) DB::table('buyer_locations')->where('id', $shop['id'])->value('lock_version');
        $this->deleteJson('/api/v1/buyers/locations/'.$shop['id'].'?lock_version='.$shopVersion)->assertOk();
        $this->assertDatabaseHas('buyer_locations', ['id' => $shop['id'], 'is_primary' => false]);
        self::assertNotNull(DB::table('buyer_locations')->where('id', $shop['id'])->value('archived_at'), 'Saved locations are archived, never hard-deleted.');

        $this->buyer();
        $this->getJson('/api/v1/buyers/locations')->assertOk()->assertJsonCount(0, 'data');
        $this->patchJson('/api/v1/buyers/locations/'.$home['id'], ['lock_version' => 1, 'label' => 'Mine now'])->assertNotFound();
        $this->deleteJson('/api/v1/buyers/locations/'.$home['id'].'?lock_version=1')->assertNotFound();
    }

    public function test_psgc_versions_import_from_csv_activate_explicitly_and_stay_immutable(): void
    {
        $first = $this->importPsgc('2025Q1', activate: false);
        self::assertSame('DRAFT', $first['status']);
        self::assertSame(['BARANGAY' => 3, 'CITY' => 2, 'MUNICIPALITY' => 1, 'PROVINCE' => 1, 'REGION' => 2, 'SUB_MUNICIPALITY' => 1], $first['level_counts']);
        self::assertSame(0, $first['orphan_count']);
        self::assertTrue($this->importPsgc('2025Q1-copy', activate: false)['duplicate'], 'Identical content is not imported twice.');
        $this->artisan('materyalph:psgc-activate', ['version' => '2025Q1'])->assertSuccessful();
        $v1 = DB::table('psgc_versions')->where('version', '2025Q1')->first();
        self::assertSame('ACTIVE', $v1->status);
        $manila = DB::table('psgc_areas')->where('psgc_version_id', $v1->id)->where('code', '1380600000')->first();
        self::assertSame((string) DB::table('psgc_areas')->where('psgc_version_id', $v1->id)->where('code', '1300000000')->value('id'), (string) $manila->parent_id);
        self::assertSame((string) $manila->id, (string) DB::table('psgc_areas')->where('psgc_version_id', $v1->id)->where('code', '1380601000')->value('parent_id'), 'Sub-municipalities sit under their city.');

        try {
            DB::transaction(fn () => DB::table('psgc_areas')->where('id', $manila->id)->update(['name' => 'Renamed']));
            self::fail('Active PSGC areas must be immutable.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('immutable', $exception->getMessage());
        }

        $this->importPsgc('2025Q2', extraRow: "0203115000,Echague,,Mun\n");
        self::assertSame('RETIRED', DB::table('psgc_versions')->where('version', '2025Q1')->value('status'));
        self::assertSame(1, DB::table('psgc_versions')->where('status', 'ACTIVE')->count());
        $this->artisan('materyalph:psgc-import', ['--source' => 'unknown'])->assertFailed();
        $bad = tempnam(sys_get_temp_dir(), 'psgc');
        file_put_contents($bad, "Name,Geographic Level\nNowhere,Reg\n");
        $this->artisan('materyalph:psgc-import', ['--source' => 'psa-csv', '--file' => $bad, '--label' => 'bad', '--effective-on' => '2025-06-30', '--reference' => 'test'])->assertFailed();
    }

    public function test_psgc_import_of_a_multi_chunk_psa_export_binds_one_timestamp_per_import(): void
    {
        $retained = [];
        DB::listen(static function ($query) use (&$retained): void {
            if (str_starts_with($query->sql, 'insert into "psgc_areas"')) {
                $retained[] = $query->bindings;
            }
        });
        $csv = "10-digit PSGC,Name,Correspondence Code,Geographic Level,Old names,City Class,\"Income\nClassification (DOF DO No. 074.2024)\",\"Urban / Rural\n(based on 2020 CPH)\",2024 Population,,Status\r\n"
            ."0200000000,Region II (Cagayan Valley),020000000,Reg,,,,,\"  3,685,744 \",,\r\n"
            ."0203100000,Isabela,023100000,Prov,,,1st,,\"  1,697,050 \",,\r\n";
        foreach (['0203122', '0203123'] as $municipality) {
            $csv .= $municipality."000,Municipality {$municipality},,Mun,,,1st,,,,\r\n";
            for ($barangay = 1; $barangay <= 750; $barangay++) {
                $csv .= $municipality.sprintf('%03d', $barangay).",Barangay {$barangay},,Bgy,,,,R,,,\r\n";
            }
        }
        $path = tempnam(sys_get_temp_dir(), 'psgc');
        file_put_contents($path, $csv);

        $summary = app(PsgcImporter::class)->import(new PsgcCsvSource($path), 'bulk', '2025-06-30', 'PSA PSGC multi-chunk test');

        self::assertSame(['BARANGAY' => 1500, 'MUNICIPALITY' => 2, 'PROVINCE' => 1, 'REGION' => 1], $summary['level_counts']);
        self::assertSame(0, $summary['orphan_count']);
        self::assertCount(2, $retained, 'Areas are inserted in 1,000-row chunks.');
        foreach ($retained as $bindings) {
            self::assertSame([], array_filter($bindings, 'is_object'), 'Retained query bindings must not pin one date object per row.');
        }
        $version = DB::table('psgc_versions')->where('id', $summary['version_id'])->first();
        self::assertSame([(string) $version->created_at], DB::table('psgc_areas')->where('psgc_version_id', $version->id)->distinct()->pluck('created_at')->map(strval(...))->all());
    }

    public function test_mat01_scope_resolution_rejects_competitor_origins_for_vendors_and_validates_admin_psgc(): void
    {
        [$store] = $this->activeStore('Own Store Origin', withListing: false);
        $this->placeStore($store->id, 0);
        $resolver = app(GeographyScopeResolver::class);

        $scope = $resolver->forVendor($store->id, []);
        self::assertSame(['OWN_STORE', 50], [$scope->originKind, $scope->radiusKm]);
        self::assertEqualsWithDelta($this->originLatitude, $scope->latitude, 0.00001);
        foreach ([['latitude' => 14.6, 'longitude' => 121.0], ['vendor_id' => (string) Str::uuid7()], ['location_id' => (string) Str::uuid7()], ['competitor_id' => 'x']] as $input) {
            $this->expectDomainError(fn () => $resolver->forVendor($store->id, $input), 'ORIGIN_NOT_PERMITTED');
        }
        $this->expectDomainError(fn () => $resolver->forVendor($store->id, ['radius_km' => 25]), 'RADIUS_UNSUPPORTED');
        $this->expectDomainError(fn () => $resolver->forVendor((string) Str::uuid7(), []), 'STORE_LOCATION_UNAVAILABLE');

        $this->expectDomainError(fn () => $resolver->forAdmin(null), 'PSGC_VERSION_UNAVAILABLE');
        $this->importPsgc('2025Q2');
        self::assertSame('PHILIPPINES', $resolver->forAdmin(null)->originKind);
        self::assertNull($resolver->forAdmin('1300000000')->radiusKm, 'Admin PSGC scope has no 50 km ceiling.');
        $this->expectDomainError(fn () => $resolver->forAdmin('9999999999'), 'PSGC_AREA_UNKNOWN');
    }

    public function test_buyer_discovery_routes_require_a_mobile_buyer_session(): void
    {
        $this->postJson('/api/v1/buyers/discovery/search', ['latitude' => 14.6, 'longitude' => 121.0])->assertUnauthorized();
        [, $owner] = $this->activeStore('Vendor Session Store', withListing: false);
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/buyers/discovery/search', ['latitude' => 14.6, 'longitude' => 121.0])->assertForbidden()->assertJsonPath('errors.0.code', 'PORTAL_ACCESS_DENIED');
        $this->getJson('/api/v1/buyers/locations')->assertForbidden();
    }

    public function test_optional_onboarding_uses_the_approved_industry_list_and_version_checks(): void
    {
        $this->buyer();
        $snapshot = $this->getJson('/api/v1/buyers/onboarding')->assertOk()->assertJsonPath('data.status', 'NOT_STARTED')->assertJsonPath('data.discovery_radius_km', 5)
            ->assertJsonPath('data.industries', ['GENERAL_CONTRACTOR', 'SUBCONTRACTOR_TRADE', 'INDEPENDENT_BUILDER', 'DIY_HOMEOWNER', 'OTHER'])->json('data');
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => $snapshot['lock_version'], 'action' => 'SKIP'])->assertOk()->assertJsonPath('data.status', 'SKIPPED');
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => $snapshot['lock_version'], 'action' => 'SAVE'])->assertStatus(409)->assertJsonPath('errors.0.code', 'ONBOARDING_VERSION_CONFLICT');
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => 2, 'action' => 'SAVE', 'industry_classification' => 'OTHER'])->assertStatus(422)->assertJsonPath('errors.0.code', 'INDUSTRY_OTHER_REQUIRED');
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => 2, 'action' => 'SAVE', 'industry_classification' => 'ARCHITECT'])->assertStatus(422);
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => 2, 'action' => 'SAVE', 'preferred_category_ids' => [(string) Str::uuid7()]])->assertStatus(422)->assertJsonPath('errors.0.code', 'CATEGORY_UNKNOWN');
        $category = $snapshot['categories'][0]['id'];
        $this->putJson('/api/v1/buyers/onboarding', ['lock_version' => 2, 'action' => 'COMPLETE', 'company_name' => 'Dela Cruz Builders', 'position_title' => 'Site engineer', 'industry_classification' => 'OTHER', 'industry_other_label' => 'Fit-out contractor', 'preferred_category_ids' => [$category]])
            ->assertOk()->assertJsonPath('data.status', 'COMPLETED')->assertJsonPath('data.industry_other_label', 'Fit-out contractor')->assertJsonPath('data.preferred_category_ids', [$category]);
    }

    /** @return array<string, mixed> */
    private function importPsgc(string $label, bool $activate = true, string $extraRow = ''): array
    {
        $path = tempnam(sys_get_temp_dir(), 'psgc');
        file_put_contents($path, "\u{FEFF}10-digit PSGC,Name,Correspondence Code,Geographic Level\n"
            ."1300000000,National Capital Region (NCR),,Reg\n"
            ."1380600000,City of Manila,,City\n"
            ."1380601000,Tondo I/II,,SubMun\n"
            ."1380601001,Barangay 1,,Bgy\n"
            ."1381300000,Quezon City,,City\n"
            ."1381300001,Bagong Silangan,,Bgy\n"
            ."200000000,Region II (Cagayan Valley),,Reg\n"
            ."0203100000,Isabela,,Prov\n"
            ."0203122000,Quezon,,Mun\n"
            ."0203122001,Poblacion,,Bgy\n".$extraRow);
        $summary = app(PsgcImporter::class)->import(new PsgcCsvSource($path), $label, '2025-06-30', 'PSA PSGC 2Q 2025 test extract');
        if ($activate) {
            $summary = app(PsgcImporter::class)->activate($label);
        }

        return $summary;
    }

    private function expectDomainError(callable $action, string $code): void
    {
        try {
            $action();
            self::fail('Expected '.$code.'.');
        } catch (AuthenticationException $exception) {
            self::assertSame($code, $exception->errorCode);
        }
    }
}
