<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    private const NAMES = [
        'vendor_onboarding_steps' => 'vendor_onboarding_requirements',
        'business_documents' => 'vendor_documents',
        'business_document_versions' => 'vendor_document_versions',
        'vendor_verification_changes' => 'vendor_verification_change_history',
    ];

    public function up(): void
    {
        // Preserve IDs, foreign keys and existing callers through writable compatibility views.
        foreach (self::NAMES as $old => $new) {
            Schema::rename($old, $new);
            DB::statement("CREATE VIEW {$old} AS SELECT * FROM {$new}");
        }
        Schema::table('vendor_onboarding_requirements', function (Blueprint $table): void {
            $table->boolean('blocking')->default(true);
            $table->text('blocking_reason')->nullable();
            $table->string('resolution_hash', 64)->nullable();
        });
        DB::statement("ALTER TABLE vendor_onboarding_requirements ADD CONSTRAINT requirement_applicability_check CHECK (status <> 'NOT_APPLICABLE' OR (level = 'CONDITIONALLY_REQUIRED' AND applicability_reason IS NOT NULL AND length(trim(applicability_reason)) > 0))");
        Schema::create('vendor_onboarding_drafts', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('workstream', 24);
            $table->text('payload_encrypted');
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
            $table->unique(['vendor_organization_id', 'workstream']);
        });
        DB::statement("ALTER TABLE vendor_onboarding_drafts ADD CONSTRAINT draft_workstream_check CHECK (workstream IN ('STORE_VERIFICATION','STORE_SETUP') AND lock_version > 0)");
        Schema::table('vendor_document_versions', function (Blueprint $table): void {
            $table->string('mime_type', 100)->nullable();
            $table->unsignedBigInteger('byte_size')->nullable();
            $table->string('content_validation_state', 24)->default('UNVERIFIED');
        });
        DB::statement('ALTER TABLE vendor_document_versions DISABLE TRIGGER business_document_versions_immutable');
        DB::statement('UPDATE vendor_document_versions v SET mime_type = f.content_type, byte_size = f.byte_size FROM files f WHERE v.file_id = f.id');
        DB::statement('ALTER TABLE vendor_document_versions ENABLE TRIGGER business_document_versions_immutable');
        DB::statement("ALTER TABLE vendor_document_versions ADD CONSTRAINT evidence_validation_check CHECK (scan_state IN ('PENDING','CLEAN','FAILED','INFECTED','ERROR') AND content_validation_state IN ('UNVERIFIED','VALID','INVALID') AND (byte_size IS NULL OR byte_size > 0))");
        // A forward chain is derived from immutable predecessor links, never by modifying evidence.
        DB::statement('CREATE VIEW vendor_document_supersessions AS SELECT supersedes_version_id AS version_id, id AS superseded_by_version_id FROM vendor_document_versions WHERE supersedes_version_id IS NOT NULL');
        DB::unprepared(<<<'SQL'
CREATE UNIQUE INDEX vendor_document_predecessor_unique ON vendor_document_versions (supersedes_version_id) WHERE supersedes_version_id IS NOT NULL;
CREATE OR REPLACE FUNCTION validate_vendor_evidence_chain() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.supersedes_version_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vendor_document_versions v WHERE v.id=NEW.supersedes_version_id
        AND v.business_document_id=NEW.business_document_id AND v.version=NEW.version-1
    ) THEN RAISE EXCEPTION 'Invalid evidence predecessor'; END IF;
    IF NOT EXISTS (
        SELECT 1 FROM files f JOIN vendor_documents d ON d.id=NEW.business_document_id
        WHERE f.id=NEW.file_id AND f.owner_type='VENDOR_ORGANIZATION' AND f.owner_id=d.vendor_organization_id
        AND f.visibility='PRIVATE' AND f.purpose='BUSINESS_DOCUMENT'
    ) THEN RAISE EXCEPTION 'Invalid evidence ownership'; END IF;
    RETURN NEW;
END; $$;
CREATE TRIGGER vendor_evidence_chain BEFORE INSERT ON vendor_document_versions FOR EACH ROW EXECUTE FUNCTION validate_vendor_evidence_chain();
CREATE OR REPLACE FUNCTION validate_vendor_document_pointer() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.current_version_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vendor_document_versions v WHERE v.id=NEW.current_version_id AND v.business_document_id=NEW.id
    ) THEN RAISE EXCEPTION 'Document version belongs to a different document'; END IF;
    RETURN NEW;
END; $$;
CREATE TRIGGER vendor_document_pointer BEFORE INSERT OR UPDATE OF current_version_id ON vendor_documents FOR EACH ROW EXECUTE FUNCTION validate_vendor_document_pointer();
SQL);
        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->text('branch_code_encrypted')->nullable();
            $table->boolean('declaration_claim')->nullable();
            $table->unsignedSmallInteger('taxable_year')->nullable();
        });
        DB::table('vendor_tax_profile_versions')->orderBy('id')->each(function (object $row): void {
            $details = json_decode($row->tax_details ?? '{}', true, flags: JSON_THROW_ON_ERROR);
            DB::table('vendor_tax_profile_versions')->where('id', $row->id)->update([
                'branch_code_encrypted' => $row->tin_branch_code === null ? null : Crypt::encryptString($row->tin_branch_code),
                'tin_branch_code' => null,
                'declaration_claim' => $details['tax_relief_claimed'] ?? null,
                'taxable_year' => $details['declaration_year'] ?? null,
            ]);
        });
        DB::statement("ALTER TABLE vendor_authority_reviews ADD CONSTRAINT authority_scope_check CHECK (scope IS NULL OR scope = '' OR string_to_array(scope, ',') <@ ARRAY['TAX_DECLARATIONS','COMMISSION_AGREEMENT','PAYMENT_CONFIGURATION']::text[])");
        DB::statement("ALTER TABLE vendor_authority_reviews ADD CONSTRAINT authority_reason_required CHECK (decision = 'APPROVED' OR (reason IS NOT NULL AND length(trim(reason)) > 0))");
        Schema::create('privacy_acknowledgments', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('agreement_version_id')->constrained('agreement_versions')->restrictOnDelete();
            $table->timestampTz('acknowledged_at');
            $table->unique(['vendor_organization_id', 'user_id', 'agreement_version_id'], 'privacy_ack_unique');
        });
        DB::statement("INSERT INTO privacy_acknowledgments SELECT a.id, a.vendor_organization_id, a.user_id, a.agreement_version_id, a.accepted_at FROM agreement_acceptances a JOIN agreement_versions v ON v.id=a.agreement_version_id JOIN agreement_documents d ON d.id=v.agreement_document_id WHERE d.code='PRIVACY_NOTICE' AND a.vendor_organization_id IS NOT NULL");
        Schema::create('vendor_addresses', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->uuid('current_version_id')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampsTz();
        });
        Schema::create('vendor_address_versions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_address_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            foreach (['street', 'unit', 'barangay', 'city_municipality', 'province', 'postal_code', 'psgc_code', 'formatted_address'] as $field) {
                $table->text($field)->nullable();
            }
            $table->string('country_code', 2)->default('PH');
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->string('source', 24);
            $table->timestampTz('created_at');
            $table->unique(['vendor_address_id', 'version']);
        });
        DB::statement('ALTER TABLE vendor_address_versions ADD COLUMN location geography(Point,4326)');
        DB::statement('CREATE INDEX vendor_address_location_gist ON vendor_address_versions USING gist (location)');
        DB::statement("ALTER TABLE vendor_address_versions ADD CONSTRAINT vendor_address_fields_check CHECK (country_code = 'PH' AND version > 0 AND ((latitude IS NULL AND longitude IS NULL AND location IS NULL) OR (latitude IS NOT NULL AND longitude IS NOT NULL AND location IS NOT NULL AND latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180 AND abs(ST_Y(location::geometry)-latitude) < 0.0000001 AND abs(ST_X(location::geometry)-longitude) < 0.0000001)))");
        Schema::table('vendor_addresses', fn (Blueprint $table) => $table->foreign('current_version_id')->references('id')->on('vendor_address_versions')->restrictOnDelete());
        foreach (DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->distinct()->pluck('owner_id') as $organizationId) {
            DB::table('vendor_addresses')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        }
        DB::statement("INSERT INTO vendor_address_versions (id,vendor_address_id,version,street,unit,barangay,city_municipality,province,postal_code,psgc_code,formatted_address,latitude,longitude,source,location,created_at) SELECT a.id,v.id,a.version,a.street,a.unit,a.barangay,a.city_municipality,a.province,a.postal_code,a.psgc_code,a.formatted_address,a.latitude,a.longitude,a.source,a.location,a.created_at FROM addresses a JOIN vendor_addresses v ON v.vendor_organization_id=a.owner_id WHERE a.owner_type='VENDOR_ORGANIZATION'");
        DB::statement("UPDATE vendor_addresses v SET current_version_id=a.id FROM addresses a WHERE a.owner_type='VENDOR_ORGANIZATION' AND a.owner_id=v.vendor_organization_id AND a.is_current=true");
        foreach (['privacy_acknowledgments', 'vendor_address_versions'] as $table) {
            DB::unprepared("CREATE TRIGGER {$table}_immutable BEFORE UPDATE OR DELETE ON {$table} FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation()");
        }
        Schema::table('vendor_activation_history', fn (Blueprint $table) => $table->string('rule_version', 32)->default('phase3.v1'));
        DB::statement("ALTER TABLE vendor_activation_history ALTER COLUMN rule_version SET DEFAULT 'phase3a.v1'");
    }

    public function down(): void
    {
        Schema::table('vendor_activation_history', fn (Blueprint $table) => $table->dropColumn('rule_version'));
        Schema::table('vendor_addresses', fn (Blueprint $table) => $table->dropForeign(['current_version_id']));
        Schema::drop('vendor_address_versions');
        Schema::drop('vendor_addresses');
        Schema::drop('privacy_acknowledgments');
        DB::statement('ALTER TABLE vendor_authority_reviews DROP CONSTRAINT authority_scope_check');
        DB::statement('ALTER TABLE vendor_authority_reviews DROP CONSTRAINT authority_reason_required');
        DB::table('vendor_tax_profile_versions')->whereNotNull('branch_code_encrypted')->orderBy('id')->each(function (object $row): void {
            DB::table('vendor_tax_profile_versions')->where('id', $row->id)->update(['tin_branch_code' => Crypt::decryptString($row->branch_code_encrypted)]);
        });
        Schema::table('vendor_tax_profile_versions', fn (Blueprint $table) => $table->dropColumn(['branch_code_encrypted', 'declaration_claim', 'taxable_year']));
        DB::statement('DROP VIEW vendor_document_supersessions');
        DB::statement('DROP TRIGGER vendor_document_pointer ON vendor_documents');
        DB::statement('DROP FUNCTION validate_vendor_document_pointer()');
        DB::statement('DROP TRIGGER vendor_evidence_chain ON vendor_document_versions');
        DB::statement('DROP FUNCTION validate_vendor_evidence_chain()');
        DB::statement('DROP INDEX vendor_document_predecessor_unique');
        DB::statement('ALTER TABLE vendor_document_versions DROP CONSTRAINT evidence_validation_check');
        Schema::table('vendor_document_versions', fn (Blueprint $table) => $table->dropColumn(['mime_type', 'byte_size', 'content_validation_state']));
        Schema::drop('vendor_onboarding_drafts');
        DB::statement('ALTER TABLE vendor_onboarding_requirements DROP CONSTRAINT requirement_applicability_check');
        Schema::table('vendor_onboarding_requirements', fn (Blueprint $table) => $table->dropColumn(['blocking', 'blocking_reason', 'resolution_hash']));
        foreach (array_reverse(self::NAMES) as $old => $new) {
            DB::statement("DROP VIEW {$old}");
            Schema::rename($new, $old);
        }
    }
};
