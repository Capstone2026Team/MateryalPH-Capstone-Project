<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\RouteProvider;

final class FakeRouteProvider implements RouteProvider
{
    public ?string $failure = null;

    public bool $noRoute = false;

    public int $calls = 0;

    public function configured(): bool
    {
        return $this->failure !== 'NOT_CONFIGURED';
    }

    public function drive(float $originLatitude, float $originLongitude, float $destinationLatitude, float $destinationLongitude): ?array
    {
        $this->calls++;
        if ($this->failure !== null) {
            throw new GeographyProviderUnavailable($this->failure);
        }

        return $this->noRoute ? null : ['distance_meters' => 4200, 'duration_seconds' => 1080, 'encoded_polyline' => '_p~iF~ps|U_ulLnnqC_mqNvxq`@', 'duration_basis' => 'TRAFFIC_AWARE'];
    }
}
