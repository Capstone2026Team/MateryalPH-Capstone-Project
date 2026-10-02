<?php

declare(strict_types=1);

namespace App\Domain\Payments;

final readonly class GatewayDescriptor
{
    /** @param list<string> $supportedProviderChannels provider channel codes the adapter can route */
    public function __construct(
        public string $mode,
        public string $evidenceOrigin,
        public string $environment,
        public string $paymentApiVersion,
        public string $accountContractVersion,
        public int $minimumExpirySeconds,
        public array $supportedProviderChannels,
        public bool $configured,
        public ?string $unavailableReason = null,
    ) {}
}
