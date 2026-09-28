<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;

/**
 * The approved Buyer and Vendor radius allowlist (MAT-01). 50 km is the platform maximum for Buyer and
 * Vendor scopes; it is never reached by automatic expansion, and it does not limit Admin PSGC scope.
 */
final class RadiusPolicy
{
    public const ALLOWED_KM = [5, 10, 20, 30, 40, 50];

    public const BUYER_DEFAULT_KM = 5;

    public const VENDOR_DEFAULT_KM = 50;

    public const EXPANSION_THRESHOLD = 3;

    /**
     * Spheroidal distance of a point projected exactly N metres away can evaluate a few nanometres above N,
     * which would drop an exact-boundary Vendor at some bearings. One centimetre is below the stored
     * 7-decimal coordinate precision, keeps the boundary inclusive and still excludes points 5 cm outside.
     */
    public const BOUNDARY_TOLERANCE_METERS = 0.01;

    public static function assertAllowed(mixed $radiusKm): int
    {
        if (! is_int($radiusKm) && ! (is_string($radiusKm) && ctype_digit($radiusKm))) {
            throw self::unsupported();
        }
        $radius = (int) $radiusKm;
        if (! in_array($radius, self::ALLOWED_KM, true)) {
            throw self::unsupported();
        }

        return $radius;
    }

    /** The next larger allowed radius, or null at the platform maximum. Offered only; never applied. */
    public static function next(int $radiusKm): ?int
    {
        foreach (self::ALLOWED_KM as $candidate) {
            if ($candidate > $radiusKm) {
                return $candidate;
            }
        }

        return null;
    }

    public static function meters(int $radiusKm): int
    {
        return $radiusKm * 1000;
    }

    private static function unsupported(): AuthenticationException
    {
        return new AuthenticationException('RADIUS_UNSUPPORTED', 'Choose a radius of 5, 10, 20, 30, 40 or 50 km.', 422, ['allowed_km' => self::ALLOWED_KM]);
    }
}
