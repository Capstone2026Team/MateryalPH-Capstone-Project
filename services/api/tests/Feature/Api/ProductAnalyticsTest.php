<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\Products\VendorProductAnalytics;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Vendor Product Analytics: product views recorded once per Buyer per Manila day from Product Details, view-to-order
 * conversion, tenant isolation, the catalog.manage gate with Owner-only peso values, strict filters and suggestions.
 */
final class ProductAnalyticsTest extends TestCase
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

    public function test_views_count_once_per_buyer_per_day_and_feed_conversion_without_revealing_buyers(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Analytics Store', [['price' => 100000, 'qty' => '100']], 1000);
        [$other, , $otherListing] = $this->pickupStore('Other Analytics Store', [['price' => 90000, 'qty' => '100']], 1200);

        $first = $this->buyer();
        $this->viewDetails($listing);
        $this->viewDetails($listing);
        $second = $this->buyer();
        $this->viewDetails($listing);
        $this->viewDetails($otherListing);
        self::assertSame(2, DB::table('listing_view_days')->where('vendor_listing_id', $listing)->count(), 'A repeat open on the same day is not another view.');
        self::assertSame((string) $other->id, (string) DB::table('listing_view_days')->where('vendor_listing_id', $otherListing)->value('vendor_organization_id'));

        $this->confirmedOrder($store, $owner, $listing, $first);
        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/product-analytics?days=30')->assertOk();
        $data = $response->json('data');

        self::assertTrue($data['access']['sales_value']);
        self::assertSame(2, $data['kpis']['views']['value'], 'Another store’s views are never counted.');
        self::assertSame(2, $data['kpis']['viewers']['value']);
        self::assertSame(['value' => 1, 'total' => 1], $data['kpis']['products_viewed']);
        self::assertSame(['percent' => '50.00', 'numerator' => 1, 'denominator' => 2], $data['kpis']['conversion']);
        self::assertSame(1, $data['kpis']['orders']['value']);
        $lineValue = (int) DB::table('order_lines as l')->join('orders as o', 'o.id', '=', 'l.order_id')->where('o.vendor_organization_id', $store->id)->sum('l.payable_centavos');
        self::assertSame($lineValue, $data['kpis']['value_centavos']['value']);
        self::assertCount(30, $data['series']);
        self::assertSame(2, array_sum(array_column($data['series'], 'views')));
        self::assertSame($listing, $data['top_selling'][0]['listing_id']);
        self::assertSame($listing, $data['most_viewed'][0]['listing_id']);
        self::assertSame(VendorProductAnalytics::wilson(1, 2), $data['top_performing'][0]['conversion_lower_bound']);
        self::assertSame(1, $data['products']['meta']['total']);
        self::assertSame(1, $data['products']['items'][0]['rank_views']);
        self::assertSame('INSUFFICIENT_DATA', $data['forecast']['views']['state'], 'One day of views is not enough for a forecast.');
        self::assertSame('INSUFFICIENT_DATA', $data['segments']['state']);
        self::assertArrayNotHasKey('previous_viewers', $data['products']['items'][0]);
        $json = (string) $response->getContent();
        foreach ([$this->buyerProfileId($first), $this->buyerProfileId($second), 'buyer_profile_id', 'latitude', 'email'] as $needle) {
            self::assertStringNotContainsString($needle, $json, 'No Buyer identity or location reaches the Vendor.');
        }

        $detail = $this->getJson('/api/v1/vendor/product-analytics/listings/'.$listing.'?days=7')->assertOk()->json('data');
        self::assertSame(2, $detail['product']['views']);
        self::assertCount(7, $detail['series']);
        self::assertSame('50.00', $detail['kpis']['conversion']['percent']);
        self::assertSame(1, $detail['kpis']['buyers']);
        self::assertSame('INSUFFICIENT_DATA', $detail['unusual_days']['state']);

        $summary = $this->getJson('/api/v1/vendor/product-analytics/summaries?listing_ids='.$listing.','.$otherListing)->assertOk()->json('data');
        self::assertCount(1, $summary['items'], 'Another store’s listing is silently left out.');
        self::assertSame(2, $summary['items'][0]['views']);
        self::assertSame(1, $summary['items'][0]['orders']);
        self::assertCount(30, $summary['items'][0]['daily_views']);
    }

    public function test_a_viewed_product_without_sellable_stock_produces_a_restock_suggestion(): void
    {
        [, $owner, $listing] = $this->pickupStore('Restock Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->buyer();
        $this->viewDetails($listing);
        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variantIds($listing))->update(['quantity_on_hand' => DB::raw('hard_reserved_quantity')]);

        $this->signInStoreMember($owner);
        $data = $this->getJson('/api/v1/vendor/product-analytics')->assertOk()->json('data');
        self::assertSame('OUT_OF_STOCK', $data['products']['items'][0]['stock_status']);
        $restock = collect($data['suggestions'])->firstWhere('kind', 'RESTOCK_VIEWED');
        self::assertNotNull($restock);
        self::assertSame('HIGH', $restock['priority']);
        self::assertSame($listing, $restock['listing_id']);
        self::assertSame('/products/inventory', $restock['href']);
        foreach ($data['suggestions'] as $suggestion) {
            self::assertNotSame('', $suggestion['technique'], 'Every suggestion names its technique.');
        }
        $detail = $this->getJson('/api/v1/vendor/product-analytics/listings/'.$listing)->assertOk()->json('data');
        self::assertSame(['RESTOCK_VIEWED'], array_column($detail['suggestions'], 'kind'));
    }

    public function test_catalog_managers_may_read_peso_values_stay_owner_only_and_other_actors_are_refused(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Role Analytics Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->confirmedOrder($store, $owner, $listing);

        foreach (['STORE_MANAGER', 'STORE_STAFF', 'INVENTORY'] as $role) {
            $this->signInStoreMember($this->storeMember($store, $role));
            $data = $this->getJson('/api/v1/vendor/product-analytics')->assertOk()->json('data');
            self::assertFalse($data['access']['sales_value'], $role);
            self::assertNull($data['kpis']['value_centavos'], $role.' never receives peso values.');
            self::assertNull($data['series'][0]['value_centavos']);
            self::assertNull($data['top_selling'][0]['value_centavos']);
            self::assertNull($data['categories'][0]['value_centavos']);
            self::assertSame('orders', $this->getJson('/api/v1/vendor/product-analytics?sort=value')->assertOk()->json('data.products.meta.sort'), 'Sorting by value falls back to orders.');
        }
        foreach (['CUSTOMER_SERVICE', 'FULFILLMENT'] as $role) {
            $this->signInStoreMember($this->storeMember($store, $role));
            $this->getJson('/api/v1/vendor/product-analytics')->assertForbidden()->assertJsonPath('errors.0.code', 'PRODUCT_ANALYTICS_DENIED');
            $this->getJson('/api/v1/vendor/product-analytics/summaries?listing_ids='.$listing)->assertForbidden();
        }

        [, $otherOwner] = $this->pickupStore('Foreign Store', [['price' => 100000, 'qty' => '100']], 1500);
        $this->signInStoreMember($otherOwner);
        $this->getJson('/api/v1/vendor/product-analytics/listings/'.$listing)->assertNotFound()->assertJsonPath('errors.0.code', 'LISTING_NOT_FOUND');

        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/product-analytics?days=14')->assertStatus(422);
        $this->getJson('/api/v1/vendor/product-analytics?store_id=abc')->assertStatus(422)->assertJsonPath('errors.0.code', 'PRODUCT_ANALYTICS_FILTER_UNSUPPORTED');
        $this->getJson('/api/v1/vendor/product-analytics?from=2026-01-02&to=2026-01-01')->assertStatus(422);
        $this->getJson('/api/v1/vendor/product-analytics/summaries')->assertStatus(422);
        $many = implode(',', array_map(static fn (): string => (string) Str::uuid7(), range(1, 51)));
        $this->getJson('/api/v1/vendor/product-analytics/summaries?listing_ids='.$many)->assertStatus(422);

        $this->signInBuyer($this->buyer());
        $this->getJson('/api/v1/vendor/product-analytics')->assertForbidden();
    }

    private function viewDetails(string $listing): void
    {
        $this->postJson('/api/v1/buyers/listings/'.$listing.'/details', $this->origin())->assertOk();
    }

    private function confirmedOrder(VendorOrganization $store, User $owner, string $listing, ?User $buyer = null): void
    {
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']], $buyer);
        $this->confirmOrder($owner, $orderId)->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));
    }
}
