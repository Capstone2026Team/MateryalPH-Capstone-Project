<?php

declare(strict_types=1);

use App\Domain\Finance\CommissionService;
use App\Domain\Finance\StatementService;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('fee_statement_lines', 'corrects_line_id')) {
            Schema::table('fee_statement_lines', function (Blueprint $table): void {
                $table->foreignUuid('corrects_line_id')->nullable()->references('id')->on('fee_statement_lines')->restrictOnDelete();
                $table->unique(['corrects_line_id', 'fee_statement_id', 'line_type'], 'fee_statement_correction_unique');
            });
        }
        DB::statement('ALTER TABLE fee_statement_lines DROP CONSTRAINT fee_statement_line_source_check');
        DB::statement('ALTER TABLE fee_statement_lines ADD CONSTRAINT fee_statement_line_source_check CHECK ((fee_assessment_id IS NOT NULL)::int + (fee_adjustment_id IS NOT NULL)::int + (corrects_line_id IS NOT NULL)::int = 1)');
        DB::statement('ALTER TABLE fee_statements DROP CONSTRAINT fee_statement_amounts_check');
        DB::statement('ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_amounts_check CHECK (charges_centavos >= 0 AND credits_centavos >= 0 AND paid_centavos >= 0 AND balance_centavos >= 0 AND outstanding_centavos = balance_centavos AND balance_centavos = GREATEST(0, charges_centavos - credits_centavos - paid_centavos))');
        $correlationId = (string) Str::uuid7();
        app(StatementService::class)->synchronizeCredits($correlationId);
        app(CommissionService::class)->synchronizeCreditVat($correlationId);
    }

    public function down(): void
    {
        // Approved credits, original payments and compensating postings remain commercial history.
        // The constraint continues to permit credits on paid bills; rollback must not recreate settled debt.
    }
};
