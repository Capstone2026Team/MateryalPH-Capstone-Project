<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use Illuminate\Support\Str;

/** Name normalization and level mapping shared by the PSGC importer and resolver. */
final class PsgcNames
{
    /** PSA "Geographic Level" and psgc.cloud "type" values mapped to the stored level. */
    public const LEVELS = [
        'reg' => 'REGION', 'region' => 'REGION',
        'prov' => 'PROVINCE', 'province' => 'PROVINCE',
        'city' => 'CITY',
        'mun' => 'MUNICIPALITY', 'municipality' => 'MUNICIPALITY',
        'submun' => 'SUB_MUNICIPALITY', 'sub-municipality' => 'SUB_MUNICIPALITY',
        'sgu' => 'SPECIAL_GEOGRAPHIC_AREA',
        'bgy' => 'BARANGAY', 'barangay' => 'BARANGAY',
    ];

    /** Insert order so a parent row always exists before its children. */
    public const RANK = ['REGION' => 0, 'PROVINCE' => 1, 'OTHER' => 1, 'CITY' => 2, 'MUNICIPALITY' => 2, 'SPECIAL_GEOGRAPHIC_AREA' => 2, 'SUB_MUNICIPALITY' => 3, 'BARANGAY' => 4];

    public static function level(string $raw): string
    {
        return self::LEVELS[mb_strtolower(trim($raw))] ?? 'OTHER';
    }

    public static function normalize(string $name): string
    {
        $value = mb_strtolower(Str::ascii($name));
        $value = (string) preg_replace('/\(.*?\)/', ' ', $value);
        $value = (string) preg_replace('/\b(city of|municipality of|city|municipality|barangay|brgy)\b\.?/', ' ', $value);
        $value = (string) preg_replace('/[^a-z0-9]+/', ' ', $value);

        return trim((string) preg_replace('/\s+/', ' ', $value));
    }

    /**
     * Region names differ between PSA ("Region III (Central Luzon)") and geocoders ("Central Luzon",
     * "Metro Manila"). Returns every comparable alias for a PSGC region name.
     *
     * @return list<string>
     */
    public static function regionAliases(string $name): array
    {
        $aliases = [self::normalize($name)];
        if (preg_match('/\((.*?)\)/', $name, $match) === 1) {
            $aliases[] = self::normalize($match[1]);
        }
        $lower = mb_strtolower($name);
        if (str_contains($lower, 'national capital region') || str_contains($lower, '(ncr)')) {
            $aliases = [...$aliases, 'ncr', 'metro manila', 'national capital region', 'kalakhang maynila'];
        }

        return array_values(array_unique(array_filter($aliases)));
    }

    /** Excel exports drop leading zeros; restore the 10-digit PSGC code or return null when malformed. */
    public static function code(string $raw): ?string
    {
        $digits = trim($raw);
        if (preg_match('/^[0-9]{9,10}$/D', $digits) !== 1) {
            return null;
        }

        return str_pad($digits, 10, '0', STR_PAD_LEFT);
    }
}
