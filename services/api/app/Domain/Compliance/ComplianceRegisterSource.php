<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Where a DTI-BPS register snapshot can be fetched automatically. Only a source
 * the platform is authorized to read may be configured: the official sheets
 * disable download for viewers, so none is configured by default and Product
 * Compliance Staff import the monthly snapshot instead.
 */
interface ComplianceRegisterSource
{
    public function configured(string $kind): bool;

    /**
     * Downloads the current snapshot to a temporary file the caller deletes.
     *
     * @return array{path: string, extension: string, source_reference: string}
     */
    public function fetch(string $kind): array;
}
