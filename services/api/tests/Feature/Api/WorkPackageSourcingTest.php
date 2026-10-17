<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/** Owner decisions 2026-10-12: Vendor selection sorting/filters and separate, linked Item-Based purchases for missing lines. */
final class WorkPackageSourcingTest extends TestCase
{
    use CreatesDiscoveryFixtures, CreatesOrderFixtures, RefreshDatabase;

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

    private function key(): array
    {
        return ['Idempotency-Key' => (string) Str::uuid7()];
    }

    /** @return array{0: object, 1: object, 2: string, 3: string} near store, cheaper store, cheaper listing, buyer site location */
    private function scenario(): array
    {
        [$near] = $this->pickupStore('Near store', [['price' => 1800, 'qty' => '40']], 500);
        [$cheap, , $cheapListing] = $this->pickupStore('Cheap store', [['price' => 1500, 'qty' => '40']], 1000);
        DB::table('store_profiles')->whereIn('vendor_organization_id', [$near->id, $cheap->id])->update(['bulk_capability' => true]);

        return [$near, $cheap, $cheapListing, ''];
    }

    /** @return array{0: array<string, mixed>, 1: string} activated package and site location */
    private function package(string $payment = 'ONLINE'): array
    {
        $site = $this->savedLocation(auth('api')->user(), 'Project site', 0, 0, 'PROJECT_SITE');
        $p = $this->postJson('/api/v1/buyers/projects', ['name' => 'House', 'budget_centavos' => 1000000, 'starts_on' => now()->toDateString(),
            'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], $this->key())->assertCreated()->json('data');
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', ['name' => 'Masonry', 'budget_centavos' => 100000, 'site_id' => $p['sites'][0]['id'], 'radius_km' => 5,
            'fulfillment_method' => 'PICKUP', 'payment_method' => $payment, 'lines' => [
                ['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => '10', 'name' => 'Hollow blocks', 'specifications' => ['thickness_mm' => '100']],
                ['unit_id' => DB::table('units')->where('code', 'CUM')->value('id'), 'quantity' => '2', 'name' => 'River sand', 'specifications' => []],
            ]], $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 5])->assertOk();

        return [$w, $site];
    }

    public function test_vendor_results_sort_and_filter_on_the_server_and_flag_favorites(): void
    {
        [$near, $cheap] = $this->scenario();
        $buyer = $this->buyer();
        [$w] = $this->package();
        $url = '/api/v1/buyers/work-packages/'.$w['id'].'/estimates';
        self::assertSame($cheap->id, $this->getJson($url.'?sort=PRICE')->assertOk()->json('data.items.0.vendor_id'));
        $this->getJson($url.'?sort=PRICE')->assertJsonPath('data.sort', 'PRICE')->assertJsonPath('data.items.1.vendor_id', $near->id);
        $this->getJson($url.'?sort=CHEAPEST')->assertUnprocessable();

        DB::table('favorite_vendors')->insert(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $this->buyerProfileId($buyer), 'vendor_organization_id' => $near->id, 'created_at' => now(), 'updated_at' => now()]);
        $favorites = $this->getJson($url.'?favorites_only=1')->assertOk()->json('data');
        self::assertSame([[$near->id, true]], array_map(static fn (array $i): array => [$i['vendor_id'], $i['is_favorite']], $favorites['items']));
        self::assertSame([1, 2], [$favorites['total'], $favorites['unfiltered_total']]);
        // The unlisted line keeps every Vendor partial.
        $this->getJson($url.'?complete_only=true')->assertOk()->assertJsonPath('data.total', 0)->assertJsonPath('data.unfiltered_total', 2);
        $this->getJson($url.'?within_budget=1')->assertOk()->assertJsonPath('data.total', 2);
    }

    public function test_the_scan_lists_only_vendors_that_offer_the_package_payment_method(): void
    {
        [$near, $cheap] = $this->scenario();
        $this->buyer();
        // Only the near store's Owner enabled In-Store Payment.
        DB::table('vendor_payment_settings')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $near->id, 'cod_enabled' => false,
            'in_store_enabled' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        [$w] = $this->package('IN_STORE');
        $items = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates')->assertOk()->assertJsonPath('data.total', 1)->json('data.items');
        self::assertSame([$near->id], array_column($items, 'vendor_id'));
        self::assertSame('IN_STORE', $items[0]['payment_method']);
        self::assertNotSame($cheap->id, $items[0]['vendor_id']);
    }

    public function test_missing_lines_list_similar_item_offers_and_tagged_purchases_flow_into_orders(): void
    {
        [$near, $cheap, $cheapListing] = $this->scenario();
        $buyer = $this->buyer();
        [$w, $site] = $this->package();
        $lines = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->orderBy('line_number')->pluck('id')->all();
        $base = '/api/v1/buyers/work-packages/'.$w['id'].'/lines/';

        $offers = $this->getJson($base.$lines[0].'/alternatives')->assertOk()->json('data');
        self::assertSame('CATALOG', $offers['status']);
        self::assertSame([$cheap->id, $near->id], array_column($offers['items'], 'vendor_id'));
        self::assertTrue($offers['items'][0]['exact_match']);
        self::assertArrayNotHasKey('available', $offers['items'][0]);
        self::assertSame($site, $offers['location_id']);
        self::assertSame([$near->id], array_column($this->getJson($base.$lines[0].'/alternatives?exclude_vendor_id='.$cheap->id)->assertOk()->json('data.items'), 'vendor_id'));
        $this->getJson($base.$lines[1].'/alternatives')->assertOk()->assertJsonPath('data.status', 'UNLISTED')->assertJsonCount(0, 'data.items');

        $item = $offers['items'][0];
        $add = ['listing_variant_id' => $item['variant_id'], 'expected_price_version_id' => $item['price_version_id'], 'quantity' => '10', 'location_id' => $site, 'radius_km' => 5];
        $this->postJson('/api/v1/buyers/cart/items', $add + ['work_package_line_id' => $lines[1]], $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'MISSING_LINE_TAG_INVALID');
        $this->postJson('/api/v1/buyers/cart/items', $add + ['work_package_line_id' => $lines[0]], $this->key())->assertOk()->assertJsonPath('data.groups.0.lines.0.work_package_line_id', $lines[0]);
        $order = $this->submitCheckout([$cheap->id])->assertCreated()->json('data.orders.0.id');
        self::assertSame($lines[0], DB::table('order_lines')->where('order_id', $order)->value('work_package_line_id'));
        self::assertSame($cheapListing, DB::table('order_lines')->where('order_id', $order)->value('vendor_listing_id'));

        DB::table('work_package_missing_lines')->insert(['id' => (string) Str::uuid7(), 'work_package_version_id' => $w['current_version_id'], 'work_package_line_id' => $lines[0], 'quantity' => '10', 'created_at' => now(), 'updated_at' => now()]);
        $missing = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data.missing_lines.0');
        self::assertSame([[$order, false]], array_map(static fn (array $o): array => [$o['id'], $o['linkable']], $missing['tagged_orders']));

        $this->buyer();
        $this->getJson($base.$lines[0].'/alternatives')->assertNotFound();
        $this->signInBuyer($buyer);
    }
}
