<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Versioned PSGC master import. Every import creates a DRAFT version inside one transaction; an operator
 * activates it explicitly, retiring the previous ACTIVE version. Areas of ACTIVE/RETIRED versions are
 * immutable (database trigger), so addresses keep the exact version and codes they were resolved against.
 */
final class PsgcImporter
{
    /**
     * @return array{version_id: string, version: string, status: string, duplicate: bool, area_count: int, level_counts: array<string, int>, orphan_count: int}
     */
    public function import(PsgcImportSource $source, string $label, string $effectiveOn, string $reference): array
    {
        if (preg_match('/^[A-Za-z0-9._-]{1,32}$/D', $label) !== 1 || preg_match('/^\d{4}-\d{2}-\d{2}$/D', $effectiveOn) !== 1 || trim($reference) === '') {
            throw new AuthenticationException('PSGC_IMPORT_INVALID', 'Provide a version label (letters, digits, dot, dash, underscore), an effective date (YYYY-MM-DD) and a source reference.', 422);
        }
        $rows = $this->validated($source->rows());
        $hash = hash('sha256', implode("\n", array_map(static fn (array $row): string => $row['code'].'|'.$row['name'].'|'.$row['level'], $rows)));
        $existing = DB::table('psgc_versions')->where('content_hash', $hash)->first();
        if ($existing !== null) {
            return $this->summary($existing, true);
        }
        if (DB::table('psgc_versions')->where('version', $label)->exists()) {
            throw new AuthenticationException('PSGC_VERSION_EXISTS', 'A PSGC version with this label already exists with different content.', 409);
        }

        return DB::transaction(function () use ($source, $label, $effectiveOn, $reference, $rows, $hash): array {
            // One timestamp string for the whole import. Query listeners (Ignition, Sentry) keep recent bindings by
            // reference, so a fresh Carbon per row kept ~2 MB per chunk alive and exhausted the CLI memory limit
            // on the ~44k-row PSA file.
            $now = now()->toDateTimeString('microsecond');
            $versionId = (string) Str::uuid7();
            DB::table('psgc_versions')->insert(['id' => $versionId, 'version' => $label, 'effective_on' => $effectiveOn, 'source_reference' => Str::limit(trim($reference), 250, ''),
                'status' => 'DRAFT', 'source_kind' => $source->kind(), 'content_hash' => $hash, 'created_at' => $now, 'updated_at' => $now]);

            $ids = [];
            foreach ($rows as $row) {
                $ids[$row['code']] = (string) Str::uuid7();
            }
            usort($rows, static fn (array $a, array $b): int => PsgcNames::RANK[$a['level']] <=> PsgcNames::RANK[$b['level']] ?: strcmp($a['code'], $b['code']));
            $orphans = 0;
            $counts = [];
            foreach (array_chunk($rows, 1000) as $chunk) {
                $insert = [];
                foreach ($chunk as $row) {
                    $parent = $this->parentCode($row['code'], $row['level'], $ids);
                    if ($parent === null && $row['level'] !== 'REGION') {
                        $orphans++;
                    }
                    $counts[$row['level']] = ($counts[$row['level']] ?? 0) + 1;
                    $insert[] = ['id' => $ids[$row['code']], 'psgc_version_id' => $versionId, 'code' => $row['code'], 'name' => $row['name'], 'normalized_name' => PsgcNames::normalize($row['name']),
                        'level' => $row['level'], 'parent_id' => $parent === null ? null : $ids[$parent], 'created_at' => $now, 'updated_at' => $now];
                }
                DB::table('psgc_areas')->insert($insert);
            }
            ksort($counts);
            DB::table('psgc_versions')->where('id', $versionId)->update(['area_count' => count($rows), 'level_counts' => json_encode($counts, JSON_THROW_ON_ERROR), 'orphan_count' => $orphans, 'updated_at' => $now]);

            return $this->summary(DB::table('psgc_versions')->where('id', $versionId)->first(), false);
        });
    }

    /** @return array{version_id: string, version: string, status: string, duplicate: bool, area_count: int, level_counts: array<string, int>, orphan_count: int} */
    public function activate(string $versionLabelOrId): array
    {
        return DB::transaction(function () use ($versionLabelOrId): array {
            DB::table('psgc_versions')->orderBy('id')->lockForUpdate()->get(['id']);
            $version = DB::table('psgc_versions')->where(Str::isUuid($versionLabelOrId) ? 'id' : 'version', $versionLabelOrId)->first();
            if ($version === null) {
                throw new AuthenticationException('PSGC_VERSION_UNKNOWN', 'This PSGC version does not exist.', 404);
            }
            if ($version->status === 'ACTIVE') {
                return $this->summary($version, true);
            }
            if ($version->status !== 'DRAFT' || (int) $version->area_count === 0 || ! DB::table('psgc_areas')->where('psgc_version_id', $version->id)->where('level', 'REGION')->exists()) {
                throw new AuthenticationException('PSGC_VERSION_NOT_ACTIVATABLE', 'Only a non-empty DRAFT version with regions can be activated.', 409);
            }
            DB::table('psgc_versions')->where('status', 'ACTIVE')->update(['status' => 'RETIRED', 'retired_at' => now(), 'updated_at' => now()]);
            DB::table('psgc_versions')->where('id', $version->id)->update(['status' => 'ACTIVE', 'activated_at' => now(), 'updated_at' => now()]);

            return $this->summary(DB::table('psgc_versions')->where('id', $version->id)->first(), false);
        });
    }

    /**
     * @param  list<array{code: string, name: string, level: string}>  $rows
     * @return list<array{code: string, name: string, level: string}>
     */
    private function validated(array $rows): array
    {
        if ($rows === [] || count($rows) > PsgcCsvSource::MAX_ROWS) {
            throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC source is empty or too large.', 422);
        }
        $seen = [];
        foreach ($rows as $row) {
            if (PsgcNames::code($row['code']) !== $row['code'] || trim($row['name']) === '' || ! isset(PsgcNames::RANK[$row['level']])) {
                throw new AuthenticationException('PSGC_SOURCE_INVALID', 'Every PSGC row needs a 10-digit code, a name and a known level.', 422);
            }
            if (isset($seen[$row['code']])) {
                throw new AuthenticationException('PSGC_SOURCE_INVALID', 'PSGC code '.$row['code'].' appears more than once.', 422);
            }
            $seen[$row['code']] = true;
        }
        if (! in_array('REGION', array_column($rows, 'level'), true)) {
            throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC source contains no regions.', 422);
        }
        usort($rows, static fn (array $a, array $b): int => strcmp($a['code'], $b['code']));

        return $rows;
    }

    /**
     * The nearest existing ancestor by zeroing trailing PSGC segments: barangay → city/sub-municipality
     * (first 7 digits), city/municipality → province or independent city (first 5), anything → region (first 2).
     *
     * @param  array<string, string>  $ids
     */
    private function parentCode(string $code, string $level, array $ids): ?string
    {
        if ($level === 'REGION') {
            return null;
        }
        foreach ([substr($code, 0, 7).'000', substr($code, 0, 5).'00000', substr($code, 0, 2).'00000000'] as $candidate) {
            if ($candidate !== $code && isset($ids[$candidate])) {
                return $candidate;
            }
        }

        return null;
    }

    /** @return array{version_id: string, version: string, status: string, duplicate: bool, area_count: int, level_counts: array<string, int>, orphan_count: int} */
    private function summary(object $version, bool $duplicate): array
    {
        $counts = json_decode((string) $version->level_counts, true);
        if (is_array($counts)) {
            ksort($counts);
        }

        return ['version_id' => (string) $version->id, 'version' => (string) $version->version, 'status' => (string) $version->status, 'duplicate' => $duplicate,
            'area_count' => (int) $version->area_count, 'level_counts' => is_array($counts) ? $counts : [], 'orphan_count' => (int) $version->orphan_count];
    }
}
