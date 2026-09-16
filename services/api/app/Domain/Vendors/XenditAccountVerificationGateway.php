<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface XenditAccountVerificationGateway
{
    /** @return array{provider_account_id: string, status: string, capabilities: array<string, mixed>} */
    public function reconcile(string $providerAccountId): array;
}
