<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Orders\OrderExpiryService;
use Illuminate\Console\Command;

final class ExpireOrders extends Command
{
    protected $signature = 'materyalph:orders-expire {--limit=200}';

    protected $description = 'Expire orders whose Vendor, Buyer or 45-minute payment window has passed and release their reservations';

    public function handle(OrderExpiryService $expiry): int
    {
        $count = $expiry->sweep(max(1, (int) $this->option('limit')));
        $this->info($count.' order(s) expired.');

        return self::SUCCESS;
    }
}
