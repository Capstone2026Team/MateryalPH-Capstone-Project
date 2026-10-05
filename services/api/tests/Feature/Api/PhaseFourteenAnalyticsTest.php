<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Analytics\DemoMaterialsMarketplace;
use App\Domain\Analytics\MaterialPriceCaptureService;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Scores\ScoreCalculator;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesAnalyticsFixtures;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Phase 14 Materials Analytics acceptance (MAT-01–MAT-07): the 100/110/120 → 110 equal-Vendor average regardless of
 * duplicate listings, 100 → 110 = +10.00% and the reverse −9.09%, one-Vendor limited data without trend, two-Vendor
 * Buyer trend, the Vendor own 80 / competitors 100/110/120 → 110 fixture and suppression at two competitors, exact
 * radius boundary, specification separation, unavailable/stale exclusion, VAT-inclusive comparison, tier/negotiated
 * price exclusion, missing days, participant changes, capture retry/midnight/failure/immutability, corrections, role,
 * export and serializer leakage checks against the raw JSON, cache isolation, revoked roles and a schedule-only edit.
 */
final class PhaseFourteenAnalyticsTest extends TestCase
{
    use CreatesAnalyticsFixtures;
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    private const PROTECTED_FINANCE = ['commission', 'withholding', 'earnings', 'payout', 'taxpayer', 'remittance', 'fee_statement', 'transaction_history'];

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
        // The feature is installed; the operational kill switch is exercised explicitly below.
        config()->set('finance.materials_analytics_enabled', true);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    public function test_capture_averages_one_vendor_each_regardless_of_duplicates_and_buyer_flow_reaches_product_details(): void
    {
        $group = $this->comparableGroup();
        // Alpha's first listing (₱300) is superseded for the average by its later-published duplicate (₱100): one Vendor, one value.
        [$a, $aOwner, $aListing] = $this->analyticsStore('Alpha Supply', 30000, 1000);
        [$b] = $this->analyticsStore('Bravo Supply', 11000, 2000, 30);
        [$c] = $this->analyticsStore('Charlie Supply', 12000, 3000, 200, 'NON_VAT');
        $this->travel(5)->seconds();
        $this->signInStoreMember($aOwner);
        $duplicate = $this->orderListing('ALPHA-DUP', [['price' => 10000, 'qty' => '20']]);
        app(ComparableMappingService::class)->assign($this->variantIds($duplicate)[0]);
        // A volume tier below the ordinary price never enters the average.
        DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $this->variantIds($aListing)[0], 'version' => 9, 'amount_centavos' => 5000, 'tax_category' => 'NON_VAT',
            'price_kind' => 'VOLUME_TIER', 'minimum_quantity' => '10', 'effective_at' => now(), 'created_by_user_id' => $aOwner->id, 'created_at' => now(), 'updated_at' => now()]);

        $result = app(MaterialPriceCaptureService::class)->capture(CarbonImmutable::now());
        self::assertSame('PUBLISHED', $result['state']);
        self::assertSame(3, $result['vendors']);
        self::assertSame(4, $result['observations']);
        self::assertSame(1, DB::table('price_observations')->where('exclusion_reason', MaterialPriceCaptureService::DUPLICATE_REASON)->count());

        $buyer = $this->buyer();
        $list = $this->buyerAnalytics(['preset_days' => 7])->assertOk()->json('data');
        $row = collect($list['items'])->firstWhere('group_id', $group);
        self::assertSame('110.00', $row['end_point']['average_php']);
        self::assertSame(3, $row['end_point']['vendor_count']);
        self::assertSame(3, $row['current']['vendor_count']);
        self::assertSame('TEST — Recorded Test Marketplace Prices', $list['dataset']['label']);
        self::assertSame('PUBLIC_LISTING', $list['source_kind']);
        self::assertNull($row['trend']['change_percent'], 'The start date has no snapshot: never use a nearest date.');
        self::assertSame('MISSING_ENDPOINT_SNAPSHOT', $row['trend']['reason']);

        $detail = $this->buyerAnalytics(['preset_days' => 7], $group)->assertOk()->json('data');
        self::assertCount(8, $detail['series'], 'Both endpoints are included.');
        self::assertSame('MISSING_DAY', $detail['series'][0]['status']);
        $offers = $this->postJson('/api/v1/buyers/materials-analytics/'.$group.'/offers', $this->origin())->assertOk()->json('data');
        self::assertCount(4, $offers, 'Current offers list every eligible listing; only the average deduplicates.');
        self::assertSame('Alpha Supply', $offers[0]['store_name']);
        self::assertSame('100.00', $offers[0]['normalized_php']);
        self::assertArrayNotHasKey('quantity_on_hand', $offers[0]);
        // The offer opens the existing single-Vendor Product Details.
        $this->postJson('/api/v1/buyers/listings/'.$offers[0]['listing_id'].'/details', $this->origin())->assertOk()->assertJsonPath('data.listing_id', $offers[0]['listing_id']);
        $this->postJson('/api/v1/buyers/explore/summary', $this->origin())->assertOk()->assertJsonPath('data.materials_analytics.enabled', true);
        self::assertNotNull($buyer);
    }

    public function test_trend_formula_limited_data_two_vendor_trend_missing_days_and_participant_change(): void
    {
        $group = $this->comparableGroup();
        [, , , $alpha] = $this->analyticsStore('Alpha', 10000, 1000);
        [, , , $bravo] = $this->analyticsStore('Bravo', 10000, 1500, 10);
        [, , , $charlie] = $this->analyticsStore('Charlie', 10000, 2500, 250);
        $end = CarbonImmutable::now('Asia/Manila')->subDay();
        $start = $end->subDays(7);
        $this->publishRun($start->toDateString(), [$alpha => '100', $bravo => '100']);
        $this->publishRun($start->addDays(3)->toDateString(), [$alpha => '105']);
        $this->publishRun($end->toDateString(), [$alpha => '105', $bravo => '115']);
        $this->buyer();

        $row = collect($this->buyerAnalytics(['preset_days' => 7])->assertOk()->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame('10.00', $row['trend']['change_percent']);
        self::assertSame('INCREASING', $row['trend']['direction']);
        self::assertFalse($row['trend']['composition_changed']);
        $series = $this->buyerAnalytics(['preset_days' => 7], $group)->json('data.series');
        self::assertSame(['OK', 'MISSING_DAY', 'MISSING_DAY', 'LIMITED_DATA', 'MISSING_DAY', 'MISSING_DAY', 'MISSING_DAY', 'OK'], array_column($series, 'status'));
        self::assertSame('Limited Local Data — 1 Vendor', $series[3]['label']);
        self::assertSame('105.00', $series[3]['average_php']);
        self::assertNull($series[1]['average_php'], 'A missing day stays a gap, never interpolated.');

        // Reversed endpoints: 110 → 100 = −9.09%; a changed participant set is flagged.
        $this->publishRun($start->subDays(7)->toDateString(), [$bravo => '110', $charlie => '110']);
        $custom = collect($this->buyerAnalytics(['start_date' => $start->subDays(7)->toDateString(), 'end_date' => $start->toDateString()])->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame('-9.09', $custom['trend']['change_percent']);
        self::assertSame('DECREASING', $custom['trend']['direction']);
        self::assertTrue($custom['trend']['composition_changed']);

        // One Vendor at an endpoint: average shown as limited data, percentage null.
        $one = collect($this->buyerAnalytics(['start_date' => $start->addDays(3)->toDateString(), 'end_date' => $end->toDateString()])->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame('LIMITED_DATA', $one['start_point']['status']);
        self::assertNull($one['trend']['change_percent']);
        self::assertSame('INSUFFICIENT_LOCAL_DATA', $one['trend']['reason']);

        // Custom range validation: future, reversed and > 365 days are refused.
        $today = CarbonImmutable::now('Asia/Manila');
        $this->buyerAnalytics(['start_date' => $today->toDateString(), 'end_date' => $today->addDay()->toDateString()])->assertStatus(422)->assertJsonPath('errors.0.code', 'ANALYTICS_DATE_RANGE_INVALID');
        $this->buyerAnalytics(['start_date' => $end->toDateString(), 'end_date' => $start->toDateString()])->assertStatus(422);
        $this->buyerAnalytics(['start_date' => $end->subDays(366)->toDateString(), 'end_date' => $end->toDateString()])->assertStatus(422);
        $this->buyerAnalytics(['start_date' => $end->subDays(365)->toDateString(), 'end_date' => $end->toDateString()])->assertOk();
        $this->buyerAnalytics(['preset_days' => 14])->assertStatus(422);
    }

    public function test_vendor_sees_own_price_separately_and_competitor_average_with_suppression_at_two_and_no_identity_leak(): void
    {
        $group = $this->comparableGroup();
        [$own, $owner, $ownListing, $ownVariant] = $this->analyticsStore('Own Store', 8000, 500);
        [, , , $c1] = $this->analyticsStore('Competitor One', 10000, 1000, 10);
        [, , , $c2] = $this->analyticsStore('Competitor Two', 11000, 1200, 100);
        [$third, , $thirdListing, $c3] = $this->analyticsStore('Competitor Three', 12000, 1400, 200);
        $date = CarbonImmutable::now('Asia/Manila')->subDay()->toDateString();
        $this->publishRun($date, [$ownVariant => '80', $c1 => '100', $c2 => '110', $c3 => '120']);

        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/materials-analytics?preset_days=7')->assertOk();
        $row = collect($response->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame('110.00', $row['end_point']['average_php']);
        self::assertSame(3, $row['end_point']['competitor_count']);
        self::assertSame('80.00', $row['own_offer']['normalized_php']);
        self::assertSame($ownListing, $row['own_offer']['listing_id']);
        $raw = $response->getContent();
        foreach (['Competitor One', 'Competitor Two', 'Competitor Three', $third->id, $thirdListing, $c3, 'vendor_ids', 'store_name', 'average_php_exact', 'minimum', 'maximum'] as $leak) {
            self::assertStringNotContainsString((string) $leak, $raw, 'Vendor payload must not reveal '.$leak);
        }
        foreach (self::PROTECTED_FINANCE as $finance) {
            self::assertStringNotContainsString($finance, $raw);
        }
        $detail = $this->getJson('/api/v1/vendor/materials-analytics/'.$group.'?preset_days=7')->assertOk();
        self::assertArrayNotHasKey('offers', $detail->json('data'));
        self::assertStringNotContainsString('Competitor', $detail->getContent());

        // Removing one competitor suppresses every competitor value and never reveals the sub-threshold count.
        $next = CarbonImmutable::now('Asia/Manila')->toDateString();
        $this->publishRun($next, [$ownVariant => '80', $c1 => '100', $c2 => '110']);
        $suppressed = collect($this->getJson('/api/v1/vendor/materials-analytics?start_date='.$date.'&end_date='.$next)->assertOk()->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame('SUPPRESSED', $suppressed['end_point']['status']);
        self::assertNull($suppressed['end_point']['average_php']);
        self::assertNull($suppressed['end_point']['competitor_count']);
        self::assertSame('Insufficient Competitor Data', $suppressed['end_point']['label']);
        self::assertNull($suppressed['trend']['change_percent']);
        self::assertSame('INSUFFICIENT_COMPETITOR_DATA', $suppressed['trend']['reason']);
        self::assertSame('80.00', $suppressed['own_offer']['normalized_php']);

        // The own organization never contributes, so the Buyer sees four Vendors where the Vendor sees three competitors.
        $this->buyer();
        $buyerRow = collect($this->buyerAnalytics(['start_date' => $date, 'end_date' => $next])->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame(4, $buyerRow['start_point']['vendor_count']);
        self::assertSame('102.50', $buyerRow['start_point']['average_php']);
    }

    public function test_every_fixed_role_buyer_and_admin_at_route_api_export_and_serializer_level(): void
    {
        $group = $this->comparableGroup();
        [$store, $owner] = $this->analyticsStore('Role Store', 10000, 500);
        $members = ['OWNER' => $owner];
        foreach (['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $members[$role] = $this->teamMember($store, $role);
        }
        // The Owner's staff dispute flag and Manager delegation never add analytics to any other role.
        DB::table('vendor_organizations')->where('id', $store->id)->update(['staff_disputes_enabled' => true]);
        DB::table('vendor_memberships')->where('user_id', $members['STORE_MANAGER']->id)->update(['can_manage_staff' => true]);
        foreach ($members as $role => $member) {
            $this->signInStoreMember($member);
            $allowed = in_array($role, ['OWNER', 'STORE_MANAGER'], true);
            $this->getJson('/api/v1/vendor/materials-analytics')->assertStatus($allowed ? 200 : 403);
            $this->getJson('/api/v1/vendor/materials-analytics/'.$group)->assertStatus($allowed ? 200 : 403);
            $export = $this->get('/api/v1/vendor/materials-analytics/export');
            $export->assertStatus($allowed ? 200 : 403);
            if ($allowed) {
                $csv = $export->streamedContent();
                self::assertStringContainsString('Competitor average', $csv);
                self::assertStringNotContainsString('Role Store', $csv);
                foreach (self::PROTECTED_FINANCE as $finance) {
                    self::assertStringNotContainsString($finance, strtolower($csv));
                }
                $this->getJson('/api/v1/vendor/finance/earnings')->assertStatus($role === 'OWNER' ? 200 : 403);
            }
            // A Vendor token can never request the Buyer serializer or its offers.
            $this->postJson('/api/v1/buyers/materials-analytics', $this->origin())->assertStatus(403);
            $this->postJson('/api/v1/buyers/materials-analytics/'.$group.'/offers', $this->origin())->assertStatus(403);
        }
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/materials-analytics?vendor_id='.$store->id)->assertStatus(422)->assertJsonPath('errors.0.code', 'ORIGIN_NOT_PERMITTED');
        $this->getJson('/api/v1/vendor/materials-analytics?include_buyer_offers=1')->assertStatus(422)->assertJsonPath('errors.0.code', 'ANALYTICS_FILTER_UNSUPPORTED');
        $this->getJson('/api/v1/vendor/materials-analytics?latitude=14.6&longitude=121')->assertStatus(422);

        $this->buyer();
        $this->getJson('/api/v1/vendor/materials-analytics')->assertStatus(403);
        $this->postJson('/api/v1/buyers/materials-analytics', $this->origin() + ['role' => 'VENDOR'])->assertStatus(422);

        $this->psgcVersion();
        foreach (['ADMIN_SUPERADMIN' => [200, 200, 200], 'ADMIN_SUPPORT' => [403, 403, 403], 'ADMIN_ORDER_DISPUTE' => [403, 403, 403]] as $role => [$list, $sources, $export]) {
            $this->signInAdmin($this->admin($role));
            $this->getJson('/api/v1/admin/materials-analytics')->assertStatus($list);
            $this->getJson('/api/v1/admin/materials-analytics/'.$group.'/sources?snapshot_date='.CarbonImmutable::now('Asia/Manila')->toDateString().'&reason=Market%20quality%20review')
                ->assertStatus($sources === 200 ? 404 : $sources);
            $this->get('/api/v1/admin/materials-analytics/export')->assertStatus($export);
        }
    }

    public function test_cache_isolation_revoked_roles_and_daily_publication_invalidation(): void
    {
        $group = $this->comparableGroup();
        [$a, $aOwner, , $aVariant] = $this->analyticsStore('Store A', 9000, 500);
        [$b, $bOwner, , $bVariant] = $this->analyticsStore('Store B', 9500, 700, 10);
        [, , , $c1] = $this->analyticsStore('Store C', 10000, 900, 100);
        [, , , $c2] = $this->analyticsStore('Store D', 11000, 1100, 200);
        [, , , $c3] = $this->analyticsStore('Store E', 12000, 1300, 300);
        $date = CarbonImmutable::now('Asia/Manila')->subDay()->toDateString();
        $this->publishRun($date, [$aVariant => '90', $bVariant => '95', $c1 => '100', $c2 => '110', $c3 => '120']);

        $this->signInStoreMember($aOwner);
        $rowA = collect($this->getJson('/api/v1/vendor/materials-analytics')->assertOk()->json('data.items'))->firstWhere('group_id', $group);
        $this->signInStoreMember($bOwner);
        $rowB = collect($this->getJson('/api/v1/vendor/materials-analytics')->assertOk()->json('data.items'))->firstWhere('group_id', $group);
        // Each Vendor's cached aggregate excludes only itself: A sees B,C,D,E; B sees A,C,D,E.
        self::assertSame('106.25', $rowA['end_point']['average_php']);
        self::assertSame('105.00', $rowB['end_point']['average_php']);
        self::assertSame('90.00', $rowA['own_offer']['normalized_php']);
        self::assertSame('95.00', $rowB['own_offer']['normalized_php']);

        // A revoked role is denied on the next request even though an authorized response is cached.
        DB::table('vendor_memberships')->where('user_id', $aOwner->id)->update(['role' => 'STORE_STAFF']);
        $this->signInStoreMember($aOwner);
        $this->getJson('/api/v1/vendor/materials-analytics')->assertStatus(403);
        $this->get('/api/v1/vendor/materials-analytics/export')->assertStatus(403);

        // A new publication changes the history generation, so cached history is not served stale.
        $this->signInStoreMember($bOwner);
        $this->publishRun(CarbonImmutable::now('Asia/Manila')->toDateString(), [$aVariant => '90', $bVariant => '95', $c1 => '200', $c2 => '210', $c3 => '220']);
        $fresh = collect($this->getJson('/api/v1/vendor/materials-analytics?preset_days=7')->assertOk()->json('data.items'))->firstWhere('group_id', $group);
        self::assertSame(CarbonImmutable::now('Asia/Manila')->toDateString(), $fresh['end_point']['date']);
        self::assertSame('180.00', $fresh['end_point']['average_php']);
        self::assertNotNull($b);
        self::assertNotNull($a);
    }

    public function test_radius_boundary_specification_separation_stale_and_unavailable_exclusion(): void
    {
        $group100 = $this->comparableGroup();
        $group150 = $this->comparableGroup('150', 'CHB_BRANDCO_150');
        [, , , $inside] = $this->analyticsStore('Exactly Five Km', 10000, 5000, 45);
        [$outsideStore] = $this->analyticsStore('Just Outside', 20000, 5050, 45);
        [$stale, $staleOwner, , $staleVariant] = $this->analyticsStore('Stale Stock', 30000, 1000, 180);
        [, , , $empty] = $this->analyticsStore('No Stock', 40000, 1200, 270);
        DB::table('inventory_items')->where('listing_variant_id', $staleVariant)->update(['confirmed_at' => now()->subDays(60)]);
        DB::table('inventory_items')->where('listing_variant_id', $empty)->update(['quantity_on_hand' => '0']);
        EligibleOfferQuery::invalidate();

        $result = app(MaterialPriceCaptureService::class)->capture(CarbonImmutable::now());
        self::assertSame(2, $result['observations'], 'Stale and zero-stock variants are never captured.');
        $this->buyer();
        $items = collect($this->buyerAnalytics(['preset_days' => 7])->assertOk()->json('data.items'));
        $row = $items->firstWhere('group_id', $group100);
        self::assertSame('100.00', $row['end_point']['average_php'], 'Exactly 5 km is inside; 5.05 km is outside.');
        self::assertSame(1, $row['end_point']['vendor_count']);
        self::assertNull($items->firstWhere('group_id', $group150), 'A 150 mm block never averages with 100 mm blocks.');
        self::assertNotNull($outsideStore);
        self::assertNotNull($stale);
        self::assertNotNull($staleOwner);
        self::assertSame(0, DB::table('price_observations')->where('comparable_group_id', $group150)->count());
        self::assertNotNull($inside);
    }

    public function test_capture_retry_midnight_failure_immutability_and_reviewed_correction(): void
    {
        $group = $this->comparableGroup();
        [, , , $alpha] = $this->analyticsStore('Alpha', 10000, 1000);
        [, , , $bravo] = $this->analyticsStore('Bravo', 12000, 1500, 30);
        $capture = app(MaterialPriceCaptureService::class);
        $day = CarbonImmutable::now('Asia/Manila')->addDay()->setTime(0, 10);
        $this->freeze($day);
        $first = $capture->capture(CarbonImmutable::now());
        self::assertSame(2, $first['observations']);
        $retry = $capture->capture(CarbonImmutable::now());
        self::assertSame('ALREADY_PUBLISHED', $retry['state']);
        self::assertSame($first['run_id'], $retry['run_id']);
        self::assertSame(1, DB::table('analytics_refresh_runs')->where('snapshot_date', $day->toDateString())->count());

        // A capture started at 23:59:59 that finishes after midnight is discarded and restarts for the new date.
        $late = $day->addDay()->setTime(23, 59, 59);
        $calls = 0;
        $clock = static function () use (&$calls, $late): CarbonImmutable {
            $calls++;

            return $late->addSeconds(2);
        };
        $this->freeze($late->addSeconds(2));
        $crossed = $capture->capture($late, $clock);
        self::assertSame($late->addSeconds(2)->toDateString(), $crossed['snapshot_date']);
        self::assertSame('PUBLISHED', $crossed['state']);
        self::assertSame(0, DB::table('price_observations')->where('local_snapshot_date', $late->toDateString())->count(), 'No partial staging for the old date.');
        self::assertFalse(DB::table('analytics_published_runs')->where('snapshot_date', $late->toDateString())->exists(), 'A missed day is never fabricated.');
        self::assertSame(2, $calls);

        $this->expectImmutable(fn () => DB::table('price_observations')->where('analytics_refresh_run_id', $first['run_id'])->update(['normalized_php_price' => '1']));
        $this->expectImmutable(fn () => DB::table('price_observations')->where('analytics_refresh_run_id', $first['run_id'])->delete());

        // A reviewed correction appends revision 2, supersedes the selection and leaves the original rows intact.
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $bad = (string) DB::table('price_observations')->where('analytics_refresh_run_id', $first['run_id'])->where('listing_variant_id', $bravo)->value('id');
        $this->postJson('/api/v1/admin/materials-analytics/runs/'.$first['run_id'].'/corrections', ['excluded_observation_ids' => [$bad], 'reason' => 'Proven invalid listing price entry.'],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.revision', 2);
        self::assertSame('SUPERSEDED', DB::table('analytics_refresh_runs')->where('id', $first['run_id'])->value('state'));
        self::assertSame(2, DB::table('price_observations')->where('analytics_refresh_run_id', $first['run_id'])->count());
        $this->psgcVersion();
        $detail = $this->getJson('/api/v1/admin/materials-analytics/'.$group.'?start_date='.$day->subDay()->toDateString().'&end_date='.$day->toDateString())->assertOk()->json('data');
        self::assertSame('100.00', end($detail['series'])['average_php']);
        self::assertSame('100.00000000', end($detail['series'])['average_php_exact']);
        self::assertNotNull($alpha);
        self::assertTrue(DB::table('audit_logs')->where('action', 'MATERIAL_PRICE_SNAPSHOT_CORRECTED')->exists());
    }

    public function test_schedule_only_edit_leaves_eligibility_counts_scores_and_analytics_unchanged(): void
    {
        $group = $this->comparableGroup();
        [$store, $owner, , $variant] = $this->analyticsStore('Hours Store', 10000, 800);
        [, , , $other] = $this->analyticsStore('Other Store', 12000, 900, 20);
        $date = CarbonImmutable::now('Asia/Manila')->subDay()->toDateString();
        $this->publishRun($date, [$variant => '100', $other => '120']);
        $this->buyer();
        $before = [$this->postJson('/api/v1/buyers/explore/summary', $this->origin())->json('data.counts'), collect($this->buyerAnalytics(['preset_days' => 7])->json('data.items'))->firstWhere('group_id', $group)];
        $snapshotBefore = app(ScoreCalculator::class)->operations($store->id, CarbonImmutable::now());

        $profileId = (string) DB::table('store_profiles')->where('vendor_organization_id', $store->id)->value('id');
        app(StoreOperatingSchedule::class)->replaceWeekly($profileId, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => $day === 7 ? 'CLOSED' : 'OPEN', 'opens_at' => $day === 7 ? null : '10:00', 'closes_at' => $day === 7 ? null : '14:00'], range(1, 7)));
        EligibleOfferQuery::invalidate();
        AnalyticsDataset::bump();

        $after = [$this->postJson('/api/v1/buyers/explore/summary', $this->origin())->json('data.counts'), collect($this->buyerAnalytics(['preset_days' => 7])->json('data.items'))->firstWhere('group_id', $group)];
        self::assertSame($before, $after);
        self::assertSame($snapshotBefore, app(ScoreCalculator::class)->operations($store->id, CarbonImmutable::now()));
        self::assertSame(2, app(MaterialPriceCaptureService::class)->capture(CarbonImmutable::now())['observations'], 'Hours never change capture eligibility.');
        self::assertNotNull($owner);
    }

    public function test_demo_marketplace_seed_is_isolated_labelled_and_navigable(): void
    {
        $result = app(DemoMaterialsMarketplace::class)->seed($this->originLatitude, $this->originLongitude, 45);
        self::assertSame(6, $result['stores']);
        self::assertSame(0, DB::table('price_observations')->where('environment', 'TEST')->count(), 'DEMO history never enters the TEST capture dataset.');
        self::assertFalse(DB::table('analytics_published_runs')->where('environment', 'DEMO')->where('snapshot_date', CarbonImmutable::now('Asia/Manila')->subDays(12)->toDateString())->exists());
        $this->buyer();
        $list = $this->postJson('/api/v1/buyers/materials-analytics', ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 10, 'preset_days' => 30])->assertOk()->json('data');
        self::assertSame('DEMO — Simulated Marketplace Data', $list['dataset']['label']);
        $chb = collect($list['items'])->firstWhere('display_name', '4-inch (100 mm) concrete hollow block — DemoBlock');
        self::assertSame('OK', $chb['end_point']['status']);
        self::assertNotNull($chb['trend']['change_percent']);
        self::assertTrue($chb['trend']['composition_changed'], 'A Vendor joined the group 20 days ago.');
        $offers = $this->postJson('/api/v1/buyers/materials-analytics/'.$chb['group_id'].'/offers', ['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 10])->assertOk()->json('data');
        self::assertCount(5, $offers);
        self::assertStringStartsWith('DEMO — ', $offers[0]['store_name']);
    }

    public function test_kill_switch_disables_every_entry_point_explicitly(): void
    {
        config()->set('finance.materials_analytics_enabled', false);
        $this->buyer();
        $this->postJson('/api/v1/buyers/explore/summary', $this->origin())->assertOk()->assertJsonPath('data.materials_analytics.enabled', false)
            ->assertJsonPath('data.materials_analytics.status', 'TEMPORARILY_UNAVAILABLE');
        $this->buyerAnalytics()->assertStatus(503)->assertJsonPath('errors.0.code', 'MATERIALS_ANALYTICS_UNAVAILABLE');
    }

    private function freeze(CarbonImmutable $instant): void
    {
        CarbonImmutable::setTestNow($instant);
        Carbon::setTestNow(Carbon::instance($instant->toDateTime()));
    }

    private function expectImmutable(callable $mutation): void
    {
        try {
            DB::transaction($mutation);
            self::fail('The append-only table accepted a mutation.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('append-only', $exception->getMessage());
        }
    }

    private function psgcVersion(): void
    {
        if (! DB::table('psgc_versions')->where('status', 'ACTIVE')->exists()) {
            DB::table('psgc_versions')->insert(['id' => (string) Str::uuid7(), 'version' => 'TEST-2026', 'effective_on' => '2026-01-01', 'status' => 'ACTIVE', 'source_reference' => 'TEST fixture', 'activated_at' => now(), 'area_count' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE14ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
