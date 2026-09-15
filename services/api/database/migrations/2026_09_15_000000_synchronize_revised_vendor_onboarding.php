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
            $table->string('store_verification_status', 32)->default('NOT_STARTED')->index();
            $table->string('business_review_status', 32)->default('NOT_STARTED');
            $table->string('store_setup_status', 32)->default('NOT_STARTED')->index();
            $table->string('activation_status', 24)->default('NOT_ACTIVE')->index();
            $table->string('discoverability_status', 32)->default('NOT_DISCOVERABLE')->index();
            $table->string('store_email')->nullable();
            $table->timestampTz('store_email_verified_at')->nullable();
            $table->string('pending_store_email')->nullable();
            $table->foreignUuid('pending_store_email_otp_id')->nullable()->constrained('email_otps')->restrictOnDelete();
            $table->string('store_phone', 20)->nullable();
        });
        DB::statement("UPDATE vendor_organizations SET store_verification_status = CASE WHEN onboarding_status = 'COMPLETED' THEN 'APPROVED' ELSE onboarding_status END, business_review_status = CASE WHEN onboarding_status IN ('APPROVED','COMPLETED') THEN 'APPROVED' WHEN onboarding_status = 'PENDING_VERIFICATION' THEN 'PENDING_VERIFICATION' WHEN onboarding_status = 'CHANGES_REQUIRED' THEN 'CHANGES_REQUIRED' WHEN onboarding_status = 'REJECTED' THEN 'REJECTED' ELSE onboarding_status END, activation_status = CASE WHEN marketplace_status = 'ACTIVE' THEN 'ACTIVE' WHEN marketplace_status = 'RESTRICTED' THEN 'RESTRICTED' ELSE 'NOT_ACTIVE' END, discoverability_status = CASE WHEN marketplace_status = 'ACTIVE' THEN 'DISCOVERABLE' WHEN marketplace_status = 'RESTRICTED' THEN 'RESTRICTED' ELSE 'NOT_DISCOVERABLE' END");
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_business_type_check');
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_business_type_check CHECK (business_type IS NULL OR business_type IN ('SOLE_PROPRIETORSHIP','PARTNERSHIP','CORPORATION','ONE_PERSON_CORPORATION','COOPERATIVE'))");
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_onboarding_state_check');
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_onboarding_state_check CHECK (onboarding_status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','CHANGES_REQUIRED','APPROVED','REJECTED','EXPIRED','COMPLETED'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_store_verification_state_check CHECK (store_verification_status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','CHANGES_REQUIRED','REJECTED','EXPIRED'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_business_review_state_check CHECK (business_review_status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','CHANGES_REQUIRED','REJECTED','EXPIRED'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_store_setup_state_check CHECK (store_setup_status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','COMPLETED','CHANGES_REQUIRED','REJECTED','EXPIRED'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_activation_state_check CHECK (activation_status IN ('NOT_ACTIVE','ACTIVE','RESTRICTED','SUSPENDED'))");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_discoverability_state_check CHECK (discoverability_status IN ('NOT_DISCOVERABLE','NO_ACTIVE_LISTINGS','DISCOVERABLE','RESTRICTED'))");

        Schema::table('vendor_onboarding_steps', function (Blueprint $table): void {
            $table->string('section', 32)->default('STORE_VERIFICATION')->index();
            $table->string('requirement_level', 32)->default('REQUIRED');
            $table->text('applicability_reason')->nullable();
            $table->string('source_version', 32)->nullable();
            $table->uuid('submission_reference')->nullable();
            $table->uuid('review_reference')->nullable();
            $table->timestampTz('submitted_at')->nullable();
            $table->timestampTz('reviewed_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        DB::statement("UPDATE vendor_onboarding_steps SET requirement_level = CASE WHEN status = 'OPTIONAL' THEN 'OPTIONAL' ELSE 'REQUIRED' END, status = CASE status WHEN 'COMPLETE' THEN 'COMPLETED' WHEN 'OPTIONAL' THEN 'NOT_STARTED' WHEN 'REQUIRED' THEN 'NOT_STARTED' ELSE status END");
        DB::statement("ALTER TABLE vendor_onboarding_steps ALTER COLUMN status SET DEFAULT 'NOT_STARTED'");
        DB::statement("ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT vendor_onboarding_section_check CHECK (section IN ('STORE_VERIFICATION','STORE_SETUP'))");
        DB::statement("ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT vendor_requirement_level_check CHECK (requirement_level IN ('REQUIRED','OPTIONAL','CONDITIONALLY_REQUIRED'))");
        DB::statement("ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT vendor_requirement_status_check CHECK (status IN ('NOT_STARTED','IN_PROGRESS','SUBMITTED','PENDING_VERIFICATION','APPROVED','COMPLETED','CHANGES_REQUIRED','REJECTED','EXPIRED','NOT_APPLICABLE'))");
        DB::statement("ALTER TABLE vendor_onboarding_steps ADD CONSTRAINT vendor_not_applicable_check CHECK (status <> 'NOT_APPLICABLE' OR (requirement_level = 'CONDITIONALLY_REQUIRED' AND applicability_reason IS NOT NULL))");

        Schema::table('business_documents', function (Blueprint $table): void {
            $table->foreignUuid('vendor_onboarding_step_id')->nullable()->constrained('vendor_onboarding_steps')->restrictOnDelete();
        });
        Schema::table('business_document_reviews', function (Blueprint $table): void {
            $table->uuid('audit_reference')->nullable();
        });
        Schema::table('vendor_contacts', function (Blueprint $table): void {
            $table->boolean('verification_communication')->default(false);
            $table->boolean('account_administration_communication')->default(false);
            $table->boolean('general_administration_communication')->default(true);
        });
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->jsonb('payment_methods')->nullable();
            $table->jsonb('refund_configuration')->nullable();
        });
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->string('vehicle_subtype', 32)->nullable();
            $table->string('custom_vehicle_type')->nullable();
            $table->foreignUuid('image_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->decimal('cargo_length_m', 10, 3)->nullable();
            $table->decimal('cargo_width_m', 10, 3)->nullable();
            $table->decimal('cargo_height_m', 10, 3)->nullable();
            $table->string('heavy_vehicle_classification', 64)->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        DB::statement("ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_type_check CHECK (vehicle_type IN ('MOTORCYCLE','PICKUP','VAN','TRUCK','CUSTOM'))");
        DB::statement('ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_count_check CHECK (number_available > 0)');
        DB::statement('ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_capacity_check CHECK (capacity_kg > 0)');
        DB::statement('ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_dimensions_check CHECK ((cargo_length_m IS NULL OR cargo_length_m > 0) AND (cargo_width_m IS NULL OR cargo_width_m > 0) AND (cargo_height_m IS NULL OR cargo_height_m > 0))');
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE vendor_vehicles DROP CONSTRAINT vendor_vehicle_dimensions_check');
        DB::statement('ALTER TABLE vendor_vehicles DROP CONSTRAINT vendor_vehicle_capacity_check');
        DB::statement('ALTER TABLE vendor_vehicles DROP CONSTRAINT vendor_vehicle_count_check');
        DB::statement('ALTER TABLE vendor_vehicles DROP CONSTRAINT vendor_vehicle_type_check');
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->dropForeign(['image_file_id']);
            $table->dropColumn(['vehicle_subtype', 'custom_vehicle_type', 'image_file_id', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'heavy_vehicle_classification', 'lock_version']);
        });
        Schema::table('store_profiles', fn (Blueprint $table) => $table->dropColumn(['payment_methods', 'refund_configuration']));
        Schema::table('vendor_contacts', fn (Blueprint $table) => $table->dropColumn(['verification_communication', 'account_administration_communication', 'general_administration_communication']));
        Schema::table('business_document_reviews', fn (Blueprint $table) => $table->dropColumn('audit_reference'));
        Schema::table('business_documents', function (Blueprint $table): void {
            $table->dropForeign(['vendor_onboarding_step_id']);
            $table->dropColumn('vendor_onboarding_step_id');
        });
        DB::statement('ALTER TABLE vendor_onboarding_steps DROP CONSTRAINT vendor_not_applicable_check');
        DB::statement('ALTER TABLE vendor_onboarding_steps DROP CONSTRAINT vendor_requirement_status_check');
        DB::statement('ALTER TABLE vendor_onboarding_steps DROP CONSTRAINT vendor_requirement_level_check');
        DB::statement('ALTER TABLE vendor_onboarding_steps DROP CONSTRAINT vendor_onboarding_section_check');
        DB::statement("UPDATE vendor_onboarding_steps SET status = CASE WHEN status IN ('COMPLETED','APPROVED') THEN 'COMPLETE' WHEN status = 'NOT_APPLICABLE' THEN 'OPTIONAL' WHEN status = 'NOT_STARTED' AND requirement_level = 'OPTIONAL' THEN 'OPTIONAL' WHEN status = 'NOT_STARTED' THEN 'REQUIRED' ELSE 'IN_PROGRESS' END");
        DB::statement("ALTER TABLE vendor_onboarding_steps ALTER COLUMN status SET DEFAULT 'REQUIRED'");
        Schema::table('vendor_onboarding_steps', fn (Blueprint $table) => $table->dropColumn(['section', 'requirement_level', 'applicability_reason', 'source_version', 'submission_reference', 'review_reference', 'submitted_at', 'reviewed_at', 'lock_version']));
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_discoverability_state_check');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_activation_state_check');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_store_setup_state_check');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_store_verification_state_check');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_business_review_state_check');
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_onboarding_state_check');
        DB::statement("UPDATE vendor_organizations SET onboarding_status = CASE WHEN onboarding_status = 'SUBMITTED' THEN 'IN_PROGRESS' WHEN onboarding_status = 'EXPIRED' THEN 'CHANGES_REQUIRED' ELSE onboarding_status END");
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_onboarding_state_check CHECK (onboarding_status IN ('NOT_STARTED','IN_PROGRESS','PENDING_VERIFICATION','CHANGES_REQUIRED','APPROVED','REJECTED','COMPLETED'))");
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_business_type_check');
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_business_type_check CHECK (business_type IS NULL OR business_type IN ('SOLE_PROPRIETORSHIP','PARTNERSHIP','CORPORATION'))");
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->dropForeign(['pending_store_email_otp_id']);
            $table->dropColumn(['store_verification_status', 'business_review_status', 'store_setup_status', 'activation_status', 'discoverability_status', 'store_email', 'store_email_verified_at', 'pending_store_email', 'pending_store_email_otp_id', 'store_phone']);
        });
    }
};
