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
        Schema::table('fee_statements', function (Blueprint $table): void {
            $table->string('issuance_origin', 16)->default('MANUAL');
        });
        DB::statement('ALTER TABLE fee_statements DROP CONSTRAINT fee_statement_approval_check');
        DB::statement("ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_approval_check CHECK (issuance_origin IN ('MANUAL','SYSTEM') AND ((state IN ('DRAFT','VOIDED')) = (approved_at IS NULL)) AND (approved_at IS NULL OR (issuance_origin = 'SYSTEM' AND approved_by_user_id IS NULL) OR (issuance_origin = 'MANUAL' AND approved_by_user_id IS NOT NULL)))");
        Schema::table('fee_adjustments', function (Blueprint $table): void {
            $table->string('origin', 16)->default('MANUAL');
            $table->foreignUuid('dispute_remedy_id')->nullable()->unique()->constrained('dispute_remedies')->restrictOnDelete();
        });
        Schema::create('commission_credit_executions', function (Blueprint $table): void {
            $table->foreignUuid('dispute_remedy_id')->primary()->constrained('dispute_remedies')->restrictOnDelete();
            $table->foreignUuid('fee_assessment_id')->constrained('fee_assessments')->restrictOnDelete();
            $table->timestampTz('created_at');
        });
        DB::statement('CREATE TRIGGER commission_credit_executions_protected BEFORE UPDATE OR DELETE ON commission_credit_executions FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation()');
        DB::statement('ALTER TABLE fee_adjustments ALTER COLUMN prepared_by_user_id DROP NOT NULL');
        DB::statement('ALTER TABLE fee_adjustments ALTER COLUMN approved_by_user_id DROP NOT NULL');
        DB::statement('ALTER TABLE fee_adjustments DROP CONSTRAINT fee_adjustment_actor_check');
        DB::statement("ALTER TABLE fee_adjustments ADD CONSTRAINT fee_adjustment_actor_check CHECK (
            (origin = 'MANUAL' AND dispute_remedy_id IS NULL AND prepared_by_user_id IS NOT NULL AND approved_by_user_id IS NOT NULL AND prepared_by_user_id <> approved_by_user_id)
            OR (origin = 'DISPUTE' AND kind = 'CREDIT' AND dispute_remedy_id IS NOT NULL AND prepared_by_user_id IS NULL AND approved_by_user_id IS NULL)
        )");
    }

    public function down(): void
    {
        if (DB::table('fee_adjustments')->where('origin', 'DISPUTE')->exists() || DB::table('fee_statements')->where('issuance_origin', 'SYSTEM')->exists() || DB::table('commission_credit_executions')->exists()) {
            throw new LogicException('Automatic commission credit history must be retained.');
        }
        DB::statement('ALTER TABLE fee_statements DROP CONSTRAINT fee_statement_approval_check');
        DB::statement("ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_approval_check CHECK (((state IN ('DRAFT','VOIDED')) = (approved_at IS NULL)) AND (approved_at IS NULL OR approved_by_user_id IS NOT NULL))");
        Schema::table('fee_statements', fn (Blueprint $table) => $table->dropColumn('issuance_origin'));
        DB::statement('ALTER TABLE fee_adjustments DROP CONSTRAINT fee_adjustment_actor_check');
        DB::statement('ALTER TABLE fee_adjustments ALTER COLUMN prepared_by_user_id SET NOT NULL');
        DB::statement('ALTER TABLE fee_adjustments ALTER COLUMN approved_by_user_id SET NOT NULL');
        DB::statement('ALTER TABLE fee_adjustments ADD CONSTRAINT fee_adjustment_actor_check CHECK (prepared_by_user_id <> approved_by_user_id)');
        Schema::dropIfExists('commission_credit_executions');
        Schema::table('fee_adjustments', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('dispute_remedy_id');
            $table->dropColumn('origin');
        });
    }
};
