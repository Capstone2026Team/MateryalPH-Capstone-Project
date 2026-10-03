<?php

declare(strict_types=1);

namespace App\Domain\Finance;

/**
 * DEMO_PLATFORM_WITHHOLDER (default teaching scenario) records the simulated platform deduction; reconciliation
 * stays PENDING because no platform remittance evidence exists. DEMO_PROVIDER_WITHHOLDER (explicit alternate
 * fixture) imports one simulated provider-reported deduction and compares it with the expected amount; the same
 * deduction is recorded once under the provider actor and never again as a platform deduction. Neither states
 * that Xendit actually withholds in TEST.
 */
final class DemoWithholdingEvidenceAdapter implements WithholdingEvidenceAdapter
{
    /** Overrides the simulated provider report to exercise a reconciliation exception. */
    public ?int $providerReportOverride = null;

    public function deduction(string $scenario, int $expectedWithheldCentavos): array
    {
        if ($scenario === 'DEMO_PROVIDER_WITHHOLDER') {
            $reported = $this->providerReportOverride ?? $expectedWithheldCentavos;

            return ['state' => 'SIMULATED_WITHHELD', 'actor' => 'DEMO_PROVIDER_WITHHOLDER', 'reported_withheld_centavos' => $reported,
                'reconciliation_state' => $reported === $expectedWithheldCentavos ? 'RECONCILED' : 'RECONCILIATION_EXCEPTION'];
        }

        return ['state' => 'SIMULATED_WITHHELD', 'actor' => 'DEMO_PLATFORM_WITHHOLDER', 'reported_withheld_centavos' => null, 'reconciliation_state' => 'PENDING'];
    }
}
