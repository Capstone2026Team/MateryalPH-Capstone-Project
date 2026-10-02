<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Payments\PaymentProviderException;
use App\Domain\Payments\SessionRequest;
use App\Infrastructure\Payments\FakePaymentGateway;
use App\Infrastructure\Payments\XenditPaymentSessionGateway;
use Carbon\CarbonImmutable;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\Factory;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use Tests\TestCase;

/**
 * Xendit TEST Payment Sessions adapter contract with HTTP faked. The key is a synthetic, non-credential string in
 * the TEST key format; no request leaves the test. A create is never retried; 5xx/timeout/unverifiable 2xx are
 * UNCERTAIN, 4xx are REJECTED. Actual TEST evidence and SIMULATED evidence are distinct descriptors.
 */
final class PhaseElevenXenditAdapterTest extends TestCase
{
    private function configure(string $mode = 'TEST'): void
    {
        config()->set('services.xendit.mode', $mode);
        config()->set('services.xendit.secret_key', 'xnd_development_'.Str::random(40));
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
    }

    private function request(): SessionRequest
    {
        return new SessionRequest('01a0f000-0000-7000-8000-000000000001', 1026441, 'PHP', 'GCASH', CarbonImmutable::parse('2026-10-02T03:45:00Z'), 'Order ORD-1 (TEST)',
            'sub-account-001', ['reference_id' => 'buyer-abc', 'given_names' => 'Juan', 'email' => 'buyer@example.test'], 'https://app.example.test/api/v1/payments/return?attempt=x', null);
    }

    public function test_unconfigured_or_non_test_keys_are_never_used(): void
    {
        config()->set('services.xendit.secret_key', null);
        $gateway = new XenditPaymentSessionGateway;
        self::assertSame([false, 'TEST_KEY_NOT_CONFIGURED'], [$gateway->descriptor()->configured, $gateway->descriptor()->unavailableReason]);
        $this->configure('LIVE');
        self::assertFalse($gateway->descriptor()->configured);
        Http::fake();
        try {
            $gateway->createSession($this->request());
            self::fail('An unconfigured adapter must not call the provider.');
        } catch (PaymentProviderException $exception) {
            self::assertSame(PaymentProviderException::UNAVAILABLE, $exception->kind);
        }
        Http::assertNothingSent();
    }

    public function test_create_sends_the_documented_payment_session_fields_to_the_sub_account(): void
    {
        $this->configure();
        Http::fake(['api.xendit.co/sessions' => Http::response(['payment_session_id' => 'ps-6752710abcdef0123456789', 'reference_id' => '01a0f000-0000-7000-8000-000000000001', 'amount' => 10264.41,
            'currency' => 'PHP', 'status' => 'ACTIVE', 'payment_link_url' => 'https://dev.xen.to/abc', 'business_id' => 'sub-account-001', 'expires_at' => '2026-10-02T03:45:00Z'], 201, ['Request-Id' => 'req-1'])]);
        $result = (new XenditPaymentSessionGateway)->createSession($this->request());
        self::assertSame(['ps-6752710abcdef0123456789', 'https://dev.xen.to/abc', 'req-1'], [$result->sessionId, $result->checkoutUrl, $result->providerRequestId]);
        Http::assertSent(function (Request $request): bool {
            $body = $request->data();

            return $request->method() === 'POST' && $request->url() === 'https://api.xendit.co/sessions' && $request->header('for-user-id') === ['sub-account-001']
                && str_starts_with($request->header('Authorization')[0] ?? '', 'Basic ') && $body['reference_id'] === '01a0f000-0000-7000-8000-000000000001'
                && $body['session_type'] === 'PAY' && $body['mode'] === 'PAYMENT_LINK' && $body['amount'] === 10264.41 && $body['currency'] === 'PHP' && $body['country'] === 'PH'
                && $body['allowed_payment_channels'] === ['GCASH'] && $body['capture_method'] === 'AUTOMATIC' && $body['expires_at'] === '2026-10-02T03:45:00Z'
                && $body['customer']['type'] === 'INDIVIDUAL' && ! array_key_exists('cancel_return_url', $body);
        });
    }

    public function test_create_outcomes_map_to_rejected_or_uncertain_and_are_never_retried(): void
    {
        $this->configure();
        Http::fake(['api.xendit.co/sessions' => Http::sequence()
            ->push(['error_code' => 'SERVER_ERROR'], 503)
            ->push(['error_code' => 'API_VALIDATION_ERROR'], 400)
            ->push(['payment_session_id' => 'ps-6752710abcdef0123456789', 'reference_id' => 'other', 'amount' => 1, 'currency' => 'PHP'], 201)]);
        foreach (['server error' => PaymentProviderException::UNCERTAIN, 'validation' => PaymentProviderException::REJECTED, 'unverifiable body' => PaymentProviderException::UNCERTAIN] as $name => $kind) {
            try {
                (new XenditPaymentSessionGateway)->createSession($this->request());
                self::fail($name.' must not succeed.');
            } catch (PaymentProviderException $exception) {
                self::assertSame($kind, $exception->kind, $name);
            }
        }
        Http::assertSentCount(3);
        Http::swap(new Factory);
        Http::fake(['api.xendit.co/sessions' => static fn () => throw new ConnectionException('timeout')]);
        try {
            (new XenditPaymentSessionGateway)->createSession($this->request());
            self::fail('A timeout must stay uncertain.');
        } catch (PaymentProviderException $exception) {
            self::assertSame([PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT'], [$exception->kind, $exception->safeCode]);
        }
    }

    public function test_retrieve_and_account_readiness_parse_authoritative_provider_state(): void
    {
        $this->configure();
        Http::fake([
            'api.xendit.co/sessions/*' => Http::response(['payment_session_id' => 'ps-6752710abcdef0123456789', 'reference_id' => 'ref-1', 'status' => 'COMPLETED', 'amount' => 10264.41,
                'currency' => 'PHP', 'payment_id' => 'py-1', 'payment_request_id' => 'pr-1', 'business_id' => 'sub-account-001']),
            'api.xendit.co/v2/accounts/sub-ready' => Http::response(['id' => 'sub-ready', 'status' => 'LIVE', 'type' => 'OWNED']),
            'api.xendit.co/v2/accounts/sub-pending' => Http::response(['id' => 'sub-pending', 'status' => 'REGISTERED', 'type' => 'OWNED']),
        ]);
        $gateway = new XenditPaymentSessionGateway;
        $session = $gateway->retrieveSession('ps-6752710abcdef0123456789', 'sub-account-001');
        self::assertSame([true, 1026441, 'py-1', 'pr-1'], [$session->completed(), $session->amountCentavos, $session->paymentId, $session->paymentRequestId]);
        $ready = $gateway->verifyAccount('sub-ready');
        self::assertSame([true, 'TEST', 'LIVE'], [$ready->canAcceptPayments, $ready->environment, $ready->rawStatus], 'Raw LIVE under a TEST key is TEST readiness only.');
        self::assertFalse($gateway->verifyAccount('sub-pending')->canAcceptPayments);
        Http::assertSent(static fn (Request $request): bool => str_contains($request->url(), '/v2/accounts/') && $request->method() === 'GET');
    }

    public function test_actual_test_evidence_and_simulated_evidence_are_distinct(): void
    {
        $this->configure();
        $actual = (new XenditPaymentSessionGateway)->descriptor();
        $fake = (new FakePaymentGateway)->descriptor();
        self::assertSame(['XENDIT_TEST', 'XENDIT_TEST', 'XENDIT_ACCOUNTS_V2'], [$actual->mode, $actual->evidenceOrigin, $actual->accountContractVersion]);
        self::assertSame(['SIMULATED', 'SIMULATED', 'XENDIT_ACCOUNTS_V2'], [$fake->mode, $fake->evidenceOrigin, $fake->accountContractVersion]);
        self::assertSame(600, $actual->minimumExpirySeconds);
    }
}
