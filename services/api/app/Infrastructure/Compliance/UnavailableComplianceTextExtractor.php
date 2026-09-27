<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Compliance\ComplianceTextExtractor;

/**
 * Default adapter while no OCR engine is configured. The Vendor enters the
 * marking values on Review and Confirm and the submission goes to Admin review.
 */
final class UnavailableComplianceTextExtractor implements ComplianceTextExtractor
{
    public function provider(): string
    {
        return 'NONE';
    }

    public function extract(string $path, string $contentType): array
    {
        return ['status' => 'UNAVAILABLE', 'confidence' => null, 'suggestions' => []];
    }
}
