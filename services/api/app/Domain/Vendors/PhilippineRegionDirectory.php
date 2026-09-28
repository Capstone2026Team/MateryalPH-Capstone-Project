<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

final class PhilippineRegionDirectory
{
    public function mapping(): Builder
    {
        return DB::query()->fromRaw(<<<'SQL'
(WITH RECURSIVE regions AS (
    SELECT id, code, code AS region_code, name AS region_name
    FROM psgc_areas
    WHERE level = 'REGION' AND psgc_version_id = (
        SELECT id FROM psgc_versions WHERE effective_on <= CURRENT_DATE AND status <> 'RETIRED'
        ORDER BY (status = 'ACTIVE') DESC, effective_on DESC, id DESC LIMIT 1
    )
    UNION ALL
    SELECT a.id, a.code, r.region_code, r.region_name
    FROM psgc_areas a JOIN regions r ON a.parent_id = r.id
) SELECT code, region_code, region_name FROM regions) AS region_mapping
SQL);
    }

    /** @return list<array{code: string, name: string}> */
    public function options(): array
    {
        return $this->mapping()->select('region_code', 'region_name')->distinct()->orderBy('region_name')->get()
            ->map(fn (object $row): array => ['code' => $row->region_code, 'name' => $row->region_name])->all();
    }
}
