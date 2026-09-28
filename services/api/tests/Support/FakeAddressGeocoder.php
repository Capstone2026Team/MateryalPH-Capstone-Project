<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\AddressProviderUnavailable;

final class FakeAddressGeocoder implements AddressGeocoder
{
    public bool $unavailable = false;

    /** @var array{latitude: float, longitude: float, formatted_address: string, place_id: ?string}|null */
    public ?array $forward = null;

    /** @var array{formatted_address: string, place_id: ?string, street: ?string, unit: ?string, barangay: ?string, city_municipality: ?string, province: ?string, postal_code: ?string}|null */
    public ?array $reverse = null;

    public function forward(string $address): ?array
    {
        if ($this->unavailable) {
            throw new AddressProviderUnavailable('Address lookup is temporarily unavailable.');
        }

        return $this->forward;
    }

    public function reverse(float $latitude, float $longitude): ?array
    {
        if ($this->unavailable) {
            throw new AddressProviderUnavailable('Address lookup is temporarily unavailable.');
        }

        return $this->reverse;
    }
}
