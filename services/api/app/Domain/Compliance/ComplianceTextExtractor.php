<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * OCR assistance for a PS/ICC marking photo. Output is an editable suggestion
 * with provenance and confidence, never a verification decision.
 */
interface ComplianceTextExtractor
{
    public function provider(): string;

    /** @return array{status: string, confidence: ?float, suggestions: array<string, string>} */
    public function extract(string $path, string $contentType): array;
}
