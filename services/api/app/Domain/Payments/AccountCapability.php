<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/** Provider evidence that an associated account may receive TEST payments. Raw LIVE in TEST stays TEST. */
final readonly class AccountCapability
{
    public function __construct(
        public string $providerAccountId,
        public string $rawStatus,
        public string $environment,
        public bool $canAcceptPayments,
        public ?string $reason = null,
    ) {}
}
