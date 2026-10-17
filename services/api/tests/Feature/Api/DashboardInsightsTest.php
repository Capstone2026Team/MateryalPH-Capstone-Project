<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\Geo\DemoGeoAnalytics;
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
 * Vendor and Admin dashboard insights: real order data, tenant isolation, the role matrix (peso values Owner-only, scores
 * Owner/Manager only, assigned-work-only Fulfillment), strict filters, and the Admin read model's small-cell protection
 * carrying through to forecasts and segments.
 */
final class DashboardInsightsTest extends TestCase
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
    }

    public function test_vendor_dated_workspaces_validate_the_range_and_query_their_timestamp_fields(): void
    {
        [, $owner, $listing] = $this->pickupStore('Dated workspace requests');
        $this->signInStoreMember($owner);
        $variant = $this->variantIds($listing)[0];
        $paths = ['/api/v1/vendor/orders', '/api/v1/vendor/disputes', '/api/v1/vendor/reviews', '/api/v1/vendor/finance/earnings',
            '/api/v1/vendors/account/activity', '/api/v1/vendor/notifications', '/api/v1/vendor/reports',
            '/api/v1/vendor/inventory/items/'.$variant.'/movements', '/api/v1/vendor/inventory/items/'.$variant.'/prices'];
        foreach (['PAYMENTS', 'PHYSICAL', 'REMITTANCES', 'STATEMENTS', 'REFUNDS', 'TAX_DOCUMENTS'] as $tab) {
            $paths[] = '/api/v1/vendor/finance/transactions?tab='.$tab;
            $paths[] = '/api/v1/vendor/finance/transactions/export?tab='.$tab;
        }
        foreach (['REQUESTS', 'DUE', 'RECORDS', 'RECONCILIATION'] as $view) {
            $paths[] = '/api/v1/vendor/invoices?view='.$view;
        }
        foreach ($paths as $path) {
            $separator = str_contains($path, '?') ? '&' : '?';
            $this->get($path.$separator.'from=2000-01-01&to=2000-01-01', ['Accept' => 'application/json'])->assertOk();
            $this->getJson($path.$separator.'from=2000-01-02&to=2000-01-01')->assertUnprocessable();
        }
    }

    public function test_vendor_custom_dates_apply_a_reporting_cutoff_and_all_dates_include_older_history(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Dated Insights', [['price' => 100000, 'qty' => '100']], 1000);
        $now = CarbonImmutable::now('Asia/Manila')->startOfDay();
        foreach ([$now->subDays(120), $now->subDays(2), $now] as $date) {
            $this->confirmedOrder($store, $owner, $listing);
            $id = DB::table('orders')->where('vendor_organization_id', $store->id)->orderByDesc('id')->value('id');
            $instant = $date->addHours(9)->setTimezone('UTC');
            DB::table('orders')->where('id', $id)->update(['created_at' => $instant, 'submitted_at' => $instant, 'accepted_at' => $instant]);
            $history = (array) DB::table('order_status_history')->where('order_id', $id)->where('to_state', 'CONFIRMED')->first();
            // Add synthetic historic facts; the append-only record already present is never edited.
            DB::table('order_status_history')->insert(['id' => (string) Str::uuid7(), 'created_at' => $instant] + array_diff_key($history, array_flip(['id', 'created_at'])));
        }
        $this->signInStoreMember($owner);
        $day = $now->subDays(2)->toDateString();
        $selected = $this->getJson('/api/v1/vendor/dashboard/insights?from='.$day.'&to='.$day)->assertOk()->json('data');
        self::assertSame(1, $selected['orders']['kpis']['order_volume']['value']);
        self::assertCount(1, $selected['orders']['series']);
        self::assertSame(1, collect($selected['orders']['funnel'])->firstWhere('key', 'ORDER_REQUESTS')['count']);
        self::assertSame($day, $selected['period']['to']);
        $all = $this->getJson('/api/v1/vendor/dashboard/insights')->assertOk()->json('data');
        self::assertSame(3, $all['orders']['kpis']['order_volume']['value']);
        self::assertSame(121, $all['period']['days']);
        self::assertCount(121, $all['orders']['series']);
        self::assertSame(3, array_sum(array_column($all['orders']['series'], 'orders')));
        $this->getJson('/api/v1/vendor/dashboard/insights?from='.$now->addDay()->toDateString())->assertUnprocessable();
        $this->getJson('/api/v1/vendor/dashboard/insights?from='.$now->toDateString().'&to='.$day)->assertUnprocessable();
    }

    public function test_owner_sees_only_their_stores_confirmed_orders_with_values_and_mining_sections(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Insight Store', [['price' => 100000, 'qty' => '100']], 1000);
        $totals = array_map(fn (): int => $this->confirmedOrder($store, $owner, $listing), range(1, 3));
        [$other, $otherOwner, $otherListing] = $this->pickupStore('Other Store', [['price' => 250000, 'qty' => '100']], 2000);
        $this->confirmedOrder($other, $otherOwner, $otherListing);
        $expectedGross = array_sum($totals);

        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/dashboard/insights?days=30')->assertOk();
        $data = $response->json('data');

        self::assertSame(['orders' => true, 'sales_value' => true, 'performance' => true, 'stock' => true, 'disputes' => true, 'assigned_fulfillment' => false], $data['access']);
        self::assertSame(3, $data['orders']['kpis']['order_volume']['value'], 'Another store’s order is never counted.');
        self::assertSame($expectedGross, $data['orders']['kpis']['gross_sales_centavos']['value']);
        self::assertSame(intdiv($expectedGross, 3), $data['orders']['kpis']['average_order_value_centavos']['value']);
        self::assertCount(30, $data['orders']['series']);
        self::assertSame(3, array_sum(array_column($data['orders']['series'], 'orders')));
        self::assertSame($expectedGross, array_sum(array_column($data['orders']['series'], 'gross_sales_centavos')));
        self::assertSame('INSUFFICIENT_DATA', $data['orders']['forecast']['orders']['state'], 'Fewer than seven active days is not enough for a forecast.');
        self::assertSame(7, $data['orders']['forecast']['horizon_days']);
        self::assertSame('INSUFFICIENT_DATA', $data['orders']['products']['segments']['state']);
        self::assertSame([], $data['orders']['products']['basket_rules']['rules']);
        self::assertSame(3, $data['orders']['products']['top'][0]['orders']);
        $lineValue = (int) DB::table('order_lines as l')->join('orders as o', 'o.id', '=', 'l.order_id')->where('o.vendor_organization_id', $store->id)->sum('l.payable_centavos');
        self::assertCount(1, $data['orders']['products']['top'], 'The store sells one listing.');
        self::assertSame($lineValue, $data['orders']['products']['top'][0]['value_centavos']);
        self::assertSame(['INQUIRIES', 'QUOTATIONS', 'ORDER_REQUESTS', 'CONFIRMED', 'COMPLETED'], array_column($data['orders']['funnel'], 'key'));
        self::assertSame(3, collect($data['orders']['funnel'])->firstWhere('key', 'CONFIRMED')['count']);
        self::assertSame('BUILDING_TRACK_RECORD', $data['performance']['classification']['class']);
        self::assertSame('New Vendor — Building Track Record', $data['performance']['classification']['label']);
        self::assertSame(1, $data['stock']['variants']);
        self::assertFalse($data['traffic']['store_visits']['tracked'], 'The platform records no storefront visits, so none are shown.');
        self::assertStringNotContainsString('email', (string) $response->getContent());
    }

    public function test_gross_sales_stays_before_refunds_and_cancellations_while_net_sales_removes_them(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Gross Rule Store', [['price' => 100000, 'qty' => '100']], 1000);
        $totals = array_map(fn (): int => $this->confirmedOrder($store, $owner, $listing), range(1, 4));
        $ids = DB::table('orders')->where('vendor_organization_id', $store->id)->pluck('id')->all();
        DB::table('orders')->where('id', $ids[0])->update(['refund_state' => 'REFUNDED']);
        DB::table('orders')->where('id', $ids[1])->update(['order_state' => 'CANCELLED']);

        $this->signInStoreMember($owner);
        $data = $this->getJson('/api/v1/vendor/dashboard/insights?days=30')->assertOk()->json('data');
        $kpis = $data['orders']['kpis'];
        self::assertSame(4, $kpis['order_volume']['value'], 'Every confirmed order still counts as an order.');
        $all = array_sum($totals);
        self::assertSame($all, $kpis['gross_sales_centavos']['value'], 'Gross sales is every confirmed order, before returns, refunds and cancellations.');
        self::assertSame($all - $totals[1], $kpis['net_sales_centavos']['value'], 'Net sales removes the cancelled order; a refund only reduces it once the refund record is paid.');
        self::assertSame(intdiv($all, 4), $kpis['average_order_value_centavos']['value']);
        self::assertSame($all, array_sum(array_column($data['orders']['series'], 'gross_sales_centavos')));
        self::assertSame($all - $totals[1], array_sum(array_column($data['orders']['series'], 'net_sales_centavos')));
    }

    public function test_role_matrix_limits_each_section_and_never_returns_a_redacted_copy(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Role Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->confirmedOrder($store, $owner, $listing);

        $expect = [
            'STORE_MANAGER' => ['orders' => true, 'sales_value' => false, 'performance' => true, 'stock' => true, 'disputes' => true],
            'STORE_STAFF' => ['orders' => true, 'sales_value' => false, 'performance' => false, 'stock' => true, 'disputes' => true],
            'CUSTOMER_SERVICE' => ['orders' => true, 'sales_value' => false, 'performance' => false, 'stock' => true, 'disputes' => true],
            'INVENTORY' => ['orders' => false, 'sales_value' => false, 'performance' => false, 'stock' => true, 'disputes' => false],
            'FULFILLMENT' => ['orders' => false, 'sales_value' => false, 'performance' => false, 'stock' => false, 'disputes' => false],
        ];
        foreach ($expect as $role => $sections) {
            $this->signInStoreMember($this->storeMember($store, $role));
            $data = $this->getJson('/api/v1/vendor/dashboard/insights')->assertOk()->json('data');
            foreach ($sections as $section => $allowed) {
                self::assertSame($allowed, $data['access'][$section], $role.' '.$section);
            }
            self::assertSame($sections['orders'], $data['orders'] !== null, $role.' orders section');
            self::assertSame($sections['performance'], $data['performance'] !== null, $role.' performance section');
            self::assertSame($sections['stock'], $data['stock'] !== null, $role.' stock section');
            self::assertSame($sections['disputes'], $data['disputes'] !== null, $role.' disputes section');
            if ($sections['orders']) {
                self::assertNull($data['orders']['kpis']['gross_sales_centavos'], $role.' never receives peso values.');
                self::assertNull($data['orders']['kpis']['average_order_value_centavos']);
                self::assertNull($data['orders']['forecast']['sales']);
                self::assertNull($data['orders']['series'][0]['gross_sales_centavos']);
                self::assertNull($data['orders']['products']['top'][0]['value_centavos']);
                self::assertNull($data['orders']['products']['categories'][0]['value_centavos']);
                self::assertNull($data['orders']['unusual_days']['days'][0]['gross_sales_centavos'] ?? null);
            }
        }
        $fulfillment = $this->storeMember($store, 'FULFILLMENT');
        $this->signInStoreMember($fulfillment);
        $keys = array_column($this->getJson('/api/v1/vendor/dashboard/insights')->assertOk()->json('data.actions'), 'key');
        self::assertSame(['ASSIGNED_FULFILLMENT'], $keys, 'Fulfillment staff see only their assigned work.');
    }

    public function test_disabling_staff_disputes_removes_the_case_section_and_other_actors_are_refused(): void
    {
        [$store, $owner] = $this->activeStore('Dispute Flag Store', false);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['staff_disputes_enabled' => false]);
        $this->signInStoreMember($this->storeMember($store, 'STORE_STAFF'));
        $data = $this->getJson('/api/v1/vendor/dashboard/insights')->assertOk()->json('data');
        self::assertNull($data['disputes']);
        self::assertNotContains('DISPUTE_RESPONSE', array_column($data['actions'], 'key'));

        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/dashboard/insights?days=14')->assertStatus(422);
        $this->getJson('/api/v1/vendor/dashboard/insights?store_id=abc')->assertStatus(422)->assertJsonPath('errors.0.code', 'DASHBOARD_FILTER_UNSUPPORTED');
        $this->signInBuyer($this->buyer());
        $this->getJson('/api/v1/vendor/dashboard/insights')->assertForbidden();
        $this->getJson('/api/v1/admin/dashboard/insights')->assertForbidden();
    }

    public function test_admin_insights_mine_the_disclosure_controlled_read_model_and_gate_each_section(): void
    {
        $this->importPsgc();
        $demo = app(DemoGeoAnalytics::class)->seed(60, 7);
        self::assertGreaterThan(0, $demo['orders']);
        $this->setK(3);

        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $data = $this->getJson('/api/v1/admin/dashboard/insights?dataset=DEMO&days=30')->assertOk()->json('data');
        self::assertTrue($data['access']['marketplace']);
        self::assertTrue($data['access']['vendor_health']);
        self::assertSame('DEMO — Simulated Marketplace Data', $data['marketplace']['dataset']['label']);
        self::assertCount(30, $data['marketplace']['series']);
        self::assertSame(['horizon_days', 'gross_gmv', 'order_volume'], array_keys($data['marketplace']['forecast']));
        self::assertContains($data['marketplace']['forecast']['order_volume']['state'], ['OK', 'INSUFFICIENT_DATA']);
        self::assertArrayHasKey('weekday_strength', $data['marketplace']['forecast']['gross_gmv']);
        self::assertContains($data['marketplace']['areas']['state'], ['OK', 'INSUFFICIENT_DATA']);
        self::assertSame(3, $data['marketplace']['categories']['minimum_buyers']);
        foreach ($data['marketplace']['categories']['rules'] as $rule) {
            self::assertGreaterThan(1.0, $rule['lift']);
            self::assertGreaterThanOrEqual(3, $rule['support_count']);
        }
        self::assertArrayHasKey('classes', $data['vendor_health']);
        $json = json_encode($data, JSON_THROW_ON_ERROR);
        foreach (['"latitude"', '"longitude"', '"buyer_key"', '"email"'] as $needle) {
            self::assertStringNotContainsString($needle, $json);
        }

        // A role without aggregate access gets no marketplace section, not a redacted one.
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $limited = $this->getJson('/api/v1/admin/dashboard/insights?dataset=DEMO')->assertOk()->json('data');
        self::assertFalse($limited['access']['marketplace']);
        self::assertNull($limited['marketplace']);

        // The feature flag turns the geographic read model off; the endpoint says so instead of failing.
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        DB::table('platform_settings')->where('key', 'features.flags')->update(['value' => json_encode(['materials_analytics' => true, 'geo_analytics' => false])]);
        PlatformSettings::current()->forget();
        $off = $this->getJson('/api/v1/admin/dashboard/insights?dataset=DEMO')->assertOk()->json('data');
        self::assertNull($off['marketplace']);
        self::assertSame('Geographic analytics is turned off in Platform Settings.', $off['marketplace_unavailable_reason']);
        DB::table('platform_settings')->where('key', 'features.flags')->update(['value' => json_encode(['materials_analytics' => true, 'geo_analytics' => true])]);
        PlatformSettings::current()->forget();

        $this->getJson('/api/v1/admin/dashboard/insights?days=45')->assertStatus(422);
        $this->getJson('/api/v1/admin/dashboard/insights?latitude=14.5')->assertStatus(422)->assertJsonPath('errors.0.code', 'DASHBOARD_FILTER_UNSUPPORTED');
        $this->getJson('/api/v1/admin/dashboard/insights?area=nope')->assertStatus(422);
    }

    public function test_small_cells_stay_hidden_through_forecasts_segments_and_rules(): void
    {
        $this->importPsgc();
        app(DemoGeoAnalytics::class)->seed(60, 7);
        // The highest allowed threshold suppresses most person-derived cells of the small demo marketplace.
        $this->setK(50);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $data = $this->getJson('/api/v1/admin/dashboard/insights?dataset=DEMO&days=30')->assertOk()->json('data.marketplace');
        $period = $data['period'];
        $geo = $this->getJson('/api/v1/admin/geo-analytics?dataset=DEMO&granularity=DAY&from='.$period['from'].'&to='.$period['to'])->assertOk()->json('data');

        // The dashboard series is the read model's series cell for cell, so a hidden day stays hidden.
        self::assertSame(array_column($geo['trends'], 'order_volume'), array_column($data['series'], 'order_volume'));
        self::assertSame(array_column($geo['trends'], 'suppressed'), array_column($data['series'], 'suppressed'));
        self::assertGreaterThan(0, count(array_filter(array_column($data['series'], 'suppressed'))));
        $visibleActive = count(array_filter($data['series'], static fn (array $p): bool => ! $p['suppressed'] && $p['order_volume'] > 0));
        if ($visibleActive < 7) {
            self::assertSame('INSUFFICIENT_DATA', $data['forecast']['order_volume']['state'], 'A forecast is never built from hidden days.');
            self::assertSame([], $data['forecast']['order_volume']['points']);
        }

        // Areas with a hidden cell never enter a segment; every grouped area is fully visible in the read model.
        $visibleAreas = collect($geo['children'])->filter(static fn (array $c): bool => $c['order_volume']['value'] !== null && $c['registered_buyers']['value'] !== null)->pluck('name')->all();
        foreach ($data['areas']['points'] ?? [] as $point) {
            self::assertContains($point['name'], $visibleAreas);
        }
        foreach ($data['categories']['rules'] as $rule) {
            self::assertGreaterThanOrEqual(50, $rule['support_count']);
        }
        self::assertSame(50, $data['categories']['minimum_buyers']);
    }

    private function confirmedOrder(VendorOrganization $store, User $owner, string $listing): int
    {
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        $this->confirmOrder($owner, $orderId)->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return (int) DB::table('orders')->where('id', $orderId)->value('commercial_total_centavos');
    }

    private function setK(int $k): void
    {
        DB::table('platform_settings')->where('key', 'analytics.disclosure_min_persons')->update(['value' => json_encode($k)]);
        PlatformSettings::current()->forget();
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
            ."0203100000,Isabela,,Prov\n");
        app(PsgcImporter::class)->import(new PsgcCsvSource($path), '2025Q2', '2025-06-30', 'PSA PSGC test extract');
        app(PsgcImporter::class)->activate('2025Q2');
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('DASHBOARDADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
