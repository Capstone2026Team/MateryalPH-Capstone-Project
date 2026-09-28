<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PlacesProvider;

/** Deterministic Places adapter: returns configured places, or fails with a configured provider reason. */
final class FakePlacesProvider implements PlacesProvider
{
    /** @var list<array{place_id: string, name: string, latitude: float, longitude: float, formatted_address: ?string, primary_type: ?string, business_status: ?string}> */
    public array $places = [];

    /** @var array<string, array<string, mixed>> */
    public array $details = [];

    public ?string $failure = null;

    public int $nearbyCalls = 0;

    public int $detailCalls = 0;

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

        return $this->places;
    }

    public function details(string $placeId): ?array
    {
        $this->detailCalls++;
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return $this->details[$placeId] ?? null;
    }
}
