<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 4 extends the Phase 1 catalog/compliance baseline in place. It never
 * recreates those tables; it adds the listing lifecycle, immutable price and
 * publication history, private compliance evidence and discoverability state.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('materials', function (Blueprint $table): void {
            $table->string('normalized_name')->nullable();
        });
        Schema::table('technical_attribute_definitions', function (Blueprint $table): void {
            $table->jsonb('allowed_values')->nullable();
            $table->string('unit_code', 24)->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('comparability_key')->default(false);
        });
        Schema::table('regulated_material_rules', function (Blueprint $table): void {
            $table->string('product_name')->nullable();
            $table->string('reference_standard', 120)->nullable();
            $table->string('technical_regulation', 120)->nullable();
            $table->text('scope')->nullable();
            $table->jsonb('marking_requirements')->nullable();
        });
        // Versioned snapshots of the DTI-BPS PS licensee and ICC certificate registers.
        $this->entity('compliance_reference_registers', function (Blueprint $table): void {
            $table->string('register_kind', 24);
            $table->string('source_reference', 500);
            $table->date('snapshot_date');
            $table->string('status', 16)->default('DRAFT');
            $table->unsignedInteger('row_count')->default(0);
            $table->unsignedInteger('rejected_row_count')->default(0);
            $table->jsonb('column_mapping');
            $table->string('content_hash', 64);
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->foreignId('imported_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('activated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('activated_at')->nullable();
            $table->timestampTz('superseded_at')->nullable();
        });
        $this->entity('compliance_reference_records', function (Blueprint $table): void {
            $table->foreignUuid('compliance_reference_register_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('row_number');
            $table->string('record_number', 120);
            $table->string('record_number_display', 160);
            $table->string('company_name', 300);
            $table->string('normalized_company', 300);
            $table->text('product_description')->nullable();
            $table->string('reference_standard', 160)->nullable();
            $table->string('brand', 200)->nullable();
            $table->text('address')->nullable();
            $table->date('issued_on')->nullable();
            $table->date('expires_on')->nullable();
            $table->index(['compliance_reference_register_id', 'record_number'], 'compliance_reference_record_lookup_index');
        });
        $this->entity('material_compatible_units', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('unit_id')->constrained('units')->restrictOnDelete();
            $table->unique(['material_id', 'unit_id']);
        });

        Schema::table('products', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('model')->nullable();
            $table->string('manufacturer_address', 500)->nullable();
        });

        Schema::table('vendor_listings', function (Blueprint $table): void {
            $table->text('description')->nullable();
            $table->jsonb('technical_attributes')->nullable();
            $table->foreignUuid('material_category_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('material_match', 24)->default('UNMATCHED');
            $table->string('other_label', 60)->nullable();
            $table->boolean('regulated')->default(false);
            $table->foreignUuid('regulated_material_rule_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('compliance_status', 32)->default('NOT_REQUIRED')->index();
            $table->uuid('current_compliance_submission_id')->nullable();
            $table->timestampTz('publication_requested_at')->nullable();
            $table->timestampTz('published_at')->nullable();
            $table->unsignedInteger('publication_version')->default(0);
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
        $this->entity('listing_tag_links', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_tag_id')->constrained()->restrictOnDelete();
            $table->unique(['vendor_listing_id', 'material_tag_id']);
        });

        Schema::table('listing_variants', function (Blueprint $table): void {
            $table->string('label', 120)->nullable();
            $table->decimal('weight_kg', 12, 3)->nullable();
            $table->decimal('length_cm', 10, 2)->nullable();
            $table->decimal('width_cm', 10, 2)->nullable();
            $table->decimal('height_cm', 10, 2)->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('listing_price_versions', function (Blueprint $table): void {
            $table->string('price_kind', 16)->default('ORDINARY');
            $table->decimal('minimum_quantity', 18, 4)->nullable();
            $table->string('tax_basis', 500)->nullable();
            $table->uuid('supersedes_price_version_id')->nullable();
            $table->foreign('supersedes_price_version_id')->references('id')->on('listing_price_versions')->restrictOnDelete();
        });
        Schema::table('listing_media', function (Blueprint $table): void {
            $table->string('status', 16)->default('READY');
            $table->unsignedInteger('media_version')->default(1);
            $table->uuid('replaces_media_id')->nullable();
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('removed_at')->nullable();
            $table->foreign('replaces_media_id')->references('id')->on('listing_media')->restrictOnDelete();
        });
        Schema::table('listing_status_history', function (Blueprint $table): void {
            $table->string('source', 16)->default('VENDOR');
            $table->string('reason_code', 64)->nullable();
            $table->uuid('compliance_submission_id')->nullable();
            $table->unsignedInteger('publication_version')->nullable();
        });
        $this->entity('listing_publication_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('publication_version');
            $table->jsonb('snapshot');
            $table->string('content_hash', 64);
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->unique(['vendor_listing_id', 'publication_version']);
        });

        Schema::table('compliance_submissions', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('regulated_material_rule_id')->nullable()->constrained()->restrictOnDelete();
            $table->unsignedInteger('rule_version')->nullable();
            $table->string('marking_type', 16)->nullable();
            $table->jsonb('declared')->nullable();
            $table->foreignId('submitted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('submitted_at')->nullable();
            $table->uuid('supersedes_submission_id')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('decided_at')->nullable();
            $table->string('listing_fingerprint', 64)->nullable();
            $table->foreign('supersedes_submission_id')->references('id')->on('compliance_submissions')->restrictOnDelete();
        });
        Schema::table('vendor_listings', function (Blueprint $table): void {
            $table->foreign('current_compliance_submission_id')->references('id')->on('compliance_submissions')->restrictOnDelete();
        });
        Schema::table('compliance_evidence', function (Blueprint $table): void {
            $table->uuid('compliance_submission_id')->nullable()->change();
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_listing_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->string('evidence_kind', 24)->nullable();
            $table->string('path', 16)->nullable();
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('attached_at')->nullable();
        });
        Schema::table('compliance_extractions', function (Blueprint $table): void {
            $table->uuid('compliance_submission_id')->nullable()->change();
            $table->foreignUuid('compliance_evidence_id')->nullable()->constrained('compliance_evidence')->restrictOnDelete();
            $table->string('source', 8)->nullable();
            $table->string('provider', 48)->nullable();
            $table->string('status', 16)->nullable();
            $table->decimal('confidence', 5, 4)->nullable();
        });
        Schema::table('compliance_reference_matches', function (Blueprint $table): void {
            $table->string('provider', 48)->nullable();
            $table->string('result', 16)->nullable();
            $table->string('source_reference', 500)->nullable();
            $table->timestampTz('checked_at')->nullable();
        });
        Schema::table('compliance_reviews', function (Blueprint $table): void {
            $table->text('reason')->nullable();
            $table->text('remarks')->nullable();
            $table->string('source_reference', 500)->nullable();
            $table->unsignedInteger('submission_version')->nullable();
            $table->unsignedInteger('submission_lock_version')->nullable();
            $table->jsonb('evidence_file_ids')->nullable();
            $table->timestampTz('reviewed_at')->nullable();
        });

        $this->entity('catalog_import_jobs', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('uploaded_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('status', 32)->default('VALIDATED');
            $table->string('template_version', 32);
            $table->unsignedInteger('total_rows')->default(0);
            $table->unsignedInteger('valid_rows')->default(0);
            $table->unsignedInteger('error_rows')->default(0);
            $table->unsignedInteger('applied_rows')->default(0);
            $table->foreignId('applied_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('applied_at')->nullable();
            $table->index(['vendor_organization_id', 'created_at']);
        });
        $this->entity('catalog_import_rows', function (Blueprint $table): void {
            $table->foreignUuid('catalog_import_job_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('row_number');
            $table->string('vendor_sku', 96)->nullable();
            $table->string('variant_sku', 96)->nullable();
            $table->jsonb('payload');
            $table->jsonb('errors')->nullable();
            $table->string('status', 16);
            $table->foreignUuid('vendor_listing_id')->nullable()->constrained()->restrictOnDelete();
            $table->unique(['catalog_import_job_id', 'row_number']);
        });

        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->string('marketplace_discoverability_reason', 48)->nullable();
            $table->timestampTz('discoverability_evaluated_at')->nullable();
        });

        $this->grantPermissions();

        if (DB::getDriverName() === 'pgsql') {
            $this->postgresConstraints();
        }
    }

    private function postgresConstraints(): void
    {
        DB::unprepared(<<<'SQL'
UPDATE materials SET normalized_name = lower(regexp_replace(name, '\s+', ' ', 'g')) WHERE normalized_name IS NULL;
CREATE INDEX materials_name_trgm_index ON materials USING GIN (lower(name) gin_trgm_ops);
CREATE INDEX material_aliases_trgm_index ON material_aliases USING GIN (normalized_alias gin_trgm_ops);
CREATE INDEX vendor_listings_display_name_trgm_index ON vendor_listings USING GIN (lower(display_name) gin_trgm_ops);
ALTER TABLE technical_attribute_definitions ADD CONSTRAINT technical_attribute_value_type_check CHECK (value_type IN ('TEXT','NUMBER','ENUM'));
ALTER TABLE regulated_material_rules ADD CONSTRAINT regulated_rule_marking_check CHECK (required_marking IN ('PS_MARK','ICC_STICKER','PS_OR_ICC'));
ALTER TABLE regulated_material_rules ADD CONSTRAINT regulated_rule_dates_check CHECK (effective_to IS NULL OR effective_to > effective_from);
ALTER TABLE compliance_reference_registers ADD CONSTRAINT compliance_register_state_check CHECK (register_kind IN ('PS_LICENSE','ICC_CERTIFICATE') AND status IN ('DRAFT','ACTIVE','SUPERSEDED') AND (status = 'DRAFT' OR activated_at IS NOT NULL));
CREATE UNIQUE INDEX compliance_one_active_register ON compliance_reference_registers (register_kind) WHERE status = 'ACTIVE';

ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_status_check CHECK (status IN ('DRAFT','PENDING_COMPLIANCE','PENDING_ADMIN_REVIEW','ACTIVE','INACTIVE','TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED','REJECTED'));
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_compliance_status_check CHECK (compliance_status IN ('NOT_REQUIRED','NOT_SUBMITTED','PENDING_ADMIN_REVIEW','VERIFIED','CHANGES_REQUIRED','REJECTED'));
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_material_match_check CHECK (material_match IN ('EXACT','ALIAS','FUZZY_CONFIRMED','UNMATCHED'));
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_other_label_check CHECK (other_label IS NULL OR length(btrim(other_label)) BETWEEN 2 AND 60);
-- The regulated publication gate is also enforced here so no code path can activate unverified regulated goods.
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_regulated_gate_check CHECK (status <> 'ACTIVE' OR regulated = false OR compliance_status = 'VERIFIED');
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_regulated_state_check CHECK ((regulated = false AND compliance_status = 'NOT_REQUIRED') OR (regulated = true AND compliance_status <> 'NOT_REQUIRED'));

ALTER TABLE listing_variants ADD CONSTRAINT listing_variant_measurements_check CHECK ((weight_kg IS NULL OR weight_kg > 0) AND (length_cm IS NULL OR length_cm > 0) AND (width_cm IS NULL OR width_cm > 0) AND (height_cm IS NULL OR height_cm > 0));
ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_kind_check CHECK (price_kind IN ('ORDINARY','PROMOTIONAL','VOLUME_TIER','NEGOTIATED'));
ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_tier_quantity_check CHECK ((price_kind = 'VOLUME_TIER') = (minimum_quantity IS NOT NULL) AND (minimum_quantity IS NULL OR minimum_quantity > 0));
ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_tax_basis_check CHECK (tax_category NOT IN ('VAT_ZERO','VAT_EXEMPT') OR (tax_basis IS NOT NULL AND length(btrim(tax_basis)) >= 3));
ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_currency_check CHECK (currency = 'PHP');
CREATE UNIQUE INDEX listing_one_current_ordinary_price ON listing_price_versions (listing_variant_id) WHERE retired_at IS NULL AND price_kind = 'ORDINARY';

ALTER TABLE listing_media ADD CONSTRAINT listing_media_status_check CHECK (status IN ('READY','REPLACED','REMOVED') AND media_version >= 1);
ALTER TABLE listing_status_history ADD CONSTRAINT listing_status_history_source_check CHECK (source IN ('VENDOR','ADMIN','SYSTEM','IMPORT'));

ALTER TABLE compliance_submissions ADD CONSTRAINT compliance_submission_path_check CHECK (path IN ('PHOTO_OCR','QR','MANUAL'));
ALTER TABLE compliance_submissions ADD CONSTRAINT compliance_submission_status_check CHECK (status IN ('PENDING_ADMIN_REVIEW','VERIFIED','CHANGES_REQUIRED','REJECTED','SUPERSEDED'));
ALTER TABLE compliance_submissions ADD CONSTRAINT compliance_submission_marking_check CHECK (marking_type IS NULL OR marking_type IN ('PS_MARK','ICC_STICKER'));
CREATE UNIQUE INDEX compliance_one_open_submission ON compliance_submissions (vendor_listing_id) WHERE status = 'PENDING_ADMIN_REVIEW';
CREATE UNIQUE INDEX compliance_submission_version_unique ON compliance_submissions (vendor_listing_id, version);
ALTER TABLE compliance_evidence ADD CONSTRAINT compliance_evidence_kind_check CHECK (evidence_kind IS NULL OR evidence_kind IN ('MARKING_PHOTO','QR_IMAGE'));
ALTER TABLE compliance_extractions ADD CONSTRAINT compliance_extraction_state_check CHECK ((source IS NULL OR source IN ('OCR','QR')) AND (status IS NULL OR status IN ('EXTRACTED','UNAVAILABLE','FAILED')) AND (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)));
ALTER TABLE compliance_reference_matches ADD CONSTRAINT compliance_reference_result_check CHECK (result IS NULL OR result IN ('MATCHED','UNMATCHED','UNCERTAIN','UNAVAILABLE'));
ALTER TABLE compliance_reviews ADD CONSTRAINT compliance_review_decision_check CHECK (decision IN ('APPROVED','CHANGES_REQUIRED','REJECTED'));
ALTER TABLE compliance_reviews ADD CONSTRAINT compliance_review_reason_check CHECK (decision = 'APPROVED' OR (reason IS NOT NULL AND length(btrim(reason)) >= 3));

ALTER TABLE catalog_import_jobs ADD CONSTRAINT catalog_import_job_status_check CHECK (status IN ('VALIDATED','HAS_ERRORS','APPLIED','APPLIED_WITH_REJECTIONS','FAILED') AND valid_rows + error_rows = total_rows AND applied_rows <= valid_rows);
ALTER TABLE catalog_import_rows ADD CONSTRAINT catalog_import_row_status_check CHECK (status IN ('VALID','INVALID','APPLIED'));

ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_discoverability_status_check CHECK (marketplace_discoverability_status IN ('NOT_DISCOVERABLE','DISCOVERABLE'));
ALTER TABLE vendor_activation_history DROP CONSTRAINT vendor_activation_result_check;
ALTER TABLE vendor_activation_history ADD CONSTRAINT vendor_activation_result_check CHECK (result IN ('READY','ACTIVATED','BLOCKED','RESTRICTED','RESTORED','SUSPENDED','DISCOVERABLE','NOT_DISCOVERABLE'));

CREATE OR REPLACE FUNCTION enforce_listing_tag_limit() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF (SELECT COUNT(*) FROM listing_tag_links WHERE vendor_listing_id = NEW.vendor_listing_id) > 3 THEN
        RAISE EXCEPTION 'A listing may have at most three search tags';
    END IF;
    RETURN NEW;
END;
$$;
CREATE CONSTRAINT TRIGGER listing_tag_limit AFTER INSERT OR UPDATE ON listing_tag_links DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION enforce_listing_tag_limit();

-- Public listing media may reference only a file uploaded for that purpose by the same organization.
CREATE OR REPLACE FUNCTION enforce_listing_media_file() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE file_purpose text; file_owner uuid; listing_owner uuid;
BEGIN
    SELECT purpose, owner_id INTO file_purpose, file_owner FROM files WHERE id = NEW.file_id;
    SELECT vendor_organization_id INTO listing_owner FROM vendor_listings WHERE id = NEW.vendor_listing_id;
    IF file_purpose IS DISTINCT FROM 'LISTING_MEDIA' OR file_owner IS DISTINCT FROM listing_owner THEN
        RAISE EXCEPTION 'Listing media must use a public listing image of the same organization';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER listing_media_file_purpose BEFORE INSERT OR UPDATE OF file_id, vendor_listing_id ON listing_media FOR EACH ROW EXECUTE FUNCTION enforce_listing_media_file();

-- Compliance evidence stays private and can never point at a public listing image.
CREATE OR REPLACE FUNCTION enforce_compliance_evidence_file() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE file_purpose text; file_visibility text;
BEGIN
    IF NEW.file_id IS NULL THEN
        RETURN NEW;
    END IF;
    SELECT purpose, visibility INTO file_purpose, file_visibility FROM files WHERE id = NEW.file_id;
    IF file_purpose IS DISTINCT FROM 'PRODUCT_COMPLIANCE_EVIDENCE' OR file_visibility IS DISTINCT FROM 'PRIVATE' THEN
        RAISE EXCEPTION 'Compliance evidence must be a private compliance evidence file';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER compliance_evidence_file_purpose BEFORE INSERT OR UPDATE OF file_id ON compliance_evidence FOR EACH ROW EXECUTE FUNCTION enforce_compliance_evidence_file();

-- A price version is immutable; the only permitted change is retiring it once.
CREATE OR REPLACE FUNCTION protect_listing_price_version() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Listing price versions are immutable';
    END IF;
    IF OLD.retired_at IS NOT NULL
        OR NEW.listing_variant_id IS DISTINCT FROM OLD.listing_variant_id OR NEW.version IS DISTINCT FROM OLD.version
        OR NEW.amount_centavos IS DISTINCT FROM OLD.amount_centavos OR NEW.currency IS DISTINCT FROM OLD.currency
        OR NEW.tax_category IS DISTINCT FROM OLD.tax_category OR NEW.effective_at IS DISTINCT FROM OLD.effective_at
        OR NEW.price_kind IS DISTINCT FROM OLD.price_kind OR NEW.minimum_quantity IS DISTINCT FROM OLD.minimum_quantity
        OR NEW.tax_basis IS DISTINCT FROM OLD.tax_basis OR NEW.created_by_user_id IS DISTINCT FROM OLD.created_by_user_id
        OR NEW.supersedes_price_version_id IS DISTINCT FROM OLD.supersedes_price_version_id THEN
        RAISE EXCEPTION 'Listing price versions are immutable';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER listing_price_versions_immutable BEFORE UPDATE OR DELETE ON listing_price_versions FOR EACH ROW EXECUTE FUNCTION protect_listing_price_version();

CREATE OR REPLACE FUNCTION prevent_phase_four_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Phase 4 catalog and compliance history is immutable';
END;
$$;
CREATE TRIGGER listing_status_history_immutable BEFORE UPDATE OR DELETE ON listing_status_history FOR EACH ROW EXECUTE FUNCTION prevent_phase_four_history_mutation();
CREATE TRIGGER listing_publication_snapshots_immutable BEFORE UPDATE OR DELETE ON listing_publication_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_four_history_mutation();
CREATE TRIGGER compliance_reviews_immutable BEFORE UPDATE OR DELETE ON compliance_reviews FOR EACH ROW EXECUTE FUNCTION prevent_phase_four_history_mutation();
CREATE TRIGGER compliance_reference_matches_immutable BEFORE UPDATE OR DELETE ON compliance_reference_matches FOR EACH ROW EXECUTE FUNCTION prevent_phase_four_history_mutation();
CREATE TRIGGER compliance_reference_records_immutable BEFORE UPDATE OR DELETE ON compliance_reference_records FOR EACH ROW EXECUTE FUNCTION prevent_phase_four_history_mutation();
SQL);
    }

    private function grantPermissions(): void
    {
        $permissions = [
            'product_compliance.review' => 'Decide submitted product PS/ICC compliance evidence.',
            'product_compliance.view_evidence' => 'View private product PS/ICC compliance evidence.',
            'product_compliance.manage_registers' => 'Import and activate DTI-BPS PS licensee and ICC certificate register snapshots.',
            'taxonomy.manage' => 'Manage canonical materials, comparable groups and regulated-material mappings.',
        ];
        foreach ($permissions as $code => $description) {
            DB::table('permissions')->updateOrInsert(
                ['code' => $code],
                ['id' => DB::table('permissions')->where('code', $code)->value('id') ?? (string) Str::uuid7(), 'description' => $description, 'created_at' => now(), 'updated_at' => now()],
            );
        }
        $grants = [
            'ADMIN_SUPERADMIN' => array_keys($permissions),
            'ADMIN_PRODUCT_COMPLIANCE' => ['product_compliance.review', 'product_compliance.view_evidence', 'product_compliance.manage_registers'],
        ];
        foreach ($grants as $roleCode => $codes) {
            $roleId = DB::table('platform_roles')->where('code', $roleCode)->where('platform', 'ADMIN')->value('id');
            if ($roleId === null) {
                continue;
            }
            foreach ($codes as $code) {
                $permissionId = DB::table('permissions')->where('code', $code)->value('id');
                if ($permissionId !== null && ! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permissionId)->exists()) {
                    DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
    }

    private function entity(string $name, callable $columns): void
    {
        Schema::create($name, function (Blueprint $table) use ($columns): void {
            $table->uuid('id')->primary();
            $columns($table);
            $table->timestampsTz();
        });
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS compliance_reference_records_immutable ON compliance_reference_records;
DROP TRIGGER IF EXISTS compliance_reference_matches_immutable ON compliance_reference_matches;
DROP TRIGGER IF EXISTS compliance_reviews_immutable ON compliance_reviews;
DROP TRIGGER IF EXISTS listing_publication_snapshots_immutable ON listing_publication_snapshots;
DROP TRIGGER IF EXISTS listing_status_history_immutable ON listing_status_history;
DROP TRIGGER IF EXISTS listing_price_versions_immutable ON listing_price_versions;
DROP TRIGGER IF EXISTS compliance_evidence_file_purpose ON compliance_evidence;
DROP TRIGGER IF EXISTS listing_media_file_purpose ON listing_media;
DROP TRIGGER IF EXISTS listing_tag_limit ON listing_tag_links;
DROP FUNCTION IF EXISTS prevent_phase_four_history_mutation();
DROP FUNCTION IF EXISTS protect_listing_price_version();
DROP FUNCTION IF EXISTS enforce_compliance_evidence_file();
DROP FUNCTION IF EXISTS enforce_listing_media_file();
DROP FUNCTION IF EXISTS enforce_listing_tag_limit();
ALTER TABLE vendor_activation_history DROP CONSTRAINT IF EXISTS vendor_activation_result_check;
ALTER TABLE vendor_activation_history ADD CONSTRAINT vendor_activation_result_check CHECK (result IN ('READY','ACTIVATED','BLOCKED','RESTRICTED','RESTORED','SUSPENDED'));
ALTER TABLE vendor_organizations DROP CONSTRAINT IF EXISTS vendor_discoverability_status_check;
DROP INDEX IF EXISTS compliance_submission_version_unique;
DROP INDEX IF EXISTS compliance_one_open_submission;
DROP INDEX IF EXISTS listing_one_current_ordinary_price;
DROP INDEX IF EXISTS vendor_listings_display_name_trgm_index;
DROP INDEX IF EXISTS material_aliases_trgm_index;
DROP INDEX IF EXISTS materials_name_trgm_index;
SQL);
        }
        Schema::table('vendor_organizations', fn (Blueprint $table) => $table->dropColumn(['marketplace_discoverability_reason', 'discoverability_evaluated_at']));
        Schema::dropIfExists('catalog_import_rows');
        Schema::dropIfExists('catalog_import_jobs');
        Schema::table('compliance_reviews', fn (Blueprint $table) => $table->dropColumn(['reason', 'remarks', 'source_reference', 'submission_version', 'submission_lock_version', 'evidence_file_ids', 'reviewed_at']));
        Schema::table('compliance_reference_matches', fn (Blueprint $table) => $table->dropColumn(['provider', 'result', 'source_reference', 'checked_at']));
        Schema::table('compliance_extractions', function (Blueprint $table): void {
            $table->dropForeign(['compliance_evidence_id']);
            $table->dropColumn(['compliance_evidence_id', 'source', 'provider', 'status', 'confidence']);
        });
        Schema::table('compliance_evidence', function (Blueprint $table): void {
            $table->dropForeign(['vendor_organization_id']);
            $table->dropForeign(['vendor_listing_id']);
            $table->dropForeign(['file_id']);
            $table->dropForeign(['uploaded_by_user_id']);
            $table->dropColumn(['vendor_organization_id', 'vendor_listing_id', 'file_id', 'evidence_kind', 'path', 'uploaded_by_user_id', 'attached_at']);
        });
        Schema::table('vendor_listings', fn (Blueprint $table) => $table->dropForeign(['current_compliance_submission_id']));
        Schema::table('compliance_submissions', function (Blueprint $table): void {
            $table->dropForeign(['vendor_organization_id']);
            $table->dropForeign(['regulated_material_rule_id']);
            $table->dropForeign(['submitted_by_user_id']);
            $table->dropForeign(['supersedes_submission_id']);
            $table->dropColumn(['vendor_organization_id', 'regulated_material_rule_id', 'rule_version', 'marking_type', 'declared', 'submitted_by_user_id', 'submitted_at', 'supersedes_submission_id', 'lock_version', 'decided_at', 'listing_fingerprint']);
        });
        Schema::dropIfExists('listing_publication_snapshots');
        Schema::table('listing_status_history', fn (Blueprint $table) => $table->dropColumn(['source', 'reason_code', 'compliance_submission_id', 'publication_version']));
        Schema::table('listing_media', function (Blueprint $table): void {
            $table->dropForeign(['replaces_media_id']);
            $table->dropForeign(['uploaded_by_user_id']);
            $table->dropColumn(['status', 'media_version', 'replaces_media_id', 'uploaded_by_user_id', 'removed_at']);
        });
        Schema::table('listing_price_versions', function (Blueprint $table): void {
            $table->dropForeign(['supersedes_price_version_id']);
            $table->dropColumn(['price_kind', 'minimum_quantity', 'tax_basis', 'supersedes_price_version_id']);
        });
        Schema::table('listing_variants', fn (Blueprint $table) => $table->dropColumn(['label', 'weight_kg', 'length_cm', 'width_cm', 'height_cm', 'sort_order', 'lock_version']));
        Schema::dropIfExists('listing_tag_links');
        Schema::table('vendor_listings', function (Blueprint $table): void {
            $table->dropForeign(['material_category_id']);
            $table->dropForeign(['regulated_material_rule_id']);
            $table->dropForeign(['created_by_user_id']);
            $table->dropForeign(['updated_by_user_id']);
            $table->dropColumn(['description', 'technical_attributes', 'material_category_id', 'material_match', 'other_label', 'regulated', 'regulated_material_rule_id', 'compliance_status', 'current_compliance_submission_id', 'publication_requested_at', 'published_at', 'publication_version', 'created_by_user_id', 'updated_by_user_id']);
        });
        Schema::table('products', function (Blueprint $table): void {
            $table->dropForeign(['vendor_organization_id']);
            $table->dropColumn(['vendor_organization_id', 'model', 'manufacturer_address']);
        });
        Schema::dropIfExists('material_compatible_units');
        Schema::dropIfExists('compliance_reference_records');
        Schema::dropIfExists('compliance_reference_registers');
        Schema::table('regulated_material_rules', fn (Blueprint $table) => $table->dropColumn(['product_name', 'reference_standard', 'technical_regulation', 'scope', 'marking_requirements']));
        Schema::table('technical_attribute_definitions', fn (Blueprint $table) => $table->dropColumn(['allowed_values', 'unit_code', 'sort_order', 'comparability_key']));
        Schema::table('materials', fn (Blueprint $table) => $table->dropColumn('normalized_name'));
    }
};
