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
        Schema::create('vendor_representative_versions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->text('details_encrypted');
            $table->string('content_hash', 64);
            $table->foreignId('account_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('created_at');
            $table->unique(['vendor_organization_id', 'version']);
        });
        Schema::create('vendor_authority_reviews', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('representative_version_id')->constrained('vendor_representative_versions')->restrictOnDelete();
            $table->foreignUuid('evidence_version_id')->nullable()->constrained('business_document_versions')->restrictOnDelete();
            $table->string('decision', 24);
            $table->text('scope')->nullable();
            $table->text('reason')->nullable();
            $table->foreignId('reviewer_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('reviewed_at');
        });
        Schema::create('vendor_verification_changes', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('actor_user_id')->constrained('users')->restrictOnDelete();
            $table->text('snapshot_encrypted');
            $table->jsonb('affected_requirements');
            $table->timestampTz('created_at');
        });
        foreach (['agreement_acceptances', 'vendor_tax_profile_versions'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->foreignUuid('representative_version_id')->nullable()->constrained('vendor_representative_versions')->restrictOnDelete();
            });
        }
        DB::statement("ALTER TABLE vendor_authority_reviews ADD CONSTRAINT vendor_authority_decision_check CHECK (decision IN ('APPROVED','CHANGES_REQUIRED','REJECTED') AND (decision = 'APPROVED' OR length(trim(reason)) > 0) AND (decision <> 'APPROVED' OR (evidence_version_id IS NOT NULL AND length(trim(scope)) > 0)))");
        foreach (['vendor_representative_versions', 'vendor_authority_reviews', 'vendor_verification_changes'] as $table) {
            DB::unprepared("CREATE TRIGGER {$table}_immutable BEFORE UPDATE OR DELETE ON {$table} FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation()");
        }
    }

    public function down(): void
    {
        foreach (['agreement_acceptances', 'vendor_tax_profile_versions'] as $name) {
            Schema::table($name, fn (Blueprint $table) => $table->dropConstrainedForeignId('representative_version_id'));
        }
        Schema::dropIfExists('vendor_verification_changes');
        Schema::dropIfExists('vendor_authority_reviews');
        Schema::dropIfExists('vendor_representative_versions');
    }
};
