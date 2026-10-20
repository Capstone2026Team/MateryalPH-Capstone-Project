<?php

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Analytics\DemoMaterialsMarketplace;
use App\Domain\Analytics\Geo\BoundaryImporter;
use App\Domain\Analytics\Geo\DemoGeoAnalytics;
use App\Domain\Analytics\Geo\GeoFactsBuilder;
use App\Domain\Analytics\MaterialPriceCaptureService;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Compliance\ComplianceRegisterImporter;
use App\Domain\Compliance\ComplianceRegisterSync;
use App\Domain\Demo\DemoVendorMarketplace;
use App\Domain\Disputes\DisputeAdminService;
use App\Domain\Enforcement\EnforcementService;
use App\Domain\Finance\StatementService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Fulfillment\ReceiptService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Invoices\InvoiceService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Orders\CancellationService;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Payments\XenditWebhookInbox;
use App\Domain\Reporting\TaxReminderService;
use App\Domain\Reviews\ReviewService;
use App\Domain\Scores\ScoreSnapshotService;
use App\Domain\Vendors\VendorVacationSchedule;
use App\Infrastructure\Payments\FakePaymentGateway;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schedule;
use Illuminate\Support\Str;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->hourly();

Schedule::command('materyalph:outbox-dispatch')->everyMinute()->withoutOverlapping();
Artisan::command('materyalph:tax-reminders', function (): void {
    $this->info('Tax reminder recipients evaluated: '.app(TaxReminderService::class)->sweep());
});
Schedule::command('materyalph:tax-reminders')->dailyAt('08:00')->timezone('Asia/Manila')->withoutOverlapping();
Schedule::command('materyalph:vendor-evidence-evaluate')->hourly()->withoutOverlapping();
Schedule::command('materyalph:vendor-media-recover')->everyFifteenMinutes()->withoutOverlapping();
Schedule::command('materyalph:vendor-expiry-scan')->dailyAt('01:00')->withoutOverlapping();
Schedule::command('materyalph:discoverability-evaluate')->hourly()->withoutOverlapping();
Schedule::command('materyalph:stock-confirmation-sweep')->everyFifteenMinutes()->withoutOverlapping();
Schedule::command('materyalph:orders-expire')->everyMinute()->withoutOverlapping();
Schedule::command('materyalph:orders-payment-reminders')->everyFiveMinutes()->withoutOverlapping();
Artisan::command('materyalph:quotations-sweep', function (): void {
    $this->info('Expired quotations: '.app(QuotationService::class)->sweep());
})->purpose('Expire quotation deadlines, release soft holds and send reminders');
Schedule::command('materyalph:quotations-sweep')->everyMinute()->withoutOverlapping();
Schedule::command('materyalph:geography-cache-prune')->hourly()->withoutOverlapping();
Artisan::command('materyalph:payments-reconcile', function (): void {
    $counts = app(PaymentReconciliationService::class)->sweep();
    $this->info('Payment reconciliation: '.json_encode($counts));
})->purpose('Reconcile open payment attempts, stalled webhooks and compensation refunds with the provider');
Schedule::command('materyalph:payments-reconcile')->everyFiveMinutes()->withoutOverlapping();

Artisan::command('materyalph:fulfillment-sweep', function (): void {
    $this->info('Cancellation requests finalized after the 24-hour Vendor window: '.app(CancellationService::class)->sweep());
    $this->info('Receipt: '.json_encode(app(ReceiptService::class)->sweep()));
})->purpose('48-hour receipt auto-confirmation and reminders, late fulfillment flags and unanswered cancellation requests');
Schedule::command('materyalph:fulfillment-sweep')->everyFiveMinutes()->withoutOverlapping();

Artisan::command('materyalph:disputes-sweep', function (): void {
    $this->info('Disputes: '.json_encode(app(DisputeAdminService::class)->sweep()));
    $this->info('Invoice requests: '.json_encode(app(InvoiceService::class)->sweep()));
})->purpose('Dispute response, mutual-resolution, clarification and appeal timers; invoice-request reminders and overdue notices');
Schedule::command('materyalph:disputes-sweep')->everyMinute()->withoutOverlapping();

Artisan::command('materyalph:finance-draft-statements', function (): void {
    $this->info('Statements drafted: '.app(StatementService::class)->draftMonthly(CarbonImmutable::now()));
})->purpose('Draft the previous month\'s Vendor commission statements (idempotent)');
Schedule::command('materyalph:finance-draft-statements')->monthlyOn(1, '00:05')->timezone('Asia/Manila')->withoutOverlapping();

Artisan::command('materyalph:finance-daily', function (): void {
    $this->info('Overdue notices: '.app(StatementService::class)->overdueScan(CarbonImmutable::now()));
    $this->info('Withholding accumulators rolled over: '.app(WithholdingThresholdService::class)->rollover(CarbonImmutable::now()));
})->purpose('Statement due/overdue notices and FIN-04A taxable-year rollover');
Schedule::command('materyalph:finance-daily')->dailyAt('00:10')->timezone('Asia/Manila')->withoutOverlapping();

Artisan::command('analytics:derive-comparable-groups', function (): int {
    $result = app(ComparableMappingService::class)->deriveForUnmapped();
    AnalyticsDataset::bump();
    EligibleOfferQuery::invalidate();
    $this->info('Comparable groups: '.json_encode($result));

    return 0;
})->purpose('MAT-03 maps unmapped listings that state the full exact key to a comparable group, creating the group when none exists');
// Hourly, so the 00:00 run precedes the 00:10 capture and new listings become comparable within the hour.
Schedule::command('analytics:derive-comparable-groups')->hourly()->timezone('Asia/Manila')->withoutOverlapping()->onOneServer();

Artisan::command('analytics:capture-material-prices', function (): int {
    $result = app(MaterialPriceCaptureService::class)->capture(CarbonImmutable::now());
    $this->info('Material price capture: '.json_encode($result));

    return $result['state'] === 'FAILED' ? 1 : 0;
})->purpose('MAT-04 daily capture of eligible public ordinary prices into an immutable published run (TEST dataset only)');
// One shared job: overlap protection plus database run uniqueness; a retry of a published day returns the same revision.
Schedule::command('analytics:capture-material-prices')->dailyAt('00:10')->timezone('Asia/Manila')->withoutOverlapping()->onOneServer();

Artisan::command('materyalph:materials-analytics-demo {--latitude=14.5995} {--longitude=120.9842} {--days=90} {--use-test : Switch analytics history back to the TEST capture dataset}', function (): int {
    if ($this->option('use-test')) {
        AnalyticsDataset::select(AnalyticsDataset::CAPTURE_ENVIRONMENT);
        $this->info('Materials Analytics now reads the TEST capture dataset.');

        return 0;
    }
    if (app()->isProduction()) {
        $this->error('DEMO marketplace data cannot be seeded in production.');

        return 1;
    }
    $result = app(DemoMaterialsMarketplace::class)->seed((float) $this->option('latitude'), (float) $this->option('longitude'), max(8, min(365, (int) $this->option('days'))));
    $this->info('DEMO — Simulated Marketplace Data seeded: '.json_encode($result).'. Analytics now reads the isolated DEMO history; --use-test switches back.');

    return 0;
})->purpose('DEMO only: seed labelled demo stores, comparable groups and isolated simulated Materials Analytics history');

Artisan::command('materyalph:demo-vendors-seed {--only=* : Seed only these Vendor slugs} {--payments=xendit : xendit provisions real Xendit TEST sub-accounts; simulate is for automated tests only} {--refresh-only : Only refresh stock confirmations and discoverability} {--credentials= : Where to write the sign-in details (default storage/app/demo-vendor-credentials.json)}', function (): int {
    if (app()->isProduction()) {
        $this->error('Demo Vendors cannot be seeded in production.');

        return 1;
    }
    $payments = (string) $this->option('payments');
    if (! in_array($payments, ['xendit', 'simulate'], true)) {
        $this->error('--payments must be xendit or simulate.');

        return 1;
    }
    if ($payments === 'xendit' && ! app()->environment('local', 'development', 'testing') && ! $this->confirm('Create real Xendit TEST sub-accounts for twelve demo Vendors?', false)) {
        return 1;
    }
    $path = (string) ($this->option('credentials') ?: storage_path('app/demo-vendor-credentials.json'));
    $existing = is_file($path) ? (json_decode((string) file_get_contents($path), true) ?: []) : [];
    $password = (string) config('materyalph.demo.password') ?: (string) ($existing['password'] ?? Str::password(24, symbols: false));
    $report = app(DemoVendorMarketplace::class)->seed((array) $this->option('only'), $payments, $password, $path, (bool) $this->option('refresh-only'));
    $failed = 0;
    foreach ($report as $row) {
        $this->line(sprintf('%-26s %-10s verification=%s setup=%s activation=%s discoverability=%s listings=%s gate=%s',
            $row['slug'], $row['status'], $row['verification'] ?? '-', $row['setup'] ?? '-', $row['activation'] ?? '-', $row['discoverability'] ?? '-', $row['active_listings'] ?? '-', ($row['gate_ready'] ?? false) ? 'ready' : 'blocked'));
        foreach (($row['notes'] ?? []) as $key => $note) {
            $this->line('    '.$key.': '.$note);
        }
        if (isset($row['error'])) {
            $this->error('    '.$row['error']);
        }
        $failed += $row['status'] === 'OK' ? 0 : 1;
    }
    $this->info('Sign-in details were written to '.$path.' (git-ignored). Passwords and authenticator secrets are never printed.');

    return $failed === 0 ? 0 : 1;
})->purpose('DEMO only: seed ten fictional, fully onboarded Tier 2 Vendors with accounts, photos, delivery setup and published listings');

Artisan::command('materyalph:scores-daily', function (): void {
    $this->info('Scores: '.json_encode(app(ScoreSnapshotService::class)->run(CarbonImmutable::now())));
})->purpose('Project metric events, write the daily score snapshots (OHS weekly) and award or remove badges');
Schedule::command('materyalph:scores-daily')->dailyAt('00:30')->timezone('Asia/Manila')->withoutOverlapping()->onOneServer();

Artisan::command('materyalph:reviews-sweep', function (): void {
    $this->info('Reviews: '.json_encode(app(ReviewService::class)->sweep()));
})->purpose('Open rating windows for completed orders and reveal ratings whose 14-day window ended');
Schedule::command('materyalph:reviews-sweep')->everyFifteenMinutes()->withoutOverlapping();

Artisan::command('materyalph:payments-simulate {payment} {--outcome=completed}', function (string $payment): int {
    $gateway = app(PaymentGateway::class);
    if (! $gateway instanceof FakePaymentGateway) {
        $this->error('Simulation is available only with PAYMENT_GATEWAY=fake; real Xendit TEST payments complete on the hosted page.');

        return 1;
    }
    $sessionId = DB::table('payments')->where('id', $payment)->value('provider_session_id');
    if (! is_string($sessionId)) {
        $this->error('The payment attempt has no simulated session.');

        return 1;
    }
    $body = $this->option('outcome') === 'expired' ? $gateway->expire($sessionId) : $gateway->complete($sessionId);
    $result = app(XenditWebhookInbox::class)->receive(json_encode($body, JSON_THROW_ON_ERROR), (string) config('services.xendit.webhook_token'), 'sim-'.$sessionId.'-'.$this->option('outcome'));
    $this->info('SIMULATED provider event stored: '.json_encode($result));

    return 0;
})->purpose('DEMO only: simulate a provider event for a SIMULATED payment through the verified inbox path');

Artisan::command('analytics:aggregate-marketplace', function (): int {
    $result = app(GeoFactsBuilder::class)->build('SCHEDULE');
    $this->info('Geographic analytics facts: '.json_encode($result));

    return $result['state'] === 'FAILED' ? 1 : 0;
})->purpose('Rebuild the daily PSGC geographic analytics facts for the TEST marketplace (idempotent; a retry publishes the next revision)');
// Keep the daily fact projection current as orders, refunds and human activity change.
// Reads stay on the disclosure-controlled facts; the immutable material-price capture remains daily.
Schedule::command('analytics:aggregate-marketplace')->everyMinute()->timezone('Asia/Manila')->withoutOverlapping()->onOneServer();

Artisan::command('analytics:refresh-presence', function (): int {
    $rows = app(GeoFactsBuilder::class)->refreshPresence();
    $this->info('Presence snapshot rows: '.($rows ?? 'none (no published daily run yet)'));

    return 0;
})->purpose("Refresh today's storefront and registered-Buyer presence facts so new stores and Buyers appear without waiting for the daily run");
// The recurring full aggregation also refreshes presence; retain this command for manual recovery.

Artisan::command('materyalph:enforcement-sweep', function (): void {
    $this->info('Temporary restrictions lifted at the end of their duration: '.app(EnforcementService::class)->sweep());
})->purpose('Lift applied Temporary Restrictions whose duration has ended (system rule; attributed to the scheduler)');
Schedule::command('materyalph:enforcement-sweep')->everyFifteenMinutes()->withoutOverlapping();

Artisan::command('materyalph:compliance-registers-sync', function (): int {
    $sync = app(ComplianceRegisterSync::class);
    $failed = false;
    foreach (ComplianceRegisterImporter::KINDS as $kind) {
        try {
            $result = $sync->sync($kind, (bool) config('materyalph.compliance_registers.auto_activate'));
            $this->info($kind.': '.$result['outcome'].($result['row_count'] === null ? '' : ' ('.$result['row_count'].' rows)'));
        } catch (AuthenticationException $exception) {
            $failed = true;
            $this->error($kind.': '.$exception->errorCode);
        }
    }

    return $failed ? 1 : 0;
})->purpose('Refresh the DTI-BPS PS licensee and ICC certificate registers from configured authorized feeds (does nothing when none is configured)');
// The lists are updated monthly; a daily check picks up a new month within a day and skips unchanged files.
Schedule::command('materyalph:compliance-registers-sync')->dailyAt('03:15')->timezone('Asia/Manila')->withoutOverlapping()->onOneServer();

Artisan::command('materyalph:vendor-vacation-sweep', function (): void {
    $this->info('Stores whose Vacation Mode started or ended: '.app(VendorVacationSchedule::class)->sweep());
})->purpose('Turn Vacation Mode on when its start date arrives and off after its end date (system rule; attributed to the scheduler)');
Schedule::command('materyalph:vendor-vacation-sweep')->everyMinute()->withoutOverlapping();

Artisan::command('materyalph:geo-analytics-demo {--days=90} {--seed=16}', function (): int {
    if (app()->isProduction()) {
        $this->error('DEMO geographic analytics cannot be seeded in production.');

        return 1;
    }
    try {
        $result = app(DemoGeoAnalytics::class)->seed(max(14, min(365, (int) $this->option('days'))), (int) $this->option('seed'));
    } catch (AuthenticationException $exception) {
        $this->error($exception->errorCode.': '.$exception->getMessage());

        return 1;
    }
    $this->info('DEMO — Simulated Marketplace Data seeded for the geographic dashboard: '.json_encode($result).'. Choose the DEMO dataset in the Admin dashboard; TEST facts are untouched.');

    return 0;
})->purpose('DEMO only: seed labelled simulated geographic analytics facts in the isolated DEMO environment');

Artisan::command('materyalph:psgc-boundaries-import {--file= : PSGC-coded GeoJSON FeatureCollection} {--reference= : Publisher, dataset and date of the boundaries} {--version= : PSGC version label; the ACTIVE version by default} {--code-property= : Feature property holding the PSGC code} {--replace : Replace existing boundaries for matched areas}', function (): int {
    try {
        $result = app(BoundaryImporter::class)->import((string) $this->option('file'), (string) $this->option('reference'), $this->option('version') ?: null, $this->option('code-property') ?: null, (bool) $this->option('replace'));
    } catch (AuthenticationException $exception) {
        $this->error($exception->errorCode.': '.$exception->getMessage());

        return 1;
    }
    $this->info('Boundaries imported: '.$result['matched'].' of '.$result['features'].' features matched using '.$result['code_property'].'; '.$result['replaced'].' replaced; '.$result['skipped_existing'].' kept (use --replace).');
    if ($result['unmatched'] !== []) {
        $this->warn('Unmatched codes (first 50): '.implode(', ', $result['unmatched']));
    }

    return 0;
})->purpose('Import versioned PSGC-coded administrative boundaries for the Admin geographic map');
