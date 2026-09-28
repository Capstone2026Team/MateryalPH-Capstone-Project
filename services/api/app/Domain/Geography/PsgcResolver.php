<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/**
 * Best-effort PSGC resolution against the ACTIVE imported version. Coordinates stay authoritative; PSGC
 * codes only support administrative aggregation. Ambiguous or missing names are left unresolved rather than
 * guessed. RESOLVED means region, province-or-independent-city and city/municipality are known; PARTIAL
 * means only higher levels are known; UNRESOLVED stores no codes.
 */
final class PsgcResolver
{
    public const CITY_LEVELS = ['CITY', 'MUNICIPALITY', 'SPECIAL_GEOGRAPHIC_AREA'];

    /**
     * @param  array{city_municipality?: ?string, province?: ?string, region?: ?string, barangay?: ?string}  $names
     * @return array<string, mixed>
     */
    public function resolveNames(array $names): array
    {
        $version = $this->activeVersion();
        if ($version === null) {
            return $this->unresolved(null, 'NO_ACTIVE_PSGC_VERSION');
        }
        $city = $this->city($version, (string) ($names['city_municipality'] ?? ''), (string) ($names['province'] ?? ''), (string) ($names['region'] ?? ''));
        if ($city !== null) {
            return $this->fromArea($version, $city, (string) ($names['barangay'] ?? ''));
        }
        $province = $this->unique($version, ['PROVINCE'], PsgcNames::normalize((string) ($names['province'] ?? '')));
        if ($province !== null) {
            return $this->partial($version, $province);
        }
        $region = $this->region($version, (string) ($names['region'] ?? ''));

        return $region === null ? $this->unresolved($version, 'NAMES_NOT_MATCHED') : $this->partial($version, $region);
    }

    /**
     * Validates codes chosen from the PSGC area picker against the ACTIVE version.
     *
     * @return array<string, mixed>|null
     */
    public function resolveCodes(string $cityCode, ?string $barangayCode = null): ?array
    {
        $version = $this->activeVersion();
        if ($version === null) {
            return null;
        }
        $city = DB::table('psgc_areas')->where('psgc_version_id', $version)->where('code', $cityCode)->whereIn('level', self::CITY_LEVELS)->first();
        if ($city === null) {
            return null;
        }
        $result = $this->fromArea($version, $city, '');
        if ($barangayCode !== null) {
            $barangay = $this->barangays($version, (string) $city->id)->where('code', $barangayCode)->first();
            if ($barangay === null) {
                return null;
            }
            $result['psgc_code'] = $barangay->code;
            $result['barangay'] = $barangay->name;
        }

        return $result;
    }

    public function activeVersion(): ?string
    {
        $id = DB::table('psgc_versions')->where('status', 'ACTIVE')->value('id');

        return $id === null ? null : (string) $id;
    }

    private function city(string $version, string $cityName, string $provinceName, string $regionName): ?object
    {
        $normalized = PsgcNames::normalize($cityName);
        if ($normalized === '') {
            return null;
        }
        $candidates = DB::table('psgc_areas')->where('psgc_version_id', $version)->whereIn('level', self::CITY_LEVELS)->where('normalized_name', $normalized)->orderBy('code')->get();
        if ($candidates->count() <= 1) {
            return $candidates->first();
        }
        $province = PsgcNames::normalize($provinceName);
        $byProvince = $candidates->filter(fn (object $candidate): bool => $province !== '' && ($ancestor = $this->ancestor($candidate, 'PROVINCE')) !== null && $ancestor->normalized_name === $province);
        if ($byProvince->count() === 1) {
            return $byProvince->first();
        }
        $region = $this->region($version, $regionName !== '' ? $regionName : $provinceName);
        if ($region !== null) {
            $byRegion = $candidates->filter(fn (object $candidate): bool => substr((string) $candidate->code, 0, 2) === substr((string) $region->code, 0, 2));
            if ($byRegion->count() === 1) {
                return $byRegion->first();
            }
        }

        return null;
    }

    private function region(string $version, string $name): ?object
    {
        $normalized = PsgcNames::normalize($name);
        if ($normalized === '') {
            return null;
        }
        $matches = DB::table('psgc_areas')->where('psgc_version_id', $version)->where('level', 'REGION')->get()
            ->filter(static fn (object $region): bool => in_array($normalized, PsgcNames::regionAliases((string) $region->name), true));

        return $matches->count() === 1 ? $matches->first() : null;
    }

    /** @param list<string> $levels */
    private function unique(string $version, array $levels, string $normalized): ?object
    {
        if ($normalized === '') {
            return null;
        }
        $matches = DB::table('psgc_areas')->where('psgc_version_id', $version)->whereIn('level', $levels)->where('normalized_name', $normalized)->limit(2)->get();

        return $matches->count() === 1 ? $matches->first() : null;
    }

    /** @return array<string, mixed> */
    private function fromArea(string $version, object $city, string $barangayName): array
    {
        $region = $this->ancestor($city, 'REGION');
        $province = $this->ancestor($city, 'PROVINCE') ?? $city;
        $result = ['psgc_resolution' => 'RESOLVED', 'psgc_version_id' => $version, 'region_code' => $region?->code, 'region' => $region?->name,
            'province_code' => $province->code, 'province' => $province->name, 'city_code' => $city->code, 'city_municipality' => $city->name,
            'psgc_code' => null, 'barangay' => null, 'reason' => null];
        if ($region === null) {
            return $this->unresolved($version, 'HIERARCHY_INCOMPLETE');
        }
        $normalized = PsgcNames::normalize($barangayName);
        if ($normalized !== '') {
            $matches = $this->barangays($version, (string) $city->id)->where('normalized_name', $normalized)->limit(2)->get();
            if ($matches->count() === 1) {
                $result['psgc_code'] = $matches->first()->code;
                $result['barangay'] = $matches->first()->name;
            }
        }

        return $result;
    }

    /** Barangays directly under a city or under one of its sub-municipalities. */
    private function barangays(string $version, string $cityId): Builder
    {
        return DB::table('psgc_areas')->where('psgc_version_id', $version)->where('level', 'BARANGAY')
            ->where(fn ($query) => $query->where('parent_id', $cityId)->orWhereIn('parent_id', DB::table('psgc_areas')->select('id')->where('parent_id', $cityId)->where('level', 'SUB_MUNICIPALITY')));
    }

    /** @return array<string, mixed> */
    private function partial(string $version, object $area): array
    {
        $region = $area->level === 'REGION' ? $area : $this->ancestor($area, 'REGION');
        if ($region === null) {
            return $this->unresolved($version, 'HIERARCHY_INCOMPLETE');
        }

        return ['psgc_resolution' => 'PARTIAL', 'psgc_version_id' => $version, 'region_code' => $region->code, 'region' => $region->name,
            'province_code' => $area->level === 'PROVINCE' ? $area->code : null, 'province' => $area->level === 'PROVINCE' ? $area->name : null,
            'city_code' => null, 'city_municipality' => null, 'psgc_code' => null, 'barangay' => null, 'reason' => 'CITY_NOT_MATCHED'];
    }

    /** @return array<string, mixed> */
    private function unresolved(?string $version, string $reason): array
    {
        return ['psgc_resolution' => 'UNRESOLVED', 'psgc_version_id' => null, 'region_code' => null, 'region' => null, 'province_code' => null, 'province' => null,
            'city_code' => null, 'city_municipality' => null, 'psgc_code' => null, 'barangay' => null, 'reason' => $reason, 'attempted_version_id' => $version];
    }

    private function ancestor(object $area, string $level): ?object
    {
        $current = $area;
        for ($depth = 0; $depth < 6 && $current->parent_id !== null; $depth++) {
            $current = DB::table('psgc_areas')->where('id', $current->parent_id)->first();
            if ($current === null) {
                return null;
            }
            if ($current->level === $level) {
                return $current;
            }
        }

        return null;
    }
}
