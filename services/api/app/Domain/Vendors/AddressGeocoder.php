<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface AddressGeocoder
{
    /** @return array{formatted_address: string, place_id: ?string, street: ?string, unit: ?string, barangay: ?string, city_municipality: ?string, province: ?string, postal_code: ?string}|null */
    public function reverse(float $latitude, float $longitude): ?array;
}
