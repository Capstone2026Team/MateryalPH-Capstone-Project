<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use Illuminate\Support\Str;

/** Deterministic normalization shared by register import and matching. */
final class RegisterNormalizer
{
    public static function number(string $value): string
    {
        return (string) preg_replace('/[^A-Z0-9]/', '', strtoupper(Str::ascii($value)));
    }

    public static function company(string $value): string
    {
        $value = strtoupper(Str::ascii($value));
        $value = str_replace('&', ' AND ', $value);
        $value = (string) preg_replace('/[^A-Z0-9 ]+/', ' ', $value);

        return trim((string) preg_replace('/\s+/', ' ', $value));
    }

    /**
     * PNS designations without their edition year, e.g. "PNS 07:2018" → "PNS07",
     * "PNS ISO 4427:2002 Amd. 01:2002" → "PNSISO4427".
     *
     * @return list<string>
     */
    public static function standards(?string $value): array
    {
        if ($value === null || trim($value) === '') {
            return [];
        }
        preg_match_all('/PNS\s*(?:ISO\s*)?\d+/i', $value, $matches);

        return array_values(array_unique(array_map(static fn (string $match): string => (string) preg_replace('/\s+/', '', strtoupper($match)), $matches[0])));
    }
}
