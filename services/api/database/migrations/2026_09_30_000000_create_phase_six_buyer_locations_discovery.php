<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Phase 6: optional Buyer onboarding, saved Buyer locations with authoritative PostGIS points and best
 * resolved versioned PSGC codes, a versioned PSGC master with one ACTIVE version, and bounded Google
 * directory/route caches. Extends the Phase 1 buyer_profiles, buyer_locations, addresses, psgc_* and
 * provider cache tables instead of duplicating them.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('buyer_profiles', function (Blueprint $table): void {
            $table->string('position_title', 80)->nullable();
            $table->string('industry_classification', 32)->nullable();
            $table->string('industry_other_label', 80)->nullable();
            $table->string('onboarding_status', 16)->default('NOT_STARTED');
            $table->timestampTz('onboarding_completed_at')->nullable();
            $table->unsignedSmallInteger('discovery_radius_km')->default(5);
            $table->unsignedInteger('lock_version')->default(1);
        });

        Schema::create('buyer_preferred_categories', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_category_id')->constrained()->restrictOnDelete();
            $table->timestampsTz();
            $table->unique(['buyer_profile_id', 'material_category_id']);
        });

        Schema::table('psgc_versions', function (Blueprint $table): void {
            $table->string('status', 16)->default('DRAFT');
            $table->string('source_kind', 24)->nullable();
            $table->string('content_hash', 64)->nullable();
            $table->unsignedInteger('area_count')->default(0);
            $table->jsonb('level_counts')->default('{}');
            $table->unsignedInteger('orphan_count')->default(0);
            $table->timestampTz('activated_at')->nullable();
            $table->timestampTz('retired_at')->nullable();
        });

        Schema::table('psgc_areas', function (Blueprint $table): void {
            $table->string('normalized_name')->nullable();
            $table->index(['psgc_version_id', 'normalized_name'], 'psgc_areas_name_lookup');
        });

        Schema::table('addresses', function (Blueprint $table): void {
            $table->string('region_code', 16)->nullable();
            $table->foreignUuid('psgc_version_id')->nullable()->constrained('psgc_versions')->restrictOnDelete();
            $table->string('psgc_resolution', 16)->nullable();
        });

        Schema::table('buyer_locations', function (Blueprint $table): void {
            $table->string('label', 60)->nullable();
            $table->string('location_kind', 24)->default('DELIVERY');
            $table->string('contact_name', 120)->nullable();
            $table->string('contact_phone_e164', 20)->nullable();
            $table->text('site_instructions_encrypted')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('archived_at')->nullable();
            $table->index(['buyer_profile_id', 'archived_at']);
        });

        Schema::table('directory_suppliers', function (Blueprint $table): void {
            $table->string('primary_type', 64)->nullable();
            $table->string('business_status', 32)->nullable();
            $table->timestampTz('expires_at')->nullable()->index();
        });

        foreach (['place_cache_entries', 'route_cache_entries'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->string('kind', 24)->default('SEARCH_CELL');
                $table->index('expires_at');
            });
        }

        $statements = [
            "ALTER TABLE buyer_profiles ADD CONSTRAINT buyer_industry_classification_check CHECK (industry_classification IS NULL OR industry_classification IN ('GENERAL_CONTRACTOR','SUBCONTRACTOR_TRADE','INDEPENDENT_BUILDER','DIY_HOMEOWNER','OTHER'))",
            "ALTER TABLE buyer_profiles ADD CONSTRAINT buyer_industry_other_label_check CHECK ((industry_classification IS DISTINCT FROM 'OTHER' AND industry_other_label IS NULL) OR (industry_classification = 'OTHER' AND length(btrim(industry_other_label)) BETWEEN 2 AND 80))",
            "ALTER TABLE buyer_profiles ADD CONSTRAINT buyer_onboarding_status_check CHECK (onboarding_status IN ('NOT_STARTED','SKIPPED','COMPLETED'))",
            "ALTER TABLE buyer_profiles ADD CONSTRAINT buyer_onboarding_completed_check CHECK ((onboarding_status = 'COMPLETED') = (onboarding_completed_at IS NOT NULL))",
            'ALTER TABLE buyer_profiles ADD CONSTRAINT buyer_discovery_radius_check CHECK (discovery_radius_km IN (5,10,20,30,40,50))',

            "ALTER TABLE psgc_versions ADD CONSTRAINT psgc_version_status_check CHECK (status IN ('DRAFT','ACTIVE','RETIRED'))",
            "ALTER TABLE psgc_versions ADD CONSTRAINT psgc_version_source_check CHECK (source_kind IS NULL OR source_kind IN ('PSA_CSV','PSGC_CLOUD_SNAPSHOT'))",
            "ALTER TABLE psgc_versions ADD CONSTRAINT psgc_version_activation_check CHECK ((status = 'DRAFT' AND activated_at IS NULL) OR (status <> 'DRAFT' AND activated_at IS NOT NULL AND area_count > 0))",
            "CREATE UNIQUE INDEX psgc_one_active_version ON psgc_versions ((true)) WHERE status = 'ACTIVE'",
            "ALTER TABLE psgc_areas ADD CONSTRAINT psgc_area_level_check CHECK (level IN ('REGION','PROVINCE','CITY','MUNICIPALITY','SUB_MUNICIPALITY','SPECIAL_GEOGRAPHIC_AREA','BARANGAY','OTHER'))",
            // Imported versions are reference facts: once a version leaves DRAFT its areas never change, so
            // historical addresses keep the exact code and name they were resolved against.
            <<<'SQL'
            CREATE OR REPLACE FUNCTION psgc_areas_immutable_after_draft() RETURNS trigger LANGUAGE plpgsql AS $$
            DECLARE version_status text;
            BEGIN
                SELECT status INTO version_status FROM psgc_versions WHERE id = COALESCE(OLD.psgc_version_id, NEW.psgc_version_id);
                IF version_status IS DISTINCT FROM 'DRAFT' THEN
                    RAISE EXCEPTION 'PSGC areas of a % version are immutable', version_status USING ERRCODE = 'check_violation';
                END IF;
                RETURN COALESCE(NEW, OLD);
            END $$
            SQL,
            'CREATE TRIGGER psgc_areas_immutable BEFORE INSERT OR UPDATE OR DELETE ON psgc_areas FOR EACH ROW EXECUTE FUNCTION psgc_areas_immutable_after_draft()',

            "ALTER TABLE addresses ADD CONSTRAINT addresses_psgc_resolution_check CHECK (psgc_resolution IS NULL OR psgc_resolution IN ('RESOLVED','PARTIAL','UNRESOLVED'))",
            "ALTER TABLE addresses ADD CONSTRAINT addresses_psgc_resolved_codes_check CHECK (psgc_resolution IS NULL OR psgc_resolution = 'UNRESOLVED' OR (psgc_version_id IS NOT NULL AND region_code IS NOT NULL AND (psgc_resolution = 'PARTIAL' OR city_code IS NOT NULL)))",
            // A Buyer location is always an authoritative point inside the Philippine envelope; PSGC is best effort.
            "ALTER TABLE addresses ADD CONSTRAINT buyer_address_point_check CHECK (owner_type <> 'BUYER_PROFILE' OR (location IS NOT NULL AND latitude BETWEEN 4.0 AND 21.5 AND longitude BETWEEN 116.0 AND 127.0 AND psgc_resolution IS NOT NULL)) NOT VALID",

            "ALTER TABLE buyer_locations ADD CONSTRAINT buyer_location_kind_check CHECK (location_kind IN ('DELIVERY','BUSINESS','PROJECT_SITE','PICKUP_REFERENCE','OTHER'))",
            'ALTER TABLE buyer_locations ADD CONSTRAINT buyer_location_label_check CHECK (label IS NULL OR length(btrim(label)) BETWEEN 1 AND 60)',
            "ALTER TABLE buyer_locations ADD CONSTRAINT buyer_location_phone_check CHECK (contact_phone_e164 IS NULL OR contact_phone_e164 ~ '^\\+[1-9][0-9]{7,14}$')",
            'ALTER TABLE buyer_locations ADD CONSTRAINT buyer_location_primary_active_check CHECK (NOT (is_primary AND archived_at IS NOT NULL)) NOT VALID',

            // Google content is cached only within the operational target; 30 days is the hard ceiling.
            "ALTER TABLE directory_suppliers ADD CONSTRAINT directory_supplier_cache_bound_check CHECK (expires_at IS NULL OR expires_at <= refreshed_at + interval '30 days')",
            "ALTER TABLE place_cache_entries ADD CONSTRAINT place_cache_kind_check CHECK (kind IN ('SEARCH_CELL','PLACE_DETAILS'))",
            "ALTER TABLE place_cache_entries ADD CONSTRAINT place_cache_bound_check CHECK (created_at IS NULL OR expires_at <= created_at + interval '30 days')",
            "ALTER TABLE route_cache_entries ADD CONSTRAINT route_cache_kind_check CHECK (kind = 'ROUTE')",
            "ALTER TABLE route_cache_entries ADD CONSTRAINT route_cache_bound_check CHECK (created_at IS NULL OR expires_at <= created_at + interval '1 day')",
        ];
        DB::table('route_cache_entries')->update(['kind' => 'ROUTE']);
        DB::statement("ALTER TABLE route_cache_entries ALTER COLUMN kind SET DEFAULT 'ROUTE'");

        foreach ($statements as $statement) {
            DB::statement($statement);
        }
    }

    public function down(): void
    {
        foreach ([
            'ALTER TABLE route_cache_entries DROP CONSTRAINT IF EXISTS route_cache_bound_check',
            'ALTER TABLE route_cache_entries DROP CONSTRAINT IF EXISTS route_cache_kind_check',
            'ALTER TABLE place_cache_entries DROP CONSTRAINT IF EXISTS place_cache_bound_check',
            'ALTER TABLE place_cache_entries DROP CONSTRAINT IF EXISTS place_cache_kind_check',
            'ALTER TABLE directory_suppliers DROP CONSTRAINT IF EXISTS directory_supplier_cache_bound_check',
            'ALTER TABLE buyer_locations DROP CONSTRAINT IF EXISTS buyer_location_primary_active_check',
            'ALTER TABLE buyer_locations DROP CONSTRAINT IF EXISTS buyer_location_phone_check',
            'ALTER TABLE buyer_locations DROP CONSTRAINT IF EXISTS buyer_location_label_check',
            'ALTER TABLE buyer_locations DROP CONSTRAINT IF EXISTS buyer_location_kind_check',
            'ALTER TABLE addresses DROP CONSTRAINT IF EXISTS buyer_address_point_check',
            'ALTER TABLE addresses DROP CONSTRAINT IF EXISTS addresses_psgc_resolved_codes_check',
            'ALTER TABLE addresses DROP CONSTRAINT IF EXISTS addresses_psgc_resolution_check',
            'DROP TRIGGER IF EXISTS psgc_areas_immutable ON psgc_areas',
            'DROP FUNCTION IF EXISTS psgc_areas_immutable_after_draft()',
            'ALTER TABLE psgc_areas DROP CONSTRAINT IF EXISTS psgc_area_level_check',
            'DROP INDEX IF EXISTS psgc_one_active_version',
        ] as $statement) {
            DB::statement($statement);
        }

        foreach (['place_cache_entries', 'route_cache_entries'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->dropIndex(['expires_at']);
                $table->dropColumn('kind');
            });
        }
        Schema::table('directory_suppliers', function (Blueprint $table): void {
            $table->dropIndex(['expires_at']);
            $table->dropColumn(['primary_type', 'business_status', 'expires_at']);
        });
        Schema::table('buyer_locations', function (Blueprint $table): void {
            $table->dropIndex(['buyer_profile_id', 'archived_at']);
            $table->dropColumn(['label', 'location_kind', 'contact_name', 'contact_phone_e164', 'site_instructions_encrypted', 'lock_version', 'archived_at']);
        });
        Schema::table('addresses', function (Blueprint $table): void {
            $table->dropForeign(['psgc_version_id']);
            $table->dropColumn(['region_code', 'psgc_version_id', 'psgc_resolution']);
        });
        Schema::table('psgc_areas', function (Blueprint $table): void {
            $table->dropIndex('psgc_areas_name_lookup');
            $table->dropColumn('normalized_name');
        });
        Schema::table('psgc_versions', function (Blueprint $table): void {
            $table->dropColumn(['status', 'source_kind', 'content_hash', 'area_count', 'level_counts', 'orphan_count', 'activated_at', 'retired_at']);
        });
        Schema::drop('buyer_preferred_categories');
        Schema::table('buyer_profiles', function (Blueprint $table): void {
            $table->dropColumn(['position_title', 'industry_classification', 'industry_other_label', 'onboarding_status', 'onboarding_completed_at', 'discovery_radius_km', 'lock_version']);
        });
    }
};
