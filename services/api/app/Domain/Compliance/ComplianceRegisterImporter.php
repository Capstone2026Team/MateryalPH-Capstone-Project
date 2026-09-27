<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Imports a CSV snapshot of a DTI-BPS register (PS licensees or ICC
 * certificates). The government maintains these lists; each import is a new
 * immutable, dated snapshot that must be explicitly activated before matching
 * uses it. Header names are recognised by alias so an exported sheet can be
 * uploaded without editing.
 */
final class ComplianceRegisterImporter
{
    public const KINDS = ['PS_LICENSE', 'ICC_CERTIFICATE'];

    public const MAX_ROWS = 100_000;

    private const ALIASES = [
        'number' => ['ps license no', 'ps license number', 'ps licence no', 'license no', 'license number', 'licence no', 'licence number', 'ps no', 'icc no', 'icc number', 'icc certificate no', 'icc certificate number', 'icc cert no', 'certificate no', 'certificate number', 'soc no', 'soc number'],
        'company' => ['company', 'company name', 'licensee', 'name of licensee', 'licensee name', 'name of company', 'manufacturer', 'manufacturer name', 'name of manufacturer', 'importer', 'importer name', 'name of importer', 'certificate holder', 'firm name', 'name of firm'],
        'product' => ['product', 'products', 'product description', 'product name', 'commodity', 'product covered', 'products covered'],
        'standard' => ['standard', 'standards', 'reference standard', 'pns', 'product standard', 'pns no', 'standard specification'],
        'brand' => ['brand', 'brand name', 'brands', 'trade name', 'brand trade name', 'trademark'],
        'address' => ['address', 'company address', 'factory address', 'plant address', 'business address'],
        'issued' => ['date issued', 'issue date', 'date of issuance', 'issuance date', 'date granted'],
        'expires' => ['expiry date', 'expiration date', 'valid until', 'validity', 'date of expiry', 'validity date', 'expiry'],
    ];

    public function __construct(private readonly CatalogFileStore $files) {}

    /** @return array{id: string, register_kind: string, snapshot_date: string, status: string, row_count: int, rejected_row_count: int, column_mapping: array<string, string>, rejected_rows: list<array{row_number: int, reason: string}>} */
    public function import(UploadedFile $file, string $kind, string $sourceReference, string $snapshotDate, int $actorId): array
    {
        if (! in_array($kind, self::KINDS, true)) {
            throw new AuthenticationException('REGISTER_KIND_INVALID', 'Choose the PS licensee or ICC certificate register.', 422);
        }
        $path = $file->getRealPath();
        $mime = $path === false ? false : (new \finfo(FILEINFO_MIME_TYPE))->file($path);
        if ($path === false || strtolower($file->getClientOriginalExtension()) !== 'csv' || ! in_array($mime, ['text/csv', 'text/plain', 'application/csv'], true)) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload the register as a CSV file (File → Download → CSV).', 422);
        }
        $handle = fopen($path, 'rb');
        if ($handle === false) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The register file could not be read.', 422);
        }
        $mapping = null;
        $rows = [];
        $rejected = [];
        $line = 0;
        try {
            while (($cells = fgetcsv($handle, 0, ',', '"', '')) !== false) {
                $line++;
                if ($line === 1 && isset($cells[0])) {
                    $cells[0] = (string) preg_replace('/^\xEF\xBB\xBF/', '', (string) $cells[0]);
                }
                if ($mapping === null) {
                    $mapping = $line <= 25 ? $this->detectHeader($cells) : null;
                    if ($mapping === null && $line >= 25) {
                        break;
                    }

                    continue;
                }
                if (count(array_filter($cells, static fn ($cell): bool => trim((string) $cell) !== '')) === 0) {
                    continue;
                }
                if (count($rows) + count($rejected) >= self::MAX_ROWS) {
                    throw new AuthenticationException('REGISTER_TOO_LARGE', 'The register exceeds '.self::MAX_ROWS.' rows. Split it and import again.', 422);
                }
                $value = static fn (string $field): ?string => isset($mapping[$field]) ? (trim(Str::limit((string) ($cells[$mapping[$field]] ?? ''), 600, '')) ?: null) : null;
                $number = RegisterNormalizer::number((string) $value('number'));
                $company = (string) $value('company');
                if ($number === '' || RegisterNormalizer::company($company) === '') {
                    $rejected[] = ['row_number' => $line, 'reason' => $number === '' ? 'Missing licence or certificate number.' : 'Missing company name.'];

                    continue;
                }
                $rows[] = [
                    'row_number' => $line, 'record_number' => Str::limit($number, 120, ''), 'record_number_display' => Str::limit((string) $value('number'), 160, ''),
                    'company_name' => Str::limit($company, 300, ''), 'normalized_company' => Str::limit(RegisterNormalizer::company($company), 300, ''),
                    'product_description' => $value('product'), 'reference_standard' => $value('standard') === null ? null : Str::limit((string) $value('standard'), 160, ''),
                    'brand' => $value('brand') === null ? null : Str::limit((string) $value('brand'), 200, ''), 'address' => $value('address'),
                    'issued_on' => $this->date($value('issued')), 'expires_on' => $this->date($value('expires')),
                ];
            }
        } finally {
            fclose($handle);
        }
        if ($mapping === null) {
            throw new AuthenticationException('REGISTER_HEADER_NOT_FOUND', 'The CSV needs a header row with a licence/certificate number column and a company column.', 422, ['recognised_number_headers' => self::ALIASES['number'], 'recognised_company_headers' => self::ALIASES['company']]);
        }
        if ($rows === []) {
            throw new AuthenticationException('REGISTER_EMPTY', 'The register has no usable rows.', 422, ['rejected_rows' => array_slice($rejected, 0, 50)]);
        }
        $fileId = $this->files->store($file, 'PLATFORM', '00000000-0000-0000-0000-000000000000', CatalogFileStore::COMPLIANCE_REGISTER, $actorId, 'text/csv');
        $registerId = (string) Str::uuid7();
        $columns = array_map(static fn (int $index): string => (string) $index, $mapping);
        DB::transaction(function () use ($registerId, $kind, $sourceReference, $snapshotDate, $rows, $rejected, $columns, $fileId, $actorId, $path): void {
            DB::table('compliance_reference_registers')->insert(['id' => $registerId, 'register_kind' => $kind, 'source_reference' => Str::limit($sourceReference, 500, ''), 'snapshot_date' => $snapshotDate, 'status' => 'DRAFT', 'row_count' => count($rows), 'rejected_row_count' => count($rejected), 'column_mapping' => json_encode($columns, JSON_THROW_ON_ERROR), 'content_hash' => (string) hash_file('sha256', $path), 'file_id' => $fileId, 'imported_by_user_id' => $actorId, 'created_at' => now(), 'updated_at' => now()]);
            foreach (array_chunk($rows, 500) as $chunk) {
                DB::table('compliance_reference_records')->insert(array_map(static fn (array $row): array => $row + ['id' => (string) Str::uuid7(), 'compliance_reference_register_id' => $registerId, 'created_at' => now(), 'updated_at' => now()], $chunk));
            }
        });

        return ['id' => $registerId, 'register_kind' => $kind, 'snapshot_date' => $snapshotDate, 'status' => 'DRAFT', 'row_count' => count($rows), 'rejected_row_count' => count($rejected), 'column_mapping' => $columns, 'rejected_rows' => array_slice($rejected, 0, 50)];
    }

    /** Activates a draft snapshot and supersedes the previous active snapshot of the same kind atomically. */
    public function activate(string $registerId, int $actorId): object
    {
        return DB::transaction(function () use ($registerId, $actorId): object {
            $register = DB::table('compliance_reference_registers')->where('id', $registerId)->lockForUpdate()->first();
            if ($register === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The register snapshot is unavailable.', 404);
            }
            if ($register->status !== 'DRAFT') {
                throw new AuthenticationException('REGISTER_NOT_DRAFT', 'Only an imported draft snapshot can be activated.', 409);
            }
            DB::table('compliance_reference_registers')->where('register_kind', $register->register_kind)->where('status', 'ACTIVE')->lockForUpdate()->update(['status' => 'SUPERSEDED', 'superseded_at' => now(), 'updated_at' => now()]);
            DB::table('compliance_reference_registers')->where('id', $registerId)->update(['status' => 'ACTIVE', 'activated_at' => now(), 'activated_by_user_id' => $actorId, 'updated_at' => now()]);

            return DB::table('compliance_reference_registers')->where('id', $registerId)->first();
        });
    }

    /**
     * @param  list<string|null>  $cells
     * @return array<string, int>|null
     */
    private function detectHeader(array $cells): ?array
    {
        $mapping = [];
        foreach ($cells as $index => $cell) {
            $header = trim((string) preg_replace('/[^a-z0-9]+/', ' ', strtolower(Str::ascii((string) $cell))));
            foreach (self::ALIASES as $field => $aliases) {
                if (! isset($mapping[$field]) && in_array($header, $aliases, true)) {
                    $mapping[$field] = $index;
                    break;
                }
            }
        }

        return isset($mapping['number'], $mapping['company']) ? $mapping : null;
    }

    private function date(?string $value): ?string
    {
        if ($value === null) {
            return null;
        }
        foreach (['Y-m-d', 'm/d/Y', 'n/j/Y', 'd-M-Y', 'd-M-y', 'F j, Y', 'M j, Y', 'd/m/Y'] as $format) {
            $date = CarbonImmutable::createFromFormat('!'.$format, $value);
            if ($date instanceof CarbonImmutable && $date->format($format) === $value) {
                return $date->toDateString();
            }
        }

        return null;
    }
}
