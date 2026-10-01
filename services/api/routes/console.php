<?php

use App\Domain\Messaging\QuotationService;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->hourly();

Schedule::command('materyalph:outbox-dispatch')->everyMinute()->withoutOverlapping();
Schedule::command('materyalph:vendor-evidence-evaluate')->hourly()->withoutOverlapping();
Schedule::command('materyalph:vendor-media-recover')->everyFifteenMinutes()->withoutOverlapping();
Schedule::command('materyalph:vendor-expiry-scan')->dailyAt('01:00')->withoutOverlapping();
Schedule::command('materyalph:discoverability-evaluate')->hourly()->withoutOverlapping();
Schedule::command('materyalph:stock-confirmation-sweep')->everyFifteenMinutes()->withoutOverlapping();
Schedule::command('materyalph:orders-expire')->everyMinute()->withoutOverlapping();
Artisan::command('materyalph:quotations-sweep', function (): void {
    $this->info('Expired quotations: '.app(QuotationService::class)->sweep());
})->purpose('Expire quotation deadlines, release soft holds and send reminders');
Schedule::command('materyalph:quotations-sweep')->everyMinute()->withoutOverlapping();
Schedule::command('materyalph:geography-cache-prune')->hourly()->withoutOverlapping();
