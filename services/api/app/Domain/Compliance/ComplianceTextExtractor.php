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

    public function available(): bool;

    /**
     * Candidates are look-alike readings of the marking number for the register
     * lookup to confirm; they are never shown as facts.
     *
     * @param  ?string  $markingType  PS_MARK or ICC_STICKER when the Vendor already chose it.
     * @return array{status: string, confidence: ?float, suggestions: array<string, string>, candidates: list<string>}
     */
    public function extract(string $path, string $contentType, ?string $markingType = null): array;
}
