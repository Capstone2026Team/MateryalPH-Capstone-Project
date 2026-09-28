<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;

/** Coarse Philippine envelope used to reject non-local or malformed points before any provider call. */
final class PhilippineBounds
{
    public const MIN_LATITUDE = 4.0;

    public const MAX_LATITUDE = 21.5;

    public const MIN_LONGITUDE = 116.0;

    public const MAX_LONGITUDE = 127.0;

    public static function contains(float $latitude, float $longitude): bool
    {
        return is_finite($latitude) && is_finite($longitude)
            && $latitude >= self::MIN_LATITUDE && $latitude <= self::MAX_LATITUDE
            && $longitude >= self::MIN_LONGITUDE && $longitude <= self::MAX_LONGITUDE;
    }

    /** @return array{0: float, 1: float} */
    public static function assert(mixed $latitude, mixed $longitude): array
    {
        if (! is_numeric($latitude) || ! is_numeric($longitude) || ! self::contains((float) $latitude, (float) $longitude)) {
            throw new AuthenticationException('LOCATION_OUTSIDE_PHILIPPINES', 'Choose a location inside the Philippines.', 422);
        }

        return [(float) $latitude, (float) $longitude];
    }
}
