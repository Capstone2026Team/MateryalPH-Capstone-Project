<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Payments\PaymentGateway;
use App\Infrastructure\Payments\FakePaymentGateway;
use App\Models\User;
use App\Models\VendorOrganization;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;

/**
 * Phase 11 fixtures on top of CreatesOrderFixtures: the deterministic SIMULATED payment adapter, a synthetic
 * callback token (never a real credential), orders brought to AWAITING_PAYMENT through the real Vendor API,
 * payment attempts through the Buyer API and provider events through the real webhook inbox.
 */
trait CreatesPaymentFixtures
{
    protected FakePaymentGateway $gateway;

    protected string $callbackToken;

    protected function fakePayments(): void
    {
        $this->gateway = new FakePaymentGateway;
        $this->app->instance(PaymentGateway::class, $this->gateway);
        $this->callbackToken = 'synthetic-test-callback-token-'.Str::random(40);
        config()->set('services.xendit.webhook_token', $this->callbackToken);
        config()->set('services.xendit.platform_account_id', null);
    }

    /**
     * A confirmed Self-Pickup order awaiting online payment.
     *
     * @param  list<array{price?: int, qty?: string, tax?: string}>  $variants
     * @return array{0: VendorOrganization, 1: User, 2: User, 3: string}
     */
    protected function awaitingPayment(string $name, array $variants = [['price' => 100000, 'qty' => '50']], string $quantity = '10'): array
    {
        [$store, $owner, $listing] = $this->pickupStore($name, $variants);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => $quantity]]);
        $this->confirmOrder($owner, $orderId)->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT');
        $this->signInBuyer($buyer);

        return [$store, $owner, $buyer, $orderId];
    }

    /** @return array<string, mixed> the created attempt */
    protected function startPayment(User $buyer, string $orderId, string $channel = 'GCASH', ?string $key = null): array
    {
        $this->signInBuyer($buyer);
        $options = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->assertOk()->json('data');
        $total = collect($options['channels'])->firstWhere('code', $channel)['total_centavos'];

        return $this->postJson('/api/v1/buyers/orders/'.$orderId.'/payments', ['channel_code' => $channel, 'expected_total_centavos' => $total], ['Idempotency-Key' => $key ?? (string) Str::uuid7()])
            ->assertCreated()->json('data');
    }

    /** @param array<string, mixed> $body */
    protected function deliverWebhook(array $body, ?string $webhookId = null, ?string $token = null): TestResponse
    {
        return $this->call('POST', '/api/v1/webhooks/xendit', [], [], [], array_filter([
            'CONTENT_TYPE' => 'application/json', 'HTTP_X_CALLBACK_TOKEN' => $token ?? $this->callbackToken, 'HTTP_WEBHOOK_ID' => $webhookId ?? 'wh-'.Str::random(16),
        ], static fn (?string $value): bool => $value !== null), json_encode($body, JSON_THROW_ON_ERROR));
    }

    /** Completes the attempt at the simulated provider and delivers the provider's webhook. */
    protected function completePayment(string $paymentId, ?int $amountCentavos = null, ?string $webhookId = null): TestResponse
    {
        $session = (string) DB::table('payments')->where('id', $paymentId)->value('provider_session_id');

        return $this->deliverWebhook($this->gateway->complete($session, $amountCentavos), $webhookId);
    }

    protected function paymentState(string $paymentId): string
    {
        return (string) DB::table('payments')->where('id', $paymentId)->value('state');
    }

    protected function orderState(string $orderId): string
    {
        return (string) DB::table('orders')->where('id', $orderId)->value('order_state');
    }
}
