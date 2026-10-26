<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\QuantityPolicy;
use App\Domain\Finance\Money;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryLedgerWriter;
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

final class ProductQuantityPolicyTest extends TestCase
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

    public function test_migration_keeps_gallon_cans_and_adds_a_distinct_measured_unit(): void
    {
        $before = (array) DB::table('units')->where('code', 'GAL')->first();
        $migration = require database_path('migrations/2026_10_26_000000_add_measured_us_gallon_unit.php');
        $migration->up();
        self::assertSame($before, (array) DB::table('units')->where('code', 'GAL')->first());
        self::assertSame(1, DB::table('units')->where('code', 'US_GAL')->count());
        self::assertTrue(QuantityPolicy::forUnit((string) DB::table('units')->where('code', 'US_GAL')->value('id'))->valid('1.5'));
        self::assertFalse(QuantityPolicy::forUnit($before['id'])->valid('1.5'));
    }

    public function test_fractional_stock_is_rejected_for_pieces_and_selling_unit_changes_require_a_replacement(): void
    {
        [, $owner, $listing] = $this->pickupStore('Counted products');
        $this->signInStoreMember($owner);
        $row = $this->getJson('/api/v1/vendor/inventory/items')->assertOk()->json('data.0');
        $this->patchJson('/api/v1/vendor/inventory/items/'.$row['listing_variant_id'], ['lock_version' => $row['lock_version'], 'quantity_on_hand' => '2.5', 'reason_code' => 'COUNT'])->assertUnprocessable();
        $catalog = $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertOk()->json('data');
        $v = $catalog['variants'][0];
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $catalog['lock_version'], 'variants' => [[
            'id' => $v['id'], 'sku' => $v['sku'], 'unit_id' => DB::table('units')->where('code', 'KG')->value('id'), 'pack_quantity' => '1', 'price_centavos' => 1800, 'tax_category' => 'NON_VAT',
        ]]])->assertUnprocessable();
        self::assertSame('20.0000', DB::table('inventory_items')->where('listing_variant_id', $v['id'])->value('quantity_on_hand'));
    }

    public function test_decimal_stock_lifecycle_is_exact_and_retries_do_not_duplicate_deductions(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Measured products', [['price' => 1801, 'qty' => '20']]);
        $variant = $this->variantIds($listing)[0];
        // Fixture describes a new measured variant before any transaction exists.
        DB::table('listing_variants')->where('id', $variant)->update(['unit_id' => DB::table('units')->where('code', 'L')->value('id')]);
        $this->buyer();
        $this->addToCart($listing, '1.125');
        $expected = Money::lineAmount('1.125', 1801);
        $this->getJson('/api/v1/buyers/cart')->assertOk()->assertJsonPath('data.groups.0.lines.0.line_total_centavos', $expected);
        $orderId = (string) $this->submitCheckout([$store->id])->assertCreated()->json('data.orders.0.id');
        self::assertSame($expected, (int) DB::table('orders')->where('id', $orderId)->value('materials_centavos'));
        $line = DB::table('order_lines')->where('order_id', $orderId)->first();
        self::assertSame('1.1250', $line->quantity);
        self::assertSame('MEASURED', json_decode($line->snapshot, true)['quantity_policy']['mode']);
        $originalSnapshot = $line->snapshot;
        $writer = app(InventoryLedgerWriter::class);
        $item = DB::table('inventory_items')->where('listing_variant_id', $variant)->first();
        DB::transaction(function () use ($writer, $item, $orderId, $line, $owner, $variant): void {
            $writer->reserve($item, '0.500', $owner->id, $orderId, $line->id);
            $writer->reserve($item, '0.500', $owner->id, $orderId, $line->id);
            self::assertSame('0.5000', DB::table('inventory_items')->where('id', $item->id)->value('hard_reserved_quantity'));
            try {
                $writer->recordCount($owner->id, $variant, '0.499', 'COUNT', null, 'TEST');
                self::fail('A physical adjustment cannot consume reserved stock.');
            } catch (AuthenticationException $e) {
                self::assertSame('STOCK_BELOW_RESERVED', $e->errorCode);
            }
            self::assertSame('0.5000', $writer->releaseOrder($orderId, 'TEST', $owner->id)[$variant]);
            self::assertSame([], $writer->releaseOrder($orderId, 'TEST', $owner->id));
            self::assertSame([], $writer->fulfillOrder($orderId, $owner->id));
        });
        [, $nextOrder] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '0.5']]);
        $nextLine = DB::table('order_lines')->where('order_id', $nextOrder)->first();
        DB::transaction(function () use ($writer, $item, $nextOrder, $nextLine, $owner, $variant): void {
            $writer->reserve($item, '0.500', $owner->id, $nextOrder, $nextLine->id);
            self::assertSame('0.5000', $writer->fulfillOrder($nextOrder, $owner->id)[$variant]);
            self::assertSame([], $writer->fulfillOrder($nextOrder, $owner->id));
        });
        $after = DB::table('inventory_items')->where('id', $item->id)->first();
        self::assertSame('19.5000', $after->quantity_on_hand);
        self::assertSame('0.0000', $after->hard_reserved_quantity);
        self::assertSame($originalSnapshot, DB::table('order_lines')->where('id', $line->id)->value('snapshot'));
    }

    public function test_legacy_order_reads_use_recorded_units_and_changed_units_cannot_reserve_stock(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Legacy measured product');
        $variant = $this->variantIds($listing)[0];
        DB::table('listing_variants')->where('id', $variant)->update(['unit_id' => DB::table('units')->where('code', 'L')->value('id')]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1.125']]);
        $line = DB::table('order_lines')->where('order_id', $orderId)->first();
        $legacy = json_decode($line->snapshot, true);
        unset($legacy['quantity_policy']);
        $original = json_encode($legacy, JSON_THROW_ON_ERROR);
        // Insert a legacy fixture; never disable or bypass the append-only history triggers.
        $sourceOrder = $orderId;
        $sourceLine = (string) $line->id;
        $order = (array) DB::table('orders')->where('id', $sourceOrder)->first();
        $orderId = $order['id'] = (string) Str::uuid7();
        $order['reference'] = 'ORD-LEGACY-'.Str::upper(Str::random(12));
        $order['checkout_group_id'] = null;
        DB::table('orders')->insert($order);
        $legacyLine = array_replace((array) $line, ['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'snapshot' => $original]);
        DB::table('order_lines')->insert($legacyLine);
        $line = (object) $legacyLine;
        foreach (DB::table('order_snapshots')->where('order_id', $sourceOrder)->get() as $version) {
            $version = (array) $version;
            $version['id'] = (string) Str::uuid7();
            $version['order_id'] = $orderId;
            $version['snapshot'] = str_replace([$sourceOrder, $sourceLine], [$orderId, $line->id], $version['snapshot']);
            DB::table('order_snapshots')->insert($version);
        }
        // Simulate a unit mutation made by an older catalog writer, now prohibited.
        DB::table('listing_variants')->where('id', $variant)->update(['unit_id' => DB::table('units')->where('code', 'GAL')->value('id')]);
        $detail = $this->buyerOrder($buyer, $orderId);
        self::assertSame('L', $detail['lines'][0]['unit_code']);
        self::assertSame(3, $detail['lines'][0]['quantity_policy']['precision']);
        self::assertSame('1.1250', $detail['lines'][0]['requested_quantity']);
        self::assertEquals($legacy, json_decode((string) DB::table('order_lines')->where('id', $line->id)->value('snapshot'), true));
        $item = DB::table('inventory_items')->where('listing_variant_id', $variant)->first();
        try {
            DB::transaction(fn () => app(InventoryLedgerWriter::class)->reserve($item, '1.125', $owner->id, $orderId, $line->id));
            self::fail('A changed selling unit cannot reinterpret historical quantities.');
        } catch (AuthenticationException $e) {
            self::assertSame('QUANTITY_INVALID', $e->errorCode);
        }
        self::assertSame('0.0000', DB::table('inventory_items')->where('id', $item->id)->value('hard_reserved_quantity'));
    }

    public function test_checkout_revalidates_a_legacy_cart_quantity_without_rounding_it(): void
    {
        [$store, , $listing] = $this->pickupStore('Legacy counted cart');
        $this->buyer();
        $this->addToCart($listing, '1');
        $variant = $this->variantIds($listing)[0];
        DB::table('cart_items')->where('listing_variant_id', $variant)->update(['quantity' => '1.5']);
        $this->submitCheckout([$store->id])->assertUnprocessable()->assertJsonPath('errors.0.code', 'QUANTITY_INVALID');
        self::assertSame('1.5000', DB::table('cart_items')->where('listing_variant_id', $variant)->value('quantity'));
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame('0.0000', DB::table('inventory_items')->where('listing_variant_id', $variant)->value('hard_reserved_quantity'));
    }
}
