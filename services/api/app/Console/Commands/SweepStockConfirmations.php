<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Inventory\StockConfirmationService;
use Illuminate\Console\Command;

/**
 * Sends Day 7 and Day 12 stock-confirmation reminders at each Vendor's configured Asia/Manila time and
 * temporarily hides listings whose stock was not confirmed for 15 consecutive days. Idempotent.
 */
final class SweepStockConfirmations extends Command
{
    protected $signature = 'materyalph:stock-confirmation-sweep';

    protected $description = 'Send stale-stock reminders and hide listings whose stock was not confirmed for 15 days.';

    public function handle(StockConfirmationService $confirmations): int
    {
        $result = $confirmations->sweep();
        $this->info('Sent '.$result['reminders'].' reminder(s); temporarily hid '.$result['hidden'].' listing(s).');

        return self::SUCCESS;
    }
}
