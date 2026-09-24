<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->string('business_type', 32)->nullable();
            $table->string('registered_name')->nullable();
            $table->date('date_established')->nullable();
            $table->string('store_email')->nullable();
            $table->timestampTz('store_email_verified_at')->nullable();
            $table->string('store_phone', 24)->nullable();
            $table->string('store_verification_status', 32)->default('NOT_STARTED')->index();
            $table->string('store_setup_status', 32)->default('NOT_STARTED')->index();
            $table->string('store_activation_status', 24)->default('NOT_READY')->index();
            $table->string('marketplace_discoverability_status', 24)->default('NOT_DISCOVERABLE')->index();
            $table->timestampTz('onboarding_welcome_dismissed_at')->nullable();
            $table->string('activation_hold_code', 64)->nullable();
            $table->text('activation_hold_reason')->nullable();
        });

        Schema::table('addresses', function (Blueprint $table): void {
            $table->string('street')->nullable();
            $table->string('unit')->nullable();
            $table->string('barangay')->nullable();
            $table->string('city_municipality')->nullable();
            $table->string('province')->nullable();
            $table->string('postal_code', 16)->nullable();
            $table->string('source', 24)->default('MANUAL');
            $table->string('provider', 32)->nullable();
            $table->string('provider_place_id', 191)->nullable();
            $table->string('review_state', 24)->default('UNREVIEWED');
            $table->unsignedInteger('version')->default(1);
            $table->boolean('is_current')->default(true);
        });

        Schema::table('files', function (Blueprint $table): void {
            $table->string('original_name')->nullable();
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->jsonb('metadata')->nullable();
        });

        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->foreignUuid('image_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->decimal('cargo_length_m', 8, 2)->nullable();
            $table->decimal('cargo_width_m', 8, 2)->nullable();
            $table->decimal('cargo_height_m', 8, 2)->nullable();
            $table->string('heavy_classification', 32)->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });

        Schema::table('vendor_invitations', function (Blueprint $table): void {
            $table->string('invitee_name')->nullable();
            $table->string('invitee_mobile', 24)->nullable();
        });

        Schema::table('vendor_tax_profiles', function (Blueprint $table): void {
            $table->timestampTz('attested_at')->nullable();
            $table->foreignId('attested_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->text('taxpayer_key_encrypted')->nullable();
            $table->string('taxpayer_key_last4', 4)->nullable();
            $table->string('tin_last4', 4)->nullable();
            $table->jsonb('tax_details')->nullable();
            $table->foreignId('drafted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('owner_attested_at')->nullable();
            $table->foreignId('owner_attested_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        $this->entity('vendor_onboarding_steps', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('section', 24);
            $table->string('requirement_key', 64);
            $table->string('level', 24);
            $table->string('status', 32)->default('NOT_STARTED');
            $table->text('applicability_reason')->nullable();
            $table->string('source_version', 32)->default('phase3.v1');
            $table->unsignedInteger('version')->default(1);
            $table->boolean('is_current')->default(true);
            $table->foreignId('submitted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('submitted_at')->nullable();
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('reviewed_at')->nullable();
            $table->text('last_reason')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->unique(['vendor_organization_id', 'section', 'requirement_key', 'version'], 'vendor_onboarding_step_version_unique');
            $table->index(['vendor_organization_id', 'section', 'is_current']);
        });

        $this->entity('vendor_contacts', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('full_name');
            $table->string('title')->nullable();
            $table->string('email')->nullable();
            $table->string('phone', 24)->nullable();
            $table->boolean('is_primary')->default(false);
            $table->boolean('is_public')->default(false);
            $table->boolean('is_authorized')->default(false);
            $table->boolean('active')->default(true);
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['vendor_organization_id', 'active']);
        });

        $this->entity('vendor_classifications', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->string('supplier_type', 40);
            $table->jsonb('niches')->default('[]');
            $table->string('custom_label')->nullable();
            $table->unsignedInteger('version')->default(1);
            $table->unsignedInteger('lock_version')->default(1);
        });

        $this->entity('store_profiles', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->string('public_store_name');
            $table->text('description')->nullable();
            $table->boolean('bulk_capability')->nullable();
            $table->string('fulfillment_method', 24)->nullable();
            $table->foreignUuid('logo_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->foreignUuid('banner_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->string('public_email')->nullable();
            $table->string('public_phone', 24)->nullable();
            $table->string('status', 24)->default('DRAFT');
            $table->unsignedInteger('version')->default(1);
            $table->unsignedInteger('lock_version')->default(1);
        });

        $this->entity('store_media', function (Blueprint $table): void {
            $table->foreignUuid('store_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('kind', 24);
            $table->string('alt_text')->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->string('status', 24)->default('PENDING_SCAN');
            $table->unique(['store_profile_id', 'file_id']);
        });

        $this->entity('operating_hours', function (Blueprint $table): void {
            $table->foreignUuid('store_profile_id')->constrained()->restrictOnDelete();
            $table->unsignedSmallInteger('day_of_week');
            $table->boolean('is_closed')->default(false);
            $table->time('opens_at')->nullable();
            $table->time('closes_at')->nullable();
            $table->unique(['store_profile_id', 'day_of_week']);
        });

        $this->entity('delivery_service_areas', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('address_id')->nullable()->constrained('addresses')->restrictOnDelete();
            $table->string('area_type', 24)->default('RADIUS');
            $table->unsignedSmallInteger('maximum_distance_km')->nullable();
            $table->text('coverage_notes')->nullable();
            $table->boolean('active')->default(true);
            $table->unsignedInteger('version')->default(1);
            $table->unsignedInteger('lock_version')->default(1);
        });

        $this->entity('business_documents', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('onboarding_step_id')->nullable()->constrained('vendor_onboarding_steps')->restrictOnDelete();
            $table->string('requirement_key', 64);
            $table->string('document_type', 48);
            $table->uuid('current_version_id')->nullable();
            $table->string('status', 32)->default('NOT_SUBMITTED');
            $table->unsignedInteger('lock_version')->default(1);
            $table->unique(['vendor_organization_id', 'requirement_key']);
        });

        $this->entity('business_document_versions', function (Blueprint $table): void {
            $table->foreignUuid('business_document_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->foreignId('uploaded_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('content_hash', 64);
            $table->string('scan_state', 24)->default('PENDING');
            $table->jsonb('vendor_metadata')->nullable();
            $table->uuid('supersedes_version_id')->nullable();
            $table->timestampTz('submitted_at')->nullable();
            $table->unique(['business_document_id', 'version']);
        });

        Schema::table('business_documents', function (Blueprint $table): void {
            $table->foreign('current_version_id')->references('id')->on('business_document_versions')->restrictOnDelete();
        });
        Schema::table('business_document_versions', function (Blueprint $table): void {
            $table->foreign('supersedes_version_id')->references('id')->on('business_document_versions')->restrictOnDelete();
        });

        $this->entity('business_document_reviews', function (Blueprint $table): void {
            $table->foreignUuid('business_document_version_id')->constrained()->restrictOnDelete();
            $table->foreignId('reviewer_user_id')->constrained('users')->restrictOnDelete();
            $table->string('decision', 24);
            $table->text('reason')->nullable();
            $table->string('verified_document_number')->nullable();
            $table->date('verified_issue_date')->nullable();
            $table->string('expiration_kind', 24)->default('UNVERIFIED');
            $table->date('verified_expiration_date')->nullable();
            $table->string('evidence_source', 48)->nullable();
            $table->text('remarks')->nullable();
            $table->timestampTz('reviewed_at');
            $table->unique(['business_document_version_id', 'reviewed_at']);
            $table->index(['decision', 'reviewed_at']);
        });

        $this->entity('vendor_payment_accounts', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->string('provider', 24)->default('XENDIT');
            $table->string('environment', 8)->default('TEST');
            $table->string('provider_account_id', 128)->nullable();
            $table->string('connection_status', 24)->default('UNVERIFIED');
            $table->string('provider_status', 48)->nullable();
            $table->jsonb('capabilities')->nullable();
            $table->text('invitation_url_encrypted')->nullable();
            $table->string('invitation_url_hash', 64)->nullable();
            $table->string('invitation_url_masked', 255)->nullable();
            $table->timestampTz('last_reconciled_at')->nullable();
            $table->timestampTz('last_provider_event_at')->nullable();
            $table->string('last_error_code', 64)->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });

        $this->entity('vendor_activation_history', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('state_before', 24)->nullable();
            $table->string('state_after', 24);
            $table->string('result', 24);
            $table->text('reason')->nullable();
            $table->jsonb('blockers')->nullable();
            $table->jsonb('readiness_snapshot')->nullable();
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('source', 24)->default('SYSTEM');
            $table->timestampTz('recorded_at');
            $table->index(['vendor_organization_id', 'recorded_at']);
        });

        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
CREATE UNIQUE INDEX vendor_one_current_address_unique
    ON addresses (owner_type, owner_id)
    WHERE is_current = true AND owner_type = 'VENDOR_ORGANIZATION';
CREATE UNIQUE INDEX vendor_one_primary_contact_unique
    ON vendor_contacts (vendor_organization_id)
    WHERE is_primary = true AND active = true;
ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_business_type_check
    CHECK (business_type IS NULL OR business_type IN ('SOLE_PROPRIETORSHIP','PARTNERSHIP','CORPORATION','ONE_PERSON_CORPORATION','COOPERATIVE'));
ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_verification_status_check
    CHECK (store_verification_status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','CHANGES_REQUIRED','REJECTED','EXPIRED'));
ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_setup_status_check
    CHECK (store_setup_status IN ('NOT_STARTED','IN_PROGRESS','COMPLETED','CHANGES_REQUIRED'));
ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_activation_status_check
    CHECK (store_activation_status IN ('NOT_READY','READY','ACTIVE','RESTRICTED','SUSPENDED'));
ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT onboarding_section_check
    CHECK (section IN ('STORE_VERIFICATION','STORE_SETUP'));
ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT onboarding_level_check
    CHECK (level IN ('REQUIRED','OPTIONAL','CONDITIONALLY_REQUIRED'));
ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT onboarding_status_check
    CHECK (status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','CHANGES_REQUIRED','REJECTED','EXPIRED','NOT_APPLICABLE','COMPLETED'));
ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT onboarding_na_reason_check
    CHECK (status <> 'NOT_APPLICABLE' OR (level = 'CONDITIONALLY_REQUIRED' AND applicability_reason IS NOT NULL));
ALTER TABLE vendor_contacts ADD CONSTRAINT vendor_contact_primary_check
    CHECK (is_primary = false OR active = true);
ALTER TABLE vendor_classifications ADD CONSTRAINT vendor_supplier_type_check
    CHECK (supplier_type IN ('WHOLESALER_DISTRIBUTOR','RETAIL_HARDWARE_STORE','SPECIALIZED_SUPPLIER','OTHER'));
ALTER TABLE addresses ADD CONSTRAINT vendor_address_coordinates_check
    CHECK ((latitude IS NULL AND longitude IS NULL) OR (latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180));
ALTER TABLE addresses ADD CONSTRAINT vendor_address_version_check
    CHECK (version >= 1);
ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_phase_three_dimensions_check
    CHECK ((cargo_length_m IS NULL OR cargo_length_m > 0) AND (cargo_width_m IS NULL OR cargo_width_m > 0) AND (cargo_height_m IS NULL OR cargo_height_m > 0));
ALTER TABLE business_document_reviews ADD CONSTRAINT business_document_review_decision_check
    CHECK (decision IN ('APPROVED','CHANGES_REQUIRED','REJECTED'));
ALTER TABLE business_document_reviews ADD CONSTRAINT business_document_review_reason_check
    CHECK (decision = 'APPROVED' OR reason IS NOT NULL);
ALTER TABLE business_document_reviews ADD CONSTRAINT business_document_review_expiration_check
    CHECK ((expiration_kind = 'DATE' AND verified_expiration_date IS NOT NULL) OR (expiration_kind IN ('NO_EXPIRATION','UNVERIFIED') AND verified_expiration_date IS NULL));
ALTER TABLE business_document_reviews ADD CONSTRAINT business_document_review_dates_check
    CHECK (verified_expiration_date IS NULL OR verified_issue_date IS NULL OR verified_expiration_date >= verified_issue_date);
ALTER TABLE vendor_payment_accounts ADD CONSTRAINT vendor_payment_provider_check
    CHECK (provider = 'XENDIT' AND environment IN ('TEST','DEMO','LIVE') AND connection_status IN ('UNVERIFIED','PENDING','CONNECTED','FAILED','REVOKED'));
ALTER TABLE vendor_activation_history ADD CONSTRAINT vendor_activation_result_check
    CHECK (result IN ('READY','ACTIVATED','BLOCKED','RESTRICTED','RESTORED','SUSPENDED'));
CREATE OR REPLACE FUNCTION prevent_phase_three_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Phase 3 history is immutable';
END;
$$;
CREATE TRIGGER business_document_versions_immutable BEFORE UPDATE OR DELETE ON business_document_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation();
CREATE TRIGGER business_document_reviews_immutable BEFORE UPDATE OR DELETE ON business_document_reviews FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation();
CREATE TRIGGER vendor_activation_history_immutable BEFORE UPDATE OR DELETE ON vendor_activation_history FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation();
SQL);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared('DROP TRIGGER IF EXISTS business_document_versions_immutable ON business_document_versions; DROP TRIGGER IF EXISTS business_document_reviews_immutable ON business_document_reviews; DROP TRIGGER IF EXISTS vendor_activation_history_immutable ON vendor_activation_history; DROP FUNCTION IF EXISTS prevent_phase_three_history_mutation(); DROP INDEX IF EXISTS vendor_one_current_address_unique; DROP INDEX IF EXISTS vendor_one_primary_contact_unique;');
        }

        Schema::table('business_documents', fn (Blueprint $table) => $table->dropForeign(['current_version_id']));
        Schema::table('business_document_versions', fn (Blueprint $table) => $table->dropForeign(['supersedes_version_id']));
        foreach ([
            'vendor_activation_history', 'vendor_payment_accounts', 'business_document_reviews', 'business_document_versions',
            'business_documents', 'delivery_service_areas', 'operating_hours', 'store_media', 'store_profiles',
            'vendor_classifications', 'vendor_contacts', 'vendor_onboarding_steps',
        ] as $table) {
            Schema::dropIfExists($table);
        }

        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->dropForeign(['owner_attested_by_user_id']);
            $table->dropForeign(['drafted_by_user_id']);
            $table->dropColumn(['taxpayer_key_encrypted', 'taxpayer_key_last4', 'tin_last4', 'tax_details', 'drafted_by_user_id', 'owner_attested_at', 'owner_attested_by_user_id']);
        });
        Schema::table('vendor_tax_profiles', function (Blueprint $table): void {
            $table->dropForeign(['attested_by_user_id']);
            $table->dropColumn(['attested_at', 'attested_by_user_id']);
        });
        Schema::table('vendor_invitations', fn (Blueprint $table) => $table->dropColumn(['invitee_name', 'invitee_mobile']));
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->dropForeign(['image_file_id']);
            $table->dropColumn(['image_file_id', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'heavy_classification', 'lock_version']);
        });
        Schema::table('files', function (Blueprint $table): void {
            $table->dropForeign(['uploaded_by_user_id']);
            $table->dropColumn(['original_name', 'uploaded_by_user_id', 'metadata']);
        });
        Schema::table('addresses', function (Blueprint $table): void {
            $table->dropColumn(['street', 'unit', 'barangay', 'city_municipality', 'province', 'postal_code', 'source', 'provider', 'provider_place_id', 'review_state', 'version', 'is_current']);
        });
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->dropColumn([
                'business_type', 'registered_name', 'date_established', 'store_email', 'store_email_verified_at', 'store_phone',
                'store_verification_status', 'store_setup_status', 'store_activation_status', 'marketplace_discoverability_status',
                'onboarding_welcome_dismissed_at', 'activation_hold_code', 'activation_hold_reason',
            ]);
        });
    }

    private function entity(string $name, callable $columns): void
    {
        Schema::create($name, function (Blueprint $table) use ($columns): void {
            $table->uuid('id')->primary();
            $columns($table);
            $table->timestampsTz();
        });
    }
};
