<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Validation\ValidationException;

final class VendorAddressResolver
{
    public function __construct(private readonly PsgcDirectory $directory, private readonly AddressGeocoder $geocoder) {}

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function resolve(string $organizationId, array $input): array
    {
        $address = $this->canonical($input);
        $query = implode(', ', array_filter([$address['unit'], $address['street'], $address['barangay'], $address['city_municipality'], $address['province'], $address['postal_code'], 'Philippines']));
        try {
            $pin = isset($input['pin_token']) ? $this->readToken($organizationId, (string) $input['pin_token'], 'pin') : null;
            if ($pin !== null && ! $this->matchesPin($pin, $address)) {
                throw ValidationException::withMessages(['address' => 'The selected locations do not match this pin. Select the pin again or resolve the updated address.']);
            }
            $location = $pin === null ? $this->geocoder->forward($query) : array_intersect_key($pin, array_flip(['latitude', 'longitude', 'formatted_address', 'place_id']));
        } catch (AddressProviderUnavailable) {
            $location = null;
        }
        if ($location === null) {
            throw ValidationException::withMessages(['address' => 'We could not locate this address. Check the detailed address and retry. No coordinates have been saved.']);
        }
        $address += $location + ['provider' => 'GOOGLE_MAPS', 'source' => 'MAP'];
        $address['provider_place_id'] = $address['place_id'];
        unset($address['place_id']);

        return ['address' => $address, 'resolution_token' => $this->token($organizationId, 'address', $address)];
    }

    /** @return array<string, mixed> */
    public function pin(string $organizationId, float $latitude, float $longitude): array
    {
        try {
            $result = $this->geocoder->reverse($latitude, $longitude);
        } catch (AddressProviderUnavailable) {
            $result = null;
        }
        if ($result === null) {
            throw ValidationException::withMessages(['address' => 'This pin could not be resolved to a Philippine address. Move it or retry.']);
        }
        $matched = $this->match($result);
        $address = array_merge($result, $matched, ['latitude' => $latitude, 'longitude' => $longitude]);
        $location = ['latitude' => $latitude, 'longitude' => $longitude, 'formatted_address' => $result['formatted_address'], 'place_id' => $result['place_id']] + array_intersect_key($address, array_flip(['province', 'city_municipality', 'barangay', 'city_code', 'psgc_code']));

        return ['address' => $address, 'pin_token' => $this->token($organizationId, 'pin', $location),
            'message' => 'Review the address from Google Maps and fill in any missing details.'];
    }

    /** @param array<string, mixed> $data */
    private function token(string $organizationId, string $kind, array $data): string
    {
        return Crypt::encryptString(json_encode(['organization_id' => $organizationId, 'expires_at' => now()->addMinutes(30)->timestamp, $kind => $data], JSON_THROW_ON_ERROR));
    }

    /** @return array<string, mixed> */
    private function readToken(string $organizationId, string $token, string $kind): array
    {
        try {
            $result = json_decode(Crypt::decryptString($token), true, 32, JSON_THROW_ON_ERROR);
        } catch (DecryptException|\JsonException) {
            $result = null;
        }
        if (! is_array($result) || ($result['organization_id'] ?? null) !== $organizationId || ($result['expires_at'] ?? 0) < now()->timestamp || ! is_array($result[$kind] ?? null)) {
            throw ValidationException::withMessages(['address' => 'This map location has expired. Select the pin again or retry the address lookup.']);
        }

        return $result[$kind];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function validated(string $organizationId, array $input): array
    {
        if (($input['source'] ?? null) === 'MANUAL') {
            $canonical = $this->canonical($input);

            return $canonical + [
                'source' => 'MANUAL', 'provider' => null, 'provider_place_id' => null,
                'latitude' => null, 'longitude' => null,
                'formatted_address' => implode(', ', array_filter([$canonical['unit'], $canonical['street'], $canonical['barangay'], $canonical['city_municipality'], $canonical['province'], $canonical['postal_code'], 'Philippines'])),
            ];
        }
        $canonical = $this->hasCodes($input) ? $this->canonical($input) : $this->fields($input);
        try {
            $resolution = json_decode(Crypt::decryptString((string) ($input['resolution_token'] ?? '')), true, 32, JSON_THROW_ON_ERROR);
        } catch (DecryptException|\JsonException) {
            $resolution = null;
        }
        if (! is_array($resolution) || ($resolution['organization_id'] ?? null) !== $organizationId || ($resolution['expires_at'] ?? 0) < now()->timestamp
            || array_intersect_key($resolution['address'] ?? [], $canonical) !== $canonical) {
            throw ValidationException::withMessages(['address' => 'Resolve the current address on the map before saving. The previous location is missing, expired, or belongs to a different address.']);
        }

        return $resolution['address'];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    private function canonical(array $input): array
    {
        if ($this->hasCodes($input)) {
            return $this->directory->validateAddress($input) + array_intersect_key($this->fields($input), array_flip(['street', 'unit', 'postal_code']));
        }
        $fields = $this->fields($input);

        return $fields + array_intersect_key($this->match($fields), array_flip(['province_code', 'city_code', 'psgc_code', 'psgc_source']));
    }

    /** @param array<string, mixed> $input */
    private function hasCodes(array $input): bool
    {
        return isset($input['province_code']) || isset($input['city_code']) || isset($input['psgc_code']);
    }

    /** @param array<string, mixed> $input
     * @return array<string, string>
     */
    private function fields(array $input): array
    {
        $fields = [];
        foreach (['province', 'city_municipality', 'barangay', 'street', 'unit', 'postal_code'] as $field) {
            $fields[$field] = trim((string) ($input[$field] ?? ''));
        }

        return $fields;
    }

    /** @param array<string, mixed> $address
     * @return array<string, mixed>
     */
    private function match(array $address): array
    {
        try {
            $matched = $this->directory->match($address);
        } catch (ValidationException) {
            return [];
        }

        return $matched + (isset($matched['city_code']) ? ['psgc_source' => 'PSGC_CLOUD_V2'] : []);
    }

    /** @param array<string, mixed> $pin
     * @param  array<string, mixed>  $address
     */
    private function matchesPin(array $pin, array $address): bool
    {
        foreach (['city_code', 'psgc_code', 'province', 'city_municipality', 'barangay'] as $field) {
            if (! empty($pin[$field]) && ! empty($address[$field]) && mb_strtolower((string) $pin[$field]) !== mb_strtolower((string) $address[$field])) {
                return false;
            }
        }

        return true;
    }
}
