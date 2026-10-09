<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * The Admin drill hierarchy on the ACTIVE PSGC version: Philippines → Region → Province or a city/municipality whose
 * parent is the region itself (independent and highly urbanized cities, NCR cities and Pateros) → City or
 * Municipality of a province. It never assumes every region has provinces. Barangays and sub-municipalities roll up
 * to their city. Codes from an older version are mapped to the current version by code (PSGC codes are stable across
 * releases); a code absent from the current version stays UNRESOLVED and is counted as a data-quality item.
 */
final class PsgcHierarchy
{
    /** @var array<string, array{id: string, code: string, name: string, level: string, parent: ?string}>|null */
    private ?array $areas = null;

    private ?object $version = null;

    private bool $loaded = false;

    public function version(): ?object
    {
        $this->load();

        return $this->version;
    }

    public function requireVersion(): object
    {
        $version = $this->version();
        if ($version === null) {
            throw new AuthenticationException('PSGC_VERSION_UNAVAILABLE', 'No PSGC version is active. Import and activate the PSGC master before using geographic analytics.', 409);
        }

        return $version;
    }

    /** @return array{id: string, code: string, name: string, level: string, parent: ?string}|null */
    public function area(?string $code): ?array
    {
        $this->load();

        return $code === null ? null : ($this->areas[$code] ?? null);
    }

    /**
     * @return array{id: string, code: string, name: string, level: string, parent: ?string}
     */
    public function requireArea(string $code): array
    {
        $area = $this->area($code);
        if ($area === null || ! in_array($this->depth($code), [1, 2, 3], true)) {
            throw new AuthenticationException('PSGC_AREA_UNKNOWN', 'Choose a region, province, city or municipality from the active PSGC version.', 422);
        }

        return $area;
    }

    /** 0 for the Philippines, 1 region, 2 province or independent city/municipality, 3 component city/municipality. */
    public function depth(?string $code): int
    {
        if ($code === null) {
            return 0;
        }
        $path = $this->path($code);

        return count($path);
    }

    /** @return list<array{code: string, name: string, level: string}> region first */
    public function path(string $code): array
    {
        $this->load();
        $chain = [];
        $current = $this->areas[$code] ?? null;
        $guard = 0;
        while ($current !== null && $guard++ < 6) {
            if (! in_array($current['level'], ['SUB_MUNICIPALITY', 'BARANGAY'], true)) {
                array_unshift($chain, ['code' => $current['code'], 'name' => $current['name'], 'level' => $current['level']]);
            }
            $current = $current['parent'] === null ? null : ($this->areas[$current['parent']] ?? null);
        }

        return array_slice($chain, 0, 3);
    }

    /**
     * Drill children: regions for the Philippines; any non-barangay direct child for a region; cities and
     * municipalities for a province. Independent cities and component cities/municipalities are leaves.
     *
     * @return list<array{code: string, name: string, level: string}>
     */
    public function children(?string $code): array
    {
        $this->load();
        $depth = $this->depth($code);
        if ($depth >= 3 || ($depth === 2 && ! in_array($this->areas[$code]['level'] ?? '', ['PROVINCE', 'OTHER'], true))) {
            return [];
        }
        $children = [];
        foreach ($this->areas as $area) {
            if ($area['parent'] !== $code || in_array($area['level'], ['BARANGAY', 'SUB_MUNICIPALITY'], true)) {
                continue;
            }
            if ($code === null && $area['level'] !== 'REGION') {
                continue;
            }
            $children[] = ['code' => $area['code'], 'name' => $area['name'], 'level' => $area['level']];
        }
        usort($children, static fn (array $a, array $b): int => strcmp($a['code'], $b['code']));

        return $children;
    }

    /**
     * Places a stored address reference into the drill hierarchy of the active version.
     *
     * @return array{region_code: ?string, area_code: ?string, locality_code: ?string, resolution: string}
     */
    public function place(?string $cityCode, ?string $provinceCode, ?string $regionCode, ?string $barangayCode = null): array
    {
        $this->load();
        foreach ([$cityCode, $barangayCode, $provinceCode, $regionCode] as $candidate) {
            $code = $candidate === null ? null : trim($candidate);
            if ($code === null || $code === '') {
                continue;
            }
            if (! isset($this->areas[$code]) && strlen($code) === 10) {
                // Barangays are not preloaded: a barangay code's first seven digits plus zeros is its city/municipality.
                $code = substr($code, 0, 7).'000';
            }
            if (! isset($this->areas[$code])) {
                continue;
            }
            $path = $this->path($code);
            if ($path === []) {
                continue;
            }
            // Resolved when the city or municipality is known; a region or province alone is a partial placement.
            $resolved = count($path) === 3 || (count($path) === 2 && ! in_array($path[1]['level'], ['PROVINCE', 'OTHER'], true));

            return ['region_code' => $path[0]['code'], 'area_code' => $path[1]['code'] ?? null, 'locality_code' => $path[2]['code'] ?? null,
                'resolution' => $resolved ? 'RESOLVED' : 'PARTIAL'];
        }

        return ['region_code' => null, 'area_code' => null, 'locality_code' => null, 'resolution' => 'UNRESOLVED'];
    }

    /** The fact column holding codes for the children of a selection depth. */
    public static function childColumn(int $depth): string
    {
        return match ($depth) {
            0 => 'region_code',
            1 => 'area_code',
            default => 'locality_code',
        };
    }

    /** The fact column that filters to a selection at this depth. */
    public static function selectionColumn(int $depth): ?string
    {
        return match ($depth) {
            1 => 'region_code',
            2 => 'area_code',
            3 => 'locality_code',
            default => null,
        };
    }

    public static function levelLabel(?string $level): string
    {
        return match ($level) {
            'REGION' => 'Region',
            'PROVINCE' => 'Province',
            'CITY' => 'City',
            'MUNICIPALITY' => 'Municipality',
            'SPECIAL_GEOGRAPHIC_AREA' => 'Special geographic area',
            null => 'Philippines',
            default => 'Area',
        };
    }

    public function forget(): void
    {
        $this->loaded = false;
        $this->areas = null;
        $this->version = null;
    }

    private function load(): void
    {
        if ($this->loaded) {
            return;
        }
        $this->loaded = true;
        $this->version = DB::table('psgc_versions')->where('status', 'ACTIVE')->first(['id', 'version', 'effective_on', 'source_reference', 'activated_at']);
        $this->areas = [];
        if ($this->version === null) {
            return;
        }
        $rows = DB::table('psgc_areas as a')->leftJoin('psgc_areas as p', 'p.id', '=', 'a.parent_id')->where('a.psgc_version_id', $this->version->id)
            ->where('a.level', '<>', 'BARANGAY')->get(['a.id', 'a.code', 'a.name', 'a.level', 'p.code as parent_code']);
        foreach ($rows as $row) {
            $this->areas[(string) $row->code] = ['id' => (string) $row->id, 'code' => (string) $row->code, 'name' => (string) $row->name, 'level' => (string) $row->level,
                'parent' => $row->parent_code === null ? null : (string) $row->parent_code];
        }
    }
}
