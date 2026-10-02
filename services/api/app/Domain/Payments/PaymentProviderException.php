<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use RuntimeException;

/**
 * A provider call that did not produce verified evidence. REJECTED means the provider definitively refused it
 * (nothing was created); UNCERTAIN means the outcome is unknown and must be reconciled before any retry;
 * UNAVAILABLE means the adapter is not configured or the provider could not be reached for a read.
 */
final class PaymentProviderException extends RuntimeException
{
    public const REJECTED = 'REJECTED';

    public const UNCERTAIN = 'UNCERTAIN';

    public const UNAVAILABLE = 'UNAVAILABLE';

    public function __construct(
        public readonly string $kind,
        public readonly string $safeCode,
        public readonly ?int $httpStatus = null,
        public readonly ?string $providerRequestId = null,
    ) {
        parent::__construct('Payment provider call '.$kind.': '.$safeCode);
    }
}
