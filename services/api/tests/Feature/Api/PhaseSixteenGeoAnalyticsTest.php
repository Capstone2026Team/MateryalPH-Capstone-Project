<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\Geo\BoundaryImporter;
use App\Domain\Analytics\Geo\DemoGeoAnalytics;
use App\Domain\Analytics\Geo\GeoFactsBuilder;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\PsgcCsvSource;
use App\Domain\Geography\PsgcImporter;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Settings\PlatformSettings;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Phase 16 Philippine Geographic Marketplace Analytics: daily facts from real orders, PSGC drill-down, boundary
 * placement without exposing points, small-cell suppression with complementary suppression, transaction-filter
 * applicability, meaningful-activity rules (auto-accept never counts), DEMO isolation and aggregate permissions.
 */
final class PhaseSixteenGeoAnalyticsTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
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
        $this->fakePayments();
        $this->importPsgc();
        $this->importBoundaries();
    }

    public function test_facts_drill_down_suppress_small_cells_with_complementary_suppression_and_never_expose_points(): void
    {
        // Three Buyers order from a store inside the Quezon City boundary and one from a store inside Manila.
        [$qc, $qcOwner, $qcListing] = $this->pickupStore('QC Hardware', [['price' => 100000, 'qty' => '100']], 1000);
        $buyers = [];
        foreach (range(1, 3) as $n) {
            $buyers[] = $this->confirmedOrder($qc, $qcOwner, $qcListing);
        }
        [$manila, $manilaOwner, $manilaListing] = $this->pickupStore('Manila Hardware', [['price' => 50000, 'qty' => '100']], 1000);
        $this->placeStore($manila->id, 4500, 180);
        $this->confirmedOrder($manila, $manilaOwner, $manilaListing);
        // A store outside every imported boundary stays unresolved and is counted as a data-quality item.
        [$far, $farOwner, $farListing] = $this->pickupStore('Far Hardware', [['price' => 30000, 'qty' => '100']], 2000);
        $this->confirmedOrder($far, $farOwner, $farListing);
        // The store later moves outside every boundary: facts use the current verified address, which is unresolved.
        $this->placeStore($far->id, 60000, 0);
        // This fixture exercises boundary placement, so exclude the shared fixture's recognizable Quezon City name.
        foreach ([$qc, $manila, $far] as $store) {
            $address = DB::table('vendor_addresses')->where('vendor_organization_id', $store->id)->first();
            self::assertNotNull($address);
            $versionId = (string) Str::uuid7();
            DB::statement('INSERT INTO vendor_address_versions (id, vendor_address_id, version, street, barangay, city_municipality, province, formatted_address, country_code, latitude, longitude, source, location, created_at)
                SELECT ?, vendor_address_id, version + 1, street, ?, ?, ?, formatted_address, country_code, latitude, longitude, source, location, now()
                FROM vendor_address_versions WHERE id = ?', [$versionId, 'Unmapped test barangay', 'Unmapped test locality', 'Unmapped test province', $address->current_version_id]);
            DB::table('vendor_addresses')->where('id', $address->id)->update(['current_version_id' => $versionId, 'updated_at' => now()]);
        }

        $run = app(GeoFactsBuilder::class)->build('COMMAND');
        self::assertSame('PUBLISHED', $run['state']);
        self::assertSame(['1300000000', '1381300000'], array_values((array) DB::table('analytics_order_facts')->where('gross_value_centavos', '>', 0)
            ->whereRaw("source_key = 'order:' || ?", [(string) DB::table('orders')->where('vendor_organization_id', $qc->id)->value('id')])->first(['region_code', 'area_code'])));
        foreach (['analytics_order_facts', 'analytics_activity_facts', 'analytics_response_facts', 'analytics_presence_facts'] as $table) {
            $columns = DB::getSchemaBuilder()->getColumnListing($table);
            self::assertSame([], array_values(array_intersect($columns, ['latitude', 'longitude', 'location', 'geography_wkt', 'email', 'name'])), $table.' stores no coordinates or identity.');
        }

        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $this->setK(3);
        $national = $this->getJson('/api/v1/admin/geo-analytics?dataset=TEST')->assertOk();
        $national->assertJsonPath('data.scope.label', 'Philippines')->assertJsonPath('data.scope.children_label', 'Regions')
            ->assertJsonPath('data.kpis.order_volume.value', 5)->assertJsonPath('data.kpis.order_volume.suppressed', false)
            ->assertJsonPath('data.dataset.label', 'Recorded Marketplace Activity')->assertJsonPath('data.disclosure.minimum_persons', 3)
            ->assertJsonPath('data.unresolved.orders', 1);
        $this->assertNoCoordinates($national->getContent());

        $ncr = $this->getJson('/api/v1/admin/geo-analytics?dataset=TEST&area=1300000000')->assertOk();
        $children = collect($ncr->json('data.children'))->keyBy('code');
        self::assertNull($children['1380600000']['gross_gmv_centavos']['value'], 'One Buyer in Manila is a small cell.');
        self::assertSame('SMALL_CELL', $children['1380600000']['suppression_reason']);
        self::assertStringContainsString('National Capital Region (NCR) total', (string) $children['1380600000']['suppression_note']);
        // Quezon City alone could be subtracted from the visible NCR total to reveal Manila, so it is hidden too.
        self::assertSame(['COMPLEMENTARY', null], [$children['1381300000']['suppression_reason'], $children['1381300000']['order_volume']['value']]);
        self::assertSame([0, false], [$children['1381700000']['order_volume']['value'], $children['1381700000']['suppressed']], 'An empty area reveals nothing and is shown as zero.');
        $ncr->assertJsonPath('data.kpis.order_volume.value', 4)->assertJsonPath('data.scope.breadcrumbs.1.code', '1300000000');

        // Raising k makes both small cells primary; no complementary suppression is needed then.
        $this->setK(5);
        $children = collect($this->getJson('/api/v1/admin/geo-analytics?dataset=TEST&area=1300000000')->assertOk()->json('data.children'))->keyBy('code');
        self::assertSame(['SMALL_CELL', 'SMALL_CELL'], [$children['1381300000']['suppression_reason'], $children['1380600000']['suppression_reason']]);
        $this->setK(3);

        // Vendor storefront counts are public: transaction filters never change them, and they are not suppressed.
        $filtered = $this->getJson('/api/v1/admin/geo-analytics?dataset=TEST&area=1300000000&payment_method=IN_STORE')->assertOk();
        self::assertSame($ncr->json('data.kpis.vendor_count.value'), $filtered->json('data.kpis.vendor_count.value'));
        self::assertSame(0, $filtered->json('data.kpis.order_volume.value'), 'No In-Store orders exist; the filter applies to order-derived metrics.');
        $applicability = collect($filtered->json('data.filter_applicability'))->firstWhere('filter', 'payment_method');
        self::assertContains('MATERIALS_ANALYTICS_PRICES', $applicability['not_applicable_to']);
        self::assertContains('VENDOR_COUNT', $applicability['not_applicable_to']);

        // Unknown filters and coordinate requests are rejected rather than creating an ad hoc grouping.
        $this->getJson('/api/v1/admin/geo-analytics?latitude=14.5&longitude=121')->assertStatus(422)->assertJsonPath('errors.0.code', 'ANALYTICS_FILTER_UNSUPPORTED');
        $this->getJson('/api/v1/admin/geo-analytics?area=9999999999')->assertStatus(422);

        // The map gets simplified PSGC boundaries with codes and names only.
        $boundaries = $this->getJson('/api/v1/admin/geo-analytics/boundaries?area=1300000000')->assertOk();
        $feature = collect($boundaries->json('data.features'))->firstWhere('id', '1381300000');
        self::assertSame(['code', 'name', 'level'], array_keys($feature['properties']));
        self::assertContains('1381700000', $boundaries->json('data.missing_codes'), 'Areas without imported geometry are listed for the tile fallback.');
    }

    public function test_activity_and_response_count_only_human_actions_and_auto_accept_never_counts(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Auto Store', [['price' => 100000, 'qty' => '100']], 1000);
        $variant = $this->variantIds($listing)[0];
        $this->enableAutoAccept($owner, $store->id, $variant, '50');
        [$buyer, $autoOrder] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        self::assertSame('AUTO_ACCEPT', (string) DB::table('orders')->where('id', $autoOrder)->value('confirmation_source'));
        app(GeoFactsBuilder::class)->build('COMMAND');

        self::assertSame(0, DB::table('analytics_activity_facts')->where('audience', 'VENDOR')->count(), 'Auto-accept is not a human Vendor action.');
        self::assertSame(1, DB::table('analytics_activity_facts')->where('audience', 'BUYER')->where('action_kind', 'ORDER_SUBMITTED')->count());
        self::assertSame(0, DB::table('analytics_response_facts')->where('source_key', 'order:'.$autoOrder)->count(), 'Auto-accepted requests are excluded from the response sample.');

        // A manual decision at another store is a human Vendor action and closes the response clock.
        [$manualStore, $manualOwner, $manualListing] = $this->pickupStore('Manual Store', [['price' => 100000, 'qty' => '100']], 1500);
        [, $manualOrder] = $this->pickupOrder($manualStore, $manualListing, [['variant' => 0, 'quantity' => '2']], $buyer);
        $this->confirmOrder($manualOwner, $manualOrder)->assertOk();
        app(GeoFactsBuilder::class)->build('COMMAND');
        self::assertSame(1, DB::table('analytics_activity_facts')->where('audience', 'VENDOR')->where('action_kind', 'ORDER_DECIDED')->count());
        $response = DB::table('analytics_response_facts')->where('source_key', 'order:'.$manualOrder)->first();
        self::assertNotNull($response?->response_seconds);

        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->setK(3);
        $data = $this->getJson('/api/v1/admin/geo-analytics?dataset=TEST')->assertOk()->json('data');
        self::assertSame(['dau', 'wau', 'mau'], array_keys($data['kpis']['active_users']['buyer']));
        self::assertTrue($data['kpis']['active_users']['buyer']['mau']['suppressed'], 'One Buyer is below the disclosure threshold.');
        self::assertArrayHasKey('response_time', $data['definitions']);
    }

    public function test_demo_dataset_is_isolated_labelled_and_aggregate_access_is_separately_authorized(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Isolation Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->confirmedOrder($store, $owner, $listing);
        app(GeoFactsBuilder::class)->build('COMMAND');
        $testOrders = DB::table('analytics_order_facts')->where('environment', 'TEST')->count();
        $demo = app(DemoGeoAnalytics::class)->seed(30, 7);
        self::assertGreaterThan(0, $demo['orders']);
        self::assertSame($testOrders, DB::table('analytics_order_facts')->where('environment', 'TEST')->count(), 'DEMO seeding never touches TEST facts.');
        self::assertSame(0, DB::table('orders')->where('reference', 'like', 'DEMO%')->count(), 'DEMO facts create no orders.');

        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->getJson('/api/v1/admin/geo-analytics?dataset=DEMO')->assertOk()->assertJsonPath('data.dataset.label', 'DEMO — Simulated Marketplace Data')->assertJsonPath('data.dataset.demo', true);
        $this->getJson('/api/v1/admin/geo-analytics/demand?dataset=DEMO&measure=VALUE')->assertOk()->assertJsonPath('data.dimension', 'CATEGORY');
        $this->getJson('/api/v1/admin/geo-analytics/demand?dataset=DEMO&measure=QUANTITY')->assertStatus(422)->assertJsonPath('errors.0.code', 'QUANTITY_NEEDS_MATERIAL');

        // Aggregate access is a separate permission: other Admin roles are denied, including User Management.
        foreach (['ADMIN_USER_MANAGEMENT', 'ADMIN_ORDER_DISPUTE', 'ADMIN_VENDOR_VERIFICATION', 'ADMIN_SUPPORT'] as $role) {
            $this->signInAdmin($this->admin($role));
            $this->getJson('/api/v1/admin/geo-analytics')->assertForbidden();
            $this->getJson('/api/v1/admin/geo-analytics/boundaries')->assertForbidden();
        }
        // The geographic feature flag turns the module off without bypassing authorization.
        $super = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($super);
        DB::table('platform_settings')->where('key', 'features.flags')->update(['value' => json_encode(['materials_analytics' => true, 'geo_analytics' => false])]);
        PlatformSettings::current()->forget();
        $this->getJson('/api/v1/admin/geo-analytics')->assertStatus(503)->assertJsonPath('errors.0.code', 'GEO_ANALYTICS_UNAVAILABLE');
        DB::table('platform_settings')->where('key', 'features.flags')->update(['value' => json_encode(['materials_analytics' => true, 'geo_analytics' => true])]);
        PlatformSettings::current()->forget();

        // Export needs aggregate view plus analytics.export and recent re-authentication; the file keeps the suppression.
        $this->setK(5);
        $export = $this->postJson('/api/v1/admin/reports', ['type' => 'GEO_ANALYTICS', 'format' => 'CSV', 'purpose' => 'Monthly regional recruitment review', 'filters' => ['dataset' => 'TEST']],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $row = DB::table('data_exports')->where('id', $export->json('data.id'))->first();
        self::assertSame('GEO_ANALYTICS', $row->export_type);
        self::assertStringContainsString('Recorded Marketplace Activity', (string) $row->source_snapshot);
        self::assertStringNotContainsString('latitude', (string) $row->source_snapshot);
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->postJson('/api/v1/admin/reports', ['type' => 'GEO_ANALYTICS', 'format' => 'CSV', 'purpose' => 'Not permitted for this role', 'filters' => ['dataset' => 'TEST']],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
    }

    public function test_boundary_import_is_versioned_idempotent_and_needs_replace_for_existing_geometry(): void
    {
        $path = $this->boundaryFile(['1381300000' => [[120.9, 14.6], [120.95, 14.6], [120.95, 14.65], [120.9, 14.65], [120.9, 14.6]]]);
        $first = app(BoundaryImporter::class)->import($path, 'Test boundaries, second import', null, 'psgc');
        self::assertSame([0, 1], [$first['matched'], $first['skipped_existing']], 'Existing geometry is kept without --replace.');
        $replaced = app(BoundaryImporter::class)->import($path, 'Test boundaries, second import', null, 'psgc', true);
        self::assertSame($first['import_id'], $replaced['import_id'], 'Identical content is recognised as the same import.');
        $changed = $this->boundaryFile(['1381300000' => [[120.9, 14.6], [120.96, 14.6], [120.96, 14.66], [120.9, 14.66], [120.9, 14.6]], '9999999999' => [[1, 1], [2, 1], [2, 2], [1, 1]]]);
        $result = app(BoundaryImporter::class)->import($changed, 'Test boundaries, corrected', null, 'psgc', true);
        self::assertSame([1, 1, ['9999999999']], [$result['matched'], $result['replaced'], $result['unmatched']]);
    }

    public function test_recurring_aggregation_updates_both_admin_views_after_new_orders_and_cancellations(): void
    {
        $this->travelTo(CarbonImmutable::parse('2026-10-20 01:00:00', 'Asia/Manila'));
        [$store, $owner, $listing] = $this->pickupStore('Current Activity Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->confirmedOrder($store, $owner, $listing);
        $this->artisan('analytics:aggregate-marketplace')->assertSuccessful();
        $first = DB::table('analytics_geo_runs')->where('state', 'PUBLISHED')->where('environment', 'TEST')->first();
        self::assertNotNull($first);

        // Later activity must reach the same day's facts without waiting for the next morning.
        $this->travelTo(CarbonImmutable::parse('2026-10-20 15:42:00', 'Asia/Manila'));
        $this->confirmedOrder($store, $owner, $listing);
        $gross = (int) DB::table('orders')->sum('commercial_total_centavos');
        $cancelled = DB::table('orders')->orderBy('created_at')->first();
        self::assertNotNull($cancelled);
        DB::table('orders')->where('id', $cancelled->id)->update(['order_state' => 'CANCELLED']);

        $this->signInStoreMember($owner);
        $vendor = $this->getJson('/api/v1/vendor/dashboard/insights?days=30')->assertOk()->json('data.orders.kpis');
        self::assertSame($gross, $vendor['gross_sales_centavos']['value']);
        self::assertSame(2, $vendor['order_volume']['value']);

        $this->artisan('analytics:aggregate-marketplace')->assertSuccessful();
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->setK(1);
        $geo = $this->getJson('/api/v1/admin/geo-analytics?dataset=TEST')->assertOk();
        $insights = $this->getJson('/api/v1/admin/dashboard/insights?dataset=TEST&days=30')->assertOk();
        foreach ([[$geo, 'data'], [$insights, 'data.marketplace']] as [$response, $path]) {
            $response->assertJsonPath($path.'.kpis.order_volume.value', 2)
                ->assertJsonPath($path.'.kpis.gross_gmv_centavos.value', $gross)
                ->assertJsonPath($path.'.kpis.net_gmv_centavos.value', $gross - (int) $cancelled->commercial_total_centavos)
                ->assertJsonPath($path.'.dataset.through_date', '2026-10-20')
                ->assertJsonPath($path.'.dataset.revision', (int) $first->revision + 1);
            $this->assertNoCoordinates($response->getContent());
        }
        self::assertSame($geo->json('data.kpis'), $insights->json('data.marketplace.kpis'));
        self::assertSame(1, DB::table('analytics_geo_runs')->where('environment', 'TEST')->where('state', 'PUBLISHED')->count());
        self::assertSame('SUPERSEDED', DB::table('analytics_geo_runs')->where('id', $first->id)->value('state'));
        self::assertSame(2, DB::table('analytics_order_facts')->where('environment', 'TEST')->count(), 'Rebuilds never double-count orders.');

        $this->setK(3);
        $this->getJson('/api/v1/admin/geo-analytics')->assertOk()->assertJsonPath('data.kpis.gross_gmv_centavos.value', null);
        $this->getJson('/api/v1/admin/dashboard/insights')->assertOk()->assertJsonPath('data.marketplace.kpis.gross_gmv_centavos.value', null);
    }

    public function test_marketplace_refresh_is_due_during_the_day_and_material_price_history_stays_daily(): void
    {
        $this->artisan('schedule:list')->assertSuccessful();
        $events = collect(app(Schedule::class)->events());
        $marketplace = $events->first(static fn ($event): bool => str_contains($event->command ?? '', 'analytics:aggregate-marketplace'));
        $prices = $events->first(static fn ($event): bool => str_contains($event->command ?? '', 'analytics:capture-material-prices'));
        self::assertNotNull($marketplace);
        self::assertSame('* * * * *', $marketplace->expression);
        self::assertTrue($marketplace->withoutOverlapping);
        self::assertTrue($marketplace->onOneServer);
        self::assertNotNull($prices);
        self::assertSame('10 0 * * *', $prices->expression);
        self::assertSame('Asia/Manila', $prices->timezone);
    }

    private function confirmedOrder(VendorOrganization $store, User $owner, string $listing): User
    {
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        $this->confirmOrder($owner, $orderId)->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return $buyer;
    }

    private function setK(int $k): void
    {
        DB::table('platform_settings')->where('key', 'analytics.disclosure_min_persons')->update(['value' => json_encode($k)]);
        PlatformSettings::current()->forget();
    }

    private function assertNoCoordinates(string $json): void
    {
        foreach (['"latitude"', '"longitude"', '"location"', '"geometry_wkt"', '"recorded_store_geography"', '14.59', '120.98'] as $needle) {
            self::assertStringNotContainsString($needle, $json, 'Aggregate responses never contain points or coordinates.');
        }
    }

    private function importPsgc(): void
    {
        $path = tempnam(sys_get_temp_dir(), 'psgc');
        file_put_contents($path, "10-digit PSGC,Name,Correspondence Code,Geographic Level\n"
            ."1300000000,National Capital Region (NCR),,Reg\n"
            ."1380600000,City of Manila,,City\n"
            ."1381300000,Quezon City,,City\n"
            ."1381700000,Pateros,,Mun\n"
            ."0200000000,Region II (Cagayan Valley),,Reg\n"
            ."0203100000,Isabela,,Prov\n"
            ."0203122000,Quezon,,Mun\n"
            ."0203115000,Echague,,Mun\n");
        app(PsgcImporter::class)->import(new PsgcCsvSource($path), '2025Q2', '2025-06-30', 'PSA PSGC test extract');
        app(PsgcImporter::class)->activate('2025Q2');
    }

    private function importBoundaries(): void
    {
        // Synthetic squares: Quezon City around the test origin, Manila five kilometres south, the region around both.
        $path = $this->boundaryFile([
            '1300000000' => [[120.95, 14.52], [121.04, 14.52], [121.04, 14.63], [120.95, 14.63], [120.95, 14.52]],
            '1381300000' => [[120.9642, 14.5795], [121.0242, 14.5795], [121.0242, 14.6195], [120.9642, 14.6195], [120.9642, 14.5795]],
            '1380600000' => [[120.9642, 14.5343], [121.0042, 14.5343], [121.0042, 14.5743], [120.9642, 14.5743], [120.9642, 14.5343]],
        ]);
        app(BoundaryImporter::class)->import($path, 'Synthetic test boundaries 2026-10', null, 'psgc');
    }

    /** @param array<string, list<list<float>>> $rings */
    private function boundaryFile(array $rings): string
    {
        $features = [];
        foreach ($rings as $code => $ring) {
            $features[] = ['type' => 'Feature', 'properties' => ['psgc' => $code], 'geometry' => ['type' => 'Polygon', 'coordinates' => [$ring]]];
        }
        $path = tempnam(sys_get_temp_dir(), 'bnd');
        file_put_contents($path, json_encode(['type' => 'FeatureCollection', 'features' => $features], JSON_THROW_ON_ERROR));

        return $path;
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE16ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInAdmin(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');
    }
}
