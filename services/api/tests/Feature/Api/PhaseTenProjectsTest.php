<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Projects\ProjectBudget;
use App\Domain\Projects\ProjectEstimateService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class PhaseTenProjectsTest extends TestCase
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

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
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

    private function scan(array $w, int $radius = 5): array
    {
        return $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => $radius])->assertOk()->json('data');
    }

    private function bulk(string $vendor, bool $value = true): void
    {
        DB::table('store_profiles')->where('vendor_organization_id', $vendor)->update(['bulk_capability' => $value]);
    }

    private function inquiry(array $w, array $candidate): array
    {
        $id = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/inquiries', ['lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id']], $this->key())->assertCreated()->json('data.id');

        return [$id, $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data')];
    }

    private function publish(string $id, string $variant, string $qty = '10', ?array $delivery = null): array
    {
        $draft = ['lines' => [['variant_id' => $variant, 'quantity' => $qty, 'unit_price_centavos' => 1700, 'description' => 'Confirmed hollow blocks', 'specifications' => ['thickness_mm' => '100']]], 'fulfillment_method' => $delivery === null ? 'PICKUP' : 'DELIVERY', 'payment_method' => 'ONLINE', 'fulfillment_date' => now()->addDays(3)->toDateString()];
        if ($delivery !== null) {
            $draft['delivery'] = $delivery;
        }
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $draft])->assertOk();

        return $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => 2], $this->key())->assertOk()->json('data.versions.0');
    }

    public function test_archived_projects_retain_originals_and_expire_unassigned_inquiries_but_reject_new_work(): void
    {
        [$vendor] = $this->pickupStore('Archived supplier');
        $this->bulk($vendor->id);
        $this->buyer();
        [$p, $w, $input] = $this->package();
        $e = $this->scan($w);
        [$chat, $w] = $this->inquiry($w, $e['items'][0]);
        $this->patchJson('/api/v1/buyers/projects/'.$p['id'], ['lock_version' => $p['lock_version'], 'status' => 'ARCHIVED'], $this->key())->assertOk();
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.project_status', 'ARCHIVED')->assertJsonPath('data.version.content_hash', $w['version']['content_hash']);
        $this->getJson('/api/v1/buyers/conversations/'.$chat)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED');
        self::assertSame('INVALIDATED', DB::table('compiled_estimates')->where('id', $e['estimate']['id'])->value('state'));
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 5])->assertConflict();
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/versions', $input + ['lock_version' => $w['lock_version']], $this->key())->assertConflict();
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertConflict();
        $this->patchJson('/api/v1/buyers/projects/'.$p['id'], ['lock_version' => $p['lock_version'] + 1, 'status' => 'ACTIVE'], $this->key())->assertConflict();
    }

    public function test_versions_are_locked_explicit_corrections_expire_history_and_owner_scope_is_enforced(): void
    {
        [$vendor] = $this->pickupStore('Version supplier');
        $this->bulk($vendor->id);
        $buyer = $this->buyer();
        [$p,$w,$input] = $this->package();
        $e = $this->scan($w);
        [$chat,$w] = $this->inquiry($w, $e['items'][0]);
        $old = $w['version'];
        $this->putJson('/api/v1/buyers/work-packages/'.$w['id'], $input + ['lock_version' => $w['lock_version']], $this->key())->assertConflict();
        $next = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/versions', $input + ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        self::assertSame('DRAFT', $next['status']);
        self::assertSame(2, $next['version']['version']);
        self::assertNotSame($old['id'], $next['version']['id']);
        self::assertSame($old['content_hash'], DB::table('work_package_versions')->where('id', $old['id'])->value('content_hash'));
        self::assertSame('INVALIDATED', DB::table('compiled_estimates')->where('id', $e['estimate']['id'])->value('state'));
        $this->getJson('/api/v1/buyers/conversations/'.$chat)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED');
        $this->buyer();
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertNotFound();
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertNotFound();
        $this->signInBuyer($buyer);
    }

    public function test_complete_candidates_precede_partial_matches_missing_quantities_and_radius_are_exact(): void
    {
        [$partial] = $this->pickupStore('Partial near', [['price' => 1000, 'qty' => '3']], 500);
        $this->bulk($partial->id);
        [$complete] = $this->pickupStore('Complete boundary', [['price' => 2000, 'qty' => '20']], 5000);
        $this->bulk($complete->id);
        [$outside] = $this->pickupStore('Outside', [['price' => 1000, 'qty' => '20']], 5001);
        $this->bulk($outside->id);
        $this->buyer();
        [, $w] = $this->package();
        $e = $this->scan($w);
        self::assertCount(2, $e['items']);
        self::assertSame($complete->id, $e['items'][0]['vendor_id']);
        self::assertTrue($e['items'][0]['complete']);
        self::assertSame('7.0000', $e['items'][1]['missing_lines'][0]['quantity']);
        self::assertSame('New Vendor', $e['items'][1]['score_label']);
        self::assertSame(10, $e['suggested_radius_km']);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 6])->assertUnprocessable();
        self::assertCount(3, $this->scan($w, 10)['items']);
    }

    public function test_bulk_restriction_blocks_future_awards_but_keeps_estimate_and_locked_original(): void
    {
        [$v] = $this->pickupStore('Bulk changes');
        $this->bulk($v->id);
        $this->buyer();
        [, $w] = $this->package();
        $e = $this->scan($w);
        $original = $w['version']['content_hash'];
        $saved = DB::table('compiled_estimate_vendors')->where('id', $e['items'][0]['id'])->value('snapshot');
        $this->bulk($v->id, false);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id']], $this->key())->assertConflict();
        self::assertSame([], $this->scan($w)['items']);
        self::assertSame($saved, DB::table('compiled_estimate_vendors')->where('id', $e['items'][0]['id'])->value('snapshot'));
        self::assertSame($original, DB::table('work_package_versions')->where('id', $w['current_version_id'])->value('content_hash'));
    }

    public function test_estimates_expire_at_48_hours_schedule_edits_change_neither_expiry_score_nor_budget(): void
    {
        [$v] = $this->pickupStore('Scheduled');
        $this->bulk($v->id);
        $this->buyer();
        [$p,$w] = $this->package();
        $e = $this->scan($w);
        $fingerprint = app(ProjectEstimateService::class)->fingerprint($v->id);
        $metrics = app(ProjectBudget::class)->metrics(DB::table('projects')->where('id', $p['id'])->first());
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $v->id)->value('id');
        app(StoreOperatingSchedule::class)->replaceWeekly($profile, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));
        self::assertSame($fingerprint, app(ProjectEstimateService::class)->fingerprint($v->id));
        self::assertSame($metrics, app(ProjectBudget::class)->metrics(DB::table('projects')->where('id', $p['id'])->first()));
        self::assertSame(48, (int) CarbonImmutable::parse($e['estimate']['created_at'])->diffInHours(CarbonImmutable::parse($e['estimate']['expires_at'])));
        $later = CarbonImmutable::parse($e['estimate']['expires_at']);
        Carbon::setTestNow($later);
        CarbonImmutable::setTestNow($later);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates')->assertOk()->assertJsonPath('data.estimate.state', 'EXPIRED')->assertJsonPath('data.items.0.fms.score', $e['items'][0]['fms']['score']);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'ESTIMATE_EXPIRED');
    }

    public function test_multi_vendor_inquiries_share_original_and_single_award_expires_competitors_with_replay(): void
    {
        [$a,$ao,$al] = $this->pickupStore('Award A');
        $this->bulk($a->id);
        [$b,$bo,$bl] = $this->pickupStore('Award B');
        $this->bulk($b->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        $e = $this->scan($w);
        [$chatA,$w] = $this->inquiry($w, $e['items'][0]);
        [$chatB,$w] = $this->inquiry($w, $e['items'][1]);
        foreach ([[$chatA, $e['items'][0]], [$chatB, $e['items'][1]]] as [$chat,$candidate]) {
            $owner = $candidate['vendor_id'] === $a->id ? $ao : $bo;
            $listing = $candidate['vendor_id'] === $a->id ? $al : $bl;
            $this->signInStoreMember($owner);
            $quote = $this->publish($chat, $this->variantIds($listing)[0]);
            self::assertNotEmpty($quote['content']['original_changes']);
            $this->signInBuyer($buyer);
        }
        $key = $this->key();
        $body = ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id'], 'note' => 'Unload beside the gate.'];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', $body, $key)->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', $body, $key)->assertCreated()->assertJsonPath('data.id', $order);
        self::assertSame(1, DB::table('orders')->where('work_package_id', $w['id'])->count());
        self::assertSame('Unload beside the gate.', DB::table('orders')->where('id', $order)->value('project_note'));
        $this->getJson('/api/v1/buyers/conversations/'.$chatB)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED')->assertJsonCount(1, 'data.quotations.versions');
        $current = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $current['lock_version'], 'candidate_id' => $e['items'][1]['id']], $this->key())->assertConflict();
    }

    public function test_quotation_acceptance_requires_written_budget_override_and_retains_history_after_bulk_no(): void
    {
        [$v,$owner,$listing] = $this->pickupStore('Budget award');
        $this->bulk($v->id);
        $buyer = $this->buyer();
        [, $w] = $this->package(1000);
        $e = $this->scan($w);
        [$chat,$w] = $this->inquiry($w, $e['items'][0]);
        $this->signInStoreMember($owner);
        $quote = $this->publish($chat, $this->variantIds($listing)[0]);
        $this->signInBuyer($buyer);
        $body = ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash']];
        $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', $body, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'BUDGET_OVERRIDE_REQUIRED');
        self::assertSame(0, DB::table('orders')->count());
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', $body + ['budget_override_reason' => 'Approved extra materials for foundation.'], $this->key())->assertOk()->json('data.order_id');
        self::assertSame(1, DB::table('budget_overrides')->count());
        $this->bulk($v->id, false);
        $this->getJson('/api/v1/buyers/orders/'.$order)->assertOk()->assertJsonPath('data.project_context.content_hash', $w['version']['content_hash']);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 17000)->assertJsonPath('data.budget.actual_centavos', 0)->assertJsonPath('data.budget.remaining_centavos', -16000);
    }

    public function test_alternate_endpoint_and_stale_rates_preserve_site_and_confirmed_snapshot(): void
    {
        [$v,$owner] = $this->activeStore('Project delivery', false, true);
        $this->bulk($v->id);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('P10-DELIVERY');
        $vehicle = $this->addVehicle($v->id);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $v->id)->update(['maximum_distance_km' => 40]);
        $this->placeStore($v->id, 1000);
        $this->connectOnlinePayments($v->id);
        $buyer = $this->buyer();
        $gate = $this->savedLocation($buyer, 'North gate', 1500);
        [$p,$w,,$site] = $this->package(extra: ['fulfillment_method' => 'DELIVERY', 'site_contact' => 'Site supervisor', 'access_instructions' => 'Unload at the accessible North gate.', 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate]);
        $e = $this->scan($w);
        $snapshot = $e['items'][0];
        self::assertSame('ADVISORY_ESTIMATE', $snapshot['delivery']['status']);
        self::assertSame(2500, $snapshot['delivery']['estimate']['options'][0]['per_km_centavos']);
        self::assertSame($site, $snapshot['destination']['intended']['location_id']);
        self::assertSame($gate, $snapshot['destination']['alternate_drop_off']['location_id']);
        self::assertSame('ALTERNATE_DROP_OFF', $snapshot['destination']['vehicle_endpoint']);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/candidates/'.$snapshot['id'].'/route')->assertOk()->assertJsonPath('data.origin', 'PROJECT_SITE');
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $snapshot['id']], $this->key())->assertConflict();
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => true]);
        [$chat,$w] = $this->inquiry($w, $this->scan($w)['items'][0]);
        $this->signInStoreMember($owner);
        $quote = $this->publish($chat, $this->variantIds($listing)[0], '10', ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60500, 'arrangement' => 'Delivery to North gate', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true]);
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash']], $this->key())->assertOk()->json('data.order_id');
        $confirmed = DB::table('order_delivery_snapshots')->where('order_id', $order)->value('snapshot');
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->bulk($v->id, false);
        self::assertSame($confirmed, DB::table('order_delivery_snapshots')->where('order_id', $order)->value('snapshot'));
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.sites.0.point.location_id', $site);
    }

    public function test_database_rejects_inserting_into_a_locked_original(): void
    {
        $this->buyer();
        [, $w] = $this->package();
        $line = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->first();
        $copy = (array) $line;
        $copy['id'] = (string) Str::uuid7();
        $copy['line_number'] = 2;
        $this->expectException(QueryException::class);
        DB::table('work_package_lines')->insert($copy);
    }

    public function test_project_preferences_reset_with_monotonic_versions_and_do_not_replace_item_preferences(): void
    {
        $buyer = $this->buyer();
        $profile = $this->buyerProfileId($buyer);
        $itemId = (string) Str::uuid7();
        DB::table('buyer_ranking_preferences')->insert(['id' => $itemId, 'buyer_profile_id' => $profile, 'procurement_type' => 'ITEM_BASED', 'weights' => json_encode(['distance' => 25, 'price' => 25, 'vps' => 20, 'stock' => 20, 'product_rating' => 10]), 'version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/project-ranking-preferences')->assertOk()->assertJsonPath('data.personalized', false);
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 50, 'budget_fit' => 25, 'distance' => 20, 'vps' => 4]])->assertUnprocessable();
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 50, 'budget_fit' => 25, 'distance' => 20, 'vps' => 5]])->assertOk()->assertJsonPath('data.personalized', true)->assertJsonPath('data.version', 1);
        $this->postJson('/api/v1/buyers/project-ranking-preferences/reset', ['version' => 1])->assertOk()->assertJsonPath('data.personalized', false)->assertJsonPath('data.weights.material_match', 40)->assertJsonPath('data.version', 2);
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 15]])->assertConflict();
        self::assertSame($itemId, DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $profile)->where('procurement_type', 'ITEM_BASED')->value('id'));
    }

    public function test_csv_preview_validates_normalized_units_and_does_not_create_versions(): void
    {
        $this->buyer();
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $unit = DB::table('units')->where('id', $material->canonical_unit_id)->value('code');
        $header = 'material_code,name,unit_code,quantity,preferred_brand,specifications';
        $csv = $header."\nCONCRETE_HOLLOW_BLOCK,Blocks,".$unit.',10,BrandCo,{}';
        $this->postJson('/api/v1/buyers/work-packages/import-preview', ['csv' => $csv])->assertOk()->assertJsonPath('data.valid', true)->assertJsonPath('data.lines.0.material_id', $material->id);
        $this->postJson('/api/v1/buyers/work-packages/import-preview', ['csv' => $header."\nCONCRETE_HOLLOW_BLOCK,Blocks,UNKNOWN,10,BrandCo,{}"])->assertOk()->assertJsonPath('data.valid', false)->assertJsonCount(1, 'data.validation_errors');
        self::assertSame(0, DB::table('work_package_versions')->count());
    }

    public function test_completion_requires_all_missing_items_or_an_explicit_audited_waiver(): void
    {
        [$v, $owner, $listing] = $this->pickupStore('Partial completion');
        $this->bulk($v->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        [$chat, $w] = $this->inquiry($w, $this->scan($w)['items'][0]);
        $this->signInStoreMember($owner);
        $quote = $this->publish($chat, $this->variantIds($listing)[0], '3');
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash']], $this->key())->assertOk()->json('data.order_id');
        // Fulfillment actions belong to Phase 12; this synthetic canonical fact exercises completion projection.
        DB::table('orders')->where('id', $order)->update(['order_state' => 'COMPLETED']);
        $current = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.status', 'IN_PROGRESS')->assertJsonPath('data.budget.actual_centavos', 5100)->json('data');
        self::assertSame('7.0000', $current['missing_lines'][0]['quantity']);
        $line = $current['missing_lines'][0]['id'];
        $this->putJson('/api/v1/buyers/work-packages/'.$w['id'].'/missing-lines/'.$line, ['lock_version' => $current['lock_version'], 'reason' => 'Remaining blocks intentionally waived by Buyer.'])->assertOk()->assertJsonPath('data.status', 'COMPLETED')->assertJsonPath('data.budget.committed_centavos', 5100)->assertJsonPath('data.budget.remaining_centavos', 994900);
        self::assertTrue(DB::table('audit_logs')->where('action', 'WORK_PACKAGE_MISSING_LINE_RESOLUTION')->exists());
    }

    public function test_fin_11_paid_cancellation_recovery_and_processing_fee_are_reconciled_once(): void
    {
        [$v,$owner,$listing] = $this->pickupStore('Financial buckets');
        $this->bulk($v->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        [$chat,$w] = $this->inquiry($w, $this->scan($w)['items'][0]);
        $this->signInStoreMember($owner);
        $quote = $this->publish($chat, $this->variantIds($listing)[0]);
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash']], $this->key())->assertOk()->json('data.order_id');
        $payment = (string) Str::uuid7();
        DB::table('payments')->insert(['id' => $payment, 'order_id' => $order, 'purpose' => 'FULL_ORDER_PAYMENT', 'principal_centavos' => 17000, 'processing_fee_centavos' => 300, 'total_centavos' => 17300, 'state' => 'PAID', 'idempotency_key' => (string) Str::uuid7(),
            // Phase 11: a PAID row always carries its provider session, account and evidence origin.
            'provider_account_id' => 'sim-sub-account', 'provider_session_id' => 'ps-sim'.Str::lower(Str::random(21)), 'paid_at' => now(), 'gateway_mode' => 'SIMULATED', 'evidence_origin' => 'SIMULATED', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 17300)->assertJsonPath('data.budget.actual_centavos', 0);
        // Synthetic financial facts exercise the Phase 10 read model; Phase 12 owns cancellation actions.
        DB::table('orders')->where('id', $order)->update(['order_state' => 'CANCELLED']);
        DB::table('cancellation_decisions')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'actor_user_id' => $owner->id, 'state' => 'APPROVED', 'reason' => 'Synthetic approved retention', 'payload' => json_encode(['retained_centavos' => 2000]), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 0)->assertJsonPath('data.budget.actual_centavos', 2000)->assertJsonPath('data.budget.awaiting_recovery_centavos', 15300)->assertJsonPath('data.budget.committed_centavos', 17300)->assertJsonPath('data.budget.remaining_centavos', 982700);
        DB::table('refunds')->insert(['id' => (string) Str::uuid7(), 'target_type' => 'ORDER', 'order_id' => $order, 'source_payment_id' => $payment, 'trigger' => 'CANCELLATION', 'amount_centavos' => 15300, 'source_captured_centavos' => 17300, 'state' => 'REFUNDED', 'idempotency_key' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.actual_centavos', 2000)->assertJsonPath('data.budget.awaiting_recovery_centavos', 0)->assertJsonPath('data.budget.committed_centavos', 2000)->assertJsonPath('data.budget.remaining_centavos', 998000);
    }
}
