<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/** Authoritative provider state of one payment session, normalized to integer centavos. */
final readonly class ProviderSession
{
    public function __construct(
        public string $sessionId,
        public string $referenceId,
        public string $status,
        public ?int $amountCentavos,
        public string $currency,
        public ?string $paymentId,
        public ?string $paymentRequestId,
        public ?string $businessId,
        public ?string $channelCode = null,
    ) {}

    public function completed(): bool
    {
        return $this->status === 'COMPLETED' && $this->paymentId !== null;
    }

    public function closedWithoutPayment(): bool
    {
        return in_array($this->status, ['EXPIRED', 'CANCELED'], true);
    }
}
