<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\AddressProviderUnavailable;
use Illuminate\Support\Facades\Http;

final class ConfiguredGoogleMapsGeocoder implements AddressGeocoder
{
    public function reverse(float $latitude, float $longitude): ?array
    {
        $key = config('services.google_maps.server_api_key');
        if (! is_string($key) || trim($key) === '') {
            return null;
        }

        $response = Http::acceptJson()
            ->timeout((int) config('services.google_maps.timeout_seconds', 5))
            ->get('https://maps.googleapis.com/maps/api/geocode/json', [
                'latlng' => $latitude.','.$longitude,
                'key' => $key,
            ]);
        if ($response->failed()) {
            throw new AddressProviderUnavailable('The address provider is unavailable.');
        }

        $payload = $response->json();
        $result = is_array($payload['results'] ?? null) ? ($payload['results'][0] ?? null) : null;
        if (! is_array($result) || ! is_string($result['formatted_address'] ?? null)) {
            return null;
        }

        $components = [];
        foreach (is_array($result['address_components'] ?? null) ? $result['address_components'] : [] as $component) {
            if (! is_array($component) || ! is_array($component['types'] ?? null) || ! is_string($component['long_name'] ?? null)) {
                continue;
            }
            foreach ($component['types'] as $type) {
                if (is_string($type)) {
                    $components[$type] = $component['long_name'];
                }
            }
        }

        return [
            'formatted_address' => $result['formatted_address'],
            'place_id' => is_string($result['place_id'] ?? null) ? $result['place_id'] : null,
            'street' => $components['route'] ?? null,
            'unit' => $components['subpremise'] ?? null,
            'barangay' => $components['sublocality_level_1'] ?? $components['sublocality'] ?? null,
            'city_municipality' => $components['locality'] ?? $components['administrative_area_level_2'] ?? null,
            'province' => $components['administrative_area_level_1'] ?? null,
            'postal_code' => $components['postal_code'] ?? null,
        ];
    }
}
