<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Orders\OrderActor;
use App\Domain\Projects\ProjectBudget;
use App\Domain\Projects\ProjectEstimateService;
use App\Domain\Projects\WorkPackageOrderRecovery;
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

    public function test_gravel_bags_never_satisfy_cubic_meters_without_a_buyer_unit_revision(): void
    {
        [$store, , $listing] = $this->pickupStore('Bagged gravel');
        $gravel = DB::table('materials')->where('code', 'GRAVEL')->first();
        $bag = DB::table('units')->where('code', 'BAG')->first();
        $listingRow = DB::table('vendor_listings')->where('id', $listing)->first();
        DB::table('products')->where('id', $listingRow->product_id)->update(['material_id' => $gravel->id]);
        DB::table('vendor_listings')->where('id', $listing)->update(['material_category_id' => $gravel->material_category_id]);
        DB::table('listing_variants')->where('vendor_listing_id', $listing)->update(['unit_id' => $bag->id]);
        $this->bulk($store->id);
        $this->buyer();
        [, $w, $input] = $this->package(extra: ['lines' => [[
            'name' => 'Crushed gravel', 'material_id' => $gravel->id, 'unit_id' => $gravel->canonical_unit_id,
            'quantity' => '1.25', 'specifications' => [],
        ]]]);
        self::assertSame([], $this->scan($w)['items']);
        $original = DB::table('work_package_versions')->where('id', $w['current_version_id'])->first();
        $input['lines'][0]['unit_id'] = $bag->id;
        $input['lines'][0]['quantity'] = '5';
        $revised = $this->putJson('/api/v1/buyers/work-packages/'.$w['id'], $input + ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        self::assertNotEmpty($this->scan($revised)['items']);
        self::assertSame($original->content, DB::table('work_package_versions')->where('id', $original->id)->value('content'));
        self::assertSame($original->content_hash, DB::table('work_package_versions')->where('id', $original->id)->value('content_hash'));
    }

    private function key(): array
    {
        return ['Idempotency-Key' => (string) Str::uuid7()];
    }

    private function input(string $site, int $budget = 1000000, string $quantity = '10'): array
    {
        $m = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();

        return ['name' => 'Foundation', 'budget_centavos' => $budget, 'site_id' => $site, 'radius_km' => 50, 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE',
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

    private function scan(array $w, int $radius = 50): array
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
        $header = $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->json('data.conversation');
        self::assertSame('PROJECT_BASED', $header['context_type']);
        self::assertNotEmpty($header['locked_reference']['work_package']);

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

    public function test_candidate_badges_are_current_public_awards_without_rewriting_the_estimate(): void
    {
        [$vendor] = $this->pickupStore('Awarded project supplier');
        $this->bulk($vendor->id);
        $awardId = (string) Str::uuid7();
        DB::table('vendor_badge_history')->insert([
            'id' => $awardId, 'vendor_organization_id' => $vendor->id,
            'badge_definition_id' => DB::table('badge_definitions')->where('code', 'FAST_RESPONDER')->value('id'),
            'earned_at' => now(), 'scope_key' => '', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->buyer();
        [, $w] = $this->package();
        $estimate = $this->scan($w);
        self::assertSame(['FAST_RESPONDER'], array_column($estimate['items'][0]['badges'], 'code'));
        $snapshot = DB::table('compiled_estimate_vendors')->where('id', $estimate['items'][0]['id'])->value('snapshot');
        self::assertArrayNotHasKey('badges', json_decode($snapshot, true, 512, JSON_THROW_ON_ERROR));
        DB::table('vendor_badge_history')->where('id', $awardId)->update(['revoked_at' => now(), 'revocation_reason' => 'CRITERIA_NOT_MET', 'updated_at' => now()]);
        $current = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates')->assertOk()->json('data');
        self::assertSame([], $current['items'][0]['badges']);
        self::assertSame($snapshot, DB::table('compiled_estimate_vendors')->where('id', $estimate['items'][0]['id'])->value('snapshot'));
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
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 50])->assertConflict();
        $this->putJson('/api/v1/buyers/work-packages/'.$w['id'], $input + ['lock_version' => $w['lock_version']], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'PROJECT_CLOSED');
        $this->postJson('/api/v1/buyers/projects/'.$p['id'].'/work-packages', $input, $this->key())->assertConflict();
        $this->patchJson('/api/v1/buyers/projects/'.$p['id'], ['lock_version' => $p['lock_version'] + 1, 'status' => 'ACTIVE'], $this->key())->assertConflict();
    }

    public function test_editing_a_quoted_package_in_place_expires_inquiries_keeps_the_quoted_copy_and_enforces_owner_scope(): void
    {
        [$vendor] = $this->pickupStore('Version supplier');
        $this->bulk($vendor->id);
        $buyer = $this->buyer();
        [$p,$w,$input] = $this->package();
        $e = $this->scan($w);
        [$chat,$w] = $this->inquiry($w, $e['items'][0]);
        $old = $w['version'];
        $next = $this->putJson('/api/v1/buyers/work-packages/'.$w['id'], $input + ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        self::assertSame($w['id'], $next['id']);
        self::assertSame('ACTIVE', $next['status']);
        self::assertNotNull($next['version']['locked_at']);
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
        [$complete] = $this->pickupStore('Complete boundary', [['price' => 2000, 'qty' => '20']], 50000);
        $this->bulk($complete->id);
        [$outside] = $this->pickupStore('Outside', [['price' => 1000, 'qty' => '20']], 50001);
        $this->bulk($outside->id);
        $this->buyer();
        [, $w] = $this->package();
        $e = $this->scan($w);
        self::assertCount(2, $e['items']);
        self::assertSame($complete->id, $e['items'][0]['vendor_id']);
        self::assertTrue($e['items'][0]['complete']);
        self::assertSame('7.0000', $e['items'][1]['missing_lines'][0]['quantity']);
        self::assertSame('New Vendor', $e['items'][1]['score_label']);
        // The fixed 50 km radius is never widened, so no larger radius is offered.
        self::assertArrayNotHasKey('suggested_radius_km', $e);
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 6])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/estimates', ['lock_version' => $w['lock_version'], 'radius_km' => 10])->assertUnprocessable();
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
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id'], 'payment_method' => 'ONLINE'], $this->key())->assertConflict();
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
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id'], 'payment_method' => 'ONLINE'], $this->key())->assertConflict()->assertJsonPath('errors.0.code', 'ESTIMATE_EXPIRED');
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
        $body = ['lock_version' => $w['lock_version'], 'candidate_id' => $e['items'][0]['id'], 'payment_method' => 'ONLINE', 'note' => 'Unload beside the gate.'];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', $body, $key)->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', $body, $key)->assertCreated()->assertJsonPath('data.id', $order);
        self::assertSame(1, DB::table('orders')->where('work_package_id', $w['id'])->count());
        self::assertSame('Unload beside the gate.', DB::table('orders')->where('id', $order)->value('project_note'));
        $this->getJson('/api/v1/buyers/conversations/'.$chatB)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED')->assertJsonCount(1, 'data.quotations.versions');
        $current = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data');
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $current['lock_version'], 'candidate_id' => $e['items'][1]['id'], 'payment_method' => 'ONLINE'], $this->key())->assertConflict();
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
        $body = ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'];
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
        $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $snapshot['id'], 'payment_method' => 'ONLINE'], $this->key())->assertConflict();
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => true]);
        [$chat,$w] = $this->inquiry($w, $this->scan($w)['items'][0]);
        $this->signInStoreMember($owner);
        $quote = $this->publish($chat, $this->variantIds($listing)[0], '10', ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60500, 'arrangement' => 'Delivery to North gate', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true]);
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], $this->key())->assertOk()->json('data.order_id');
        $confirmed = DB::table('order_delivery_snapshots')->where('order_id', $order)->value('snapshot');
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->bulk($v->id, false);
        self::assertSame($confirmed, DB::table('order_delivery_snapshots')->where('order_id', $order)->value('snapshot'));
        $this->getJson('/api/v1/buyers/projects/'.$p['id'])->assertOk()->assertJsonPath('data.sites.0.point.location_id', $site);
    }

    public function test_a_both_package_offers_each_vendor_method_and_the_buyer_picks_one_per_vendor(): void
    {
        [$deliverer, $owner] = $this->activeStore('Both deliverer', false, true);
        $this->bulk($deliverer->id);
        $this->signInStoreMember($owner);
        $this->orderListing('BOTH-DELIVERER');
        $this->addVehicle($deliverer->id);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $deliverer->id)->update(['maximum_distance_km' => 40]);
        $this->placeStore($deliverer->id, 1000);
        $this->connectOnlinePayments($deliverer->id);
        [$pickup] = $this->pickupStore('Both pickup only');
        $this->bulk($pickup->id);
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Both site', 0, 0, 'PROJECT_SITE');
        $project = $this->postJson('/api/v1/buyers/projects', ['name' => 'Both house', 'budget_centavos' => 1000000, 'starts_on' => now()->toDateString(),
            'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], $this->key())->assertCreated()->json('data');
        $input = array_replace($this->input($project['sites'][0]['id']), ['fulfillment_method' => 'BOTH', 'site_contact' => 'Site supervisor',
            'access_instructions' => 'Unload at the accessible gate.', 'heavy_vehicle_restriction' => 'NO']);
        $save = '/api/v1/buyers/projects/'.$project['id'].'/work-packages';

        // Cash on Delivery and In-Store Payment need one method; delivery details are required because the Buyer may choose delivery.
        $this->postJson($save, ['payment_method' => 'CASH_ON_DELIVERY'] + $input, $this->key())->assertUnprocessable();
        $this->postJson($save, ['payment_method' => 'IN_STORE'] + $input, $this->key())->assertUnprocessable();
        $this->postJson($save, ['site_contact' => null] + $input, $this->key())->assertUnprocessable();

        $w = $this->postJson($save, $input, $this->key())->assertCreated()->json('data');
        $w = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/activate', ['lock_version' => $w['lock_version']], $this->key())->assertOk()->json('data');
        $items = collect($this->scan($w)['items'])->keyBy('vendor_id');
        self::assertSame(['DELIVERY', 'PICKUP'], $items[$deliverer->id]['fulfillment_options']);
        self::assertSame(['PICKUP'], $items[$pickup->id]['fulfillment_options']);
        self::assertSame('PICKUP', $items[$pickup->id]['fulfillment_method']);

        $both = $items[$deliverer->id];
        $url = '/api/v1/buyers/work-packages/'.$w['id'];
        $choice = ['lock_version' => $w['lock_version'], 'candidate_id' => $both['id'], 'payment_method' => 'ONLINE'];
        // A Vendor offering both needs the Buyer's choice; a method the Vendor lacks is refused.
        $this->postJson($url.'/selection', $choice, $this->key())->assertUnprocessable()->assertJsonPath('errors.0.code', 'FULFILLMENT_CHOICE_REQUIRED');
        $this->postJson($url.'/selection', ['candidate_id' => $items[$pickup->id]['id'], 'fulfillment_method' => 'DELIVERY'] + $choice, $this->key())
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'FULFILLMENT_NOT_OFFERED');

        $delivery = $this->postJson($url.'/candidates/'.$both['id'].'/selection-preview', ['fulfillment_method' => 'DELIVERY'])->assertOk()
            ->assertJsonPath('data.fulfillment_method', 'DELIVERY')->assertJsonPath('data.destination.type', 'DELIVERY')->json('data');
        $pickupView = $this->postJson($url.'/candidates/'.$both['id'].'/selection-preview', ['fulfillment_method' => 'PICKUP'])->assertOk()
            ->assertJsonPath('data.fulfillment_method', 'PICKUP')->assertJsonPath('data.destination.type', 'PICKUP')->assertJsonPath('data.delivery_centavos', 0)->json('data');
        self::assertSame(60500, $delivery['delivery_centavos']);
        self::assertSame($pickupView['materials_centavos'] + 60500, $delivery['projected_total_centavos']);

        $order = $this->postJson($url.'/selection', ['fulfillment_method' => 'PICKUP'] + $choice, $this->key())->assertCreated()->json('data.id');
        $row = DB::table('orders')->where('id', $order)->first(['fulfillment_method', 'payment_method', 'destination']);
        self::assertSame(['PICKUP', 'ONLINE', 'PICKUP'], [$row->fulfillment_method, $row->payment_method, json_decode($row->destination, true)['type']]);
    }

    public function test_direct_project_selection_keeps_the_delivery_estimate_in_buyer_and_vendor_order_summaries(): void
    {
        [$vendor, $owner] = $this->activeStore('Project estimate summary', false, true);
        $this->bulk($vendor->id);
        $this->signInStoreMember($owner);
        $this->orderListing('PROJECT-DELIVERY-SUMMARY');
        $vehicle = $this->addVehicle($vendor->id);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $vendor->id)->update(['maximum_distance_km' => 40]);
        $this->placeStore($vendor->id, 1000);
        $this->connectOnlinePayments($vendor->id);
        $buyer = $this->buyer();
        [, $package] = $this->package(extra: ['fulfillment_method' => 'DELIVERY', 'site_contact' => 'Site supervisor',
            'access_instructions' => 'Unload at the site.', 'heavy_vehicle_restriction' => 'NO']);
        $candidate = $this->scan($package)['items'][0];
        $fee = $candidate['delivery']['estimate']['fee_min_centavos'];
        self::assertSame(60500, $fee);
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$package['id'].'/selection', [
            'lock_version' => $package['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE',
        ], $this->key())->assertCreated()->json('data.id');
        $assertEstimate = static fn ($response) => $response->assertOk()
            ->assertJsonPath('data.money.delivery.estimate.min_centavos', $fee)
            ->assertJsonPath('data.money.delivery.amount_centavos', null)
            ->assertJsonPath('data.money.commercial_total_centavos', null)
            ->assertJsonPath('data.delivery.status', 'ADVISORY_ESTIMATE')
            ->assertJsonPath('data.delivery.estimate.fee_min_centavos', $fee);
        $assertEstimate($this->getJson('/api/v1/buyers/orders/'.$order));
        $this->signInStoreMember($owner);
        $assertEstimate($this->getJson('/api/v1/vendor/orders/'.$order));
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->signInBuyer($buyer);
        $assertEstimate($this->getJson('/api/v1/buyers/orders/'.$order));
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
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 0, 'budget_fit' => 0, 'distance' => 0, 'vps' => 0]])->assertUnprocessable()->assertJsonPath('errors.0.code', 'WEIGHTS_ALL_ZERO');
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 80, 'budget_fit' => 50, 'distance' => 40, 'vps' => 30]])->assertOk()->assertJsonPath('data.personalized', true)->assertJsonPath('data.version', 1);
        $this->getJson('/api/v1/buyers/project-ranking-preferences')->assertOk()->assertJsonPath('data.weights', ['material_match' => 80, 'budget_fit' => 50, 'distance' => 40, 'vps' => 30]);
        $this->postJson('/api/v1/buyers/project-ranking-preferences/reset', ['version' => 1])->assertOk()->assertJsonPath('data.personalized', false)->assertJsonPath('data.weights.material_match', 40)->assertJsonPath('data.version', 2);
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => ['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 15]])->assertConflict();
        self::assertSame($itemId, DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $profile)->where('procurement_type', 'ITEM_BASED')->value('id'));
    }

    public function test_new_estimates_apply_saved_raw_weights_without_rewriting_preferences_or_prior_snapshots(): void
    {
        [$vendor] = $this->pickupStore('Ranking supplier');
        $this->bulk($vendor->id);
        $this->buyer();
        [, $package] = $this->package();
        $before = $this->scan($package);
        $oldSnapshot = DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $before['estimate']['id'])->value('snapshot');
        $weights = ['material_match' => 1, 'budget_fit' => 0, 'distance' => 0, 'vps' => 0];
        $this->putJson('/api/v1/buyers/project-ranking-preferences', ['version' => 0, 'weights' => $weights])->assertOk();
        $this->getJson('/api/v1/buyers/work-packages/'.$package['id'].'/estimates')->assertOk()->assertJsonPath('data.estimate.state', 'INVALIDATED');
        $current = $this->getJson('/api/v1/buyers/work-packages/'.$package['id'])->assertOk()->json('data');
        $after = $this->scan($current);
        self::assertSame('100.00', $after['items'][0]['fms']['score']);
        self::assertEquals($weights, $after['items'][0]['fms']['weights']);
        self::assertSame($oldSnapshot, DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $before['estimate']['id'])->value('snapshot'));
        $this->getJson('/api/v1/buyers/project-ranking-preferences')->assertOk()->assertJsonPath('data.weights', $weights);
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
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], $this->key())->assertOk()->json('data.order_id');
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
        $order = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], $this->key())->assertOk()->json('data.order_id');
        $payment = (string) Str::uuid7();
        DB::table('payments')->insert(['id' => $payment, 'order_id' => $order, 'purpose' => 'FULL_ORDER_PAYMENT', 'principal_centavos' => 17000, 'processing_fee_centavos' => 300, 'total_centavos' => 17300, 'state' => 'PAID', 'idempotency_key' => (string) Str::uuid7(),
            // Phase 11: a PAID row always carries its provider session, account and evidence origin.
            'provider_account_id' => 'sim-sub-account', 'provider_session_id' => 'ps-sim'.Str::lower(Str::random(21)), 'paid_at' => now(), 'gateway_mode' => 'SIMULATED', 'evidence_origin' => 'SIMULATED', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 17300)->assertJsonPath('data.budget.actual_centavos', 0);
        // Synthetic financial facts exercise the Phase 10 read model; Phase 12 owns cancellation actions.
        DB::table('orders')->where('id', $order)->update(['order_state' => 'CANCELLED']);
        // Phase 12 constraints: a decision records cause and decider, and a CANCELLATION refund links its decision.
        $decision = (string) Str::uuid7();
        DB::table('cancellation_decisions')->insert(['id' => $decision, 'order_id' => $order, 'actor_user_id' => $owner->id, 'state' => 'APPROVED', 'reason' => 'Synthetic approved retention', 'payload' => json_encode(['retained_centavos' => 2000]),
            'cause' => 'BUYER', 'decided_by' => 'VENDOR', 'decision_code' => 'VENDOR_FINALIZED_NRPC_RETAINED', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.pending_centavos', 0)->assertJsonPath('data.budget.actual_centavos', 2000)->assertJsonPath('data.budget.awaiting_recovery_centavos', 15300)->assertJsonPath('data.budget.committed_centavos', 17300)->assertJsonPath('data.budget.remaining_centavos', 982700);
        DB::table('refunds')->insert(['id' => (string) Str::uuid7(), 'target_type' => 'ORDER', 'order_id' => $order, 'source_payment_id' => $payment, 'trigger' => 'CANCELLATION', 'amount_centavos' => 15300, 'source_captured_centavos' => 17300, 'state' => 'REFUNDED',
            'cancellation_decision_id' => $decision, 'idempotency_key' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.budget.actual_centavos', 2000)->assertJsonPath('data.budget.awaiting_recovery_centavos', 0)->assertJsonPath('data.budget.committed_centavos', 2000)->assertJsonPath('data.budget.remaining_centavos', 998000);
    }

    public function test_opening_fulfillment_messages_preserves_the_work_package_order_and_requirements(): void
    {
        [$vendor, $owner] = $this->pickupStore('Package message navigation');
        $this->bulk($vendor->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        $candidate = $this->scan($w)['items'][0];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', [
            'lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE',
        ], $this->key())->assertCreated()->json('data.id');
        $before = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data');
        $thread = $this->postJson('/api/v1/buyers/orders/'.$order.'/fulfillment-conversation', [], $this->key())->assertOk()->json('data.conversation_id');
        $this->getJson('/api/v1/buyers/conversations/'.$thread)->assertOk()->assertJsonPath('data.conversation.order_id', $order)
            ->assertJsonPath('data.conversation.locked_reference.version_id', $w['current_version_id']);
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', ['body' => 'Please confirm availability.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $after = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->json('data');
        self::assertSame($before['order_id'], $after['order_id']);
        self::assertSame($before['selected_vendor_id'], $after['selected_vendor_id']);
        self::assertSame($before['version'], $after['version']);
    }

    public function test_cancellation_reopens_the_same_package_and_allows_matching_again(): void
    {
        [$vendor] = $this->pickupStore('Reusable package');
        $this->bulk($vendor->id);
        $this->buyer();
        [, $w] = $this->package();
        $candidate = $this->scan($w)['items'][0];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', [
            'lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE',
        ], $this->key())->assertCreated()->json('data.id');
        $lock = (int) DB::table('orders')->where('id', $order)->value('lock_version');
        $this->postJson('/api/v1/buyers/orders/'.$order.'/cancel', ['lock_version' => $lock], $this->key())->assertOk();
        $reopened = $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.status', 'ACTIVE')
            ->assertJsonPath('data.selected_vendor_id', null)->assertJsonPath('data.current_version_id', $w['current_version_id'])->json('data');
        self::assertNotEmpty($this->scan($reopened)['items']);
        self::assertSame('CANCELLED', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertTrue(DB::table('outbox_events')->where('event_type', 'WORK_PACKAGE_REOPEN_REQUESTED')->exists());
        DB::transaction(fn () => app(WorkPackageOrderRecovery::class)->reopen(DB::table('orders')->where('id', $order)->first(), OrderActor::system()));
        self::assertTrue(DB::table('audit_logs')->where('action', 'WORK_PACKAGE_REOPENED')->exists());
    }

    public function test_grouped_cancellation_reopens_only_failed_coverage_and_preserves_the_other_supplier_order(): void
    {
        [$first] = $this->pickupStore('First group supplier', [['price' => 1800, 'qty' => '5']]);
        [$second] = $this->pickupStore('Second group supplier', [['price' => 1900, 'qty' => '5']]);
        $this->bulk($first->id);
        $this->bulk($second->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        $this->scan($w);
        $base = '/api/v1/buyers/work-packages/'.$w['id'];
        $options = $this->getJson($base.'/arrangement-options')->assertOk()->json('data.items');
        $group = collect($options)->firstWhere('vendor_count', 2);
        self::assertNotNull($group);
        $arrangement = $this->postJson($base.'/arrangements', ['source_candidate_id' => $group['source_candidate_id'], 'proposal_token' => $group['proposal_token']], $this->key())->assertCreated()->json('data');
        $url = $base.'/arrangements/'.$arrangement['id'];
        $arrangement = $this->postJson($url.'/submit', ['version' => $arrangement['version'], 'fingerprint' => $arrangement['fingerprint'], 'acknowledged' => true,
            'payments' => [['vendor_id' => $first->id, 'payment_method' => 'ONLINE'], ['vendor_id' => $second->id, 'payment_method' => 'ONLINE']]], $this->key())->assertCreated()->json('data');
        $orders = array_column($arrangement['vendors'], 'order_id', 'vendor_id');
        self::assertCount(2, array_filter($orders));
        $cancelled = $orders[$first->id];
        $peer = $orders[$second->id];
        $this->postJson('/api/v1/buyers/orders/'.$cancelled.'/cancel', ['lock_version' => (int) DB::table('orders')->where('id', $cancelled)->value('lock_version')], $this->key())->assertOk();
        DB::transaction(fn () => app(WorkPackageOrderRecovery::class)->reopen(DB::table('orders')->where('id', $cancelled)->first(), OrderActor::system()));
        $reopened = $this->getJson($url)->assertOk()->json('data');
        self::assertCount(1, $reopened['vendors']);
        self::assertSame($peer, $reopened['vendors'][0]['order_id']);
        self::assertSame('5.0000', bcadd($reopened['coverage']['lines'][0]['remaining_quantity'], '0', 4));
        self::assertSame($cancelled, $reopened['previous_vendors'][0]['order_id']);

        [$replacement, , $listing] = $this->pickupStore('Replacement group supplier', [['price' => 2000, 'qty' => '5']]);
        $this->bulk($replacement->id);
        $this->signInBuyer($buyer);
        $variant = $this->variantIds($listing)[0];
        $price = DB::table('listing_price_versions')->where('listing_variant_id', $variant)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->value('id');
        $line = DB::table('work_package_lines')->where('work_package_version_id', $w['current_version_id'])->value('id');
        $edited = $this->patchJson($url, ['version' => $reopened['version'], 'vendor_id' => $replacement->id, 'line_id' => $line,
            'variant_id' => $variant, 'price_version_id' => $price, 'method' => 'PICKUP'])->assertOk()->json('data');
        self::assertSame('0.0000', bcadd($edited['coverage']['lines'][0]['remaining_quantity'], '0', 4));
        self::assertSame($peer, collect($edited['vendors'])->firstWhere('vendor_id', $second->id)['order_id']);
        self::assertNull(collect($edited['vendors'])->firstWhere('vendor_id', $replacement->id)['order_id']);
        self::assertSame('AWAITING_VENDOR_CONFIRMATION', DB::table('orders')->where('id', $peer)->value('order_state'));
        self::assertSame(2, DB::table('orders')->where('work_package_id', $w['id'])->count());
    }

    public function test_work_package_message_buttons_attach_packages_to_the_same_normal_store_chat(): void
    {
        [$vendor, $owner, $listing] = $this->pickupStore('One ordinary chat');
        $this->bulk($vendor->id);
        $buyer = $this->buyer();
        $store = null;
        $inquiries = [];
        foreach (range(1, 2) as $index) {
            [, $w] = $this->package();
            $candidate = $this->scan($w)['items'][0];
            $key = $this->key();
            $input = ['lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id']];
            $result = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/inquiries', $input, $key)->assertCreated()->json('data');
            $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/inquiries', $input, $key)->assertCreated()->assertJsonPath('data.store_conversation_id', $result['store_conversation_id']);
            $store ??= $result['store_conversation_id'];
            self::assertSame($store, $result['store_conversation_id']);
            $inquiries[] = $result['id'];
            $this->getJson('/api/v1/buyers/conversations/'.$store.'?store_thread=true')->assertOk()->assertJsonPath('data.conversation.id', $store)
                ->assertJsonPath('data.conversation.context_type', 'ITEM_BASED')->assertJsonCount($index, 'data.messages.items')
                ->assertJsonPath('data.messages.items.'.($index - 1).'.work_package_attachment.reference.version_id', $w['current_version_id']);
        }
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $store);
        $this->postJson('/api/v1/buyers/conversations/'.$store.'/messages', ['body' => 'Please review my two packages.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$inquiries[1].'/buyer-thread')->assertOk()->assertJsonPath('data.conversation.id', $store)
            ->assertJsonPath('data.conversation.read_only', false)->assertJsonPath('data.messages.items.0.work_package_attachment.can_prepare_quotation', true);
        $this->postJson('/api/v1/vendor/conversations/'.$store.'/messages', ['body' => 'I can help with both.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $version = $this->publish($inquiries[0], $this->variantIds($listing)[0]);
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations/'.$store.'?store_thread=true')->assertOk()->assertJsonPath('data.quotations.versions.0.id', $version['id'])
            ->assertJsonPath('data.quotations.versions.0.conversation_id', $inquiries[0]);
        self::assertSame(2, DB::table('messages')->where('conversation_id', $store)->where('kind', 'WORK_PACKAGE')->count());
        self::assertSame(1, DB::table('conversations')->where('buyer_profile_id', $this->buyerProfileId($buyer))->where('context_type', 'ITEM_BASED')->count());
        $this->postJson('/api/v1/buyers/conversations/'.$store.'/work-package-attachment', [], $this->key())->assertForbidden();
        $this->buyer();
        $this->postJson('/api/v1/buyers/conversations/'.$inquiries[0].'/work-package-attachment', [], $this->key())->assertNotFound();
        self::assertSame(2, DB::table('messages')->where('conversation_id', $store)->where('kind', 'WORK_PACKAGE')->count());
    }

    public function test_package_attachment_shows_only_this_vendors_allocation_then_its_accepted_order_items(): void
    {
        [$first, $owner, $listing] = $this->pickupStore('Scoped first supplier', [['price' => 1800, 'qty' => '5']]);
        [$second, $otherOwner] = $this->pickupStore('Scoped second supplier', [['price' => 1900, 'qty' => '5']]);
        $this->bulk($first->id);
        $this->bulk($second->id);
        $buyer = $this->buyer();
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $line = ['material_id' => $material->id, 'unit_id' => $material->canonical_unit_id, 'quantity' => '5', 'specifications' => ['thickness_mm' => '100'], 'preferred_brand' => 'BrandCo'];
        [, $w] = $this->package(extra: ['lines' => [array_merge($line, ['name' => 'North wall blocks']), array_merge($line, ['name' => 'South wall blocks'])]]);
        $original = DB::table('work_package_versions')->where('id', $w['current_version_id'])->first();
        $this->scan($w);
        $base = '/api/v1/buyers/work-packages/'.$w['id'];
        $group = collect($this->getJson($base.'/arrangement-options')->assertOk()->json('data.items'))->firstWhere('vendor_count', 2);
        self::assertNotNull($group);
        $arrangement = $this->postJson($base.'/arrangements', ['source_candidate_id' => $group['source_candidate_id'], 'proposal_token' => $group['proposal_token']], $this->key())->assertCreated()->json('data');
        $arrangement = $this->postJson($base.'/arrangements/'.$arrangement['id'].'/vendors/'.$first->id.'/inquiry', ['version' => $arrangement['version']])->assertOk()->json('data');
        $inquiry = collect($arrangement['vendors'])->firstWhere('vendor_id', $first->id)['conversation_id'];
        $chat = $this->postJson('/api/v1/buyers/conversations/'.$inquiry.'/work-package-attachment', [], $this->key())->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/conversations/'.$chat.'/buyer-thread')->assertOk()->json('data');
        $reference = $response['messages']['items'][0]['work_package_attachment']['reference'];
        self::assertSame('VENDOR_ALLOCATION', $reference['material_scope']);
        self::assertCount(1, $reference['work_package']['lines']);
        self::assertSame('5.0000', bcadd($reference['work_package']['lines'][0]['quantity'], '0', 4));
        $assigned = $reference['work_package']['lines'][0]['name'];
        $other = $assigned === 'North wall blocks' ? 'South wall blocks' : 'North wall blocks';
        self::assertStringNotContainsString($other, json_encode($reference));
        self::assertArrayNotHasKey('budget_centavos', $reference['work_package']);
        self::assertArrayNotHasKey('system_estimate', $reference);
        $this->getJson('/api/v1/vendor/conversations/'.$inquiry)->assertOk()->assertJsonCount(1, 'data.conversation.locked_reference.work_package.lines');
        $this->signInStoreMember($otherOwner);
        $this->getJson('/api/v1/vendor/conversations/'.$chat.'/buyer-thread')->assertNotFound();
        $this->signInStoreMember($owner);
        $quote = $this->publish($inquiry, $this->variantIds($listing)[0], '3');
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$inquiry.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], $this->key())->assertOk()->json('data.order_id');
        $this->postJson('/api/v1/buyers/orders/'.$order.'/work-package-message', [], $this->key())->assertCreated()->assertJsonPath('data.id', $chat);
        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/conversations/'.$chat.'/buyer-thread')->assertOk()->json('data');
        foreach (collect($response['messages']['items'])->where('kind', 'WORK_PACKAGE') as $message) {
            $reference = $message['work_package_attachment']['reference'];
            self::assertSame('VENDOR_ORDER', $reference['material_scope']);
            self::assertTrue($reference['order']['accepted']);
            self::assertSame($order, $reference['order']['id']);
            self::assertCount(1, $reference['work_package']['lines']);
            self::assertSame('3.0000', bcadd($reference['work_package']['lines'][0]['quantity'], '0', 4));
            self::assertSame(1700, $reference['work_package']['lines'][0]['unit_price_centavos']);
            self::assertSame('100', $reference['work_package']['lines'][0]['specifications']['thickness_mm']);
            self::assertArrayNotHasKey('working_duplicate', $reference);
            self::assertStringNotContainsString($other, json_encode($reference));
        }
        $fulfillment = DB::table('conversations')->where('order_id', $order)->where('purpose', 'FULFILLMENT')->value('id');
        $this->getJson('/api/v1/vendor/conversations/'.$fulfillment)->assertOk()->assertJsonPath('data.conversation.locked_reference.material_scope', 'VENDOR_ORDER')
            ->assertJsonCount(1, 'data.conversation.locked_reference.work_package.lines')->assertJsonPath('data.conversation.locked_reference.work_package.lines.0.quantity', '3.0000');
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations/'.$inquiry)->assertOk()->assertJsonCount(2, 'data.conversation.locked_reference.work_package.lines');
        self::assertSame($original->content, DB::table('work_package_versions')->where('id', $original->id)->value('content'));
        self::assertSame($original->content_hash, DB::table('work_package_versions')->where('id', $original->id)->value('content_hash'));
    }

    public function test_order_message_attaches_its_package_and_cancelling_the_order_never_locks_the_store_chat(): void
    {
        [$vendor, $owner] = $this->pickupStore('Order package attachment');
        $this->bulk($vendor->id);
        $this->buyer();
        [, $w] = $this->package();
        $candidate = $this->scan($w)['items'][0];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', ['lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE'], $this->key())->assertCreated()->json('data.id');
        $key = $this->key();
        $store = $this->postJson('/api/v1/buyers/orders/'.$order.'/work-package-message', [], $key)->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/orders/'.$order.'/work-package-message', [], $key)->assertCreated()->assertJsonPath('data.id', $store);
        self::assertSame(1, DB::table('messages')->where('conversation_id', $store)->where('kind', 'WORK_PACKAGE')->count());
        $this->postJson('/api/v1/buyers/orders/'.$order.'/cancel', ['lock_version' => (int) DB::table('orders')->where('id', $order)->value('lock_version')], $this->key())->assertOk();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$store.'/buyer-thread')->assertOk()->assertJsonPath('data.conversation.purpose', 'SALES')
            ->assertJsonPath('data.conversation.read_only', false)->assertJsonPath('data.messages.items.0.work_package_attachment.order_id', $order)
            ->assertJsonPath('data.messages.items.0.work_package_attachment.can_prepare_quotation', false);
        $this->postJson('/api/v1/vendor/conversations/'.$store.'/messages', ['body' => 'We can discuss the next package here.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        self::assertSame('CANCELLED', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertSame($w['id'], DB::table('orders')->where('id', $order)->value('work_package_id'));
    }

    public function test_pending_order_quotation_preserves_the_request_until_acceptance_then_replaces_it_atomically(): void
    {
        [$vendor, $owner, $listing] = $this->pickupStore('Pending replacement');
        $this->bulk($vendor->id);
        $buyer = $this->buyer();
        [, $w] = $this->package();
        $candidate = $this->scan($w)['items'][0];
        $order = $this->postJson('/api/v1/buyers/work-packages/'.$w['id'].'/selection', [
            'lock_version' => $w['lock_version'], 'candidate_id' => $candidate['id'], 'payment_method' => 'ONLINE',
        ], $this->key())->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $chat = $this->postJson('/api/v1/vendor/orders/'.$order.'/quotation-inquiry', ['lock_version' => (int) DB::table('orders')->where('id', $order)->value('lock_version')], $this->key())->assertOk()->json('data.id');
        self::assertSame('AWAITING_VENDOR_CONFIRMATION', DB::table('orders')->where('id', $order)->value('order_state'));
        $quote = $this->publish($chat, $this->variantIds($listing)[0], '10');
        $this->signInBuyer($buyer);
        $replacement = $this->postJson('/api/v1/buyers/conversations/'.$chat.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], $this->key())->assertOk()->json('data.order_id');
        self::assertNotSame($order, $replacement);
        self::assertSame('CANCELLED', DB::table('orders')->where('id', $order)->value('order_state'));
        $this->getJson('/api/v1/buyers/work-packages/'.$w['id'])->assertOk()->assertJsonPath('data.order_id', $replacement);
        self::assertTrue(DB::table('order_snapshots')->where('order_id', $order)->exists());
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$replacement.'/quotation-inquiry', ['lock_version' => (int) DB::table('orders')->where('id', $replacement)->value('lock_version')], $this->key())->assertConflict();
    }
}
