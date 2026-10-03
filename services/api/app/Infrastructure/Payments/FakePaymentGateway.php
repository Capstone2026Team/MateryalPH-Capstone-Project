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
use Illuminate\Support\Facades\Cache;

/**
 * Deterministic payment simulator for automated tests and offline demos. Identifiers derive from the reference
 * (the same reference always yields the same session), state lives in the configured cache, and every result is
 * SIMULATED evidence: the descriptor can never report XENDIT_TEST, so a fake success is never promoted to a real
 * Xendit TEST payment. Failure injection lets tests exercise rejected, uncertain, unreachable and mismatched paths.
 */
final class FakePaymentGateway implements PaymentGateway
{
    /** Next createSession outcome: REJECT, TIMEOUT (nothing created) or TIMEOUT_AFTER_CREATE (created, response lost). */
    public ?string $nextCreate = null;

    public bool $retrieveUnavailable = false;

    /** Next refund outcome: REJECT, TIMEOUT or TIMEOUT_AFTER_CREATE. */
    public ?string $nextRefund = null;

    /** @var list<string> Accounts the simulated provider reports as not ready. */
    public array $blockedAccounts = [];

    public int $createCalls = 0;

    public int $retrieveCalls = 0;

    public int $refundCalls = 0;

    public function descriptor(): GatewayDescriptor
    {
        return new GatewayDescriptor('SIMULATED', 'SIMULATED', 'TEST', 'SIMULATED_PAYMENT_SESSIONS', 'XENDIT_ACCOUNTS_V2', 0,
            ['CARDS', 'GCASH', 'PAYMAYA', 'GRABPAY', 'SHOPEEPAY'], true);
    }

    public function verifyAccount(string $providerAccountId): AccountCapability
    {
        $ready = ! in_array($providerAccountId, $this->blockedAccounts, true);

        return new AccountCapability($providerAccountId, $ready ? 'LIVE' : 'SUSPENDED', 'TEST', $ready, $ready ? null : 'PROVIDER_ACCOUNT_NOT_READY');
    }

    public function createSession(SessionRequest $request): SessionResult
    {
        $this->createCalls++;
        $outcome = $this->nextCreate;
        $this->nextCreate = null;
        if ($outcome === 'REJECT') {
            throw new PaymentProviderException(PaymentProviderException::REJECTED, 'SIMULATED_VALIDATION_ERROR', 400);
        }
        if ($outcome === 'TIMEOUT') {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }
        $sessionId = self::sessionIdFor($request->referenceId);
        $existing = $this->load($sessionId);
        if ($existing === null) {
            $this->store($sessionId, ['reference_id' => $request->referenceId, 'status' => 'ACTIVE', 'amount_centavos' => $request->amountCentavos, 'currency' => $request->currency,
                'business_id' => $request->forUserId ?? 'sim-platform-master', 'for_user_id' => $request->forUserId, 'channel' => $request->providerChannelCode,
                'expires_at' => $request->expiresAt->toIso8601String(), 'payment_id' => null, 'payment_request_id' => null]);
        }
        if ($outcome === 'TIMEOUT_AFTER_CREATE') {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }

        return new SessionResult($sessionId, 'ACTIVE', 'https://checkout.simulated.invalid/'.$sessionId, $request->expiresAt->toIso8601String(), $request->forUserId ?? 'sim-platform-master');
    }

    public function retrieveSession(string $sessionId, ?string $forUserId): ProviderSession
    {
        $this->retrieveCalls++;
        if ($this->retrieveUnavailable) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'PROVIDER_UNREACHABLE_RETRIEVE');
        }
        $session = $this->load($sessionId);
        if ($session === null || ($session['for_user_id'] ?? null) !== $forUserId) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'SESSION_NOT_FOUND', 404);
        }

        return new ProviderSession($sessionId, (string) $session['reference_id'], (string) $session['status'], (int) $session['amount_centavos'], (string) $session['currency'],
            $session['payment_id'], $session['payment_request_id'], (string) $session['business_id'], (string) $session['channel']);
    }

    public function cancelSession(string $sessionId, ?string $forUserId): void
    {
        $session = $this->load($sessionId);
        if ($session !== null && $session['status'] === 'ACTIVE') {
            $this->store($sessionId, ['status' => 'CANCELED'] + $session);
        }
    }

    /**
     * Like the provider, a refund is idempotent per key and starts PENDING; settleRefund() completes it and returns
     * the webhook body. Failure injection: REJECT (definitive, e.g. insufficient balance), TIMEOUT (nothing created)
     * or TIMEOUT_AFTER_CREATE (created, response lost).
     */
    public function refund(RefundRequest $request): RefundResult
    {
        $this->refundCalls++;
        $outcome = $this->nextRefund;
        $this->nextRefund = null;
        if ($outcome === 'REJECT') {
            throw new PaymentProviderException(PaymentProviderException::REJECTED, 'INSUFFICIENT_BALANCE', 400);
        }
        if ($outcome === 'TIMEOUT') {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }
        $providerId = 'rfd-sim-'.substr(hash('sha256', $request->idempotencyKey), 0, 24);
        if ($this->loadRefund($providerId) === null) {
            $this->storeRefund($providerId, ['reference_id' => $request->referenceId, 'payment_request_id' => $request->paymentRequestId, 'amount_centavos' => $request->amountCentavos,
                'currency' => $request->currency, 'for_user_id' => $request->forUserId, 'status' => 'PENDING', 'failure_code' => null]);
        }
        if ($outcome === 'TIMEOUT_AFTER_CREATE') {
            throw new PaymentProviderException(PaymentProviderException::UNCERTAIN, 'PROVIDER_TIMEOUT');
        }

        return new RefundResult($providerId, 'PENDING');
    }

    public function retrieveRefund(string $providerRefundId, ?string $forUserId): ProviderRefund
    {
        $this->retrieveCalls++;
        if ($this->retrieveUnavailable) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'PROVIDER_UNREACHABLE_REFUND_RETRIEVE');
        }
        $refund = $this->loadRefund($providerRefundId);
        if ($refund === null || ($refund['for_user_id'] ?? null) !== $forUserId) {
            throw new PaymentProviderException(PaymentProviderException::UNAVAILABLE, 'REFUND_NOT_FOUND', 404);
        }

        return new ProviderRefund($providerRefundId, (string) $refund['reference_id'], (string) $refund['payment_request_id'], (string) $refund['status'],
            (int) $refund['amount_centavos'], (string) $refund['currency'], $refund['failure_code']);
    }

    /**
     * Completes a simulated refund (SUCCEEDED or FAILED) and returns the refund webhook the provider would send.
     * $amountCentavos overrides the event amount to exercise mismatch handling.
     *
     * @return array<string, mixed>
     */
    public function settleRefund(string $providerRefundId, string $status = 'SUCCEEDED', ?int $amountCentavos = null): array
    {
        $refund = $this->loadRefund($providerRefundId) ?? throw new \LogicException('Unknown simulated refund.');
        $refund = ['status' => $status, 'failure_code' => $status === 'FAILED' ? 'INSUFFICIENT_BALANCE' : null] + $refund;
        $this->storeRefund($providerRefundId, $refund);

        return ['event' => $status === 'SUCCEEDED' ? 'refund.succeeded' : 'refund.failed', 'business_id' => $refund['for_user_id'] ?? 'sim-platform-master',
            'created' => now()->utc()->format('Y-m-d\TH:i:s.v\Z'), 'api_version' => 'SIMULATED', 'data' => [
                'id' => $providerRefundId, 'reference_id' => $refund['reference_id'], 'payment_request_id' => $refund['payment_request_id'], 'status' => $status,
                'amount' => ProviderAmount::toProvider($amountCentavos ?? (int) $refund['amount_centavos']), 'currency' => $refund['currency'], 'failure_code' => $refund['failure_code'],
            ]];
    }

    /** @return array<string, mixed>|null */
    private function loadRefund(string $providerRefundId): ?array
    {
        $value = Cache::get('simulated-refunds:'.$providerRefundId);

        return is_array($value) ? $value : null;
    }

    /** @param array<string, mixed> $refund */
    private function storeRefund(string $providerRefundId, array $refund): void
    {
        Cache::forever('simulated-refunds:'.$providerRefundId, $refund);
    }

    /**
     * Completes the session as the simulated provider would and returns the webhook body it would send.
     * $amountCentavos overrides the captured amount to exercise mismatch handling.
     *
     * @return array<string, mixed>
     */
    public function complete(string $sessionId, ?int $amountCentavos = null): array
    {
        $session = $this->load($sessionId) ?? throw new \LogicException('Unknown simulated session.');
        $suffix = substr(hash('sha256', $sessionId), 0, 24);
        $session = ['status' => 'COMPLETED', 'payment_id' => 'py-sim-'.$suffix, 'payment_request_id' => 'pr-sim-'.$suffix] + $session;
        $this->store($sessionId, $session);

        return $this->webhook('payment_session.completed', $sessionId, $session, $amountCentavos);
    }

    /** @return array<string, mixed> */
    public function expire(string $sessionId): array
    {
        $session = $this->load($sessionId) ?? throw new \LogicException('Unknown simulated session.');
        $session = ['status' => 'EXPIRED'] + $session;
        $this->store($sessionId, $session);

        return $this->webhook('payment_session.expired', $sessionId, $session, null);
    }

    public static function sessionIdFor(string $referenceId): string
    {
        return 'ps-sim'.substr(hash('sha256', $referenceId), 0, 21);
    }

    /**
     * @param  array<string, mixed>  $session
     * @return array<string, mixed>
     */
    private function webhook(string $event, string $sessionId, array $session, ?int $amountCentavos): array
    {
        return ['event' => $event, 'business_id' => $session['business_id'], 'created' => now()->utc()->format('Y-m-d\TH:i:s.v\Z'), 'api_version' => 'SIMULATED', 'data' => [
            'payment_session_id' => $sessionId, 'reference_id' => $session['reference_id'], 'status' => $session['status'],
            'amount' => ProviderAmount::toProvider($amountCentavos ?? (int) $session['amount_centavos']), 'currency' => $session['currency'],
            'payment_id' => $session['payment_id'], 'payment_request_id' => $session['payment_request_id'], 'business_id' => $session['business_id'], 'session_type' => 'PAY',
        ]];
    }

    /** @return array<string, mixed>|null */
    private function load(string $sessionId): ?array
    {
        $value = Cache::get('simulated-payments:'.$sessionId);

        return is_array($value) ? $value : null;
    }

    /** @param array<string, mixed> $session */
    private function store(string $sessionId, array $session): void
    {
        Cache::forever('simulated-payments:'.$sessionId, $session);
    }
}
