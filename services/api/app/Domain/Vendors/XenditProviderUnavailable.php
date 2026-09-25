<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use RuntimeException;

final class XenditProviderUnavailable extends RuntimeException
{
    public function __construct(string $message = 'The TEST provider is unavailable.', public readonly bool $creationRejected = false, public readonly ?int $providerHttpStatus = null, public readonly ?string $providerErrorCode = null, public readonly ?string $providerRequestId = null)
    {
        parent::__construct($message);
    }
}
