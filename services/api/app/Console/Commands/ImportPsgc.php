<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Geography\PsgcCsvSource;
use App\Domain\Geography\PsgcImporter;
use App\Domain\Identity\AuthenticationException;
use App\Infrastructure\Geography\PsgcCloudSnapshotSource;
use Illuminate\Console\Command;

/**
 * Imports a PSGC master as a DRAFT version from the PSA CSV export or a psgc.cloud snapshot. See
 * docs/architecture/psgc-import.md. Re-importing identical content returns the existing version.
 */
final class ImportPsgc extends Command
{
    protected $signature = 'materyalph:psgc-import
        {--source= : psa-csv or psgc-cloud}
        {--file= : Path to the PSA CSV export (psa-csv only)}
        {--label= : Version label, e.g. 2025Q2}
        {--effective-on= : Publication effective date, YYYY-MM-DD}
        {--reference= : Source reference, e.g. the PSA publication title or URL}';

    protected $description = 'Import the PSGC master as a DRAFT version (activate it with materyalph:psgc-activate).';

    public function handle(PsgcImporter $importer): int
    {
        $source = match ($this->option('source')) {
            'psa-csv' => new PsgcCsvSource((string) $this->option('file')),
            'psgc-cloud' => new PsgcCloudSnapshotSource,
            default => null,
        };
        if ($source === null) {
            $this->error('Use --source=psa-csv --file=path or --source=psgc-cloud.');

            return self::INVALID;
        }
        try {
            $summary = $importer->import($source, (string) $this->option('label'), (string) $this->option('effective-on'), (string) $this->option('reference'));
        } catch (AuthenticationException $exception) {
            $this->error($exception->errorCode.': '.$exception->getMessage());

            return self::FAILURE;
        }
        $this->info(($summary['duplicate'] ? 'Identical content already imported as ' : 'Imported DRAFT ').$summary['version'].' ('.$summary['status'].')');
        $this->table(['Level', 'Areas'], collect($summary['level_counts'])->map(static fn (int $count, string $level): array => [$level, $count])->values()->all());
        $this->line('Total areas: '.$summary['area_count'].'; areas without a resolvable parent: '.$summary['orphan_count']);

        return self::SUCCESS;
    }
}
