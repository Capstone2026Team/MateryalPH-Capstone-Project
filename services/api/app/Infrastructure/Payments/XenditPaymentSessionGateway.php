<?php

declare(strict_types=1);

namespace App\Infrastructure\Payments;

use App\Domain\Payments\AccountCapability;
use App\Domain\Payments\GatewayDescriptor;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentProviderException;
use App\Domain\Payments\ProviderAmount;
use App\Domain\Payments\ProviderRefund;
use App\Domain\Payments\ProviderSession;
use App\Domain\Payments\RefundRequest;
use App\Domain\Payments\RefundResult;
use App\Domain\Payments\SessionRequest;
use App\Domain\Payments\SessionResult;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;

/**
 * Xendit TEST adapter for hosted Payment Sessions (`POST /sessions`, mode PAYMENT_LINK) routed to a xenPlatform
 * sub-account with the `for-user-id` header, per the current Payment Sessions and sub-account documentation.
 * Invoices are documented as legacy and are not used. Account readiness keeps the Phase 3D Accounts v2 contract
 * (`GET /v2/accounts/{id}`) so checkout never switches the association's API version.
 *
 * The create endpoint documents no idempotency key, so a create is never retried automatically: a timeout or
 * 5xx is UNCERTAIN and the attempt is reconciled through the reference instead. Only the secret key from backend
 * configuration is used; responses are reduced to the fields MateryalPH stores and are never logged in full.
 */
final class XenditPaymentSessionGateway implements PaymentGateway
{
    private const ORIGIN = 'https://api.xendit.co';

    private const CHANNELS = ['CARDS', 'GCASH', 'PAYMAYA', 'GRABPAY', 'SHOPEEPAY'];

    public function descriptor(): GatewayDescriptor
    {
        $reason = $this->unavailableReason();

        return new GatewayDescriptor('XENDIT_TEST', 'XENDIT_TEST', 'TEST', 'XENDIT_PAYMENT_SESSIONS', 'XENDIT_ACCOUNTS_V2',
            (int) config('payments.provider_minimum_expiry_seconds', 600), self::CHANNELS, $reason === null, $reason);
    }

    public function verifyAccount(string $providerAccountId): AccountCapability
    {
        if (preg_match('/^[A-Za-z0-9_-]{3,128}$/', $providerAccountId) !== 1) {
            return new AccountCapability($providerAccountId, 'INVALID', 'TEST', false, 'ACCOUNT_REFERENCE_INVALID');
        }
        $response = $this->send(fn (PendingRequest $http): Response => $http->get(self::ORIGIN.'/v2/accounts/'.$providerAccountId), 'ACCOUNT_CHECK');
        $payload = $response->json();
        if (! $response->successful() || ! is_array($payload) || ($payload['id'] ?? null) !== $providerAccountId) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'ACCOUNT_NOT_VERIFIED', $response->status(), $this->requestId($response));
        }
        $status = is_string($payload['status'] ?? null) ? strtoupper($payload['status']) : 'UNKNOWN';

        // A TEST master key only ever reaches TEST accounts; provider status LIVE there is TEST readiness only.
        return new AccountCapability($providerAccountId, $status, 'TEST', $status === 'LIVE', $status === 'LIVE' ? null : 'PROVIDER_ACCOUNT_NOT_READY');
    }

    public function createSession(SessionRequest $request): SessionResult
    {
        $body = array_filter([
            'reference_id' => $request->referenceId,
            'session_type' => 'PAY',
            'mode' => 'PAYMENT_LINK',
            'amount' => ProviderAmount::toProvider($request->amountCentavos),
            'currency' => $request->currency,
            'country' => 'PH',
            'capture_method' => 'AUTOMATIC',
            'allowed_payment_channels' => [$request->providerChannelCode],
            'expires_at' => $request->expiresAt->utc()->format('Y-m-d\TH:i:s\Z'),
            'description' => mb_substr($request->description, 0, 1000),
            'customer' => array_filter([
                'reference_id' => $request->customer['reference_id'],
                'type' => 'INDIVIDUAL',
                'email' => $request->customer['email'],
                'individual_detail' => ['given_names' => mb_substr($request->customer['given_names'], 0, 50)],
            ], static fn (mixed $value): bool => $value !== null),
            'success_return_url' => $request->successReturnUrl,
            'cancel_return_url' => $request->cancelReturnUrl,
        ], static fn (mixed $value): bool => $value !== null);
        try {
            $response = $this->client($request->forUserId)->post(self::ORIGIN.'/sessions', $body);
        } catch (ConnectionException) {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }
        if ($response->status() >= 500) {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_SERVER_ERROR', $response->status(), $this->requestId($response));
        }
        if (! $response->successful()) {
            throw new PaymentProviderException(PaymentProviderException::REJECTED, $this->errorCode($response), $response->status(), $this->requestId($response));
        }
        $payload = $response->json();
        $sessionId = is_array($payload) ? ($payload['payment_session_id'] ?? null) : null;
        if (! is_string($sessionId) || preg_match('/^ps-[A-Za-z0-9]{6,61}$/', $sessionId) !== 1
            || ($payload['reference_id'] ?? null) !== $request->referenceId
            || ProviderAmount::toCentavos($payload['amount'] ?? null) !== $request->amountCentavos
            || ($payload['currency'] ?? null) !== $request->currency) {
            // A 2xx with an unverifiable body may still have created a session; reconcile, never assume either way.
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_RESPONSE_INVALID', $response->status(), $this->requestId($response));
        }
        $url = $payload['payment_link_url'] ?? null;

        return new SessionResult($sessionId, is_string($payload['status'] ?? null) ? $payload['status'] : 'ACTIVE',
            is_string($url) && str_starts_with($url, 'https://') ? $url : null, is_string($payload['expires_at'] ?? null) ? $payload['expires_at'] : null,
            is_string($payload['business_id'] ?? null) ? $payload['business_id'] : null, $this->requestId($response));
    }

    public function retrieveSession(string $sessionId, ?string $forUserId): ProviderSession
    {
        if (preg_match('/^ps-[A-Za-z0-9]{6,61}$/', $sessionId) !== 1) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'SESSION_REFERENCE_INVALID');
        }
        $response = $this->send(fn (PendingRequest $http): Response => $http->get(self::ORIGIN.'/sessions/'.$sessionId), 'RETRIEVE', $forUserId);
        $payload = $response->json();
        if (! $response->successful() || ! is_array($payload) || ($payload['payment_session_id'] ?? null) !== $sessionId || ! is_string($payload['reference_id'] ?? null)) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, $response->status() === 404 ? 'SESSION_NOT_FOUND' : 'SESSION_NOT_VERIFIED', $response->status(), $this->requestId($response));
        }

        return new ProviderSession($sessionId, $payload['reference_id'], is_string($payload['status'] ?? null) ? strtoupper($payload['status']) : 'UNKNOWN',
            ProviderAmount::toCentavos($payload['amount'] ?? null), is_string($payload['currency'] ?? null) ? $payload['currency'] : '',
            is_string($payload['payment_id'] ?? null) ? $payload['payment_id'] : null, is_string($payload['payment_request_id'] ?? null) ? $payload['payment_request_id'] : null,
            is_string($payload['business_id'] ?? null) ? $payload['business_id'] : null);
    }

    public function cancelSession(string $sessionId, ?string $forUserId): void
    {
        if (preg_match('/^ps-[A-Za-z0-9]{6,61}$/', $sessionId) !== 1) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'SESSION_REFERENCE_INVALID');
        }
        $response = $this->send(fn (PendingRequest $http): Response => $http->post(self::ORIGIN.'/sessions/'.$sessionId.'/cancel'), 'CANCEL', $forUserId);
        if (! $response->successful() && $response->status() !== 409) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, $this->errorCode($response), $response->status(), $this->requestId($response));
        }
    }

    /**
     * `POST /refunds` against the original payment request with the `for-user-id` sub-account. The idempotency key is
     * per attempt, so a timeout resend returns the refund the provider already created instead of a second refund.
     */
    public function refund(RefundRequest $request): RefundResult
    {
        try {
            $response = $this->client($request->forUserId)->withHeaders(['idempotency-key' => $request->idempotencyKey])->post(self::ORIGIN.'/refunds', [
                'reference_id' => $request->referenceId, 'payment_request_id' => $request->paymentRequestId,
                'amount' => ProviderAmount::toProvider($request->amountCentavos), 'currency' => $request->currency, 'reason' => 'OTHERS',
                'metadata' => ['materyalph_reason' => mb_substr($request->reason, 0, 120)],
            ]);
        } catch (ConnectionException) {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }
        $payload = $response->json();
        if (! $response->successful() || ! is_array($payload) || ! is_string($payload['id'] ?? null)) {
            throw new PaymentProviderException($response->status() >= 500 ? PaymentProviderException::UNCERTAIN : PaymentProviderException::REJECTED, $this->errorCode($response), $response->status(), $this->requestId($response));
        }

        return new RefundResult($payload['id'], is_string($payload['status'] ?? null) ? $payload['status'] : 'PENDING');
    }

    /** Authoritative `GET /refunds/{id}` read used by webhook processing and reconciliation. */
    public function retrieveRefund(string $providerRefundId, ?string $forUserId): ProviderRefund
    {
        if (preg_match('/^[A-Za-z0-9_-]{3,128}$/', $providerRefundId) !== 1) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'REFUND_REFERENCE_INVALID');
        }
        $response = $this->send(fn (PendingRequest $http): Response => $http->get(self::ORIGIN.'/refunds/'.$providerRefundId), 'REFUND_RETRIEVE', $forUserId);
        $payload = $response->json();
        if (! $response->successful() || ! is_array($payload) || ($payload['id'] ?? null) !== $providerRefundId || ! is_string($payload['reference_id'] ?? null)) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, $response->status() === 404 ? 'REFUND_NOT_FOUND' : 'REFUND_NOT_VERIFIED', $response->status(), $this->requestId($response));
        }

        return new ProviderRefund($providerRefundId, $payload['reference_id'], is_string($payload['payment_request_id'] ?? null) ? $payload['payment_request_id'] : null,
            is_string($payload['status'] ?? null) ? strtoupper($payload['status']) : 'UNKNOWN', ProviderAmount::toCentavos($payload['amount'] ?? null),
            is_string($payload['currency'] ?? null) ? $payload['currency'] : '', is_string($payload['failure_code'] ?? null) ? mb_substr($payload['failure_code'], 0, 64) : null);
    }

    private function send(callable $call, string $operation, ?string $forUserId = null): Response
    {
        try {
            return $call($this->client($forUserId));
        } catch (ConnectionException) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'PROVIDER_UNREACHABLE_'.$operation);
        }
    }

    private function client(?string $forUserId): PendingRequest
    {
        $reason = $this->unavailableReason();
        if ($reason !== null) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, $reason);
        }
        if ($forUserId !== null && preg_match('/^[A-Za-z0-9_-]{3,128}$/', $forUserId) !== 1) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'ACCOUNT_REFERENCE_INVALID');
        }
        $timeout = (int) config('services.xendit.timeout_seconds', 5);
        $http = Http::withBasicAuth((string) config('services.xendit.secret_key'), '')->acceptJson()->asJson()->withoutRedirecting()->connectTimeout($timeout)->timeout($timeout);

        return $forUserId === null ? $http : $http->withHeaders(['for-user-id' => $forUserId]);
    }

    private function unavailableReason(): ?string
    {
        $key = config('services.xendit.secret_key');
        if (config('services.xendit.mode') !== 'TEST' || ! is_string($key) || ! str_starts_with($key, 'xnd_development_')) {
            return 'TEST_KEY_NOT_CONFIGURED';
        }

        return rtrim((string) config('services.xendit.base_url', self::ORIGIN), '/') === self::ORIGIN ? null : 'PROVIDER_ORIGIN_UNSUPPORTED';
    }

    private function errorCode(Response $response): string
    {
        $code = $response->json('error_code');

        return is_string($code) && preg_match('/^[A-Z][A-Z0-9_]{2,63}$/', $code) === 1 ? $code : 'PROVIDER_HTTP_'.$response->status();
    }

    private function requestId(Response $response): ?string
    {
        $id = $response->header('Request-Id');

        return preg_match('/^[A-Za-z0-9._:-]{1,128}$/', $id) === 1 ? $id : null;
    }
}
