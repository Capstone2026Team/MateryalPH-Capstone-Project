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
        Schema::table('agreement_versions', function (Blueprint $table): void {
            $table->text('published_content')->nullable();
        });
        Schema::table('fee_policy_versions', function (Blueprint $table): void {
            $table->foreignUuid('agreement_version_id')->nullable()->constrained('agreement_versions')->restrictOnDelete();
            $table->text('reason')->nullable();
        });
        DB::statement('ALTER TABLE fee_policy_versions DROP CONSTRAINT fee_policy_commission_check');
        DB::statement("ALTER TABLE fee_policy_versions ADD CONSTRAINT fee_policy_commission_check CHECK (commission_basis_points BETWEEN 0 AND 10000 AND basis = 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT' AND cadence = 'MONTHLY')");
        DB::statement('ALTER TABLE fee_assessments DROP CONSTRAINT fee_assessment_amounts_check');
        DB::statement('ALTER TABLE fee_assessments ADD CONSTRAINT fee_assessment_amounts_check CHECK (commission_basis_centavos >= 0 AND commission_basis_points BETWEEN 0 AND 10000 AND earned_centavos >= 0 AND earned_target_centavos >= 0 AND credited_centavos >= 0 AND credited_centavos <= earned_centavos)');
        DB::statement('CREATE INDEX fee_policy_effective_lookup ON fee_policy_versions (environment, code, effective_from DESC, version DESC)');
        // Published rate terms are immutable, including their content hash and effective date.
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION protect_published_commission_terms() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.published_content IS NOT NULL THEN
        RAISE EXCEPTION 'Published commission terms are immutable';
    END IF;
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER published_commission_terms_immutable BEFORE UPDATE OR DELETE ON agreement_versions
FOR EACH ROW EXECUTE FUNCTION protect_published_commission_terms();
CREATE OR REPLACE FUNCTION protect_commercial_commission_policy() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.agreement_version_id IS NOT NULL THEN
        RAISE EXCEPTION 'Published commission policies are immutable';
    END IF;
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER commercial_commission_policy_immutable BEFORE UPDATE OR DELETE ON fee_policy_versions
FOR EACH ROW EXECUTE FUNCTION protect_commercial_commission_policy();
SQL);
    }

    public function down(): void
    {
        if (DB::table('fee_policy_versions')->whereNotNull('agreement_version_id')->exists()) {
            throw new RuntimeException('Published commission policies and consent history must be retained.');
        }
        DB::unprepared('DROP TRIGGER commercial_commission_policy_immutable ON fee_policy_versions; DROP FUNCTION protect_commercial_commission_policy(); DROP TRIGGER published_commission_terms_immutable ON agreement_versions; DROP FUNCTION protect_published_commission_terms(); DROP INDEX fee_policy_effective_lookup;');
        DB::statement('ALTER TABLE fee_policy_versions DROP CONSTRAINT fee_policy_commission_check');
        DB::statement("ALTER TABLE fee_policy_versions ADD CONSTRAINT fee_policy_commission_check CHECK (commission_basis_points = 200 AND basis = 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT' AND cadence = 'MONTHLY')");
        DB::statement('ALTER TABLE fee_assessments DROP CONSTRAINT fee_assessment_amounts_check');
        DB::statement('ALTER TABLE fee_assessments ADD CONSTRAINT fee_assessment_amounts_check CHECK (commission_basis_centavos >= 0 AND commission_basis_points = 200 AND earned_centavos >= 0 AND earned_target_centavos >= 0 AND credited_centavos >= 0 AND credited_centavos <= earned_centavos)');
        Schema::table('fee_policy_versions', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('agreement_version_id');
            $table->dropColumn('reason');
        });
        Schema::table('agreement_versions', fn (Blueprint $table) => $table->dropColumn('published_content'));
    }
};
