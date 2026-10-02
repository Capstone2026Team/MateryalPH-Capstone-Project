<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use Carbon\CarbonImmutable;

final readonly class SessionRequest
{
    /** @param array{reference_id: string, given_names: string, email: ?string} $customer */
    public function __construct(
        public string $referenceId,
        public int $amountCentavos,
        public string $currency,
        public string $providerChannelCode,
        public CarbonImmutable $expiresAt,
        public string $description,
        public ?string $forUserId,
        public array $customer,
        public ?string $successReturnUrl,
        public ?string $cancelReturnUrl,
    ) {}
}
