<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\PhilippineRegionDirectory;
use App\Domain\Vendors\VendorExpiryService;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseThreeVendorOnboardingTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        Storage::fake('local');
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
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

        self::assertSame(10, $snapshot->json('data.sections.STORE_VERIFICATION.total'));
        self::assertSame(6, $snapshot->json('data.sections.STORE_SETUP.total'));

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
                'tin' => '123-456-789-000',
                'owner_attested' => true,
                'tax_relief_claimed' => false,
            ],
        ])->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');

        $this->signInVendor($owner);
        $response = $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-001',
                'tin' => '123-456-789-000',
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

        $this->uploadEvidence('business_registration', 'sec-registration.pdf');
        $this->assertDatabaseHas('business_documents', [
            'vendor_organization_id' => $organization->getKey(),
            'requirement_key' => 'business_registration',
            'document_type' => 'SEC_REGISTRATION',
        ]);
    }

    public function test_tax_relief_upload_creates_versioned_tax_evidence(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-RELIEF',
                'tin' => '123-456-789-000',
                'owner_attested' => true,
                'tax_relief_claimed' => true,
            ],
        ])->assertOk();

        $versionId = $this->post('/api/v1/vendors/onboarding/documents', [
            'requirement_key' => 'tax_relief_evidence',
            'metadata' => ['valid_from' => '2026-01-01', 'valid_until' => '2026-12-31'],
            'file' => UploadedFile::fake()->create('tax-relief.pdf', 10, 'application/pdf'),
        ])->assertCreated()->json('data.id');
        $fileId = DB::table('business_document_versions')->where('id', $versionId)->value('file_id');
        $this->assertDatabaseHas('tax_evidence', [
            'file_id' => $fileId,
            'evidence_type' => 'TAX_RELIEF_DECLARATION',
            'origin' => 'VENDOR_UPLOAD',
            'review_state' => 'PENDING',
        ]);
    }

    public function test_submission_requires_an_explicit_tax_relief_declaration(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['store_email' => 'verified@example.test', 'store_email_verified_at' => now()]);
        $this->signInVendor($owner);

        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => 1,
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-002',
                'tin' => '987-654-321-000',
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
        $this->saveVerificationDraft($organization);

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
        $this->assertDatabaseCount('idempotency_records', 1);

        $this->postJson('/api/v1/vendors/onboarding/verification/submit', [
            'lock_version' => 999,
            'privacy_acknowledged' => true,
        ], ['Idempotency-Key' => $key])->assertConflict()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
    }

    public function test_private_evidence_is_scoped_to_the_vendor_and_authorized_admin_role(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->uploadEvidence('business_registration', 'registration.pdf');
        $fileId = (string) DB::table('business_document_versions')->where('id', $versionId)->value('file_id');

        $vendorFileUrl = $this->getJson('/api/v1/vendors/onboarding/files/'.$fileId)->assertOk()->json('data.url');
        self::assertIsString($vendorFileUrl);
        self::assertStringContainsString('signature=', $vendorFileUrl);

        [, $otherOwner] = $this->vendorFixture('OWNER');
        $this->signInVendor($otherOwner);
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

    public function test_admin_queue_requires_clean_evidence_and_records_immutable_decisions(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->uploadEvidence('business_registration', 'registration.pdf');
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
            ->assertJsonPath('errors.0.code', 'EVIDENCE_NOT_CLEAN');

        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'CHANGES_REQUIRED',
        ], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertUnprocessable();

        $response = $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'APPROVED',
            'lock_version' => 1,
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

    public function test_payment_boundary_is_test_only_idempotent_and_provider_failure_stays_pending(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $key = (string) Str::uuid7();
        $payload = ['invitation_url' => 'https://test.xendit.com/invitations/demo', 'provider_account_id' => 'acct_test_001'];

        $this->postJson('/api/v1/vendors/onboarding/payment-connection', $payload, ['Idempotency-Key' => $key])
            ->assertOk()
            ->assertJsonPath('data.setup.payment.environment', 'TEST')
            ->assertJsonPath('data.setup.payment.connection_status', 'PENDING');
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', $payload, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame(1, DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->getKey())->count());
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', ['invitation_url' => 'https://test.xendit.com/invitations/demo', 'provider_account_id' => 'acct_test_002'], ['Idempotency-Key' => $key])
            ->assertConflict()
            ->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');

        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')
            ->assertOk()
            ->assertJsonPath('data.status', 'PENDING')
            ->assertJsonPath('data.provider_available', false);
        $this->assertDatabaseHas('vendor_payment_accounts', ['vendor_organization_id' => $organization->getKey(), 'last_error_code' => 'PROVIDER_UNAVAILABLE']);

        $this->postJson('/api/v1/vendors/onboarding/activation', [], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertConflict()
            ->assertJsonPath('errors.0.code', 'ACTIVATION_NOT_READY');
    }

    public function test_xendit_webhook_requires_configured_token_and_replay_is_deduplicated(): void
    {
        $payload = ['id' => 'event-test-001', 'for_user_id' => 'acct_test_unknown', 'status' => 'PASSED'];
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, ['x-callback-token' => 'wrong'])
            ->assertServiceUnavailable()
            ->assertJsonPath('errors.0.code', 'WEBHOOK_NOT_CONFIGURED');

        config()->set('services.xendit.webhook_token', 'phase3-webhook-test-token');
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, ['x-callback-token' => 'wrong'])
            ->assertUnauthorized()
            ->assertJsonPath('errors.0.code', 'WEBHOOK_INVALID');
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, ['x-callback-token' => 'phase3-webhook-test-token'])
            ->assertStatus(202)
            ->assertJsonPath('data.duplicate', false);
        $this->postJson('/api/v1/webhooks/xendit/account-verification', $payload, ['x-callback-token' => 'phase3-webhook-test-token'])
            ->assertStatus(202)
            ->assertJsonPath('data.duplicate', true);
        $this->assertDatabaseHas('webhook_events', ['provider' => 'XENDIT', 'provider_event_id' => 'event-test-001', 'state' => 'RECEIVED']);
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
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'TEAM_SETUP_REQUIRED');
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

    public function test_ready_setup_and_verification_can_activate_without_making_the_store_discoverable(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER', null, false, ['store_email' => 'ready@example.test', 'store_email_verified_at' => now()]);
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk();
        DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->getKey())->where('section', 'STORE_VERIFICATION')->update(['status' => 'APPROVED']);
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_verification_status' => 'APPROVED']);
        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => 1,
            'public_store_name' => 'Activation Ready Supply',
            'bulk_capability' => true,
            'fulfillment_method' => 'SELF_PICKUP',
        ])->assertOk();
        app()->instance(XenditAccountVerificationGateway::class, new class implements XenditAccountVerificationGateway
        {
            public function reconcile(string $providerAccountId): array
            {
                return ['provider_account_id' => $providerAccountId, 'status' => 'PASSED', 'capabilities' => ['account_verification' => true]];
            }
        });
        $this->postJson('/api/v1/vendors/onboarding/payment-connection', ['invitation_url' => 'https://test.xendit.com/invitations/ready', 'provider_account_id' => 'acct_ready_001'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->postJson('/api/v1/vendors/onboarding/payment-connection/reconcile')->assertOk()->assertJsonPath('data.status', 'CONNECTED');
        $this->postJson('/api/v1/vendors/onboarding/setup/complete', [
            'organization_lock_version' => $organization->refresh()->lock_version,
            'commission_terms_accepted' => true,
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(202)->assertJsonPath('data.setup.status', 'COMPLETED');
        $this->postJson('/api/v1/vendors/onboarding/activation', [], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(202)
            ->assertJsonPath('data.activation.status', 'ACTIVE')
            ->assertJsonPath('data.activation.marketplace_discoverability_status', 'NOT_DISCOVERABLE');
        $version = $organization->refresh()->lock_version;
        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => $version,
            'description' => 'Updated public description',
        ])->assertOk()->assertJsonPath('data.setup.status', 'COMPLETED')->assertJsonPath('data.activation.status', 'ACTIVE');
        $this->patchJson('/api/v1/vendors/onboarding/setup', [
            'organization_lock_version' => $version,
            'description' => 'Stale update',
        ])->assertConflict();
    }

    public function test_expired_approved_evidence_is_notified_once_and_restricts_active_store(): void
    {
        [$organization, $owner] = $this->vendorFixture('OWNER');
        $this->signInVendor($owner);
        $versionId = $this->uploadEvidence('business_registration', 'expiring-registration.pdf');
        DB::table('vendor_organizations')->where('id', $organization->getKey())->update(['store_verification_status' => 'PENDING_VERIFICATION']);
        $reviewer = $this->adminFixture('ADMIN_VENDOR_VERIFICATION');
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/vendor-verification/'.$organization->getKey().'/requirements/business_registration/decision', [
            'decision' => 'APPROVED',
            'lock_version' => 1,
            'expiration_kind' => 'DATE',
            'verified_expiration_date' => now()->addDay()->toDateString(),
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
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

    private function saveVerificationDraft(VendorOrganization $organization): void
    {
        $this->patchJson('/api/v1/vendors/onboarding/verification', [
            'lock_version' => $organization->refresh()->lock_version,
            'business_type' => 'CORPORATION',
            'registered_name' => 'Phase Three Registered Corporation',
            'date_established' => '2020-01-15',
            'store_phone' => '+639171234567',
            'contacts' => [[
                'full_name' => 'Phase Three Owner',
                'title' => 'Owner',
                'email' => 'owner@example.test',
                'phone' => '+639171234567',
                'is_primary' => true,
                'is_authorized' => true,
            ]],
            'classification' => [
                'supplier_type' => 'WHOLESALER_DISTRIBUTOR',
                'niches' => ['Concrete', 'Steel'],
            ],
            'address' => [
                'street' => '100 Test Street',
                'unit' => 'Unit 1',
                'barangay' => 'Barangay Test',
                'city_municipality' => 'Manila',
                'province' => 'Metro Manila',
                'postal_code' => '1000',
                'formatted_address' => '100 Test Street, Manila, Metro Manila 1000',
                'latitude' => 14.5995,
                'longitude' => 120.9842,
                'source' => 'MANUAL',
            ],
            'tax_profile' => [
                'taxpayer_key' => 'TEST-TAXPAYER-READY',
                'tin' => '123-456-789-000',
                'entity_class' => 'CORPORATION',
                'registration_category' => 'DOMESTIC',
                'vat_category' => 'VAT',
                'fiscal_year_start_month' => 1,
                'owner_attested' => true,
                'tax_relief_claimed' => false,
            ],
        ])->assertOk();
        foreach ([
            'business_registration' => 'registration.pdf',
            'lgu_permit' => 'lgu-permit.pdf',
            'bir_cor' => 'bir-cor.pdf',
        ] as $requirementKey => $fileName) {
            $this->uploadEvidence($requirementKey, $fileName);
        }
    }

    private function uploadEvidence(string $requirementKey, string $fileName): string
    {
        return (string) $this->post('/api/v1/vendors/onboarding/documents', [
            'requirement_key' => $requirementKey,
            'file' => UploadedFile::fake()->create($fileName, 10, 'application/pdf'),
        ])->assertCreated()->json('data.id');
    }
}
