<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->string('business_type', 32)->nullable();
            $table->date('established_on')->nullable();
            $table->jsonb('business_draft')->nullable();
            $table->boolean('bulk_capability_recorded')->default(false);
            $table->boolean('activation_hold')->default(false);
            $table->string('withholding_demo_scenario', 32)->nullable();
            $table->timestampTz('submitted_at')->nullable();
        });
        Schema::table('vendor_contacts', function (Blueprint $table): void {
            $table->boolean('is_primary')->default(false);
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('deactivated_at')->nullable();
        });
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->boolean('cod_enabled')->default(false);
            $table->boolean('in_store_payment_enabled')->default(false);
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('business_document_versions', function (Blueprint $table): void {
            $table->string('environment', 8)->default('TEST');
            $table->string('evidence_origin', 32)->default('SAMPLE_DEMO');
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
        Schema::table('business_document_reviews', function (Blueprint $table): void {
            $table->string('verified_reference')->nullable();
            $table->date('verified_issued_on')->nullable();
            $table->date('verified_expires_on')->nullable();
            $table->boolean('verified_expiry_not_applicable')->default(false);
            $table->text('remarks')->nullable();
            $table->boolean('immediate_restriction')->default(false);
            $table->string('environment', 8)->default('TEST');
        });
        Schema::table('business_documents', function (Blueprint $table): void {
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('expiry_warned_at')->nullable();
            $table->unique(['vendor_organization_id', 'document_type']);
        });
        Schema::table('files', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('evidence_origin', 32)->default('SAMPLE_DEMO');
        });
        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->jsonb('profile_data')->nullable();
            $table->string('environment', 8)->default('TEST');
            $table->string('evidence_origin', 32)->default('SAMPLE_DEMO');
            $table->timestampTz('owner_attested_at')->nullable();
        });
        Schema::create('vendor_tax_profile_reviews', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_tax_profile_version_id')->constrained()->restrictOnDelete();
            $table->foreignId('reviewer_user_id')->constrained('users')->restrictOnDelete();
            $table->string('decision', 32);
            $table->text('reason')->nullable();
            $table->string('approval_scope', 64);
            $table->string('environment', 8)->default('TEST');
            $table->timestampsTz();
        });
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            $table->string('evidence_origin', 32)->nullable();
            $table->timestampTz('checked_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('vendor_activation_history', function (Blueprint $table): void {
            $table->string('rule_version', 32)->nullable();
            $table->jsonb('result')->nullable();
            $table->string('correlation_id', 64)->nullable();
        });
        Schema::table('vendor_invitations', function (Blueprint $table): void {
            $table->string('full_name')->nullable();
            $table->string('telephone_e164', 20)->nullable();
            $table->foreignId('accepted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('expiry_recorded_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('vendor_memberships', fn (Blueprint $table) => $table->unsignedInteger('lock_version')->default(1));

        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_business_type_check CHECK (business_type IS NULL OR business_type IN ('SOLE_PROPRIETORSHIP','PARTNERSHIP','CORPORATION'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_onboarding_state_check CHECK (onboarding_status IN ('NOT_STARTED','IN_PROGRESS','PENDING_VERIFICATION','CHANGES_REQUIRED','APPROVED','REJECTED','COMPLETED'))");
        DB::statement('CREATE UNIQUE INDEX vendor_primary_contact_unique ON vendor_contacts (vendor_organization_id) WHERE is_primary AND deactivated_at IS NULL');
        DB::statement('ALTER TABLE business_document_reviews ADD CONSTRAINT verified_expiry_check CHECK (NOT verified_expiry_not_applicable OR verified_expires_on IS NULL)');
        DB::statement("ALTER TABLE vendor_tax_profile_reviews ADD CONSTRAINT tax_review_decision_check CHECK (decision IN ('APPROVE','RETURN_FOR_CORRECTION','REJECT') AND (decision = 'APPROVE' OR (reason IS NOT NULL AND length(trim(reason)) >= 3)))");
        DB::unprepared("CREATE OR REPLACE FUNCTION phase_three_immutable() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'Historical evidence is immutable'; END; $$");
        foreach ($this->immutableTables() as $name) {
            DB::statement("CREATE TRIGGER phase_three_immutable BEFORE UPDATE OR DELETE ON {$name} FOR EACH ROW EXECUTE FUNCTION phase_three_immutable()");
        }
        foreach (['vendors.verify', 'vendors.review_tax_evidence'] as $code) {
            $permission = DB::table('permissions')->where('code', $code)->value('id');
            if ($permission === null) {
                $permission = (string) Str::uuid7();
                DB::table('permissions')->insert(['id' => $permission, 'code' => $code, 'description' => $code, 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach (['ADMIN_SUPERADMIN', 'ADMIN_VENDOR_VERIFICATION'] as $role) {
                $roleId = DB::table('platform_roles')->where('code', $role)->value('id');
                if (! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permission)->exists()) {
                    DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permission, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
    }

    /** @return list<string> */
    private function immutableTables(): array
    {
        return ['business_document_versions', 'business_document_reviews', 'vendor_tax_profile_versions', 'vendor_tax_profile_reviews', 'vendor_activation_history'];
    }

    public function down(): void
    {
        foreach ($this->immutableTables() as $name) {
            DB::statement("DROP TRIGGER phase_three_immutable ON {$name}");
        }
        DB::statement('DROP FUNCTION phase_three_immutable()');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_business_type_check, DROP CONSTRAINT vendor_onboarding_state_check');
        DB::statement('DROP INDEX vendor_primary_contact_unique');
        DB::statement('ALTER TABLE business_document_reviews DROP CONSTRAINT verified_expiry_check');
        Schema::dropIfExists('vendor_tax_profile_reviews');
        Schema::table('files', fn (Blueprint $table) => $table->dropForeign(['vendor_organization_id']));
        Schema::table('business_document_versions', fn (Blueprint $table) => $table->dropForeign(['uploaded_by_user_id']));
        Schema::table('vendor_invitations', fn (Blueprint $table) => $table->dropForeign(['accepted_by_user_id']));
        Schema::table('business_documents', fn (Blueprint $table) => $table->dropUnique(['vendor_organization_id', 'document_type']));
        foreach ([
            'vendor_organizations' => ['business_type', 'established_on', 'business_draft', 'bulk_capability_recorded', 'activation_hold', 'withholding_demo_scenario', 'submitted_at'],
            'vendor_contacts' => ['is_primary', 'lock_version', 'deactivated_at'],
            'store_profiles' => ['cod_enabled', 'in_store_payment_enabled', 'lock_version'],
            'business_document_versions' => ['environment', 'evidence_origin', 'uploaded_by_user_id'],
            'business_document_reviews' => ['verified_reference', 'verified_issued_on', 'verified_expires_on', 'verified_expiry_not_applicable', 'remarks', 'immediate_restriction', 'environment'],
            'business_documents' => ['lock_version', 'expiry_warned_at'],
            'files' => ['vendor_organization_id', 'environment', 'evidence_origin'],
            'vendor_tax_profile_versions' => ['profile_data', 'environment', 'evidence_origin', 'owner_attested_at'],
            'vendor_payment_accounts' => ['evidence_origin', 'checked_at', 'lock_version'],
            'vendor_activation_history' => ['rule_version', 'result', 'correlation_id'],
            'vendor_invitations' => ['full_name', 'telephone_e164', 'accepted_by_user_id', 'expiry_recorded_at', 'lock_version'],
            'vendor_memberships' => ['lock_version'],
        ] as $name => $columns) {
            Schema::table($name, fn (Blueprint $table) => $table->dropColumn($columns));
        }
        // Permission identities can be referenced by accepted authorization history.
    }
};
