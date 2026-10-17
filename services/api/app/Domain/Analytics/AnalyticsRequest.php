<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Geography\GeographyScope;

/**
 * One server-validated analytics query: the authenticated audience, its resolved geography scope, the requesting
 * Vendor organization (excluded from every competitor aggregate), the active dataset, the date window and the
 * allowlisted filters. Built only by the controller from the session; never from a client role flag.
 */
final readonly class AnalyticsRequest
{
    /**
     * @param  array{environment: string, dataset_id: string, label: string, kind: string}  $dataset
     * @param  array{category_id?: string, q?: string}  $filters
     */
    public function __construct(
        public string $audience,
        public GeographyScope $scope,
        public ?string $ownOrganizationId,
        public array $dataset,
        public AnalyticsWindow $window,
        public array $filters = [],
    ) {}

    /** Buyer and Admin may see a one-Vendor average; a Vendor needs three competing Vendors for any point. */
    public function minimumDisplayVendors(): int
    {
        return $this->audience === 'VENDOR' ? 3 : 1;
    }

    /** A trend needs two Vendors at each endpoint for Buyer/Admin and three competitors for a Vendor. */
    public function minimumTrendVendors(): int
    {
        return $this->audience === 'VENDOR' ? 3 : 2;
    }

    public function cacheKey(string $part): string
    {
        return implode(':', ['mat', $part, $this->dataset['environment'], $this->dataset['dataset_id'], AnalyticsDataset::generation(), AnalyticsDataset::ALGORITHM_VERSION,
            $this->audience, $this->ownOrganizationId ?? '-', $this->scope->originVersion, $this->scope->radiusKm ?? 'psgc', $this->window->cacheKey(),
            hash('sha256', json_encode($this->filters, JSON_THROW_ON_ERROR))]);
    }
}
