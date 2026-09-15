<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface TestConnectionProvider
{
    /** @return array{status: string, provider_status?: string, evidence_origin: string, provider_account_reference: ?string, capabilities: array<string, bool>} */
    public function connect(string $organization): array;

    /** @return array{outcome: string, status?: string, provider_status?: string, provider_account_reference?: string, capabilities?: array<string, bool>} */
    public function reconcile(string $organization): array;
}
