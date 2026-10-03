<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/** Authoritative provider view of one refund, reduced to the fields MateryalPH verifies and stores. */
final readonly class ProviderRefund
{
    public function __construct(
        public string $providerRefundId,
        public string $referenceId,
        public ?string $paymentRequestId,
        public string $status,
        public ?int $amountCentavos,
        public string $currency,
        public ?string $failureCode = null,
    ) {}

    public function succeeded(): bool
    {
        return in_array($this->status, ['SUCCEEDED', 'COMPLETED'], true);
    }

    public function failed(): bool
    {
        return in_array($this->status, ['FAILED', 'CANCELLED'], true);
    }
}
