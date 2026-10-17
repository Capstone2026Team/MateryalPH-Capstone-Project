<?php

declare(strict_types=1);

use App\Domain\Finance\RemittanceAssessmentService;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-05 step 4: a fully refunded collection is voided and leaves the FIN-04A gross-remittance counter, so refunded
 * money is not treated as paid. The counter still never decreases once the taxable year has crossed the threshold;
 * the only permitted decrease is in an uncrossed year, written by RemittanceAssessmentService together with the
 * VOIDED assessment and a status event. Collections refunded before this rule existed are voided once here.
 */
return new class extends Migration
{
    public function up(): void
    {
        $this->guard(allowUncrossedDecrease: true);
        app(RemittanceAssessmentService::class)->voidAllFullyRefundedCollections((string) Str::uuid7());
    }

    public function down(): void
    {
        $this->guard(allowUncrossedDecrease: false);
    }

    private function guard(bool $allowUncrossedDecrease): void
    {
        $decrease = $allowUncrossedDecrease
            ? 'IF NEW.g_accumulated_centavos < OLD.g_accumulated_centavos AND (OLD.crossed_at IS NOT NULL OR NEW.crossed_at IS NOT NULL) THEN'
            : 'IF NEW.g_accumulated_centavos < OLD.g_accumulated_centavos THEN';
        $message = $allowUncrossedDecrease
            ? 'The posted gross-remittance total of a crossed taxable year never decreases; open an adjustment review.'
            : 'The posted gross-remittance total never decreases; open an adjustment review.';
        DB::unprepared(<<<SQL
CREATE OR REPLACE FUNCTION protect_withholding_accumulators() RETURNS trigger LANGUAGE plpgsql AS \$\$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Withholding accumulators are retained.';
    END IF;
    IF (NEW.environment, NEW.taxpayer_key, NEW.taxable_year, NEW.organization_id, NEW.threshold_centavos) IS DISTINCT FROM (OLD.environment, OLD.taxpayer_key, OLD.taxable_year, OLD.organization_id, OLD.threshold_centavos) THEN
        RAISE EXCEPTION 'An accumulator key and threshold are fixed.';
    END IF;
    {$decrease}
        RAISE EXCEPTION '{$message}';
    END IF;
    IF OLD.crossed_at IS NOT NULL AND (NEW.crossed_at IS DISTINCT FROM OLD.crossed_at OR NEW.crossing_assessment_id IS DISTINCT FROM OLD.crossing_assessment_id OR NEW.withholding_status <> 'SUBJECT_THRESHOLD_BREACHED') THEN
        RAISE EXCEPTION 'A threshold crossing is final for the taxable year.';
    END IF;
    RETURN NEW;
END;
\$\$;
SQL);
    }
};
