<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Orders\OrderExpiryService;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Infrastructure\Payments\FakePaymentGateway;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
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
 * Phase 11 checkout payments against the deterministic SIMULATED adapter: server-calculated amounts and fee
 * snapshots, the verified webhook inbox, idempotency, expiry, reconciliation and technical compensation. A
 * redirect, a forged, duplicate, reordered, mismatched or unknown event never creates a paid order.
 */
final class PhaseElevenPaymentsTest extends TestCase
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

    public function test_server_amount_fee_snapshot_and_only_a_verified_event_marks_paid(): void
    {
        [$store, , $buyer, $orderId] = $this->awaitingPayment('Pay Hardware');
        $options = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->assertOk()->json('data');
        self::assertSame(['FULL_ORDER_PAYMENT', 1000000, 'TEST'], [$options['purpose'], $options['principal_centavos'], $options['environment']]);
        $available = collect($options['channels'])->where('available', true)->pluck('code')->sort()->values()->all();
        self::assertSame(['CARDS', 'GCASH', 'GRABPAY', 'MAYA', 'SHOPEEPAY'], $available);
        foreach (['QRPH', 'OVER_THE_COUNTER', 'DIRECT_DEBIT', 'BANK_TRANSFER'] as $code) {
            self::assertSame('REFUND_ROUTE_UNAVAILABLE', collect($options['channels'])->firstWhere('code', $code)['unavailable_reason']);
        }
        $gcash = collect($options['channels'])->firstWhere('code', 'GCASH');
        // 2.3% + 12% VAT on the fee, grossed up: base money(1,026,441 × 2.3%) = 23,608, VAT 2,833, charge 26,441 = F.
        self::assertSame(1026441, $gcash['total_centavos']);

        $attempt = $this->startPayment($buyer, $orderId);
        self::assertSame(['PENDING', 'SIMULATED', 1000000, 26441, 1026441], [$attempt['status'], $attempt['evidence_origin'], $attempt['principal_centavos'], $attempt['processing_fee_centavos'], $attempt['total_centavos']]);
        self::assertNotNull($attempt['checkout_url']);
        $row = DB::table('payments')->where('id', $attempt['id'])->first();
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->first();
        self::assertSame([$account->provider_account_id, 'VENDOR_SUB_ACCOUNT', 'XENDIT_ACCOUNTS_V2', 'FULL_ORDER_PAYMENT'], [$row->provider_account_id, $row->account_scope, $row->account_contract_version, $row->purpose]);
        self::assertSame(1, DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->count(), 'Checkout reuses the existing association and never provisions another.');
        $snapshot = DB::table('processing_fee_snapshots')->where('payment_id', $attempt['id'])->first();
        self::assertSame(['GCASH', 26441, 'BUYER'], [$snapshot->channel, (int) $snapshot->quoted_centavos, $snapshot->fee_bearer]);

        // A browser return renders Pending and changes nothing.
        $this->get('/api/v1/payments/return?attempt='.$attempt['id'])->assertOk()->assertSee('Payment pending verification')->assertDontSee('successful');
        self::assertSame(['PENDING', 'AWAITING_PAYMENT'], [$this->paymentState($attempt['id']), $this->orderState($orderId)]);

        $this->completePayment($attempt['id'])->assertOk()->assertJsonPath('data.received', true)->assertJsonPath('data.duplicate', false);
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($attempt['id']), $this->orderState($orderId)]);
        $detail = $this->buyerOrder($buyer, $orderId);
        self::assertSame(['PAID', 'PAID', 26441], [$detail['payment']['verified_payment']['status'], $detail['money']['processing_fee']['status'], $detail['money']['processing_fee']['amount_centavos']]);

        // The DEMO adapter assesses the collection as its own SIMULATED remittance group.
        $assessment = DB::table('remittance_assessments')->where('payment_id', $attempt['id'])->first();
        // G = C − R − D_r − V_r − P = 1,026,441 − 26,441 = 1,000,000; W = 5,000; cash = C − P − W = 995,000.
        self::assertSame([1026441, 0, 0, 26441, 1000000, 5000, 995000, 0], [(int) $assessment->collections_centavos, (int) $assessment->delivery_centavos, (int) $assessment->vat_centavos,
            (int) $assessment->provider_charge_centavos, (int) $assessment->gross_basis_centavos, (int) $assessment->withheld_centavos, (int) $assessment->expected_vendor_cash_centavos, (int) $assessment->commission_deducted_centavos]);
        self::assertSame(['SIMULATED_WITHHELD', 'SUBJECT_STANDARD', 'SIMULATED'], [$assessment->deduction_evidence_state, $assessment->threshold_status_after, $assessment->evidence_origin]);
        foreach (DB::table('financial_posting_batches')->where('ledger', 'DEMO_FLOW')->get() as $batch) {
            self::assertSame((int) $batch->debit_total_centavos, (int) $batch->credit_total_centavos);
        }
    }

    public function test_forged_unconfigured_duplicate_and_unknown_events_never_create_a_paid_order(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Forge Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $session = (string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id');
        $claim = ['event' => 'payment_session.completed', 'business_id' => 'x', 'created' => '2026-10-02T00:00:00Z', 'data' => ['payment_session_id' => $session, 'reference_id' => $attempt['id'],
            'status' => 'COMPLETED', 'amount' => 10264.52, 'currency' => 'PHP', 'payment_id' => 'py-forged', 'payment_request_id' => 'pr-forged']];

        $this->deliverWebhook($claim, token: 'wrong-token')->assertStatus(401);
        config()->set('services.xendit.webhook_token', '');
        $this->deliverWebhook($claim)->assertStatus(503);
        config()->set('services.xendit.webhook_token', $this->callbackToken);
        self::assertSame(0, DB::table('webhook_events')->count(), 'An unauthenticated callback is never stored.');

        // A token-valid but forged completion: the authoritative provider read still says ACTIVE.
        $this->deliverWebhook($claim, 'wh-forged')->assertOk();
        self::assertSame(['PENDING', 'AWAITING_PAYMENT'], [$this->paymentState($attempt['id']), $this->orderState($orderId)]);

        $unknown = $claim;
        $unknown['data']['reference_id'] = (string) Str::uuid7();
        $unknown['data']['payment_session_id'] = 'ps-unknown00000000000000000';
        $this->deliverWebhook($unknown, 'wh-unknown')->assertOk();
        self::assertSame('IGNORED', DB::table('webhook_events')->where('provider_event_id', 'wh:wh-unknown')->value('state'));

        $this->completePayment($attempt['id'], webhookId: 'wh-real')->assertOk();
        $this->deliverWebhook($this->gateway->complete($session), 'wh-real')->assertOk()->assertJsonPath('data.duplicate', true);
        self::assertSame(1, DB::table('payment_events')->where('payment_id', $attempt['id'])->where('state', 'PAID')->count());
        self::assertSame(1, DB::table('remittance_assessments')->where('payment_id', $attempt['id'])->count());
        self::assertSame(1, DB::table('order_status_history')->where('order_id', $orderId)->where('state_family', 'PAYMENT')->where('to_state', 'PAID')->count());
    }

    public function test_mismatched_amount_is_rejected_into_the_exception_queue(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Mismatch Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'], 100)->assertOk();
        self::assertSame(['PENDING', 'AWAITING_PAYMENT', 'EXCEPTION'], [$this->paymentState($attempt['id']), $this->orderState($orderId), (string) DB::table('payments')->where('id', $attempt['id'])->value('reconciliation_state')]);
        self::assertSame('AMOUNT_MISMATCH', DB::table('finance_review_items')->where('kind', 'PAYMENT_MISMATCH')->value('reason_code'));
        self::assertSame('REJECTED', DB::table('webhook_events')->latest('received_at')->value('state'));
    }

    public function test_reordered_events_and_expired_attempts_allow_a_safe_new_attempt(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Order Hardware');
        $first = $this->startPayment($buyer, $orderId, 'MAYA');
        $session = (string) DB::table('payments')->where('id', $first['id'])->value('provider_session_id');
        $this->deliverWebhook($this->gateway->expire($session), 'wh-exp')->assertOk();
        self::assertSame(['EXPIRED', 'AWAITING_PAYMENT'], [$this->paymentState($first['id']), $this->orderState($orderId)]);

        $second = $this->startPayment($buyer, $orderId, 'GCASH');
        self::assertSame(2, (int) DB::table('payments')->where('id', $second['id'])->value('attempt_number'));
        $completed = $this->gateway->complete((string) DB::table('payments')->where('id', $second['id'])->value('provider_session_id'));
        $this->deliverWebhook($completed, 'wh-done')->assertOk();
        // An older expiry event arriving after the capture cannot undo it.
        $this->deliverWebhook(['event' => 'payment_session.expired'] + $completed, 'wh-late-expiry')->assertOk();
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($second['id']), $this->orderState($orderId)]);
    }

    public function test_idempotent_create_conflict_amount_change_and_in_progress_guard(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Idem Hardware');
        $key = (string) Str::uuid7();
        $attempt = $this->startPayment($buyer, $orderId, 'GCASH', $key);
        $total = $attempt['total_centavos'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => $total], ['Idempotency-Key' => $key])
            ->assertOk()->assertJsonPath('meta.replayed', true)->assertJsonPath('data.id', $attempt['id']);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'MAYA', 'expected_total_centavos' => $total], ['Idempotency-Key' => $key])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => $total], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ATTEMPT_IN_PROGRESS');
        self::assertSame(1, $this->gateway->createCalls, 'A retry never creates a second provider session.');

        [, , $other, $otherOrder] = $this->awaitingPayment('Idem Two Hardware');
        $this->postJson('/api/v1/buyers/orders/'.$otherOrder.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => 1], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_AMOUNT_CHANGED');
        $this->postJson('/api/v1/buyers/orders/'.$otherOrder.'/payments', ['channel_code' => 'QRPH', 'expected_total_centavos' => 1], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'PAYMENT_CHANNEL_UNAVAILABLE');
        // Another Buyer's order is simply not found.
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$otherOrder.'/payment-options')->assertNotFound();
        $this->getJson('/api/v1/buyers/payments/'.$attempt['id'])->assertOk();
        $this->signInBuyer($other);
        $this->getJson('/api/v1/buyers/payments/'.$attempt['id'])->assertNotFound();
    }

    public function test_timeouts_stay_uncertain_until_an_authoritative_read_and_rejections_allow_retry(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Timeout Hardware');
        $this->gateway->nextCreate = 'REJECT';
        $options = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->json('data');
        $total = collect($options['channels'])->firstWhere('code', 'GCASH')['total_centavos'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => $total], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'PAYMENT_PROVIDER_REJECTED');
        self::assertSame('FAILED', (string) DB::table('payments')->where('order_id', $orderId)->value('state'));

        $this->gateway->nextCreate = 'TIMEOUT_AFTER_CREATE';
        $uncertain = $this->startPayment($buyer, $orderId);
        self::assertSame('PENDING', $uncertain['status']);
        self::assertSame('UNCERTAIN', $this->paymentState($uncertain['id']));
        self::assertNull(DB::table('payments')->where('id', $uncertain['id'])->value('provider_session_id'));
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => $total], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ATTEMPT_IN_PROGRESS');

        // The provider's own event, verified by an authoritative read of that session, resolves the attempt.
        $session = FakePaymentGateway::sessionIdFor($uncertain['id']);
        $this->deliverWebhook($this->gateway->complete($session), 'wh-uncertain')->assertOk();
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($uncertain['id']), $this->orderState($orderId)]);
        self::assertSame($session, DB::table('payments')->where('id', $uncertain['id'])->value('provider_session_id'));
    }

    public function test_scheduled_reconciliation_marks_paid_when_the_webhook_never_arrives_and_survives_provider_outage(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Recon Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->gateway->complete((string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id'));
        $this->travel(3)->minutes();
        $this->gateway->retrieveUnavailable = true;
        app(PaymentReconciliationService::class)->sweep();
        self::assertSame('PENDING', $this->paymentState($attempt['id']), 'A provider outage never posts success.');
        $this->gateway->retrieveUnavailable = false;
        $this->travel(2)->minutes();
        $counts = app(PaymentReconciliationService::class)->sweep();
        self::assertGreaterThanOrEqual(1, $counts['reconciled']);
        self::assertSame(['PAID', 'CONFIRMED'], [$this->paymentState($attempt['id']), $this->orderState($orderId)]);
        self::assertSame('RECONCILIATION', DB::table('payment_events')->where('payment_id', $attempt['id'])->where('state', 'PAID')->value('source'));
    }

    public function test_capture_after_the_window_closed_is_compensated_and_never_confirms_the_order(): void
    {
        [$store, , $buyer, $orderId] = $this->awaitingPayment('Late Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $session = (string) DB::table('payments')->where('id', $attempt['id'])->value('provider_session_id');
        $this->travel(24)->hours();
        $this->travel(1)->minutes();
        app(OrderExpiryService::class)->sweep();
        self::assertSame(['EXPIRED', 'EXPIRED'], [$this->orderState($orderId), $this->paymentState($attempt['id'])]);

        // The capture arrives anyway (for example, the provider expiry raced the window).
        $this->deliverWebhook($this->gateway->complete($session), 'wh-late')->assertOk();
        $payment = DB::table('payments')->where('id', $attempt['id'])->first();
        self::assertSame(['PAID', true], [$payment->state, (bool) $payment->late_capture]);
        self::assertSame('EXPIRED', $this->orderState($orderId));
        $refund = DB::table('refunds')->where('source_payment_id', $attempt['id'])->first();
        self::assertSame(['TECHNICAL_COMPENSATION', (int) $payment->total_centavos, 'REFUNDED'], [$refund->trigger, (int) $refund->amount_centavos, $refund->state]);
        self::assertSame('REFUNDED', (string) DB::table('orders')->where('id', $orderId)->value('refund_state'));
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'LATE_CAPTURE_COMPENSATION')->where('vendor_organization_id', $store->id)->count());
        self::assertSame(0, DB::table('remittance_assessments')->where('payment_id', $attempt['id'])->count(), 'A compensated capture is not a merchant remittance.');

        // Compensation is idempotent.
        $this->deliverWebhook($this->gateway->complete($session), 'wh-late-again')->assertOk();
        self::assertSame(1, DB::table('refunds')->where('source_payment_id', $attempt['id'])->count());
        self::assertSame(1, $this->gateway->refundCalls);
    }

    public function test_environment_contract_and_account_readiness_are_revalidated_before_each_payment(): void
    {
        [$store, , $buyer, $orderId] = $this->awaitingPayment('Guard Hardware');
        $options = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->json('data');
        $total = collect($options['channels'])->firstWhere('code', 'GCASH')['total_centavos'];
        $attempt = fn () => $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => 'GCASH', 'expected_total_centavos' => $total], ['Idempotency-Key' => (string) Str::uuid7()]);

        DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->update(['environment' => 'LIVE']);
        $attempt()->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ENVIRONMENT_MISMATCH');
        DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->update(['environment' => 'TEST', 'provider_api_version' => 'XENDIT_ACCOUNTS_V3']);
        $attempt()->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_CONTRACT_MISMATCH');
        DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->update(['provider_api_version' => 'XENDIT_ACCOUNTS_V2']);
        $this->gateway->blockedAccounts = [(string) DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->value('provider_account_id')];
        $attempt()->assertStatus(409)->assertJsonPath('errors.0.code', 'VENDOR_PAYMENT_ACCOUNT_NOT_READY');
        self::assertSame(0, $this->gateway->createCalls);
        self::assertSame(0, DB::table('payments')->count());

        // An uncertain provisioning record is a separate scope: it neither blocks this payment nor is retried by it.
        $this->gateway->blockedAccounts = [];
        DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->update(['onboarding_requested_at' => now(), 'last_error_code' => 'PROVIDER_ONBOARDING_UNCERTAIN']);
        $attempt()->assertCreated();
        self::assertStringStartsNotWith('payment|', (string) DB::table('payments')->value('idempotency_key'));
        self::assertSame(1, DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->count());
    }

    public function test_database_rejects_platform_fee_to_a_vendor_account_and_fake_evidence_labelled_as_xendit(): void
    {
        [$store, , $buyer, $orderId] = $this->awaitingPayment('Constraint Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->expectException(QueryException::class);
        DB::table('payments')->where('id', $attempt['id'])->update(['gateway_mode' => 'SIMULATED', 'evidence_origin' => 'XENDIT_TEST']);
    }

    public function test_platform_fee_payment_cannot_route_to_a_vendor_sub_account(): void
    {
        [$store] = $this->awaitingPayment('Scope Hardware');
        $this->expectException(QueryException::class);
        DB::table('payments')->insert(['id' => (string) Str::uuid7(), 'purpose' => 'PLATFORM_FEE_PAYMENT', 'account_scope' => 'VENDOR_SUB_ACCOUNT', 'provider_account_id' => 'acct', 'order_id' => DB::table('orders')->value('id'),
            'vendor_organization_id' => $store->id, 'principal_centavos' => 100, 'processing_fee_centavos' => 0, 'total_centavos' => 100, 'idempotency_key' => Str::random(20), 'state' => 'CREATING',
            'gateway_mode' => 'SIMULATED', 'evidence_origin' => 'SIMULATED', 'created_at' => now(), 'updated_at' => now()]);
    }
}
