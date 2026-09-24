<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface AddressGeocoder
{
    /** @return array{latitude: float, longitude: float, formatted_address: string, place_id: ?string}|null */
    public function forward(string $address): ?array;

    /** @return array{formatted_address: string, place_id: ?string, street: ?string, unit: ?string, barangay: ?string, city_municipality: ?string, province: ?string, postal_code: ?string}|null */
    public function reverse(float $latitude, float $longitude): ?array;
}
