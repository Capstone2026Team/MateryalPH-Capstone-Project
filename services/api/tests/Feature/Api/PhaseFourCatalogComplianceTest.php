<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\CatalogImportService;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\StoreActivationGate;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
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
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseFourCatalogComplianceTest extends TestCase
{
    use RefreshDatabase;

    private bool $scannerAvailable = true;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnUsing(function (): void {
            if (! $this->scannerAvailable) {
                throw new AuthenticationException('FILE_SCANNER_UNAVAILABLE', 'File scanning is unavailable. Try again later.', 503);
            }
        });
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_product_free_activation_keeps_the_store_not_discoverable(): void
    {
        [$organization] = $this->activeStore();
        self::assertSame(0, DB::table('vendor_listings')->where('vendor_organization_id', $organization->id)->count());
        $blockers = app(StoreActivationGate::class)->evaluate($organization->id)['blockers'];
        self::assertSame([], array_values(array_filter($blockers, static fn (array $blocker): bool => (bool) preg_match('/listing|product|inventory|compliance_submission/i', $blocker['key'].' '.$blocker['reason']))));

        $state = app(MarketplaceDiscoverability::class)->evaluate($organization->id);
        self::assertSame(['status' => 'NOT_DISCOVERABLE', 'reason' => 'NO_ELIGIBLE_LISTINGS', 'eligible_listings' => 0], $state);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_activation_status' => 'ACTIVE', 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertNotFound();
    }

    public function test_an_eligible_listing_makes_the_store_discoverable_and_later_loss_of_eligibility_hides_it(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-4', ['thickness_mm' => '100']);
        $this->publish($listing)->assertOk()->assertJsonPath('data.status', 'ACTIVE');
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->assertDatabaseHas('vendor_activation_history', ['vendor_organization_id' => $organization->id, 'result' => 'DISCOVERABLE', 'state_before' => 'NOT_DISCOVERABLE']);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk();

        // Selling out removes eligibility while the listing itself stays ACTIVE.
        $current = $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertOk()->json('data');
        $variants = $current['variants'];
        $variants[0]['quantity_on_hand'] = '0';
        $variants[0]['price_centavos'] = $variants[0]['price']['amount_centavos'];
        $variants[0]['tax_category'] = $variants[0]['price']['tax_category'];
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])->assertOk()
            ->assertJsonPath('data.status', 'ACTIVE')->assertJsonPath('data.variants.0.public_availability', 'OUT_OF_STOCK');
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE', 'marketplace_discoverability_reason' => 'NO_ELIGIBLE_LISTINGS']);

        $current = $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data');
        $variants = $current['variants'];
        $variants[0]['quantity_on_hand'] = '25';
        $variants[0]['price_centavos'] = $variants[0]['price']['amount_centavos'];
        $variants[0]['tax_category'] = $variants[0]['price']['tax_category'];
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])->assertOk();
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);

        // Stale stock confirmations age out through the scheduled evaluation.
        $this->travel(16)->days();
        $this->artisan('materyalph:discoverability-evaluate')->assertSuccessful();
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
        $this->travelBack();
        app(MarketplaceDiscoverability::class)->evaluate($organization->id);

        // Deactivation and an organization restriction each remove discovery.
        $version = (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version');
        $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/deactivate', ['lock_version' => $version, 'reason' => 'Seasonal'])->assertOk()->assertJsonPath('data.status', 'INACTIVE');
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
        $this->publish($listing)->assertOk()->assertJsonPath('data.status', 'ACTIVE');
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['store_activation_status' => 'RESTRICTED', 'activation_hold_code' => 'ADMIN_RESTRICTION']);
        self::assertSame('STORE_NOT_ACTIVE', app(MarketplaceDiscoverability::class)->evaluate($organization->id)['reason']);
        $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertNotFound();
    }

    public function test_each_fixed_role_has_the_documented_ps_icc_and_catalog_access(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('PORTLAND_CEMENT', 'CEM-40', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        foreach (['OWNER' => $owner, 'STORE_MANAGER' => null, 'STORE_STAFF' => null, 'INVENTORY' => null] as $role => $user) {
            $user ??= $this->member($organization, $role);
            $this->signInVendor($user);
            $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/compliance/evidence', ['path' => 'MANUAL', 'file' => UploadedFile::fake()->image('marking-'.$role.'.jpg')])->assertCreated();
            $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertOk()->assertJsonPath('data.permissions.can_submit_compliance', true);
            // Product compliance never grants business/tax evidence, Owner attestations or Admin decisions.
            if ($role !== 'OWNER') {
                $this->post('/api/v1/vendors/onboarding/documents', ['requirement_key' => 'bir_cor', 'file' => $this->pdf()])->assertForbidden();
                $this->postJson('/api/v1/vendors/onboarding/verification/commission', ['organization_lock_version' => 1, 'agreement_version_id' => (string) Str::uuid7(), 'accepted' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
            }
            $this->getJson('/api/v1/admin/product-compliance')->assertForbidden();
        }
        foreach (['CUSTOMER_SERVICE', 'FULFILLMENT'] as $role) {
            $this->signInVendor($this->member($organization, $role));
            $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/compliance/evidence', ['path' => 'MANUAL', 'file' => UploadedFile::fake()->image('marking.jpg')])->assertForbidden();
            $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'display_name' => 'Changed'])->assertForbidden();
            $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Other', 'vendor_sku' => 'X-1'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        }
        // Customer Service keeps the sales stock view; Fulfillment sees only assigned products.
        $this->signInVendor($this->member($organization, 'CUSTOMER_SERVICE'));
        $this->getJson('/api/v1/vendor/catalog/listings')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $listing);
        $this->signInVendor($this->member($organization, 'FULFILLMENT'));
        $this->getJson('/api/v1/vendor/catalog/listings')->assertOk()->assertJsonCount(0, 'data')->assertJsonPath('meta.scope', 'ASSIGNED_ONLY');
        $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertNotFound();

        // Another organization cannot read or act on this listing.
        [, $otherOwner] = $this->activeStore('Other Store');
        $this->signInVendor($otherOwner);
        $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertNotFound();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/compliance/evidence', ['path' => 'MANUAL', 'file' => UploadedFile::fake()->image('marking.jpg')])->assertNotFound();
    }

    public function test_other_labels_stay_listing_text_and_never_write_shared_taxonomy(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $counts = fn (): array => array_map(fn (string $table): int => DB::table($table)->count(), ['material_categories', 'materials', 'material_aliases', 'material_tags', 'technical_attribute_definitions']);
        $before = $counts();
        $listing = $this->createListing('Bamboo poles', 'BAMBOO-1');
        $category = DB::table('material_categories')->where('code', 'WOOD_AND_LUMBER')->value('id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'other_label' => 'Bamboo poles', 'material_category_id' => $category, 'tag_ids' => [DB::table('material_tags')->where('code', 'EXTERIOR')->value('id')]])
            ->assertOk()->assertJsonPath('data.other_label', 'Bamboo poles')->assertJsonPath('data.material', null)->assertJsonPath('data.material_match', 'UNMATCHED')->assertJsonPath('data.regulated', false);
        self::assertSame($before, $counts());
        self::assertFalse(DB::table('material_aliases')->where('normalized_alias', 'bamboo poles')->exists());
        self::assertNotContains('Bamboo poles', collect($this->getJson('/api/v1/vendor/catalog/taxonomy')->json('data.categories'))->pluck('name')->all());
        $this->getJson('/api/v1/vendor/catalog/materials/search?q=bamboo%20poles')->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_rental_services_are_excluded_but_equipment_sold_as_products_is_allowed(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Backhoe for rent', 'vendor_sku' => 'RENT-1'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'CATALOG_RENTAL_UNSUPPORTED');
        $listing = $this->createListing('Concrete mixer unit', 'MIXER-1');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'other_label' => 'Equipment rental'])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'CATALOG_RENTAL_UNSUPPORTED');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'other_label' => 'Construction equipment', 'material_category_id' => DB::table('material_categories')->where('code', 'TOOLS_AND_EQUIPMENT')->value('id')])->assertOk();
        self::assertSame(0, DB::table('vendor_listings')->where('vendor_sku', 'RENT-1')->count());
    }

    public function test_private_verification_and_compliance_evidence_never_become_public_listing_media(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('PORTLAND_CEMENT', 'CEM-40', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        $evidence = $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/compliance/evidence', ['path' => 'MANUAL', 'file' => UploadedFile::fake()->image('marking.jpg')])->assertCreated()->json('data');
        $businessFile = (string) Str::uuid7();
        DB::table('files')->insert(['id' => $businessFile, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organization->id, 'purpose' => 'BUSINESS_DOCUMENT', 'visibility' => 'PRIVATE', 'content_type' => 'application/pdf', 'byte_size' => 10, 'checksum_sha256' => str_repeat('a', 64), 'scan_state' => 'CLEAN', 'object_key' => 'private/test/'.$businessFile, 'retention_class' => 'VENDOR_ONBOARDING', 'created_at' => now(), 'updated_at' => now()]);
        foreach ([$businessFile, $evidence['file_id']] as $privateFile) {
            try {
                DB::transaction(fn () => DB::table('listing_media')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listing, 'file_id' => $privateFile, 'sort_order' => 9, 'created_at' => now(), 'updated_at' => now()]));
                self::fail('A private file was attached as public listing media.');
            } catch (QueryException $exception) {
                self::assertStringContainsString('Listing media must use a public listing image', $exception->getMessage());
            }
        }
        $mediaFile = DB::table('listing_media')->where('vendor_listing_id', $listing)->value('file_id');
        try {
            DB::transaction(fn () => DB::table('compliance_evidence')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listing, 'file_id' => $mediaFile, 'evidence_kind' => 'MARKING_PHOTO', 'created_at' => now(), 'updated_at' => now()]));
            self::fail('A public listing image was reused as private compliance evidence.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('Compliance evidence must be a private compliance evidence file', $exception->getMessage());
        }
        self::assertSame('PRIVATE', DB::table('files')->where('id', $evidence['file_id'])->value('visibility'));
        $this->getJson('/api/v1/vendor/catalog/files/'.$businessFile)->assertNotFound();
        $this->getJson('/api/v1/vendor/catalog/files/'.$evidence['file_id'])->assertOk();
        $this->signInAdmin($this->admin('ADMIN_PRODUCT_COMPLIANCE'));
        // Unsubmitted evidence and business documents are not reachable through product compliance.
        $this->getJson('/api/v1/admin/product-compliance/files/'.$evidence['file_id'])->assertNotFound();
        $this->getJson('/api/v1/admin/product-compliance/files/'.$businessFile)->assertNotFound();
        $this->signInAdmin($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/product-compliance/files/'.$mediaFile)->assertForbidden();
    }

    public function test_regulated_publication_gate_admin_review_and_compliance_sensitive_reverification(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('PORTLAND_CEMENT', 'CEM-40', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        $this->publish($listing)->assertOk()->assertJsonPath('data.status', 'PENDING_COMPLIANCE')->assertJsonPath('data.compliance_status', 'NOT_SUBMITTED');
        try {
            DB::transaction(fn () => DB::table('vendor_listings')->where('id', $listing)->update(['status' => 'ACTIVE']));
            self::fail('The database accepted an unverified regulated ACTIVE listing.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('vendor_listing_regulated_gate_check', $exception->getMessage());
        }
        $submission = $this->submitCompliance($listing, 'MANUAL', ['certificate_number' => 'Q-1234', 'manufacturer_name' => 'Sample Cement Corporation'])->assertCreated()
            ->assertJsonPath('data.status', 'PENDING_ADMIN_REVIEW')->assertJsonPath('data.compliance_status', 'PENDING_ADMIN_REVIEW')->json('data.compliance_submissions.0');
        $this->assertDatabaseHas('compliance_reference_matches', ['compliance_submission_id' => $submission['id'], 'result' => 'UNAVAILABLE']);
        $this->assertDatabaseMissing('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);

        $this->signInAdmin($this->admin('ADMIN_VENDOR_VERIFICATION'));
        $this->getJson('/api/v1/admin/product-compliance')->assertForbidden();
        $reviewer = $this->admin('ADMIN_PRODUCT_COMPLIANCE');
        $this->signInAdmin($reviewer);
        $this->getJson('/api/v1/admin/product-compliance')->assertOk()->assertJsonPath('data.0.id', $submission['id'])->assertJsonPath('data.0.reference_result', 'UNAVAILABLE');
        $detail = $this->getJson('/api/v1/admin/product-compliance/'.$submission['id'])->assertOk()
            ->assertJsonPath('data.rule.reference_standard', 'PNS 07:2018')->assertJsonPath('data.rule.technical_regulation', 'DAO 17-06:2017')->json('data');
        self::assertContains('PS Mark', $detail['rule']['marking_requirements']);
        $this->getJson('/api/v1/admin/product-compliance/files/'.$detail['evidence'][0]['file_id'])->assertOk()->assertJsonStructure(['data' => ['url', 'expires_at']]);
        $decide = fn (array $body): TestResponse => $this->postJson('/api/v1/admin/product-compliance/'.$submission['id'].'/decision', $body, ['Idempotency-Key' => (string) Str::uuid7()]);
        $decide(['decision' => 'CHANGES_REQUIRED', 'lock_version' => 1])->assertUnprocessable();
        $decide(['decision' => 'CHANGES_REQUIRED', 'lock_version' => 1, 'reason' => 'The PS licence number is not legible in the photo.'])->assertOk()->assertJsonPath('data.submission.status', 'CHANGES_REQUIRED');
        $decide(['decision' => 'APPROVED', 'lock_version' => 1])->assertConflict()->assertJsonPath('errors.0.code', 'STALE_REVIEW');
        $this->assertDatabaseHas('vendor_listings', ['id' => $listing, 'status' => 'PENDING_COMPLIANCE', 'compliance_status' => 'CHANGES_REQUIRED']);
        $this->assertDatabaseHas('compliance_reviews', ['compliance_submission_id' => $submission['id'], 'decision' => 'CHANGES_REQUIRED', 'reviewer_user_id' => $reviewer->id]);
        $this->assertDatabaseHas('audit_logs', ['action' => 'PRODUCT_COMPLIANCE_DECIDED', 'resource_id' => $submission['id']]);
        $this->assertDatabaseHas('notifications', ['user_id' => $owner->id, 'category' => 'PRODUCT_COMPLIANCE']);

        $this->signInVendor($owner);
        $second = $this->submitCompliance($listing, 'PHOTO_OCR', ['certificate_number' => 'Q-1234', 'manufacturer_name' => 'Sample Cement Corporation'])->assertCreated()->json('data.compliance_submissions.0');
        self::assertSame(2, $second['version']);
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/product-compliance/'.$second['id'].'/decision', ['decision' => 'APPROVED', 'lock_version' => 1, 'source_reference' => 'BPS PS licence list checked'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->assertDatabaseHas('vendor_listings', ['id' => $listing, 'status' => 'ACTIVE', 'compliance_status' => 'VERIFIED']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_activation_status' => 'ACTIVE']);

        // A compliance-sensitive edit withdraws the verified state and opens reverification.
        $this->signInVendor($owner);
        $version = (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => $version, 'manufacturer' => 'Different Cement Inc.'])->assertOk()
            ->assertJsonPath('data.status', 'PENDING_COMPLIANCE')->assertJsonPath('data.compliance_status', 'NOT_SUBMITTED');
        $this->assertDatabaseHas('compliance_submissions', ['id' => $second['id'], 'status' => 'VERIFIED']);
        $this->assertDatabaseHas('listing_status_history', ['vendor_listing_id' => $listing, 'from_status' => 'ACTIVE', 'to_status' => 'PENDING_COMPLIANCE', 'reason_code' => 'COMPLIANCE_SENSITIVE_EDIT']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
    }

    public function test_exact_register_match_auto_verifies_and_partial_match_routes_to_admin_review(): void
    {
        $admin = $this->admin('ADMIN_PRODUCT_COMPLIANCE');
        $this->signInAdmin($admin);
        $csv = "DTI-BPS PS Licensees\n\nPS License No.,Name of Licensee,Product,Standard,Address,Expiry Date\nQ-7001,Sample Cement Corporation,Portland Cement Type I,PNS 07:2018,Test City,2099-12-31\n,Missing Number Inc.,Cement,PNS 07:2018,Test City,\nQ-7002,Expired Cement Co.,Portland Cement,PNS 07:2018,Test City,2020-01-01\n";
        $register = $this->post('/api/v1/admin/product-compliance/registers', ['register_kind' => 'PS_LICENSE', 'source_reference' => 'DTI-BPS PS Licensees sheet', 'snapshot_date' => now()->toDateString(), 'file' => UploadedFile::fake()->createWithContent('ps-licensees.csv', $csv)])
            ->assertCreated()->assertJsonPath('data.status', 'DRAFT')->assertJsonPath('data.row_count', 2)->assertJsonPath('data.rejected_row_count', 1)->json('data');
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $pending = $this->publishableListing('PORTLAND_CEMENT', 'CEM-A', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        $this->publish($pending)->assertOk();
        // A draft snapshot is not used for matching.
        $this->submitCompliance($pending, 'MANUAL', ['certificate_number' => 'Q-7001', 'manufacturer_name' => 'Sample Cement Corporation'])->assertJsonPath('data.compliance_status', 'PENDING_ADMIN_REVIEW');

        $this->signInAdmin($admin);
        $this->postJson('/api/v1/admin/product-compliance/registers/'.$register['id'].'/activate')->assertOk()->assertJsonPath('data.status', 'ACTIVE');
        $this->signInVendor($owner);
        $exact = $this->publishableListing('PORTLAND_CEMENT', 'CEM-B', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        $this->publish($exact)->assertOk();
        $this->submitCompliance($exact, 'MANUAL', ['certificate_number' => 'q 7001', 'manufacturer_name' => 'SAMPLE CEMENT CORPORATION.'])->assertCreated()
            ->assertJsonPath('data.compliance_status', 'VERIFIED')->assertJsonPath('data.status', 'ACTIVE')
            ->assertJsonPath('data.compliance_submissions.0.latest_review.source', 'SYSTEM_REGISTER_MATCH');
        $submissionId = DB::table('compliance_submissions')->where('vendor_listing_id', $exact)->value('id');
        $this->assertDatabaseHas('compliance_reviews', ['compliance_submission_id' => $submissionId, 'decision' => 'APPROVED', 'reviewer_user_id' => null]);
        $this->assertDatabaseHas('compliance_reference_matches', ['compliance_submission_id' => $submissionId, 'result' => 'MATCHED']);

        foreach (['CEM-C' => ['certificate_number' => 'Q-7001', 'manufacturer_name' => 'Another Company'], 'CEM-D' => ['certificate_number' => 'Q-7002', 'manufacturer_name' => 'Expired Cement Co.'], 'CEM-E' => ['certificate_number' => 'Q-9999', 'manufacturer_name' => 'Sample Cement Corporation']] as $sku => $declared) {
            $listing = $this->publishableListing('PORTLAND_CEMENT', $sku, ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
            $this->submitCompliance($listing, 'MANUAL', $declared)->assertCreated()->assertJsonPath('data.compliance_status', 'PENDING_ADMIN_REVIEW');
            $result = DB::table('compliance_reference_matches as m')->join('compliance_submissions as s', 's.id', '=', 'm.compliance_submission_id')->where('s.vendor_listing_id', $listing)->value('m.result');
            self::assertSame($sku === 'CEM-E' ? 'UNMATCHED' : 'UNCERTAIN', $result);
        }
        try {
            DB::transaction(fn () => DB::table('compliance_reference_records')->where('compliance_reference_register_id', $register['id'])->update(['company_name' => 'Changed']));
            self::fail('A register snapshot record was modified.');
        } catch (QueryException) {
            self::assertTrue(true);
        }
    }

    public function test_material_search_prefers_aliases_and_uses_pg_trgm_for_typos(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendor/catalog/materials/search?q=Semento')->assertOk()->assertJsonPath('data.0.code', 'PORTLAND_CEMENT')->assertJsonPath('data.0.match_type', 'ALIAS');
        $this->getJson('/api/v1/vendor/catalog/materials/search?q=Portland%20cement')->assertOk()->assertJsonPath('data.0.match_type', 'EXACT');
        $fuzzy = $this->getJson('/api/v1/vendor/catalog/materials/search?q=portlnd%20cemnt')->assertOk()->json('data');
        self::assertSame('PORTLAND_CEMENT', $fuzzy[0]['code']);
        self::assertSame('FUZZY', $fuzzy[0]['match_type']);
        self::assertTrue($fuzzy[0]['regulated']);
        $this->getJson('/api/v1/vendor/catalog/materials/search?q=zzqxv')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/vendor/catalog/materials/search?q=a')->assertUnprocessable();
        self::assertTrue(collect(DB::select("SELECT indexname FROM pg_indexes WHERE tablename = 'material_aliases'"))->contains('indexname', 'material_aliases_trgm_index'));

        // A near-match to a regulated material cannot stay unmatched to bypass the PS/ICC gate.
        $listing = $this->createListing('Portland cemnt', 'NEAR-1');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, ['lock_version' => 1, 'other_label' => 'Bagged binder', 'material_category_id' => DB::table('material_categories')->where('code', 'CEMENT_AND_CONCRETE')->value('id')])->assertOk();
        $blockers = collect($this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data.blockers'));
        self::assertTrue($blockers->contains(fn (array $blocker): bool => $blocker['key'] === 'material' && str_contains($blocker['reason'], 'Portland cement')));
    }

    public function test_price_versions_and_publication_snapshots_preserve_history_for_later_orders(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-4', ['thickness_mm' => '100']);
        $this->publish($listing)->assertOk();
        $first = DB::table('listing_publication_snapshots')->where('vendor_listing_id', $listing)->where('publication_version', 1)->first();
        $firstSnapshot = json_decode($first->snapshot, true);
        self::assertSame(1800, $firstSnapshot['variants'][0]['price']['amount_centavos']);
        self::assertSame('Phase Four Store', $firstSnapshot['store']['public_store_name']);

        $current = $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data');
        $variants = $current['variants'];
        $variants[0]['price_centavos'] = 1950;
        $variants[0]['tax_category'] = 'NON_VAT';
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])->assertOk()->assertJsonPath('data.variants.0.price.version', 2)->assertJsonPath('data.publication_version', 2);
        $versions = DB::table('listing_price_versions')->where('listing_variant_id', $variants[0]['id'])->orderBy('version')->get();
        self::assertCount(2, $versions);
        self::assertNotNull($versions[0]->retired_at);
        self::assertSame($versions[0]->id, $versions[1]->supersedes_price_version_id);
        $second = json_decode(DB::table('listing_publication_snapshots')->where('vendor_listing_id', $listing)->where('publication_version', 2)->value('snapshot'), true);
        self::assertSame(1950, $second['variants'][0]['price']['amount_centavos']);
        self::assertSame($versions[0]->id, json_decode(DB::table('listing_publication_snapshots')->where('id', $first->id)->value('snapshot'), true)['variants'][0]['price']['price_version_id']);

        foreach ([
            fn () => DB::table('listing_price_versions')->where('id', $versions[0]->id)->update(['amount_centavos' => 1]),
            fn () => DB::table('listing_price_versions')->where('id', $versions[0]->id)->delete(),
            fn () => DB::table('listing_publication_snapshots')->where('id', $first->id)->update(['content_hash' => 'x']),
            fn () => DB::table('listing_status_history')->where('vendor_listing_id', $listing)->delete(),
        ] as $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Immutable catalog history was modified.');
            } catch (QueryException $exception) {
                self::assertStringContainsString('immutable', $exception->getMessage());
            }
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])->assertConflict();
    }

    public function test_mat03_comparable_groups_use_exact_keys_and_ordinary_vat_inclusive_prices(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $exact = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-4', ['thickness_mm' => '100'], brand: 'BlockCo', packQuantity: '10', price: 15000);
        $different = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-6', ['thickness_mm' => '150'], brand: 'BlockCo');
        $otherBrand = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-4B', ['thickness_mm' => '100'], brand: 'OtherBlocks');

        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $group = $this->postJson('/api/v1/admin/taxonomy/comparable-groups', ['material_id' => $material->id, 'code' => 'CHB_100_BLOCKCO', 'display_name' => 'CHB 100 mm BlockCo', 'brand' => 'BlockCo', 'specification' => ['thickness_mm' => '100'], 'canonical_unit_id' => $material->canonical_unit_id])
            ->assertCreated()->assertJsonPath('data.mapped_variants', 1)->json('data');
        $this->signInAdmin($this->admin('ADMIN_PRODUCT_COMPLIANCE'));
        $this->postJson('/api/v1/admin/taxonomy/comparable-groups', ['material_id' => $material->id, 'code' => 'CHB_X', 'display_name' => 'X', 'specification' => ['thickness_mm' => '100'], 'canonical_unit_id' => $material->canonical_unit_id])->assertForbidden();

        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendor/catalog/listings/'.$exact)->assertJsonPath('data.variants.0.comparability', 'COMPARABLE');
        $this->getJson('/api/v1/vendor/catalog/listings/'.$different)->assertJsonPath('data.variants.0.comparability', 'NOT_YET_COMPARABLE');
        $this->getJson('/api/v1/vendor/catalog/listings/'.$otherBrand)->assertJsonPath('data.variants.0.comparability', 'NOT_YET_COMPARABLE');

        $variantId = DB::table('listing_variants')->where('vendor_listing_id', $exact)->value('id');
        $mapping = app(ComparableMappingService::class);
        self::assertSame('15.00000000', $mapping->normalizedPrice(15000, '10', (string) DB::table('listing_variants')->where('id', $variantId)->value('unit_id'), $group['group_version_id']));
        self::assertSame('0.33333333', $mapping->normalizedPrice(100, '3', (string) $material->canonical_unit_id, $group['group_version_id']));
        // Units without an approved conversion never normalize into the group.
        self::assertNull($mapping->normalizedPrice(100, '1', (string) DB::table('units')->where('code', 'KG')->value('id'), $group['group_version_id']));

        // Promotional, volume-tier and negotiated amounts never replace the ordinary analytics source.
        $ordinary = $mapping->ordinaryPublicPrice((string) $variantId);
        foreach (['PROMOTIONAL' => [21, null], 'VOLUME_TIER' => [22, '100'], 'NEGOTIATED' => [23, null]] as $kind => [$priceVersion, $minimum]) {
            DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => $priceVersion, 'amount_centavos' => 1000, 'currency' => 'PHP', 'tax_category' => 'NON_VAT', 'price_kind' => $kind, 'minimum_quantity' => $minimum, 'effective_at' => now(), 'created_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        }
        self::assertSame($ordinary->id, $mapping->ordinaryPublicPrice((string) $variantId)?->id);
        self::assertSame(1, DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->count());

        // FIN-02 classifications remain distinct and follow the reviewed VAT profile.
        $current = $this->getJson('/api/v1/vendor/catalog/listings/'.$exact)->json('data');
        $variants = array_map(static fn (array $variant): array => array_diff_key($variant, ['volume_tiers' => true]), $current['variants']);
        $variants[0]['price_centavos'] = 15000;
        $variants[0]['tax_category'] = 'VAT_12';
        $this->putJson('/api/v1/vendor/catalog/listings/'.$exact.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])
            ->assertUnprocessable()->assertJsonPath('errors.0.details', ['variants.0.tax_category' => ['This classification is not permitted by your reviewed VAT registration.']]);
        DB::table('vendor_tax_profile_versions')->whereIn('vendor_tax_profile_id', DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->id)->pluck('id'))->update(['vat_verified_category' => 'VAT', 'vat_category' => 'VAT']);
        $variants[0]['tax_category'] = 'VAT_ZERO';
        $this->putJson('/api/v1/vendor/catalog/listings/'.$exact.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])
            ->assertUnprocessable()->assertJsonPath('errors.0.details', ['variants.0.tax_basis' => ['Zero-rated and exempt lines need their supporting basis.']]);
        $variants[0]['tax_category'] = 'VAT_12';
        $this->putJson('/api/v1/vendor/catalog/listings/'.$exact.'/variants', ['lock_version' => $current['lock_version'], 'variants' => $variants])->assertOk()
            ->assertJsonPath('data.variants.0.price.tax_category', 'VAT_12')->assertJsonPath('data.variants.0.price.included_vat_centavos', 1607);
        // An unknown reviewed VAT classification blocks payable publication.
        DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization->id)->update(['status' => 'PENDING']);
        $blockers = collect($this->getJson('/api/v1/vendor/catalog/listings/'.$different)->json('data.blockers'));
        self::assertTrue($blockers->contains('key', 'variants.0.tax_category'));
        $this->publish($different)->assertUnprocessable()->assertJsonPath('errors.0.code', 'LISTING_NOT_PUBLISHABLE');
    }

    public function test_listing_uploads_reject_file_abuse_and_fail_closed_when_scanning_is_unavailable(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->createListing('Hollow block', 'CHB-X');
        $upload = fn (UploadedFile $file): TestResponse => $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => $file]);
        $upload(UploadedFile::fake()->createWithContent('photo.png', "%PDF-1.4\n1 0 obj<</Type/Catalog>>endobj\n%%EOF"))->assertUnprocessable()->assertJsonPath('errors.0.code', 'FILE_VALIDATION_FAILED');
        // Genuine JPEG bytes presented under a PNG name are rejected by content sniffing.
        $source = UploadedFile::fake()->image('source.jpg');
        $jpeg = (string) file_get_contents($source->getPathname());
        $upload(UploadedFile::fake()->createWithContent('photo.png', $jpeg))->assertUnprocessable();
        $upload(UploadedFile::fake()->createWithContent('photo.svg', '<svg xmlns="http://www.w3.org/2000/svg"><script>alert(1)</script></svg>'))->assertUnprocessable();
        $upload(UploadedFile::fake()->image('huge.png')->size(6000))->assertUnprocessable();
        $filesBefore = DB::table('files')->count();
        $this->scannerAvailable = false;
        $upload(UploadedFile::fake()->image('ok.png'))->assertStatus(503)->assertJsonPath('errors.0.code', 'FILE_SCANNER_UNAVAILABLE');
        self::assertSame($filesBefore, DB::table('files')->count());
        $this->scannerAvailable = true;
        $media = $upload(UploadedFile::fake()->image('ok.png'))->assertCreated()->json('data.media.0');
        self::assertSame(['READY', 1, 'CLEAN', 'image/png'], [$media['status'], $media['version'], $media['scan_state'], $media['content_type']]);
        $replacement = $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image('v2.png'), 'replaces_media_id' => $media['id']])->assertCreated()->json('data.media');
        self::assertSame([2, 'READY'], [$replacement[0]['version'], $replacement[0]['status']]);
        $this->assertDatabaseHas('listing_media', ['id' => $media['id'], 'status' => 'REPLACED']);
        $this->post('/api/v1/vendor/catalog/imports', ['file' => UploadedFile::fake()->image('catalog.png')])->assertUnprocessable();
    }

    public function test_bulk_import_reports_row_errors_and_applies_validated_rows_in_one_transaction(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $header = implode(',', CatalogImportService::COLUMNS);
        $csv = $header."\n"
            .'IMP-CHB,Hollow block 4in,CONCRETE_HOLLOW_BLOCK,,,MASONRY_WORK,BlockCo,Load-bearing block,IMP-CHB-100,100 mm,PC,1,18.00,NON_VAT,,12,40,10,20,500'."\n"
            .'IMP-SAND,Washed sand,WASHED_SAND,,,BULK,,Fine sand,IMP-SAND-1,Per cubic meter,CUM,1,"1,450.50",NON_VAT,,1500,100,100,100,20'."\n"
            .'IMP-BAD,Rebar,DEFORMED_STEEL_BAR,,,STRUCTURAL,,Rebar,IMP-BAD-1,,KG,0,abc,VAT_12,,,,,,'."\n"
            .'IMP-RENT,Scaffolding for rent,,Scaffolding rental,FORMWORKS_AND_SCAFFOLDING,,,,IMP-RENT-1,,PC,1,100,NON_VAT,,,,,,'."\n";
        $job = $this->post('/api/v1/vendor/catalog/imports', ['file' => UploadedFile::fake()->createWithContent('catalog.csv', $csv)])->assertCreated()
            ->assertJsonPath('data.status', 'HAS_ERRORS')->assertJsonPath('data.valid_rows', 2)->assertJsonPath('data.error_rows', 2)->json('data');
        self::assertSame(0, DB::table('vendor_listings')->count());
        $rowErrors = collect($job['row_errors'])->keyBy('row_number');
        self::assertArrayHasKey('pack_quantity', $rowErrors[4]['errors']);
        self::assertArrayHasKey('price_php', $rowErrors[4]['errors']);
        self::assertArrayHasKey('unit_code', $rowErrors[4]['errors']);
        self::assertArrayHasKey('display_name', $rowErrors[5]['errors']);
        $this->postJson('/api/v1/vendor/catalog/imports/'.$job['id'].'/apply', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.status', 'APPLIED_WITH_REJECTIONS')->assertJsonPath('data.applied_rows', 2);
        self::assertSame(['DRAFT', 'DRAFT'], DB::table('vendor_listings')->orderBy('vendor_sku')->pluck('status')->all());
        self::assertSame(145050, (int) DB::table('listing_price_versions as p')->join('listing_variants as v', 'v.id', '=', 'p.listing_variant_id')->where('v.sku', 'IMP-SAND-1')->value('p.amount_centavos'));
        $this->postJson('/api/v1/vendor/catalog/imports/'.$job['id'].'/apply', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        $this->post('/api/v1/vendor/catalog/imports', ['file' => UploadedFile::fake()->createWithContent('bad.csv', "sku,name\nA,B\n")])->assertUnprocessable()->assertJsonPath('errors.0.code', 'IMPORT_TEMPLATE_INVALID');
    }

    public function test_variant_rows_are_validated_together_and_catalog_writes_require_store_activation(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->createListing('Hollow block', 'CHB-R');
        $unit = DB::table('units')->where('code', 'PC')->value('id');
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 1, 'variants' => [
            ['sku' => 'A', 'unit_id' => $unit, 'pack_quantity' => '1', 'price_centavos' => 1000, 'tax_category' => 'NON_VAT'],
            ['sku' => 'A', 'unit_id' => $unit, 'pack_quantity' => '0', 'price_centavos' => -5, 'tax_category' => 'UNKNOWN', 'weight_kg' => '-1'],
        ]])->assertUnprocessable()->assertJsonPath('errors.0.details', [
            'variants.1.sku' => ['Each variant SKU must be unique within the listing.'],
            'variants.1.pack_quantity' => ['Enter a pack quantity greater than zero.'],
            'variants.1.price_centavos' => ['Enter a price greater than zero.'],
            'variants.1.tax_category' => ['Choose a tax classification.'],
            'variants.1.weight_kg' => ['Enter a value greater than zero.'],
        ]);
        self::assertSame(0, DB::table('listing_variants')->where('vendor_listing_id', $listing)->count());

        [$pending, $pendingOwner] = $this->activeStore('Pending Store', 'NOT_READY');
        $this->signInVendor($pendingOwner);
        $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Early', 'vendor_sku' => 'EARLY'], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'STORE_NOT_ACTIVE');
        $this->getJson('/api/v1/vendor/catalog/listings')->assertOk()->assertJsonCount(0, 'data');
        self::assertSame(0, DB::table('vendor_listings')->where('vendor_organization_id', $pending->id)->count());
    }

    public function test_volume_tiers_are_validated_versioned_and_snapshotted(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-T', ['thickness_mm' => '100']);
        $this->publish($listing)->assertOk();
        $current = $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->json('data');
        $row = array_diff_key($current['variants'][0], ['volume_tiers' => true]) + ['price_centavos' => 1800, 'tax_category' => 'NON_VAT'];
        $save = fn (array $variant, int $lock) => $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => $lock, 'variants' => [$variant]]);

        $save($row + ['volume_tiers' => [['minimum_quantity' => '1', 'price_centavos' => 1900], ['minimum_quantity' => '1', 'price_centavos' => 1950]]], $current['lock_version'])
            ->assertUnprocessable()->assertJsonPath('errors.0.details', [
                'variants.0.volume_tiers.0.minimum_quantity' => ['Enter a minimum quantity greater than 1, with up to four decimals.'],
                'variants.0.volume_tiers.0.price_centavos' => ['A tier price must be lower than the ordinary price.'],
                'variants.0.volume_tiers.1.minimum_quantity' => ['Enter a minimum quantity greater than 1, with up to four decimals.'],
                'variants.0.volume_tiers.1.price_centavos' => ['A tier price must be lower than the ordinary price.'],
            ]);
        self::assertSame(0, DB::table('listing_price_versions')->where('price_kind', 'VOLUME_TIER')->count());

        $saved = $save($row + ['volume_tiers' => [['minimum_quantity' => '50', 'price_centavos' => 1700], ['minimum_quantity' => '100', 'price_centavos' => 1650]]], $current['lock_version'])
            ->assertOk()->assertJsonCount(2, 'data.variants.0.volume_tiers')
            ->assertJsonPath('data.variants.0.volume_tiers.0.minimum_quantity', '50.0000')->assertJsonPath('data.variants.0.volume_tiers.1.amount_centavos', 1650)
            ->assertJsonPath('data.publication_version', 2)->json('data');
        $snapshot = json_decode(DB::table('listing_publication_snapshots')->where('vendor_listing_id', $listing)->where('publication_version', 2)->value('snapshot'), true);
        self::assertSame([1700, 1650], array_column($snapshot['variants'][0]['volume_tiers'], 'amount_centavos'));
        $tierIds = array_column($saved['variants'][0]['volume_tiers'], 'price_version_id');

        // Omitting volume_tiers keeps the tiers; they must still undercut a changed ordinary price.
        $unchanged = $save($row, $saved['lock_version'])->assertOk()->json('data');
        self::assertSame($tierIds, array_column($unchanged['variants'][0]['volume_tiers'], 'price_version_id'));
        $save(['price_centavos' => 1650] + $row, $unchanged['lock_version'])->assertUnprocessable()->assertJsonPath('errors.0.details', [
            'variants.0.volume_tiers.0.price_centavos' => ['A tier price must be lower than the ordinary price.'],
            'variants.0.volume_tiers.1.price_centavos' => ['A tier price must be lower than the ordinary price.'],
        ]);

        $removed = $save($row + ['volume_tiers' => []], $unchanged['lock_version'])->assertOk()->assertJsonCount(0, 'data.variants.0.volume_tiers')->json('data');
        self::assertSame(2, DB::table('listing_price_versions')->whereIn('id', $tierIds)->whereNotNull('retired_at')->count());
        $save($row + ['volume_tiers' => [['minimum_quantity' => '10', 'price_centavos' => 1750], ['minimum_quantity' => '10', 'price_centavos' => 1700]]], $removed['lock_version'])->assertUnprocessable()
            ->assertJsonPath('errors.0.details', ['variants.0.volume_tiers.1.minimum_quantity' => ['Each tier needs a higher minimum quantity than the tier before it.']]);

        $variantId = $row['id'];
        $insert = fn () => DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => 90 + random_int(0, 9), 'amount_centavos' => 1500, 'currency' => 'PHP', 'tax_category' => 'NON_VAT', 'price_kind' => 'VOLUME_TIER', 'minimum_quantity' => '20', 'effective_at' => now(), 'created_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        DB::transaction($insert);
        $this->expectException(QueryException::class);
        DB::transaction($insert);
    }

    public function test_listing_list_reports_status_counts_units_stock_and_signed_thumbnails(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $active = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-L', ['thickness_mm' => '100']);
        $this->publish($active)->assertOk();
        $this->createListing('Draft sand', 'SAND-1');
        $unit = DB::table('units')->where('id', DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->value('canonical_unit_id'))->value('code');

        $list = $this->getJson('/api/v1/vendor/catalog/listings?status=ACTIVE')->assertOk()
            ->assertJsonPath('meta.status_counts.ACTIVE', 1)->assertJsonPath('meta.status_counts.DRAFT', 1)->assertJsonPath('meta.active_out_of_stock', 0)
            ->assertJsonCount(1, 'data')->assertJsonPath('data.0.unit_code', $unit)->assertJsonPath('data.0.available_quantity', '100.0000');
        self::assertStringContainsString('signature=', (string) $list->json('data.0.primary_image_url'));
        $this->getJson('/api/v1/vendor/catalog/listings?status=DRAFT')->assertOk()->assertJsonPath('data.0.primary_image_url', null)->assertJsonPath('data.0.unit_code', null)->assertJsonPath('data.0.available_quantity', null);

        DB::table('inventory_items')->whereIn('listing_variant_id', DB::table('listing_variants')->where('vendor_listing_id', $active)->pluck('id'))->update(['quantity_on_hand' => 0]);
        $this->getJson('/api/v1/vendor/catalog/listings?q=chb')->assertOk()->assertJsonPath('meta.active_out_of_stock', 1)->assertJsonPath('meta.status_counts.ACTIVE', 1)
            ->assertJsonMissingPath('meta.status_counts.DRAFT')->assertJsonPath('data.0.public_availability', 'OUT_OF_STOCK');
    }

    public function test_only_never_published_listings_can_be_deleted_and_their_history_is_kept(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $draft = $this->createListing('Draft gravel', 'GRAVEL-1');
        $this->getJson('/api/v1/vendor/catalog/listings?status=DRAFT')->assertOk()->assertJsonPath('data.0.deletable', true);
        $this->getJson('/api/v1/vendor/catalog/listings/'.$draft)->assertOk()->assertJsonPath('data.permissions.can_delete', true);
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$draft.'?lock_version=99')->assertConflict();
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$draft.'?lock_version=1')->assertOk()->assertJsonPath('data.id', $draft);
        $this->getJson('/api/v1/vendor/catalog/listings/'.$draft)->assertNotFound();
        $this->getJson('/api/v1/vendor/catalog/listings')->assertOk()->assertJsonCount(0, 'data');
        self::assertNotNull(DB::table('vendor_listings')->where('id', $draft)->value('removed_at'));
        self::assertSame(1, DB::table('listing_status_history')->where('vendor_listing_id', $draft)->count());
        $this->assertDatabaseHas('audit_logs', ['action' => 'CATALOG_LISTING_DELETED', 'resource_id' => $draft]);
        // The deleted draft's SKU is free again.
        $this->createListing('Draft gravel again', 'GRAVEL-1');

        // A pending PS/ICC submission on a never-published regulated draft is superseded, not left for a reviewer.
        $regulated = $this->publishableListing('PORTLAND_CEMENT', 'CEM-DEL', ['cement_type' => 'Type I', 'bag_weight_kg' => '40'], regulated: true);
        $this->submitCompliance($regulated, 'MANUAL', ['certificate_number' => 'Q-9999', 'manufacturer_name' => 'Unlisted Maker'])->assertCreated()->assertJsonPath('data.compliance_status', 'PENDING_ADMIN_REVIEW');
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$regulated.'?lock_version='.DB::table('vendor_listings')->where('id', $regulated)->value('lock_version'))->assertOk();
        self::assertSame(['SUPERSEDED'], DB::table('compliance_submissions')->where('vendor_listing_id', $regulated)->pluck('status')->unique()->values()->all());

        // Anything Buyers have seen keeps its history: published, and later deactivated, listings cannot be deleted.
        $published = $this->publishableListing('CONCRETE_HOLLOW_BLOCK', 'CHB-DEL', ['thickness_mm' => '100']);
        $this->publish($published)->assertOk()->assertJsonPath('data.status', 'ACTIVE');
        $this->getJson('/api/v1/vendor/catalog/listings/'.$published)->assertJsonPath('data.permissions.can_delete', false);
        $version = fn (): int => (int) DB::table('vendor_listings')->where('id', $published)->value('lock_version');
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$published.'?lock_version='.$version())->assertConflict()->assertJsonPath('errors.0.code', 'LISTING_HAS_PUBLICATION_HISTORY');
        $this->postJson('/api/v1/vendor/catalog/listings/'.$published.'/deactivate', ['lock_version' => $version()])->assertOk()->assertJsonPath('data.status', 'INACTIVE');
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$published.'?lock_version='.$version())->assertConflict();
        try {
            DB::transaction(fn () => DB::table('vendor_listings')->where('id', $published)->update(['removed_at' => now(), 'removed_by_user_id' => $owner->id]));
            self::fail('A published listing was removed directly.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('vendor_listing_removal_check', $exception->getMessage());
        }

        // Read-only roles cannot delete.
        $other = $this->createListing('Draft sand', 'SAND-DEL');
        $this->signInVendor($this->member($organization, 'CUSTOMER_SERVICE'));
        $this->getJson('/api/v1/vendor/catalog/listings/'.$other)->assertOk()->assertJsonPath('data.permissions.can_delete', false);
        $this->deleteJson('/api/v1/vendor/catalog/listings/'.$other.'?lock_version=1')->assertForbidden();
    }

    private function publishableListing(string $materialCode, string $sku, array $attributes, bool $regulated = false, string $brand = 'BrandCo', string $packQuantity = '1', int $price = 1800): string
    {
        $material = DB::table('materials')->where('code', $materialCode)->first();
        self::assertSame($regulated, (bool) $material->regulated);
        $listing = $this->createListing('Listing '.$sku, $sku);
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, [
            'lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => $brand, 'manufacturer' => 'Sample Cement Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => $attributes,
        ])->assertOk()->assertJsonPath('data.regulated', $regulated);
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => [[
            'sku' => $sku.'-V1', 'label' => 'Standard', 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => $packQuantity, 'price_centavos' => $price, 'tax_category' => 'NON_VAT',
            'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => '100',
        ]]])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Product photo'])->assertCreated();

        return $listing;
    }

    private function createListing(string $name, string $sku): string
    {
        return (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => $name, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
    }

    private function publish(string $listing): TestResponse
    {
        return $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    /** @param array<string, string> $declared */
    private function submitCompliance(string $listing, string $path, array $declared): TestResponse
    {
        $evidence = $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/compliance/evidence', ['path' => $path, 'file' => UploadedFile::fake()->image('marking.jpg')])->assertCreated()->json('data');
        if ($path === 'PHOTO_OCR') {
            self::assertSame('UNAVAILABLE', $evidence['extraction']['status']);
        }

        return $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/compliance', $declared + [
            'listing_lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version'), 'path' => $path, 'evidence_ids' => [$evidence['evidence_id']],
            'marking_type' => 'PS_MARK', 'confirmed' => true,
        ], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    /** @return array{VendorOrganization, User} */
    private function activeStore(string $name = 'Phase Four Store', string $activation = 'ACTIVE'): array
    {
        $organization = VendorOrganization::query()->create(['legal_name' => $name.' Legal', 'store_name' => $name]);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['account_status' => 'ACTIVE', 'store_activation_status' => $activation, 'store_verification_status' => 'APPROVED', 'store_setup_status' => 'COMPLETED']);
        $storeProfileId = (string) Str::uuid7();
        DB::table('store_profiles')->insert(['id' => $storeProfileId, 'vendor_organization_id' => $organization->id, 'public_store_name' => $name, 'status' => 'COMPLETED', 'created_at' => now(), 'updated_at' => now()]);
        app(StoreOperatingSchedule::class)->replaceWeekly($storeProfileId, array_map(fn (int $day): array => ['day_of_week' => $day, 'status' => $day === 7 ? 'CLOSED' : 'OPEN', 'opens_at' => $day === 7 ? null : '08:00', 'closes_at' => $day === 7 ? null : '17:00'], range(1, 7)));
        $owner = $this->member($organization, 'OWNER');
        $profileId = (string) Str::uuid7();
        DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization->id, 'status' => 'APPROVED', 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
        $versionId = (string) Str::uuid7();
        DB::table('vendor_tax_profile_versions')->insert(['id' => $versionId, 'vendor_tax_profile_id' => $profileId, 'version' => 1, 'taxpayer_key_hash' => hash('sha256', $name), 'entity_class' => 'NON_INDIVIDUAL', 'registration_category' => 'BIR_REGISTERED', 'vat_category' => 'NON_VAT', 'vat_verified_category' => 'NON_VAT', 'effective_from' => now(), 'submitted_by_user_id' => $owner->id, 'content_hash' => hash('sha256', $versionId), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $versionId]);
        $organization->refresh();

        return [$organization, $owner];
    }

    private function member(VendorOrganization $organization, string $role): User
    {
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $user->getKey(), 'role' => $role, 'status' => 'ACTIVE', 'can_manage_staff' => false]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE4TESTSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE4ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInVendor(User $user): void
    {
        $this->signIn($user, 'VENDOR');
    }

    private function signInAdmin(User $user): void
    {
        $this->signIn($user, 'ADMIN');
    }

    private function signIn(User $user, string $scope): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => [$scope]]));
        $this->actingAs($user, 'api');
    }

    private function pdf(): UploadedFile
    {
        return UploadedFile::fake()->createWithContent('evidence.pdf', "%PDF-1.4\n1 0 obj<</Type/Catalog>>endobj\n%%EOF");
    }
}
