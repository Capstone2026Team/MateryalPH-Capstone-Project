<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\ProviderBudget;
use App\Domain\Geography\RouteProvider;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;

/** Routes API computeRoutes adapter: one driving route, no alternatives, minimum field mask. */
final class GoogleRoutesProvider implements RouteProvider
{
    public const FIELD_MASK = 'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline';

    public function __construct(private readonly ProviderBudget $budget) {}

    public function configured(): bool
    {
        $key = config('services.google_maps.server_api_key');

        return is_string($key) && trim($key) !== '';
    }

    public function drive(float $originLatitude, float $originLongitude, float $destinationLatitude, float $destinationLongitude): ?array
    {
        if (! $this->configured()) {
            throw new GeographyProviderUnavailable('NOT_CONFIGURED');
        }
        $this->budget->consume('routes');
        $preference = config('services.google_maps.routes.routing_preference') === 'TRAFFIC_UNAWARE' ? 'TRAFFIC_UNAWARE' : 'TRAFFIC_AWARE';
        try {
            $response = Http::withHeaders(['X-Goog-Api-Key' => (string) config('services.google_maps.server_api_key'), 'X-Goog-FieldMask' => self::FIELD_MASK])
                ->acceptJson()->asJson()->connectTimeout(3)->timeout((int) config('services.google_maps.timeout_seconds', 5))
                ->post('https://routes.googleapis.com/directions/v2:computeRoutes', [
                    'origin' => ['location' => ['latLng' => ['latitude' => $originLatitude, 'longitude' => $originLongitude]]],
                    'destination' => ['location' => ['latLng' => ['latitude' => $destinationLatitude, 'longitude' => $destinationLongitude]]],
                    'travelMode' => 'DRIVE',
                    'routingPreference' => $preference,
                    'computeAlternativeRoutes' => false,
                    'units' => 'METRIC',
                    'languageCode' => 'en',
                    'regionCode' => 'PH',
                ]);
        } catch (ConnectionException) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        if ($response->status() === 429) {
            throw new GeographyProviderUnavailable('QUOTA');
        }
        if ($response->failed()) {
            throw new GeographyProviderUnavailable('ERROR');
        }
        $route = $response->json('routes.0');
        if (! is_array($route)) {
            return null;
        }
        $distance = $route['distanceMeters'] ?? null;
        $duration = is_string($route['duration'] ?? null) && preg_match('/^(\d{1,7})(?:\.\d+)?s$/D', $route['duration'], $match) === 1 ? (int) $match[1] : null;
        $polyline = $route['polyline']['encodedPolyline'] ?? null;
        if (! is_int($distance) || $distance < 0 || $duration === null || ! is_string($polyline) || $polyline === '' || strlen($polyline) > 200000) {
            throw new GeographyProviderUnavailable('ERROR');
        }

        return ['distance_meters' => $distance, 'duration_seconds' => $duration, 'encoded_polyline' => $polyline, 'duration_basis' => $preference];
    }
}
