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

    public const DETAILS_FIELD_MASK = 'id,displayName,formattedAddress,location,primaryType,nationalPhoneNumber,websiteUri,googleMapsUri,regularOpeningHours.weekdayDescriptions,currentOpeningHours.openNow,currentOpeningHours.nextCloseTime,rating,userRatingCount,businessStatus,photos,reviews,attributions,delivery,curbsidePickup,accessibilityOptions,paymentOptions';

    private const SEARCH_URL = 'https://places.googleapis.com/v1/places:searchNearby';

    public function __construct(private readonly ProviderBudget $budget) {}

    public function configured(): bool
    {
        $key = config('services.google_maps.server_api_key');

        return (bool) config('services.google_maps.places.enabled', true) && is_string($key) && trim($key) !== '';
    }

    public function autocomplete(string $query, string $sessionToken): array
    {
        $this->assertConfigured();
        $this->budget->consume('places');
        try {
            $response = $this->client('suggestions.placePrediction.placeId,suggestions.placePrediction.structuredFormat')->post('https://places.googleapis.com/v1/places:autocomplete', [
                'input' => $query, 'sessionToken' => $sessionToken, 'includedRegionCodes' => ['ph'], 'languageCode' => 'en',
            ]);
        } catch (ConnectionException) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        $items = [];
        foreach (array_slice($this->checked($response)->json('suggestions') ?? [], 0, 5) as $suggestion) {
            $place = $suggestion['placePrediction'] ?? [];
            $id = $place['placeId'] ?? null;
            $title = $this->text($place['structuredFormat']['mainText']['text'] ?? null, 200);
            if (is_string($id) && preg_match('/^[A-Za-z0-9_-]{10,300}$/D', $id) === 1 && $title !== null) {
                $items[] = ['place_id' => $id, 'title' => $title, 'subtitle' => $this->text($place['structuredFormat']['secondaryText']['text'] ?? null, 300)];
            }
        }

        return $items;
    }

    public function locate(string $placeId, string $sessionToken): ?array
    {
        $this->assertConfigured();
        if (preg_match('/^[A-Za-z0-9_-]{10,300}$/D', $placeId) !== 1) {
            return null;
        }
        $this->budget->consume('places');
        try {
            $response = $this->client('location,formattedAddress')->get('https://places.googleapis.com/v1/places/'.$placeId, ['sessionToken' => $sessionToken, 'languageCode' => 'en']);
        } catch (ConnectionException) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        if ($response->status() === 404) {
            return null;
        }
        $place = $this->checked($response)->json();
        $address = $this->text($place['formattedAddress'] ?? null, 300);
        $lat = $place['location']['latitude'] ?? null;
        $lng = $place['location']['longitude'] ?? null;

        return $address !== null && is_numeric($lat) && is_numeric($lng)
            ? ['latitude' => (float) $lat, 'longitude' => (float) $lng, 'formatted_address' => $address] : null;
    }

    private function assertConfigured(): void
    {
        if (! $this->configured()) {
            throw new GeographyProviderUnavailable('NOT_CONFIGURED');
        }
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
        $places = [];
        // Bound concurrency independently of the geographic cell count.
        foreach (array_chunk($cells, 16) as $batch) {
            $responses = Http::pool(fn (Pool $pool): array => array_map(fn (array $cell): mixed => $this->request($pool)->post(self::SEARCH_URL, [
                'includedTypes' => $types,
                'maxResultCount' => 20,
                // Ranking is upstream and capped; neither ranking mode guarantees complete coverage.
                'rankPreference' => 'POPULARITY',
                'regionCode' => 'PH',
                'languageCode' => 'en',
                'locationRestriction' => ['circle' => ['center' => ['latitude' => $cell['latitude'], 'longitude' => $cell['longitude']], 'radius' => (float) min(50000, $cell['radius_meters'])]],
            ]), $batch));
            foreach ($responses as $response) {
                foreach ($this->checked($response)->json('places') ?? [] as $place) {
                    $parsed = is_array($place) ? $this->summary($place) : null;
                    if ($parsed !== null) {
                        $places[$parsed['place_id']] = $parsed;
                    }
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
            'open_now' => is_bool($place['currentOpeningHours']['openNow'] ?? null) ? $place['currentOpeningHours']['openNow'] : null,
            'next_close_time' => $this->text($place['currentOpeningHours']['nextCloseTime'] ?? null, 40),
            'photos' => $this->photos($place['photos'] ?? [], $placeId),
            'reviews' => $this->reviews($place['reviews'] ?? []),
            'attributes' => $this->attributes($place),
            'provider_attributions' => $this->providerAttributions($place['attributions'] ?? []),
        ];
    }

    public function thumbnail(string $placeId): array
    {
        $this->assertConfigured();
        $empty = ['photos' => [], 'provider_attributions' => []];
        if (preg_match('/^[A-Za-z0-9_-]{10,300}$/D', $placeId) !== 1) {
            return $empty;
        }
        $this->budget->consume('places');
        try {
            $response = $this->client('photos,attributions')->get('https://places.googleapis.com/v1/places/'.$placeId, ['languageCode' => 'en', 'regionCode' => 'PH']);
        } catch (ConnectionException) {
            throw new GeographyProviderUnavailable('TIMEOUT');
        }
        if ($response->status() === 404) {
            return $empty;
        }
        $place = $this->checked($response)->json();

        return [
            'photos' => $this->photos($place['photos'] ?? [], $placeId, 1, 160),
            'provider_attributions' => $this->providerAttributions($place['attributions'] ?? []),
        ];
    }

    /**
     * Photos are resolved only for visible content. Never persist names or media URLs.
     *
     * @param  array<array-key, mixed>  $photos
     * @return list<array{uri: string, authors: list<array{name: string, uri: ?string, photo_uri: ?string}>, google_maps_uri: ?string}>
     */
    private function photos(array $photos, string $placeId, int $limit = 4, int $width = 800): array
    {
        $items = [];
        foreach (array_slice($photos, 0, $limit) as $photo) {
            $name = $photo['name'] ?? '';
            if (! is_string($name) || ! preg_match('~^places/'.preg_quote($placeId, '~').'/photos/[A-Za-z0-9_-]+$~D', $name)) {
                continue;
            }
            try {
                $this->budget->consume('places');
                $response = $this->client('')->get('https://places.googleapis.com/v1/'.$name.'/media', ['maxWidthPx' => $width, 'skipHttpRedirect' => 'true']);
                $uri = $this->uri($this->checked($response)->json('photoUri'));
                if ($uri !== null && ! str_contains(strtolower($uri), 'key=')) {
                    $items[] = ['uri' => $uri, 'authors' => $this->authors($photo['authorAttributions'] ?? []), 'google_maps_uri' => $this->uri($photo['googleMapsUri'] ?? null)];
                }
            } catch (ConnectionException|GeographyProviderUnavailable) {
                // A photo outage must not hide address, phone or other available details.
            }
        }

        return $items;
    }

    /**
     * @param  array<array-key, mixed>  $authors
     * @return list<array{name: string, uri: ?string, photo_uri: ?string}>
     */
    private function authors(array $authors): array
    {
        $items = [];
        foreach ($authors as $author) {
            $name = $this->text($author['displayName'] ?? null, 200);
            if ($name !== null) {
                $items[] = ['name' => $name, 'uri' => $this->uri($author['uri'] ?? null), 'photo_uri' => $this->uri($author['photoUri'] ?? null)];
            }
        }

        return $items;
    }

    /**
     * @param  array<array-key, mixed>  $reviews
     * @return list<array{author: array{name: string, uri: ?string, photo_uri: ?string}, rating: float, text: ?string, relative_time: ?string, google_maps_uri: ?string}>
     */
    private function reviews(array $reviews): array
    {
        $items = [];
        foreach (array_slice($reviews, 0, 5) as $review) {
            $author = $this->authors([$review['authorAttribution'] ?? []])[0] ?? null;
            $rating = $review['rating'] ?? null;
            if ($author !== null && is_numeric($rating) && $rating >= 1 && $rating <= 5) {
                $items[] = ['author' => $author, 'rating' => (float) $rating, 'text' => $this->text($review['text']['text'] ?? null, 5000),
                    'relative_time' => $this->text($review['relativePublishTimeDescription'] ?? null, 100), 'google_maps_uri' => $this->uri($review['googleMapsUri'] ?? null)];
            }
        }

        return $items;
    }

    /**
     * @param  array<string, mixed>  $place
     * @return list<array{label: string, available: bool}>
     */
    private function attributes(array $place): array
    {
        $fields = ['delivery' => 'Delivery', 'curbsidePickup' => 'Curbside pickup',
            'accessibilityOptions.wheelchairAccessibleParking' => 'Wheelchair accessible parking', 'accessibilityOptions.wheelchairAccessibleEntrance' => 'Wheelchair accessible entrance',
            'accessibilityOptions.wheelchairAccessibleRestroom' => 'Wheelchair accessible restroom', 'accessibilityOptions.wheelchairAccessibleSeating' => 'Wheelchair accessible seating',
            'paymentOptions.acceptsCreditCards' => 'Credit cards', 'paymentOptions.acceptsDebitCards' => 'Debit cards', 'paymentOptions.acceptsCashOnly' => 'Cash only', 'paymentOptions.acceptsNfc' => 'NFC payments'];
        $items = [];
        foreach ($fields as $path => $label) {
            $value = data_get($place, $path);
            if (is_bool($value)) {
                $items[] = ['label' => $label, 'available' => $value];
            }
        }

        return $items;
    }

    /**
     * @param  array<array-key, mixed>  $attributions
     * @return list<array{name: string, uri: ?string, photo_uri: ?string}>
     */
    private function providerAttributions(array $attributions): array
    {
        $items = [];
        foreach ($attributions as $attribution) {
            $name = $this->text($attribution['provider'] ?? null, 200);
            if ($name !== null) {
                $items[] = ['name' => $name, 'uri' => $this->uri($attribution['providerUri'] ?? null), 'photo_uri' => null];
            }
        }

        return $items;
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
        return array_filter(['X-Goog-Api-Key' => (string) config('services.google_maps.server_api_key'), 'X-Goog-FieldMask' => $fieldMask], static fn (string $value): bool => $value !== '');
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
