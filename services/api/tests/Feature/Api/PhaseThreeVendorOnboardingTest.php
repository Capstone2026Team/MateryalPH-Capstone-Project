<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\ProfilePhotoScanner;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\ConfirmedDeliverySnapshot;
use App\Domain\Vendors\DeliveryRecommendationService;
use App\Domain\Vendors\NewProcurementAvailability;
use App\Domain\Vendors\OnboardingDrafts;
use App\Domain\Vendors\OnboardingRequirementResolver;
use App\Domain\Vendors\PhilippineRegionDirectory;
use App\Domain\Vendors\PsgcProvider;
use App\Domain\Vendors\StoreActivationGate;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorAddressResolver;
use App\Domain\Vendors\VendorExpiryService;
use App\Domain\Vendors\VendorFileScanner;
use App\Domain\Vendors\VendorOnboardingService;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Domain\Vendors\XenditProviderUnavailable;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseThreeVendorOnboardingTest extends TestCase
{
    use RefreshDatabase;

    public function test_vacation_mode_is_audited_versioned_and_preserves_store_hours(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => 1, 'description' => 'Sample store', 'bulk_capability' => false, 'fulfillment_method' => 'SELF_PICKUP', 'operating_schedule' => $this->weeklyOperatingSchedule()])->assertOk();
        foreach (['LOGO', 'BANNER'] as $kind) {
            $this->post('/api/v1/vendors/onboarding/media', ['kind' => $kind, 'file' => UploadedFile::fake()->image(strtolower($kind).'.png')])->assertCreated();
        }
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'provider' => 'XENDIT', 'environment' => 'TEST', 'provider_associated_at' => now(), 'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'provider_account_id' => 'fixture-account', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['status' => 'COMPLETED']);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_setup_status' => 'COMPLETED', 'store_activation_status' => 'ACTIVE', 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $version = $organization->refresh()->lock_version;
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $version, 'vacation_mode' => true])->assertOk()->assertJsonPath('data.setup.vacation_mode', true)->assertJsonPath('data.setup.status', 'COMPLETED')->assertJsonCount(7, 'data.setup.operating_schedule');
        $this->assertDatabaseHas('audit_logs', ['action' => 'VENDOR_VACATION_MODE_UPDATED', 'actor_user_id' => $owner->id]);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk()->assertJsonPath('data.vacation_mode', true);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $version, 'vacation_mode' => false])->assertConflict();
        try {
            DB::transaction(fn () => app(NewProcurementAvailability::class)->assertAvailable($organization->id));
            self::fail('Vacation Mode must reject new procurement.');
        } catch (AuthenticationException $exception) {
            self::assertSame('STORE_ON_VACATION', $exception->errorCode);
        }
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'vacation_mode' => false])->assertOk()->assertJsonPath('data.setup.vacation_mode', false);
        DB::transaction(fn () => app(NewProcurementAvailability::class)->assertAvailable($organization->id));
    }

    public function test_staff_cannot_change_vacation_mode(): void
    {
        [$organization, $staff] = $this->vendorFixture('STORE_STAFF');
        $this->signInVendor($staff);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => 1, 'vacation_mode' => true])->assertForbidden();
    }

    public function test_delivery_vehicles_support_categories_images_mixer_capacity_and_default_coverage(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $image = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'VEHICLE_IMAGE', 'file' => UploadedFile::fake()->image('vehicle.png')])->assertCreated()->json('data.file_id');
        $this->getJson('/api/v1/vendors/onboarding/files/'.$image)->assertOk();
        $vehicle = ['vehicle_category' => 'TRUCK', 'vehicle_type' => 'CONCRETE_MIXER', 'name' => 'Mixer one', 'brand' => 'Sample brand', 'capacity_kg' => 24000, 'number_available' => 3, 'mixer_capacity_m3' => 6, 'image_file_id' => $image, 'heavy_classification' => 'HEAVY', 'base_fee_centavos' => 50000, 'per_km_centavos' => 2500, 'cargo_length_m' => 4];
        $saved = $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => 1, 'fulfillment_method' => 'VENDOR_DELIVERY', 'bulk_capability' => true, 'delivery' => [], 'vehicles' => [$vehicle]])->assertOk();
        $id = $saved->json('data.setup.vehicles.0.id');
        $saved->assertJsonPath('data.setup.vehicles.0.vehicle_category', 'TRUCK')->assertJsonPath('data.setup.vehicles.0.cargo_length_m', null)->assertJsonPath('data.setup.vehicles.0.maximum_distance_km', 50);
        self::assertCount(1, app(DeliveryRecommendationService::class)->eligibleVehicles($organization->id));
        self::assertSame(0, DB::table('store_media')->where('file_id', $image)->count());
        $buyer = User::factory()->create(['account_type' => 'BUYER']);
        $buyerId = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $buyerId, 'user_id' => $buyer->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $orderId = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $orderId, 'reference' => 'DELIVERY-TEST', 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $organization->id, 'procurement_type' => 'ITEM_BASED', 'order_state' => 'CONFIRMED', 'fulfillment_method' => 'VENDOR_DELIVERY', 'payment_method' => 'COD', 'commercial_total_centavos' => 100000, 'created_at' => now(), 'updated_at' => now()]);
        $load = ['material_kind' => 'READY_MIXED_CONCRETE', 'weight_kg' => 24000, 'volume_m3' => 10, 'distance_meters' => 10000, 'heavy_vehicle_restriction' => false, 'intended_location' => ['latitude' => 14, 'longitude' => 121], 'route_destination' => ['latitude' => 14, 'longitude' => 121], 'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
        $snapshotId = app(ConfirmedDeliverySnapshot::class)->record($owner, $orderId, $load, [['vehicle_id' => $id, 'number_of_vehicles' => 2, 'total_vehicle_trips' => 2]], 150000, 'Two mixer trips, confirmed drop-off.', now('Asia/Manila')->toDateString());
        $frozen = DB::table('order_delivery_snapshots')->where('id', $snapshotId)->first();
        $version = $saved->json('data.organization.lock_version');
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $version, 'vehicles' => [['id' => $id, 'active' => false]]])->assertOk();
        self::assertSame([], app(DeliveryRecommendationService::class)->eligibleVehicles($organization->id));
        self::assertSame(1, DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $id)->count());
        self::assertSame($frozen->snapshot, DB::table('order_delivery_snapshots')->where('id', $snapshotId)->value('snapshot'));
        foreach (['update', 'delete'] as $operation) {
            try {
                DB::transaction(function () use ($snapshotId, $operation): void {
                    $query = DB::table('order_delivery_snapshots')->where('id', $snapshotId);
                    if ($operation === 'update') {
                        $query->update(['final_charge_centavos' => 1]);
                    } else {
                        $query->delete();
                    }
                });
                self::fail('Accepted delivery history must be immutable.');
            } catch (QueryException $exception) {
                self::assertStringContainsString('immutable', strtolower($exception->getMessage()));
            }
        }

    }

    public function test_delivery_rejects_category_mismatch_and_cross_vendor_images(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $image = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'VEHICLE_IMAGE', 'file' => UploadedFile::fake()->image('vehicle.png')])->assertCreated()->json('data.file_id');
        [, $otherOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($otherOwner);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$image)->assertNotFound();
        $vehicle = ['vehicle_category' => 'VAN', 'vehicle_type' => 'CONCRETE_MIXER', 'name' => 'Invalid', 'capacity_kg' => 1000, 'number_available' => 1, 'mixer_capacity_m3' => 2, 'heavy_classification' => 'HEAVY', 'image_file_id' => $image];
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => 1, 'vehicles' => [$vehicle]])->assertUnprocessable();
        $vehicle['vehicle_category'] = 'TRUCK';
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => 1, 'vehicles' => [$vehicle]])->assertNotFound();
        self::assertSame(0, DB::table('vendor_vehicles')->count());
    }

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        Storage::fake('local');
        config()->set('services.cloudinary.cloud_name', '');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_commission_acceptance_is_versioned_explicit_and_owned_by_verification(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'SOLE_PROPRIETORSHIP']);
        $this->signInVendor($owner);
        $snapshot = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        self::assertTrue($snapshot['verification']['commission_terms']['can_accept']);
        self::assertFalse($snapshot['verification']['commission_terms']['accepted']);
        self::assertSame('STORE_VERIFICATION', collect($snapshot['requirements'])->firstWhere('key', 'commission_terms')['workstream']);
        self::assertCount(10, $snapshot['step_completion']);
        $version = $snapshot['verification']['commission_terms']['agreement']['id'];
        $input = ['organization_lock_version' => $snapshot['organization']['lock_version'], 'agreement_version_id' => $version, 'accepted' => true];
        $this->withHeader('Idempotency-Key', (string) Str::uuid7());
        $this->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertOk()->assertJsonPath('data.verification.commission_terms.accepted', true);
        $this->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertOk();
        self::assertSame(1, DB::table('agreement_acceptances')->where('vendor_organization_id', $organization->id)->where('agreement_version_id', $version)->count());
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'section' => 'STORE_VERIFICATION', 'requirement_key' => 'commission_terms', 'status' => 'COMPLETED', 'submitted_at' => null]);
        $this->assertDatabaseHas('audit_logs', ['action' => 'VENDOR_COMMISSION_TERMS_ACCEPTED', 'actor_user_id' => $owner->id]);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertConflict();
        $input['organization_lock_version'] = $organization->fresh()->lock_version;
        $input['agreement_version_id'] = (string) Str::uuid7();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertConflict()->assertJsonPath('errors.0.code', 'AGREEMENT_VERSION_CONFLICT');
    }

    public function test_commission_acceptance_rejects_missing_consent_and_unapproved_authority_or_staff(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'CORPORATION']);
        $this->signInVendor($owner);
        $snapshot = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        self::assertFalse($snapshot['verification']['commission_terms']['can_accept']);
        $input = ['organization_lock_version' => $snapshot['organization']['lock_version'], 'agreement_version_id' => $snapshot['verification']['commission_terms']['agreement']['id'], 'accepted' => false];
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertUnprocessable();
        $this->postJson('/api/v1/vendors/account/agreements', ['version_ids' => [$input['agreement_version_id']]])->assertUnprocessable()->assertJsonPath('errors.0.code', 'COMMISSION_VERIFICATION_REQUIRED');
        $input['accepted'] = true;
        $this->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertUnprocessable()->assertJsonPath('errors.0.code', 'AUTHORITY_REQUIRED');
        [, $manager] = $this->vendorFixture('STORE_MANAGER', $organization);
        $this->signInVendor($manager);
        $this->postJson('/api/v1/vendors/onboarding/verification/commission', $input)->assertForbidden();
        self::assertSame(0, DB::table('agreement_acceptances')->where('vendor_organization_id', $organization->id)->count());
    }

    public function test_setup_completion_does_not_record_commission_consent(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'SOLE_PROPRIETORSHIP']);
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        DB::table('store_profiles')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'public_store_name' => 'Setup test store', 'description' => 'Construction materials', 'fulfillment_method' => 'SELF_PICKUP', 'bulk_capability' => true, 'status' => 'IN_PROGRESS', 'created_at' => now(), 'updated_at' => now()]);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/setup/complete', ['organization_lock_version' => $organization->fresh()->lock_version])->assertUnprocessable()->assertJsonPath('errors.0.code', 'STORE_PROFILE_MEDIA_REQUIRED');
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('logo.png')])->assertCreated();
        $banner = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('banner.png')])->assertCreated()->json('data.id');
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/setup/complete', ['organization_lock_version' => $organization->fresh()->lock_version])->assertUnprocessable()->assertJsonPath('errors.0.code', 'STORE_OPERATION_REQUIRED');
        app(StoreOperatingSchedule::class)->replaceWeekly((string) DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->value('id'), $this->weeklyOperatingSchedule());
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/setup/complete', ['organization_lock_version' => $organization->fresh()->lock_version])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PAYMENT_CONNECTION_REQUIRED');
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'environment' => 'TEST', 'provider_associated_at' => now(), 'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'provider_account_id' => 'acct_test_commission', 'capabilities' => json_encode(['account_verification' => true]), 'created_at' => now(), 'updated_at' => now()]);
        $result = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/vendors/onboarding/setup/complete', ['organization_lock_version' => $organization->fresh()->lock_version])->assertAccepted();
        $result->assertJsonPath('data.setup.status', 'COMPLETED')->assertJsonPath('data.verification.commission_terms.accepted', false);
        self::assertSame(0, DB::table('agreement_acceptances')->where('vendor_organization_id', $organization->id)->count());
        self::assertTrue(collect($result->json('data.activation.readiness.blockers'))->contains('key', 'commission_terms'));
        $this->deleteJson('/api/v1/vendors/onboarding/media/'.$banner)->assertOk()
            ->assertJsonPath('data.setup.status', 'IN_PROGRESS')
            ->assertJsonPath('data.setup.profile.status', 'DRAFT')
            ->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_setup_status' => 'IN_PROGRESS']);
    }

    public function test_store_operation_requires_all_days_validates_times_and_is_public_only_after_activation(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        $schedule = $this->weeklyOperatingSchedule();
        $schedule[0]['closes_at'] = '08:00';
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'operating_schedule' => $schedule])->assertUnprocessable();
        self::assertSame(0, DB::table('operating_hours')->count());
        $schedule = $this->weeklyOperatingSchedule();
        $saved = $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'operating_schedule' => $schedule])->assertOk();
        $saved->assertJsonCount(7, 'data.setup.operating_schedule')->assertJsonPath('data.setup.operating_schedule.6.status', 'CLOSED');
        $saved->assertJsonPath('data.setup.status', 'IN_PROGRESS');
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'store_operation', 'status' => 'COMPLETED']);
        $this->assertDatabaseHas('audit_logs', ['action' => 'VENDOR_STORE_OPERATION_UPDATED', 'actor_user_id' => $owner->id]);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertNotFound();
        $this->getJson('/api/v1/stores')->assertOk()->assertJsonCount(0, 'data');
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'public_store_name' => 'Schedule test store', 'description' => 'Building materials', 'bulk_capability' => false, 'fulfillment_method' => 'SELF_PICKUP'])->assertOk();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('schedule-logo.png')])->assertCreated();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('schedule-banner.png')])->assertCreated();
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'environment' => 'TEST', 'provider_associated_at' => now(), 'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'provider_account_id' => 'acct_test_schedule', 'capabilities' => json_encode(['account_verification' => true]), 'created_at' => now(), 'updated_at' => now()]);
        $this->postJson('/api/v1/vendors/onboarding/setup/complete', ['organization_lock_version' => $organization->fresh()->lock_version], ['Idempotency-Key' => (string) Str::uuid7()])->assertAccepted();
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_activation_status' => 'ACTIVE', 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk()->assertJsonPath('data.operating_schedule.6.status', 'CLOSED');
        $this->getJson('/api/v1/stores')->assertOk()->assertJsonCount(1, 'data');
        DB::table('store_operation_date_overrides')->insert(['id' => (string) Str::uuid7(), 'store_profile_id' => DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->value('id'), 'specific_date' => now('Asia/Manila')->toDateString(), 'is_closed' => true, 'opens_at' => null, 'closes_at' => null, 'created_by_user_id' => $owner->id, 'updated_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk()->assertJsonPath('data.effective_source', 'DATE_OVERRIDE')->assertJsonPath('data.effective_today.status', 'CLOSED');
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_setup_status' => 'COMPLETED']);
        $schedule[5]['closes_at'] = '15:00';
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'operating_schedule' => $schedule])->assertOk();
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_setup_status' => 'COMPLETED', 'store_activation_status' => 'ACTIVE', 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->assertDatabaseHas('store_profiles', ['vendor_organization_id' => $organization->id, 'status' => 'COMPLETED']);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk()->assertJsonPath('data.operating_schedule.5.closes_at', '15:00');
    }

    /** @return list<array{day_of_week: int, status: string, opens_at: ?string, closes_at: ?string}> */
    private function weeklyOperatingSchedule(): array
    {
        return array_map(fn (int $day): array => ['day_of_week' => $day, 'status' => $day === 7 ? 'CLOSED' : 'OPEN', 'opens_at' => $day === 7 ? null : '08:00', 'closes_at' => $day === 7 ? null : '17:00'], range(1, 7));
    }

    public function test_upload_budget_is_shared_by_organization_and_does_not_block_reads(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        [, $manager] = $this->vendorFixture('STORE_MANAGER', $organization);
        $this->signInVendor($owner);
        for ($attempt = 0; $attempt < 20; $attempt++) {
            $this->postJson('/api/v1/vendors/onboarding/documents', [])->assertUnprocessable();
        }
        $this->signInVendor($manager);
        $this->postJson('/api/v1/vendors/onboarding/media', [])
            ->assertStatus(429)->assertHeader('Retry-After')
            ->assertJsonPath('errors.0.code', 'RATE_LIMITED');
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        $this->travel(61)->seconds();
        $this->postJson('/api/v1/vendors/onboarding/media', [])->assertUnprocessable();
    }

    public function test_personal_photo_is_scanned_private_versioned_and_owner_only(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $scanner = $this->mock(ProfilePhotoScanner::class);
        $scanner->shouldReceive('assertClean')->twice();
        $version = (int) $owner->fresh()->lock_version;
        $result = $this->post('/api/v1/vendors/account/photo', ['photo' => UploadedFile::fake()->image('portrait.png', 64, 64), 'lock_version' => $version])
            ->assertOk()->assertJsonPath('data.lock_version', $version + 1);
        $url = $result->json('data.avatar_url');
        $owner->refresh();
        $this->get($url)->assertOk()->assertHeader('Content-Type', 'image/png');
        $this->get('/api/v1/vendors/account/photo')->assertForbidden();
        $this->post('/api/v1/vendors/account/photo', ['photo' => UploadedFile::fake()->image('replacement.png'), 'lock_version' => $version])->assertConflict();
        [, $other] = $this->vendorFixture('OWNER');
        $this->signInVendor($other);
        $this->get($url)->assertNotFound();
        $this->post('/api/v1/admin/account/photo', [])->assertForbidden();
        $this->assertDatabaseHas('audit_logs', ['action' => 'PROFILE_PHOTO_UPDATED', 'actor_user_id' => $owner->getKey()]);
    }

    public function test_admin_and_vendor_staff_can_upload_their_own_photo(): void
    {
        $scanner = $this->mock(ProfilePhotoScanner::class);
        $scanner->shouldReceive('assertClean')->twice();
        $admin = $this->adminFixture('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $this->post('/api/v1/admin/account/photo', ['photo' => UploadedFile::fake()->image('admin.png'), 'lock_version' => $admin->fresh()->lock_version])->assertOk();
        [, $staff] = $this->vendorFixture('STORE_STAFF');
        $this->signInVendor($staff);
        $this->post('/api/v1/vendors/account/photo', ['photo' => UploadedFile::fake()->image('staff.png'), 'lock_version' => $staff->fresh()->lock_version])->assertOk();
    }

    public function test_personal_photo_rejects_invalid_files_and_scanner_failure_preserves_profile(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->post('/api/v1/vendors/account/photo', ['photo' => UploadedFile::fake()->create('fake.svg', 1, 'image/svg+xml'), 'lock_version' => 1])->assertUnprocessable();
        $scanner = $this->mock(ProfilePhotoScanner::class);
        $scanner->shouldReceive('assertClean')->once()->andThrow(new AuthenticationException('PHOTO_SCANNER_UNAVAILABLE', 'Unavailable.', 503));
        $this->post('/api/v1/vendors/account/photo', ['photo' => UploadedFile::fake()->image('portrait.png'), 'lock_version' => 1])->assertStatus(503);
        self::assertNull($owner->refresh()->profile_photo_key);
    }

    public function test_snapshot_exposes_independent_workstreams_and_setup_can_start_first(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);

        $snapshot = $this->getJson('/api/v1/vendors/onboarding')
            ->assertOk()
            ->assertJsonPath('data.welcome_required', true)
            ->assertJsonPath('data.sections.STORE_VERIFICATION.key', 'STORE_VERIFICATION')
            ->assertJsonPath('data.sections.STORE_VERIFICATION.label', 'Store Verification')
            ->assertJsonPath('data.sections.STORE_SETUP.key', 'STORE_SETUP')
            ->assertJsonPath('data.sections.STORE_SETUP.label', 'Store Setup');

        self::assertSame(15, $snapshot->json('data.sections.STORE_VERIFICATION.total'));
        self::assertSame(5, $snapshot->json('data.sections.STORE_SETUP.total'));

        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => 1,
            'public_store_name' => 'First Build Supply',
            'bulk_capability' => true,
            'fulfillment_method' => 'SELF_PICKUP',
        ])->assertOk()->assertJsonPath('data.setup.profile.public_store_name', 'First Build Supply');

        self::assertSame('IN_PROGRESS', $organization->refresh()->store_setup_status);
        self::assertSame('NOT_STARTED', $organization->store_verification_status);
        self::assertNotNull(DB::table('store_profiles')->where('vendor_organization_id', $organization->getKey())->first());

        $this->postJson('/api/v1/vendors/onboarding/welcome/dismiss')
            ->assertOk()
            ->assertJsonPath('data.welcome_required', false);
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.welcome_required', false);
    }

    public function test_tax_attestation_is_owner_only_and_tax_relief_requires_an_explicit_choice(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        [, $manager] = $this->vendorFixture('STORE_MANAGER', $organization);

        $this->signInVendor($manager);
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-001',
                'tin' => '12345678900000',
                'owner_attested' => true,
                'tax_relief_claimed' => false,
            ],
        ])->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');

        $this->signInVendor($owner);
        $response = $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-001',
                'tin' => '12345678900000',
                'entity_class' => 'CORPORATION',
                'registration_category' => 'DOMESTIC',
                'vat_category' => 'VAT',
                'owner_attested' => true,
                'tax_relief_claimed' => false,
            ],
        ])->assertOk();

        self::assertStringNotContainsString('TEST-TAXPAYER-001', $response->getContent());
        self::assertSame(false, $response->json('data.verification.tax_profile.details.tax_relief_claimed'));
        $this->assertDatabaseHas('vendor_onboarding_steps', [
            'vendor_organization_id' => $organization->getKey(),
            'requirement_key' => 'tax_relief_evidence',
            'status' => 'NOT_APPLICABLE',
        ]);
        $taxVersionId = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->getKey())->value('current_version_id');
        self::assertIsString($taxVersionId);
        $this->assertDatabaseHas('withholding_assignments', [
            'vendor_tax_profile_version_id' => $taxVersionId,
            'tax_rule_version_id' => DB::table('tax_rule_versions')->where('environment', 'DEMO')->where('code', 'DEMO_PLATFORM_WITHHOLDER')->where('version', 1)->value('id'),
            'rate_basis_points' => 50,
        ]);
    }

    public function test_rental_supplier_categories_are_rejected(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);

        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'classification' => [
                'supplier_type' => 'SPECIALIZED_SUPPLIER',
                'niches' => ['Construction Vehicle Rental'],
            ],
        ])->assertUnprocessable()->assertJsonPath('errors.0.code', 'CLASSIFICATION_UNSUPPORTED');
    }

    public function test_registration_evidence_uses_the_business_type_authority(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'business_type' => 'CORPORATION',
        ])->assertOk();

        $this->submittedEvidenceFixture('business_registration', 'sec-registration.pdf');
        $this->assertDatabaseHas('business_documents', [
            'vendor_organization_id' => $organization->getKey(),
            'requirement_key' => 'business_registration',
            'document_type' => 'SEC_REGISTRATION',
        ]);
    }

    public function test_document_upload_accepts_generated_client_json_metadata_parts(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);

        foreach (['{}', '{"document_number":"TEST-REGISTRATION"}'] as $json) {
            $this->post('/api/v1/vendors/onboarding/documents', [
                'requirement_key' => 'business_registration',
                'metadata' => UploadedFile::fake()->createWithContent('blob', $json),
                'file' => $this->pdf('registration.pdf'),
            ])->assertCreated();
        }
    }

    public function test_document_upload_rejects_invalid_json_metadata_parts(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);

        foreach (['invalid', '[]', '{"nested":{"value":"invalid"}}', '{"value":"'.str_repeat('a', 256).'"}', str_repeat('a', 65537)] as $json) {
            $this->post('/api/v1/vendors/onboarding/documents', [
                'requirement_key' => 'business_registration',
                'metadata' => UploadedFile::fake()->createWithContent('blob', $json),
                'file' => $this->pdf('registration.pdf'),
            ], ['Accept' => 'application/json'])->assertUnprocessable();
        }
    }

    public function test_tax_relief_selection_does_not_create_review_evidence(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-RELIEF',
                'tin' => '12345678900000',
                'owner_attested' => true,
                'tax_relief_claimed' => true, 'declaration_year' => 2026,
            ],
        ])->assertOk();

        $versionId = $this->post('/api/v1/vendors/onboarding/documents', [
            'requirement_key' => 'tax_relief_evidence',
            'metadata' => ['valid_from' => '2026-01-01', 'valid_until' => '2026-12-31'],
            'file' => $this->pdf('tax-relief.pdf'),
        ])->assertCreated()->json('data.id');
        $this->assertDatabaseHas('vendor_pending_documents', ['file_id' => $versionId, 'requirement_key' => 'tax_relief_evidence']);
        $this->assertDatabaseMissing('tax_evidence', ['file_id' => $versionId]);
    }

    public function test_submission_requires_an_explicit_tax_relief_declaration(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['store_email' => 'verified@example.test', 'store_email_verified_at' => now()]);
        $this->signInVendor($owner);

        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-002',
                'tin' => '98765432100000',
                'owner_attested' => true,
            ],
        ])->assertOk();

        $response = $this->postJson('/api/v1/vendors/onboarding/verification/submit', [
            'lock_version' => $organization->refresh()->lock_version,
            'privacy_acknowledged' => true,
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();

        $blockers = $response->json('errors.0.details.blockers');
        self::assertIsArray($blockers);
        self::assertContains('tax_relief_claimed', array_column($blockers, 'key'));
    }

    public function test_failed_or_expired_store_email_otp_preserves_the_verified_email(): void
    {
        $originalVerifiedAt = now()->toDateTimeString();
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, [
            'store_email' => 'verified@example.test',
            'store_email_verified_at' => $originalVerifiedAt,
        ]);
        $this->signInVendor($owner);
        $code = '123456';
        $this->mock(OtpCodeGenerator::class)->shouldReceive('sixDigits')->once()->andReturn($code);

        $this->postJson('/api/v1/vendors/onboarding/store-email', ['email' => 'replacement@example.test'])
            ->assertStatus(202);
        $this->postJson('/api/v1/vendors/onboarding/store-email/confirm', [
            'email' => 'replacement@example.test',
            'code' => '000000',
        ])->assertUnprocessable()->assertJsonPath('errors.0.code', 'OTP_INVALID_OR_EXPIRED');

        $organization->refresh();
        self::assertSame('verified@example.test', $organization->store_email);
        self::assertNotNull($organization->store_email_verified_at);
        self::assertSame($originalVerifiedAt, substr((string) $organization->store_email_verified_at, 0, 19));
        self::assertSame('replacement@example.test', $organization->pending_store_email);

        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['pending_store_email_expires_at' => now()->subSecond()]);
        $this->postJson('/api/v1/vendors/onboarding/store-email/confirm', [
            'email' => 'replacement@example.test',
            'code' => $code,
        ])->assertUnprocessable()->assertJsonPath('errors.0.code', 'OTP_INVALID_OR_EXPIRED');
        self::assertSame('verified@example.test', $organization->refresh()->store_email);
    }

    public function test_vendor_can_submit_verification_once_and_replay_the_same_idempotent_request(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['store_email' => 'owner@example.test', 'store_email_verified_at' => now()]);
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization, false);

        $key = (string) Str::uuid7();
        $payload = [
            'lock_version' => $organization->refresh()->lock_version,
            'privacy_acknowledged' => true,
        ];
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', $payload, ['Idempotency-Key' => $key])
            ->assertStatus(202)
            ->assertJsonPath('data.verification.status', 'PENDING_VERIFICATION');
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', $payload, ['Idempotency-Key' => $key])
            ->assertStatus(202)
            ->assertJsonPath('data.verification.status', 'PENDING_VERIFICATION');
        self::assertSame(1, DB::table('idempotency_records')->where('endpoint', 'VENDOR_VERIFICATION_SUBMIT')->count());

        $this->postJson('/api/v1/vendors/onboarding/verification/submit', [
            'lock_version' => 999,
            'privacy_acknowledged' => true,
        ], ['Idempotency-Key' => $key])->assertConflict()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
    }

    public function test_private_evidence_is_scoped_to_the_vendor_and_authorized_admin_role(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->submittedEvidenceFixture('business_registration', 'registration.pdf');
        $fileId = (string) DB::table('business_document_versions')->where('id', $versionId)->value('file_id');

        $vendorFileUrl = $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertOk()->json('data.url');
        self::assertIsString($vendorFileUrl);
        self::assertStringContainsString('signature=', $vendorFileUrl);

        [, $staff] = $this->vendorFixture('STORE_STAFF', $organization);
        $this->signInVendor($staff);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertForbidden();
        $this->get($vendorFileUrl)->assertForbidden();

        [, $otherOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($otherOwner);
        $this->get($vendorFileUrl)->assertNotFound();
        $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)
            ->assertNotFound()
            ->assertJsonPath('errors.0.code', 'RESOURCE_NOT_FOUND');

        $support = $this->adminFixture('ADMIN_SUPPORT');
        $this->signInAdmin($support);
        $this->getJson('/api/v1/admin/vendor-verification/files/'.$fileId)
            ->assertForbidden()
            ->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');

        $reviewer = $this->adminFixture('ADMIN_VENDOR_VERIFICATION');
        $this->signInAdmin($reviewer);
        $adminFileUrl = $this->getJson('/api/v1/admin/vendor-verification/files/'.$fileId)->assertOk()->json('data.url');
        self::assertIsString($adminFileUrl);
        self::assertStringContainsString('signature=', $adminFileUrl);

        $this->get($adminFileUrl)->assertOk()->assertHeader('Cache-Control', 'no-store, private');
        $this->travel(6)->minutes();
        $this->get($adminFileUrl)->assertForbidden();
        self::assertSame('ACTIVE', $organization->refresh()->account_status);
    }

    public function test_store_media_preview_is_private_and_rechecks_ownership_on_download(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => 1,
            'public_store_name' => 'Preview Supply',
        ])->assertOk();
        $image = UploadedFile::fake()->createWithContent('logo.png', base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=', true));
        $this->post('/api/v1/vendors/onboarding/media', ['file' => $image, 'kind' => 'LOGO'], ['Accept' => 'application/json'])->assertSuccessful();
        $fileId = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data.setup.media.0.file_id');
        self::assertIsString($fileId);
        $url = $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertOk()->json('data.url');
        self::assertIsString($url);
        $this->get($url)->assertOk()->assertHeader('Content-Type', 'image/png');

        [, $otherOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($otherOwner);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertNotFound();
        $this->getJson($url)->assertNotFound();

        $this->signInVendor($owner);
        DB::table('files')->where('id', $fileId)->update(['scan_state' => 'PENDING']);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertNotFound();
    }

    public function test_setup_checklist_uses_current_saved_profile_media_and_five_required_items(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $initial = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        self::assertSame(5, $initial['sections']['STORE_SETUP']['total']);
        self::assertSame('NOT_STARTED', $initial['sections']['STORE_SETUP']['status']);
        self::assertSame(['public_store_profile', 'bulk_capability', 'fulfillment_method', 'payment_connection', 'store_operation'], array_column($initial['sections']['STORE_SETUP']['steps'], 'key'));
        self::assertSame('NOT_STARTED', $initial['sections']['STORE_SETUP']['steps'][0]['status']);
        $this->postJson('/api/v1/vendors/account/invitations', ['email' => 'optional-staff@example.test', 'invitee_name' => 'Optional Staff', 'role' => 'STORE_STAFF'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $withTeam = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        self::assertSame($initial['sections']['STORE_SETUP']['progress'], $withTeam['sections']['STORE_SETUP']['progress']);
        self::assertSame(array_column($initial['activation']['readiness']['blockers'], 'key'), array_column($withTeam['activation']['readiness']['blockers'], 'key'));

        $saved = $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => $organization->refresh()->lock_version,
            'public_store_name' => 'Checklist Supply', 'description' => 'Building materials',
            'bulk_capability' => false, 'fulfillment_method' => 'SELF_PICKUP',
        ])->assertOk()->json('data');
        self::assertSame('IN_PROGRESS', $saved['sections']['STORE_SETUP']['steps'][0]['status']);
        self::assertSame(2, $saved['sections']['STORE_SETUP']['complete']);
        self::assertSame('NOT_APPLICABLE', collect($saved['requirements'])->firstWhere('key', 'delivery_configuration')['status']);

        $logo = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('logo.png')])->assertCreated()->json('data.id');
        $this->getJson('/api/v1/vendors/onboarding')->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $banner = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('banner.png')])->assertCreated()->json('data.id');
        $this->getJson('/api/v1/vendors/onboarding')->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'COMPLETED')->assertJsonPath('data.sections.STORE_SETUP.complete', 3);
        $this->deleteJson('/api/v1/vendors/onboarding/media/'.$banner)->assertOk()->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS')->assertJsonPath('data.sections.STORE_SETUP.complete', 2);
        $replacementBanner = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('replacement.png')])->assertCreated()->json('data.id');
        $this->getJson('/api/v1/vendors/onboarding')->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'COMPLETED');
        $this->deleteJson('/api/v1/vendors/onboarding/media/'.$banner)->assertStatus(409);
        $this->deleteJson('/api/v1/vendors/onboarding/media/'.$logo)->assertOk()->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $this->deleteJson('/api/v1/vendors/onboarding/media/'.$replacementBanner)->assertOk()->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('replacement-logo.png')])->assertCreated();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('replacement-banner.png')])->assertCreated();
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'description' => ''])->assertOk()->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $this->getJson('/api/v1/vendors/onboarding')->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'IN_PROGRESS');
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'description' => 'Building materials'])->assertOk()->assertJsonPath('data.sections.STORE_SETUP.steps.0.status', 'COMPLETED');
    }

    public function test_removed_saved_vehicle_reopens_delivery_without_deleting_its_record(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $image = $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'VEHICLE_IMAGE', 'file' => UploadedFile::fake()->image('truck.png')])->assertCreated()->json('data.file_id');
        $vehicle = ['vehicle_category' => 'TRUCK', 'vehicle_type' => 'FLATBED_TRUCK', 'name' => 'Delivery truck', 'capacity_kg' => 1000, 'number_available' => 1, 'cargo_length_m' => 2, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'NOT_HEAVY', 'image_file_id' => $image, 'base_fee_centavos' => 1000, 'per_km_centavos' => 100];
        $saved = $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'fulfillment_method' => 'VENDOR_DELIVERY', 'delivery' => [], 'vehicles' => [$vehicle], 'form_state' => '{}'])->assertOk()->json('data');
        $id = $saved['setup']['vehicles'][0]['id'];
        self::assertSame('COMPLETED', collect($saved['requirements'])->firstWhere('key', 'delivery_configuration')['status']);
        $removed = $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'vehicles' => [['id' => $id, 'active' => false]], 'form_state' => '{}'])->assertOk()->json('data');
        self::assertFalse($removed['setup']['vehicles'][0]['active']);
        self::assertSame('IN_PROGRESS', collect($removed['requirements'])->firstWhere('key', 'delivery_configuration')['status']);
        self::assertSame('IN_PROGRESS', collect($removed['sections']['STORE_SETUP']['steps'])->firstWhere('key', 'fulfillment_method')['status']);
        $this->assertDatabaseHas('vendor_vehicles', ['id' => $id, 'active' => false]);
    }

    public function test_admin_queue_requires_clean_evidence_and_records_immutable_decisions(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->submittedEvidenceFixture('business_registration', 'registration.pdf');
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_verification_status' => 'PENDING_VERIFICATION']);

        $reviewer = $this->adminFixture('ADMIN_VENDOR_VERIFICATION');
        $this->signInAdmin($reviewer);
        $this->getJson('/api/v1/admin/vendor-verification')
            ->assertOk()
            ->assertJsonPath('data.0.id', $organization->getKey());
        $this->getJson('/api/v1/admin/vendor-verification/'.$organization->getKey())
            ->assertOk()
            ->assertJsonPath('data.organization.id', $organization->getKey());

        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/lgu_permit/decision', [
            'decision' => 'APPROVED',
        ], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'REQUIREMENT_NOT_SUBMITTED');

        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'CHANGES_REQUIRED',
        ], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertUnprocessable();

        $response = $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'APPROVED',
            'lock_version' => DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->getKey())->where('requirement_key', 'business_registration')->value('lock_version'),
            'expiration_kind' => 'NO_EXPIRATION',
            'evidence_source' => 'TEST_UPLOAD',
            'remarks' => 'Evidence matched the submitted requirement.',
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();

        self::assertSame('APPROVED', $response->json('data.documents.0.status'));
        $this->assertDatabaseHas('business_document_reviews', [
            'business_document_version_id' => $versionId,
            'decision' => 'APPROVED',
            'evidence_source' => 'TEST_UPLOAD',
        ]);
        self::assertSame(1, DB::table('business_document_reviews')->where('business_document_version_id', $versionId)->count());
    }

    public function test_test_account_creation_is_private_immediate_durable_and_not_duplicated(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'SOLE_PROPRIETORSHIP']);
        $this->signInVendor($owner);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_email' => 'store@example.test', 'store_email_verified_at' => now()]);
        config()->set('services.xendit.secret_key', 'xnd_development_synthetic_fixture');
        config()->set('services.xendit.mode', 'TEST');
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
        Http::preventStrayRequests();
        Http::fake([
            'https://api.xendit.co/v2/accounts' => Http::response([
                'id' => 'acct_test_8763', 'status' => 'LIVE', 'type' => 'OWNED',
                'email' => 'store@example.test', 'public_profile' => ['business_name' => $organization->store_name],
                'country' => 'PH', 'created' => '2026-09-25T01:00:00Z',
            ]),
            'https://api.xendit.co/v2/accounts/acct_test_8763' => Http::sequence()
                ->push(['id' => 'acct_test_8763', 'type' => 'OWNED', 'status' => 'REGISTERED'])
                ->push(['id' => 'acct_test_8763', 'type' => 'OWNED', 'status' => 'REGISTERED'])
                ->push(['id' => 'acct_test_8763', 'type' => 'OWNED', 'status' => 'LIVE']),
        ]);
        foreach ([1, 2] as $attempt) {
            $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])
                ->assertOk()->assertHeader('Cache-Control', 'no-store, private')->assertJsonPath('data.status', 'PENDING')
                ->assertJsonPath('data.environment', 'TEST')->assertDontSee('xnd_development_synthetic_fixture')->assertJsonMissingPath('data.invitation_url');
        }
        Http::assertSentCount(2);
        Http::assertSent(fn ($request) => $request->method() === 'POST' && $request['email'] === 'store@example.test'
            && $request['type'] === 'OWNED' && $request['public_profile']['business_name'] === $organization->store_name);
        $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $organization->id, 'provider_account_id' => 'acct_test_8763', 'provider_status' => 'REGISTERED', 'connection_status' => 'PENDING']);
        self::assertSame('SOLE_PROPRIETORSHIP', $organization->fresh()->business_type);
        self::assertSame(1, DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->count());
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.setup.payment.connection_status', 'PENDING')
            ->assertJsonPath('data.setup.payment.account_suffix', '8763')->assertDontSee('acct_test_8763');
        self::assertContains('payment_connection', array_column(app(StoreActivationGate::class)->evaluate($organization->id)['blockers'], 'key'));
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'PENDING');
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'CONNECTED_TEST');
        $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $organization->id, 'provider_status' => 'LIVE', 'connection_status' => 'CONNECTED_TEST']);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', ['provider_account_id' => 'arbitrary', 'invitation_url' => 'https://example.test'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertNotContains('payment_connection', array_column(app(StoreActivationGate::class)->evaluate($organization->id)['blockers'], 'key'));
        foreach (['NOT_CONNECTED', 'CONNECTION_FAILED', 'CONNECTING'] as $state) {
            DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->update(['connection_status' => $state]);
            self::assertContains('payment_connection', array_column(app(StoreActivationGate::class)->evaluate($organization->id)['blockers'], 'key'));
        }
    }

    public function test_in_flight_connect_reservation_blocks_a_second_request(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $gateway = $this->mock(XenditAccountVerificationGateway::class);
        $gateway->shouldReceive('initiate')->once()->andReturnUsing(function () {
            $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])
                ->assertConflict()->assertJsonPath('errors.0.code', 'PROVIDER_ONBOARDING_UNCERTAIN');

            return ['provider_account_id' => 'acct_concurrent', 'status' => 'LIVE', 'provider_created_at' => null];
        });
        $gateway->shouldReceive('reconcile')->once()->andReturn(['provider_account_id' => 'acct_concurrent', 'status' => 'LIVE', 'capabilities' => []]);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.status', 'CONNECTED_TEST');
        self::assertSame(1, DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->count());
    }

    public function test_explicit_provider_rejections_remain_disconnected_and_allow_retry(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set('services.xendit.secret_key', 'xnd_development_synthetic_fixture');
        config()->set('services.xendit.mode', 'TEST');
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::sequence()->push(['error_code' => 'API_VALIDATION_ERROR'], 400)->push([], 401)->push(['error_code' => 'MAXIMUM_ACCOUNT_REACHED'], 400)]);
        foreach ([1, 2, 3] as $attempt) {
            $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])
                ->assertServiceUnavailable()->assertJsonPath('errors.0.code', 'PROVIDER_UNAVAILABLE')->assertDontSee('xnd_development_synthetic_fixture');
            $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $organization->id, 'provider_account_id' => null, 'connection_status' => 'CONNECTION_FAILED', 'onboarding_requested_at' => null]);
        }
        Http::assertSentCount(3);
        self::assertSame(3, DB::table('audit_logs')->where('action', 'VENDOR_PAYMENT_CONNECTION_FAILED')->count());
    }

    public function test_xendit_account_access_denial_exposes_a_safe_provider_request_reference(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set('services.xendit.secret_key', 'xnd_development_synthetic_fixture');
        config()->set('services.xendit.mode', 'TEST');
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response(['error_code' => 'DISALLOWED_OPERATION'], 403, ['Request-Id' => 'req_test_123'])]);

        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertServiceUnavailable()
            ->assertJsonPath('errors.0.code', 'PROVIDER_ACCOUNT_ACCESS_REQUIRED')
            ->assertSeeText('req_test_123')
            ->assertDontSee('xnd_development_synthetic_fixture');
        $this->assertDatabaseHas('vendor_payment_accounts', [
            'vendor_organization_id' => $organization->id,
            'connection_status' => 'CONNECTION_FAILED',
            'last_error_code' => 'PROVIDER_ACCOUNT_ACCESS_REQUIRED',
            'onboarding_requested_at' => null,
        ]);
        Http::assertSentCount(1);
        $audit = DB::table('audit_logs')->where('action', 'VENDOR_PAYMENT_CONNECTION_FAILED')->sole();
        self::assertSame('req_test_123', json_decode((string) $audit->after, true, 512, JSON_THROW_ON_ERROR)['provider_request_id']);
    }

    public function test_explicit_xendit_conflict_releases_creation_reservation_for_reviewed_retry(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set('services.xendit.secret_key', 'xnd_development_synthetic_fixture');
        config()->set('services.xendit.mode', 'TEST');
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response(['error_code' => 'DUPLICATE_ERROR'], 409, ['Request-Id' => 'req_conflict_123'])]);

        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertConflict()->assertJsonPath('errors.0.code', 'PROVIDER_ACCOUNT_CONFLICT')
            ->assertSeeText('req_conflict_123');
        $this->assertDatabaseHas('vendor_payment_accounts', [
            'vendor_organization_id' => $organization->id,
            'connection_status' => 'CONNECTION_FAILED',
            'last_error_code' => 'PROVIDER_ACCOUNT_CONFLICT',
            'onboarding_requested_at' => null,
            'provider_account_id' => null,
        ]);
        self::assertSame(1, DB::table('audit_logs')->where('action', 'VENDOR_PAYMENT_CONNECTION_FAILED')->count());
    }

    public function test_xendit_registration_webhook_authentication_reconciliation_and_replay(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'provider_account_id' => 'acct_test_001', 'provider_associated_at' => now(), 'connection_status' => 'PENDING', 'created_at' => now(), 'updated_at' => now()]);
        $payload = ['event' => 'account.registered', 'created' => '2026-09-25T01:00:00Z', 'data' => ['user_id' => 'acct_test_001', 'account_info' => ['payments_enabled' => false]]];
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload)->assertServiceUnavailable();
        config()->set('services.xendit.webhook_token', 'synthetic-test-callback');
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, ['x-callback-token' => 'wrong'])->assertUnauthorized();
        $gateway = $this->mock(XenditAccountVerificationGateway::class);
        $gateway->shouldReceive('reconcile')->once()->andThrow(new XenditProviderUnavailable('Synthetic provider outage'));
        $gateway->shouldReceive('reconcile')->once()->andReturn(['provider_account_id' => 'acct_test_001', 'status' => 'LIVE', 'capabilities' => []]);
        $headers = ['x-callback-token' => 'synthetic-test-callback'];
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, $headers)->assertServiceUnavailable();
        $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $organization->id, 'connection_status' => 'PENDING']);
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, $headers)->assertStatus(202)->assertJsonPath('data.duplicate', false);
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, $headers)->assertStatus(202)->assertJsonPath('data.duplicate', true);
        self::assertSame(1, DB::table('webhook_events')->where('provider', 'XENDIT')->count());
        $this->postJson('/api/v1/webhooks/xendit/account-verification', ['id' => 'legacy', 'status' => 'PASSED', 'account_id' => 'acct_test_001'], $headers)->assertUnprocessable();
    }

    public function test_manual_legacy_reference_and_staff_cannot_connect_or_reconcile(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'provider_account_id' => 'legacy', 'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'created_at' => now(), 'updated_at' => now()]);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertUnprocessable();
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.setup.payment.connection_status', 'NOT_CONNECTED');
        [, $staff] = $this->vendorFixture('STORE_MANAGER', $organization);
        $this->signInVendor($staff);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertForbidden();
    }

    public function test_pending_registration_and_outages_never_fabricate_connection(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'provider_account_id' => 'acct_pending', 'provider_associated_at' => now(), 'connection_status' => 'PENDING', 'created_at' => now(), 'updated_at' => now()]);
        $gateway = $this->mock(XenditAccountVerificationGateway::class);
        $gateway->shouldReceive('reconcile')->once()->andReturn(['provider_account_id' => 'acct_pending', 'status' => 'INVITED', 'capabilities' => ['account_verification' => true]]);
        $gateway->shouldReceive('reconcile')->once()->andThrow(new XenditProviderUnavailable);
        $gateway->shouldReceive('reconcile')->once()->andReturn(['provider_account_id' => 'acct_pending', 'status' => 'LIVE', 'capabilities' => []]);
        $gateway->shouldReceive('reconcile')->once()->andThrow(new XenditProviderUnavailable);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'PENDING');
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'PENDING')->assertJsonPath('data.provider_available', false);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'CONNECTED_TEST');
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'CONNECTED_TEST')->assertJsonPath('data.provider_available', false);
        self::assertSame(1, DB::table('audit_logs')->where('action', 'VENDOR_PAYMENT_REGISTRATION_RECONCILED')->count());
        self::assertSame(1, DB::table('notifications')->where('category', 'VENDOR_PAYMENT_CONNECTION')->count());
    }

    public function test_connect_requires_current_organizational_authority_and_does_not_retry_uncertain_creation(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'CORPORATION']);
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'AUTHORITY_REQUIRED');
        $this->assertDatabaseMissing('vendor_payment_accounts', ['vendor_organization_id' => $organization->id]);
        [$soleOrganization, $soleOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($soleOwner);
        $gateway = $this->mock(XenditAccountVerificationGateway::class);
        $gateway->shouldReceive('initiate')->once()->andThrow(new XenditProviderUnavailable);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertServiceUnavailable()->assertJsonPath('errors.0.code', 'PROVIDER_ONBOARDING_UNCERTAIN');
        $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $soleOrganization->id, 'connection_status' => 'CONNECTING', 'last_error_code' => 'PROVIDER_ONBOARDING_UNCERTAIN']);
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'PROVIDER_ONBOARDING_UNCERTAIN');
    }

    public function test_owner_and_delegated_manager_can_only_issue_fixed_team_roles(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        [, $manager] = $this->vendorFixture('STORE_MANAGER', $organization, true);

        $ownerKey = (string) Str::uuid7();
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendors/account/invitations', [
            'email' => 'blocked-manager@example.test',
            'invitee_name' => 'Blocked Manager',
            'role' => 'STORE_MANAGER',
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_setup_status' => 'COMPLETED']);
        $this->postJson('/api/v1/vendors/account/invitations', [
            'email' => 'new-manager@example.test',
            'invitee_name' => 'New Manager',
            'role' => 'STORE_MANAGER',
        ], ['Idempotency-Key' => $ownerKey])->assertStatus(202)->assertJsonMissingPath('data.token')->assertJsonMissingPath('data.invitation_url');
        $this->assertDatabaseHas('vendor_invitations', ['vendor_organization_id' => $organization->getKey(), 'normalized_email' => 'new-manager@example.test', 'role' => 'STORE_MANAGER']);

        $this->signInVendor($manager);
        $this->postJson('/api/v1/vendors/account/invitations', [
            'email' => 'another-manager@example.test',
            'invitee_name' => 'Another Manager',
            'role' => 'STORE_MANAGER',
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'ROLE_UNAVAILABLE');
        $this->postJson('/api/v1/vendors/account/invitations', [
            'email' => 'staff@example.test',
            'invitee_name' => 'Store Staff',
            'role' => 'STORE_STAFF',
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
    }

    public function test_team_history_delegation_and_employee_snapshot_are_organization_scoped(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        [, $manager] = $this->vendorFixture('STORE_MANAGER', $organization, true);
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendors/account/invitations', ['email' => 'delegated@example.test', 'invitee_name' => 'Delegated Manager', 'role' => 'STORE_MANAGER', 'can_manage_staff' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $this->getJson('/api/v1/vendors/account/invitations')->assertOk()->assertJsonPath('data.0.status', 'PENDING')->assertJsonPath('data.0.can_manage_staff', true)->assertJsonMissingPath('data.0.token_hash');
        $this->signInVendor($manager);
        $this->getJson('/api/v1/vendors/account/invitations')->assertOk()->assertJsonCount(0, 'data');
        $this->postJson('/api/v1/vendors/account/invitations', ['email' => 'delegated@example.test', 'invitee_name' => 'Replacement', 'role' => 'STORE_STAFF'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->postJson('/api/v1/vendors/account/invitations', ['email' => 'staff@example.test', 'invitee_name' => 'Staff', 'role' => 'STORE_STAFF', 'can_manage_staff' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $snapshot = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        self::assertSame([], $snapshot['verification']);
        self::assertArrayNotHasKey('payment', $snapshot['setup']);
        self::assertNotContains('finance.view', $snapshot['permissions']);
        self::assertNotContains('vendor.onboarding.manage', $snapshot['permissions']);
        self::assertNotContains('portal.wallet', $snapshot['permissions']);
        $this->patchJson('/api/v1/vendors/account/staff-disputes', ['enabled' => false, 'lock_version' => $organization->fresh()->lock_version])->assertForbidden();
        [, $otherOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($otherOwner);
        $this->getJson('/api/v1/vendors/account/invitations')->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_owner_dispute_setting_and_staff_role_changes_preserve_historical_attribution(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        [, $staff] = $this->vendorFixture('STORE_STAFF', $organization);
        $membership = VendorMembership::query()->where('user_id', $staff->id)->firstOrFail();
        foreach (DB::table('agreement_versions')->pluck('id') as $version) {
            DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'vendor_organization_id' => $organization->id, 'agreement_version_id' => $version, 'source' => 'VENDOR_ONBOARDING', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/account/staff-disputes', ['enabled' => false, 'lock_version' => $organization->fresh()->lock_version])->assertOk();
        self::assertNotContains('portal.disputes', app(AccountAccess::class)->resolve($staff)['permissions']);
        $url = '/api/v1/vendors/account/memberships/'.$membership->id;
        $input = ['full_name' => 'Updated Employee', 'role' => 'INVENTORY', 'lock_version' => $membership->lock_version];
        $this->patchJson($url, $input)->assertOk();
        $this->patchJson($url, $input)->assertConflict();
        $this->assertDatabaseHas('vendor_memberships', ['id' => $membership->id, 'role' => 'INVENTORY']);
        $this->assertDatabaseHas('audit_logs', ['resource_id' => $membership->id, 'action' => 'VENDOR_STAFF_UPDATED', 'actor_role' => 'OWNER']);
        $this->signInVendor($staff);
        $this->patchJson($url, ['full_name' => 'Elevated', 'role' => 'STORE_MANAGER', 'lock_version' => $membership->fresh()->lock_version])->assertForbidden();
    }

    public function test_ready_setup_and_verification_can_activate_without_making_the_store_discoverable(): void
    {
        [$organization] = $this->activationReadyFixture();
        $this->postJson('/api/v1/vendors/onboarding/activation', [], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(202)->assertJsonPath('data.activation.status', 'ACTIVE')
            ->assertJsonPath('data.activation.marketplace_discoverability_status', 'NOT_DISCOVERABLE');
        $version = $organization->refresh()->lock_version;
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $version, 'description' => 'Updated public description'])
            ->assertOk()->assertJsonPath('data.setup.status', 'COMPLETED')->assertJsonPath('data.activation.status', 'ACTIVE');
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $version, 'description' => 'Stale update'])->assertConflict();
    }

    public function test_each_of_the_ten_activation_conditions_individually_blocks_readiness(): void
    {
        [$organization, $owner] = $this->activationReadyFixture();
        $gate = app(StoreActivationGate::class);
        self::assertTrue($gate->evaluate($organization->id)['ready']);
        foreach (range(1, 10) as $condition) {
            DB::beginTransaction();
            switch ($condition) {
                case 1: DB::table('users')->where('id', $owner->id)->update(['email_verified_at' => null]);
                    break;
                case 2: DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->update(['submitted_at' => null]);
                    break;
                case 3: DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'business_information')->update(['status' => 'IN_PROGRESS']);
                    break;
                case 4: DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'lgu_permit')->update(['status' => 'EXPIRED']);
                    break;
                case 5: DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->id)->update(['status' => 'INCOMPLETE']);
                    break;
                case 6: DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['description' => '']);
                    break;
                case 7: DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['fulfillment_method' => 'VENDOR_DELIVERY']);
                    break;
                case 8: DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->update(['connection_status' => 'NOT_CONNECTED']);
                    break;
                case 9: DB::table('agreement_versions')->whereIn('agreement_document_id', DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->select('id'))->update(['effective_at' => now()->addDay()]);
                    break;
                case 10: DB::table('vendor_organizations')->where('id', $organization->id)->update(['activation_hold_code' => 'PAYMENT_REVIEW']);
                    break;
            }
            $result = $gate->evaluate($organization->id);
            self::assertFalse($result['ready'], 'Missing activation condition '.$condition);
            self::assertContains($condition, array_column($result['blockers'], 'condition'));
            DB::rollBack();
        }
    }

    public function test_activation_identifies_unverified_owner_email(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        DB::table('users')->where('id', $owner->id)->update(['email_verified_at' => null]);

        $readiness = app(StoreActivationGate::class)->evaluate($organization->id);
        self::assertFalse($readiness['ready']);
        self::assertTrue(collect($readiness['blockers'])->contains('key', 'owner_email_verification'));
    }

    public function test_verified_google_identity_satisfies_owner_email_activation_condition_for_matching_current_address(): void
    {
        [$organization, $owner] = $this->activationReadyFixture();
        DB::table('users')->where('id', $owner->id)->update(['email_verified_at' => null]);
        DB::table('external_identities')->insert([
            'id' => (string) Str::uuid7(),
            'user_id' => $owner->id,
            'provider' => 'GOOGLE',
            'provider_subject' => 'verified-google-owner',
            'email_at_link' => $owner->email,
            'linked_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        self::assertTrue(app(StoreActivationGate::class)->evaluate($organization->id)['ready']);

        DB::table('users')->where('id', $owner->id)->update(['email' => 'different@example.test']);
        $readiness = app(StoreActivationGate::class)->evaluate($organization->id);
        self::assertFalse($readiness['ready']);
        self::assertTrue(collect($readiness['blockers'])->contains('key', 'owner_email_verification'));
    }

    public function test_each_applicable_mandatory_requirement_blocks_activation_when_incomplete(): void
    {
        [$organization] = $this->activationReadyFixture();
        $gate = app(StoreActivationGate::class);
        foreach (DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('level', '!=', 'OPTIONAL')->where('status', '!=', 'NOT_APPLICABLE')->get() as $requirement) {
            DB::beginTransaction();
            if ($requirement->requirement_key === 'commission_terms') {
                DB::table('agreement_versions')->whereIn('agreement_document_id', DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->select('id'))->update(['retired_at' => now()]);
            }
            if ($requirement->section === 'STORE_SETUP') {
                match ($requirement->requirement_key) {
                    'public_store_profile' => DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['description' => '']),
                    'bulk_capability' => DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['bulk_capability' => null]),
                    'fulfillment_method' => DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->update(['fulfillment_method' => null]),
                    'payment_connection' => DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->update(['connection_status' => 'NOT_CONNECTED']),
                    'store_operation' => DB::table('operating_hours')->where('store_profile_id', DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->value('id'))->where('day_of_week', 7)->delete(),
                    default => self::fail('No source-data mutation for '.$requirement->requirement_key),
                };
            } else {
                DB::table('vendor_onboarding_requirements')->where('id', $requirement->id)->update(['status' => 'IN_PROGRESS']);
            }
            $result = $gate->evaluate($organization->id);
            self::assertFalse($result['ready'], $requirement->requirement_key);
            self::assertContains($requirement->requirement_key, array_column($result['blockers'], 'key'));
            DB::rollBack();
        }
    }

    public function test_pending_and_failed_evidence_never_satisfy_an_approved_requirement(): void
    {
        [$organization] = $this->activationReadyFixture();
        $document = DB::table('vendor_documents')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'lgu_permit')->first();
        $original = DB::table('vendor_document_versions')->where('id', $document->current_version_id)->first();
        foreach (['PENDING', 'FAILED'] as $scanState) {
            DB::beginTransaction();
            $replacement = (array) $original;
            $replacement['id'] = (string) Str::uuid7();
            $replacement['version']++;
            $replacement['supersedes_version_id'] = $original->id;
            $replacement['scan_state'] = $scanState;
            DB::table('vendor_document_versions')->insert($replacement);
            DB::table('vendor_documents')->where('id', $document->id)->update(['current_version_id' => $replacement['id']]);
            $result = app(StoreActivationGate::class)->evaluate($organization->id);
            self::assertFalse($result['ready']);
            self::assertContains('lgu_permit_evidence', array_column($result['blockers'], 'key'));
            $snapshot = $this->getJson('/api/v1/vendor/onboarding')->assertOk()->json('data');
            self::assertTrue(collect($snapshot['requirements'])->firstWhere('key', 'lgu_permit')['blocking']);
            self::assertFalse(collect($snapshot['step_completion'])->firstWhere('key', 'V1')['complete']);
            DB::rollBack();
        }
    }

    public function test_authoritative_snapshot_and_stale_workstream_draft(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendor/onboarding')->assertOk()->assertJsonStructure(['data' => ['requirements', 'drafts', 'lock_version', 'activation' => ['readiness' => ['rule_version', 'blockers']], 'verification' => ['privacy_notice']]]);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => 1, 'draft_lock_version' => 0, 'store_name' => 'Draft one'])->assertOk();
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'draft_lock_version' => 0, 'store_name' => 'Stale draft'])->assertConflict();
        self::assertSame('Draft one', $organization->refresh()->store_name);
        $row = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organization->id)->first();
        self::assertSame(1, $row->lock_version);
        self::assertStringNotContainsString('Draft one', $row->payload_encrypted);
    }

    public function test_blocked_activation_is_audited_and_retained_after_conflict_response(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendors/onboarding/activation', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        $this->assertDatabaseHas('vendor_activation_history', ['vendor_organization_id' => $organization->id, 'result' => 'BLOCKED', 'rule_version' => 'phase3a.v1']);
        $this->assertDatabaseHas('audit_logs', ['action' => 'VENDOR_ACTIVATION_BLOCKED']);
    }

    public function test_private_evidence_validates_bytes_not_only_reported_mime(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => UploadedFile::fake()->create('fake.pdf', 10, 'application/pdf')])->assertUnprocessable();
        $this->assertDatabaseCount('vendor_document_versions', 0);
    }

    public function test_evidence_never_uses_a_public_disk_and_versions_are_immutable(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set('materyalph.files.disk', 'public');
        $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => $this->pdf('registration.pdf')])
            ->assertStatus(503)->assertJsonPath('errors.0.code', 'PRIVATE_STORAGE_UNAVAILABLE');
        $this->assertDatabaseCount('vendor_document_versions', 0);
        config()->set('materyalph.files.disk', 'local');
        $first = $this->submittedEvidenceFixture('business_registration', 'first.pdf');
        $second = $this->submittedEvidenceFixture('business_registration', 'second.pdf');
        $this->assertDatabaseHas('vendor_document_supersessions', ['version_id' => $first, 'superseded_by_version_id' => $second]);
        $this->assertDatabaseHas('vendor_documents', ['vendor_organization_id' => $organization->id, 'current_version_id' => $second]);
        try {
            DB::transaction(fn () => DB::table('vendor_document_versions')->where('id', $first)->update(['scan_state' => 'FAILED']));
            self::fail('Evidence versions must be immutable.');
        } catch (QueryException $exception) {
            self::assertSame('P0001', $exception->errorInfo[0]);
        }
        try {
            DB::transaction(fn () => DB::table('vendor_document_versions')->where('id', $first)->delete());
            self::fail('Evidence versions cannot be deleted.');
        } catch (QueryException $exception) {
            self::assertSame('P0001', $exception->errorInfo[0]);
        }
    }

    public function test_setup_progress_retains_incomplete_vehicles_without_publishing_them(): void
    {
        [$organization] = $this->activationReadyFixture();
        $state = json_encode(['vehicles' => [['key' => 'draft-vehicle', 'name' => 'Unfinished truck']]], JSON_THROW_ON_ERROR);
        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => $organization->lock_version,
            'draft_lock_version' => 0,
            'form_state' => $state,
        ])->assertOk()->assertJsonPath('data.setup.form_state.vehicles.0.name', 'Unfinished truck');
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.setup.form_state.vehicles.0.name', 'Unfinished truck');
        $payload = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organization->id)->where('workstream', 'STORE_SETUP')->value('payload_encrypted');
        self::assertStringNotContainsString('Unfinished truck', $payload);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'draft_lock_version' => 0, 'form_state' => '{}'])->assertConflict();
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'draft_lock_version' => 1, 'form_state' => '{}'])->assertOk()->assertJsonPath('data.setup.form_state', []);
    }

    public function test_drafts_merge_partial_saves_and_reject_stale_public_profile_writes(): void
    {
        [$organization] = $this->activationReadyFixture();
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->lock_version, 'draft_lock_version' => 0, 'description' => 'First description'])->assertOk();
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'draft_lock_version' => 1, 'public_phone' => '+639171234567'])->assertOk();
        $draft = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organization->id)->where('workstream', 'STORE_SETUP')->first();
        $payload = json_decode(Crypt::decryptString($draft->payload_encrypted), true, flags: JSON_THROW_ON_ERROR);
        self::assertSame('First description', $payload['description']);
        self::assertSame('+639171234567', $payload['public_phone']);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'draft_lock_version' => 1, 'description' => 'Stale change'])->assertConflict();
        $this->assertDatabaseHas('store_profiles', ['vendor_organization_id' => $organization->id, 'description' => 'First description']);
    }

    /** @return array{VendorOrganization, User} */
    private function activationReadyFixture(): array
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['business_type' => 'SOLE_PROPRIETORSHIP', 'store_email' => 'ready@example.test', 'store_email_verified_at' => now()]);
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendor/onboarding')->assertOk();
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => 1, 'tax_profile' => ['taxpayer_key' => 'TEST-READY', 'tin' => '12345678900000', 'vat_category' => 'NON_VAT', 'owner_attested' => true, 'tax_relief_claimed' => false]])->assertOk();
        foreach (['business_registration', 'lgu_permit', 'bir_cor', 'identity_evidence'] as $key) {
            $this->submittedEvidenceFixture($key, $key.'.pdf');
        }
        $profileId = (string) Str::uuid7();
        DB::table('store_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization->id, 'public_store_name' => 'Ready store', 'fulfillment_method' => 'SELF_PICKUP', 'bulk_capability' => true, 'description' => 'Test store', 'status' => 'IN_PROGRESS', 'created_at' => now(), 'updated_at' => now()]);
        app(StoreOperatingSchedule::class)->replaceWeekly($profileId, $this->weeklyOperatingSchedule());
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('ready-logo.png')])->assertCreated();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'BANNER', 'file' => UploadedFile::fake()->image('ready-banner.png')])->assertCreated();
        app(OnboardingRequirementResolver::class)->synchronize($organization->id);
        DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('status', '!=', 'NOT_APPLICABLE')->where('section', 'STORE_VERIFICATION')->update(['status' => 'APPROVED', 'submitted_at' => now(), 'submitted_by_user_id' => $owner->id]);
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'public_store_profile', 'status' => 'COMPLETED']);
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'store_operation', 'status' => 'COMPLETED']);
        DB::table('vendor_documents')->where('vendor_organization_id', $organization->id)->update(['status' => 'APPROVED']);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_verification_status' => 'APPROVED', 'store_setup_status' => 'COMPLETED']);
        $tax = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->id)->first();
        DB::table('vendor_tax_profiles')->where('id', $tax->id)->update(['status' => 'APPROVED']);
        DB::table('vendor_tax_profile_versions')->where('id', $tax->current_version_id)->update(['vat_verified_category' => 'NON_VAT']);
        DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'environment' => 'TEST', 'provider_associated_at' => now(), 'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'provider_account_id' => 'acct_test_ready', 'capabilities' => json_encode(['account_verification' => true]), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('store_profiles')->where('id', $profileId)->update(['status' => 'COMPLETED']);
        foreach (['TERMS_OF_SERVICE', 'VENDOR_CODE_OF_CONDUCT', 'VENDOR_COMMISSION_TEST'] as $code) {
            $version = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', $code)->whereNull('v.retired_at')->orderByDesc('v.version')->value('v.id');
            DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'vendor_organization_id' => $organization->id, 'agreement_version_id' => $version, 'source' => 'VENDOR_ONBOARDING', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $privacyVersion = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', 'PRIVACY_NOTICE')->whereNull('v.retired_at')->orderByDesc('v.version')->value('v.id');
        DB::table('privacy_acknowledgments')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'vendor_organization_id' => $organization->id, 'agreement_version_id' => $privacyVersion, 'acknowledged_at' => now()]);

        $readiness = app(StoreActivationGate::class)->evaluate($organization->id);
        self::assertTrue($readiness['ready'], json_encode($readiness['blockers']));

        return [$organization->refresh(), $owner];
    }

    public function test_expired_approved_evidence_is_notified_once_and_restricts_active_store(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->submittedEvidenceFixture('business_registration', 'expiring-registration.pdf');
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_verification_status' => 'PENDING_VERIFICATION']);
        $reviewer = $this->adminFixture('ADMIN_VENDOR_VERIFICATION');
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'APPROVED',
            'lock_version' => DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->getKey())->where('requirement_key', 'business_registration')->value('lock_version'),
            'expiration_kind' => 'DATE',
            'verified_issue_date' => now()->subYear()->toDateString(),
            'verified_expiration_date' => now()->addDay()->toDateString(),
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInVendor($owner);
        $document = collect($this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data.verification.documents'))->firstWhere('id', $versionId);
        self::assertSame('DATE', $document['review']['expiration_kind']);
        self::assertSame(now()->addDay()->toDateString(), $document['review']['verified_expiration_date']);
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_activation_status' => 'ACTIVE']);

        $this->travel(2)->days();
        self::assertSame(1, app(VendorExpiryService::class)->scan());
        self::assertSame(0, app(VendorExpiryService::class)->scan());
        $this->assertDatabaseHas('vendor_document_expiry_notices', ['business_document_version_id' => $versionId, 'notice_kind' => 'EXPIRED']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->getKey(), 'store_activation_status' => 'RESTRICTED', 'activation_hold_code' => 'DOCUMENT_EXPIRED']);
    }

    /** @param array<string, mixed> $organizationValues @return array{VendorOrganization, User} */
    private function vendorFixture(string $role, ?VendorOrganization $organization = null, bool $canManageStaff = false, array $organizationValues = []): array
    {
        $organization ??= VendorOrganization::query()->create(array_merge([
            'legal_name' => 'Phase Three Test Organization',
            'store_name' => 'Phase Three Test Store',
        ], $organizationValues));
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create([
            'vendor_organization_id' => $organization->getKey(),
            'user_id' => $user->getKey(),
            'role' => $role,
            'status' => 'ACTIVE',
            'can_manage_staff' => $canManageStaff,
        ]);
        DB::table('totp_factors')->insert([
            'id' => (string) Str::uuid7(),
            'user_id' => $user->getKey(),
            'encrypted_secret' => Crypt::encryptString('PHASE3TESTSECRET'),
            'confirmed_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return [$organization, $user];
    }

    public function test_dashboard_enforces_least_privilege_and_counts_active_accounts(): void
    {
        $this->vendorFixture('OWNER', organizationValues: ['account_status' => 'ACTIVE', 'store_activation_status' => 'ACTIVE']);
        $this->vendorFixture('OWNER');
        User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'SUSPENDED']);
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/dashboard')->assertOk()
            ->assertJsonPath('data.active_vendors', 1)
            ->assertJsonPath('data.inactive_vendors', 1)
            ->assertJsonPath('data.active_buyers', null)
            ->assertJsonPath('data.audit_events', null)
            ->assertJsonPath('data.can_view_audit', false);
        $this->getJson('/api/v1/admin/dashboard/audit')->assertForbidden();
        $this->signInAdmin($this->adminFixture('ADMIN_SUPERADMIN'));
        $this->getJson('/api/v1/admin/dashboard')->assertOk()
            ->assertJsonPath('data.active_buyers', 1)
            ->assertJsonPath('data.can_view_audit', true);
        $this->getJson('/api/v1/admin/dashboard/audit')->assertOk()
            ->assertJsonStructure(['data', 'meta' => ['current_page', 'last_page', 'total']]);
    }

    public function test_queue_validates_filters_and_preserves_unassigned_locations(): void
    {
        $this->vendorFixture('OWNER', organizationValues: ['store_verification_status' => 'PENDING_VERIFICATION']);
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/vendor-verification?region_code=UNASSIGNED&sort=location')->assertOk()
            ->assertJsonCount(1, 'data')->assertJsonPath('data.0.region_code', null);
        $this->getJson('/api/v1/admin/vendor-verification?sort=invalid')->assertUnprocessable();
        $this->getJson('/api/v1/admin/vendor-verification?submitted_to=2026-09-17')->assertOk();
        $this->getJson('/api/v1/admin/vendor-verification?submitted_from=2026-09-18&submitted_to=2026-09-17')->assertUnprocessable();
    }

    public function test_region_directory_uses_current_hierarchy_and_excludes_future_versions(): void
    {
        $current = (string) Str::uuid7();
        $future = (string) Str::uuid7();
        foreach ([$current => now()->subDay(), $future => now()->addYear()] as $id => $date) {
            DB::table('psgc_versions')->insert(['id' => $id, 'version' => $date->toDateString(), 'effective_on' => $date->toDateString(), 'source_reference' => 'Test fixture']);
        }
        $region = (string) Str::uuid7();
        DB::table('psgc_areas')->insert([
            ['id' => $region, 'psgc_version_id' => $current, 'code' => 'TEST-REGION', 'name' => 'Test Region', 'level' => 'REGION', 'parent_id' => null],
            ['id' => (string) Str::uuid7(), 'psgc_version_id' => $current, 'code' => 'TEST-CITY', 'name' => 'Test City', 'level' => 'CITY', 'parent_id' => $region],
            ['id' => (string) Str::uuid7(), 'psgc_version_id' => $future, 'code' => 'FUTURE-REGION', 'name' => 'Future Region', 'level' => 'REGION', 'parent_id' => null],
        ]);
        $directory = new PhilippineRegionDirectory;
        self::assertSame([['code' => 'TEST-REGION', 'name' => 'Test Region']], $directory->options());
        self::assertSame('TEST-REGION', $directory->mapping()->where('code', 'TEST-CITY')->value('region_code'));
    }

    private function adminFixture(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        $roleId = DB::table('platform_roles')->where('code', $role)->value('id');
        self::assertIsString($roleId);
        DB::table('admin_memberships')->insert([
            'id' => (string) Str::uuid7(),
            'user_id' => $user->getKey(),
            'platform_role_id' => $roleId,
            'status' => 'ACTIVE',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('totp_factors')->insert([
            'id' => (string) Str::uuid7(),
            'user_id' => $user->getKey(),
            'encrypted_secret' => Crypt::encryptString('PHASE3ADMINTESTSECRET'),
            'confirmed_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return $user;
    }

    private function signInVendor(User $user): AuthSession
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api');

        return $session;
    }

    private function signInAdmin(User $user): AuthSession
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');

        return $session;
    }

    public function test_cloudinary_is_used_only_for_public_store_media(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set(['services.cloudinary.cloud_name' => 'test-store-media', 'services.cloudinary.api_key' => 'test-key', 'services.cloudinary.api_secret' => str_repeat('test-only-', 4)]);
        Http::fake(['api.cloudinary.com/*' => function ($request) {
            $fields = array_column($request->data(), 'contents', 'name');

            return Http::response(['public_id' => $fields['public_id'], 'secure_url' => 'https://res.cloudinary.com/test-store-media/image/upload/'.$fields['public_id'].'.png']);
        }]);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'public_store_name' => 'Public Test Store'])->assertOk();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('logo.png')])->assertCreated();
        $publicFile = DB::table('files')->where('purpose', 'STORE_MEDIA')->first();
        self::assertSame('PUBLIC', $publicFile->visibility);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$publicFile->id)->assertOk()->assertJsonPath('data.url', 'https://res.cloudinary.com/test-store-media/image/upload/'.$publicFile->object_key.'.png');
        $this->submittedEvidenceFixture('business_registration', 'private-registration.pdf');
        $privateFile = DB::table('files')->where('purpose', 'BUSINESS_DOCUMENT')->first();
        self::assertSame('PRIVATE', $privateFile->visibility);
        Storage::disk('local')->assertExists($privateFile->object_key);
        Http::assertSentCount(1);
    }

    public function test_cloudinary_failure_is_safe_and_does_not_create_ready_media(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        config()->set(['services.cloudinary.cloud_name' => 'test-store-media', 'services.cloudinary.api_key' => 'test-key', 'services.cloudinary.api_secret' => str_repeat('test-only-', 4)]);
        Http::fake(['api.cloudinary.com/*' => Http::response(['error' => 'Provider failure'], 503)]);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $organization->refresh()->lock_version, 'public_store_name' => 'Public Test Store'])->assertOk();
        $this->post('/api/v1/vendors/onboarding/media', ['kind' => 'LOGO', 'file' => UploadedFile::fake()->image('logo.png')])->assertStatus(503)->assertJsonPath('errors.0.code', 'PUBLIC_MEDIA_STORAGE_UNAVAILABLE');
        self::assertSame(0, DB::table('store_media')->count());
    }

    public function test_combined_tin_validates_encrypts_and_preserves_taxpayer_identity(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        foreach (['123456789', '12345678900', '123456789000000', '123-456-789-AB1', '123 456 789 000'] as $tin) {
            $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => ['tin' => $tin]])->assertUnprocessable();
        }
        foreach (['000', '1234', '12345'] as $branch) {
            $response = $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => ['tin' => '123-456-789-'.$branch]]);
            $response->assertOk()->assertJsonMissing(['tin' => '123-456-789-'.$branch]);
            $version = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organization->id)->first();
            self::assertSame('123456789'.$branch, Crypt::decryptString($version->tin_encrypted));
            self::assertSame(hash_hmac('sha256', '123456789', (string) config('app.key')), $version->tin_hash);
            self::assertSame(hash_hmac('sha256', 'TEST|123456789', (string) config('app.key')), $version->taxpayer_key_hash);
        }
        foreach (['head_office' => true, 'branch_code' => '000', 'branch_code_length' => 3] as $key => $value) {
            $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => [$key => $value]])->assertUnprocessable();
        }
    }

    public function test_public_name_and_unchanged_draft_preserve_unrelated_approvals(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->getKey())->whereIn('requirement_key', ['business_registration', 'lgu_permit', 'tax_profile', 'registered_business_address'])->update(['status' => 'APPROVED']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'store_name' => 'New Public Store Name'])->assertOk();
        foreach (['business_registration', 'lgu_permit', 'tax_profile', 'registered_business_address'] as $key) {
            $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->getKey(), 'requirement_key' => $key, 'status' => 'APPROVED']);
        }
    }

    public function test_representative_change_preserves_history_and_revokes_attestation_authority(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $old = DB::table('vendor_representative_versions')->where('vendor_organization_id', $organization->getKey())->value('id');
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => ['full_name' => 'Replacement Representative', 'same_as_owner' => false]])->assertOk();
        $this->assertDatabaseHas('vendor_representative_versions', ['id' => $old]);
        self::assertSame(2, DB::table('vendor_representative_versions')->where('vendor_organization_id', $organization->getKey())->count());
        $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->getKey(), 'requirement_key' => 'authority_to_act', 'status' => 'IN_PROGRESS']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => ['owner_attested' => true]])->assertUnprocessable()->assertJsonPath('errors.0.code', 'AUTHORITY_REQUIRED');
    }

    public function test_document_scanner_failure_does_not_create_clean_evidence(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->once()->andThrow(new AuthenticationException('FILE_SCANNER_UNAVAILABLE', 'Unavailable.', 503));
        $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => $this->pdf('registration.pdf')])->assertStatus(503);
        self::assertSame(0, DB::table('business_document_versions')->count());
    }

    public function test_replaced_evidence_rejects_a_stale_admin_decision(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->submittedEvidenceFixture('business_registration', 'original.pdf');
        $oldLock = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->getKey())->where('requirement_key', 'business_registration')->value('lock_version');
        $this->submittedEvidenceFixture('business_registration', 'replacement.pdf');
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', ['decision' => 'APPROVED', 'lock_version' => $oldLock, 'expiration_kind' => 'NO_EXPIRATION'], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        self::assertSame(0, DB::table('business_document_reviews')->count());
    }

    public function test_classification_accepts_all_canonical_niches_and_rejects_an_unknown_supplier_type(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => ['supplier_type' => 'OTHER', 'niches' => ['Construction Materials']]])->assertUnprocessable();
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => ['supplier_type' => 'SPECIALIZED_SUPPLIER', 'niches' => VendorOnboardingService::SUPPLIER_NICHES, 'custom_label' => 'Specialty building supplies']])->assertOk();
    }

    public function test_primary_business_contacts_are_retired_from_schema_and_api(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $migration = require database_path('migrations/2026_09_23_000002_remove_vendor_primary_business_contacts.php');
        $migration->down();
        DB::table('vendor_contacts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'full_name' => 'Retired contact', 'created_at' => now(), 'updated_at' => now()]);
        app(OnboardingDrafts::class)->save($organization->id, 'STORE_VERIFICATION', ['store_phone' => '+639170000000'], (int) $owner->id, null);
        $draft = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organization->id)->first();
        DB::table('vendor_onboarding_drafts')->where('id', $draft->id)->update(['payload_encrypted' => Crypt::encryptString(json_encode(['store_phone' => '+639170000000', 'contacts' => [['full_name' => 'Retired contact']]], JSON_THROW_ON_ERROR))]);
        $migration->up();
        $this->assertFalse(Schema::hasTable('vendor_contacts'));
        $payload = json_decode(Crypt::decryptString(DB::table('vendor_onboarding_drafts')->where('id', $draft->id)->value('payload_encrypted')), true);
        $this->assertArrayNotHasKey('contacts', $payload);
        $this->assertSame('+639170000000', $payload['store_phone']);
        $response = $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        $this->assertArrayNotHasKey('contacts', $response->json('data.verification'));
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'contacts' => []])->assertUnprocessable();
        $this->saveVerificationDraft($organization);
    }

    public function test_custom_classification_labels_persist_and_validate_every_label(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $classification = ['supplier_type' => 'SPECIALIZED_SUPPLIER', 'niches' => ['Other Category'], 'custom_labels' => ['Acoustic panels', 'Reclaimed bricks']];
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => $classification])->assertOk();
        $saved = DB::table('vendor_classifications')->where('vendor_organization_id', $organization->id)->first();
        $this->assertSame($classification['custom_labels'], json_decode($saved->custom_labels, true));
        $this->assertSame('Acoustic panels', $saved->custom_label);
        foreach ([[], ['Acoustic panels', 'EQUIPMENT-RENTAL'], ['Bricks', 'bricks']] as $labels) {
            $classification['custom_labels'] = $labels;
            $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => $classification])->assertUnprocessable();
        }
        $classification['niches'] = ['Construction Materials'];
        $classification['custom_labels'] = [];
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => $classification])->assertOk();
        $this->assertSame('[]', DB::table('vendor_classifications')->where('vendor_organization_id', $organization->id)->value('custom_labels'));
    }

    public function test_authority_evidence_cannot_be_reused_for_a_replacement_representative(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $oldEvidence = $this->submittedEvidenceFixture('authority_to_act', 'authority.pdf');
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => ['full_name' => 'Replacement Representative', 'id_number' => 'TEST-REPLACEMENT-ID', 'same_as_owner' => false]])->assertOk();
        $this->submittedEvidenceFixture('representative_identity', 'replacement-passport.pdf');
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/authority_to_act/decision', ['decision' => 'APPROVED', 'authority_evidence_version_id' => $oldEvidence, 'authority_scopes' => ['TAX_DECLARATIONS']], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'REQUIREMENT_NOT_SUBMITTED');
    }

    public function test_business_information_keeps_names_separate_and_returns_both_conflict_codes(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $first = $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1, 'draft_lock_version' => 0, 'business_type' => 'SOLE_PROPRIETORSHIP',
            'business_type' => 'CORPORATION', 'legal_business_name' => 'Registered Trading Business', 'store_name' => 'Public Supply',
            'legal_identity' => ['surname' => 'Example', 'first_name' => 'Owner'],
        ])->assertOk();
        $version = $first->json('data.organization.lock_version');
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'legal_business_name' => 'Registered Trading Business', 'store_name' => 'Public Supply']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => 1, 'draft_lock_version' => 1, 'store_name' => 'Stale'])->assertConflict()->assertJsonPath('errors.0.code', 'RESOURCE_VERSION_CONFLICT');
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $version, 'draft_lock_version' => 0, 'store_name' => 'Stale'])->assertConflict()->assertJsonPath('errors.0.code', 'STALE_VERSION');
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['draft_lock_version' => 1])->assertUnprocessable();
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $version, 'draft_lock_version' => 1, 'store_name' => 'Changed Public Supply'])->assertOk();
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'legal_business_name' => 'Registered Trading Business', 'store_name' => 'Changed Public Supply']);
    }

    public function test_requirement_preview_is_read_only_and_resolves_all_business_types_and_authority_roles(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        foreach (VendorOnboardingService::BUSINESS_TYPES as $type) {
            $this->getJson('/api/v1/vendors/onboarding/requirements?business_type='.$type.'&representative_role=PROPRIETOR')
                ->assertOk()->assertJsonPath('data.authority_to_act.applicable', $type !== 'SOLE_PROPRIETORSHIP');
        }
        foreach (['EMPLOYEE', 'ACCOUNTANT', 'AUTHORIZED_REPRESENTATIVE', 'OTHER'] as $role) {
            $this->getJson('/api/v1/vendors/onboarding/requirements?business_type=CORPORATION&representative_role='.$role)
                ->assertOk()->assertJsonPath('data.authority_to_act.level', 'REQUIRED');
        }
        self::assertSame(1, $organization->refresh()->lock_version);
        self::assertSame(0, DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organization->id)->count());
    }

    public function test_business_type_change_supersedes_evidence_and_preserves_versions(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $document = DB::table('vendor_documents')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'business_registration')->first();
        DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'business_registration')->update(['status' => 'APPROVED']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'business_type' => 'COOPERATIVE'])->assertOk();
        self::assertNotNull(DB::table('vendor_documents')->where('id', $document->id)->value('superseded_at'));
        $this->assertDatabaseHas('vendor_document_versions', ['id' => $document->current_version_id]);
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'business_registration', 'status' => 'IN_PROGRESS']);
    }

    public function test_authority_selection_requires_accepted_own_evidence_and_creates_a_new_representative_version(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $registration = DB::table('vendor_documents')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'business_registration')->first();
        DB::table('vendor_documents')->where('id', $registration->id)->update(['status' => 'IN_PROGRESS']);
        $representative = ['full_name' => 'Phase Three Owner', 'relationship' => 'OFFICER', 'authority_evidence_source' => 'EXISTING_REGISTRATION_EVIDENCE', 'authority_evidence_version_id' => $registration->current_version_id, 'authority_scopes' => ['TAX_DECLARATIONS']];
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => $representative])->assertUnprocessable();
        DB::table('vendor_documents')->where('id', $registration->id)->update(['status' => 'APPROVED']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => $representative])->assertOk();
        self::assertSame(2, DB::table('vendor_representative_versions')->where('vendor_organization_id', $organization->id)->count());
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'authority_to_act', 'level' => 'CONDITIONALLY_REQUIRED', 'status' => 'IN_PROGRESS']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => ['owner_attested' => true]])->assertUnprocessable()->assertJsonPath('errors.0.code', 'AUTHORITY_REQUIRED');
        $representative['relationship'] = 'EMPLOYEE';
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => $representative])->assertUnprocessable();
        $representative['relationship'] = 'OFFICER';
        $representative['authority_evidence_version_id'] = (string) Str::uuid7();
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'representative' => $representative])->assertUnprocessable();
    }

    private function stubAddressProviders(): void
    {
        $this->mock(PsgcProvider::class)->shouldReceive('list')->andReturnUsing(fn (string $path): array => match ($path) {
            'regions' => [['code' => '1300000000', 'name' => 'National Capital Region (NCR)']],
            'provinces' => [['code' => '1208000000', 'name' => 'Sarangani']],
            'cities-municipalities' => [['code' => '1381300000', 'name' => 'Quezon City', 'province' => 'Sarangani']],
            'cities-municipalities/1381300000/barangays' => [['code' => '1381300001', 'name' => 'Alicia']],
            default => [],
        });
        $geocoder = $this->mock(AddressGeocoder::class);
        $geocoder->shouldReceive('forward')->andReturn(['latitude' => 14.65, 'longitude' => 121.02, 'formatted_address' => '100 Test Street, Alicia, Quezon City', 'place_id' => 'test-place']);
        $geocoder->shouldReceive('reverse')->andReturn(['street' => '100 Test Street', 'unit' => '', 'barangay' => 'Alicia', 'city_municipality' => 'Quezon City', 'province' => 'Metro Manila', 'postal_code' => '1100', 'formatted_address' => '100 Test Street, Alicia, Quezon City', 'place_id' => 'test-place']);
    }

    /** @return array<string, mixed> */
    private function resolvedAddressInput(VendorOrganization $organization): array
    {
        $this->stubAddressProviders();
        $selection = ['street' => '100 Test Street', 'unit' => '', 'postal_code' => '1100', 'province_code' => '1300000000', 'city_code' => '1381300000', 'psgc_code' => '1381300001'];
        $result = app(VendorAddressResolver::class)->resolve((string) $organization->getKey(), $selection);

        return $selection + ['province' => 'National Capital Region (NCR)', 'city_municipality' => 'Quezon City', 'barangay' => 'Alicia', 'resolution_token' => $result['resolution_token']];
    }

    public function test_address_search_pin_and_save_validate_hierarchy_and_store_system_coordinates(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $input = $this->resolvedAddressInput($organization);
        $this->getJson('/api/v1/vendors/onboarding/address/areas?level=CITY&parent_code=1300000000&q=Quez')->assertOk()->assertJsonPath('data.items.0.code', '1381300000');
        $this->getJson('/api/v1/vendors/onboarding/address/areas?level=CITY&parent_code=1208000000')->assertOk()->assertJsonCount(0, 'data.items');
        $pin = $this->postJson('/api/v1/vendors/onboarding/address/pin', ['latitude' => 14.651, 'longitude' => 121.021])->assertOk()->assertJsonPath('data.address.psgc_code', '1381300001')->json('data.pin_token');
        $resolved = $this->postJson('/api/v1/vendors/onboarding/address/resolve', $input + ['pin_token' => $pin])->assertOk()->json('data');
        $input['resolution_token'] = $resolved['resolution_token'];
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'address' => $input])->assertOk();
        $this->assertDatabaseHas('addresses', ['owner_id' => $organization->getKey(), 'latitude' => 14.651, 'longitude' => 121.021, 'psgc_code' => '1381300001', 'city_code' => '1381300000', 'province_code' => '1300000000', 'is_current' => true]);
        $this->assertDatabaseHas('vendor_address_versions', ['psgc_code' => '1381300001', 'psgc_source' => 'PSGC_CLOUD_V2']);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'address' => $input + ['latitude' => 0, 'longitude' => 0]])->assertUnprocessable();
        $input['street'] = 'Changed address';
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'address' => $input])->assertUnprocessable();
    }

    public function test_address_resolution_requires_manage_permission(): void
    {
        [, $staff] = $this->vendorFixture('STORE_STAFF');
        $this->signInVendor($staff);
        $this->getJson('/api/v1/vendors/onboarding/address/areas?level=PROVINCE')->assertForbidden();
        $this->postJson('/api/v1/vendors/onboarding/address/pin', ['latitude' => 14.6, 'longitude' => 121])->assertForbidden();
    }

    public function test_authorized_tax_attestation_completes_without_resubmitting_documents(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $this->assertDatabaseCount('vendor_document_versions', 5);
        $this->assertDatabaseCount('vendor_tax_profile_versions', 1);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_verification_status' => 'PENDING_VERIFICATION']);
        $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'tax_profile', 'status' => 'PENDING_VERIFICATION']);
        self::assertNotNull(DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->id)->value('attested_at'));
    }

    public function test_document_transport_requires_a_file_without_creating_pending_or_review_records(): void
    {
        [, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'identity_evidence'])->assertUnprocessable();
        $this->assertDatabaseCount('vendor_pending_documents', 0);
        $this->assertDatabaseCount('vendor_document_versions', 0);
    }

    public function test_pending_files_are_private_replaceable_removable_and_never_review_records(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $first = $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => $this->pdf('first.pdf')])->assertCreated()->assertJsonPath('data.status', 'PENDING_SUBMISSION')->json('data.id');
        $this->assertDatabaseCount('vendor_document_versions', 0);
        $this->getJson('/api/v1/vendors/onboarding/files/'.$first)->assertOk();
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/vendor-verification/files/'.$first)->assertNotFound();
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/business_registration/decision', ['decision' => 'CHANGES_REQUIRED', 'reason' => 'Not submitted'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'REQUIREMENT_NOT_SUBMITTED');
        $this->signInVendor($owner);
        $second = $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => $this->pdf('second.pdf')])->assertCreated()->json('data.id');
        $this->assertDatabaseMissing('files', ['id' => $first]);
        $this->assertDatabaseCount('vendor_pending_documents', 1);
        $this->assertDatabaseCount('vendor_document_versions', 0);
        $this->deleteJson('/api/v1/vendors/onboarding/documents/pending/business_registration')->assertOk();
        $this->assertDatabaseMissing('files', ['id' => $second]);
        $this->assertDatabaseCount('vendor_pending_documents', 0);
        $this->assertDatabaseCount('vendor_documents', 0);
    }

    public function test_grouped_admin_review_updates_information_once_and_keeps_documents_independent(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization, false);
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $steps = collect($this->getJson('/api/v1/admin/vendor-verification/'.$organization->id)->assertOk()->json('data.sections.STORE_VERIFICATION'));
        $keys = ['business_type', 'business_information', 'legal_identity', 'registered_business_address', 'supplier_classification', 'tax_profile', 'privacy_acknowledgement'];
        $versions = $steps->whereIn('key', $keys)->where('status', '!=', 'NOT_APPLICABLE')->pluck('lock_version', 'key')->all();
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/business_information_group/decision', [
            'decision' => 'CHANGES_REQUIRED', 'reason' => 'Correct the submitted business details.', 'requirement_versions' => $versions,
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        foreach (array_keys($versions) as $key) {
            $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->id, 'requirement_key' => $key, 'status' => 'CHANGES_REQUIRED']);
        }
        $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'bir_cor', 'status' => 'PENDING_VERIFICATION']);
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/business_information_group/decision', [
            'decision' => 'APPROVED', 'requirement_versions' => $versions,
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'RESOURCE_VERSION_CONFLICT');

        $identity = $steps->firstWhere('key', 'representative_identity');
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/representative_id/decision', [
            'decision' => 'APPROVED', 'requirement_versions' => ['representative_identity' => $identity['lock_version']], 'expiration_kind' => 'NO_EXPIRATION',
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->assertDatabaseHas('vendor_documents', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'representative_identity', 'status' => 'APPROVED']);
        $this->assertDatabaseHas('vendor_documents', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'bir_cor', 'status' => 'SUBMITTED']);
    }

    public function test_submission_promotes_multiple_files_and_only_replacement_reopens_review(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization, false);
        $this->assertDatabaseCount('vendor_document_versions', 0);
        $this->assertDatabaseCount('vendor_pending_documents', 5);
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true, 'draft' => ['store_name' => 'Latest form values']], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_name' => 'Latest form values']);
        $this->assertDatabaseCount('vendor_document_versions', 5);
        $this->assertDatabaseCount('vendor_pending_documents', 0);
        $original = DB::table('vendor_documents')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'lgu_permit')->value('current_version_id');
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/bir_cor/decision', ['decision' => 'APPROVED', 'expiration_kind' => 'NO_EXPIRATION'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->id.'/requirements/lgu_permit/decision', ['decision' => 'CHANGES_REQUIRED', 'reason' => 'Provide the complete permit.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonFragment(['reason' => 'Provide the complete permit.']);
        $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'lgu_permit', 'file' => $this->pdf('replacement.pdf')])->assertCreated();
        $this->assertDatabaseHas('vendor_documents', ['requirement_key' => 'lgu_permit', 'current_version_id' => $original, 'status' => 'CHANGES_REQUIRED']);
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $this->assertDatabaseHas('vendor_document_versions', ['supersedes_version_id' => $original, 'version' => 2]);
        $this->assertDatabaseHas('vendor_document_versions', ['id' => $original]);
        $this->assertDatabaseHas('vendor_documents', ['requirement_key' => 'bir_cor', 'status' => 'APPROVED']);
        $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'lgu_permit', 'status' => 'PENDING_VERIFICATION']);
    }

    public function test_failed_submission_rolls_back_promotions_and_returns_field_blockers(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'business_registration', 'file' => $this->pdf('registration.pdf')])->assertCreated();
        $before = $organization->refresh()->store_name;
        $response = $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->lock_version, 'privacy_acknowledged' => true, 'draft' => ['store_name' => 'Atomic submission name']], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertSame($before, $organization->refresh()->store_name);
        self::assertGreaterThan(1, count($response->json('errors.0.details.blockers')));
        $this->assertDatabaseCount('vendor_document_versions', 0);
        $this->assertDatabaseCount('vendor_pending_documents', 1);
    }

    public function test_automatic_partial_progress_is_private_and_sole_proprietor_name_is_not_required(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $state = ['business_type' => ['SOLE_PROPRIETORSHIP'], 'individual_first_name' => ['Partial'], 'tin' => ['123']];
        $response = $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'form_state' => json_encode($state)])->assertOk();
        $response->assertJsonPath('data.verification.form_state.individual_first_name.0', 'Partial')->assertJsonMissingPath('data.verification.form_state.tin');
        $this->assertDatabaseCount('vendor_document_versions', 0);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.verification.form_state.individual_first_name.0', 'Partial');
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'business_type' => 'SOLE_PROPRIETORSHIP', 'legal_business_name' => ''])->assertOk();
        $response = $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $keys = array_column($response->json('errors.0.details.blockers'), 'key');
        self::assertNotContains('legal_business_name', $keys);
        self::assertNotContains('registered_name', $keys);
    }

    public function test_manual_address_submits_without_geocoder_and_records_privacy_context(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization, false);
        $this->mock(AddressGeocoder::class)->shouldNotReceive('forward', 'reverse');
        $address = ['source' => 'MANUAL', 'street' => '12 Manual Street', 'postal_code' => '1100', 'province_code' => '1300000000', 'city_code' => '1381300000', 'psgc_code' => '1381300001', 'province' => 'NCR', 'city_municipality' => 'Quezon City', 'barangay' => 'Alicia'];
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true, 'draft' => ['address' => $address]], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202)->assertJsonPath('data.verification.status', 'PENDING_VERIFICATION');
        $this->assertDatabaseHas('addresses', ['owner_id' => $organization->id, 'source' => 'MANUAL', 'street' => '12 Manual Street', 'latitude' => null, 'longitude' => null, 'location' => null, 'is_current' => true]);
        $this->assertDatabaseHas('vendor_address_versions', ['street' => '12 Manual Street', 'source' => 'MANUAL', 'latitude' => null, 'location' => null]);
        $ack = DB::table('privacy_acknowledgments')->where('vendor_organization_id', $organization->id)->first();
        $this->assertSame((int) $owner->id, (int) $ack->user_id);
        $this->assertSame('STORE_VERIFICATION', $ack->processing_activity);
        $this->assertSame('VENDOR_WEB', $ack->source);
        $this->assertNotNull($ack->acknowledged_at);
        $this->assertDatabaseMissing('agreement_acceptances', ['vendor_organization_id' => $organization->id, 'agreement_version_id' => $ack->agreement_version_id]);
    }

    public function test_manual_address_correction_versions_history_and_reopens_review(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization);
        $previous = DB::table('addresses')->where('owner_id', $organization->id)->where('is_current', true)->first();
        DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'registered_business_address')->update(['status' => 'APPROVED']);
        $address = ['source' => 'MANUAL', 'street' => '12 Changed Street', 'postal_code' => '1100', 'province_code' => '1300000000', 'city_code' => '1381300000', 'psgc_code' => '1381300001', 'province' => 'NCR', 'city_municipality' => 'Quezon City', 'barangay' => 'Alicia'];
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'address' => $address])->assertOk();
        $this->assertDatabaseHas('addresses', ['id' => $previous->id, 'street' => $previous->street, 'is_current' => false]);
        $this->assertDatabaseHas('addresses', ['owner_id' => $organization->id, 'version' => 2, 'street' => '12 Changed Street', 'is_current' => true]);
        $this->assertDatabaseHas('vendor_onboarding_steps', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'registered_business_address', 'status' => 'IN_PROGRESS']);
        foreach ([['postal_code' => '12ab'], ['street' => 'a'], ['latitude' => 14.6], ['city_code' => 'invalid']] as $invalid) {
            $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'address' => array_replace($address, $invalid)])->assertUnprocessable();
        }
    }

    public function test_submission_names_missing_address_classification_and_store_fields(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_name' => '']);
        $response = $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $keys = array_column($response->json('errors.0.details.blockers'), 'key');
        foreach (['store_name', 'registered_business_address.street', 'registered_business_address.barangay', 'registered_business_address.city_municipality', 'registered_business_address.province', 'registered_business_address.postal_code', 'classification.supplier_type', 'classification.niches', 'business_registration', 'lgu_permit', 'bir_cor'] as $key) {
            $this->assertContains($key, $keys);
        }
    }

    public function test_privacy_acknowledgment_and_published_notice_are_required(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->saveVerificationDraft($organization, false);
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => false], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        DB::table('agreement_versions')->whereIn('agreement_document_id', DB::table('agreement_documents')->where('code', 'PRIVACY_NOTICE')->select('id'))->update(['retired_at' => now()]);
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(503)->assertJsonPath('errors.0.code', 'PRIVACY_NOTICE_UNAVAILABLE');
        $this->assertDatabaseCount('privacy_acknowledgments', 0);
    }

    public function test_classification_normalizes_rental_variants_and_names_the_offending_label(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        foreach (['  Equipment   RENTAL ', 'Construction-vehicle-rental', 'EquipmentRental', 'R.E.N.T.A.L', 'Equipment for hire', 'Vehicle leasing'] as $label) {
            $response = $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => ['supplier_type' => 'SPECIALIZED_SUPPLIER', 'niches' => ['Tools and Equipment', 'Other Category'], 'custom_labels' => ['Acoustic panels', $label]]])->assertUnprocessable()->assertJsonPath('errors.0.code', 'CLASSIFICATION_UNSUPPORTED');
            $this->assertStringContainsString(trim((string) preg_replace('/\s+/u', ' ', $label)), $response->json('errors.0.details.blockers.0.reason'));
        }
        foreach (['a', str_repeat('a', 61)] as $label) {
            $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'classification' => ['supplier_type' => 'SPECIALIZED_SUPPLIER', 'niches' => ['Other Category'], 'custom_labels' => [$label]]])->assertUnprocessable();
        }
        $this->assertDatabaseCount('vendor_classifications', 0);
    }

    private function saveVerificationDraft(VendorOrganization $organization, bool $review = true): void
    {
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_email_verified_at' => now()]);
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'business_type' => 'CORPORATION',
            'registered_name' => 'Phase Three Registered Corporation',
            'representative' => ['full_name' => 'Phase Three Owner', 'same_as_owner' => true, 'position' => 'Director', 'email' => 'owner@example.test', 'phone' => '+639171234567', 'relationship' => 'OFFICER', 'authority_evidence_source' => 'SEPARATE_AUTHORITY_DOCUMENT', 'authority_document_type' => 'BOARD_RESOLUTION', 'authority_document_date' => '2026-01-01', 'authority_scopes' => ['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION'], 'id_type' => 'PASSPORT', 'id_number' => 'TEST-REPRESENTATIVE-001'],
            'date_established' => '2020-01-15',
            'store_phone' => '+639171234567',
            'classification' => [
                'supplier_type' => 'WHOLESALER_DISTRIBUTOR',
                'niches' => ['Cement and Concrete', 'Steel and Reinforcement'],
            ],
            'address' => $this->resolvedAddressInput($organization),
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-READY',
                'tin' => '12345678900000',
                'entity_class' => 'CORPORATION',
                'registration_category' => 'DOMESTIC',
                'vat_category' => 'VAT',
                'fiscal_year_start_month' => 1,
                'owner_attested' => false,
                'tax_relief_claimed' => false,
            ],
        ])->assertOk();
        foreach ([
            'business_registration' => 'registration.pdf',
            'lgu_permit' => 'lgu-permit.pdf',
            'bir_cor' => 'bir-cor.pdf',
            'representative_identity' => 'representative-passport.pdf',
            'authority_to_act' => 'authority.pdf',
        ] as $requirementKey => $fileName) {
            $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => $requirementKey, 'file' => $this->pdf($fileName)])->assertCreated();
        }
        if (! $review) {
            return;
        }
        $this->postJson('/api/v1/vendors/onboarding/verification/submit', ['lock_version' => $organization->refresh()->lock_version, 'privacy_acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202);
        $owner = User::query()->findOrFail(DB::table('vendor_memberships')->where('vendor_organization_id', $organization->getKey())->where('role', 'OWNER')->value('user_id'));
        $this->signInAdmin($this->adminFixture('ADMIN_VENDOR_VERIFICATION'));
        $evidenceId = DB::table('business_documents')->where('vendor_organization_id', $organization->getKey())->where('requirement_key', 'authority_to_act')->value('current_version_id');
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', ['decision' => 'APPROVED', 'expiration_kind' => 'NO_EXPIRATION'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/authority_to_act/decision', ['decision' => 'APPROVED', 'expiration_kind' => 'NO_EXPIRATION', 'authority_evidence_version_id' => $evidenceId, 'authority_scopes' => ['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION']], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/verification', ['lock_version' => $organization->refresh()->lock_version, 'tax_profile' => ['owner_attested' => true]])->assertOk();
    }

    private function pdf(string $name): UploadedFile
    {
        $content = "%PDF-1.4\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n2 0 obj\n<< /Type /Pages /Count 0 /Kids [] >>\nendobj\ntrailer\n<< /Root 1 0 R /Size 3 >>\n%%EOF\n";

        return UploadedFile::fake()->createWithContent($name, $content);
    }

    // Seed a formally submitted version for review, expiry and immutable-history
    // tests. The complete user submission path is exercised separately above.
    private function submittedEvidenceFixture(string $requirementKey, string $fileName): string
    {
        $fileId = $this->post('/api/v1/vendors/onboarding/documents', [
            'requirement_key' => $requirementKey,
            'file' => $this->pdf($fileName),
        ])->assertCreated()->json('data.id');
        $pending = DB::table('vendor_pending_documents')->where('file_id', $fileId)->first();
        DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $pending->vendor_organization_id)->where('requirement_key', $requirementKey)->where('is_current', true)->update(['status' => 'IN_PROGRESS']);
        $request = app('request');
        DB::transaction(fn () => (new \ReflectionMethod(VendorOnboardingService::class, 'submitPendingDocuments'))->invoke(app(VendorOnboardingService::class), $request, $pending->vendor_organization_id));

        return (string) DB::table('vendor_document_versions')->where('file_id', $fileId)->value('id');
    }
}
