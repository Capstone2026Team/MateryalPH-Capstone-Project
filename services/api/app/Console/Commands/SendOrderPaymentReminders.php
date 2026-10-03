<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Orders\OrderPaymentReminders;
use Illuminate\Console\Command;

final class SendOrderPaymentReminders extends Command
{
    protected $signature = 'materyalph:orders-payment-reminders {--limit=500}';

    protected $description = 'Remind Buyers about orders still in Pending Payment 12 hours and 1 hour before the deadline';

    public function handle(OrderPaymentReminders $reminders): int
    {
        $this->info($reminders->send(max(1, (int) $this->option('limit'))).' reminder(s) sent.');

        return self::SUCCESS;
    }
}
