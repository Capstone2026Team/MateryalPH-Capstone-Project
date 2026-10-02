<?php

declare(strict_types=1);

namespace App\Domain\Payments;

final readonly class RefundRequest
{
    public function __construct(
        public string $referenceId,
        public string $paymentRequestId,
        public int $amountCentavos,
        public string $currency,
        public ?string $forUserId,
        public string $reason,
    ) {}
}
