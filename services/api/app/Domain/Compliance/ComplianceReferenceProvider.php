<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Official-source comparison for a PS License No. or ICC sticker serial. Only
 * MATCHED may lead to automatic verification. Any other result is never treated
 * as a counterfeit finding; the Vendor corrects the number or asks for review.
 */
interface ComplianceReferenceProvider
{
    /** Looks up one typed or extracted marking number in the active register for its marking type. */
    public function lookup(string $markingType, string $number, ProductRelevance $relevance): ReferenceMatch;

    /**
     * The first OCR/QR reading that exists in the active register, preferring one
     * that also covers the product.
     *
     * @param  list<string>  $candidates
     */
    public function firstListed(string $markingType, array $candidates, ProductRelevance $relevance): ?string;
}
