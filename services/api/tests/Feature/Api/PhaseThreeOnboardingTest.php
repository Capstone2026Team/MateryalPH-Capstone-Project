<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\ActivationReadiness;
use App\Domain\Vendors\DocumentRequirements;
use App\Domain\Vendors\PublicMediaProvider;
use App\Domain\Vendors\SimulatedXenditConnection;
use App\Domain\Vendors\TestConnectionProvider;
use App\Domain\Vendors\XenditTestConnection;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Fakes\FakePublicMediaProvider;
use Tests\TestCase;

final class PhaseThreeOnboardingTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config(['vendor_onboarding.disk' => 's3', 'vendor_onboarding.simulated_scan' => true, 'finance.mode' => 'TEST', 'finance.live_commerce_enabled' => false]);
        Storage::fake('s3');
        $this->app->instance(PublicMediaProvider::class, new FakePublicMediaProvider);
        $this->app->bind(TestConnectionProvider::class, SimulatedXenditConnection::class);
        Http::preventStrayRequests();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_draft_persists_and_rejects_stale_and_cross_vendor_writes(): void
    {
        [$owner, $org] = $this->vendor(true, false);
        $session = $this->signIn($owner);
        $url = '/api/v1/vendors/'.$org->id.'/business';
        $this->putJson($url, ['lock_version' => 1, 'submit' => false, 'business' => ['legal_name' => 'SAMPLE DEMO Hardware']])->assertOk()->assertJsonPath('data.draft.legal_name', 'SAMPLE DEMO Hardware');
        $this->getJson($url)->assertOk()->assertJsonPath('data.status', 'IN_PROGRESS');
        $this->putJson($url, ['lock_version' => 1, 'submit' => false, 'business' => ['legal_name' => 'Stale']])->assertConflict();
        [, $other] = $this->vendor();
        $this->getJson('/api/v1/vendors/'.$other->id.'/business')->assertNotFound();
        $session->update(['reauthenticated_at' => now()->subHour()]);
        $this->putJson($url, ['lock_version' => 2, 'submit' => false, 'business' => ['legal_name' => 'SAMPLE DEMO Hardware']])->assertForbidden();
    }

    public function test_activation_cannot_be_forced_and_team_is_optional(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $response = $this->getJson($base.'/onboarding')->assertOk()->assertJsonPath('data.ready', false);
        $steps = collect($response->json('data.checklist'))->keyBy('id');
        self::assertFalse($steps['TEAM_ACCOUNTS']['blocking']);
        self::assertSame('OPTIONAL', $steps['TEAM_ACCOUNTS']['requirement_level']);
        self::assertFalse($steps->has('LISTING_REQUIRED'));
        $this->postJson($base.'/activation', ['lock_version' => 1, 'marketplace_status' => 'ACTIVE'])->assertUnprocessable();
        $this->postJson($base.'/activation', ['lock_version' => 1])->assertUnprocessable()->assertJsonPath('errors.0.code', 'ACTIVATION_BLOCKED');
        self::assertSame('NOT_ACTIVE', $org->refresh()->marketplace_status);
    }

    public function test_all_supported_business_types_drive_registration_evidence_and_test_xendit_without_mutation(): void
    {
        config(['vendor_onboarding.simulated_connection' => true]);
        $expectedRegistration = [
            'SOLE_PROPRIETORSHIP' => ['GOVERNMENT_ID', 'DTI'],
            'PARTNERSHIP' => ['SEC'],
            'CORPORATION' => ['SEC'],
            'ONE_PERSON_CORPORATION' => ['SEC'],
            'COOPERATIVE' => ['CDA'],
        ];

        foreach ($expectedRegistration as $businessType => $expected) {
            [$owner, $org] = $this->vendor();
            DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => $businessType, 'onboarding_status' => 'APPROVED']);
            $requirements = app(DocumentRequirements::class)->required($org->refresh());
            foreach ($expected as $documentType) {
                self::assertContains($documentType, $requirements);
            }
            $this->signIn($owner);
            $this->postJson('/api/v1/vendors/'.$org->id.'/payment-connection', ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])
                ->assertOk()
                ->assertJsonPath('data.payment.status', 'TEST_SIMULATED_READY')
                ->assertJsonPath('data.payment.environment', 'TEST');
            self::assertSame($businessType, $org->refresh()->business_type);
        }
    }

    public function test_seeded_capstone_agreements_are_current_integrity_checked_and_owner_scoped(): void
    {
        [$owner, $org] = $this->vendor(false);
        config(['materyalph.agreements.privacy_contact' => 'privacy-contact@example.test']);
        $this->signIn($owner);

        $rows = collect($this->getJson('/api/v1/vendors/account/agreements')->assertOk()->json('data'))->keyBy('code');
        foreach ([
            'TERMS_OF_SERVICE' => [2, true],
            'PRIVACY_NOTICE' => [2, true],
            'VENDOR_CODE_OF_CONDUCT' => [2, true],
            'VENDOR_COMMISSION_TEST' => [1, false],
        ] as $code => [$version, $requiresReacceptance]) {
            self::assertSame($version, $rows[$code]['version']);
            self::assertTrue($rows[$code]['content_available']);
            self::assertSame($requiresReacceptance, $rows[$code]['requires_acceptance']);
            self::assertStringContainsString('CAPSTONE/TEST', $rows[$code]['content']);
        }
        self::assertStringContainsString('privacy-contact@example.test', $rows['PRIVACY_NOTICE']['content']);
        self::assertStringNotContainsString('{{PRIVACY_CONTACT}}', $rows['PRIVACY_NOTICE']['content']);
        self::assertStringContainsString('2% platform commission', $rows['VENDOR_COMMISSION_TEST']['content']);

        $current = DB::table('agreement_versions as v')
            ->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->whereIn('d.code', $rows->keys())
            ->whereNull('v.retired_at')
            ->get(['v.id', 'v.version', 'v.content_hash', 'v.effective_at', 'v.requires_reacceptance', 'd.code'])
            ->keyBy('code');
        foreach ($current as $record) {
            $path = resource_path('agreements/'.$record->code.'/'.$record->version.'.md');
            self::assertSame(hash_file('sha256', $path), $record->content_hash);
            self::assertSame($record->code !== 'VENDOR_COMMISSION_TEST', (bool) $record->requires_reacceptance);
            self::assertLessThanOrEqual(now()->getTimestamp(), strtotime($record->effective_at));
        }

        $before = collect(app(ActivationReadiness::class)->evaluate($org->id)['checklist'])->keyBy('id');
        self::assertSame('REQUIRED', $before['REGISTRATION_AGREEMENTS']['requirement_level']);
        self::assertSame('NOT_STARTED', $before['REGISTRATION_AGREEMENTS']['status']);
        self::assertSame('REQUIRED', $before['COMMISSION_TERMS']['requirement_level']);
        self::assertSame('NOT_STARTED', $before['COMMISSION_TERMS']['status']);
        $this->postJson('/api/v1/vendors/'.$org->id.'/commission-terms/acceptance', ['version_id' => (string) Str::uuid7()])->assertConflict();

        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $manager->id, 'role' => 'STORE_MANAGER']);
        $this->signIn($manager);
        $this->postJson('/api/v1/vendors/'.$org->id.'/commission-terms/acceptance', ['version_id' => $rows['VENDOR_COMMISSION_TEST']['id']])->assertForbidden();

        $this->signIn($owner);
        $generalIds = $rows->except('VENDOR_COMMISSION_TEST')->pluck('id')->values()->all();
        $this->postJson('/api/v1/vendors/account/agreements', ['version_ids' => $generalIds])->assertOk();
        $this->postJson('/api/v1/vendors/'.$org->id.'/commission-terms/acceptance', ['version_id' => $rows['VENDOR_COMMISSION_TEST']['id']])->assertOk();
        $this->assertDatabaseCount('agreement_acceptances', 4);
        foreach ($rows as $row) {
            $this->assertDatabaseHas('agreement_acceptances', [
                'user_id' => $owner->id,
                'agreement_version_id' => $row['id'],
                'vendor_organization_id' => $org->id,
            ]);
        }
        self::assertSame(4, DB::table('audit_logs')->where('actor_user_id', $owner->id)->where('action', 'AGREEMENT_ACCEPTED')->count());
        $after = collect(app(ActivationReadiness::class)->evaluate($org->id)['checklist'])->keyBy('id');
        self::assertSame('COMPLETED', $after['REGISTRATION_AGREEMENTS']['status']);
        self::assertSame('COMPLETED', $after['COMMISSION_TERMS']['status']);

        $versionIds = $current->pluck('id', 'code');
        $this->seed(SystemFoundationSeeder::class);
        self::assertSame($versionIds->all(), DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->whereIn('d.code', $rows->keys())->whereNull('v.retired_at')->pluck('v.id', 'd.code')->all());
        $this->assertDatabaseCount('agreement_acceptances', 4);
    }

    public function test_private_evidence_is_versioned_and_cannot_cross_organizations_or_staff_roles(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $first = $this->post($base.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $second = $this->post($base.'/documents', ['lock_version' => 2, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->assertJsonPath('data.version', 2)->json('data.id');
        self::assertNotSame($first, $second);
        $link = $this->postJson($base.'/documents/'.$first.'/download-link')->assertOk()->json('data.url');
        $this->get($link)->assertOk()->assertHeader('X-Content-Type-Options', 'nosniff');
        [$other] = $this->vendor();
        $this->signIn($other);
        $this->postJson($base.'/documents/'.$first.'/download-link')->assertNotFound();
        $this->get($link)->assertForbidden();
        $staff = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $staff->id, 'role' => 'STORE_STAFF']);
        $this->signIn($staff);
        $this->postJson($base.'/documents/'.$first.'/download-link')->assertForbidden();
        $this->signIn($owner);
        $this->travel(6)->minutes();
        $this->get($link)->assertForbidden();
    }

    public function test_file_validation_rejects_empty_mismatch_and_malformed_pdf(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        foreach ([UploadedFile::fake()->createWithContent('empty.pdf', ''), UploadedFile::fake()->createWithContent('document.jpg', "%PDF-1.4\n%%EOF"), UploadedFile::fake()->createWithContent('bad.pdf', '%PDF-1.4 incomplete')] as $file) {
            $this->post('/api/v1/vendors/'.$org->id.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $file])->assertUnprocessable();
        }
        $this->assertDatabaseCount('business_document_versions', 0);
    }

    public function test_only_verification_admin_reviews_and_verified_expiry_is_authoritative(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $version = $this->post('/api/v1/vendors/'.$org->id.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $url = '/api/v1/admin/vendor-verification/'.$org->id.'/documents/'.$version.'/reviews';
        $input = ['lock_version' => 2, 'decision' => 'APPROVE', 'verified_reference' => 'SAMPLE-COR-001', 'verified_issued_on' => '2025-01-01', 'verified_expiry_not_applicable' => true, 'source_reference' => 'SAMPLE DEMO review fixture', 'immediate_restriction' => false];
        $this->postJson($url, $input)->assertForbidden();
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $this->postJson($url, $input)->assertForbidden();
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson($url, [...$input, 'decision' => 'RETURN_FOR_CORRECTION'])->assertUnprocessable();
        $this->postJson($url, $input)->assertOk();
        self::assertSame('APPROVED', app(DocumentRequirements::class)->effective($org->id, 'BIR_COR')['status']);
        self::assertNull(DB::table('business_document_versions')->where('id', $version)->value('expires_on'));
        $this->postJson($url, [...$input, 'lock_version' => 3, 'verified_expiry_not_applicable' => false, 'verified_expires_on' => '2025-02-01'])->assertOk();
        self::assertSame('EXPIRED', app(DocumentRequirements::class)->effective($org->id, 'BIR_COR')['status']);
        $this->assertDatabaseCount('business_document_reviews', 2);
    }

    public function test_pending_replacement_retains_approved_unexpired_evidence(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $url = '/api/v1/vendors/'.$org->id.'/documents';
        $version = $this->post($url, ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/documents/'.$version.'/reviews', ['lock_version' => 2, 'decision' => 'APPROVE', 'verified_reference' => 'SAMPLE', 'verified_issued_on' => '2025-01-01', 'verified_expiry_not_applicable' => true, 'source_reference' => 'SAMPLE DEMO', 'immediate_restriction' => false])->assertOk();
        $this->signIn($owner);
        $this->post($url, ['lock_version' => 3, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated();
        self::assertSame($version, app(DocumentRequirements::class)->effective($org->id, 'BIR_COR')['version_id']);
    }

    public function test_test_connection_is_explicit_and_delivery_remains_a_forward_gate(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $this->postJson($base.'/payment-connection', ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PROVIDER_WITHHOLDER'])->assertOk()->assertJsonPath('data.payment.status', 'NOT_CONNECTED');
        config(['vendor_onboarding.simulated_connection' => true]);
        $this->postJson($base.'/payment-connection', ['lock_version' => 2, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])->assertOk()->assertJsonPath('data.payment.status', 'TEST_SIMULATED_READY');
        self::assertNull(DB::table('vendor_payment_accounts')->value('provider_account_reference'));
        $hours = array_map(fn (int $day): array => ['weekday' => $day, 'closed' => false, 'opens_at' => '08:00', 'closes_at' => '17:00'], range(0, 6));
        $this->putJson($base.'/store-profile', ['lock_version' => 3, 'description' => 'SAMPLE DEMO store', 'public_email' => 'public@example.test', 'bulk_order_capable' => false, 'fulfillment' => 'SELF_PICKUP', 'cod_enabled' => false, 'in_store_payment_enabled' => true, 'online_payment_enabled' => true, 'refund_configuration' => ['online_refund_supported' => true, 'physical_reimbursement_supported' => true], 'delivery_vehicles' => [], 'hours' => $hours])->assertOk();
        $steps = collect($this->getJson($base.'/onboarding')->assertOk()->json('data.checklist'))->keyBy('id');
        self::assertFalse($steps->has('DELIVERY_CONFIGURATION_REQUIRED'));
        self::assertSame('COMPLETED', $steps['FULFILLMENT_CONFIGURATION']['status']);
        self::assertSame('NOT_APPLICABLE', $steps['DELIVERY_CONFIGURATION']['status']);
        $this->getJson($base.'/commission-terms')->assertOk()->assertJsonPath('data.content_available', true)->assertJsonPath('data.environment', 'TEST');
        $this->postJson($base.'/commission-terms/acceptance', ['version_id' => (string) Str::uuid7()])->assertConflict();
    }

    public function test_team_invitation_idempotency_and_manager_boundaries(): void
    {
        [$owner, $org] = $this->vendor(true, false);
        $this->signIn($owner);
        $url = '/api/v1/vendors/'.$org->id.'/team/invitations';
        $this->withHeader('Idempotency-Key', (string) Str::uuid7());
        $input = ['full_name' => 'SAMPLE DEMO employee', 'email' => 'employee@example.test', 'role' => 'STORE_STAFF', 'expires_at' => now()->addDay()->toIso8601String()];
        $this->postJson($url, $input)->assertStatus(202);
        $this->postJson($url, $input)->assertStatus(202);
        $this->assertDatabaseCount('vendor_invitations', 1);
        $invitation = DB::table('vendor_invitations')->first();
        self::assertFalse($invitation->can_manage_staff);
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $membership = VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $manager->id, 'role' => 'STORE_MANAGER', 'can_manage_staff' => false]);
        $this->signIn($manager);
        $this->postJson($url, $input)->assertForbidden();
        $membership->update(['can_manage_staff' => true]);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7());
        $this->postJson($url, [...$input, 'role' => 'STORE_MANAGER'])->assertForbidden();
        $this->postJson($url, [...$input, 'can_manage_staff' => true])->assertForbidden();
        $this->postJson($url, [...$input, 'email' => 'second@example.test'])->assertStatus(202);
        $this->postJson($url.'/'.$invitation->id.'/revoke', ['lock_version' => 1])->assertOk();
        self::assertNotNull(DB::table('vendor_invitations')->where('id', $invitation->id)->value('revoked_at'));
        self::assertGreaterThan(0, DB::table('outbox_events')->where('event_type', 'ACCOUNT_SECURITY_NOTICE')->count());
    }

    public function test_tax_owner_attestation_and_manager_draft_boundary(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $evidence = $this->post($base.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $profile = ['taxpayer_key' => 'SAMPLE-001', 'legal_name' => 'SAMPLE DEMO Legal', 'trade_name' => 'SAMPLE DEMO Trade', 'tin' => 'SAMPLE-000', 'entity_class' => 'INDIVIDUAL', 'registration_category' => 'REGISTERED', 'vat_category' => 'NON_VAT', 'fiscal_year_start_month' => 1, 'effective_from' => '2026-01-01', 'bir_cor_version_id' => $evidence, 'invoice_method' => 'SAMPLE Manual', 'invoice_coverage' => 'SAMPLE goods'];
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $manager->id, 'role' => 'STORE_MANAGER']);
        $this->signIn($manager);
        $this->postJson($base.'/tax-profile/versions', ['lock_version' => 2, 'attest' => true, 'profile' => $profile])->assertForbidden();
        $this->postJson($base.'/tax-profile/versions', ['lock_version' => 2, 'attest' => false, 'profile' => $profile])->assertOk()->assertJsonPath('data.status', 'DRAFT');
        $this->signIn($owner);
        $version = $this->postJson($base.'/tax-profile/versions', ['lock_version' => 3, 'attest' => true, 'profile' => $profile])->assertOk()->assertJsonPath('data.version', 2)->json('data.version_id');
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/tax-profile/versions/'.$version.'/reviews', ['lock_version' => 4, 'decision' => 'APPROVE'])->assertOk();
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/tax-profile/versions/'.$version.'/reviews', ['lock_version' => 5, 'decision' => 'REJECT', 'reason' => 'TEST duplicate decision'])->assertConflict();
        $this->assertDatabaseCount('vendor_tax_profile_versions', 2);
        $this->assertDatabaseCount('vendor_tax_profile_reviews', 1);
        $this->signIn($owner);
        $this->getJson($base.'/tax-profile')->assertOk()->assertJsonPath('data.withholding_treatment', 'STANDARD_UNLESS_SEPARATE_RELIEF_VALIDATED')->assertJsonPath('data.legal_effect', 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL')->assertJsonPath('data.history.0.reviews.0.approval_scope', 'TEST_REGISTRATION_AND_INVOICE_METHOD')->assertJsonPath('data.history.1.status', 'DRAFT');
        try {
            DB::table('vendor_tax_profile_reviews')->update(['reason' => 'changed']);
            self::fail('Immutable tax decision accepted an update.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('Historical evidence is immutable', $exception->getMessage());
        }
    }

    public function test_admin_business_read_and_manager_tax_choices_are_scoped(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $this->putJson($base.'/business', ['lock_version' => 1, 'submit' => false, 'business' => ['legal_name' => 'SAMPLE REVIEW']])->assertOk();
        $evidence = $this->post($base.'/documents', ['lock_version' => 2, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $manager->id, 'role' => 'STORE_MANAGER']);
        $this->signIn($manager);
        $this->getJson($base.'/tax-profile')->assertOk()->assertJsonPath('data.lock_version', 3)->assertJsonPath('data.evidence_versions.0.id', $evidence);
        $this->getJson($base.'/documents')->assertForbidden();
        $this->postJson($base.'/documents/'.$evidence.'/download-link')->assertForbidden();
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $this->getJson('/api/v1/admin/vendor-verification/'.$org->id.'/business')->assertForbidden();
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/vendor-verification/'.$org->id.'/business')->assertOk()->assertJsonPath('data.draft.legal_name', 'SAMPLE REVIEW');
    }

    public function test_pending_replacement_does_not_hide_expiry_and_scheduler_is_repeatable(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $version = $this->post($base.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/documents/'.$version.'/reviews', ['lock_version' => 2, 'decision' => 'APPROVE', 'verified_reference' => 'SAMPLE', 'verified_issued_on' => '2025-01-01', 'verified_expires_on' => now()->addDay()->toDateString(), 'verified_expiry_not_applicable' => false, 'source_reference' => 'SAMPLE DEMO', 'immediate_restriction' => false])->assertOk();
        $this->signIn($owner);
        $this->post($base.'/documents', ['lock_version' => 3, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated();
        $this->travel(3)->days();
        self::assertSame('EXPIRED', app(DocumentRequirements::class)->effective($org->id, 'BIR_COR')['status']);
        $this->artisan('materyalph:vendor-evidence-evaluate')->assertSuccessful();
        $count = DB::table('outbox_events')->where('event_type', 'ACCOUNT_SECURITY_NOTICE')->count();
        $this->artisan('materyalph:vendor-evidence-evaluate')->assertSuccessful();
        self::assertSame($count, DB::table('outbox_events')->where('event_type', 'ACCOUNT_SECURITY_NOTICE')->count());
        self::assertSame('EXPIRED', DB::table('business_documents')->value('status'));
    }

    public function test_business_submission_preserves_snapshot_and_media_requires_review(): void
    {
        [$owner, $org] = $this->vendor(true, false);
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $version = fn (): int => (int) DB::table('vendor_organizations')->where('id', $org->id)->value('lock_version');
        $evidence = [];
        foreach (['GOVERNMENT_ID', 'DTI', 'LGU_PERMIT', 'BIR_COR'] as $type) {
            $evidence[$type] = $this->post($base.'/documents', ['lock_version' => $version(), 'document_type' => $type, 'file' => $this->pdf()])->assertCreated()->json('data.id');
        }
        $this->postJson($base.'/tax-profile/versions', ['lock_version' => $version(), 'attest' => true, 'profile' => ['taxpayer_key' => 'SAMPLE-001', 'legal_name' => 'SAMPLE Legal', 'trade_name' => 'SAMPLE Store', 'tin' => 'SAMPLE-001', 'entity_class' => 'INDIVIDUAL', 'registration_category' => 'REGISTERED', 'vat_category' => 'NON_VAT', 'fiscal_year_start_month' => 1, 'effective_from' => '2025-01-01', 'bir_cor_version_id' => $evidence['BIR_COR'], 'invoice_method' => 'SAMPLE Manual', 'invoice_coverage' => 'SAMPLE goods']])->assertOk();
        $business = ['legal_name' => 'SAMPLE Legal', 'individual_registered_name' => ['surname' => 'Vendor', 'first_name' => 'Sample', 'same_as_owner' => true], 'government_id_type' => 'SAMPLE PASSPORT', 'government_id_number' => 'SAMPLE-001', 'store_name' => 'SAMPLE Store', 'business_type' => 'SOLE_PROPRIETORSHIP', 'established_on' => '2025-01-01', 'store_email' => $owner->email, 'store_phone' => '+639000000000', 'classification' => 'RETAIL_HARDWARE_STORE', 'niches' => ['CONSTRUCTION_MATERIALS'], 'address' => ['street' => 'SAMPLE Street', 'barangay' => 'SAMPLE Barangay', 'city' => 'SAMPLE City', 'province' => 'SAMPLE Province', 'postal_code' => '1000', 'latitude' => 14.5995, 'longitude' => 120.9842], 'contacts' => [['full_name' => 'SAMPLE Contact', 'position' => 'Owner', 'email' => 'contact@example.test', 'telephone_e164' => '+639000000000', 'authorized_representative' => true, 'is_primary' => true, 'verification_communication' => true, 'account_administration_communication' => true, 'general_administration_communication' => true]]];
        $this->putJson($base.'/business', ['lock_version' => $version(), 'submit' => true, 'business' => $business])->assertOk()->assertJsonPath('data.status', 'PENDING_VERIFICATION');
        $this->assertDatabaseCount('vendor_business_submissions', 1);
        self::assertNotNull(DB::table('store_profiles')->value('address_id'));
        $this->putJson($base.'/business', ['lock_version' => $version(), 'submit' => false, 'business' => ['store_name' => 'Changed']])->assertConflict();
        $this->post($base.'/store-media', ['lock_version' => $version(), 'kind' => 'LOGO', 'alt_text' => 'SAMPLE store logo', 'file' => UploadedFile::fake()->createWithContent('logo.png', base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aV1sAAAAASUVORK5CYII='))])->assertCreated();
        $media = $this->getJson($base.'/store-media')->assertOk()->assertJsonPath('data.0.review_status', 'PENDING_VERIFICATION')->json('data.0.id');
        $this->get($base.'/store-media/'.$media)->assertOk()->assertHeader('X-Content-Type-Options', 'nosniff');
        [$other] = $this->vendor();
        $this->signIn($other);
        $this->get($base.'/store-media/'.$media)->assertNotFound();
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/store-media/'.$media.'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertOk();
        $this->getJson('/api/v1/admin/vendor-verification/'.$org->id.'/store-media')->assertOk()->assertJsonPath('data.0.review_status', 'APPROVED');
        $this->signIn($owner);
        $this->postJson($base.'/store-media/'.$media.'/remove', ['lock_version' => $version()])->assertOk();
        $this->get($base.'/store-media/'.$media)->assertNotFound();
        $this->assertDatabaseCount('store_media', 1);
    }

    public function test_public_store_media_keeps_approved_version_active_until_replacement_is_approved(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $version = fn (): int => (int) DB::table('vendor_organizations')->where('id', $org->id)->value('lock_version');
        $hours = array_map(fn (int $day): array => ['weekday' => $day, 'closed' => false, 'opens_at' => '08:00', 'closes_at' => '17:00'], range(0, 6));
        DB::table('vendor_organizations')->where('id', $org->id)->update(['submitted_at' => now(), 'store_verification_status' => 'PENDING_VERIFICATION', 'business_review_status' => 'PENDING_VERIFICATION']);
        $this->putJson($base.'/store-profile', ['lock_version' => $version(), 'description' => 'SAMPLE public store', 'public_email' => 'public@example.test', 'bulk_order_capable' => false, 'fulfillment' => 'SELF_PICKUP', 'cod_enabled' => false, 'in_store_payment_enabled' => true, 'online_payment_enabled' => true, 'refund_configuration' => ['online_refund_supported' => true, 'physical_reimbursement_supported' => true], 'delivery_vehicles' => [], 'hours' => $hours])->assertOk();
        $this->post($base.'/store-media', ['lock_version' => $version(), 'kind' => 'LOGO', 'alt_text' => 'SAMPLE approved logo', 'file' => $this->png()])->assertCreated();
        $first = DB::table('store_media')->value('id');
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/store-media/'.$first.'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertOk();
        DB::table('vendor_organizations')->where('id', $org->id)->update(['marketplace_status' => 'ACTIVE']);
        $publicFirst = '/api/v1/public/vendors/'.$org->id.'/store-media/'.$first;
        $this->get($publicFirst)->assertOk()->assertHeader('Cache-Control', 'max-age=3600, public');

        $this->signIn($owner);
        $this->post($base.'/store-media', ['lock_version' => $version(), 'kind' => 'LOGO', 'alt_text' => 'SAMPLE replacement logo', 'file' => $this->png()])->assertCreated();
        $second = DB::table('store_media')->where('id', '!=', $first)->value('id');
        self::assertNull(DB::table('store_media')->where('id', $first)->value('replaced_at'));
        DB::table('vendor_organizations')->where('id', $org->id)->update(['marketplace_status' => 'ACTIVE']);
        $this->get($publicFirst)->assertOk();
        $this->get('/api/v1/public/vendors/'.$org->id.'/store-media/'.$second)->assertNotFound();
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/store-media/'.$second.'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertOk();
        DB::table('vendor_organizations')->where('id', $org->id)->update(['marketplace_status' => 'ACTIVE']);
        $this->get($publicFirst)->assertNotFound();
        $this->get('/api/v1/public/vendors/'.$org->id.'/store-media/'.$second)->assertOk();
        self::assertNotNull(DB::table('store_media')->where('id', $first)->value('replaced_at'));

        $this->signIn($owner);
        $this->post($base.'/store-media', ['lock_version' => $version(), 'kind' => 'BANNER', 'alt_text' => 'SAMPLE rejected banner', 'file' => $this->png()])->assertCreated();
        $rejected = DB::table('store_media')->where('kind', 'BANNER')->value('id');
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $review = '/api/v1/admin/vendor-verification/'.$org->id.'/store-media/'.$rejected.'/reviews';
        $this->postJson($review, ['lock_version' => $version(), 'decision' => 'REJECT', 'reason' => 'TEST image is unsuitable'])->assertOk();
        $this->postJson($review, ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertConflict();
        $this->get('/api/v1/public/vendors/'.$org->id.'/store-media/'.$rejected)->assertNotFound();
    }

    public function test_public_media_compensates_database_failure_and_schedules_unconfirmed_cleanup(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $base = '/api/v1/vendors/'.$org->id;
        $hours = array_map(fn (int $day): array => ['weekday' => $day, 'closed' => false, 'opens_at' => '08:00', 'closes_at' => '17:00'], range(0, 6));
        $this->putJson($base.'/store-profile', ['lock_version' => 1, 'description' => 'SAMPLE recovery store', 'public_email' => 'public@example.test', 'bulk_order_capable' => false, 'fulfillment' => 'SELF_PICKUP', 'cod_enabled' => false, 'in_store_payment_enabled' => true, 'online_payment_enabled' => true, 'refund_configuration' => ['online_refund_supported' => true, 'physical_reimbursement_supported' => true], 'delivery_vehicles' => [], 'hours' => $hours])->assertOk();
        $provider = app(PublicMediaProvider::class);
        self::assertInstanceOf(FakePublicMediaProvider::class, $provider);
        $provider->afterUpload = fn () => DB::table('vendor_organizations')->where('id', $org->id)->increment('lock_version');
        $this->post($base.'/store-media', ['lock_version' => 2, 'kind' => 'LOGO', 'alt_text' => 'SAMPLE failed write', 'file' => $this->png()])->assertConflict();
        self::assertSame('CLEANED', DB::table('vendor_public_media_recoveries')->value('state'));
        self::assertSame(1, $provider->removals);
        $this->assertDatabaseCount('store_media', 0);

        $provider->afterUpload = null;
        $provider->failAfterUpload = true;
        $this->post($base.'/store-media', ['lock_version' => 3, 'kind' => 'LOGO', 'alt_text' => 'SAMPLE uncertain upload', 'file' => $this->png()])->assertStatus(503)->assertJsonPath('errors.0.code', 'PUBLIC_MEDIA_CLEANUP_REQUIRED');
        self::assertSame('UPLOAD_UNCONFIRMED', DB::table('vendor_public_media_recoveries')->orderByDesc('id')->value('state'));
        $uploadsBeforeBlockedRetry = $provider->uploads;
        $this->post($base.'/store-media', ['lock_version' => 3, 'kind' => 'LOGO', 'alt_text' => 'SAMPLE blocked retry', 'file' => $this->png()])->assertStatus(503)->assertJsonPath('errors.0.code', 'PUBLIC_MEDIA_RECOVERY_PENDING');
        self::assertSame($uploadsBeforeBlockedRetry, $provider->uploads);
        $provider->failAfterUpload = false;
        $this->travel(6)->minutes();
        $this->artisan('materyalph:vendor-media-recover')->assertSuccessful();
        self::assertSame('CLEANED', DB::table('vendor_public_media_recoveries')->orderByDesc('id')->value('state'));

        $provider->failCleanup = true;
        $provider->afterUpload = fn () => DB::table('vendor_organizations')->where('id', $org->id)->increment('lock_version');
        $this->post($base.'/store-media', ['lock_version' => 3, 'kind' => 'LOGO', 'alt_text' => 'SAMPLE cleanup retry', 'file' => $this->png()])->assertStatus(503)->assertJsonPath('errors.0.code', 'PUBLIC_MEDIA_CLEANUP_REQUIRED');
        self::assertSame('CLEANUP_REQUIRED', DB::table('vendor_public_media_recoveries')->orderByDesc('id')->value('state'));
        $provider->failCleanup = false;
        $provider->afterUpload = null;
        $this->travel(6)->minutes();
        $this->artisan('materyalph:vendor-media-recover')->assertSuccessful();
        self::assertSame('CLEANED', DB::table('vendor_public_media_recoveries')->orderByDesc('id')->value('state'));
        self::assertGreaterThanOrEqual(7, DB::table('audit_logs')->whereIn('action', ['VENDOR_STORE_MEDIA_UPLOAD_PLANNED', 'VENDOR_STORE_MEDIA_CLEANUP_UNCONFIRMED', 'VENDOR_STORE_MEDIA_CLEANED'])->count());
    }

    public function test_commission_acceptance_is_owner_scoped_versioned_and_content_checked(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $document = DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->value('id');
        $root = storage_path('framework/testing/commission-'.Str::uuid7());
        config(['materyalph.agreements.content_path' => $root]);
        File::ensureDirectoryExists($root.'/VENDOR_COMMISSION_TEST');
        $text = 'TEST fixture only. Not legal Terms and not approved runtime content.';
        $base = '/api/v1/vendors/'.$org->id.'/commission-terms';
        try {
            $first = (string) Str::uuid7();
            DB::table('agreement_versions')->insert(['id' => $first, 'agreement_document_id' => $document, 'version' => 2, 'content_hash' => hash('sha256', $text), 'content_uri' => '/test-only', 'effective_at' => now(), 'requires_reacceptance' => true, 'created_at' => now(), 'updated_at' => now()]);
            $this->postJson($base.'/acceptance', ['version_id' => $first])->assertStatus(503);
            File::put($root.'/VENDOR_COMMISSION_TEST/2.md', $text);
            $this->postJson($base.'/acceptance', ['version_id' => $first])->assertOk();
            $this->postJson($base.'/acceptance', ['version_id' => $first])->assertOk();
            self::assertSame(1, DB::table('agreement_acceptances')->where('agreement_version_id', $first)->count());
            $second = (string) Str::uuid7();
            DB::table('agreement_versions')->insert(['id' => $second, 'agreement_document_id' => $document, 'version' => 3, 'content_hash' => hash('sha256', $text), 'content_uri' => '/test-only', 'effective_at' => now(), 'requires_reacceptance' => true, 'created_at' => now(), 'updated_at' => now()]);
            $steps = collect(app(ActivationReadiness::class)->evaluate($org->id)['checklist'])->keyBy('id');
            self::assertSame('NOT_STARTED', $steps['COMMISSION_TERMS']['status']);
            self::assertSame('REQUIRED', $steps['COMMISSION_TERMS']['requirement_level']);
            $this->postJson($base.'/acceptance', ['version_id' => $first])->assertConflict();
            File::put($root.'/VENDOR_COMMISSION_TEST/3.md', 'Mismatched TEST content');
            $this->postJson($base.'/acceptance', ['version_id' => $second])->assertStatus(503);
            File::put($root.'/VENDOR_COMMISSION_TEST/3.md', $text);
            $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
            VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $manager->id, 'role' => 'STORE_MANAGER']);
            $this->signIn($manager);
            $this->postJson($base.'/acceptance', ['version_id' => $second])->assertForbidden();
            $this->signIn($owner);
            $this->postJson($base.'/acceptance', ['version_id' => $second])->assertOk();
            self::assertSame(2, DB::table('agreement_acceptances')->where('source', 'PHASE_3_TEST')->where('vendor_organization_id', $org->id)->count());
        } finally {
            File::deleteDirectory($root);
        }
    }

    public function test_historical_evidence_rejects_database_updates(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $version = $this->post('/api/v1/vendors/'.$org->id.'/documents', ['lock_version' => 1, 'document_type' => 'BIR_COR', 'file' => $this->pdf()])->assertCreated()->json('data.id');
        try {
            DB::transaction(fn () => DB::table('business_document_versions')->where('id', $version)->update(['content_hash' => str_repeat('0', 64)]));
            self::fail('Immutable evidence accepted an update.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('Historical evidence is immutable', $exception->getMessage());
        }
        self::assertNotSame(str_repeat('0', 64), DB::table('business_document_versions')->where('id', $version)->value('content_hash'));
    }

    public function test_complete_test_fixture_activates_and_missing_prerequisites_restrict_then_restore(): void
    {
        [$owner, $org] = $this->vendor(false);
        $admin = $this->admin('ADMIN_VENDOR_VERIFICATION');
        $base = '/api/v1/vendors/'.$org->id;
        $version = fn (): int => (int) DB::table('vendor_organizations')->where('id', $org->id)->value('lock_version');
        $insert = function (string $table, array $values): string {
            $id = (string) Str::uuid7();
            DB::table($table)->insert(['id' => $id, ...$values, 'created_at' => now(), 'updated_at' => now()]);

            return $id;
        };
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'SOLE_PROPRIETORSHIP', 'onboarding_status' => 'APPROVED', 'store_verification_status' => 'PENDING_VERIFICATION', 'business_review_status' => 'APPROVED', 'submitted_at' => now(), 'bulk_capability_recorded' => true, 'regulatory_evidence_required' => false, 'regulatory_review_basis' => 'TEST fixture applicability assessment']);
        $insert('vendor_classifications', ['vendor_organization_id' => $org->id, 'classification' => 'RETAIL_HARDWARE_STORE']);
        $evidence = [];
        foreach (['GOVERNMENT_ID', 'DTI', 'LGU_PERMIT', 'BIR_COR'] as $type) {
            $this->signIn($owner);
            $evidence[$type] = $this->post($base.'/documents', ['lock_version' => $version(), 'document_type' => $type, 'file' => $this->pdf()])->assertCreated()->json('data.id');
            $this->signIn($admin);
            $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/documents/'.$evidence[$type].'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE', 'verified_reference' => 'SAMPLE', 'verified_issued_on' => '2025-01-01', 'verified_expiry_not_applicable' => true, 'source_reference' => 'SAMPLE TEST fixture', 'immediate_restriction' => false])->assertOk();
        }
        $this->signIn($owner);
        $hours = array_map(fn (int $day): array => ['weekday' => $day, 'closed' => false, 'opens_at' => '08:00', 'closes_at' => '17:00'], range(0, 6));
        $this->putJson($base.'/store-profile', ['lock_version' => $version(), 'description' => 'SAMPLE store', 'public_email' => 'store@example.test', 'bulk_order_capable' => false, 'fulfillment' => 'SELF_PICKUP', 'cod_enabled' => false, 'in_store_payment_enabled' => true, 'online_payment_enabled' => true, 'refund_configuration' => ['online_refund_supported' => true, 'physical_reimbursement_supported' => true], 'delivery_vehicles' => [], 'hours' => $hours])->assertOk();
        $address = $insert('addresses', ['owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $org->id, 'formatted_address' => 'SAMPLE address']);
        DB::table('store_profiles')->where('vendor_organization_id', $org->id)->update(['address_id' => $address]);
        foreach (['LOGO', 'BANNER'] as $kind) {
            $this->signIn($owner);
            $this->post($base.'/store-media', ['lock_version' => $version(), 'kind' => $kind, 'alt_text' => 'SAMPLE image', 'file' => UploadedFile::fake()->createWithContent('image.png', base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aV1sAAAAASUVORK5CYII='))])->assertCreated();
            $media = DB::table('store_media')->where('kind', $kind)->value('id');
            $this->signIn($admin);
            $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/store-media/'.$media.'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertOk();
        }
        $this->signIn($owner);
        $tax = $this->postJson($base.'/tax-profile/versions', ['lock_version' => $version(), 'attest' => true, 'profile' => ['taxpayer_key' => 'SAMPLE-001', 'legal_name' => 'SAMPLE', 'trade_name' => 'SAMPLE', 'tin' => 'SAMPLE-001', 'entity_class' => 'INDIVIDUAL', 'registration_category' => 'REGISTERED', 'vat_category' => 'NON_VAT', 'fiscal_year_start_month' => 1, 'effective_from' => '2025-01-01', 'bir_cor_version_id' => $evidence['BIR_COR'], 'invoice_method' => 'SAMPLE Manual', 'invoice_coverage' => 'SAMPLE goods']])->assertOk()->json('data.version_id');
        $this->signIn($admin);
        $this->postJson('/api/v1/admin/vendor-verification/'.$org->id.'/tax-profile/versions/'.$tax.'/reviews', ['lock_version' => $version(), 'decision' => 'APPROVE'])->assertOk();
        $this->signIn($owner);
        config(['vendor_onboarding.simulated_connection' => true]);
        $this->postJson($base.'/payment-connection', ['lock_version' => $version(), 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])->assertOk();
        // Deterministic existing Phase 1 catalog state; no Phase 4 publishing implementation.
        $category = $insert('material_categories', ['code' => 'SAMPLE_CATEGORY', 'name' => 'SAMPLE']);
        $unit = $insert('units', ['code' => 'SAMPLE_UNIT', 'name' => 'SAMPLE', 'dimension' => 'COUNT']);
        $material = $insert('materials', ['material_category_id' => $category, 'canonical_unit_id' => $unit, 'code' => 'SAMPLE_MATERIAL', 'name' => 'SAMPLE']);
        $product = DB::table('products')->insertGetId(['public_id' => (string) Str::uuid7(), 'name' => 'SAMPLE product', 'material_id' => $material, 'created_at' => now(), 'updated_at' => now()]);
        $listing = $insert('vendor_listings', ['vendor_organization_id' => $org->id, 'product_id' => $product, 'vendor_sku' => 'SAMPLE', 'display_name' => 'SAMPLE', 'status' => 'ACTIVE', 'ordinary_public_price_available' => true]);
        $variant = $insert('listing_variants', ['vendor_listing_id' => $listing, 'sku' => 'SAMPLE', 'unit_id' => $unit]);
        $insert('listing_price_versions', ['listing_variant_id' => $variant, 'version' => 1, 'amount_centavos' => 100, 'tax_category' => 'NON_VAT', 'effective_at' => now(), 'created_by_user_id' => $owner->id]);
        $root = storage_path('framework/testing/activation-'.Str::uuid7());
        File::ensureDirectoryExists($root.'/VENDOR_COMMISSION_TEST');
        config(['materyalph.agreements.content_path' => $root]);
        try {
            $document = DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->value('id');
            $commission = DB::table('agreement_versions')->where('agreement_document_id', $document)->whereNull('retired_at')->orderByDesc('version')->value('id');
            File::put($root.'/VENDOR_COMMISSION_TEST/1.md', file_get_contents(resource_path('agreements/VENDOR_COMMISSION_TEST/1.md')));
            foreach (DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->whereIn('d.audience', ['ALL', 'VENDOR'])->where('v.id', '!=', $commission)->get(['v.id']) as $agreement) {
                $insert('agreement_acceptances', ['user_id' => $owner->id, 'agreement_version_id' => $agreement->id, 'vendor_organization_id' => $org->id, 'source' => 'TEST_FIXTURE', 'accepted_at' => now()]);
            }
            $this->postJson($base.'/commission-terms/acceptance', ['version_id' => $commission])->assertOk();
            $this->getJson($base.'/onboarding')->assertOk()->assertJsonPath('data.ready', true);
            $this->postJson($base.'/activation', ['lock_version' => $version()])->assertOk()->assertJsonPath('data.activation_status', 'ACTIVE')->assertJsonPath('data.discoverability_status', 'DISCOVERABLE');
            DB::table('vendor_listings')->where('id', $listing)->update(['status' => 'DRAFT']);
            $this->artisan('materyalph:vendor-evidence-evaluate')->assertSuccessful();
            self::assertSame('ACTIVE', $org->refresh()->activation_status);
            self::assertSame('NO_ACTIVE_LISTINGS', $org->refresh()->discoverability_status);
            DB::table('vendor_listings')->where('id', $listing)->update(['status' => 'ACTIVE']);
            $this->artisan('materyalph:vendor-evidence-evaluate')->assertSuccessful();
            self::assertSame('ACTIVE', $org->refresh()->activation_status);
            self::assertSame('DISCOVERABLE', $org->refresh()->discoverability_status);
            DB::table('store_profiles')->where('vendor_organization_id', $org->id)->update(['delivery_enabled' => true]);
            $this->getJson($base.'/onboarding')->assertOk()->assertJsonPath('data.ready', false);
            $this->postJson($base.'/activation', ['lock_version' => $version()])->assertUnprocessable();
        } finally {
            File::deleteDirectory($root);
        }
    }

    public function test_real_test_adapter_records_provider_live_as_test_and_never_duplicates(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'CORPORATION', 'onboarding_status' => 'APPROVED']);
        $this->app->bind(TestConnectionProvider::class, XenditTestConnection::class);
        config(['vendor_providers.xendit.mode' => 'test', 'vendor_providers.xendit.secret' => 'xnd_development_'.bin2hex(random_bytes(24))]);
        Http::fake(['https://api.xendit.co/v3/accounts' => Http::response(['id' => '5cafeb170a2b18519b1b8763', 'status' => 'LIVE', 'identity' => ['country_of_incorporation' => 'PH', 'entity_type' => 'CORPORATION']], 200)]);
        $url = '/api/v1/vendors/'.$org->id.'/payment-connection';
        $input = ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'];
        $this->postJson($url, $input)->assertOk()->assertJsonPath('data.payment.status', 'TEST_CONNECTED')->assertJsonPath('data.payment.provider_status', 'LIVE')->assertJsonPath('data.payment.environment', 'TEST');
        $this->postJson($url, $input)->assertOk();
        Http::assertSentCount(1);
        Http::assertSent(fn ($request): bool => $request->url() === 'https://api.xendit.co/v3/accounts' && $request['identity']['entity_type'] === 'CORPORATION' && $request['configuration']['users']['send_email_invite'] === false);
        self::assertSame('5cafeb170a2b18519b1b8763', DB::table('vendor_payment_accounts')->value('provider_account_reference'));
        self::assertSame('NOT_ACTIVE', $org->refresh()->marketplace_status);
    }

    public function test_real_test_adapter_does_not_change_identity_or_repeat_unknown_creation(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $this->app->bind(TestConnectionProvider::class, XenditTestConnection::class);
        config(['vendor_providers.xendit.mode' => 'test', 'vendor_providers.xendit.secret' => 'xnd_development_'.bin2hex(random_bytes(24))]);
        $url = '/api/v1/vendors/'.$org->id.'/payment-connection';
        $input = ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'];
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'SOLE_PROPRIETORSHIP', 'onboarding_status' => 'APPROVED']);
        $this->postJson($url, $input)->assertUnprocessable()->assertJsonPath('errors.0.code', 'XENDIT_TEST_ENTITY_UNSUPPORTED');
        Http::assertNothingSent();
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'CORPORATION']);
        $providerPhase = 'CREATE_UNKNOWN';
        Http::fake(function ($request) use (&$providerPhase, $owner) {
            if ($providerPhase === 'CREATE_UNKNOWN') {
                throw new ConnectionException('TEST unknown outcome');
            }

            return Http::response(['data' => [['id' => '5cafeb170a2b18519b1b8764', 'status' => 'LIVE', 'email' => $owner->email, 'public_profile' => ['business_name' => 'SAMPLE DEMO', 'country' => 'PH']]], 'has_more' => false]);
        });
        $this->postJson($url, $input)->assertStatus(503);
        $this->postJson($url, [...$input, 'lock_version' => 2])->assertConflict();
        self::assertSame('TEST_RECONCILE_REQUIRED', DB::table('vendor_payment_accounts')->value('status'));
        self::assertNull(DB::table('vendor_payment_accounts')->value('provider_account_reference'));
        $providerPhase = 'RECONCILE_FOUND';
        $this->postJson('/api/v1/vendors/'.$org->id.'/payment-connection/reconciliation', ['lock_version' => 2])->assertOk()->assertJsonPath('data.payment.status', 'TEST_CONNECTED')->assertJsonPath('data.payment.provider_status', 'LIVE')->assertJsonPath('data.payment.environment', 'TEST');
        self::assertSame('5cafeb170a2b18519b1b8764', DB::table('vendor_payment_accounts')->value('provider_account_reference'));
        self::assertSame(1, DB::table('audit_logs')->where('action', 'XENDIT_TEST_RECONCILIATION_MATCHED')->count());
        Http::assertSent(fn ($request): bool => $request->method() === 'GET' && str_starts_with($request->url(), 'https://api.xendit.co/v2/accounts?'));
    }

    public function test_confirmed_provider_result_with_unconfirmed_local_persistence_requires_reconciliation(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'CORPORATION', 'onboarding_status' => 'APPROVED']);
        $this->app->instance(TestConnectionProvider::class, new class implements TestConnectionProvider
        {
            public function connect(string $organization): array
            {
                DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->update(['status' => 'TEST_PENDING', 'updated_at' => now()]);

                return ['status' => 'TEST_CONNECTED', 'provider_status' => 'LIVE', 'evidence_origin' => 'PROVIDER_TEST', 'provider_account_reference' => '5cafeb170a2b18519b1b8766', 'capabilities' => ['simulated_onboarding' => false, 'live_payments' => false, 'provider_verified' => true]];
            }

            public function reconcile(string $organization): array
            {
                return ['outcome' => 'NOT_FOUND'];
            }
        });
        $base = '/api/v1/vendors/'.$org->id.'/payment-connection';
        $this->postJson($base, ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])->assertStatus(503)->assertJsonPath('errors.0.code', 'XENDIT_RECONCILIATION_REQUIRED');
        self::assertSame('TEST_RECONCILE_REQUIRED', DB::table('vendor_payment_accounts')->value('status'));
        self::assertSame(1, DB::table('audit_logs')->where('action', 'XENDIT_TEST_ACCOUNT_PERSISTENCE_UNCONFIRMED')->count());

        DB::table('vendor_payment_accounts')->update(['status' => 'TEST_CONNECTING', 'updated_at' => now()]);
        $this->postJson($base.'/reconciliation', ['lock_version' => 2])->assertConflict();
        $this->travel(2)->minutes();
        $this->postJson($base.'/reconciliation', ['lock_version' => 2])->assertOk()->assertJsonPath('data.payment.status', 'TEST_RETRY_ALLOWED');
    }

    public function test_xendit_retry_requires_an_authoritative_empty_reconciliation_result(): void
    {
        [$owner, $org] = $this->vendor();
        $this->signIn($owner);
        $this->app->bind(TestConnectionProvider::class, XenditTestConnection::class);
        config(['vendor_providers.xendit.mode' => 'test', 'vendor_providers.xendit.secret' => 'xnd_development_'.bin2hex(random_bytes(24))]);
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'CORPORATION', 'onboarding_status' => 'APPROVED']);
        $base = '/api/v1/vendors/'.$org->id.'/payment-connection';
        $providerPhase = 'CREATE_UNKNOWN';
        Http::fake(function ($request) use (&$providerPhase) {
            if ($providerPhase === 'CREATE_UNKNOWN') {
                throw new ConnectionException('TEST unknown outcome');
            }
            if ($providerPhase === 'RECONCILE_NOT_FOUND') {
                return Http::response(['data' => [], 'has_more' => false]);
            }

            return Http::response(['id' => '5cafeb170a2b18519b1b8765', 'status' => 'LIVE', 'identity' => ['country_of_incorporation' => 'PH', 'entity_type' => 'CORPORATION']]);
        });
        $this->postJson($base, ['lock_version' => 1, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])->assertStatus(503);

        $providerPhase = 'RECONCILE_NOT_FOUND';
        $this->postJson($base.'/reconciliation', ['lock_version' => 2])->assertOk()->assertJsonPath('data.payment.status', 'TEST_RETRY_ALLOWED')->assertJsonPath('data.payment.environment', 'TEST');
        self::assertNull(DB::table('vendor_payment_accounts')->value('connection_attempt_id'));
        self::assertSame(1, DB::table('audit_logs')->where('action', 'XENDIT_TEST_RECONCILIATION_RETRY_ALLOWED')->count());

        $providerPhase = 'CREATE_CONFIRMED';
        $this->postJson($base, ['lock_version' => 3, 'withholding_demo_scenario' => 'DEMO_PLATFORM_WITHHOLDER'])->assertOk()->assertJsonPath('data.payment.status', 'TEST_CONNECTED');
        self::assertSame('5cafeb170a2b18519b1b8765', DB::table('vendor_payment_accounts')->value('provider_account_reference'));
        self::assertSame(2, DB::table('audit_logs')->where('action', 'XENDIT_TEST_ACCOUNT_CREATION_STARTED')->count());
    }

    public function test_regulatory_applicability_is_reviewed_and_required_evidence_blocks_activation(): void
    {
        [$owner, $org] = $this->vendor();
        DB::table('vendor_organizations')->where('id', $org->id)->update(['business_type' => 'CORPORATION', 'onboarding_status' => 'PENDING_VERIFICATION', 'submitted_at' => now()]);
        $this->signIn($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $url = '/api/v1/admin/vendor-verification/'.$org->id.'/business/reviews';
        $this->postJson($url, ['lock_version' => 1, 'decision' => 'APPROVE'])->assertUnprocessable();
        $this->postJson($url, ['lock_version' => 1, 'decision' => 'APPROVE', 'regulatory_evidence_required' => true, 'regulatory_review_basis' => 'TEST fixture applicability source'])->assertOk();
        $this->signIn($owner);
        $steps = collect($this->getJson('/api/v1/vendors/'.$org->id.'/onboarding')->assertOk()->json('data.checklist'))->keyBy('id');
        self::assertSame('CONDITIONALLY_REQUIRED', $steps['REGULATORY']['requirement_level']);
        self::assertSame('NOT_STARTED', $steps['REGULATORY']['status']);
        $this->putJson('/api/v1/vendors/'.$org->id.'/business', ['lock_version' => 2, 'submit' => false, 'business' => ['legal_name' => 'SAMPLE revised']])->assertOk();
        self::assertNull(DB::table('vendor_organizations')->where('id', $org->id)->value('regulatory_evidence_required'));
    }

    /** @return array{User, VendorOrganization} */
    private function vendor(bool $agreementsAccepted = true, bool $verificationSubmitted = true): array
    {
        $org = VendorOrganization::query()->create(['legal_name' => 'SAMPLE DEMO', 'store_name' => 'SAMPLE DEMO']);
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $user->id, 'role' => 'OWNER']);
        if ($verificationSubmitted) {
            $org->forceFill(['submitted_at' => now(), 'store_verification_status' => 'PENDING_VERIFICATION', 'business_review_status' => 'PENDING_VERIFICATION', 'onboarding_status' => 'PENDING_VERIFICATION'])->save();
        }
        if ($agreementsAccepted) {
            foreach (DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->whereIn('d.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE', 'VENDOR_CODE_OF_CONDUCT'])->whereNull('v.retired_at')->get(['v.id']) as $agreement) {
                DB::table('agreement_acceptances')->insert([
                    'id' => (string) Str::uuid7(),
                    'user_id' => $user->id,
                    'agreement_version_id' => $agreement->id,
                    'vendor_organization_id' => $org->id,
                    'source' => 'TEST_FIXTURE',
                    'accepted_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        return [$user, $org];
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signIn(User $user): AuthSession
    {
        if (! DB::table('totp_factors')->where('user_id', $user->id)->exists()) {
            DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString(bin2hex(random_bytes(20))), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => [$user->account_type]]));
        $this->actingAs($user, 'api');

        return $session;
    }

    private function pdf(): UploadedFile
    {
        return UploadedFile::fake()->createWithContent('SAMPLE-DEMO.pdf', "%PDF-1.4\n1 0 obj<</Type /Catalog>>endobj\n%%EOF\n");
    }

    private function png(): UploadedFile
    {
        return UploadedFile::fake()->createWithContent('SAMPLE-DEMO.png', base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aV1sAAAAASUVORK5CYII='));
    }
}
