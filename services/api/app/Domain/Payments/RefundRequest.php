<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/**
 * One provider refund request. The reference is the stable refund instruction id (it maps provider events back);
 * the idempotency key is per attempt, so a timeout resend reuses it while an authorized retry after a definitive
 * failure uses the next attempt's key.
 */
final readonly class RefundRequest
{
    public string $idempotencyKey;

    public function __construct(
        public string $referenceId,
        public string $paymentRequestId,
        public int $amountCentavos,
        public string $currency,
        public ?string $forUserId,
        public string $reason,
        ?string $idempotencyKey = null,
    ) {
        $this->idempotencyKey = $idempotencyKey ?? $referenceId;
    }
}
