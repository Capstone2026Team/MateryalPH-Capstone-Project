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

final class CheckoutOptionsTest extends TestCase
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

    private function input(string $site, int $budget = 1000000, string $quantity = '10'): array
    {
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();

        return ['name' => 'Foundation', 'budget_centavos' => $budget, 'site_id' => $site, 'radius_km' => 5, 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE',
            'lines' => [['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => $quantity, 'name' => 'Hollow blocks', 'specifications' => ['thickness_mm' => '100'], 'preferred_brand' => 'BrandCo']]];
    }

    private function package(int $budget = 1000000, string $quantity = '10', ?array $extra = null): array
    {
        $buyer = auth('api')->user();
        $site = $this->savedLocation($buyer, 'Project site', 0, 0, 'PROJECT_SITE');
        $p = $this->postJson('/api/v1/buyers/projects', ['name' => 'House construction', 'budget_centavos' => $budget, 'starts_on' => now()->toDateString(), 'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], $this->key())->assertCreated()->json('data');
        $input = array_replace($this->input($p['sites'][0]['id'], $budget, $quantity), $extra ?? []);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');

        return [$p, $w, $input, $site];
    }

    public function test_checkout_links_each_item_order_and_saves_private_invoice_details_atomically_and_replays(): void
    {
        [$one, , $listing] = $this->pickupStore('Linked one');
        [$two, , $listingTwo] = $this->pickupStore('Linked two');
        $buyer = $this->buyer();
        [$project, $package] = $this->package();
        $this->addToCart($listing, '2');
        $this->addToCart($listingTwo, '3');
        $body = $this->body([$one->id, $two->id], $package) + ['invoice_details' => ['billing_name' => 'Test Buyer', 'billing_address' => 'Test street, Quezon City 1100', 'tin' => '123456789000']];
        $key = $this->key();
        $first = $this->postJson('/api/v1/buyers/checkouts', $body, $key)->assertCreated()->assertJsonCount(2, 'data.orders');
        $this->postJson('/api/v1/buyers/checkouts', $body, $key)->assertOk()->assertJsonPath('data.id', $first->json('data.id'))->assertJsonPath('meta.replayed', true);
        foreach ($first->json('data.orders') as $child) {
            $this->assertDatabaseHas('orders', ['id' => $child['id'], 'work_package_id' => $package['id'], 'work_package_version_id' => $package['current_version_id'], 'procurement_type' => 'ITEM_BASED']);
            $details = DB::table('order_invoice_details')->where('order_id', $child['id'])->first();
            self::assertSame('Test Buyer', $details->billing_name);
            self::assertSame('9000', $details->tin_last4);
            self::assertNotSame('123456789000', $details->tin_encrypted);
            $this->getJson('/api/v1/buyers/orders/'.$child['id'].'/invoices')->assertOk()->assertDontSee('123456789000');
        }
        self::assertSame(2, DB::table('order_invoice_details')->count());
        self::assertSame(0, DB::table('invoice_requests')->count(), 'Copy requests retain the confirmed-sale gate.');
        $body['invoice_details']['billing_name'] = 'Changed Buyer';
        $this->postJson('/api/v1/buyers/checkouts', $body, $key)->assertConflict()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        $this->getJson('/api/v1/buyers/projects/'.$project['id'])->assertOk()->assertJsonPath('data.budget.pending_confirmation_count', 2);
        $this->buyer();
        $this->getJson('/api/v1/buyers/orders/'.$first->json('data.orders.0.id').'/invoices')->assertNotFound();
    }

    public function test_foreign_stale_and_closed_project_links_leave_the_cart_and_orders_unchanged(): void
    {
        [$store, , $listing] = $this->pickupStore('Link guards');
        $owner = $this->buyer();
        [$project, $package] = $this->package();
        $other = $this->buyer();
        $this->addToCart($listing, '2');
        $this->postJson('/api/v1/buyers/checkouts', $this->body([$store->id], $package), $this->key())->assertNotFound()->assertJsonPath('errors.0.code', 'PROJECT_NOT_FOUND');
        $this->signInBuyer($owner);
        $this->addToCart($listing, '2');
        $body = $this->body([$store->id], $package);
        $body['work_package_lock_version']++;
        $this->postJson('/api/v1/buyers/checkouts', $body, $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_VERSION_CONFLICT');
        DB::table('projects')->where('id', $project['id'])->update(['status' => 'ARCHIVED']);
        $this->postJson('/api/v1/buyers/checkouts', $this->body([$store->id], $package), $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_CLOSED');
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame(0, DB::table('checkout_groups')->count());
        self::assertSame(2, DB::table('cart_items')->count());
    }

    public function test_budget_override_and_invalid_tin_roll_back_all_children_and_billing_details(): void
    {
        [$one, , $listing] = $this->pickupStore('Budget one');
        [$two, , $listingTwo] = $this->pickupStore('Budget two');
        $this->buyer();
        [$project, $package] = $this->package(5000);
        $this->addToCart($listing, '2');
        $this->addToCart($listingTwo, '2');
        $body = $this->body([$one->id, $two->id], $package) + ['invoice_details' => ['billing_name' => 'Test Buyer', 'billing_address' => 'Test street, Quezon City 1100', 'tin' => '12']];
        $this->postJson('/api/v1/buyers/checkouts', $body, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        $empty = $body;
        $empty['invoice_details'] = [];
        $this->postJson('/api/v1/buyers/checkouts', $empty, $this->key())->assertUnprocessable();
        $body['invoice_details']['tin'] = null;
        $this->postJson('/api/v1/buyers/checkouts', $body, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'BUDGET_OVERRIDE_REQUIRED');
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame(0, DB::table('order_invoice_details')->count());
        self::assertSame(2, DB::table('cart_items')->count());
        $body['budget_override_reason'] = 'Additional materials are required for the foundation.';
        $this->postJson('/api/v1/buyers/checkouts', $body, $this->key())->assertCreated();
        $this->assertDatabaseHas('budget_overrides', ['project_id' => $project['id'], 'work_package_id' => $package['id'], 'overage_centavos' => 2200]);
    }

    public function test_linked_auto_accept_and_manual_confirmation_recheck_the_budget_before_acceptance(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Linked acceptance');
        $variant = $this->variantIds($listing)[0];
        $this->enableAutoAccept($owner, $store->id, $variant, '20', null, null, 2);
        $buyer = $this->buyer();
        [$project, $package] = $this->package(5000);
        $this->addToCart($listing, '2');
        $first = $this->postJson('/api/v1/buyers/checkouts', $this->body([$store->id], $package), $this->key())->assertCreated()->json('data.orders.0.id');
        $this->assertDatabaseHas('orders', ['id' => $first, 'confirmation_source' => 'AUTO_ACCEPT', 'procurement_type' => 'ITEM_BASED']);
        $this->getJson('/api/v1/buyers/projects/'.$project['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 3600);
        self::assertNull($this->vendorOrder($owner, $first)['project_context'], 'An Item-Based Vendor does not receive the private Work Package.');
        $this->signInBuyer($buyer);
        $this->addToCart($listing, '2');
        $body = $this->body([$store->id], $package) + ['budget_override_reason' => 'Extra foundation materials approved by the Buyer.'];
        $second = $this->postJson('/api/v1/buyers/checkouts', $body, $this->key())->assertCreated()->json('data.orders.0.id');
        $this->assertDatabaseHas('orders', ['id' => $second, 'order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'accepted_at' => null]);
        self::assertSame('2.0000', $this->reserved($variant), 'The over-budget order did not consume stock or allotment.');
        $this->confirmOrder($owner, $second)->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_BUYER_APPROVAL');
        $detail = $this->buyerOrder($buyer, $second);
        $decision = ['snapshot_version' => $detail['commercial_version']['current']];
        $this->postJson('/api/v1/buyers/orders/'.$second.'/revision/approve', $decision, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'BUDGET_OVERRIDE_REQUIRED');
        $this->postJson('/api/v1/buyers/orders/'.$second.'/revision/approve', $decision + ['budget_override_reason' => 'Confirmed final additional materials and budget deficit.'], $this->key())->assertOk();
        $this->getJson('/api/v1/buyers/projects/'.$project['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 7200)->assertJsonPath('data.budget.remaining_centavos', -2200);
    }

    private function body(array $vendors, array $package): array
    {
        return ['cart_lock_version' => $this->getJson('/api/v1/buyers/cart')->assertOk()->json('data.lock_version'), 'vendor_ids' => $vendors,
            'work_package_id' => $package['id'], 'work_package_lock_version' => $package['lock_version']];
    }
}
