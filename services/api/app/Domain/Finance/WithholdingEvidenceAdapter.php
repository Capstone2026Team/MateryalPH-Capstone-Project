<?php

declare(strict_types=1);

namespace App\Domain\Finance;

/**
 * FIN-05 step 8 deduction evidence, separate from payment evidence: it can never infer a BIR deduction from a
 * Xendit TEST payment webhook. The DEMO adapter only ever reports SIMULATED evidence under the scenario's actor.
 */
interface WithholdingEvidenceAdapter
{
    /** @return array{state: string, actor: ?string, reported_withheld_centavos: ?int, reconciliation_state: string} */
    public function deduction(string $scenario, int $expectedWithheldCentavos): array;
}
