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
            if ($pin !== null && (($pin['city_code'] ?? null) !== $address['city_code'] || (isset($pin['psgc_code']) && $pin['psgc_code'] !== $address['psgc_code']))) {
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
        $matched = $this->directory->match($result);
        $address = array_merge($result, $matched, ['latitude' => $latitude, 'longitude' => $longitude]);
        $location = ['latitude' => $latitude, 'longitude' => $longitude, 'formatted_address' => $result['formatted_address'], 'place_id' => $result['place_id']] + array_intersect_key($matched, array_flip(['city_code', 'psgc_code']));

        return ['address' => $address, 'pin_token' => isset($matched['city_code']) ? $this->token($organizationId, 'pin', $location) : null,
            'message' => isset($matched['psgc_code']) ? 'Pin located. Review the matched address before saving.' : 'Pin located. Select any unmatched PSGC locations and complete the detailed address before saving.'];
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
        $canonical = $this->canonical($input);
        if (($input['source'] ?? null) === 'MANUAL') {
            return $canonical + [
                'source' => 'MANUAL', 'provider' => null, 'provider_place_id' => null,
                'latitude' => null, 'longitude' => null,
                'formatted_address' => implode(', ', array_filter([$canonical['unit'], $canonical['street'], $canonical['barangay'], $canonical['city_municipality'], $canonical['province'], $canonical['postal_code'], 'Philippines'])),
            ];
        }
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
        return $this->directory->validateAddress($input) + [
            'street' => trim((string) ($input['street'] ?? '')),
            'unit' => trim((string) ($input['unit'] ?? '')),
            'postal_code' => trim((string) ($input['postal_code'] ?? '')),
        ];
    }
}
