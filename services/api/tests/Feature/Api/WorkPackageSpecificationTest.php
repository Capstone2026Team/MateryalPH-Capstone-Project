<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/** Owner request 2026-10-16: stated details match product information, and open details become a Buyer choice. */
final class WorkPackageSpecificationTest extends TestCase
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

    /** A bulk store selling hollow blocks in two thicknesses, 40 of each. @return array{0: string, 1: list<string>} store id, variant ids */
    private function store(): array
    {
        [$store, $owner] = $this->activeStore('Spec store', false);
        $this->signInStoreMember($owner);
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Hollow block', 'vendor_sku' => 'CHB'], $this->key())->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => 'BrandCo', 'manufacturer' => 'Sample Block Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => []])->assertOk();
        $rows = [];
        foreach ([['100', 1500], ['150', 2200]] as $i => [$thickness, $price]) {
            $rows[] = ['sku' => 'CHB-'.$thickness, 'label' => $thickness.' mm', 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => '1', 'price_centavos' => $price, 'tax_category' => 'NON_VAT',
                'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => '40', 'attributes' => ['thickness_mm' => $thickness]];
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => $rows])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image('chb.png'), 'alt_text' => 'Product photo'])->assertCreated();
        $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], $this->key())->assertOk();
        $this->placeStore($store->id, 500);
        $this->connectOnlinePayments($store->id);
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['bulk_capability' => true]);

        return [$store->id, $this->variantIds($listing)];
    }

    /** @param array<string, string> $specifications
     * @return array<string, mixed> the activated, scanned package */
    private function package(array $specifications, string $quantity = '50'): array
    {
        $site = $this->savedLocation(auth('api')->user(), 'Project site', 0, 0, 'PROJECT_SITE');
        $p = $this->postJson('/api/v1/buyers/projects', ['name' => 'House', 'budget_centavos' => 10000000, 'starts_on' => now()->toDateString(),
            'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], $this->key())->assertCreated()->json('data');
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', ['name' => 'Masonry', 'budget_centavos' => 1000000, 'site_id' => $p['sites'][0]['id'], 'radius_km' => 50,
            'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'lines' => [
                ['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => $quantity, 'name' => 'Hollow blocks', 'specifications' => $specifications],
            ]], $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk();

        return $w;
    }

    public function test_open_details_become_a_buyer_choice_and_options_are_never_mixed(): void
    {
        [, $variants] = $this->store();
        $this->buyer();
        $w = $this->package([]);
        $base = '/api/v1/buyers/work-packages/'.$w['id'];
        $candidate = $this->getJson($base.'/estimates')->assertOk()->json('data.items.0');
        $line = $candidate['lines'][0];

        self::assertTrue($line['selection_required']);
        self::assertNull($line['selected_option_id']);
        self::assertCount(2, $line['options']);
        self::assertSame([[['code' => 'thickness_mm', 'label' => 'Thickness', 'value' => '100', 'unit_code' => 'mm']], 'PARTIAL'], [$line['options'][0]['specifications'], $line['options'][0]['availability']]);
        // 50 needed, 40 of each: one thickness is used as the basis; the other is never added to fill it.
        self::assertSame([$variants[0]], array_column($line['allocations'], 'variant_id'));
        self::assertSame('10.0000', $line['missing_quantity']);
        self::assertSame('Thickness', $line['allocations'][0]['offered_specifications'][0]['label']);

        $request = ['lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE'];
        $this->postJson($base.'/selection', $request, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'SPECIFICATION_SELECTION_REQUIRED');
        $this->postJson($base.'/inquiries', $request, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'SPECIFICATION_SELECTION_REQUIRED');
        $this->postJson($base.'/candidates/'.$candidate['id'].'/selection-preview', ['selections' => [['line_id' => $line['line_id'], 'option_id' => 'ffffffffffffffff']]])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'SPECIFICATION_OPTION_INVALID');

        $choice = ['selections' => [['line_id' => $line['line_id'], 'option_id' => $line['options'][1]['option_id']]]];
        $preview = $this->postJson($base.'/candidates/'.$candidate['id'].'/selection-preview', $choice)->assertOk()->json('data');
        self::assertSame([false, $line['options'][1]['option_id'], [$variants[1]]], [$preview['lines'][0]['selection_required'], $preview['lines'][0]['selected_option_id'], array_column($preview['lines'][0]['allocations'], 'variant_id')]);
        self::assertSame(40 * 2200, $preview['materials_centavos']);
        self::assertSame($candidate['id'], $preview['id']);
        // Previewing stores nothing.
        self::assertTrue($this->getJson($base.'/estimates')->json('data.items.0.lines.0.selection_required'));

        $order = $this->postJson($base.'/selection', $request + $choice, $this->key())->assertCreated()->json('data.id');
        self::assertSame([[$variants[1], '40.0000']], DB::table('order_lines')->where('order_id', $order)->get(['listing_variant_id', 'quantity'])->map(static fn (object $l): array => [(string) $l->listing_variant_id, (string) $l->quantity])->all());
        self::assertSame(40 * 2200, (int) DB::table('orders')->where('id', $order)->value('materials_centavos'));
    }

    public function test_stated_numbers_match_in_any_format_and_invalid_details_are_rejected(): void
    {
        [, $variants] = $this->store();
        $this->buyer();
        $w = $this->package(['thickness_mm' => '150.0'], '30');
        self::assertSame(['thickness_mm' => '150'], json_decode((string) DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->value('specifications'), true));
        $line = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates')->assertOk()->json('data.items.0.lines.0');
        self::assertSame([false, [], [$variants[1]], '0.0000'], [$line['selection_required'], $line['options'], array_column($line['allocations'], 'variant_id'), $line['missing_quantity']]);
        self::assertNotNull($line['selected_option_id']);

        $p = $this->getJson('/api/v1/buyers/projects')->assertOk()->json('data.items.0');
        $p = $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->json('data');
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        foreach ([['color_code' => 'red'], ['thickness_mm' => '150 mm'], ['thickness_mm' => '0']] as $specifications) {
            $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', ['name' => 'Walls', 'budget_centavos' => 1000, 'site_id' => $p['sites'][0]['id'], 'radius_km' => 50,
                'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'lines' => [['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => '5', 'name' => 'Blocks', 'specifications' => $specifications]]], $this->key())
                ->assertUnprocessable()->assertJsonPath('errors.0.code', 'INVALID_SPECIFICATION');
        }
    }

    public function test_material_search_lists_the_values_products_are_listed_with(): void
    {
        $this->store();
        $this->buyer();
        $attributes = collect($this->getJson('/api/v1/buyers/project-materials?query=hollow')->assertOk()->json('data.items'))->firstWhere('code', 'CONCRETE_HOLLOW_BLOCK')['attributes'];
        self::assertSame(['100', '150'], collect($attributes)->firstWhere('code', 'thickness_mm')['offered_values']);
    }
}
