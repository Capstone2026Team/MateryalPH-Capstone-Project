<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Orders\NrpcTerms;
use App\Domain\Orders\OrderExpiryService;
use App\Domain\Orders\OrderPaymentReminders;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * The 24-hour Pending Payment window: a failed or abandoned checkout leaves the order payable for the same amount
 * with no second charge, reminders go out once at 12 hours and 1 hour, and the server clock alone cancels the order
 * at the deadline, never while a verified payment is on its way.
 */
final class PhaseElevenPendingPaymentWindowTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
        $this->fakePayments();
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    private function deadline(string $orderId): CarbonImmutable
    {
        return CarbonImmutable::parse((string) DB::table('orders')->where('id', $orderId)->value('payment_expires_at'));
    }

    public function test_the_order_has_24_hours_and_each_checkout_session_ends_after_45_minutes(): void
    {
        $this->travelTo(CarbonImmutable::parse('2026-10-05 09:00:00', 'Asia/Manila'));
        [, , $buyer, $orderId] = $this->awaitingPayment('Window Hardware');
        self::assertEqualsWithDelta(24 * 60, CarbonImmutable::now()->diffInMinutes($this->deadline($orderId)), 1);

        $attempt = $this->startPayment($buyer, $orderId);
        $expires = CarbonImmutable::parse((string) DB::table('payments')->where('id', $attempt['id'])->value('expires_at'));
        self::assertEqualsWithDelta(45, CarbonImmutable::now()->diffInMinutes($expires), 1, 'A session ends after 45 minutes, not after the 24-hour order window.');
    }

    public function test_nrpc_terms_publish_the_new_window_without_rewriting_historical_terms(): void
    {
        $document = DB::table('agreement_documents')->where('code', 'NRPC_TERMS')->value('id');
        $oldId = (string) Str::uuid7();
        $oldContent = file_get_contents(resource_path('agreements/NRPC_TERMS/1.md'));
        DB::table('agreement_versions')->insert([
            'id' => $oldId, 'agreement_document_id' => $document, 'version' => 1,
            'content_hash' => hash('sha256', $oldContent), 'content_uri' => '/legal/nrpc-terms',
            'effective_at' => now()->subDay(), 'retired_at' => null, 'requires_reacceptance' => false,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $migration = require database_path('migrations/2026_10_06_010000_publish_pending_payment_nrpc_terms.php');
        $migration->up();
        $migration->up();
        self::assertSame($oldContent, app(NrpcTerms::class)->version($oldId)['content']);
        self::assertSame(2, app(NrpcTerms::class)->current()['version']);
        self::assertStringContainsString('24-hour Pending Payment window', app(NrpcTerms::class)->current()['content']);
        self::assertSame(2, DB::table('agreement_versions')->where('agreement_document_id', $document)->count());
    }

    public function test_an_abandoned_or_failed_checkout_leaves_the_order_payable_once(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Retry Hardware');
        $first = $this->startPayment($buyer, $orderId, 'MAYA');
        $deadline = $this->deadline($orderId);

        // Abandoned: the 45-minute session ends and the sweep runs. The order is not cancelled.
        $this->travel(46)->minutes();
        self::assertSame(0, app(OrderExpiryService::class)->sweep());
        $this->deliverWebhook($this->gateway->expire((string) DB::table('payments')->where('id', $first['id'])->value('provider_session_id')), 'wh-abandoned')->assertOk();
        self::assertSame(['EXPIRED', 'AWAITING_PAYMENT'], [$this->paymentState($first['id']), $this->orderState($orderId)]);
        $this->getJson('/api/v1/buyers/orders?group=AWAITING_ACTION')->assertOk()->assertJsonPath('data.0.payment_retryable', true);
        self::assertSame($deadline->toIso8601String(), $this->deadline($orderId)->toIso8601String(), 'Re-paying never moves the deadline.');

        // Pay again: same order, same amount, a new session; the Buyer sees it as the order's second attempt.
        $second = $this->startPayment($buyer, $orderId, 'MAYA');
        self::assertSame(2, (int) DB::table('payments')->where('id', $second['id'])->value('attempt_number'));
        self::assertSame($first['principal_centavos'], $second['principal_centavos']);
        self::assertSame(1, DB::table('payments')->where('order_id', $orderId)->whereIn('state', ['CREATING', 'PENDING'])->count());
        $this->getJson('/api/v1/buyers/orders?group=AWAITING_ACTION')->assertOk()->assertJsonPath('data.0.payment_retryable', false);

        // A second open session is refused rather than charging twice; the response names the one in progress.
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'MAYA', 'expected_total_centavos' => $second['total_centavos']], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ATTEMPT_IN_PROGRESS')->assertJsonPath('errors.0.details.payment_id', $second['id']);

        $this->deliverWebhook($this->gateway->complete((string) DB::table('payments')->where('id', $second['id'])->value('provider_session_id')), 'wh-pay')->assertOk();
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($second['id']), $this->orderState($orderId)]);
        self::assertSame(1, DB::table('payments')->where('order_id', $orderId)->where('state', 'PAID')->count());
    }

    public function test_a_checkout_near_the_order_deadline_is_capped_without_extending_the_order(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Capped Session Hardware');
        $deadline = $this->deadline($orderId);
        $this->travelTo($deadline->subMinutes(20));
        $attempt = $this->startPayment($buyer, $orderId);
        self::assertTrue($deadline->equalTo(CarbonImmutable::parse($attempt['expires_at'])));
        self::assertTrue($deadline->equalTo($this->deadline($orderId)));
    }

    public function test_the_order_is_cancelled_at_the_deadline_and_the_vendor_is_told(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Cancel Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $deadline = $this->deadline($orderId);

        $this->travelTo($deadline->subSecond());
        self::assertSame(0, app(OrderExpiryService::class)->sweep());
        self::assertSame('AWAITING_PAYMENT', $this->orderState($orderId));

        $this->travelTo($deadline);
        self::assertSame(1, app(OrderExpiryService::class)->sweep());
        $order = DB::table('orders')->where('id', $orderId)->first();
        self::assertSame(['EXPIRED', 'EXPIRED', 'PAYMENT_WINDOW_EXPIRED'], [$order->order_state, $order->payment_state, $order->terminal_reason_code]);
        self::assertSame('EXPIRED', $this->paymentState($attempt['id']), 'The open checkout closes with the order.');
        self::assertSame(0, DB::table('inventory_holds')->where('source_id', $orderId)->where('state', 'ACTIVE')->count(), 'Reserved stock is released.');
        self::assertSame(1, DB::table('notifications')->where('resource_id', $orderId)->where('user_id', $owner->id)->where('title', 'like', '%cancelled: payment expired%')->count(), 'The Vendor is notified.');
        self::assertSame(1, DB::table('notifications')->where('resource_id', $orderId)->where('user_id', $buyer->id)->where('title', 'like', '%cancelled: payment expired%')->count());
        self::assertSame($store->id, (string) $order->vendor_organization_id);
    }

    public function test_no_payment_can_be_opened_once_the_deadline_has_passed_even_before_the_job_runs(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Late Open Hardware');
        $this->travelTo($this->deadline($orderId)->addSecond());
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => 1026441], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409);
        self::assertSame(0, DB::table('payments')->where('order_id', $orderId)->count());
        self::assertSame(0, $this->gateway->createCalls);
    }

    public function test_a_verified_payment_beats_the_cancellation_job(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Race Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        // The Buyer completed the payment at the provider, but the webhook has not reached us yet.
        $this->gateway->complete((string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id'));
        $this->travelTo($this->deadline($orderId)->addSecond());

        app(OrderExpiryService::class)->sweep();
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($attempt['id']), $this->orderState($orderId)], 'Reconciliation confirms the payment before the job may cancel.');
        self::assertSame(0, DB::table('refunds')->where('source_payment_id', $attempt['id'])->count());
    }

    public function test_reminders_go_out_once_at_12_hours_and_once_at_1_hour(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Reminder Hardware');
        $deadline = $this->deadline($orderId);
        $reminders = fn (): int => DB::table('notifications')->where('resource_id', $orderId)->where('user_id', $buyer->id)->where('title', 'like', '%left to pay%')->count();

        $this->travelTo($deadline->subHours(13));
        self::assertSame(0, app(OrderPaymentReminders::class)->send());
        $this->travelTo($deadline->subHours(12));
        self::assertSame(1, app(OrderPaymentReminders::class)->send());
        self::assertSame(0, app(OrderPaymentReminders::class)->send(), 'Running again never repeats a reminder.');
        $this->travelTo($deadline->subHours(2));
        self::assertSame(0, app(OrderPaymentReminders::class)->send());
        $this->travelTo($deadline->subMinutes(59));
        self::assertSame(1, app(OrderPaymentReminders::class)->send());
        self::assertSame(0, app(OrderPaymentReminders::class)->send());
        self::assertSame(2, $reminders());
        self::assertSame([12, 1], DB::table('order_payment_reminders')->where('order_id', $orderId)->orderByDesc('hours_before')->pluck('hours_before')->map(fn ($hours) => (int) $hours)->all());
    }

    public function test_a_late_scheduler_sends_only_the_most_urgent_reminder_and_never_for_paid_or_closed_orders(): void
    {
        [, , , $late] = $this->awaitingPayment('Late Scheduler Hardware');
        $this->travelTo($this->deadline($late)->subMinutes(30));
        self::assertSame(1, app(OrderPaymentReminders::class)->send());
        self::assertSame([1], DB::table('order_payment_reminders')->where('order_id', $late)->pluck('hours_before')->map(fn ($hours) => (int) $hours)->all());

        [, , $payer, $paid] = $this->awaitingPayment('Paid Hardware');
        $attempt = $this->startPayment($payer, $paid);
        $this->deliverWebhook($this->gateway->complete((string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id')), 'wh-paid')->assertOk();
        $this->travelTo(CarbonImmutable::now()->addHours(13));
        self::assertSame(0, DB::table('order_payment_reminders')->where('order_id', $paid)->count());
        app(OrderPaymentReminders::class)->send();
        self::assertSame(0, DB::table('order_payment_reminders')->where('order_id', $paid)->count(), 'A confirmed order is never reminded.');
    }

    public function test_reminded_orders_do_not_starve_later_batches(): void
    {
        [, , , $first] = $this->awaitingPayment('First Reminder Hardware');
        [, , , $second] = $this->awaitingPayment('Second Reminder Hardware');
        $this->travelTo($this->deadline($second)->subHours(11));
        self::assertSame(1, app(OrderPaymentReminders::class)->send(1));
        self::assertSame(1, app(OrderPaymentReminders::class)->send(1));
        self::assertSame(0, app(OrderPaymentReminders::class)->send(1));
        self::assertSame(2, DB::table('order_payment_reminders')->whereIn('order_id', [$first, $second])->count());
    }

    public function test_options_resolve_expiry_and_a_provider_capture_before_exposing_payability(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Options Expiry Hardware');
        $this->travelTo($this->deadline($orderId));
        $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->assertOk()->assertJsonPath('data.payment_due', false);
        self::assertSame('EXPIRED', $this->orderState($orderId));

        [, , $buyer, $paidId] = $this->awaitingPayment('Options Paid Hardware');
        $attempt = $this->startPayment($buyer, $paidId);
        $this->gateway->complete((string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id'));
        $this->travelTo($this->deadline($paidId));
        // Paid and confirmed: nothing is payable; Phase 12 offers only a reasoned cancellation before preparation.
        $this->getJson('/api/v1/buyers/orders/'.$paidId)->assertOk()->assertJsonPath('data.available_actions', ['CANCEL']);
        self::assertSame('CONFIRMED', $this->orderState($paidId));
    }
}
