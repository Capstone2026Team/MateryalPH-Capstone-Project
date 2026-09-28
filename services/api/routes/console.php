<?php

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
