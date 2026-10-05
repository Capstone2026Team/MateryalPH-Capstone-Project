<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Admin-only analytics operations: snapshot health, audited source inspection (public listing identity, source price
 * and version, capture time and recorded geography — never stock, Buyer coordinates, tax evidence or quotations) and
 * reviewed corrections. A correction appends a replacement revision that copies the original observations except the
 * proven-invalid ones, supersedes the selected run and keeps every original observation untouched.
 */
final class MaterialsAnalyticsAdminService
{
    public function __construct(private readonly MaterialPriceCaptureService $capture, private readonly CatalogAccess $keys, private readonly AuditRecorder $audit) {}

    /** @return list<array<string, mixed>> */
    public function runs(int $limit = 30): array
    {
        $dataset = AnalyticsDataset::active();

        return DB::table('analytics_refresh_runs')->where('kind', AnalyticsDataset::KIND)->where('environment', $dataset['environment'])->where('dataset_id', $dataset['dataset_id'])
            ->orderByDesc('snapshot_date')->orderByDesc('revision')->limit($limit)->get()->map(static fn (object $run): array => [
                'id' => (string) $run->id, 'snapshot_date' => (string) $run->snapshot_date, 'revision' => (int) $run->revision, 'state' => $run->state, 'error_code' => $run->error_code,
                'observed_at' => $run->observed_at === null ? null : CarbonImmutable::parse((string) $run->observed_at)->toIso8601String(),
                'published_at' => $run->published_at === null ? null : CarbonImmutable::parse((string) $run->published_at)->toIso8601String(),
                'observations' => (int) $run->source_count, 'selected' => (int) $run->selected_count, 'vendors' => (int) $run->selected_vendor_count,
                'delayed' => $run->observed_at !== null && CarbonImmutable::parse((string) $run->observed_at)->setTimezone('Asia/Manila')->format('H:i') > '00:10',
                'reviewer_reason' => $run->reviewer_reason,
            ])->all();
    }

    /**
     * @param  array{snapshot_date: string, reason: string, psgc_code?: ?string}  $input
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function sources(Request $request, string $groupId, array $input): array
    {
        $dataset = AnalyticsDataset::active();
        $run = $this->capture->publishedRun($dataset['environment'], $dataset['dataset_id'], $input['snapshot_date']);
        if ($run === null) {
            throw new AuthenticationException('SNAPSHOT_NOT_FOUND', 'No published snapshot exists for this date.', 404);
        }
        $query = DB::table('price_observations as po')->join('vendor_organizations as o', 'o.id', '=', 'po.vendor_organization_id')->join('vendor_listings as l', 'l.id', '=', 'po.vendor_listing_id')
            ->join('listing_variants as v', 'v.id', '=', 'po.listing_variant_id')->join('listing_price_versions as pv', 'pv.id', '=', 'po.listing_price_version_id')
            ->where('po.analytics_refresh_run_id', $run->id)->where('po.comparable_group_id', $groupId);
        if (($input['psgc_code'] ?? null) !== null) {
            $code = $input['psgc_code'];
            $query->where(fn ($q) => $q->where('po.psgc_region_code', $code)->orWhere('po.psgc_province_code', $code)->orWhere('po.psgc_city_code', $code));
        }
        $rows = $query->orderBy('o.store_name')->orderBy('po.listing_variant_id')->limit(500)->get(['po.id', 'o.store_name', 'l.id as listing_id', 'l.display_name', 'v.label as variant_label',
            'pv.version as price_version', 'po.ordinary_payable_centavos', 'po.normalized_php_price', 'po.tax_category', 'po.observed_at', 'po.price_effective_at', 'po.selected_for_average',
            'po.exclusion_reason', 'po.psgc_region_code', 'po.psgc_province_code', 'po.psgc_city_code']);
        $this->audit->account($request, 'MATERIALS_ANALYTICS_SOURCES_INSPECTED', 'MATERIAL_COMPARABLE_GROUP', $groupId, after: ['snapshot_date' => $input['snapshot_date'], 'psgc_code' => $input['psgc_code'] ?? null,
            'run_id' => (string) $run->id, 'rows' => $rows->count()], reason: $input['reason']);

        return ['items' => $rows->map(static fn (object $row): array => [
            'observation_id' => (string) $row->id, 'store_name' => (string) $row->store_name, 'listing_id' => (string) $row->listing_id, 'display_name' => (string) $row->display_name,
            'variant_label' => $row->variant_label, 'price_version' => (int) $row->price_version, 'ordinary_payable_centavos' => (int) $row->ordinary_payable_centavos,
            'normalized_php_exact' => (string) $row->normalized_php_price, 'tax_category' => (string) $row->tax_category,
            'captured_at' => CarbonImmutable::parse((string) $row->observed_at)->toIso8601String(), 'price_effective_at' => $row->price_effective_at === null ? null : CarbonImmutable::parse((string) $row->price_effective_at)->toIso8601String(),
            'selected_for_average' => (bool) $row->selected_for_average, 'exclusion_reason' => $row->exclusion_reason,
            'geography' => ['region_code' => $row->psgc_region_code, 'province_code' => $row->psgc_province_code, 'city_code' => $row->psgc_city_code],
        ])->all(), 'meta' => ['run_id' => (string) $run->id, 'revision' => (int) $run->revision, 'snapshot_date' => $input['snapshot_date'], 'dataset' => $dataset['label']]];
    }

    /**
     * @param  array{excluded_observation_ids: list<string>, reason: string}  $input
     * @return array<string, mixed>
     */
    public function correct(Request $request, string $runId, array $input): array
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $result = DB::transaction(function () use ($request, $runId, $input, $key): ?array {
            if ($this->keys->replayed($request, 'MATERIAL_PRICE_CORRECTION', $key, $runId)) {
                return null;
            }
            $original = DB::table('analytics_refresh_runs')->where('id', $runId)->lockForUpdate()->first();
            $pointer = $original === null ? null : DB::table('analytics_published_runs')->where('analytics_refresh_run_id', $original->id)->lockForUpdate()->first();
            if ($original === null || $pointer === null || $original->state !== 'PUBLISHED') {
                throw new AuthenticationException('SNAPSHOT_NOT_CORRECTABLE', 'Only the currently selected published snapshot can be corrected.', 409);
            }
            $excluded = array_values(array_unique($input['excluded_observation_ids']));
            $sources = DB::table('price_observations')->where('analytics_refresh_run_id', $original->id)->orderBy('vendor_organization_id')->orderBy('listing_variant_id')->get();
            if (count(array_intersect($excluded, $sources->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all())) !== count($excluded)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Every excluded observation must belong to this snapshot.', 422);
            }
            $revision = (int) DB::table('analytics_refresh_runs')->where('kind', $original->kind)->where('environment', $original->environment)->where('dataset_id', $original->dataset_id)
                ->where('snapshot_date', $original->snapshot_date)->max('revision') + 1;
            $run = $this->capture->openRun((string) $original->environment, (string) $original->dataset_id, (string) $original->snapshot_date, CarbonImmutable::parse((string) $original->observed_at),
                $revision, (string) $original->id, $input['reason'], (int) $request->user()->getKey());
            $rows = $sources->reject(static fn (object $row): bool => in_array((string) $row->id, $excluded, true))->map(static fn (object $row): array => [
                'listing_variant_id' => (string) $row->listing_variant_id, 'vendor_listing_id' => (string) $row->vendor_listing_id, 'vendor_organization_id' => (string) $row->vendor_organization_id,
                'listing_price_version_id' => (string) $row->listing_price_version_id, 'price_effective_at' => (string) $row->price_effective_at, 'ordinary_payable_centavos' => (int) $row->ordinary_payable_centavos,
                'normalized_php_price' => (string) $row->normalized_php_price, 'tax_category' => (string) $row->tax_category, 'comparable_group_version_id' => (string) $row->comparable_group_version_id,
                'comparable_group_id' => (string) $row->comparable_group_id, 'unit_conversion_version' => (string) $row->unit_conversion_version, 'stock_confirmed_at' => $row->stock_confirmed_at,
                'vendor_address_version_id' => (string) $row->vendor_address_version_id, 'address_version' => (int) $row->address_version,
                'psgc_region_code' => $row->psgc_region_code, 'psgc_province_code' => $row->psgc_province_code, 'psgc_city_code' => $row->psgc_city_code,
            ])->values()->all();
            $published = $this->capture->publish($run, $this->capture->stage($run, $rows, CarbonImmutable::parse((string) $original->observed_at), (string) $original->snapshot_date, (string) $original->environment, (string) $original->dataset_id));
            $this->keys->claim($request, 'MATERIAL_PRICE_CORRECTION', $key, $runId, 200);
            $this->audit->account($request, 'MATERIAL_PRICE_SNAPSHOT_CORRECTED', 'ANALYTICS_REFRESH_RUN', (string) $original->id, ['revision' => (int) $original->revision],
                ['revision' => $revision, 'run_id' => $published['run_id'], 'excluded_observations' => count($excluded)], reason: $input['reason']);

            return $published;
        });
        AnalyticsDataset::bump();

        return $result ?? ['state' => 'REPLAYED'];
    }
}
