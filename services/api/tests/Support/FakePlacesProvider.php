<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PlacesProvider;

/** Deterministic Places adapter: returns configured places, or fails with a configured provider reason. */
final class FakePlacesProvider implements PlacesProvider
{
    /** @var list<array{place_id: string, name: string, latitude: float, longitude: float, formatted_address: ?string, primary_type: ?string, business_status: ?string, google_rating?: ?float, google_rating_count?: ?int, cell_keys?: list<string>}> */
    public array $places = [];

    /** @var array<string, array<string, mixed>> */
    public array $details = [];

    public ?string $failure = null;

    public int $nearbyCalls = 0;

    public int $detailCalls = 0;

    public array $suggestions = [];

    public ?array $located = null;

    public function autocomplete(string $query, string $sessionToken): array
    {
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return $this->suggestions;
    }

    public function locate(string $placeId, string $sessionToken): ?array
    {
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return $this->located;
    }

    public function configured(): bool
    {
        return $this->failure !== 'NOT_CONFIGURED';
    }

    public function nearby(array $cells): array
    {
        $this->nearbyCalls++;
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return array_map(fn (array $place): array => $place + ['cell_keys' => array_values(array_filter(array_column($cells, 'key')))], $this->places);
    }

    public int $textCalls = 0;

    public function searchText(array $cells): array
    {
        $this->textCalls++;
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return array_map(fn (array $place): array => $place + ['cell_keys' => array_column($cells, 'key')], $this->places);
    }

    public function details(string $placeId): ?array
    {
        $this->detailCalls++;
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return $this->details[$placeId] ?? null;
    }

    public function thumbnail(string $placeId): array
    {
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return ['photos' => array_slice($this->details[$placeId]['photos'] ?? [], 0, 1),
            'provider_attributions' => $this->details[$placeId]['provider_attributions'] ?? []];
    }
}
