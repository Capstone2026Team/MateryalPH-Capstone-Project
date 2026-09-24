<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\AddressProviderUnavailable;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;

final class ConfiguredGoogleMapsGeocoder implements AddressGeocoder
{
    public function forward(string $address): ?array
    {
        $key = config('services.google_maps.server_api_key');
        if (! is_string($key) || trim($key) === '') {
            return null;
        }
        try {
            $response = Http::acceptJson()->timeout((int) config('services.google_maps.timeout_seconds', 5))
                ->get('https://maps.googleapis.com/maps/api/geocode/json', ['address' => $address, 'components' => 'country:PH', 'key' => $key]);
        } catch (ConnectionException) {
            throw new AddressProviderUnavailable('Address lookup is temporarily unavailable.');
        }
        if ($response->failed() || $response->json('status') !== 'OK') {
            return null;
        }
        $result = $response->json('results.0');
        if (! is_array($result) || ($result['partial_match'] ?? false)) {
            return null;
        }
        $location = $result['geometry']['location'] ?? [];
        if (! is_numeric($location['lat'] ?? null) || ! is_numeric($location['lng'] ?? null)) {
            return null;
        }

        return ['latitude' => (float) $location['lat'], 'longitude' => (float) $location['lng'],
            'formatted_address' => (string) ($result['formatted_address'] ?? $address), 'place_id' => $result['place_id'] ?? null];
    }

    public function reverse(float $latitude, float $longitude): ?array
    {
        $key = config('services.google_maps.server_api_key');
        if (! is_string($key) || trim($key) === '') {
            return null;
        }

        try {
            $response = Http::acceptJson()
                ->timeout((int) config('services.google_maps.timeout_seconds', 5))
                ->get('https://maps.googleapis.com/maps/api/geocode/json', [
                    'latlng' => $latitude.','.$longitude,
                    'key' => $key,
                ]);
        } catch (ConnectionException) {
            throw new AddressProviderUnavailable('Address lookup is temporarily unavailable.');
        }
        if ($response->failed()) {
            throw new AddressProviderUnavailable('The address provider is unavailable.');
        }

        $payload = $response->json();
        $result = is_array($payload['results'] ?? null) ? ($payload['results'][0] ?? null) : null;
        if (! is_array($result) || ! is_string($result['formatted_address'] ?? null)) {
            return null;
        }

        $components = [];
        $countryCode = null;
        foreach (is_array($result['address_components'] ?? null) ? $result['address_components'] : [] as $component) {
            if (! is_array($component) || ! is_array($component['types'] ?? null) || ! is_string($component['long_name'] ?? null)) {
                continue;
            }
            if (in_array('country', $component['types'], true)) {
                $countryCode = $component['short_name'] ?? null;
            }
            foreach ($component['types'] as $type) {
                if (is_string($type)) {
                    $components[$type] = $component['long_name'];
                }
            }
        }

        if ($countryCode !== 'PH') {
            return null;
        }

        return [
            'formatted_address' => $result['formatted_address'],
            'place_id' => is_string($result['place_id'] ?? null) ? $result['place_id'] : null,
            'street' => trim(implode(' ', array_filter([$components['street_number'] ?? null, $components['route'] ?? null]))) ?: null,
            'unit' => $components['subpremise'] ?? null,
            'barangay' => $components['sublocality_level_1'] ?? $components['sublocality'] ?? null,
            'city_municipality' => $components['locality'] ?? $components['administrative_area_level_2'] ?? null,
            'province' => $components['administrative_area_level_2'] ?? $components['administrative_area_level_1'] ?? null,
            'postal_code' => $components['postal_code'] ?? null,
        ];
    }
}
