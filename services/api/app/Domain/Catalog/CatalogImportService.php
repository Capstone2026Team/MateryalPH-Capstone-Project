<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Bulk spreadsheet import (CSV). Upload validates every row and applies
 * nothing. Apply creates DRAFT listings from the validated rows in one
 * transaction; rejected rows are reported and never counted as success.
 * Imported listings are never published automatically.
 */
final class CatalogImportService
{
    public const TEMPLATE_VERSION = 'catalog-import.v1';

    public const COLUMNS = ['vendor_sku', 'display_name', 'material_code', 'other_label', 'category_code', 'tag_codes', 'brand', 'description', 'variant_sku', 'variant_label', 'unit_code', 'pack_quantity', 'price_php', 'tax_category', 'tax_basis', 'weight_kg', 'length_cm', 'width_cm', 'height_cm', 'quantity_on_hand'];

    public const REQUIRED = ['vendor_sku', 'display_name', 'variant_sku', 'unit_code', 'pack_quantity', 'price_php', 'tax_category'];

    public const MAX_ROWS = 500;

    public function __construct(
        private readonly CatalogAccess $access,
        private readonly CatalogFileStore $files,
        private readonly VendorCatalogService $catalog,
        private readonly ListingTaxPolicy $tax,
        private readonly RentalServicePolicy $rental,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> */
    public function upload(Request $request, UploadedFile $file): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        DB::transaction(fn () => $this->access->lockActiveStore($organizationId));
        $path = $file->getRealPath();
        $mime = $path === false ? false : (new \finfo(FILEINFO_MIME_TYPE))->file($path);
        $maxKb = (int) config('materyalph.catalog.max_import_kb', 2048);
        if ($path === false || strtolower($file->getClientOriginalExtension()) !== 'csv' || ! in_array($mime, ['text/csv', 'text/plain', 'application/csv'], true) || $file->getSize() > $maxKb * 1024) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a CSV file up to '.intdiv($maxKb, 1024).' MB using the catalog template.', 422, ['accepted_types' => ['text/csv'], 'max_kb' => $maxKb]);
        }
        [$header, $rows] = $this->read($path);
        $missing = array_values(array_diff(self::REQUIRED, $header));
        if ($missing !== []) {
            throw new AuthenticationException('IMPORT_TEMPLATE_INVALID', 'The CSV header does not match the catalog template.', 422, ['missing_columns' => $missing, 'template_columns' => self::COLUMNS]);
        }
        $validated = $this->validateRows($organizationId, $header, $rows);
        $fileId = $this->files->store($file, 'VENDOR_ORGANIZATION', $organizationId, CatalogFileStore::CATALOG_IMPORT, (int) $request->user()->getKey(), 'text/csv');
        $jobId = (string) Str::uuid7();
        $valid = count(array_filter($validated, static fn (array $row): bool => $row['errors'] === []));
        DB::transaction(function () use ($request, $organizationId, $jobId, $fileId, $validated, $valid): void {
            DB::table('catalog_import_jobs')->insert(['id' => $jobId, 'vendor_organization_id' => $organizationId, 'uploaded_by_user_id' => $request->user()->getKey(), 'file_id' => $fileId, 'status' => $valid === count($validated) ? 'VALIDATED' : 'HAS_ERRORS', 'template_version' => self::TEMPLATE_VERSION, 'total_rows' => count($validated), 'valid_rows' => $valid, 'error_rows' => count($validated) - $valid, 'created_at' => now(), 'updated_at' => now()]);
            foreach (array_chunk($validated, 200) as $chunk) {
                DB::table('catalog_import_rows')->insert(array_map(static fn (array $row): array => ['id' => (string) Str::uuid7(), 'catalog_import_job_id' => $jobId, 'row_number' => $row['row_number'], 'vendor_sku' => Str::limit((string) ($row['payload']['vendor_sku'] ?? ''), 96, ''), 'variant_sku' => Str::limit((string) ($row['payload']['variant_sku'] ?? ''), 96, ''), 'payload' => json_encode($row['payload'], JSON_THROW_ON_ERROR), 'errors' => $row['errors'] === [] ? null : json_encode($row['errors'], JSON_THROW_ON_ERROR), 'status' => $row['errors'] === [] ? 'VALID' : 'INVALID', 'created_at' => now(), 'updated_at' => now()], $chunk));
            }
            $this->audit->account($request, 'CATALOG_IMPORT_VALIDATED', 'CATALOG_IMPORT_JOB', $jobId, after: ['rows' => count($validated), 'valid_rows' => $valid]);
        });

        return $this->job($request, $jobId, 1);
    }

    /** @return array<string, mixed> */
    public function job(Request $request, string $jobId, int $page): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        $job = DB::table('catalog_import_jobs')->where('id', $jobId)->where('vendor_organization_id', $organizationId)->first();
        if ($job === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The import is unavailable.', 404);
        }
        $rows = DB::table('catalog_import_rows')->where('catalog_import_job_id', $jobId)->where('status', 'INVALID')->orderBy('row_number')->paginate(50, ['row_number', 'vendor_sku', 'variant_sku', 'errors'], 'page', $page);

        return [
            'id' => $job->id, 'status' => $job->status, 'template_version' => $job->template_version, 'total_rows' => (int) $job->total_rows, 'valid_rows' => (int) $job->valid_rows,
            'error_rows' => (int) $job->error_rows, 'applied_rows' => (int) $job->applied_rows, 'applied_at' => $job->applied_at, 'created_at' => $job->created_at,
            'row_errors' => array_map(static fn (object $row): array => ['row_number' => (int) $row->row_number, 'vendor_sku' => $row->vendor_sku, 'variant_sku' => $row->variant_sku, 'errors' => ComparableMappingService::decode($row->errors)], $rows->items()),
            'row_errors_meta' => ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total()],
        ];
    }

    /**
     * Applies every validated row in one transaction. Any failure applies nothing.
     *
     * @return array<string, mixed>
     */
    public function apply(Request $request, string $jobId): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        $key = $this->access->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $jobId, $key): void {
            $this->access->lockActiveStore($organizationId);
            $job = DB::table('catalog_import_jobs')->where('id', $jobId)->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
            if ($job === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The import is unavailable.', 404);
            }
            if ($this->access->replayed($request, 'catalog.imports.apply', $key, $jobId)) {
                return;
            }
            if (! in_array($job->status, ['VALIDATED', 'HAS_ERRORS'], true)) {
                throw new AuthenticationException('IMPORT_ALREADY_APPLIED', 'This import was already applied.', 409);
            }
            if ((int) $job->valid_rows === 0) {
                throw new AuthenticationException('IMPORT_NO_VALID_ROWS', 'No row passed validation. Correct the file and upload it again.', 422);
            }
            $rows = DB::table('catalog_import_rows')->where('catalog_import_job_id', $jobId)->where('status', 'VALID')->orderBy('row_number')->get();
            // Revalidate under the organization lock: the catalog may have changed since upload.
            $payloads = $rows->map(fn (object $row): array => ComparableMappingService::decode($row->payload))->all();
            $current = $this->validateRows($organizationId, self::COLUMNS, array_map(fn (array $payload): array => array_map(fn (string $column): string => (string) ($payload[$column] ?? ''), self::COLUMNS), $payloads), $rows->pluck('row_number')->all());
            $stale = array_filter($current, static fn (array $row): bool => $row['errors'] !== []);
            if ($stale !== []) {
                throw new AuthenticationException('IMPORT_REVALIDATION_FAILED', 'Some rows are no longer valid because the catalog changed. Upload the file again.', 409, ['rows' => array_values(array_map(static fn (array $row): array => ['row_number' => $row['row_number'], 'errors' => $row['errors']], $stale))]);
            }
            $applied = 0;
            foreach (collect($current)->groupBy(fn (array $row): string => strtoupper((string) $row['payload']['vendor_sku'])) as $group) {
                $listingId = $this->createListing($request, $organizationId, $group->all());
                DB::table('catalog_import_rows')->where('catalog_import_job_id', $jobId)->whereIn('row_number', $group->pluck('row_number'))->update(['status' => 'APPLIED', 'vendor_listing_id' => $listingId, 'updated_at' => now()]);
                $applied += $group->count();
            }
            DB::table('catalog_import_jobs')->where('id', $jobId)->update(['status' => (int) $job->error_rows === 0 ? 'APPLIED' : 'APPLIED_WITH_REJECTIONS', 'applied_rows' => $applied, 'applied_by_user_id' => $request->user()->getKey(), 'applied_at' => now(), 'updated_at' => now()]);
            $this->access->claim($request, 'catalog.imports.apply', $key, $jobId, 200);
            $this->audit->account($request, 'CATALOG_IMPORT_APPLIED', 'CATALOG_IMPORT_JOB', $jobId, after: ['applied_rows' => $applied, 'rejected_rows' => (int) $job->error_rows]);
        });

        return $this->job($request, $jobId, 1);
    }

    /**
     * @param  list<string>  $header
     * @param  list<list<string>>  $rows
     * @param  list<int>|null  $rowNumbers
     * @return list<array{row_number: int, payload: array<string, string>, errors: array<string, list<string>>}>
     */
    private function validateRows(string $organizationId, array $header, array $rows, ?array $rowNumbers = null): array
    {
        $units = DB::table('units')->pluck('id', 'code')->all();
        $materials = DB::table('materials')->where('active', true)->get(['id', 'code', 'material_category_id', 'regulated'])->keyBy('code');
        $categories = DB::table('material_categories')->where('active', true)->pluck('id', 'code')->all();
        $tags = DB::table('material_tags')->pluck('id', 'code')->all();
        $compatible = DB::table('material_compatible_units')->get(['material_id', 'unit_id'])->groupBy('material_id')->map(fn ($items) => $items->pluck('unit_id')->all());
        $existingSkus = DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->pluck('vendor_sku')->flip();
        $allowedTax = $this->tax->allowedCategories($organizationId);
        $variantSkus = [];
        $listingNames = [];
        $result = [];
        foreach ($rows as $index => $cells) {
            $payload = [];
            foreach (self::COLUMNS as $column) {
                $position = array_search($column, $header, true);
                $payload[$column] = $position === false ? '' : trim(Str::limit((string) ($cells[$position] ?? ''), 500, ''));
            }
            $errors = [];
            $error = static function (string $field, string $message) use (&$errors): void {
                $errors[$field][] = $message;
            };
            foreach (self::REQUIRED as $field) {
                if ($payload[$field] === '') {
                    $error($field, 'Required.');
                }
            }
            $vendorSku = strtoupper((string) preg_replace('/\s+/', '-', $payload['vendor_sku']));
            $variantSku = strtoupper((string) preg_replace('/\s+/', '-', $payload['variant_sku']));
            if ($vendorSku !== '' && $existingSkus->has($vendorSku)) {
                $error('vendor_sku', 'A listing with this Vendor SKU already exists.');
            }
            if ($vendorSku !== '' && $variantSku !== '') {
                if (isset($variantSkus[$vendorSku.'|'.$variantSku])) {
                    $error('variant_sku', 'Duplicate variant SKU for this listing in the file.');
                }
                $variantSkus[$vendorSku.'|'.$variantSku] = true;
                if (isset($listingNames[$vendorSku]) && $listingNames[$vendorSku] !== $payload['display_name']) {
                    $error('display_name', 'Rows of the same Vendor SKU must share one display name.');
                }
                $listingNames[$vendorSku] ??= $payload['display_name'];
            }
            foreach (['display_name', 'other_label'] as $field) {
                if ($payload[$field] !== '' && $this->rental->describesRental($payload[$field])) {
                    $error($field, RentalServicePolicy::MESSAGE);
                }
            }
            $material = $payload['material_code'] === '' ? null : ($materials[strtoupper($payload['material_code'])] ?? null);
            if ($payload['material_code'] !== '' && $material === null) {
                $error('material_code', 'Unknown canonical material code.');
            }
            if ($material === null && $payload['material_code'] === '' && ($payload['other_label'] === '' || $payload['category_code'] === '')) {
                $error('material_code', 'Provide a material code, or an Other label with a category code.');
            }
            if ($payload['other_label'] !== '' && (mb_strlen($payload['other_label']) < 2 || mb_strlen($payload['other_label']) > 60)) {
                $error('other_label', 'Use 2–60 characters.');
            }
            if ($payload['category_code'] !== '' && ! isset($categories[strtoupper($payload['category_code'])])) {
                $error('category_code', 'Unknown category code.');
            }
            if ($material !== null && $payload['category_code'] !== '' && ($categories[strtoupper($payload['category_code'])] ?? null) !== $material->material_category_id) {
                $error('category_code', 'The category must match the material.');
            }
            $tagCodes = array_values(array_filter(array_map('trim', explode(';', strtoupper($payload['tag_codes'])))));
            if (count($tagCodes) > 3 || array_diff($tagCodes, array_keys($tags)) !== []) {
                $error('tag_codes', 'Use up to three approved tag codes separated by semicolons.');
            }
            $unitId = $units[strtoupper($payload['unit_code'])] ?? null;
            if ($payload['unit_code'] !== '' && $unitId === null) {
                $error('unit_code', 'Unknown unit code.');
            } elseif ($material !== null && $unitId !== null && ($compatible[$material->id] ?? []) !== [] && ! in_array($unitId, $compatible[$material->id], true)) {
                $error('unit_code', 'This unit is not compatible with the material.');
            }
            if ($payload['pack_quantity'] !== '' && (! is_numeric($payload['pack_quantity']) || (float) $payload['pack_quantity'] <= 0)) {
                $error('pack_quantity', 'Enter a number greater than zero.');
            }
            if ($payload['price_php'] !== '' && self::centavos($payload['price_php']) === null) {
                $error('price_php', 'Enter a peso amount greater than zero with at most two decimals, e.g. 285.50.');
            }
            if ($payload['tax_category'] !== '') {
                if (! in_array($payload['tax_category'], ListingTaxPolicy::CATEGORIES, true)) {
                    $error('tax_category', 'Use VAT_12, VAT_ZERO, VAT_EXEMPT or NON_VAT.');
                } elseif ($allowedTax !== [] && ! in_array($payload['tax_category'], $allowedTax, true)) {
                    $error('tax_category', 'Not permitted by your reviewed VAT registration.');
                } elseif (in_array($payload['tax_category'], ListingTaxPolicy::BASIS_REQUIRED, true) && mb_strlen($payload['tax_basis']) < 3) {
                    $error('tax_basis', 'Zero-rated and exempt lines need their supporting basis.');
                }
            }
            foreach (['weight_kg', 'length_cm', 'width_cm', 'height_cm'] as $field) {
                if ($payload[$field] !== '' && (! is_numeric($payload[$field]) || (float) $payload[$field] <= 0)) {
                    $error($field, 'Enter a number greater than zero.');
                }
            }
            if ($payload['quantity_on_hand'] !== '' && preg_match('/^\d{1,14}(\.\d{1,4})?$/', $payload['quantity_on_hand']) !== 1) {
                $error('quantity_on_hand', 'Enter a counted quantity of zero or more, with up to four decimals.');
            }
            $result[] = ['row_number' => $rowNumbers[$index] ?? $index + 2, 'payload' => $payload, 'errors' => $errors];
        }

        return $result;
    }

    /** @param list<array{row_number: int, payload: array<string, string>, errors: array<string, list<string>>}> $group */
    private function createListing(Request $request, string $organizationId, array $group): string
    {
        $first = $group[0]['payload'];
        $material = $first['material_code'] === '' ? null : DB::table('materials')->where('code', strtoupper($first['material_code']))->first(['id', 'material_category_id']);
        $categoryId = $material !== null ? $material->material_category_id : DB::table('material_categories')->where('code', strtoupper($first['category_code']))->value('id');
        $productId = DB::table('products')->insertGetId(['name' => $first['display_name'], 'public_id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'material_id' => $material?->id, 'brand' => $first['brand'] === '' ? null : $first['brand'], 'created_at' => now(), 'updated_at' => now()]);
        $listingId = (string) Str::uuid7();
        $rule = $material === null ? null : $this->catalog->currentRule((string) $material->id);
        DB::table('vendor_listings')->insert(['id' => $listingId, 'vendor_organization_id' => $organizationId, 'product_id' => $productId, 'vendor_sku' => strtoupper((string) preg_replace('/\s+/', '-', $first['vendor_sku'])), 'display_name' => $first['display_name'], 'description' => $first['description'] === '' ? null : $first['description'], 'material_category_id' => $categoryId, 'material_match' => $material === null ? 'UNMATCHED' : 'EXACT', 'other_label' => $material === null ? $first['other_label'] : null, 'regulated' => $rule !== null, 'regulated_material_rule_id' => $rule['id'] ?? null, 'compliance_status' => $rule === null ? 'NOT_REQUIRED' : 'NOT_SUBMITTED', 'status' => 'DRAFT', 'created_by_user_id' => $request->user()->getKey(), 'updated_by_user_id' => $request->user()->getKey(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('listing_status_history')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'from_status' => null, 'to_status' => 'DRAFT', 'actor_user_id' => $request->user()->getKey(), 'source' => 'IMPORT', 'reason_code' => 'BULK_IMPORT', 'created_at' => now(), 'updated_at' => now()]);
        foreach (array_filter(array_map('trim', explode(';', strtoupper($first['tag_codes'])))) as $tagCode) {
            DB::table('listing_tag_links')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'material_tag_id' => DB::table('material_tags')->where('code', $tagCode)->value('id'), 'created_at' => now(), 'updated_at' => now()]);
        }
        $variants = array_map(static fn (array $row): array => array_filter([
            'sku' => $row['payload']['variant_sku'], 'label' => $row['payload']['variant_label'] ?: null, 'unit_id' => DB::table('units')->where('code', strtoupper($row['payload']['unit_code']))->value('id'),
            'pack_quantity' => $row['payload']['pack_quantity'], 'price_centavos' => self::centavos($row['payload']['price_php']), 'tax_category' => $row['payload']['tax_category'],
            'tax_basis' => $row['payload']['tax_basis'] ?: null, 'weight_kg' => $row['payload']['weight_kg'] ?: null, 'length_cm' => $row['payload']['length_cm'] ?: null,
            'width_cm' => $row['payload']['width_cm'] ?: null, 'height_cm' => $row['payload']['height_cm'] ?: null, 'quantity_on_hand' => $row['payload']['quantity_on_hand'] === '' ? null : $row['payload']['quantity_on_hand'],
        ], static fn ($value): bool => $value !== null), $group);
        $this->catalog->saveVariants($request, $listingId, ['lock_version' => 1, 'variants' => $variants]);

        return $listingId;
    }

    /** Converts a peso string to integer centavos without binary floating point. */
    public static function centavos(string $value): ?int
    {
        $value = str_replace(',', '', trim($value));
        if (preg_match('/^(\d{1,12})(?:\.(\d{1,2}))?$/', $value, $parts) !== 1) {
            return null;
        }
        $centavos = (int) $parts[1] * 100 + (int) str_pad($parts[2] ?? '0', 2, '0');

        return $centavos > 0 ? $centavos : null;
    }

    /** @return array{0: list<string>, 1: list<list<string>>} */
    private function read(string $path): array
    {
        $handle = fopen($path, 'rb');
        if ($handle === false) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The CSV could not be read.', 422);
        }
        $header = null;
        $rows = [];
        try {
            while (($cells = fgetcsv($handle, 0, ',', '"', '')) !== false) {
                if ($header === null) {
                    $header = array_map(static fn ($cell): string => strtolower(trim((string) preg_replace('/^\xEF\xBB\xBF/', '', (string) $cell))), $cells);

                    continue;
                }
                if (count(array_filter($cells, static fn ($cell): bool => trim((string) $cell) !== '')) === 0) {
                    continue;
                }
                if (count($rows) >= self::MAX_ROWS) {
                    throw new AuthenticationException('IMPORT_TOO_LARGE', 'A catalog import can contain up to '.self::MAX_ROWS.' rows.', 422);
                }
                // Neutralize spreadsheet formula prefixes so values echoed back cannot execute as formulas.
                $rows[] = array_map(static fn ($cell): string => ltrim((string) $cell, "=+@\t\r"), $cells);
            }
        } finally {
            fclose($handle);
        }

        return [$header ?? [], $rows];
    }
}
