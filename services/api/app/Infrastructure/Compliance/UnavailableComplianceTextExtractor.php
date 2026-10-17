<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Compliance\ComplianceTextExtractor;

/**
 * Default adapter while no OCR engine is configured. The Vendor enters the
 * marking number on Review and Confirm and the register lookup still runs.
 */
final class UnavailableComplianceTextExtractor implements ComplianceTextExtractor
{
    public function provider(): string
    {
        return 'NONE';
    }

    public function available(): bool
    {
        return false;
    }

    public function extract(string $path, string $contentType, ?string $markingType = null): array
    {
        return ['status' => 'UNAVAILABLE', 'confidence' => null, 'suggestions' => [], 'candidates' => []];
    }
}
