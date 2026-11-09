<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\Products\VendorProductAnalytics;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Procurement\ListingPublicFacts;
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

    public function test_product_reports_match_finance_snapshots_and_exclude_cancelled_and_fully_refunded_sales(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Consistent product sales', [['price' => 100000, 'qty' => '100']], 1000);
        foreach (range(1, 3) as $unused) {
            $this->confirmedOrder($store, $owner, $listing);
        }
        $ids = DB::table('orders')->where('vendor_organization_id', $store->id)->orderBy('id')->pluck('id')->all();
        DB::table('orders')->where('id', $ids[1])->update(['order_state' => 'CANCELLED']);
        $payment = DB::table('payments')->where('order_id', $ids[2])->where('state', 'PAID')->first();
        DB::table('refunds')->insert(['id' => (string) Str::uuid7(), 'target_type' => 'ORDER', 'order_id' => $ids[2],
            'source_payment_id' => $payment->id, 'trigger' => 'TECHNICAL_COMPENSATION', 'amount_centavos' => $payment->total_centavos,
            'principal_centavos' => $payment->principal_centavos, 'processing_fee_centavos' => $payment->processing_fee_centavos,
            'source_captured_centavos' => $payment->total_centavos, 'state' => 'REFUNDED', 'idempotency_key' => (string) Str::uuid7(),
            'created_at' => now(), 'updated_at' => now()]);
        // A confirmed discount creates a new frozen amount that every product report must use.
        [$buyer, $discounted] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        $this->confirmOrder($owner, $discounted, [], ['vendor_discount_centavos' => 10000])->assertOk();
        $this->buyerOrder($buyer, $discounted);
        $this->postJson('/api/v1/buyers/orders/'.$discounted.'/revision/approve', ['snapshot_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $attempt = $this->startPayment($buyer, $discounted);
        $this->completePayment($attempt['id'])->assertOk();

        $this->signInStoreMember($owner);
        $finance = $this->getJson('/api/v1/vendor/finance/earnings')->assertOk()->json('data');
        $dashboard = $this->getJson('/api/v1/vendor/dashboard/insights?days=30')->assertOk()->json('data.orders.products');
        $analytics = $this->getJson('/api/v1/vendor/product-analytics?days=30')->assertOk()->json('data');
        $detail = $this->getJson('/api/v1/vendor/product-analytics/listings/'.$listing.'?days=30')->assertOk()->json('data');
        self::assertSame(390000, $finance['breakdown']['sales']['materials_after_discount_centavos']);
        self::assertSame(390000, $finance['products']['items'][0]['value_centavos']);
        self::assertSame(390000, $dashboard['top'][0]['value_centavos']);
        self::assertSame(390000, array_sum(array_column($dashboard['categories'], 'value_centavos')));
        self::assertSame(390000, $dashboard['sales_breakdown']['product_sales_centavos']);
        self::assertSame($finance['commercial_sales_centavos'], $dashboard['sales_breakdown']['net_sales_centavos']);
        self::assertSame(390000, $analytics['kpis']['value_centavos']['value']);
        self::assertSame(390000, $detail['kpis']['value_centavos']['value']);
        self::assertSame(2, $dashboard['top'][0]['orders']);
        self::assertSame(2, $analytics['kpis']['orders']['value']);
    }

    public function test_catalog_managers_may_read_peso_values_stay_owner_only_and_other_actors_are_refused(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Role Analytics Store', [['price' => 100000, 'qty' => '100']], 1000);
        $this->confirmedOrder($store, $owner, $listing);

        foreach (['STORE_MANAGER', 'STORE_STAFF', 'INVENTORY'] as $role) {
            $this->signInStoreMember($this->storeMember($store, $role));
            $data = $this->getJson('/api/v1/vendor/product-analytics')->assertOk()->json('data');
            self::assertFalse($data['access']['sales_value'], $role);
            self::assertSame($role === 'INVENTORY' ? null : [], $data['top_rated'], $role.' retains the existing reviews.view gate.');
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

    public function test_top_rated_products_reuse_all_time_visible_averages_across_the_whole_store(): void
    {
        [$store, $owner, $first] = $this->pickupStore('Rated Analytics');
        $second = $this->orderListing('RATED-SECOND');
        $third = $this->orderListing('RATED-THIRD');
        $this->orderListing('UNRATED');
        [$other, , $foreign] = $this->pickupStore('Foreign Ratings');
        $buyer = $this->buyer();
        $this->ratedProduct($store, $buyer, $first, 4);
        $this->ratedProduct($store, $buyer, $first, 5);
        $this->ratedProduct($store, $buyer, $second, 5);
        $old = $this->ratedProduct($store, $buyer, $third, 5);
        DB::table('reviews')->where('id', $old)->update(['submitted_at' => now()->subDays(120), 'revealed_at' => now()->subDays(120)]);
        $this->ratedProduct($store, $buyer, $third, 5);
        $this->ratedProduct($other, $buyer, $foreign, 5);
        $this->signInStoreMember($owner);
        $expected = app(ListingPublicFacts::class)->productRatings([$first, $second, $third]);
        $url = '/api/v1/vendor/product-analytics?days=7&page=2';
        $ranked = $this->getJson($url)->assertOk()->json('data.top_rated');
        self::assertSame([$third, $second, $first], array_column($ranked, 'listing_id'), 'Average first, then rating count; independent of table pagination.');
        foreach ($ranked as $product) {
            self::assertSame($expected[$product['listing_id']]['average'], $product['average']);
            self::assertSame($expected[$product['listing_id']]['count'], $product['count']);
            self::assertSame(['listing_id', 'name', 'category', 'average', 'count'], array_keys($product));
        }
        self::assertSame($ranked, $this->getJson('/api/v1/vendor/product-analytics?days=90')->assertOk()->json('data.top_rated'));
        $this->signInStoreMember($this->storeMember($store, 'STORE_STAFF'));
        self::assertSame($ranked, $this->getJson($url)->assertOk()->json('data.top_rated'));
        $this->signInStoreMember($this->storeMember($store, 'INVENTORY'));
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated', null);
    }

    public function test_top_rated_products_withhold_blind_moderated_disputed_and_excluded_reviews(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Rating Eligibility');
        $buyer = $this->buyer();
        $review = $this->ratedProduct($store, $buyer, $listing, 5);
        $order = (string) DB::table('reviews')->where('id', $review)->value('order_id');
        $this->signInStoreMember($owner);
        $url = '/api/v1/vendor/product-analytics';
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated.0.average', '5.00');
        DB::table('reviews')->where('id', $review)->update(['revealed_at' => null]);
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated', []);
        DB::table('reviews')->where('id', $review)->update(['revealed_at' => now(), 'moderation_state' => 'REMOVED']);
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated', []);
        DB::table('reviews')->where('id', $review)->update(['moderation_state' => 'NONE']);
        $case = (string) Str::uuid7();
        DB::table('dispute_cases')->insert(['id' => $case, 'reference' => 'CASE-ANALYTICS-RATING', 'order_id' => $order, 'vendor_organization_id' => $store->id,
            'status' => 'OPEN_AWAITING_RESPONSE', 'filed_by_party' => 'BUYER', 'responding_party' => 'VENDOR', 'description' => 'The materials were damaged on arrival.',
            'issue_type' => 'DEFECTIVE', 'requested_remedy' => 'REPLACEMENT', 'response_due_at' => now()->addDays(2), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated', []);
        DB::table('dispute_cases')->where('id', $case)->update(['status' => 'RESOLVED']);
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated.0.count', 1);
        DB::table('score_exclusions')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'vendor_organization_id' => $store->id, 'reason_code' => 'TEST',
            'note' => 'Exclude this fixture from public score inputs.', 'created_by_user_id' => $owner->id, 'created_role' => 'ADMIN_SUPERADMIN', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson($url)->assertOk()->assertJsonPath('data.top_rated', []);
    }

    private function ratedProduct(VendorOrganization $store, User $buyer, string $listing, int $rating): string
    {
        $profile = $this->buyerProfileId($buyer);
        $order = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $order, 'reference' => 'ORD-'.Str::upper(Str::random(10)), 'buyer_profile_id' => $profile, 'vendor_organization_id' => $store->id, 'procurement_type' => 'ITEM_BASED',
            'order_state' => 'COMPLETED', 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'commercial_total_centavos' => 1000, 'materials_centavos' => 1000,
            'closed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $variant = DB::table('listing_variants')->where('vendor_listing_id', $listing)->first(['id', 'unit_id']);
        $line = (string) Str::uuid7();
        DB::table('order_lines')->insert(['id' => $line, 'order_id' => $order, 'listing_variant_id' => $variant->id, 'unit_id' => $variant->unit_id,
            'quantity' => '1', 'unit_price_centavos' => 1000, 'payable_centavos' => 1000, 'tax_category' => 'NON_VAT', 'created_at' => now(), 'updated_at' => now()]);
        $review = (string) Str::uuid7();
        DB::table('reviews')->insert(['id' => $review, 'order_id' => $order, 'order_line_id' => $line, 'vendor_listing_id' => $listing, 'vendor_organization_id' => $store->id, 'buyer_profile_id' => $profile,
            'review_type' => 'PRODUCT', 'reviewer_party' => 'BUYER', 'reviewer_role' => 'BUYER', 'reviewer_user_id' => $buyer->id, 'rating' => $rating,
            'submitted_at' => now(), 'revealed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $review;
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
