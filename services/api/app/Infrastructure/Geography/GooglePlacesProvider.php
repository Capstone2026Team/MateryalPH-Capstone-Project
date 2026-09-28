<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\ProviderBudget;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Http\Client\Pool;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;

/**
 * Places API (New) adapter using the restricted backend server key. Requests only the fields each screen
 * needs: the search mask supports markers and list rows; the details mask supports the Tier 1 sheet.
 */
final class GooglePlacesProvider implements PlacesProvider
{
    public const SEARCH_FIELD_MASK = 'places.id,places.displayName,places.location,places.formattedAddress,places.primaryType,places.businessStatus';

    public const DETAILS_FIELD_MASK = 'id,displayName,formattedAddress,location,nationalPhoneNumber,websiteUri,googleMapsUri,regularOpeningHours.weekdayDescriptions,rating,userRatingCount,businessStatus';

    private const SEARCH_URL = 'https://places.googleapis.com/v1/places:searchNearby';

    public function __construct(private readonly ProviderBudget $budget) {}

    public function configured(): bool
    {
        $key = config('services.google_maps.server_api_key');

        return (bool) config('services.google_maps.places.enabled', true) && is_string($key) && trim($key) !== '';
    }

    public function nearby(array $cells): array
    {
        if (! $this->configured()) {
            throw new GeographyProviderUnavailable('NOT_CONFIGURED');
        }
        if ($cells === []) {
            return [];
        }
        $this->budget->consume('places', count($cells));
        $types = array_values(array_filter((array) config('services.google_maps.places.included_types', []), static fn (mixed $type): bool => is_string($type) && preg_match('/^[a-z_]{3,64}$/D', $type) === 1));
        $responses = Http::pool(fn (Pool $pool): array => array_map(fn (array $cell): mixed => $this->request($pool)->post(self::SEARCH_URL, [
            'includedTypes' => $types,
            'maxResultCount' => 20,
            // Prominence spreads each cell's 20 results across the cell instead of the 20 nearest its centre.
            // Buyer-facing order is still straight-line distance, applied by SupplierDiscoveryService.
            'rankPreference' => 'POPULARITY',
            'regionCode' => 'PH',
            'languageCode' => 'en',
            'locationRestriction' => ['circle' => ['center' => ['latitude' => $cell['latitude'], 'longitude' => $cell['longitude']], 'radius' => (float) min(50000, $cell['radius_meters'])]],
        ]), $cells));
        $places = [];
        foreach ($responses as $response) {
            foreach ($this->checked($response)->json('places') ?? [] as $place) {
                $parsed = is_array($place) ? $this->summary($place) : null;
                if ($parsed !== null) {
                    $places[$parsed['place_id']] = $parsed;
                }
            }
        }

        return array_values($places);
    }

    public function details(string $placeId): ?array
    {
        if (! $this->configured()) {
            throw new GeographyProviderUnavailable('NOT_CONFIGURED');
        }
        if (preg_match('/^[A-Za-z0-9_-]{10,300}$/D', $placeId) !== 1) {
            return null;
        }
        $this->budget->consume('places');
        try {
            $response = $this->client(self::DETAILS_FIELD_MASK)->get('https://places.googleapis.com/v1/places/'.$placeId, ['languageCode' => 'en', 'regionCode' => 'PH']);
        } catch (ConnectionException) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        if ($response->status() === 404) {
            return null;
        }
        $place = $this->checked($response)->json();
        $summary = is_array($place) ? $this->summary($place) : null;
        if ($summary === null) {
            return null;
        }
        $hours = $place['regularOpeningHours']['weekdayDescriptions'] ?? [];

        return [
            'place_id' => $summary['place_id'], 'name' => $summary['name'], 'formatted_address' => $summary['formatted_address'],
            'latitude' => $summary['latitude'], 'longitude' => $summary['longitude'],
            'national_phone' => $this->text($place['nationalPhoneNumber'] ?? null, 40),
            'website_uri' => $this->uri($place['websiteUri'] ?? null),
            'google_maps_uri' => $this->uri($place['googleMapsUri'] ?? null),
            'weekday_descriptions' => array_values(array_filter(array_map(fn (mixed $line): ?string => $this->text($line, 120), is_array($hours) ? array_slice($hours, 0, 7) : []))),
            'rating' => is_numeric($place['rating'] ?? null) && $place['rating'] >= 1 && $place['rating'] <= 5 ? round((float) $place['rating'], 1) : null,
            'user_rating_count' => is_int($place['userRatingCount'] ?? null) && $place['userRatingCount'] >= 0 ? $place['userRatingCount'] : null,
            'business_status' => $summary['business_status'],
        ];
    }

    private function request(Pool $pool): mixed
    {
        return $pool->withHeaders($this->headers(self::SEARCH_FIELD_MASK))->acceptJson()->asJson()
            ->connectTimeout(3)->timeout((int) config('services.google_maps.timeout_seconds', 5));
    }

    private function client(string $fieldMask): PendingRequest
    {
        return Http::withHeaders($this->headers($fieldMask))->acceptJson()->connectTimeout(3)->timeout((int) config('services.google_maps.timeout_seconds', 5));
    }

    /** @return array<string, string> */
    private function headers(string $fieldMask): array
    {
        return ['X-Goog-Api-Key' => (string) config('services.google_maps.server_api_key'), 'X-Goog-FieldMask' => $fieldMask];
    }

    private function checked(mixed $response): Response
    {
        if ($response instanceof ConnectionException || ! $response instanceof Response) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        if ($response->status() === 429) {
            throw new GeographyProviderUnavailable('QUOTA');
        }
        if ($response->failed()) {
            throw new GeographyProviderUnavailable('ERROR');
        }

        return $response;
    }

    /**
     * @param  array<string, mixed>  $place
     * @return array{place_id: string, name: string, latitude: float, longitude: float, formatted_address: ?string, primary_type: ?string, business_status: ?string}|null
     */
    private function summary(array $place): ?array
    {
        $id = $place['id'] ?? null;
        $name = $this->text($place['displayName']['text'] ?? null, 200);
        $latitude = $place['location']['latitude'] ?? null;
        $longitude = $place['location']['longitude'] ?? null;
        $status = is_string($place['businessStatus'] ?? null) ? $place['businessStatus'] : null;
        if (! is_string($id) || preg_match('/^[A-Za-z0-9_-]{10,300}$/D', $id) !== 1 || $name === null || ! is_numeric($latitude) || ! is_numeric($longitude)
            || in_array($status, ['CLOSED_PERMANENTLY', 'CLOSED_TEMPORARILY'], true)) {
            return null;
        }

        return ['place_id' => $id, 'name' => $name, 'latitude' => (float) $latitude, 'longitude' => (float) $longitude,
            'formatted_address' => $this->text($place['formattedAddress'] ?? null, 300), 'primary_type' => $this->text($place['primaryType'] ?? null, 64), 'business_status' => $status];
    }

    private function text(mixed $value, int $max): ?string
    {
        return is_string($value) && trim($value) !== '' ? mb_substr(trim(strip_tags($value)), 0, $max) : null;
    }

    private function uri(mixed $value): ?string
    {
        return is_string($value) && strlen($value) <= 2048 && preg_match('~^https://~i', $value) === 1 && filter_var($value, FILTER_VALIDATE_URL) !== false ? $value : null;
    }
}
