<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Geography\PsgcNames;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Versioned import of PSGC-coded administrative boundaries (GeoJSON) for the Admin map. Each feature is matched by
 * its 10-digit PSGC code to an area of the chosen version (ACTIVE by default), repaired with ST_MakeValid, stored as a
 * MultiPolygon for server-side point placement, and simplified per level for the browser. An existing boundary is
 * replaced only with an explicit --replace; every import records its source, hash, matched and unmatched codes.
 * Boundaries are reference geometry, not personal data; no Buyer or Vendor point is ever sent to the browser.
 */
final class BoundaryImporter
{
    public const MAX_BYTES = 150 * 1024 * 1024;

    private const CODE_PROPERTIES = ['psgc', 'psgc_code', 'adm4_psgc', 'adm3_psgc', 'adm2_psgc', 'adm1_psgc', 'code', 'PSGC', 'PSGC_CODE'];

    /** Simplification tolerance in degrees per level: coarse for regions, finer for cities and municipalities. */
    private const TOLERANCE = ['REGION' => 0.01, 'PROVINCE' => 0.004, 'OTHER' => 0.004, 'CITY' => 0.0015, 'MUNICIPALITY' => 0.0015, 'SPECIAL_GEOGRAPHIC_AREA' => 0.0015];

    /** @return array{import_id: string, features: int, matched: int, replaced: int, skipped_existing: int, unmatched: list<string>, code_property: string} */
    public function import(string $path, string $reference, ?string $versionLabel = null, ?string $codeProperty = null, bool $replace = false): array
    {
        if (! is_file($path) || ! is_readable($path) || filesize($path) === 0 || filesize($path) > self::MAX_BYTES) {
            throw new AuthenticationException('BOUNDARY_SOURCE_INVALID', 'Provide a readable GeoJSON file of at most 150 MB.', 422);
        }
        if (mb_strlen(trim($reference)) < 5) {
            throw new AuthenticationException('BOUNDARY_SOURCE_INVALID', 'Record the boundary source reference (publisher, dataset and date).', 422);
        }
        $raw = (string) file_get_contents($path);
        try {
            $collection = json_decode($raw, true, 512, JSON_THROW_ON_ERROR);
        } catch (Throwable) {
            throw new AuthenticationException('BOUNDARY_SOURCE_INVALID', 'The file is not valid GeoJSON.', 422);
        }
        if (! is_array($collection) || ($collection['type'] ?? null) !== 'FeatureCollection' || ! is_array($collection['features'] ?? null)) {
            throw new AuthenticationException('BOUNDARY_SOURCE_INVALID', 'The file must be a GeoJSON FeatureCollection.', 422);
        }
        $version = $versionLabel === null ? DB::table('psgc_versions')->where('status', 'ACTIVE')->first() : DB::table('psgc_versions')->where('version', $versionLabel)->first();
        if ($version === null) {
            throw new AuthenticationException('PSGC_VERSION_UNAVAILABLE', 'Import and activate the PSGC master first, or name an existing version.', 409);
        }
        $features = $collection['features'];
        $property = $codeProperty ?? $this->detect($features);
        $hash = hash('sha256', $raw);
        $existingImport = DB::table('psgc_boundary_imports')->where('psgc_version_id', $version->id)->where('content_hash', $hash)->first();
        if ($existingImport !== null) {
            return ['import_id' => (string) $existingImport->id, 'features' => (int) $existingImport->feature_count, 'matched' => (int) $existingImport->matched_count,
                'replaced' => (int) $existingImport->replaced_count, 'skipped_existing' => 0, 'unmatched' => json_decode((string) $existingImport->unmatched_codes, true) ?: [], 'code_property' => (string) $existingImport->code_property];
        }
        $areas = DB::table('psgc_areas')->where('psgc_version_id', $version->id)->where('level', '<>', 'BARANGAY')->get(['id', 'code', 'level'])->keyBy('code');

        return DB::transaction(function () use ($features, $property, $areas, $version, $reference, $hash, $replace): array {
            $importId = (string) Str::uuid7();
            DB::table('psgc_boundary_imports')->insert(['id' => $importId, 'psgc_version_id' => $version->id, 'source_reference' => mb_substr(trim($reference), 0, 255), 'content_hash' => $hash,
                'feature_count' => count($features), 'matched_count' => 0, 'unmatched_codes' => '[]', 'code_property' => $property, 'imported_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $matched = 0;
            $replaced = 0;
            $skipped = 0;
            $unmatched = [];
            foreach ($features as $feature) {
                $rawCode = $feature['properties'][$property] ?? null;
                $code = is_scalar($rawCode) ? PsgcNames::code((string) $rawCode) : null;
                $area = $code === null ? null : $areas->get($code);
                $geometry = $feature['geometry'] ?? null;
                if ($area === null || ! is_array($geometry) || ! in_array($geometry['type'] ?? null, ['Polygon', 'MultiPolygon'], true)) {
                    $unmatched[] = $code ?? (is_scalar($rawCode) ? (string) $rawCode : '(missing)');

                    continue;
                }
                $existing = DB::table('psgc_boundaries')->where('psgc_area_id', $area->id)->first(['id']);
                if ($existing !== null && ! $replace) {
                    $skipped++;

                    continue;
                }
                $json = json_encode($geometry, JSON_THROW_ON_ERROR);
                $tolerance = self::TOLERANCE[$area->level] ?? 0.0015;
                $shape = DB::selectOne('WITH g AS (SELECT ST_Multi(ST_CollectionExtract(ST_MakeValid(ST_SetSRID(ST_GeomFromGeoJSON(?), 4326)), 3)) AS geom)
                    SELECT ST_AsText(geom) AS full_wkt, ST_AsGeoJSON(ST_SimplifyPreserveTopology(geom, ?), 5) AS simplified, ST_IsEmpty(geom) AS empty FROM g', [$json, $tolerance]);
                if ($shape === null || $shape->empty) {
                    $unmatched[] = $code;

                    continue;
                }
                $values = ['geometry_wkt' => (string) $shape->full_wkt, 'content_hash' => hash('sha256', $json), 'simplified_geojson' => (string) $shape->simplified,
                    'source_reference' => mb_substr(trim($reference), 0, 255), 'psgc_boundary_import_id' => $importId, 'updated_at' => now()];
                if ($existing === null) {
                    $id = (string) Str::uuid7();
                    DB::table('psgc_boundaries')->insert(['id' => $id, 'psgc_area_id' => $area->id, 'created_at' => now()] + $values);
                } else {
                    $id = (string) $existing->id;
                    DB::table('psgc_boundaries')->where('id', $id)->update($values);
                    $replaced++;
                }
                DB::statement('UPDATE psgc_boundaries SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(ST_SetSRID(ST_GeomFromText(geometry_wkt), 4326)), 3)) WHERE id = ?', [$id]);
                $matched++;
            }
            DB::table('psgc_boundary_imports')->where('id', $importId)->update(['matched_count' => $matched, 'replaced_count' => $replaced,
                'unmatched_codes' => json_encode(array_slice(array_values(array_unique($unmatched)), 0, 500), JSON_THROW_ON_ERROR), 'updated_at' => now()]);

            return ['import_id' => $importId, 'features' => count($features), 'matched' => $matched, 'replaced' => $replaced, 'skipped_existing' => $skipped,
                'unmatched' => array_slice(array_values(array_unique($unmatched)), 0, 50), 'code_property' => $property];
        });
    }

    /** @param list<array<string, mixed>> $features */
    private function detect(array $features): string
    {
        $properties = is_array($features[0]['properties'] ?? null) ? $features[0]['properties'] : [];
        foreach (self::CODE_PROPERTIES as $candidate) {
            if (array_key_exists($candidate, $properties)) {
                return $candidate;
            }
        }
        throw new AuthenticationException('BOUNDARY_CODE_PROPERTY_REQUIRED', 'No PSGC code property was found. Name it with --code-property.', 422);
    }
}
