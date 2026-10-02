<?php

use App\Domain\Finance\StatementService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Payments\XenditWebhookInbox;
use App\Infrastructure\Payments\FakePaymentGateway;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
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

Artisan::command('materyalph:finance-draft-statements', function (): void {
    $this->info('Statements drafted: '.app(StatementService::class)->draftMonthly(CarbonImmutable::now()));
})->purpose('Draft the previous month\'s Vendor commission statements (idempotent)');
Schedule::command('materyalph:finance-draft-statements')->monthlyOn(1, '00:05')->timezone('Asia/Manila')->withoutOverlapping();

Artisan::command('materyalph:finance-daily', function (): void {
    $this->info('Overdue notices: '.app(StatementService::class)->overdueScan(CarbonImmutable::now()));
    $this->info('Withholding accumulators rolled over: '.app(WithholdingThresholdService::class)->rollover(CarbonImmutable::now()));
})->purpose('Statement due/overdue notices and FIN-04A taxable-year rollover');
Schedule::command('materyalph:finance-daily')->dailyAt('00:10')->timezone('Asia/Manila')->withoutOverlapping();

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
