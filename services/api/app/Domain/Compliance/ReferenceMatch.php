<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

final readonly class ReferenceMatch
{
    public const MATCHED = 'MATCHED';

    public const UNMATCHED = 'UNMATCHED';

    public const UNCERTAIN = 'UNCERTAIN';

    public const UNAVAILABLE = 'UNAVAILABLE';

    /** @param array<string, mixed> $details */
    public function __construct(
        public string $result,
        public string $provider,
        public ?string $sourceReference,
        public ?string $registerId,
        public array $details = [],
    ) {}
}
