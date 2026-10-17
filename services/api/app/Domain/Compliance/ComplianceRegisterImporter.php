<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Generator;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use LogicException;
use Pdo\Pgsql;

/**
 * Imports a snapshot of a DTI-BPS register (List of PS Licensees, List of ICC
 * Certificate Holders) from CSV or XLSX. The government maintains these lists
 * and updates them monthly; each import is a new immutable, dated snapshot that
 * matching uses only once it is activated. Header names are recognised by alias
 * so the official layout imports without editing: title and note rows above the
 * header are skipped, and the ICC sticker serial range comes either from the
 * merged "ICC Sticker Serial No." heading spanning the from and to columns or
 * from separate "ICC Sticker Serial No. (From)" and "(To)" columns.
 */
final class ComplianceRegisterImporter
{
    public const KINDS = ['PS_LICENSE', 'ICC_CERTIFICATE'];

    public const MAX_ROWS = 100_000;

    private const HEADER_SEARCH_ROWS = 25;

    private const ALIASES = [
        'number' => ['ps license no', 'ps license number', 'ps licence no', 'license no', 'license number', 'licence no', 'licence number', 'ps no', 'icc no', 'icc number', 'icc certificate no', 'icc certificate number', 'icc cert no', 'certificate no', 'certificate number', 'soc no', 'soc number'],
        'company' => ['company', 'company name', 'licensee', 'name of licensee', 'licensee name', 'name of company', 'manufacturer', 'manufacturer name', 'name of manufacturer', 'importer', 'importer name', 'name of importer', 'certificate holder', 'firm name', 'name of firm'],
        'product' => ['product', 'products', 'product description', 'product name', 'commodity', 'product covered', 'products covered'],
        'standard' => ['standard', 'standards', 'reference standard', 'pns', 'product standard', 'pns no', 'standard specification'],
        'brand' => ['brand', 'brand name', 'brands', 'trade name', 'brand trade name', 'trademark'],
        'model' => ['model type', 'type model', 'model', 'models', 'model s', 'model no', 'model number'],
        'type' => ['type', 'types', 'product type'],
        'serial' => ['icc sticker serial no', 'icc sticker serial number', 'icc sticker serial', 'icc sticker no', 'icc sticker number', 'sticker serial no', 'sticker serial number', 'serial no', 'serial number', 'serial from', 'sticker serial from', 'icc sticker serial from', 'icc sticker serial no from', 'icc sticker serial number from', 'sticker serial no from', 'sticker serial number from', 'serial no from', 'serial number from'],
        'serial_to' => ['serial to', 'sticker serial to', 'icc sticker serial to', 'icc sticker serial no to', 'icc sticker serial number to', 'sticker serial no to', 'sticker serial number to', 'serial no to', 'serial number to'],
        'origin' => ['foreign local', 'local foreign', 'origin'],
        'region' => ['region if local', 'region'],
        'size' => ['size', 'sizes'],
        'class' => ['class', 'classification'],
        'address' => ['address', 'company address', 'factory address', 'plant address', 'business address'],
        'issued' => ['date issued', 'issue date', 'date of issuance', 'issuance date', 'date granted'],
        'expires' => ['expiry date', 'expiration date', 'valid until', 'validity', 'date of expiry', 'validity date', 'expiry'],
    ];

    /** Placeholder cells in the official lists that carry no value. */
    private const EMPTY_VALUES = ['N A', 'NA', 'NOT APPLICABLE', 'NOT INDICATED', 'NOT IDENTIFIED', 'NONE'];

    public function __construct(private readonly CatalogFileStore $files) {}

    /** @return array{id: string, register_kind: string, snapshot_date: string, status: string, row_count: int, rejected_row_count: int, serial_range_count: int, column_mapping: array<string, string>, rejected_rows: list<array{row_number: int, reason: string}>} */
    public function import(UploadedFile $file, string $kind, string $sourceReference, string $snapshotDate, ?int $actorId, string $channel = 'UPLOAD'): array
    {
        if (! in_array($kind, self::KINDS, true)) {
            throw new AuthenticationException('REGISTER_KIND_INVALID', 'Choose the PS licensee or ICC certificate register.', 422);
        }
        $path = $file->getRealPath();
        if ($path === false) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The register file could not be read.', 422);
        }
        $format = RegisterSpreadsheet::format($path, $file->getClientOriginalExtension());
        // Official registers run to tens of thousands of rows, so both passes stream:
        // the first validates and counts, the second inserts in chunks. No pass holds every row.
        $rowCount = 0;
        $rejectedCount = 0;
        $serialRanges = 0;
        $rejected = [];
        $records = $this->records($path, $format, $kind);
        foreach ($records as $record) {
            if (isset($record['reason'])) {
                $rejectedCount++;
                if (count($rejected) < 50) {
                    $rejected[] = $record;
                }

                continue;
            }
            $rowCount++;
            $serialRanges += $record['serial_prefix'] === null ? 0 : 1;
        }
        $mapping = $records->getReturn();
        if ($mapping === null) {
            throw new AuthenticationException('REGISTER_HEADER_NOT_FOUND', 'The file needs a header row with a licence/certificate number column and a company column within its first '.self::HEADER_SEARCH_ROWS.' rows.', 422, ['recognised_number_headers' => self::ALIASES['number'], 'recognised_company_headers' => self::ALIASES['company']]);
        }
        if ($rowCount === 0) {
            throw new AuthenticationException('REGISTER_EMPTY', 'The register has no usable rows.', 422, ['rejected_rows' => $rejected]);
        }
        if ($kind === 'ICC_CERTIFICATE' && $serialRanges === 0) {
            throw new AuthenticationException('REGISTER_SERIALS_NOT_FOUND', 'The ICC register needs "ICC Sticker Serial No. (From)" and "(To)" columns, or one merged "ICC Sticker Serial No." heading, with the from and to serial of each sticker range.', 422);
        }
        $fileId = $this->files->store($file, 'PLATFORM', '00000000-0000-0000-0000-000000000000', CatalogFileStore::COMPLIANCE_REGISTER, $actorId, $format === 'xlsx' ? RegisterSpreadsheet::XLSX_MIME : 'text/csv');
        $registerId = (string) Str::uuid7();
        $columns = array_map(static fn (int $index): string => (string) $index, $mapping);
        DB::transaction(function () use ($registerId, $kind, $sourceReference, $snapshotDate, $rowCount, $rejectedCount, $columns, $fileId, $actorId, $path, $format, $channel): void {
            DB::table('compliance_reference_registers')->insert(['id' => $registerId, 'register_kind' => $kind, 'source_reference' => Str::limit($sourceReference, 500, ''), 'snapshot_date' => $snapshotDate, 'status' => 'DRAFT', 'row_count' => $rowCount, 'rejected_row_count' => $rejectedCount, 'column_mapping' => json_encode($columns, JSON_THROW_ON_ERROR), 'content_hash' => (string) hash_file('sha256', $path), 'file_id' => $fileId, 'imported_by_user_id' => $actorId, 'source_channel' => $channel, 'created_at' => now(), 'updated_at' => now()]);
            $this->copyRecords($registerId, $this->records($path, $format, $kind));
        });

        return ['id' => $registerId, 'register_kind' => $kind, 'snapshot_date' => $snapshotDate, 'status' => 'DRAFT', 'row_count' => $rowCount, 'rejected_row_count' => $rejectedCount, 'serial_range_count' => $serialRanges, 'column_mapping' => $columns, 'rejected_rows' => $rejected];
    }

    /**
     * Bulk-loads the accepted records with PostgreSQL COPY in batches. A whole
     * register as parameterised INSERTs carries hundreds of thousands of
     * bindings that query listeners retain, which exhausts a request's memory.
     *
     * @param  iterable<array<string, mixed>>  $records
     */
    private function copyRecords(string $registerId, iterable $records): void
    {
        $pdo = DB::connection()->getPdo();
        if (! $pdo instanceof Pgsql) {
            throw new LogicException('Register import requires the PostgreSQL connection.');
        }
        $columns = ['id', 'compliance_reference_register_id', 'row_number', 'record_number', 'record_number_display', 'company_name', 'normalized_company', 'product_description', 'reference_standard', 'brand', 'address', 'model_type', 'issued_on', 'expires_on', 'serial_prefix', 'serial_from', 'serial_to', 'serial_digits', 'details', 'created_at', 'updated_at'];
        $now = now()->utc()->format('Y-m-d H:i:sP');
        $escape = static fn (mixed $value): string => $value === null ? '\N' : strtr((string) $value, ['\\' => '\\\\', "\t" => '\t', "\n" => '\n', "\r" => '\r']);
        $flush = static function (array $lines) use ($pdo, $columns): void {
            if ($lines !== []) {
                $pdo->copyFromArray('compliance_reference_records', $lines, "\t", '\\\\N', implode(', ', $columns));
            }
        };
        $lines = [];
        foreach ($records as $record) {
            if (isset($record['reason'])) {
                continue;
            }
            $record += ['id' => (string) Str::uuid7(), 'compliance_reference_register_id' => $registerId, 'created_at' => $now, 'updated_at' => $now];
            $lines[] = implode("\t", array_map(static fn (string $column): string => $escape($record[$column] ?? null), $columns));
            if (count($lines) === 1000) {
                $flush($lines);
                $lines = [];
            }
        }
        $flush($lines);
    }

    /**
     * Streams the register's data rows below the detected header: each one is
     * either a record ready to insert or a rejection with its reason. The
     * generator returns the column mapping, or null when no header was found.
     *
     * @return Generator<int, array<string, mixed>, mixed, array<string, int>|null>
     */
    private function records(string $path, string $format, string $kind): Generator
    {
        $mapping = null;
        $count = 0;
        foreach (RegisterSpreadsheet::rows($path, $format) as $line => $cells) {
            if ($mapping === null) {
                $mapping = $line <= self::HEADER_SEARCH_ROWS ? $this->detectHeader($cells) : null;
                if ($mapping === null && $line >= self::HEADER_SEARCH_ROWS) {
                    return null;
                }

                continue;
            }
            if (implode('', array_map('trim', $cells)) === '') {
                continue;
            }
            if (++$count > self::MAX_ROWS) {
                throw new AuthenticationException('REGISTER_TOO_LARGE', 'The register exceeds '.self::MAX_ROWS.' rows. Split it and import again.', 422);
            }
            $value = fn (string $field, int $limit = 600): ?string => isset($mapping[$field]) ? $this->cell($cells[$mapping[$field]] ?? '', $limit) : null;
            $company = (string) $value('company', 300);
            $serial = $kind === 'ICC_CERTIFICATE' ? $this->serialRange($value('serial', 120), $value('serial_to', 120)) : null;
            $displayNumber = $value('number', 160) ?? $serial['display'] ?? null;
            $number = RegisterNormalizer::number((string) $displayNumber);
            if ($number === '' || RegisterNormalizer::company($company) === '') {
                yield ['row_number' => $line, 'reason' => $number === '' ? 'Missing licence, certificate or sticker serial number.' : 'Missing company name.'];

                continue;
            }
            $details = array_filter(['origin' => $value('origin', 40), 'region' => $value('region', 80), 'size' => $value('size', 300), 'class' => $value('class', 300)], static fn (?string $item): bool => $item !== null);
            $modelType = implode('; ', array_filter([$value('type', 2000), $value('model', 2000)], static fn (?string $item): bool => $item !== null));
            yield [
                'row_number' => $line, 'record_number' => Str::limit($number, 120, ''), 'record_number_display' => Str::limit((string) $displayNumber, 160, ''),
                'company_name' => $company, 'normalized_company' => Str::limit(RegisterNormalizer::company($company), 300, ''),
                'product_description' => $value('product', 2000), 'reference_standard' => $value('standard', 160),
                'brand' => $value('brand', 200), 'address' => $value('address'), 'model_type' => $modelType === '' ? null : Str::limit($modelType, 4000, ''),
                'issued_on' => $this->date($value('issued')), 'expires_on' => $this->date($value('expires')),
                'serial_prefix' => $serial['prefix'] ?? null, 'serial_from' => $serial['from'] ?? null, 'serial_to' => $serial['to'] ?? null, 'serial_digits' => $serial['digits'] ?? null,
                'details' => $details === [] ? null : json_encode($details, JSON_THROW_ON_ERROR),
            ];
        }

        return $mapping;
    }

    /** Activates a draft snapshot and supersedes the previous active snapshot of the same kind atomically. */
    public function activate(string $registerId, ?int $actorId): object
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
     * @param  list<string>  $cells
     * @return array<string, int>|null
     */
    private function detectHeader(array $cells): ?array
    {
        $mapping = [];
        foreach ($cells as $index => $cell) {
            $header = trim((string) preg_replace('/[^a-z0-9]+/', ' ', strtolower(Str::ascii($cell))));
            foreach (self::ALIASES as $field => $aliases) {
                if (! isset($mapping[$field]) && in_array($header, $aliases, true)) {
                    $mapping[$field] = $index;
                    break;
                }
            }
        }
        // The official ICC heading "ICC Sticker Serial No." is merged across the from and to columns.
        if (isset($mapping['serial']) && ! isset($mapping['serial_to']) && trim($cells[$mapping['serial'] + 1] ?? '') === '') {
            $mapping['serial_to'] = $mapping['serial'] + 1;
        }

        return isset($mapping['number'], $mapping['company']) || isset($mapping['serial'], $mapping['company']) ? $mapping + (isset($mapping['number']) ? [] : ['number' => $mapping['serial']]) : null;
    }

    private function cell(string $raw, int $limit): ?string
    {
        $value = trim((string) preg_replace('/[ \t]+/', ' ', str_replace(["\r\n", "\r"], "\n", $raw)));
        $value = trim((string) preg_replace('/\s*\n\s*/', "\n", $value));
        if ($value === '' || in_array(RegisterNormalizer::company($value), self::EMPTY_VALUES, true)) {
            return null;
        }

        return Str::limit($value, $limit, '');
    }

    /**
     * A sticker serial range from its from/to cells, or from one cell holding
     * "A1 – A2". A single serial is a range of one.
     *
     * @return array{prefix: string, from: int, to: int, digits: int, display: string}|null
     */
    private function serialRange(?string $from, ?string $to): ?array
    {
        if ($from !== null && $to === null && preg_match('/^\s*(\S+)\s*(?:-|–|—|to)\s*(\S+)\s*$/iu', $from, $parts) === 1) {
            [$from, $to] = [$parts[1], $parts[2]];
        }
        $start = $from === null ? null : RegisterNormalizer::serial($from);
        $end = $to === null ? $start : RegisterNormalizer::serial($to);
        if ($start === null || $end === null || $start['prefix'] !== $end['prefix'] || $start['number'] > $end['number']) {
            return null;
        }

        return ['prefix' => $start['prefix'], 'from' => $start['number'], 'to' => $end['number'], 'digits' => max($start['digits'], $end['digits']), 'display' => $start['display']];
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
