<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/**
 * Provider payment/refund evidence only. Every adapter is TEST-scoped in this release; a SIMULATED adapter can
 * never produce XENDIT_TEST evidence. Implementations never log credentials or full provider payloads.
 */
interface PaymentGateway
{
    public function descriptor(): GatewayDescriptor;

    /** Confirms, through the provider, that the associated sub-account can accept payments in this environment. */
    public function verifyAccount(string $providerAccountId): AccountCapability;

    /** @throws PaymentProviderException */
    public function createSession(SessionRequest $request): SessionResult;

    /** @throws PaymentProviderException */
    public function retrieveSession(string $sessionId, ?string $forUserId): ProviderSession;

    /** @throws PaymentProviderException */
    public function cancelSession(string $sessionId, ?string $forUserId): void;

    /** @throws PaymentProviderException */
    public function refund(RefundRequest $request): RefundResult;
}
