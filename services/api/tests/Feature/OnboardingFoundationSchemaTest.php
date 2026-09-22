<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Domain\Vendors\OnboardingRequirementResolver;
use App\Models\User;
use App\Models\VendorOrganization;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Tests\TestCase;

final class OnboardingFoundationSchemaTest extends TestCase
{
    use RefreshDatabase;

    public function test_fresh_schema_has_foundation_tables_and_geography_index(): void
    {
        foreach (['vendor_onboarding_requirements', 'vendor_onboarding_drafts', 'vendor_documents', 'vendor_document_versions', 'vendor_representative_versions', 'vendor_authority_reviews', 'vendor_verification_change_history', 'vendor_tax_profiles', 'vendor_tax_profile_versions', 'vendor_addresses', 'vendor_address_versions', 'privacy_acknowledgments', 'vendor_activation_history'] as $table) {
            self::assertSame('BASE TABLE', DB::table('information_schema.tables')->where('table_schema', 'public')->where('table_name', $table)->value('table_type'), $table);
        }
        self::assertStringContainsString('USING gist (location)', DB::table('pg_indexes')->where('indexname', 'vendor_address_location_gist')->value('indexdef'));
    }

    public function test_complete_empty_database_migration_and_rollback_cycle(): void
    {
        // Tests\TestCase proves the dedicated PostgreSQL 16 test database before this can run.
        self::assertSame(0, Artisan::call('migrate:rollback', ['--force' => true]), Artisan::output());
        self::assertFalse(Schema::hasTable('vendor_organizations'));
        self::assertSame(0, Artisan::call('migrate', ['--force' => true]), Artisan::output());
        self::assertTrue(Schema::hasTable('vendor_onboarding_requirements'));
        self::assertTrue(Schema::hasTable('privacy_acknowledgments'));
    }

    public function test_upgrade_and_rollback_preserve_existing_requirement_ids_and_states(): void
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Migration fixture', 'store_name' => 'Migration fixture']);
        app(OnboardingRequirementResolver::class)->synchronize($organization->id);
        $before = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->orderBy('id')->get(['id', 'status'])->toArray();
        $migration = require database_path('migrations/2026_09_21_010000_complete_onboarding_domain_foundation.php');
        $migration->down();
        self::assertFalse(Schema::hasTable('vendor_onboarding_drafts'));
        self::assertSame(json_encode($before), json_encode(DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization->id)->orderBy('id')->get(['id', 'status'])->toArray()));
        $actor = User::factory()->create();
        $profileId = (string) Str::uuid7();
        $taxVersionId = (string) Str::uuid7();
        DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization->id, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profile_versions')->insert(['id' => $taxVersionId, 'vendor_tax_profile_id' => $profileId, 'version' => 1, 'taxpayer_key_hash' => hash('sha256', 'synthetic taxpayer'), 'entity_class' => 'INDIVIDUAL', 'registration_category' => 'OTHER', 'vat_category' => 'NON_VAT', 'effective_from' => now(), 'submitted_by_user_id' => $actor->id, 'content_hash' => hash('sha256', 'synthetic tax version'), 'tin_encrypted' => Crypt::encryptString('123456789'), 'tin_branch_code' => '00000', 'tax_details' => json_encode(['tax_relief_claimed' => true, 'declaration_year' => 2026]), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $taxVersionId]);
        $addressId = (string) Str::uuid7();
        DB::table('addresses')->insert(['id' => $addressId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organization->id, 'formatted_address' => 'Synthetic street, Manila', 'street' => 'Synthetic street', 'barangay' => 'Synthetic barangay', 'city_municipality' => 'Manila', 'province' => 'Metro Manila', 'latitude' => 14.5995, 'longitude' => 120.9842, 'location' => DB::raw('ST_SetSRID(ST_MakePoint(120.9842,14.5995),4326)::geography'), 'version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $migration->up();
        self::assertSame(json_encode($before), json_encode(DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->orderBy('id')->get(['id', 'status'])->toArray()));
        $tax = DB::table('vendor_tax_profile_versions')->where('id', $taxVersionId)->first();
        self::assertNull($tax->tin_branch_code);
        self::assertNotSame('00000', $tax->branch_code_encrypted);
        self::assertSame('00000', Crypt::decryptString($tax->branch_code_encrypted));
        self::assertTrue($tax->declaration_claim);
        self::assertSame(2026, $tax->taxable_year);
        $this->assertDatabaseHas('vendor_address_versions', ['id' => $addressId, 'street' => 'Synthetic street', 'country_code' => 'PH']);
        $this->assertDatabaseHas('vendor_addresses', ['vendor_organization_id' => $organization->id, 'current_version_id' => $addressId]);
        $migration->down();
        self::assertSame('00000', DB::table('vendor_tax_profile_versions')->where('id', $taxVersionId)->value('tin_branch_code'));
        $migration->up();
    }

    public function test_not_applicable_cannot_hide_required_items_or_omit_a_reason(): void
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Requirement fixture', 'store_name' => 'Requirement fixture']);
        app(OnboardingRequirementResolver::class)->synchronize($organization->id);
        foreach ([['REQUIRED', 'Not needed'], ['OPTIONAL', 'Not needed'], ['CONDITIONALLY_REQUIRED', null], ['CONDITIONALLY_REQUIRED', '   ']] as [$level, $reason]) {
            try {
                DB::transaction(fn () => DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->where('requirement_key', 'business_type')->update(['level' => $level, 'status' => 'NOT_APPLICABLE', 'applicability_reason' => $reason]));
                self::fail('An invalid NOT_APPLICABLE state was accepted.');
            } catch (QueryException $exception) {
                self::assertSame('23514', $exception->errorInfo[0]);
            }
        }
    }

    public function test_input_changes_reopen_approved_requirements_without_losing_unrelated_approvals(): void
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Resolver fixture', 'store_name' => 'Resolver fixture', 'business_type' => 'SOLE_PROPRIETORSHIP']);
        $resolver = app(OnboardingRequirementResolver::class);
        $resolver->synchronize($organization->id);
        DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organization->id)->whereIn('requirement_key', ['business_registration', 'registered_business_address'])->update(['status' => 'APPROVED']);
        $organization->update(['business_type' => 'COOPERATIVE']);
        $resolver->synchronize($organization->id);
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'business_registration', 'status' => 'IN_PROGRESS']);
        $this->assertDatabaseHas('vendor_onboarding_requirements', ['vendor_organization_id' => $organization->id, 'requirement_key' => 'registered_business_address', 'status' => 'APPROVED']);
    }
}
