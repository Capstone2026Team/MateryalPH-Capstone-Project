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
        Schema::table('projects', fn (Blueprint $t) => $t->unsignedInteger('lock_version')->default(1));
        Schema::table('buyer_ranking_preferences', fn (Blueprint $t) => $t->boolean('is_personalized')->default(true));
        Schema::table('project_sites', function (Blueprint $t): void {
            $t->string('name')->nullable();
            $t->jsonb('snapshot')->default('{}');
            $t->string('discovery_origin', 32)->nullable();
        });
        Schema::table('work_packages', function (Blueprint $t): void {
            $t->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('work_package_versions', function (Blueprint $t): void {
            $t->jsonb('content')->default('{}');
            $t->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
        Schema::table('work_package_lines', function (Blueprint $t): void {
            $t->unsignedSmallInteger('line_number')->nullable();
            $t->string('name')->nullable();
            $t->string('preferred_brand')->nullable();
            $t->unique(['work_package_version_id', 'line_number']);
        });
        Schema::table('compiled_estimates', function (Blueprint $t): void {
            $t->jsonb('context')->default('{}');
            $t->timestampTz('invalidated_at')->nullable();
        });
        Schema::table('compiled_estimate_vendors', function (Blueprint $t): void {
            $t->jsonb('snapshot')->default('{}');
            $t->decimal('fms', 5, 2)->nullable()->change();
            $t->bigInteger('projected_total_centavos')->nullable()->change();
        });
        Schema::table('compiled_estimate_lines', fn (Blueprint $t) => $t->jsonb('snapshot')->default('{}'));
        Schema::table('orders', function (Blueprint $t): void {
            $t->foreignUuid('work_package_version_id')->nullable()->constrained()->restrictOnDelete();
            $t->foreignUuid('compiled_estimate_vendor_id')->nullable()->constrained()->restrictOnDelete();
            $t->text('project_note')->nullable();
        });
        Schema::create('work_package_missing_lines', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('work_package_version_id')->constrained()->restrictOnDelete();
            $t->foreignUuid('work_package_line_id')->constrained()->restrictOnDelete();
            $t->decimal('quantity', 18, 4);
            $t->foreignUuid('linked_order_id')->nullable()->constrained('orders')->restrictOnDelete();
            $t->foreignId('waived_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->text('waiver_reason')->nullable();
            $t->timestampsTz();
            $t->unique(['work_package_version_id', 'work_package_line_id']);
        });
        Schema::table('budget_overrides', function (Blueprint $t): void {
            $t->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $t->jsonb('snapshot')->default('{}');
        });
        DB::table('platform_settings')->insertOrIgnore(['id' => (string) Str::uuid7(), 'key' => 'ranking.fms.default_weights',
            'value' => json_encode(['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 15], JSON_THROW_ON_ERROR),
            'version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        DB::unprepared(<<<'SQL'
ALTER TABLE projects ADD CONSTRAINT project_status_check CHECK (status IN ('ACTIVE','COMPLETED','ARCHIVED'));
ALTER TABLE projects ADD CONSTRAINT project_dates_check CHECK (starts_on IS NULL OR ends_on IS NULL OR ends_on >= starts_on);
ALTER TABLE work_packages ADD CONSTRAINT package_status_check CHECK (status IN ('DRAFT','ACTIVE','QUOTATION_INQUIRY','VENDOR_SELECTED','AWAITING_PAYMENT','IN_PROGRESS','COMPLETED','CANCELLED'));
ALTER TABLE work_package_missing_lines ADD CONSTRAINT missing_line_check CHECK (quantity > 0 AND NOT (linked_order_id IS NOT NULL AND waived_by_user_id IS NOT NULL));
ALTER TABLE buyer_ranking_preferences ADD CONSTRAINT buyer_ranking_project_weights_check CHECK (procurement_type <> 'PROJECT_BASED' OR (
 jsonb_typeof(weights) = 'object' AND jsonb_exists_all(weights, array['material_match','budget_fit','distance','vps'])
 AND (weights - array['material_match','budget_fit','distance','vps']) = '{}'::jsonb
 AND (weights->>'material_match') ~ '^[0-9]{1,3}$' AND (weights->>'budget_fit') ~ '^[0-9]{1,3}$'
 AND (weights->>'distance') ~ '^[0-9]{1,3}$' AND (weights->>'vps') ~ '^[0-9]{1,3}$'
 AND (weights->>'material_match')::int BETWEEN 0 AND 100 AND (weights->>'budget_fit')::int BETWEEN 0 AND 100
 AND (weights->>'distance')::int BETWEEN 0 AND 100 AND (weights->>'vps')::int BETWEEN 0 AND 100
 AND (weights->>'material_match')::int + (weights->>'budget_fit')::int + (weights->>'distance')::int + (weights->>'vps')::int = 100));
CREATE UNIQUE INDEX one_project_order_per_version ON orders(work_package_version_id) WHERE procurement_type = 'PROJECT_BASED' AND order_state NOT IN ('CANCELLED','DECLINED','EXPIRED');
CREATE OR REPLACE FUNCTION protect_work_package_version() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF OLD.locked_at IS NOT NULL THEN RAISE EXCEPTION 'Locked Work Package versions are immutable.'; END IF;
 RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END; $$;
CREATE TRIGGER work_package_version_immutable BEFORE UPDATE OR DELETE ON work_package_versions FOR EACH ROW EXECUTE FUNCTION protect_work_package_version();
CREATE OR REPLACE FUNCTION protect_work_package_line() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF EXISTS (SELECT 1 FROM work_package_versions WHERE id = CASE WHEN TG_OP = 'INSERT' THEN NEW.work_package_version_id ELSE OLD.work_package_version_id END AND locked_at IS NOT NULL)
 OR (TG_OP = 'UPDATE' AND EXISTS (SELECT 1 FROM work_package_versions WHERE id = NEW.work_package_version_id AND locked_at IS NOT NULL)) THEN
  RAISE EXCEPTION 'Locked Work Package lines are immutable.';
 END IF;
 RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END; $$;
CREATE TRIGGER work_package_line_immutable BEFORE INSERT OR UPDATE OR DELETE ON work_package_lines FOR EACH ROW EXECUTE FUNCTION protect_work_package_line();
CREATE OR REPLACE FUNCTION protect_compiled_estimate() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF TG_OP = 'DELETE' THEN RAISE EXCEPTION 'Compiled estimates are retained.'; END IF;
 IF (to_jsonb(OLD) - array['state','invalidated_at','updated_at']) IS DISTINCT FROM (to_jsonb(NEW) - array['state','invalidated_at','updated_at']) THEN
  RAISE EXCEPTION 'Compiled estimate sources and expiry are immutable.';
 END IF;
 RETURN NEW;
END; $$;
CREATE TRIGGER compiled_estimate_immutable BEFORE UPDATE OR DELETE ON compiled_estimates FOR EACH ROW EXECUTE FUNCTION protect_compiled_estimate();
CREATE TRIGGER compiled_vendor_immutable BEFORE UPDATE OR DELETE ON compiled_estimate_vendors FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER compiled_line_immutable BEFORE UPDATE OR DELETE ON compiled_estimate_lines FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER budget_override_immutable BEFORE UPDATE OR DELETE ON budget_overrides FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE OR REPLACE FUNCTION protect_project_inquiry_original() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF OLD.context_type = 'PROJECT_BASED' AND (OLD.locked_reference IS DISTINCT FROM NEW.locked_reference OR OLD.context_id IS DISTINCT FROM NEW.context_id OR OLD.context_type IS DISTINCT FROM NEW.context_type) THEN
  RAISE EXCEPTION 'The Buyer original attached to a Project inquiry is immutable.';
 END IF;
 RETURN NEW;
END; $$;
CREATE TRIGGER project_inquiry_original_immutable BEFORE UPDATE ON conversations FOR EACH ROW EXECUTE FUNCTION protect_project_inquiry_original();
SQL);
    }

    public function down(): void
    {
        if (DB::table('projects')->exists() || DB::table('compiled_estimates')->exists() || DB::table('budget_overrides')->exists()
            || DB::table('buyer_ranking_preferences')->where('procurement_type', 'PROJECT_BASED')->exists()) {
            throw new LogicException('Phase 10 contains Project history. Use a reviewed forward migration.');
        }
        DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS project_inquiry_original_immutable ON conversations;
DROP FUNCTION IF EXISTS protect_project_inquiry_original();
DROP TRIGGER IF EXISTS budget_override_immutable ON budget_overrides;
DROP TRIGGER IF EXISTS compiled_line_immutable ON compiled_estimate_lines;
DROP TRIGGER IF EXISTS compiled_vendor_immutable ON compiled_estimate_vendors;
DROP TRIGGER IF EXISTS compiled_estimate_immutable ON compiled_estimates;
DROP FUNCTION IF EXISTS protect_compiled_estimate();
DROP TRIGGER IF EXISTS work_package_line_immutable ON work_package_lines;
DROP FUNCTION IF EXISTS protect_work_package_line();
DROP TRIGGER IF EXISTS work_package_version_immutable ON work_package_versions;
DROP FUNCTION IF EXISTS protect_work_package_version();
DROP INDEX IF EXISTS one_project_order_per_version;
ALTER TABLE buyer_ranking_preferences DROP CONSTRAINT IF EXISTS buyer_ranking_project_weights_check;
ALTER TABLE work_packages DROP CONSTRAINT IF EXISTS package_status_check;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS project_dates_check;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS project_status_check;
SQL);
        Schema::dropIfExists('work_package_missing_lines');
        Schema::table('orders', function (Blueprint $t): void {
            $t->dropConstrainedForeignId('work_package_version_id');
            $t->dropConstrainedForeignId('compiled_estimate_vendor_id');
            $t->dropColumn('project_note');
        });
        Schema::table('budget_overrides', function (Blueprint $t): void {
            $t->dropConstrainedForeignId('order_id');
            $t->dropColumn('snapshot');
        });
        Schema::table('compiled_estimate_lines', fn (Blueprint $t) => $t->dropColumn('snapshot'));
        Schema::table('compiled_estimate_vendors', function (Blueprint $t): void {
            $t->dropColumn('snapshot');
            $t->decimal('fms', 5, 2)->nullable(false)->change();
            $t->bigInteger('projected_total_centavos')->nullable(false)->change();
        });
        Schema::table('compiled_estimates', fn (Blueprint $t) => $t->dropColumn(['context', 'invalidated_at']));
        Schema::table('work_package_lines', function (Blueprint $t): void {
            $t->dropUnique(['work_package_version_id', 'line_number']);
            $t->dropColumn(['line_number', 'name', 'preferred_brand']);
        });
        Schema::table('work_package_versions', function (Blueprint $t): void {
            $t->dropConstrainedForeignId('created_by_user_id');
            $t->dropColumn('content');
        });
        Schema::table('work_packages', fn (Blueprint $t) => $t->dropColumn('lock_version'));
        Schema::table('project_sites', fn (Blueprint $t) => $t->dropColumn(['name', 'snapshot', 'discovery_origin']));
        Schema::table('buyer_ranking_preferences', fn (Blueprint $t) => $t->dropColumn('is_personalized'));
        Schema::table('projects', fn (Blueprint $t) => $t->dropColumn('lock_version'));
        DB::table('platform_settings')->where('key', 'ranking.fms.default_weights')->delete();
    }
};
