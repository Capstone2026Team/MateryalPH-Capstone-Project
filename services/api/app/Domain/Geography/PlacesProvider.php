<?php

declare(strict_types=1);

namespace App\Domain\Geography;

/** Google Places API (New) boundary for Tier 1 Directory Suppliers. Adapters request minimum field masks. */
interface PlacesProvider
{
    public function configured(): bool;

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
     * @return array{place_id: string, name: string, formatted_address: ?string, latitude: ?float, longitude: ?float, national_phone: ?string, website_uri: ?string, google_maps_uri: ?string, weekday_descriptions: list<string>, rating: ?float, user_rating_count: ?int, business_status: ?string}|null
     *
     * @throws GeographyProviderUnavailable
     */
    public function details(string $placeId): ?array;
}
