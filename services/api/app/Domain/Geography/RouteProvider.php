<?php

declare(strict_types=1);

namespace App\Domain\Geography;

/** Google Routes API boundary. One driving route per selected supplier; never used for radius membership. */
interface RouteProvider
{
    public function configured(): bool;

    /**
     * @return array{distance_meters: int, duration_seconds: int, encoded_polyline: string, duration_basis: string}|null null when no driving route exists
     *
     * @throws GeographyProviderUnavailable
     */
    public function drive(float $originLatitude, float $originLongitude, float $destinationLatitude, float $destinationLongitude): ?array;
}
