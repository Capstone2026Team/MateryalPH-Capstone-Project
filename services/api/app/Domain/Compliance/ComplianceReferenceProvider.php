<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Official-source comparison for a declared PS licence or ICC certificate.
 * Only MATCHED may lead to automatic verification; every other result routes
 * the submission to Admin review and is never treated as a counterfeit finding.
 */
interface ComplianceReferenceProvider
{
    /**
     * @param  array{marking_type: string, certificate_number: string, manufacturer_name: ?string, importer_name: ?string}  $declared
     * @param  list<string>  $standards  PNS designations of the applicable regulated-material rule.
     */
    public function match(array $declared, array $standards): ReferenceMatch;
}
