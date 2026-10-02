<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Asynchronous processing of one stored, token-verified webhook. The payload is only a trigger: it must name a
 * known attempt and agree with it on session, reference, amount, currency and account, and then the selected
 * adapter fetches the session authoritatively before PaymentSettlement may change anything. Unknown references,
 * forged or mismatched payloads and out-of-order events can therefore never create a paid order. A provider read
 * that fails leaves the event RECEIVED for retry and scheduled reconciliation.
 */
final class XenditWebhookProcessor
{
    private const SESSION_EVENTS = ['payment_session.completed', 'payment_session.expired'];

    private const PAYMENT_EVENTS = ['payment.capture', 'payment.failure', 'payment.authorization', 'payment_request.expiry'];

    private const REFUND_EVENTS = ['refund.succeeded', 'refund.failed'];

    public function __construct(
        private readonly PaymentSettlement $settlement,
        private readonly PaymentReconciliationService $reconciliation,
        private readonly PaymentGateway $gateway,
    ) {}

    public function process(string $webhookEventId): string
    {
        return Cache::lock('xendit-webhook:'.$webhookEventId, 60)->block(10, fn (): string => $this->handle($webhookEventId));
    }

    private function handle(string $webhookEventId): string
    {
        $row = DB::table('webhook_events')->where('id', $webhookEventId)->first();
        if ($row === null || $row->state !== 'RECEIVED' || $row->payload_encrypted === null) {
            return 'SKIPPED';
        }
        DB::table('webhook_events')->where('id', $webhookEventId)->update(['attempts' => (int) $row->attempts + 1, 'updated_at' => now()]);
        $payload = json_decode(Crypt::decryptString((string) $row->payload_encrypted), true) ?: [];
        $event = (string) ($payload['event'] ?? '');
        $data = is_array($payload['data'] ?? null) ? $payload['data'] : [];
        if (in_array($event, self::REFUND_EVENTS, true)) {
            return $this->finish($webhookEventId, $this->refund($event, $data));
        }
        if (! in_array($event, [...self::SESSION_EVENTS, ...self::PAYMENT_EVENTS], true)) {
            return $this->finish($webhookEventId, 'UNSUPPORTED_EVENT', 'IGNORED');
        }
        $payment = $this->payment($data);
        if ($payment === null) {
            return $this->finish($webhookEventId, 'UNKNOWN_REFERENCE', 'IGNORED');
        }
        if (in_array($event, self::SESSION_EVENTS, true)) {
            $claimed = new ProviderSession((string) ($data['payment_session_id'] ?? ''), (string) ($data['reference_id'] ?? ''), strtoupper((string) ($data['status'] ?? '')),
                ProviderAmount::toCentavos($data['amount'] ?? null), (string) ($data['currency'] ?? ''), is_string($data['payment_id'] ?? null) ? $data['payment_id'] : null,
                is_string($data['payment_request_id'] ?? null) ? $data['payment_request_id'] : null, is_string($data['business_id'] ?? $payload['business_id'] ?? null) ? ($data['business_id'] ?? $payload['business_id']) : null);
            $mismatch = $this->settlement->mismatch($payment, $claimed);
            if ($mismatch !== null) {
                $this->settlement->apply((string) $payment->id, $claimed, 'WEBHOOK', $webhookEventId, (string) Str::uuid7());

                return $this->finish($webhookEventId, $mismatch, 'REJECTED');
            }
            if ($payment->provider_session_id === null) {
                // An uncertain create learns its session reference only from an authoritative read of that session.
                try {
                    $session = $this->gateway->retrieveSession($claimed->sessionId, PaymentReconciliationService::forUserId($payment));
                } catch (PaymentProviderException) {
                    return 'RETRY';
                }
                if ($session->referenceId === (string) $payment->id && $session->sessionId === $claimed->sessionId) {
                    DB::table('payments')->where('id', $payment->id)->whereNull('provider_session_id')->update(['provider_session_id' => $session->sessionId, 'updated_at' => now()]);
                }
                $result = $this->settlement->apply((string) $payment->id, $session, 'WEBHOOK', $webhookEventId, (string) Str::uuid7());

                return $this->finish($webhookEventId, $result, $result === 'MISMATCH' ? 'REJECTED' : 'PROCESSED');
            }
        }
        $result = $this->reconciliation->reconcile((string) $payment->id, 'WEBHOOK', $webhookEventId);
        if ($result === 'UNAVAILABLE') {
            return 'RETRY';
        }

        return $this->finish($webhookEventId, $result, $result === 'MISMATCH' ? 'REJECTED' : 'PROCESSED');
    }

    /** @param array<string, mixed> $data */
    private function payment(array $data): ?object
    {
        $reference = $data['reference_id'] ?? null;
        if (is_string($reference) && Str::isUuid($reference)) {
            $payment = DB::table('payments')->where('id', $reference)->first();
            if ($payment !== null) {
                return $payment;
            }
        }
        foreach (['payment_session_id' => 'provider_session_id', 'payment_request_id' => 'provider_payment_request_id', 'payment_id' => 'provider_payment_id'] as $field => $column) {
            $value = $data[$field] ?? null;
            if (is_string($value) && preg_match('/^[A-Za-z0-9_-]{3,128}$/', $value) === 1) {
                $payment = DB::table('payments')->where($column, $value)->first();
                if ($payment !== null) {
                    return $payment;
                }
            }
        }

        return null;
    }

    /** @param array<string, mixed> $data */
    private function refund(string $event, array $data): string
    {
        $refundId = $data['reference_id'] ?? null;
        $refund = is_string($refundId) && Str::isUuid($refundId) ? DB::table('refunds')->where('id', $refundId)->first() : null;
        if ($refund === null || ProviderAmount::toCentavos($data['amount'] ?? null) !== (int) $refund->amount_centavos || ($data['currency'] ?? 'PHP') !== 'PHP') {
            return 'UNKNOWN_OR_MISMATCHED_REFUND';
        }
        if ($event === 'refund.succeeded') {
            $this->settlement->refundSucceeded((string) $refund->id, (string) Str::uuid7());
        } else {
            DB::table('refunds')->where('id', $refund->id)->where('state', 'REFUND_PENDING')->update(['state' => 'REFUND_FAILED', 'failure_code' => 'PROVIDER_REFUND_FAILED', 'updated_at' => now()]);
        }

        return 'REFUND_UPDATED';
    }

    private function finish(string $webhookEventId, string $result, string $state = 'PROCESSED'): string
    {
        DB::table('webhook_events')->where('id', $webhookEventId)->where('state', 'RECEIVED')->update(['state' => $state, 'result_code' => mb_substr($result, 0, 64), 'processed_at' => now(), 'updated_at' => now()]);

        return $result;
    }
}
