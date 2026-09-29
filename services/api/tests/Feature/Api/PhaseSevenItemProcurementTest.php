<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\PriceVersionService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\PublicStoreHours;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class PhaseSevenItemProcurementTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use RefreshDatabase;

    private FakeRouteProvider $routes;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->routes = new FakeRouteProvider;
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, $this->routes);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    // ── Public Store Operation ──────────────────────────────────────────────────────────────────────

    public function test_store_hours_use_a_manila_clock_with_an_exclusive_closing_minute_and_the_next_opening(): void
    {
        [$store] = $this->activeStore('Clock Hardware', false);
        $hours = app(PublicStoreHours::class);
        $profile = $this->profileId($store->id);
        $at = static fn (string $local): CarbonImmutable => CarbonImmutable::parse($local, 'Asia/Manila');

        self::assertSame('CLOSED', $hours->describe($profile, $at('2026-09-30 07:59:59'))['open_now']['status']);
        self::assertSame(['date' => '2026-09-30', 'weekday' => 'Wednesday', 'opens_at' => '08:00'], $hours->describe($profile, $at('2026-09-30 07:59:59'))['open_now']['next_opening']);
        self::assertSame('OPEN', $hours->describe($profile, $at('2026-09-30 08:00:00'))['open_now']['status']);
        self::assertSame('OPEN', $hours->describe($profile, $at('2026-09-30 16:59:59'))['open_now']['status']);
        $closing = $hours->describe($profile, $at('2026-09-30 17:00:00'));
        self::assertSame('CLOSED', $closing['open_now']['status'], 'The exact closing minute is closed.');
        self::assertSame(['date' => '2026-10-01', 'weekday' => 'Thursday', 'opens_at' => '08:00'], $closing['open_now']['next_opening']);
        self::assertCount(7, $closing['week']);
        self::assertSame(['2026-09-30', 'Wednesday'], [$closing['week'][0]['date'], $closing['week'][0]['weekday']]);
        self::assertSame('2026-10-06', $closing['week'][6]['date']);

        // A phone in another time zone sends nothing; the server's UTC instant maps to the Manila date.
        $utcEvening = CarbonImmutable::parse('2026-09-29 16:30:00', 'UTC');
        $manila = $hours->describe($profile, $utcEvening);
        self::assertSame('2026-09-30', $manila['today']['date'], '16:30 UTC is 00:30 the next day in Asia/Manila.');
        self::assertSame('Wednesday', $manila['today']['weekday']);
        self::assertSame('CLOSED', $manila['open_now']['status']);
        self::assertSame('2026-09-30', $manila['open_now']['next_opening']['date']);
    }

    public function test_all_closed_is_valid_dated_overrides_win_for_their_date_and_removal_restores_the_week(): void
    {
        [$store, $owner] = $this->activeStore('Override Hardware');
        $profile = $this->profileId($store->id);
        $hours = app(PublicStoreHours::class);
        $wednesday = CarbonImmutable::parse('2026-09-30 10:00:00', 'Asia/Manila');
        $audit = ['created_by_user_id' => $owner->id, 'updated_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()];

        DB::table('store_operation_date_overrides')->insert(['id' => (string) Str::uuid7(), 'store_profile_id' => $profile, 'specific_date' => '2026-09-30', 'is_closed' => true] + $audit);
        DB::table('store_operation_date_overrides')->insert(['id' => (string) Str::uuid7(), 'store_profile_id' => $profile, 'specific_date' => '2026-10-02', 'is_closed' => false, 'opens_at' => '10:00', 'closes_at' => '12:00'] + $audit);
        $overridden = $hours->describe($profile, $wednesday);
        self::assertSame(['CLOSED', 'DATE_OVERRIDE'], [$overridden['today']['status'], $overridden['today']['source']]);
        self::assertSame('CLOSED', $overridden['open_now']['status']);
        self::assertSame('DATE_OVERRIDE', $overridden['open_now']['basis']);
        self::assertSame(['OPEN', '08:00', 'WEEKLY'], [$overridden['week'][1]['status'], $overridden['week'][1]['opens_at'], $overridden['week'][1]['source']]);
        self::assertSame(['10:00', '12:00', 'DATE_OVERRIDE'], [$overridden['week'][2]['opens_at'], $overridden['week'][2]['closes_at'], $overridden['week'][2]['source']]);
        try {
            DB::transaction(fn () => DB::table('store_operation_date_overrides')->insert(['id' => (string) Str::uuid7(), 'store_profile_id' => $profile, 'specific_date' => '2026-09-30', 'is_closed' => true] + $audit));
            self::fail('A date can have only one override.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('unique', strtolower($exception->getMessage()));
        }

        DB::table('store_operation_date_overrides')->where('store_profile_id', $profile)->delete();
        $restored = $hours->describe($profile, $wednesday);
        self::assertSame(['OPEN', 'WEEKLY'], [$restored['today']['status'], $restored['today']['source']]);
        self::assertSame('OPEN', $restored['open_now']['status']);

        app(StoreOperatingSchedule::class)->replaceWeekly($profile, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));
        $closed = $hours->describe($profile, $wednesday);
        self::assertSame('AVAILABLE', $closed['status'], 'All-Closed is a valid saved schedule, not missing data.');
        self::assertTrue($closed['all_closed']);
        self::assertSame(array_fill(0, 7, 'CLOSED'), array_column($closed['week'], 'status'));
        self::assertNull($closed['open_now']['next_opening']);

        // Hours never change discovery membership, even when every day is closed.
        $this->placeStore($store->id, 1000);
        $this->buyer();
        $this->search()->assertOk()->assertJsonPath('data.0.result_id', $store->id);
    }

    public function test_public_profile_shows_saved_hours_never_drafts_and_unavailable_legacy_hours_without_fabrication(): void
    {
        [$store, $owner] = $this->activeStore('Draft Hardware');
        $profile = $this->profileId($store->id);
        Carbon::setTestNow(Carbon::parse('2026-09-30 09:15:00', 'Asia/Manila'));

        $this->signInStoreMember($owner);
        $draft = array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7));
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => (int) DB::table('vendor_organizations')->where('id', $store->id)->value('lock_version'),
            'form_state' => json_encode(['operating_schedule' => $draft], JSON_THROW_ON_ERROR)])->assertOk();
        $this->restoreCompletedProfile($store->id);
        $public = $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertOk()
            ->assertJsonPath('data.hours_status', 'AVAILABLE')
            ->assertJsonPath('data.time_zone', 'Asia/Manila')
            ->assertJsonPath('data.open_now.status', 'OPEN')
            ->assertJsonPath('data.week.0.date', '2026-09-30')
            ->assertJsonPath('data.week.0.status', 'OPEN')
            ->assertJsonPath('data.effective_today.opens_at', '08:00')
            ->assertJsonCount(7, 'data.week');
        self::assertStringContainsString('informational', (string) $public->json('data.hours_notice'));

        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => (int) DB::table('vendor_organizations')->where('id', $store->id)->value('lock_version'),
            'operating_schedule' => array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => $day === 3 ? 'CLOSED' : 'OPEN', 'opens_at' => $day === 3 ? null : '07:00', 'closes_at' => $day === 3 ? null : '16:00'], range(1, 7))])->assertOk();
        $this->restoreCompletedProfile($store->id);
        $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertOk()
            ->assertJsonPath('data.week.0.status', 'CLOSED')
            ->assertJsonPath('data.week.1.opens_at', '07:00')
            ->assertJsonPath('data.open_now.next_opening.date', '2026-10-01');

        DB::table('operating_hours')->where('store_profile_id', $profile)->delete();
        $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertOk()
            ->assertJsonPath('data.hours_status', 'UNAVAILABLE')
            ->assertJsonPath('data.open_now.status', 'UNAVAILABLE')
            ->assertJsonPath('data.effective_today', null)
            ->assertJsonCount(0, 'data.week')
            ->assertJsonCount(0, 'data.operating_schedule');
    }

    // ── Explore dashboard ───────────────────────────────────────────────────────────────────────────

    public function test_explore_counts_distinct_vendors_and_listings_from_one_snapshot_with_radius_stale_and_duplicate_cases(): void
    {
        [$a, $ownerA] = $this->activeStore('Alpha Hardware', false);
        $this->signInStoreMember($ownerA);
        $this->listing('A1');
        $this->listing('A2', [['price' => 1800], ['price' => 1900]]);
        [$b, $ownerB] = $this->activeStore('Bravo Hardware', false);
        $this->signInStoreMember($ownerB);
        $this->listing('B1');
        [$stale, $ownerC] = $this->activeStore('Stale Hardware', false);
        $this->signInStoreMember($ownerC);
        $staleListing = $this->listing('C1');
        [$far, $ownerD] = $this->activeStore('Far Hardware', false);
        $this->signInStoreMember($ownerD);
        $this->listing('D1');
        $this->placeStore($a->id, 1000);
        $this->placeStore($b->id, 2000, 180);
        $this->placeStore($stale->id, 1500, 270);
        $this->placeStore($far->id, 8000);
        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variants($staleListing))->update(['confirmed_at' => now()->subDays(20)]);
        EligibleOfferQuery::invalidate();
        $this->buyer();

        $summary = $this->explore()->assertOk()
            ->assertJsonPath('data.counts.verified_vendors', 2)
            ->assertJsonPath('data.counts.vendor_listings', 3)
            ->assertJsonPath('data.labels.vendor_listings_unit', 'Vendor listings')
            ->assertJsonPath('data.count_scope', 'ALL_CATEGORIES_AT_LOCATION_RADIUS')
            ->assertJsonPath('data.scope.radius_km', 5)
            ->assertJsonPath('data.materials_analytics.enabled', false)
            ->assertJsonPath('data.dataset.label', 'DEMO — Simulated Marketplace Data');
        self::assertNotNull($summary->json('data.current_as_of'));
        $masonry = collect($summary->json('data.categories'))->firstWhere('code', 'MASONRY');
        self::assertSame(3, $masonry['vendor_listings'], 'Category counts come from the same snapshot as the cards.');

        $this->explore(['radius_km' => 10])->assertOk()->assertJsonPath('data.counts.verified_vendors', 3)->assertJsonPath('data.counts.vendor_listings', 4);
        self::assertSame(0, $this->routes->calls);
    }

    // ── Search, SRS and Best Price ─────────────────────────────────────────────────────────────────

    public function test_best_deal_srs_is_explainable_best_price_normalizes_packs_and_requires_available_stock(): void
    {
        [$a, $ownerA] = $this->activeStore('Alpha Blocks', false);
        $this->signInStoreMember($ownerA);
        $expensive = $this->listing('ALPHA', [['price' => 1800]], name: 'Hollow block 4 inch');
        [$b, $ownerB] = $this->activeStore('Bravo Blocks', false);
        $this->signInStoreMember($ownerB);
        $cheap = $this->listing('BRAVO', [['price' => 1500]], name: 'Hollow block 4 inch');
        [$c, $ownerC] = $this->activeStore('Charlie Blocks', false);
        $this->signInStoreMember($ownerC);
        $pack = $this->listing('CHARLIE', [['price' => 15000, 'pack' => '10']], name: 'Hollow block 4 inch pack');
        $custom = $this->listing('CUSTOM', [['price' => 1000]], thickness: '150', name: 'Hollow block 6 inch');
        $this->comparableGroup();
        $this->placeStore($a->id, 1000);
        $this->placeStore($b->id, 2500, 180);
        $this->placeStore($c->id, 4000, 270);
        $this->buyer();

        $response = $this->searchListings(['query' => 'hollow block'])->assertOk()->assertJsonPath('meta.sort', 'BEST_DEAL')->assertJsonPath('meta.ranking.personalized', false);
        $cards = collect($response->json('data'))->keyBy('listing_id');
        self::assertSame(['BEST_PRICE'], $cards[$cheap]['badges']);
        self::assertSame(['BEST_PRICE'], $cards[$pack]['badges'], '₱150.00 for a 10-piece pack normalizes to ₱15.00 per piece, tying the lowest price.');
        self::assertSame([], $cards[$expensive]['badges']);
        self::assertSame('15.00000000', $cards[$pack]['comparable']['normalized_unit_price']);
        self::assertSame('NOT_YET_COMPARABLE', $cards[$custom]['comparable']['status']);

        $components = collect($cards[$expensive]['ranking']['components'])->keyBy('key');
        self::assertSame('80.00', $components['distance']['score'], '1 km in a 5 km radius.');
        self::assertSame('83.33', $components['price']['score'], '₱15.00 / ₱18.00.');
        self::assertSame(['50.00', '100.00', '60.00'], [$components['vps']['score'], $components['stock']['score'], $components['product_rating']['score']]);
        self::assertSame([30, 25, 20, 15, 10], $components->pluck('weight_percent')->values()->all());
        // 80×0.30 + 83.3333×0.25 + 50×0.20 + 100×0.15 + 60×0.10 = 75.8333
        self::assertSame('75.83', $cards[$expensive]['ranking']['srs']);
        self::assertSame('50.00', collect($cards[$custom]['ranking']['components'])->firstWhere('key', 'price')['score'], 'Not Yet Comparable uses the approved neutral 50.');

        // Best Price requires active available stock: an out-of-stock offer is excluded and no longer sets the minimum.
        DB::table('inventory_items')->whereIn('listing_variant_id', [...$this->variants($cheap), ...$this->variants($pack)])->update(['quantity_on_hand' => 0]);
        $after = collect($this->searchListings(['query' => 'hollow block'])->assertOk()->json('data'))->keyBy('listing_id');
        self::assertFalse($after->has($cheap));
        self::assertSame([], $after[$expensive]['badges'], 'One remaining Vendor is not a price comparison.');
        self::assertSame('100.00', collect($after[$expensive]['ranking']['components'])->firstWhere('key', 'price')['score']);
    }

    public function test_sorting_defaults_ties_favorites_first_personal_weights_one_card_per_listing_and_cursor_pages(): void
    {
        $stores = [];
        foreach (['Near' => 1000, 'Middle' => 2000, 'Farther' => 3000] as $name => $meters) {
            [$store, $owner] = $this->activeStore($name.' Supply', false);
            $this->signInStoreMember($owner);
            $stores[$name] = ['id' => $store->id, 'listing' => $this->listing(Str::upper($name), $name === 'Middle' ? [['price' => 1800], ['price' => 1700]] : [['price' => 1800]])];
            $this->placeStore($store->id, $meters, 90);
        }
        $this->buyer();

        $browse = $this->searchListings()->assertOk()->assertJsonPath('meta.sort', 'DISTANCE')->assertJsonPath('meta.default_sort', 'DISTANCE');
        self::assertSame([$stores['Near']['listing'], $stores['Middle']['listing'], $stores['Farther']['listing']], array_column($browse->json('data'), 'listing_id'));
        $middle = collect($browse->json('data'))->firstWhere('listing_id', $stores['Middle']['listing']);
        self::assertSame(2, $middle['options_count'], 'Two eligible variants still make one card.');
        self::assertSame(1700, $middle['price']['unit_price_centavos']);
        self::assertSame([], collect($browse->json('data'))->where('listing_id', $stores['Middle']['listing'])->skip(1)->all());

        $bestDeal = array_column($this->searchListings(['sort' => 'BEST_DEAL'])->json('data'), 'listing_id');
        self::assertSame($bestDeal, array_column($this->searchListings(['sort' => 'BEST_DEAL'])->json('data'), 'listing_id'), 'Ranking is deterministic.');

        $this->putJson('/api/v1/buyers/favorite-suppliers/'.$stores['Farther']['id'])->assertOk();
        self::assertSame($bestDeal, array_column($this->searchListings(['sort' => 'BEST_DEAL'])->json('data'), 'listing_id'), 'A Favorite never changes Best Deal.');
        self::assertSame($stores['Farther']['listing'], $this->searchListings(['sort' => 'FAVORITES_FIRST'])->json('data.0.listing_id'));
        self::assertTrue($this->searchListings(['sort' => 'FAVORITES_FIRST'])->json('data.0.is_favorite'));

        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 0, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 100]])->assertOk();
        $tied = $this->searchListings(['sort' => 'BEST_DEAL'])->assertOk()->assertJsonPath('meta.ranking.personalized', true);
        $expected = [$stores['Near']['listing'], $stores['Middle']['listing'], $stores['Farther']['listing']];
        self::assertSame($expected, array_column($tied->json('data'), 'listing_id'), 'Equal SRS breaks ties by distance, then price, then listing id.');

        $seen = [];
        $cursor = null;
        do {
            $page = $this->searchListings(array_filter(['per_page' => 1, 'cursor' => $cursor]))->assertOk();
            $seen = [...$seen, ...array_column($page->json('data'), 'listing_id')];
            $cursor = $page->json('meta.next_cursor');
        } while ($cursor !== null);
        self::assertSame([$stores['Near']['listing'], $stores['Middle']['listing'], $stores['Farther']['listing']], $seen, 'Keyset pages never repeat or skip a card.');
        $first = $this->searchListings(['per_page' => 1])->json('meta.next_cursor');
        $this->searchListings(['per_page' => 1, 'cursor' => $first.'x'])->assertStatus(422)->assertJsonPath('errors.0.code', 'CURSOR_INVALID');
        $this->searchListings(['per_page' => 1, 'cursor' => $first, 'query' => 'other'])->assertStatus(422)->assertJsonPath('errors.0.code', 'CURSOR_INVALID');
    }

    public function test_stale_stock_is_excluded_and_old_product_details_report_unavailable(): void
    {
        [$store, $owner] = $this->activeStore('Stale Details', false);
        $this->signInStoreMember($owner);
        $listing = $this->listing('STALE');
        $this->placeStore($store->id, 1000);
        $this->buyer();
        $this->listingDetails($listing)->assertOk()->assertJsonPath('data.purchasable', true)->assertJsonPath('data.variants.0.stock_label', 'IN_STOCK')
            ->assertJsonPath('data.compliance.notice', 'A PS/ICC badge means MateryalPH matched or reviewed the submitted evidence. It is not a new government certification.')
            ->assertJsonMissingPath('data.variants.0.quantity_on_hand');
        $this->listingDetails($listing, ['radius_km' => 5, 'latitude' => 14.70, 'longitude' => 121.10])->assertOk()->assertJsonPath('data.purchasable', false)->assertJsonPath('data.not_purchasable_reason', 'OUTSIDE_SELECTED_RADIUS');

        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variants($listing))->update(['confirmed_at' => now()->subDays(16)]);
        $this->searchListings()->assertOk()->assertJsonCount(0, 'data')->assertJsonPath('meta.expansion.suggested_radius_km', 10);
        $this->listingDetails($listing)->assertNotFound()->assertJsonPath('errors.0.code', 'LISTING_UNAVAILABLE');
    }

    // ── Ranking preferences ────────────────────────────────────────────────────────────────────────

    public function test_item_based_preferences_total_100_reject_all_zero_reset_and_stay_private_to_the_buyer(): void
    {
        $this->getJson('/api/v1/buyers/ranking-preferences/item-based')->assertUnauthorized();
        $first = $this->buyer();
        $this->getJson('/api/v1/buyers/ranking-preferences/item-based')->assertOk()
            ->assertJsonPath('data.weights', ['distance' => 30, 'price' => 25, 'vps' => 20, 'stock' => 15, 'product_rating' => 10])
            ->assertJsonPath('data.personalized', false)->assertJsonPath('data.version', 0);

        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 40, 'price' => 20, 'vps' => 20, 'stock' => 10, 'product_rating' => 0]])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'WEIGHTS_TOTAL_INVALID');
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 0, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'WEIGHTS_ALL_ZERO');
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 50.5, 'price' => 49.5, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 50, 'price' => 50, 'vps' => 0, 'stock' => 0, 'product_rating' => 0, 'sponsored' => 0]])
            ->assertStatus(422);

        $weights = ['distance' => 50, 'price' => 30, 'vps' => 10, 'stock' => 10, 'product_rating' => 0];
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => $weights])->assertOk()
            ->assertJsonPath('data.personalized', true)->assertJsonPath('data.version', 1)->assertJsonPath('data.total_percent', 100);
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => $weights])->assertStatus(409)->assertJsonPath('errors.0.code', 'PREFERENCE_VERSION_CONFLICT');
        $this->assertDatabaseHas('buyer_ranking_preferences', ['buyer_profile_id' => $this->buyerProfileId($first), 'procurement_type' => 'ITEM_BASED', 'version' => 1]);
        $this->assertDatabaseHas('audit_logs', ['action' => 'BUYER_RANKING_PREFERENCES_UPDATED', 'actor_user_id' => $first->id]);

        $second = $this->buyer();
        $this->getJson('/api/v1/buyers/ranking-preferences/item-based')->assertOk()->assertJsonPath('data.personalized', false);
        $this->deleteJson('/api/v1/buyers/ranking-preferences/item-based?version=1')->assertStatus(409);
        $this->signInBuyer($first);
        $this->deleteJson('/api/v1/buyers/ranking-preferences/item-based?version=1')->assertOk()->assertJsonPath('data.personalized', false)->assertJsonPath('data.version', 0)
            ->assertJsonPath('data.weights.distance', 30);
        $this->assertDatabaseHas('audit_logs', ['action' => 'BUYER_RANKING_PREFERENCES_RESET']);
        self::assertNotSame($first->id, $second->id);

        [, $owner] = $this->activeStore('Vendor Only', false);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/buyers/ranking-preferences/item-based')->assertForbidden()->assertJsonPath('errors.0.code', 'PORTAL_ACCESS_DENIED');
        $this->putJson('/api/v1/buyers/ranking-preferences/item-based', ['version' => 0, 'weights' => ['distance' => 100, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]])->assertForbidden();

        try {
            DB::transaction(fn () => DB::table('buyer_ranking_preferences')->insert(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $this->buyerProfileId($second), 'procurement_type' => 'ITEM_BASED',
                'weights' => json_encode(['distance' => 90, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]), 'version' => 1, 'created_at' => now(), 'updated_at' => now()]));
            self::fail('The database rejects a weight set that does not total 100.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('buyer_ranking_item_weights_check', $exception->getMessage());
        }
    }

    // ── Cart and checkout preview ──────────────────────────────────────────────────────────────────

    public function test_cart_placement_is_idempotent_validates_price_and_quantity_and_never_holds_stock(): void
    {
        [$store, $owner] = $this->activeStore('Cart Store', false);
        $this->signInStoreMember($owner);
        $listing = $this->listing('CART', [['price' => 1800, 'qty' => '12']]);
        $this->placeStore($store->id, 1000);
        $buyer = $this->buyer();
        [$variant] = $this->variants($listing);
        $price = (string) DB::table('listing_price_versions')->where('listing_variant_id', $variant)->whereNull('retired_at')->value('id');
        $before = DB::table('inventory_items')->where('listing_variant_id', $variant)->first(['quantity_on_hand', 'hard_reserved_quantity', 'soft_held_quantity']);
        $key = (string) Str::uuid7();

        $body = ['listing_variant_id' => $variant, 'expected_price_version_id' => $price, 'quantity' => '5'] + $this->origin();
        $this->postJson('/api/v1/buyers/cart/items', $body, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.groups.0.lines.0.quantity', '5.0000')
            ->assertJsonPath('data.groups.0.fulfillment_method', 'PICKUP')->assertJsonPath('data.summary.reserves_stock', false);
        $this->postJson('/api/v1/buyers/cart/items', $body, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.groups.0.lines.0.quantity', '5.0000');
        $this->postJson('/api/v1/buyers/cart/items', ['quantity' => '6'] + $body, ['Idempotency-Key' => $key])->assertStatus(409)->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        $this->postJson('/api/v1/buyers/cart/items', $body)->assertStatus(422)->assertJsonPath('errors.0.code', 'IDEMPOTENCY_KEY_REQUIRED');
        $this->postJson('/api/v1/buyers/cart/items', ['quantity' => '1.5'] + $body, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422)->assertJsonPath('errors.0.code', 'QUANTITY_INVALID');
        $this->postJson('/api/v1/buyers/cart/items', ['quantity' => '8'] + $body, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422)->assertJsonPath('errors.0.code', 'QUANTITY_UNAVAILABLE')
            ->assertJsonMissingPath('errors.0.details.available');
        $this->postJson('/api/v1/buyers/cart/items', ['expected_price_version_id' => (string) Str::uuid7()] + $body, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'PRICE_CHANGED');

        $after = DB::table('inventory_items')->where('listing_variant_id', $variant)->first(['quantity_on_hand', 'hard_reserved_quantity', 'soft_held_quantity']);
        self::assertEquals($before, $after, 'Cart placement never changes on-hand, reserved or held quantities.');
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(0, DB::table('orders')->count());

        $cart = $this->getJson('/api/v1/buyers/cart')->assertOk();
        $line = $cart->json('data.groups.0.lines.0');
        $this->patchJson('/api/v1/buyers/cart/items/'.$line['id'], ['lock_version' => $cart->json('data.lock_version') - 1, 'quantity' => '2'])->assertStatus(409)->assertJsonPath('errors.0.code', 'CART_VERSION_CONFLICT');
        $this->patchJson('/api/v1/buyers/cart/items/'.$line['id'], ['lock_version' => $cart->json('data.lock_version'), 'quantity' => '2'])->assertOk()->assertJsonPath('data.groups.0.lines.0.quantity', '2.0000');

        $other = $this->buyer();
        $this->patchJson('/api/v1/buyers/cart/items/'.$line['id'], ['lock_version' => 1, 'quantity' => '1'])->assertNotFound()->assertJsonPath('errors.0.code', 'CART_ITEM_NOT_FOUND');
        $this->getJson('/api/v1/buyers/cart')->assertOk()->assertJsonCount(0, 'data.groups');
        self::assertNotSame($buyer->id, $other->id);
    }

    public function test_cross_vendor_preview_marks_stale_price_vendor_status_and_stock_inline_without_discarding_the_cart(): void
    {
        [$alpha, $ownerA] = $this->activeStore('Alpha Cart', false);
        $this->signInStoreMember($ownerA);
        $alphaListing = $this->listing('ALPHA-CART');
        [$bravo, $ownerB] = $this->activeStore('Bravo Cart', false);
        $this->signInStoreMember($ownerB);
        $bravoListing = $this->listing('BRAVO-CART');
        $bravoSecond = $this->listing('BRAVO-TWO');
        foreach ([$alpha->id, $bravo->id] as $index => $id) {
            $this->placeStore($id, 1000 + $index * 500, $index * 90);
            $this->connectOnlinePayments($id);
        }
        $this->buyer();
        foreach ([$alphaListing, $bravoListing, $bravoSecond] as $listing) {
            $this->addToCart($listing, '2');
        }

        $preview = $this->preview()->assertOk()->assertJsonCount(2, 'data.groups')->assertJsonPath('data.summary.ready_groups', 2)->assertJsonPath('data.summary.creates_orders', false);
        self::assertSame(['READY', 'READY'], array_column($preview->json('data.groups'), 'status'));

        // A new public price on one Bravo line: only that group needs action.
        DB::transaction(fn () => app(PriceVersionService::class)->saveOrdinary($ownerB->id, $this->variants($bravoListing)[0], 2000, 'NON_VAT', null));
        $stale = $this->preview()->assertOk()->assertJsonPath('data.summary.requires_split_confirmation', true);
        $groups = collect($stale->json('data.groups'))->keyBy('vendor.id');
        self::assertSame('READY', $groups[$alpha->id]['status']);
        self::assertSame('ACTION_REQUIRED', $groups[$bravo->id]['status']);
        $bravoLine = collect($groups[$bravo->id]['lines'])->firstWhere('listing_id', $bravoListing);
        self::assertSame(['PRICE_CHANGED'], array_column($bravoLine['issues'], 'code'));
        self::assertSame([1800, 2000], [$bravoLine['snapshot']['unit_price_centavos'], $bravoLine['current']['unit_price_centavos']]);

        $cart = $this->getJson('/api/v1/buyers/cart')->assertOk();
        $this->patchJson('/api/v1/buyers/cart/items/'.$bravoLine['id'], ['lock_version' => $cart->json('data.lock_version'), 'accept_current_price' => true])->assertOk();
        self::assertSame('READY', collect($this->preview()->json('data.groups'))->firstWhere('vendor.id', $bravo->id)['status']);

        // Stale stock blocks the affected line; a suspended Vendor blocks only its own group.
        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variants($bravoSecond))->update(['confirmed_at' => now()->subDays(16)]);
        $blocked = collect($this->preview()->json('data.groups'))->keyBy('vendor.id');
        self::assertSame('BLOCKED', $blocked[$bravo->id]['status']);
        self::assertSame(['LISTING_UNAVAILABLE'], array_column(collect($blocked[$bravo->id]['lines'])->firstWhere('listing_id', $bravoSecond)['issues'], 'code'));
        DB::table('vendor_organizations')->where('id', $alpha->id)->update(['store_activation_status' => 'SUSPENDED']);
        $suspended = collect($this->preview()->json('data.groups'))->keyBy('vendor.id');
        self::assertContains('VENDOR_UNAVAILABLE', array_column($suspended[$alpha->id]['issues'], 'code'));
        self::assertSame('BLOCKED', $suspended[$alpha->id]['status']);
        self::assertCount(3, array_merge(...array_column($this->getJson('/api/v1/buyers/cart')->json('data.groups'), 'lines')), 'No cart line is discarded.');
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(0, DB::table('orders')->count());
    }

    public function test_heavy_access_requires_an_alternate_preserves_the_intended_site_and_uses_the_drop_off_route_basis(): void
    {
        [$store, $owner] = $this->activeStore('Delivery Yard', false, true);
        $this->signInStoreMember($owner);
        $listing = $this->listing('HEAVY', [['price' => 1800, 'qty' => '50']]);
        $this->vehicle();
        // A 10 km stated area: the vehicle's usable range is capped by it and must cover the 4.2 km fake route.
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->placeStore($store->id, 1000);
        $this->connectOnlinePayments($store->id);
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Project site', 0, 0, 'PROJECT_SITE', true);
        $gate = $this->savedLocation($buyer, 'North gate', 1500, 0);
        $farGate = $this->savedLocation($buyer, 'Far gate', 12000, 270);
        $this->addToCart($listing, '10', 'DELIVERY');

        $preview = $this->preview()->assertOk();
        self::assertSame('DESTINATION_REQUIRED', $preview->json('data.groups.0.issues.0.code'));

        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'ALTERNATE_DROP_OFF_REQUIRED');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $site, 'access_instructions' => 'Use the side gate'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'ALTERNATE_DROP_OFF_REQUIRED');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'Forklift at the north gate; unload before 5 PM.'])
            ->assertOk()->assertJsonPath('data.destination.intended.location_id', $site)->assertJsonPath('data.destination.alternate_drop_off.location_id', $gate)
            ->assertJsonPath('data.destination.vehicle_endpoint', 'ALTERNATE_DROP_OFF')->assertJsonPath('data.destination.labels.intended', 'Intended destination / Project site');

        $advisory = $this->preview()->assertOk();
        $delivery = $advisory->json('data.groups.0.delivery');
        self::assertSame('ADVISORY_ESTIMATE', $delivery['status']);
        self::assertSame('ALTERNATE_DROP_OFF', $delivery['endpoint']);
        self::assertSame('ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF', $delivery['route']['basis']);
        self::assertSame(4200, $delivery['route']['distance_meters']);
        self::assertNull($delivery['confirmed_offer'], 'A confirmed offer exists only after Vendor confirmation.');
        $gatePoint = DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')->where('bl.id', $gate)->first(['a.latitude', 'a.longitude']);
        self::assertSame([(float) $gatePoint->latitude, (float) $gatePoint->longitude], end($this->routes->requests)['destination'], 'The route goes to the vehicle drop-off, not the intended site.');
        // Box truck: (₱500.00 + ₱25.00 × 4.2 km) per trip, 120 kg of blocks → one trip.
        self::assertSame([60500, 60500, 1, 1], [$delivery['estimate']['fee_min_centavos'], $delivery['estimate']['fee_max_centavos'], $delivery['estimate']['trips_min'], $delivery['estimate']['trips_max']]);
        self::assertSame('ESTIMATE', $advisory->json('data.groups.0.amounts.delivery.status'));
        self::assertSame(18000 + 60500, $advisory->json('data.groups.0.amounts.total_before_processing_min_centavos'), '10 × ₱18.00 materials plus the estimated delivery.');
        self::assertSame($site, DB::table('carts')->where('buyer_profile_id', $this->buyerProfileId($buyer))->value('intended_location_id'), 'The intended site is never overwritten by the drop-off.');
        self::assertTrue((bool) DB::table('buyer_locations')->where('id', $site)->value('is_primary'));

        // No restriction: the intended site is the endpoint again.
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'NO'])->assertOk()
            ->assertJsonPath('data.destination.alternate_drop_off', null)->assertJsonPath('data.destination.vehicle_endpoint', 'INTENDED_LOCATION');
        self::assertSame('INTENDED_LOCATION', $this->preview()->json('data.groups.0.delivery.endpoint'));

        // A drop-off beyond the Vendor's stated area is a blocker, never a made-up distance or zero fee.
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $farGate, 'access_instructions' => 'Far gate access road.'])->assertOk();
        $outside = $this->preview()->json('data.groups.0');
        self::assertSame(['BLOCKED', 'OUTSIDE_DELIVERY_COVERAGE'], [$outside['status'], $outside['delivery']['issues'][0]['code']]);
        self::assertNull($outside['delivery']['estimate']);

        // Route failure blocks the group; unknown measurements stay manual review.
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'North gate.'])->assertOk();
        DB::table('route_cache_entries')->delete();
        $this->routes->failure = 'UNAVAILABLE';
        self::assertSame('ROUTE_UNAVAILABLE', $this->preview()->json('data.groups.0.delivery.issues.0.code'));
        $this->routes->failure = null;
        DB::table('listing_variants')->whereIn('id', $this->variants($listing))->update(['weight_kg' => null]);
        $manual = $this->preview()->json('data.groups.0');
        self::assertSame('MANUAL_REVIEW', $manual['delivery']['status']);
        self::assertContains('WEIGHT_UNKNOWN', $manual['delivery']['manual_review_reasons']);
        self::assertSame('PENDING_VENDOR_REVIEW', $manual['amounts']['delivery']['status']);
        self::assertNull($manual['amounts']['total_before_processing_min_centavos']);
    }

    public function test_preview_amounts_follow_fin02_included_vat_and_exclude_commission_and_withholding(): void
    {
        [$store, $owner] = $this->activeStore('VAT Store', false);
        $this->signInStoreMember($owner);
        $listing = $this->listing('VAT');
        DB::table('vendor_tax_profile_versions')->whereIn('vendor_tax_profile_id', DB::table('vendor_tax_profiles')->where('vendor_organization_id', $store->id)->pluck('id'))->update(['vat_category' => 'VAT', 'vat_verified_category' => 'VAT']);
        DB::transaction(fn () => app(PriceVersionService::class)->saveOrdinary($owner->id, $this->variants($listing)[0], 11200, 'VAT_12', null));
        $this->placeStore($store->id, 1000);
        $this->connectOnlinePayments($store->id);
        $this->buyer();
        $this->addToCart($listing, '3');

        $amounts = $this->preview()->assertOk()->json('data.groups.0.amounts');
        self::assertSame(33600, $amounts['materials_subtotal_centavos']);
        self::assertSame(3600, $amounts['included_vat_centavos'], 'money(33,600 × 12 / 112) is included, never added.');
        self::assertSame(30000, $amounts['vat_exclusive_materials_centavos']);
        self::assertSame(33600, $amounts['total_before_processing_min_centavos']);
        self::assertSame(['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'], $amounts['excludes']);
        self::assertSame('PENDING_PAYMENT_CHANNEL', $amounts['processing_fee']['status']);
        $methods = collect($this->preview()->json('data.groups.0.payment_methods'))->keyBy('method');
        self::assertTrue($methods['ONLINE']['available']);
        self::assertSame([false, 'NOT_OFFERED_BY_VENDOR'], [$methods['IN_STORE']['available'], $methods['IN_STORE']['reason']]);
        self::assertSame([false, 'SITE_DELIVERY_ONLY'], [$methods['CASH_ON_DELIVERY']['available'], $methods['CASH_ON_DELIVERY']['reason']]);
    }

    // ── Helpers ────────────────────────────────────────────────────────────────────────────────────

    /** @param array<string, mixed> $overrides */
    private function explore(array $overrides = []): TestResponse
    {
        return $this->postJson('/api/v1/buyers/explore/summary', array_replace($this->origin(), $overrides));
    }

    /** @param array<string, mixed> $overrides */
    private function searchListings(array $overrides = []): TestResponse
    {
        return $this->postJson('/api/v1/buyers/listings/search', array_replace($this->origin(), $overrides));
    }

    /** @param array<string, mixed> $overrides */
    private function listingDetails(string $listing, array $overrides = []): TestResponse
    {
        return $this->postJson('/api/v1/buyers/listings/'.$listing.'/details', array_replace($this->origin(), $overrides));
    }

    private function preview(): TestResponse
    {
        return $this->postJson('/api/v1/buyers/cart/checkout-preview', ['request_version' => 'test-1']);
    }

    /** @return array<string, mixed> */
    private function origin(): array
    {
        return ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 5];
    }

    private function addToCart(string $listing, string $quantity, ?string $fulfillment = null): void
    {
        $variant = $this->variants($listing)[0];
        $price = (string) DB::table('listing_price_versions')->where('listing_variant_id', $variant)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->value('id');
        $this->postJson('/api/v1/buyers/cart/items', array_filter(['listing_variant_id' => $variant, 'expected_price_version_id' => $price, 'quantity' => $quantity, 'fulfillment_method' => $fulfillment]) + $this->origin(),
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
    }

    /**
     * Publishes a CHB listing through the real Vendor catalog API as the signed-in Owner.
     *
     * @param  list<array{price?: int, qty?: string, pack?: string}>  $variants
     */
    private function listing(string $sku, array $variants = [['price' => 1800]], string $thickness = '100', ?string $name = null): string
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => $name ?? 'Listing '.$sku, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, [
            'lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => 'BrandCo', 'manufacturer' => 'Sample Block Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => ['thickness_mm' => $thickness],
        ])->assertOk();
        $rows = [];
        foreach ($variants as $index => $variant) {
            $rows[] = ['sku' => $sku.'-V'.($index + 1), 'label' => 'Variant '.($index + 1), 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => $variant['pack'] ?? '1', 'price_centavos' => $variant['price'] ?? 1800,
                'tax_category' => 'NON_VAT', 'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => $variant['qty'] ?? '100'];
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => $rows])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Product photo'])->assertCreated();
        $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();

        return $listing;
    }

    private function comparableGroup(): void
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $reviewer = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE']);
        app(ComparableMappingService::class)->createGroup(['material_id' => (string) $material->id, 'code' => 'CHB-100-BRANDCO', 'display_name' => 'CHB 100 mm BrandCo', 'brand' => 'BrandCo',
            'specification' => ['thickness_mm' => '100'], 'canonical_unit_id' => (string) $material->canonical_unit_id], (int) $reviewer->id);
    }

    /** @return list<string> */
    private function variants(string $listing): array
    {
        return DB::table('listing_variants')->where('vendor_listing_id', $listing)->where('active', true)->orderBy('sort_order')->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
    }

    private function profileId(string $organizationId): string
    {
        return (string) DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('id');
    }

    private function connectOnlinePayments(string $organizationId): void
    {
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => 'test-sub-'.Str::random(8),
            'connection_status' => 'CONNECTED_TEST', 'capabilities' => json_encode(['test_account_provisioned' => true]), 'provider_associated_at' => now(), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
    }

    private function vehicle(): void
    {
        $image = (string) $this->post('/api/v1/vendor/fleet/vehicle-images', ['file' => UploadedFile::fake()->image('truck.png')])->assertCreated()->json('data.file_id');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [['vehicle_category' => 'TRUCK', 'vehicle_type' => 'BOX_TRUCK', 'name' => 'Box truck', 'brand' => 'Isuzu', 'image_file_id' => $image,
            'number_available' => 2, 'capacity_kg' => 1000, 'cargo_length_m' => 4, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'HEAVY',
            'base_fee_centavos' => 50000, 'per_km_centavos' => 2500, 'maximum_distance_km' => 40, 'active' => true, 'available' => true]]])->assertOk();
        $this->restoreCompletedProfile((string) DB::table('vendor_vehicles')->orderByDesc('created_at')->value('vendor_organization_id'));
    }

    /**
     * The fixture activates stores without onboarding requirement rows, so a Vendor save's requirement sync
     * reopens the public profile. Restore the completed profile the fixture represents.
     */
    private function restoreCompletedProfile(string $organizationId): void
    {
        DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => 'COMPLETED']);
    }

    /** A saved Buyer location projected $meters from the origin on a geodesic bearing. */
    private function savedLocation(User $buyer, string $label, float $meters, float $bearing = 0, string $kind = 'DELIVERY', bool $primary = false): string
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
}
