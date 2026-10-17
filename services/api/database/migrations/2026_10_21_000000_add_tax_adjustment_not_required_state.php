<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * FIN-07: a fully refunded collection in an uncrossed year is voided, so nothing remains to review. The system-opened
 * tax review nobody has started is closed as NOT_REQUIRED instead of waiting for a person to reject it. A row is never
 * deleted and a prepared, approved or posted adjustment is never touched.
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::statement('ALTER TABLE tax_adjustments DROP CONSTRAINT tax_adjustment_state_check');
        DB::statement("ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_state_check CHECK (state IN ('ADJUSTMENT_REQUIRED','UNDER_REVIEW','APPROVED','POSTED','REJECTED','NOT_REQUIRED'))");
        DB::statement(<<<'SQL'
UPDATE tax_adjustments t
SET state = 'NOT_REQUIRED',
    after_values = jsonb_build_object('closed_by', 'SYSTEM', 'note', 'The collection was fully refunded and voided before the taxable year crossed the threshold; no withholding remains to review.'),
    updated_at = now()
FROM remittance_assessments a
WHERE a.id = t.remittance_assessment_id AND a.calculation_state = 'VOIDED'
  AND t.opened_by = 'SYSTEM' AND t.state = 'ADJUSTMENT_REQUIRED' AND t.prepared_by_user_id IS NULL
SQL);
    }

    public function down(): void
    {
        if (DB::table('tax_adjustments')->where('state', 'NOT_REQUIRED')->exists()) {
            throw new LogicException('Closed tax adjustments are retained. Use a reviewed forward migration.');
        }
        DB::statement('ALTER TABLE tax_adjustments DROP CONSTRAINT tax_adjustment_state_check');
        DB::statement("ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_state_check CHECK (state IN ('ADJUSTMENT_REQUIRED','UNDER_REVIEW','APPROVED','POSTED','REJECTED'))");
    }
};
