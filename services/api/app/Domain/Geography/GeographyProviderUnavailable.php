<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use RuntimeException;

/** A maps provider could not answer: NOT_CONFIGURED, TIMEOUT, QUOTA or ERROR. Never carries provider payloads. */
final class GeographyProviderUnavailable extends RuntimeException
{
    public function __construct(public readonly string $reason)
    {
        parent::__construct('The maps provider is unavailable ('.$reason.').');
    }
}
