<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Geography\PsgcImporter;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Console\Command;

/** Activates a reviewed DRAFT PSGC version and retires the previous ACTIVE one. Existing addresses keep their version. */
final class ActivatePsgcVersion extends Command
{
    protected $signature = 'materyalph:psgc-activate {version : Version label or id}';

    protected $description = 'Activate a DRAFT PSGC version for new address resolution.';

    public function handle(PsgcImporter $importer): int
    {
        try {
            $summary = $importer->activate((string) $this->argument('version'));
        } catch (AuthenticationException $exception) {
            $this->error($exception->errorCode.': '.$exception->getMessage());

            return self::FAILURE;
        }
        $this->info('PSGC version '.$summary['version'].' is '.$summary['status'].' ('.$summary['area_count'].' areas).');

        return self::SUCCESS;
    }
}
