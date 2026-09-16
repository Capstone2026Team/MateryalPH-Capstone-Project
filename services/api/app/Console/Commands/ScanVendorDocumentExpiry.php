<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Vendors\VendorExpiryService;
use Illuminate\Console\Command;

final class ScanVendorDocumentExpiry extends Command
{
    protected $signature = 'materyalph:vendor-expiry-scan';

    protected $description = 'Send Vendor evidence expiry notices and restrict expired activation evidence.';

    public function handle(VendorExpiryService $expiry): int
    {
        $this->info('Processed '.$expiry->scan().' Vendor evidence expiry notice(s).');

        return self::SUCCESS;
    }
}
