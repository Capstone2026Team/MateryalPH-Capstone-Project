<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
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

/** Owner decisions 2026-10-12: allocation ceiling, unlisted materials, catalog details and the advisory estimate. */
final class WorkPackageAuthoringTest extends TestCase
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

    private function project(int $budget = 1000000): array
    {
        $site = $this->savedLocation(auth('api')->user(), 'Project site', 0, 0, 'PROJECT_SITE');

        return $this->postJson('/api/v1/buyers/projects', ['name' => 'House', 'budget_centavos' => $budget, 'starts_on' => now()->toDateString(),
            'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], $this->key())->assertCreated()->json('data');
    }

    private function catalogLine(string $quantity = '10', array $specifications = ['thickness_mm' => '100']): array
    {
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();

        return ['material_id' => $m->id, 'unit_id' => $m->canonical_unit_id, 'quantity' => $quantity, 'name' => 'Hollow blocks', 'specifications' => $specifications, 'preferred_brand' => null];
    }

    private function unlistedLine(): array
    {
        // Generated clients omit a null material_id; absence means unlisted.
        return ['unit_id' => DB::table('units')->where('code', 'CUM')->value('id'), 'quantity' => '2.5', 'name' => 'Washed river sand S-1',
            'description' => 'For plastering', 'color' => 'Grey', 'specifications' => ['size' => 'S-1'], 'preferred_brand' => null];
    }

    private function input(array $project, int $budget, ?array $lines = null): array
    {
        return ['name' => 'Masonry', 'budget_centavos' => $budget, 'site_id' => $project['sites'][0]['id'], 'radius_km' => 50, 'fulfillment_method' => 'PICKUP',
            'payment_method' => 'ONLINE', 'lines' => $lines ?? [$this->catalogLine()]];
    }

    public function test_work_package_budgets_are_deducted_from_the_project_budget_and_never_exceed_it(): void
    {
        $this->buyer();
        $p = $this->project(1000000);
        $first = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 600000), $this->key())->assertCreated()->json('data');
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.budget.allocated_centavos', 600000)->assertJsonPath('data.budget.unallocated_centavos', 400000);

        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 400001), $this->key())->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT');
        self::assertSame(1, DB::table('work_packages')->count());
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 400000), $this->key())->assertCreated();

        // A package's own budget is replaced, not counted twice, when it is edited.
        $first = $this->putJson('/api/v1/buyers/work-packages/'.$first['id'], $this->input($p, 600000) + ['lock_version' => $first['lock_version']], $this->key())->assertOk()->json('data');
        $this->patchJson('/api/v1/buyers/projects/'.$p['id'], ['lock_version' => $p['lock_version'], 'budget_centavos' => 999999], $this->key())->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'PROJECT_BUDGET_BELOW_ALLOCATED');

        // Cancelling releases the allocation.
        $this->postJson('/api/v1/buyers/work-packages/'.$first['id'].'/close', ['lock_version' => $first['lock_version']])->assertOk();
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.budget.allocated_centavos', 400000)->assertJsonPath('data.budget.unallocated_centavos', 600000);
    }

    public function test_unlisted_materials_keep_their_own_name_and_unit_and_are_always_missing_lines(): void
    {
        [$vendor] = $this->pickupStore('Blocks only');
        DB::table('store_profiles')->where('vendor_organization_id', $vendor->id)->update(['bulk_capability' => true]);
        $this->buyer();
        $p = $this->project();
        $catalog = $this->catalogLine();
        $incompatible = array_replace($catalog, ['unit_id' => DB::table('units')->where('code', 'CUM')->value('id')]);
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 500000, [$incompatible]), $this->key())->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'INVALID_MATERIAL_LINE');
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 500000, [array_replace($this->unlistedLine(), ['name' => ''])]), $this->key())->assertUnprocessable();

        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 500000, [$catalog, $this->unlistedLine()]), $this->key())->assertCreated()->json('data');
        self::assertTrue(array_is_list($w['version']['content']['lines']));
        self::assertSame('UNLISTED', $w['version']['content']['lines'][1]['material_kind']);
        self::assertSame('For plastering', $w['version']['content']['lines'][1]['description']);
        $row = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->where('line_number', 2)->first();
        self::assertNull($row->material_id);
        self::assertSame(['UNLISTED', 'Grey'], [$row->material_kind, $row->color]);
        $this->expectsDatabaseCheck(fn () => DB::table('work_package_lines')->where('id', $row->id)->update(['material_kind' => 'CATALOG']));

        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $scan = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk()->json('data');
        self::assertFalse($scan['items'][0]['complete']);
        self::assertSame([['Washed river sand S-1', 'UNLISTED_MATERIAL']], array_map(static fn (array $m): array => [$m['name'], $m['reason']], $scan['items'][0]['missing_lines']));
    }

    public function test_material_search_returns_match_type_category_details_and_every_unit(): void
    {
        $this->buyer();
        $data = $this->getJson('/api/v1/buyers/project-materials?query=deformed%20steel%20bar')->assertOk()->json('data');
        self::assertSame('EXACT', $data['items'][0]['match_type']);
        self::assertTrue($data['items'][0]['regulated']);
        self::assertSame(['grade', 'diameter_mm', 'length_m'], array_column($data['items'][0]['attributes'], 'code'));
        self::assertContains('Grade 280', $data['items'][0]['attributes'][0]['allowed_values']);
        self::assertSame(DB::table('units')->count(), count($data['units']));
    }

    public function test_budget_estimate_averages_one_lowest_price_per_vendor_within_the_radius(): void
    {
        foreach ([['Near A', 1800, 500], ['Near B', 2001, 1000], ['Far C', 1000, 60000]] as [$name, $price, $meters]) {
            [$vendor] = $this->pickupStore($name, [['price' => $price, 'qty' => '20']], $meters);
            DB::table('store_profiles')->where('vendor_organization_id', $vendor->id)->update(['bulk_capability' => true]);
        }
        $buyer = $this->buyer();
        $p = $this->project();
        $body = ['site_id' => $p['sites'][0]['id'], 'radius_km' => 50, 'fulfillment_method' => 'PICKUP',
            'lines' => [$this->catalogLine('10'), $this->unlistedLine(), $this->catalogLine('10', ['thickness_mm' => '150'])]];
        $estimate = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-package-estimate', $body)->assertOk()->json('data');
        // (1800 + 2001) / 2 = 1900.5 rounds half-up to 1901; 10 x 1901 = 19010. The far store is outside the fixed 50 km Project-Based radius.
        self::assertSame(['PRICED', 1901, 19010, 2], [$estimate['lines'][0]['status'], $estimate['lines'][0]['average_unit_price_centavos'], $estimate['lines'][0]['amount_centavos'], $estimate['lines'][0]['vendor_count']]);
        self::assertSame(['UNLISTED', null], [$estimate['lines'][1]['status'], $estimate['lines'][1]['amount_centavos']]);
        self::assertSame('NO_PRICE_DATA', $estimate['lines'][2]['status']);
        self::assertSame([19010, 1, 2], [$estimate['materials_total_centavos'], $estimate['priced_line_count'], $estimate['unpriced_line_count']]);
        self::assertSame(['DELIVERY_FEE', 'LABOR'], $estimate['excludes']);
        // 50 km is the only Project-Based radius: another value is refused, never applied.
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-package-estimate', ['radius_km' => 10] + $body)->assertUnprocessable();
        self::assertSame(0, DB::table('compiled_estimates')->count());

        $this->buyer();
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-package-estimate', $body)->assertNotFound();
        $this->signInBuyer($buyer);
    }

    public function test_editing_changes_the_package_in_place_without_adding_list_entries_or_exposing_versions(): void
    {
        $this->buyer();
        $p = $this->project();
        $input = $this->input($p, 500000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];

        // A Draft owns one copy, so saving it again overwrites that copy.
        $w = $this->putJson($url, array_replace($input, ['name' => 'Masonry v2', 'lock_version' => $w['lock_version']]), $this->key())->assertOk()
            ->assertJsonPath('data.name', 'Masonry v2')->assertJsonPath('data.status', 'DRAFT')->assertJsonMissingPath('data.versions')->json('data');
        self::assertSame(1, DB::table('work_package_versions')->where('work_package_id', $w['id'])->count());

        $w = $this->postJson($url.'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $estimate = $this->postJson($url.'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk()->json('data.estimate.id');
        $locked = DB::table('work_package_versions')->where('id', $w['current_version_id'])->first();
        $w = $this->getJson($url)->assertOk()->json('data');

        $key = $this->key();
        $edited = $this->putJson($url, array_replace($input, ['name' => 'Masonry final', 'budget_centavos' => 450000, 'lock_version' => $w['lock_version']]), $key)->assertOk()
            ->assertJsonPath('data.id', $w['id'])->assertJsonPath('data.name', 'Masonry final')->assertJsonPath('data.budget_centavos', 450000)
            ->assertJsonPath('data.status', 'ACTIVE')->assertJsonPath('data.version.content.name', 'Masonry final')->json('data');
        self::assertNotNull($edited['version']['locked_at']);
        self::assertSame('INVALIDATED', DB::table('compiled_estimates')->where('id', $estimate)->value('state'));
        self::assertSame(1, DB::table('work_packages')->where('project_id', $p['id'])->count());
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonCount(1, 'data.packages.items')->assertJsonPath('data.budget.allocated_centavos', 450000);
        // The earlier saved contents are kept only as an internal record; the database still protects them.
        self::assertEquals($locked, DB::table('work_package_versions')->where('id', $locked->id)->first());
        $this->assertDatabaseHas('audit_logs', ['action' => 'WORK_PACKAGE_EDITED', 'resource_id' => $w['id']]);
        // Replaying the same request changes nothing further.
        $this->putJson($url, array_replace($input, ['name' => 'Masonry final', 'budget_centavos' => 450000, 'lock_version' => $w['lock_version']]), $key)->assertOk()->assertJsonPath('data.lock_version', $edited['lock_version']);
        self::assertSame(2, DB::table('work_package_versions')->where('work_package_id', $w['id'])->count());
    }

    public function test_a_cancelled_package_can_be_edited_and_reactivated_in_place(): void
    {
        $this->buyer();
        $p = $this->project(1000000);
        $input = $this->input($p, 100000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $w = $this->postJson($url.'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_NOT_CANCELLED');
        $w = $this->postJson($url.'/close', ['lock_version' => $w['lock_version']])->assertOk()->assertJsonPath('data.status', 'CANCELLED')->json('data');
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.budget.allocated_centavos', 0);

        // Editing a cancelled package keeps it cancelled and does not take budget back.
        $w = $this->putJson($url, array_replace($input, ['name' => 'Revised masonry', 'lock_version' => $w['lock_version']]), $this->key())->assertOk()
            ->assertJsonPath('data.status', 'CANCELLED')->assertJsonPath('data.name', 'Revised masonry')->json('data');
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.budget.allocated_centavos', 0);

        $key = $this->key();
        $active = $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $key)->assertOk()->assertJsonPath('data.status', 'ACTIVE')
            ->assertJsonPath('data.name', 'Revised masonry')->json('data');
        self::assertNotNull($active['version']['locked_at']);
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonCount(1, 'data.packages.items')->assertJsonPath('data.budget.allocated_centavos', 100000);
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $key)->assertOk()->assertJsonPath('data.lock_version', $active['lock_version']);
        $this->assertDatabaseHas('audit_logs', ['action' => 'WORK_PACKAGE_REACTIVATED', 'resource_id' => $w['id']]);
    }

    public function test_reactivation_revalidates_the_project_budget_and_changes_nothing_when_it_fails(): void
    {
        $this->buyer();
        $p = $this->project();
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 500000), $this->key())->assertCreated()->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $w = $this->postJson($url.'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $w = $this->postJson($url.'/close', ['lock_version' => $w['lock_version']])->assertOk()->json('data');
        $this->patchJson('/api/v1/buyers/projects/'.$p['id'], ['lock_version' => $p['lock_version'], 'budget_centavos' => 100000], $this->key())->assertOk();
        $key = $this->key();
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $key)->assertUnprocessable()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT');
        $this->getJson($url)->assertOk()->assertJsonPath('data.status', 'CANCELLED')->assertJsonPath('data.lock_version', $w['lock_version']);
        self::assertFalse(DB::table('idempotency_records')->where('idempotency_key', $key['Idempotency-Key'])->exists());
    }

    public function test_edit_and_reactivate_require_ownership_current_lock_active_project_and_no_order(): void
    {
        [$vendor] = $this->pickupStore('Edit test');
        $owner = $this->buyer();
        $p = $this->project();
        $input = $this->input($p, 500000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $edit = fn (array $body, array $headers) => $this->putJson($url, array_replace($input, $body), $headers);
        $this->buyer();
        $edit(['lock_version' => $w['lock_version']], $this->key())->assertNotFound();
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $this->key())->assertNotFound();
        $this->signInBuyer($owner);
        $edit(['lock_version' => $w['lock_version'] + 1], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_VERSION_CONFLICT');
        $edit([], $this->key())->assertUnprocessable();
        $edit(['lock_version' => $w['lock_version']], ['Idempotency-Key' => ''])->assertUnprocessable();
        // The version endpoints no longer exist.
        $this->postJson($url.'/versions', $input + ['lock_version' => $w['lock_version']], $this->key())->assertNotFound();
        $this->deleteJson($url.'/versions/'.$w['current_version_id'], ['lock_version' => $w['lock_version']], $this->key())->assertNotFound();

        DB::table('work_packages')->where('id', $w['id'])->update(['selected_vendor_organization_id' => $vendor->id]);
        $edit(['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_HAS_ORDER');
        DB::table('work_packages')->where('id', $w['id'])->update(['status' => 'CANCELLED']);
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_HAS_ORDER');

        DB::table('work_packages')->where('id', $w['id'])->update(['selected_vendor_organization_id' => null]);
        DB::table('projects')->where('id', $p['id'])->update(['status' => 'ARCHIVED']);
        $edit(['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_CLOSED');
        $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_CLOSED');
    }

    public function test_deleting_a_package_that_was_edited_after_activation_hides_it_and_keeps_its_saved_contents(): void
    {
        $this->buyer();
        $p = $this->project(1000000);
        $input = $this->input($p, 100000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->assertJsonPath('data.can_delete', true)->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $w = $this->postJson($url.'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $w = $this->putJson($url, array_replace($input, ['name' => 'Edited', 'lock_version' => $w['lock_version']]), $this->key())->assertOk()->json('data');
        $this->deleteJson($url, ['lock_version' => $w['lock_version']])->assertOk();
        $row = DB::table('work_packages')->where('id', $w['id'])->first();
        self::assertNotNull($row->deleted_at);
        self::assertSame('CANCELLED', $row->status);
        self::assertSame(2, DB::table('work_package_versions')->where('work_package_id', $w['id'])->count());
        $this->getJson($url)->assertNotFound();
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonCount(0, 'data.packages.items')->assertJsonPath('data.budget.allocated_centavos', 0);
    }

    public function test_a_package_with_no_order_can_be_deleted_even_after_activation_and_keeps_its_locked_records(): void
    {
        [$vendor] = $this->pickupStore('Blocks only');
        DB::table('store_profiles')->where('vendor_organization_id', $vendor->id)->update(['bulk_capability' => true]);
        $this->buyer();
        $p = $this->project(1000000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 300000), $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->assertJsonPath('data.can_delete', true)->assertJsonPath('data.has_order', false)->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertOk();
        $w = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data');

        $this->deleteJson('/api/v1/buyers/work-packages/'.$w['id'], ['lock_version' => $w['lock_version']])->assertOk();

        $row = DB::table('work_packages')->where('id', $w['id'])->first();
        self::assertNotNull($row->deleted_at);
        self::assertSame('CANCELLED', $row->status);
        self::assertTrue(DB::table('work_package_versions')->where('work_package_id', $w['id'])->whereNotNull('locked_at')->exists());
        self::assertSame(0, DB::table('compiled_estimates')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $w['id']))->whereNull('invalidated_at')->count());
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertNotFound();
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $row->lock_version], $this->key())->assertNotFound();
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonCount(0, 'data.packages.items')->assertJsonPath('data.budget.unallocated_centavos', 1000000);
    }

    public function test_a_declined_order_does_not_lock_the_package_but_an_open_order_does(): void
    {
        [$vendor] = $this->pickupStore('Declined supplier');
        $buyer = $this->buyer();
        $p = $this->project();
        $input = $this->input($p, 100000);
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertCreated()->json('data');
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $w = $this->postJson($url.'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $orderId = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $orderId, 'reference' => 'WP-'.Str::upper(Str::random(8)), 'buyer_profile_id' => DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'),
            'vendor_organization_id' => $vendor->id, 'procurement_type' => 'PROJECT_BASED', 'order_state' => 'DECLINED', 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE',
            'materials_centavos' => 100000, 'commercial_total_centavos' => 100000, 'work_package_id' => $w['id'], 'work_package_version_id' => $w['current_version_id'],
            'created_at' => now(), 'updated_at' => now()]);

        // A declined order is closed, so the package stays fully manageable.
        $w = $this->getJson($url)->assertOk()->assertJsonPath('data.has_order', false)->assertJsonPath('data.can_delete', true)->json('data');
        $w = $this->putJson($url, array_replace($input, ['name' => 'Retry masonry', 'lock_version' => $w['lock_version']]), $this->key())->assertOk()->json('data');
        $w = $this->postJson($url.'/close', ['lock_version' => $w['lock_version']])->assertOk()->json('data');
        $w = $this->postJson($url.'/reactivate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->assertJsonPath('data.status', 'ACTIVE')->json('data');

        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'CONFIRMED']);
        $this->getJson($url)->assertOk()->assertJsonPath('data.has_order', true)->assertJsonPath('data.can_delete', false);
        $this->deleteJson($url, ['lock_version' => $w['lock_version']])->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_HAS_ORDER');
        $this->putJson($url, array_replace($input, ['lock_version' => $w['lock_version']]), $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_HAS_ORDER');
    }

    public function test_a_package_with_an_order_or_selected_vendor_cannot_be_deleted(): void
    {
        [$vendor] = $this->pickupStore('Blocks only');
        $this->buyer();
        $p = $this->project();
        $w = $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $this->input($p, 100000), $this->key())->assertCreated()->json('data');
        DB::table('work_packages')->where('id', $w['id'])->update(['selected_vendor_organization_id' => $vendor->id]);

        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.has_order', true)->assertJsonPath('data.can_delete', false);
        $this->deleteJson('/api/v1/buyers/work-packages/'.$w['id'], ['lock_version' => $w['lock_version']])->assertConflict()->assertJsonPath('errors.0.code', 'WORK_PACKAGE_HAS_ORDER');
        self::assertNull(DB::table('work_packages')->where('id', $w['id'])->value('deleted_at'));
    }

    private function expectsDatabaseCheck(callable $write): void
    {
        try {
            DB::transaction($write);
            self::fail('The material kind check must reject a catalog line without a material.');
        } catch (QueryException $e) {
            self::assertStringContainsString('work_package_lines_material_kind_check', $e->getMessage());
        }
    }
}
