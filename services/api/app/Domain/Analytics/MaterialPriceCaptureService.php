<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Procurement\ScopedOfferQuery;
use Carbon\CarbonImmutable;
use Closure;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use RuntimeException;
use Throwable;

/**
 * MAT-04 daily capture (00:10 Asia/Manila). Inside one REPEATABLE READ transaction it reads every eligible, comparable,
 * discoverable public ordinary price (MAT-02 predicate + MAT-03 mapping) once, stores one immutable observation per
 * variant with the actual capture instant, local date, price/version, normalized PHP per canonical unit (8 dp), tax
 * category, the store's address version, PSGC codes and geography point, marks each Vendor's one selected offer per
 * comparable group (latest published ordinary-price effective time, then ascending variant id) and publishes the run —
 * or nothing at all. A retry of a published day returns the same revision; a failed day is recorded as FAILED and can
 * be retried; a capture that crosses local midnight is discarded and restarted for the actual new date. A missed day
 * stays a gap: nothing is backfilled from current inventory. The job writes only the TEST capture dataset.
 */
final class MaterialPriceCaptureService
{
    public const DUPLICATE_REASON = 'DUPLICATE_VENDOR_OFFER';

    public function __construct(private readonly ScopedOfferQuery $offers) {}

    /**
     * @param  Closure(): CarbonImmutable|null  $clock  the instant used for the pre-publication midnight check (tests inject one)
     * @return array{state: string, snapshot_date: string, run_id: ?string, revision: ?int, observations: int, selected: int, vendors: int, error_code?: string}
     */
    public function capture(CarbonImmutable $startedAt, ?Closure $clock = null, bool $retryAfterMidnight = true): array
    {
        $clock ??= static fn (): CarbonImmutable => CarbonImmutable::now();
        $startedAt = $startedAt->setTimezone('UTC');
        $localDate = $startedAt->setTimezone('Asia/Manila')->toDateString();
        $published = $this->publishedRun(AnalyticsDataset::CAPTURE_ENVIRONMENT, AnalyticsDataset::CAPTURE_DATASET, $localDate);
        if ($published !== null) {
            return ['state' => 'ALREADY_PUBLISHED', 'snapshot_date' => $localDate, 'run_id' => (string) $published->id, 'revision' => (int) $published->revision,
                'observations' => (int) $published->source_count, 'selected' => (int) $published->selected_count, 'vendors' => (int) $published->selected_vendor_count];
        }
        try {
            $result = DB::transaction(function () use ($startedAt, $localDate, $clock): array {
                if (DB::transactionLevel() === 1) {
                    // One consistent snapshot for the whole capture (an enclosing transaction already provides one).
                    DB::statement('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');
                }
                $run = $this->openRun(AnalyticsDataset::CAPTURE_ENVIRONMENT, AnalyticsDataset::CAPTURE_DATASET, $localDate, $startedAt);
                $rows = $this->eligibleRows();
                $inserted = $this->stage($run, $rows, $startedAt, $localDate, AnalyticsDataset::CAPTURE_ENVIRONMENT, AnalyticsDataset::CAPTURE_DATASET);
                if ($clock()->setTimezone('Asia/Manila')->toDateString() !== $localDate) {
                    throw new CaptureCrossedMidnight;
                }

                return $this->publish($run, $inserted);
            });
            AnalyticsDataset::bump();
            EligibleOfferQuery::invalidate();

            return $result;
        } catch (CaptureCrossedMidnight) {
            // The staged rows for the old date were rolled back; capture again for the actual new local date.
            return $retryAfterMidnight ? $this->capture($clock(), null, false) : $this->fail($localDate, $startedAt, 'CAPTURE_CROSSED_MIDNIGHT');
        } catch (Throwable $exception) {
            Log::error('Material price capture failed.', ['snapshot_date' => $localDate, 'exception' => $exception::class]);

            return $this->fail($localDate, $startedAt, 'CAPTURE_FAILED');
        }
    }

    /**
     * Stages observations for a run inside the caller's transaction and returns the inserted count, selected count,
     * selected Vendor count and content hash. Shared with the DEMO seeder, which supplies simulated rows.
     *
     * @param  list<array<string, mixed>>  $rows
     * @return array{observations: int, selected: int, vendors: int, hash: string}
     */
    public function stage(object $run, array $rows, CarbonImmutable $observedAt, string $localDate, string $environment, string $dataset): array
    {
        $selected = [];
        foreach ($rows as $index => $row) {
            $key = $row['vendor_organization_id'].'|'.$row['comparable_group_id'];
            $current = $selected[$key] ?? null;
            if ($current === null || self::prefer($row, $rows[$current])) {
                $selected[$key] = $index;
            }
        }
        $chosen = array_flip(array_values($selected));
        $hashParts = [];
        foreach (array_chunk($rows, 200, true) as $chunk) {
            $batch = [];
            foreach ($chunk as $index => $row) {
                $isSelected = isset($chosen[$index]);
                $hashParts[] = $row['listing_variant_id'].':'.$row['listing_price_version_id'].':'.$row['normalized_php_price'].':'.($isSelected ? 1 : 0);
                $batch[] = [
                    'id' => (string) Str::uuid7(), 'analytics_refresh_run_id' => $run->id, 'source_kind' => 'PUBLIC_LISTING', 'environment' => $environment, 'dataset_id' => $dataset,
                    'vendor_organization_id' => $row['vendor_organization_id'], 'vendor_listing_id' => $row['vendor_listing_id'], 'listing_variant_id' => $row['listing_variant_id'],
                    'listing_price_version_id' => $row['listing_price_version_id'], 'comparable_group_version_id' => $row['comparable_group_version_id'], 'comparable_group_id' => $row['comparable_group_id'],
                    'observed_at' => $observedAt, 'local_snapshot_date' => $localDate, 'ordinary_payable_centavos' => $row['ordinary_payable_centavos'], 'normalized_php_price' => $row['normalized_php_price'],
                    'tax_category' => $row['tax_category'], 'address_id' => null, 'address_version' => $row['address_version'], 'vendor_address_version_id' => $row['vendor_address_version_id'],
                    'psgc_region_code' => $row['psgc_region_code'], 'psgc_province_code' => $row['psgc_province_code'], 'psgc_city_code' => $row['psgc_city_code'],
                    'store_location' => DB::raw('(SELECT location FROM vendor_address_versions WHERE id = '.DB::getPdo()->quote((string) $row['vendor_address_version_id']).')'),
                    'eligibility_version' => EligibleOfferQuery::VERSION, 'selected_for_average' => $isSelected, 'exclusion_reason' => $isSelected ? null : self::DUPLICATE_REASON,
                    'price_effective_at' => $row['price_effective_at'], 'unit_conversion_version' => $row['unit_conversion_version'], 'comparability_rule_version' => ComparableMappingService::MAPPING_RULE,
                    'stock_confirmed_at' => $row['stock_confirmed_at'], 'created_at' => now(), 'updated_at' => now(),
                ];
            }
            DB::table('price_observations')->insert($batch);
        }
        $vendors = [];
        foreach ($selected as $index) {
            $vendors[$rows[$index]['vendor_organization_id']] = true;
        }
        sort($hashParts);

        return ['observations' => count($rows), 'selected' => count($selected), 'vendors' => count($vendors), 'hash' => hash('sha256', implode("\n", $hashParts))];
    }

    /**
     * Validates the staged run and publishes it atomically with its pointer row.
     *
     * @param  array{observations: int, selected: int, vendors: int, hash: string}  $staged
     * @return array{state: string, snapshot_date: string, run_id: string, revision: int, observations: int, selected: int, vendors: int}
     */
    public function publish(object $run, array $staged): array
    {
        $stored = DB::table('price_observations')->where('analytics_refresh_run_id', $run->id)->selectRaw('count(*) AS total, count(*) FILTER (WHERE selected_for_average) AS selected,
            count(*) FILTER (WHERE store_location IS NULL OR normalized_php_price <= 0) AS invalid')->first();
        if ((int) $stored->total !== $staged['observations'] || (int) $stored->selected !== $staged['selected'] || (int) $stored->invalid > 0) {
            throw new RuntimeException('Staged observations failed validation.');
        }
        DB::table('analytics_refresh_runs')->where('id', $run->id)->update(['state' => 'VALIDATED', 'validated_at' => now(), 'source_count' => $staged['observations'], 'selected_count' => $staged['selected'],
            'selected_vendor_count' => $staged['vendors'], 'content_hash' => $staged['hash'], 'error_code' => null, 'updated_at' => now()]);
        DB::table('analytics_refresh_runs')->where('id', $run->id)->update(['state' => 'PUBLISHED', 'published_at' => now(), 'updated_at' => now()]);
        $pointer = DB::table('analytics_published_runs')->where('kind', AnalyticsDataset::KIND)->where('environment', $run->environment)->where('dataset_id', $run->dataset_id)->where('snapshot_date', $run->snapshot_date)->lockForUpdate()->first();
        if ($pointer === null) {
            DB::table('analytics_published_runs')->insert(['id' => (string) Str::uuid7(), 'kind' => AnalyticsDataset::KIND, 'environment' => $run->environment, 'dataset_id' => $run->dataset_id,
                'snapshot_date' => $run->snapshot_date, 'analytics_refresh_run_id' => $run->id, 'published_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        } else {
            DB::table('analytics_refresh_runs')->where('id', $pointer->analytics_refresh_run_id)->update(['state' => 'SUPERSEDED', 'updated_at' => now()]);
            DB::table('analytics_published_runs')->where('id', $pointer->id)->update(['analytics_refresh_run_id' => $run->id, 'published_at' => now(), 'updated_at' => now()]);
        }

        return ['state' => 'PUBLISHED', 'snapshot_date' => (string) $run->snapshot_date, 'run_id' => (string) $run->id, 'revision' => (int) $run->revision,
            'observations' => $staged['observations'], 'selected' => $staged['selected'], 'vendors' => $staged['vendors']];
    }

    /** Opens (or reopens a FAILED/RUNNING) revision-1 run row for the date inside the caller's transaction. */
    public function openRun(string $environment, string $dataset, string $localDate, CarbonImmutable $observedAt, int $revision = 1, ?string $supersedes = null, ?string $reason = null, ?int $reviewerId = null): object
    {
        $existing = DB::table('analytics_refresh_runs')->where('kind', AnalyticsDataset::KIND)->where('environment', $environment)->where('dataset_id', $dataset)
            ->where('snapshot_date', $localDate)->where('revision', $revision)->lockForUpdate()->first();
        if ($existing !== null && in_array($existing->state, ['PUBLISHED', 'VALIDATED', 'SUPERSEDED'], true)) {
            throw new RuntimeException('This snapshot revision was already published.');
        }
        if ($existing !== null) {
            DB::table('analytics_refresh_runs')->where('id', $existing->id)->update(['state' => 'RUNNING', 'error_code' => null, 'observed_at' => $observedAt, 'updated_at' => now()]);

            return DB::table('analytics_refresh_runs')->where('id', $existing->id)->first();
        }
        $id = (string) Str::uuid7();
        DB::table('analytics_refresh_runs')->insert(['id' => $id, 'kind' => AnalyticsDataset::KIND, 'environment' => $environment, 'dataset_id' => $dataset, 'snapshot_date' => $localDate, 'revision' => $revision,
            'state' => 'RUNNING', 'observed_at' => $observedAt, 'supersedes_run_id' => $supersedes, 'reviewer_reason' => $reason, 'reviewed_by_user_id' => $reviewerId, 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('analytics_refresh_runs')->where('id', $id)->first();
    }

    public function publishedRun(string $environment, string $dataset, string $localDate): ?object
    {
        return DB::table('analytics_published_runs as p')->join('analytics_refresh_runs as r', 'r.id', '=', 'p.analytics_refresh_run_id')->where('p.kind', AnalyticsDataset::KIND)
            ->where('p.environment', $environment)->where('p.dataset_id', $dataset)->where('p.snapshot_date', $localDate)->first(['r.*']);
    }

    /** @return list<array<string, mixed>> */
    private function eligibleRows(): array
    {
        $query = ComparableMappingService::joinComparable($this->offers->anywhere())
            ->whereNotNull('ca.id')->where('cg.status', 'ACTIVE')->where('gv.review_state', 'APPROVED')
            ->selectRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' AS normalized_php_price')
            ->addSelect(['v.id as listing_variant_id', 'l.id as vendor_listing_id', 'o.id as vendor_organization_id', 'pv.id as listing_price_version_id', 'pv.effective_at as price_effective_at',
                'pv.amount_centavos as ordinary_payable_centavos', 'pv.tax_category', 'gv.id as comparable_group_version_id', 'cg.id as comparable_group_id', 'gv.conversion_version as unit_conversion_version',
                'i.confirmed_at as stock_confirmed_at', 'av.id as vendor_address_version_id', 'av.version as address_version', 'av.province_code', 'av.city_code'])
            ->orderBy('o.id')->orderBy('v.id');
        $regions = [];
        $rows = [];
        foreach ($query->get() as $row) {
            if ($row->normalized_php_price === null || bccomp((string) $row->normalized_php_price, '0', 8) <= 0) {
                continue;
            }
            $areaCode = $row->city_code ?? $row->province_code;
            $regionKey = (string) $areaCode;
            $regions[$regionKey] ??= $areaCode === null ? null : $this->regionCode((string) $areaCode);
            $rows[] = [
                'listing_variant_id' => (string) $row->listing_variant_id, 'vendor_listing_id' => (string) $row->vendor_listing_id, 'vendor_organization_id' => (string) $row->vendor_organization_id,
                'listing_price_version_id' => (string) $row->listing_price_version_id, 'price_effective_at' => (string) $row->price_effective_at, 'ordinary_payable_centavos' => (int) $row->ordinary_payable_centavos,
                'normalized_php_price' => (string) $row->normalized_php_price, 'tax_category' => (string) $row->tax_category, 'comparable_group_version_id' => (string) $row->comparable_group_version_id,
                'comparable_group_id' => (string) $row->comparable_group_id, 'unit_conversion_version' => (string) $row->unit_conversion_version, 'stock_confirmed_at' => $row->stock_confirmed_at,
                'vendor_address_version_id' => (string) $row->vendor_address_version_id, 'address_version' => (int) $row->address_version,
                'psgc_region_code' => $regions[$regionKey], 'psgc_province_code' => $row->province_code, 'psgc_city_code' => $row->city_code,
            ];
        }

        return $rows;
    }

    /** The top ancestor (region) of a PSGC area in the active version, or null when the code is unknown. */
    private function regionCode(string $code): ?string
    {
        $area = DB::table('psgc_areas as a')->join('psgc_versions as v', 'v.id', '=', 'a.psgc_version_id')->where('v.status', 'ACTIVE')->where('a.code', $code)->first(['a.id', 'a.code', 'a.parent_id']);
        for ($depth = 0; $area !== null && $area->parent_id !== null && $depth < 6; $depth++) {
            $area = DB::table('psgc_areas')->where('id', $area->parent_id)->first(['id', 'code', 'parent_id']);
        }

        return $area === null ? null : (string) $area->code;
    }

    /**
     * @param  array<string, mixed>  $candidate
     * @param  array<string, mixed>  $current
     */
    private static function prefer(array $candidate, array $current): bool
    {
        $compare = CarbonImmutable::parse((string) $candidate['price_effective_at'])->getTimestamp() <=> CarbonImmutable::parse((string) $current['price_effective_at'])->getTimestamp();
        if ($compare === 0) {
            $compare = CarbonImmutable::parse((string) $candidate['price_effective_at'])->format('u') <=> CarbonImmutable::parse((string) $current['price_effective_at'])->format('u');
        }

        return $compare > 0 || ($compare === 0 && strcmp((string) $candidate['listing_variant_id'], (string) $current['listing_variant_id']) < 0);
    }

    /** @return array{state: string, snapshot_date: string, run_id: ?string, revision: ?int, observations: int, selected: int, vendors: int, error_code: string} */
    private function fail(string $localDate, CarbonImmutable $startedAt, string $code): array
    {
        $runId = DB::transaction(function () use ($localDate, $startedAt, $code): string {
            $existing = DB::table('analytics_refresh_runs')->where('kind', AnalyticsDataset::KIND)->where('environment', AnalyticsDataset::CAPTURE_ENVIRONMENT)
                ->where('dataset_id', AnalyticsDataset::CAPTURE_DATASET)->where('snapshot_date', $localDate)->where('revision', 1)->lockForUpdate()->first();
            if ($existing !== null && in_array($existing->state, ['PUBLISHED', 'SUPERSEDED'], true)) {
                return (string) $existing->id;
            }
            if ($existing !== null) {
                DB::table('analytics_refresh_runs')->where('id', $existing->id)->update(['state' => 'FAILED', 'error_code' => $code, 'updated_at' => now()]);

                return (string) $existing->id;
            }
            $id = (string) Str::uuid7();
            DB::table('analytics_refresh_runs')->insert(['id' => $id, 'kind' => AnalyticsDataset::KIND, 'environment' => AnalyticsDataset::CAPTURE_ENVIRONMENT, 'dataset_id' => AnalyticsDataset::CAPTURE_DATASET,
                'snapshot_date' => $localDate, 'revision' => 1, 'state' => 'FAILED', 'observed_at' => $startedAt, 'error_code' => $code, 'created_at' => now(), 'updated_at' => now()]);

            return $id;
        });

        return ['state' => 'FAILED', 'snapshot_date' => $localDate, 'run_id' => $runId, 'revision' => 1, 'observations' => 0, 'selected' => 0, 'vendors' => 0, 'error_code' => $code];
    }
}
