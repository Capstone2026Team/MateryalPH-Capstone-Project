<?php

declare(strict_types=1);

namespace App\Domain\Payments;

final readonly class SessionResult
{
    public function __construct(
        public string $sessionId,
        public string $status,
        public ?string $checkoutUrl,
        public ?string $expiresAt,
        public ?string $businessId,
        public ?string $providerRequestId = null,
    ) {}
}
