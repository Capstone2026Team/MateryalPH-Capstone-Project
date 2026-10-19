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
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', ['name' => 'Masonry', 'budget_centavos' => 100000, 'site_id' => $p['sites'][0]['id'], 'radius_km' => 50,
            'fulfillment_method' => 'PICKUP', 'payment_method' => $payment, 'lines' => [
                ['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => '10', 'name' => 'Hollow blocks', 'specifications' => ['thickness_mm' => '100']],
                ['unit_id' => DB::table('units')->where('code', 'CUM')->value('id'), 'quantity' => '2', 'name' => 'River sand', 'specifications' => []],
            ]], $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk();

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

    public function test_sort_direction_reverses_the_order_keeps_unrated_vendors_last_and_breaks_ties_by_distance(): void
    {
        [$near, $cheap] = $this->scenario();
        $this->buyer();
        [$w] = $this->package();
        $url = '/api/v1/buyers/work-packages/'.$w['id'].'/estimates';
        $order = fn (string $query): array => array_column($this->getJson($url.$query)->assertOk()->json('data.items'), 'vendor_id');
        // Estimates are immutable snapshots, so a new rating needs a new scan.
        $rate = function (string $vendor, string $vps, string $day) use ($w): void {
            DB::table('score_snapshots')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $vendor, 'window_ends_on' => $day, 'vcs' => $vps, 'ohs' => $vps, 'vps' => $vps,
                'sample_counts' => '{}', 'created_at' => now(), 'updated_at' => now()]);
            $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk();
        };

        // Price opens cheapest first and flips on request; the arrow's direction is echoed.
        self::assertSame([$cheap->id, $near->id], $order('?sort=PRICE'));
        $this->getJson($url.'?sort=PRICE')->assertJsonPath('data.direction', 'ASC');
        self::assertSame([$near->id, $cheap->id], $order('?sort=PRICE&direction=DESC'));
        $this->getJson($url.'?sort=PRICE&direction=DESC')->assertJsonPath('data.direction', 'DESC');
        $this->getJson($url.'?sort=PRICE&direction=UP')->assertUnprocessable();

        // Best Match is a fixed ranking: a direction changes nothing and none is reported.
        self::assertSame($order('?sort=BEST_MATCH'), $order('?sort=BEST_MATCH&direction=DESC'));
        $this->getJson($url.'?sort=BEST_MATCH&direction=ASC')->assertJsonPath('data.direction', null);

        // A Vendor with no rating is last in both directions.
        $rate($cheap->id, '4.50', '2026-09-01');
        self::assertSame([$cheap->id, $near->id], $order('?sort=RATING'));
        self::assertSame([$cheap->id, $near->id], $order('?sort=RATING&direction=ASC'));
        $this->getJson($url.'?sort=RATING')->assertJsonPath('data.direction', 'DESC');

        // Rated Vendors reverse; equal ones fall back to the nearest store whichever way it runs.
        $rate($near->id, '3.50', '2026-09-01');
        self::assertSame([$cheap->id, $near->id], $order('?sort=RATING'));
        self::assertSame([$near->id, $cheap->id], $order('?sort=RATING&direction=ASC'));
        $rate($near->id, '4.50', '2026-09-08');
        self::assertSame([$near->id, $cheap->id], $order('?sort=RATING'));
        self::assertSame([$near->id, $cheap->id], $order('?sort=RATING&direction=ASC'));
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

    public function test_recommendations_and_tagged_adds_use_the_locked_site_when_the_saved_location_is_archived(): void
    {
        [$near, $cheap] = $this->scenario();
        $this->buyer();
        [$w, $site] = $this->package();
        $line = (string) DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->orderBy('line_number')->value('id');
        DB::table('buyer_locations')->where('id', $site)->update(['archived_at' => now(), 'is_primary' => false]);
        $base = '/api/v1/buyers/work-packages/'.$w['id'].'/lines/'.$line;

        $offers = $this->getJson($base.'/alternatives')->assertOk()->json('data.items');
        self::assertSame([$cheap->id, $near->id], array_column($offers, 'vendor_id'));
        $this->postJson('/api/v1/buyers/cart/items', ['listing_variant_id' => $offers[0]['variant_id'], 'expected_price_version_id' => $offers[0]['price_version_id'],
            'quantity' => '10', 'location_id' => $site, 'radius_km' => 50, 'work_package_line_id' => $line], $this->key())->assertOk()->assertJsonPath('data.groups.0.lines.0.work_package_line_id', $line);
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
        $add = ['listing_variant_id' => $item['variant_id'], 'expected_price_version_id' => $item['price_version_id'], 'quantity' => '10', 'location_id' => $site, 'radius_km' => 50];
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

    /**
     * Owner request 2026-10-17: stores 30 km away qualify, 60 km away never do, and no client value moves the radius.
     */
    public function test_the_project_radius_is_fixed_at_50_km_for_scans_alternatives_and_tagged_adds(): void
    {
        [$partial] = $this->pickupStore('Partial', [['price' => 1700, 'qty' => '6']], 500);
        [$far, , $farListing] = $this->pickupStore('Thirty km store', [['price' => 1500, 'qty' => '40']], 30000);
        [$out] = $this->pickupStore('Sixty km store', [['price' => 1000, 'qty' => '40']], 60000);
        DB::table('store_profiles')->whereIn('vendor_organization_id', [$partial->id, $far->id, $out->id])->update(['bulk_capability' => true]);
        $this->buyer();
        [$w, $site] = $this->package();
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $lines = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->orderBy('line_number')->pluck('id')->all();

        // The package and its scan carry the fixed radius; the 30 km store is a candidate, the 60 km store is not.
        self::assertSame(50, $w['version']['content']['radius_km']);
        $scan = $this->getJson($url.'/estimates')->assertOk()->json('data');
        self::assertSame(50, $scan['estimate']['context']['radius_km']);
        self::assertEqualsCanonicalizing([$partial->id, $far->id], array_column($scan['items'], 'vendor_id'));
        self::assertArrayNotHasKey('suggested_radius_km', $scan);
        foreach ([5, 10, 20, 30, 40] as $other) {
            $this->postJson($url.'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => $other])->assertUnprocessable();
        }

        $offers = $this->getJson($url.'/lines/'.$lines[0].'/alternatives')->assertOk()->json('data');
        self::assertSame(50, $offers['radius_km']);
        self::assertSame('CATALOG', $offers['status']);
        self::assertEqualsCanonicalizing([$partial->id, $far->id], array_column($offers['items'], 'vendor_id'));
        self::assertNotContains($out->id, array_column($offers['items'], 'vendor_id'));

        // A client-sent 5 km cannot make the server refuse a store the page just recommended.
        $item = collect($offers['items'])->firstWhere('vendor_id', $far->id);
        $this->postJson('/api/v1/buyers/cart/items', ['listing_variant_id' => $item['variant_id'], 'expected_price_version_id' => $item['price_version_id'], 'quantity' => '10',
            'radius_km' => 5, 'location_id' => $site, 'work_package_line_id' => $lines[0]], $this->key())->assertOk()->assertJsonPath('data.groups.0.lines.0.work_package_line_id', $lines[0]);
        self::assertSame($farListing, DB::table('cart_items as ci')->join('listing_variants as v', 'v.id', '=', 'ci.listing_variant_id')->value('v.vendor_listing_id'));

        // Creating a package with another radius is refused; leaving it out saves the fixed one.
        $project = (string) DB::table('work_packages')->where('id', $w['id'])->value('project_id');
        $body = ['name' => 'Second', 'budget_centavos' => 1000, 'site_id' => $this->getJson('/api/v1/buyers/projects/'.$project)->json('data.sites.0.id'), 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE',
            'lines' => [['material_id' => DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->value('id'), 'unit_id' => DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->value('canonical_unit_id'),
                'quantity' => '1', 'name' => 'Blocks', 'specifications' => ['thickness_mm' => '100']]]];
        $this->postJson('/api/v1/buyers/projects/'.$project.'/work-packages', $body + ['radius_km' => 20], $this->key())->assertUnprocessable();
        $this->postJson('/api/v1/buyers/projects/'.$project.'/work-packages', $body, $this->key())->assertCreated()->assertJsonPath('data.version.content.radius_km', 50);
    }

    /**
     * The card, the order summary and the missing-item list read one server-side fulfillment, which counts a separate
     * purchase only when the product satisfies the requirement and never stacks the same product twice.
     */
    public function test_fulfillment_is_derived_from_the_lines_and_separate_purchases_on_every_read(): void
    {
        [$partial] = $this->pickupStore('Partial', [['price' => 1700, 'qty' => '6']], 500);
        [$full] = $this->pickupStore('Full', [['price' => 1900, 'qty' => '40']], 1000);
        [$similar, , $similarListing] = $this->pickupStore('Similar', [['price' => 1200, 'qty' => '40']], 2000);
        [$exact, , $exactListing] = $this->pickupStore('Exact', [['price' => 1600, 'qty' => '40']], 3000);
        [$tiny] = $this->pickupStore('Tiny', [['price' => 1500, 'qty' => '3']], 4000);
        DB::table('store_profiles')->whereIn('vendor_organization_id', [$partial->id, $full->id])->update(['bulk_capability' => true]);
        // The similar store's product has a different thickness than the 100 mm the package states.
        DB::table('vendor_listings')->where('id', $similarListing)->update(['technical_attributes' => json_encode(['thickness_mm' => '150'])]);
        $this->buyer();
        [$w] = $this->package();
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $lines = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->orderBy('line_number')->pluck('id')->all();
        $card = static fn (array $items, string $vendor): array => collect($items)->firstWhere('vendor_id', $vendor);
        $items = $this->getJson($url.'/estimates')->assertOk()->json('data.items');

        // The Vendor with 6 of 10 is partial, not "missing": 4 remain. The unlisted line is unfulfilled for everyone.
        $f = $card($items, $partial->id)['fulfillment'];
        self::assertSame(['PARTIAL', 2, 0, 1, 1], [$f['status'], $f['lines_total'], $f['lines_fulfilled'], $f['lines_partial'], $f['lines_unfulfilled']]);
        self::assertSame(['PARTIAL', '6.0000', '4.0000'], [$f['lines'][0]['status'], $f['lines'][0]['vendor_quantity'], $f['lines'][0]['remaining_quantity']]);
        self::assertSame('UNFULFILLED', $f['lines'][1]['status']);
        $g = $card($items, $full->id)['fulfillment'];
        self::assertSame([1, 0, 1], [$g['lines_fulfilled'], $g['lines_partial'], $g['lines_unfulfilled']]);
        // Nothing is complete (the unlisted line), so the Vendor supplying the larger share still ranks first.
        self::assertSame($full->id, $items[0]['vendor_id']);

        $candidate = $card($items, $partial->id)['id'];
        $preview = fn (): array => $this->postJson($url.'/candidates/'.$candidate.'/selection-preview', [])->assertOk()->json('data');
        self::assertSame($f, $preview()['fulfillment']);

        // The recommendation asks only for the 4 still needed and leaves the compared Vendor out.
        // A photographed offer carries its photo as {url, alt_text}, the shape the contract declares.
        $media = DB::table('listing_media')->where('vendor_listing_id', $exactListing)->pluck('file_id')->all();
        DB::table('files')->whereIn('id', $media)->update(['visibility' => 'PUBLIC', 'scan_state' => 'CLEAN', 'metadata' => json_encode(['public_url' => 'https://cdn.example.test/chb.jpg'])]);
        $offers = $this->getJson($url.'/lines/'.$lines[0].'/alternatives?candidate_id='.$candidate)->assertOk()->json('data');
        self::assertSame('4.0000', $offers['needed_quantity']);
        self::assertSame(['url' => 'https://cdn.example.test/chb.jpg', 'alt_text' => 'Product photo'], collect($offers['items'])->firstWhere('vendor_id', $exact->id)['image']);
        self::assertNotContains($partial->id, array_column($offers['items'], 'vendor_id'));
        $byVendor = fn (string $vendor): array => collect($offers['items'])->firstWhere('vendor_id', $vendor);
        self::assertFalse($byVendor($similar->id)['exact_match']);
        self::assertTrue($byVendor($exact->id)['exact_match']);
        self::assertSame('PARTIAL', $byVendor($tiny->id)['availability']);
        self::assertSame(4 * 1600, $byVendor($exact->id)['estimated_total_centavos']);
        // Specification match ranks before the cheaper similar product; stock only as a label.
        self::assertLessThan(array_search($similar->id, array_column($offers['items'], 'vendor_id'), true), array_search($exact->id, array_column($offers['items'], 'vendor_id'), true));
        self::assertArrayNotHasKey('available', $byVendor($exact->id));

        $add = fn (array $item, string $quantity, array $extra = []) => $this->postJson('/api/v1/buyers/cart/items', ['listing_variant_id' => $item['variant_id'], 'expected_price_version_id' => $item['price_version_id'],
            'quantity' => $quantity, 'work_package_line_id' => $lines[0]] + $extra, $this->key());

        // A similar product is bought as a substitute: listed and priced, but the requirement stays open.
        $add($byVendor($similar->id), '4')->assertOk();
        $f = $preview()['fulfillment'];
        self::assertSame(['PARTIAL', '0.0000', '4.0000', '4.0000'], [$f['lines'][0]['status'], $f['lines'][0]['separate_quantity'], $f['lines'][0]['substitute_quantity'], $f['lines'][0]['remaining_quantity']]);
        self::assertSame(4 * 1200, $f['separate_total_centavos']);

        // The exact product closes it; adding it again or asking for more than the package needs never doubles or oversizes it.
        $add($byVendor($exact->id), '4')->assertOk();
        $add($byVendor($exact->id), '4')->assertOk();
        self::assertSame('4.0000', DB::table('cart_items')->where('listing_variant_id', $byVendor($exact->id)['variant_id'])->value('quantity'));
        $add($byVendor($exact->id), '11')->assertUnprocessable()->assertJsonPath('errors.0.code', 'TAGGED_QUANTITY_EXCEEDS_REQUIREMENT');
        $after = $preview();
        $f = $after['fulfillment'];
        self::assertSame(['PARTIAL', 1, 0, 1, 'FULFILLED', '4.0000', '0.0000'], [$f['status'], $f['lines_fulfilled'], $f['lines_partial'], $f['lines_unfulfilled'], $f['lines'][0]['status'], $f['lines'][0]['separate_quantity'], $f['lines'][0]['remaining_quantity']]);
        self::assertSame(2, count($f['separate_items']));
        self::assertSame(4 * 1200 + 4 * 1600, $f['separate_total_centavos']);
        self::assertSame($after['materials_centavos'] + $f['separate_total_centavos'], $f['combined_total_centavos']);
        self::assertSame('COVERED', $this->getJson($url.'/lines/'.$lines[0].'/alternatives?candidate_id='.$candidate)->assertOk()->json('data.status'));
        self::assertTrue(collect($this->getJson($url.'/lines/'.$lines[0].'/alternatives')->assertOk()->json('data.items'))->firstWhere('vendor_id', $exact->id)['already_added']);
        // The Vendor's own quotation figures did not move: completeness for ranking stays the Vendor's alone.
        self::assertFalse($after['complete']);
        self::assertSame(['Hollow blocks', 'River sand'], array_column($after['missing_lines'], 'name'));
        // Nothing was ordered or charged by adding to the cart.
        self::assertSame(0, DB::table('orders')->count());
    }

    public function test_a_line_with_no_suitable_alternative_says_so_and_a_partial_store_is_added_for_what_it_holds(): void
    {
        [$partial] = $this->pickupStore('Partial', [['price' => 1700, 'qty' => '6']], 500);
        [$tiny] = $this->pickupStore('Tiny', [['price' => 1500, 'qty' => '3']], 4000);
        DB::table('store_profiles')->where('vendor_organization_id', $partial->id)->update(['bulk_capability' => true]);
        $this->buyer();
        [$w] = $this->package();
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $lines = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->orderBy('line_number')->pluck('id')->all();
        $candidate = $this->getJson($url.'/estimates')->assertOk()->json('data.items.0.id');

        $offers = $this->getJson($url.'/lines/'.$lines[0].'/alternatives?candidate_id='.$candidate)->assertOk()->json('data');
        self::assertSame('PARTIAL', $offers['items'][0]['availability']);
        $item = $offers['items'][0];
        $body = ['listing_variant_id' => $item['variant_id'], 'expected_price_version_id' => $item['price_version_id'], 'quantity' => '4', 'work_package_line_id' => $lines[0]];
        $this->postJson('/api/v1/buyers/cart/items', $body, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'QUANTITY_UNAVAILABLE');
        $this->postJson('/api/v1/buyers/cart/items', $body + ['allow_partial_stock' => true], $this->key())->assertOk();
        self::assertSame('3.0000', DB::table('cart_items')->where('listing_variant_id', $item['variant_id'])->value('quantity'));
        $f = $this->postJson($url.'/candidates/'.$candidate.'/selection-preview', [])->assertOk()->json('data.fulfillment');
        self::assertSame(['PARTIAL', '3.0000', '1.0000'], [$f['lines'][0]['status'], $f['lines'][0]['separate_quantity'], $f['lines'][0]['remaining_quantity']]);

        // With the only other store used up and removed from range, the remaining 1 has no suitable source: a specific answer, not an error.
        DB::table('store_profiles')->where('vendor_organization_id', $tiny->id)->update(['vacation_mode' => true]);
        $none = $this->getJson($url.'/lines/'.$lines[0].'/alternatives?candidate_id='.$candidate)->assertOk()->json('data');
        self::assertSame(['NO_SUITABLE_ALTERNATIVE', '1.0000', 50, []], [$none['status'], $none['needed_quantity'], $none['radius_km'], $none['items']]);
    }
}
