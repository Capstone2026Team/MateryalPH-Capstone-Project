<?php

declare(strict_types=1);

namespace App\Domain\Geography;

/** Google Places API (New) boundary for Tier 1 Directory Suppliers. Adapters request minimum field masks. */
interface PlacesProvider
{
    /**
     * On-demand list thumbnail, without reviews or other business details.
     *
     * @return array{photos: list<array{uri: string, authors: list<array{name: string, uri: ?string, photo_uri: ?string}>, google_maps_uri: ?string}>, provider_attributions: list<array{name: string, uri: ?string, photo_uri: ?string}>}
     */
    public function thumbnail(string $placeId): array;

    public function configured(): bool;

    /** @return list<array{place_id: string, title: string, subtitle: ?string}> */
    public function autocomplete(string $query, string $sessionToken): array;

    /** @return array{latitude: float, longitude: float, formatted_address: string}|null */
    public function locate(string $placeId, string $sessionToken): ?array;

    /**
     * Construction-relevant places inside one circle. Closed businesses and results without a usable name or
     * location are already excluded.
     *
     * @param  list<array{latitude: float, longitude: float, radius_meters: int}>  $cells
     * @return list<array{place_id: string, name: string, latitude: float, longitude: float, formatted_address: ?string, primary_type: ?string, business_status: ?string}>
     *
     * @throws GeographyProviderUnavailable
     */
    public function nearby(array $cells): array;

    /**
     * Policy-permitted Place Details for one Directory Supplier, or null when Google no longer returns it.
     *
     * @return array{place_id: string, name: string, formatted_address: ?string, latitude: ?float, longitude: ?float, national_phone: ?string, website_uri: ?string, google_maps_uri: ?string, weekday_descriptions: list<string>, rating: ?float, user_rating_count: ?int, business_status: ?string, open_now?: ?bool, next_close_time?: ?string, photos?: list<array{uri: string, authors: list<array{name: string, uri: ?string, photo_uri: ?string}>, google_maps_uri: ?string}>, reviews?: list<array{author: array{name: string, uri: ?string, photo_uri: ?string}, rating: float, text: ?string, relative_time: ?string, google_maps_uri: ?string}>, attributes?: list<array{label: string, available: bool}>, provider_attributions?: list<array{name: string, uri: ?string, photo_uri: ?string}>}|null
     *
     * @throws GeographyProviderUnavailable
     */
    public function details(string $placeId): ?array;
}
