<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

final class SimulatedXenditConnection implements TestConnectionProvider
{
    public function connect(string $organization): array
    {
        $ready = config('vendor_onboarding.simulated_connection') && ! config('finance.live_commerce_enabled') && in_array(config('finance.mode'), ['TEST', 'DEMO'], true);

        return ['status' => $ready ? 'TEST_SIMULATED_READY' : 'NOT_CONNECTED', 'evidence_origin' => 'SIMULATED', 'provider_account_reference' => null, 'capabilities' => ['simulated_onboarding' => (bool) $ready, 'live_payments' => false, 'provider_verified' => false]];
    }

    public function reconcile(string $organization): array
    {
        return ['outcome' => 'NOT_APPLICABLE'];
    }
}
