<?php

declare(strict_types=1);

namespace App\Domain\Geography;

/**
 * A resolved, server-validated MAT-01 scope. RADIUS scopes carry an authoritative origin point and an
 * allowlisted radius; PSGC scopes carry a versioned area. The origin version is opaque: it identifies the
 * exact origin for stale-response checks without revealing coordinates.
 */
final readonly class GeographyScope
{
    public function __construct(
        public string $audience,
        public string $kind,
        public string $originKind,
        public ?float $latitude,
        public ?float $longitude,
        public ?int $radiusKm,
        public string $originVersion,
        public ?string $locationId = null,
        public ?string $originLabel = null,
        public ?string $psgcVersionId = null,
        public ?string $psgcCode = null,
    ) {}

    public function radiusMeters(): int
    {
        return RadiusPolicy::meters((int) $this->radiusKm);
    }

    /** The inclusive ST_DWithin distance for radius membership. */
    public function membershipMeters(): float
    {
        return $this->radiusMeters() + RadiusPolicy::BOUNDARY_TOLERANCE_METERS;
    }

    /**
     * Public scope summary; never includes the exact origin coordinates.
     *
     * @return array<string, mixed>
     */
    public function summary(): array
    {
        return array_filter([
            'audience' => $this->audience,
            'kind' => $this->kind,
            'origin_kind' => $this->originKind,
            'location_id' => $this->locationId,
            'origin_label' => $this->originLabel,
            'origin_version' => $this->originVersion,
            'radius_km' => $this->radiusKm,
            'radius_meters' => $this->radiusKm === null ? null : $this->radiusMeters(),
            'distance_basis' => $this->kind === 'RADIUS' ? 'GEODESIC_STRAIGHT_LINE' : null,
            'psgc_version_id' => $this->psgcVersionId,
            'psgc_code' => $this->psgcCode,
        ], static fn (mixed $value): bool => $value !== null);
    }
}
