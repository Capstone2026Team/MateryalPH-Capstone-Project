<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

/**
 * Fast inbox for `/api/v1/webhooks/xendit`. Xendit's current documentation authenticates callbacks with the
 * `x-callback-token` header (no HMAC signature header is documented), so the token is compared in constant time
 * against backend configuration and the endpoint fails closed when it is not configured. The raw body is stored
 * once, encrypted, keyed by the provider `webhook-id` (or a digest of the event identity when absent); the inbox
 * acknowledges immediately and an outbox job processes the event asynchronously. Nothing here changes a payment.
 */
final class XenditWebhookInbox
{
    public function __construct(private readonly OutboxPublisher $outbox) {}

    /** @return array{received: bool, duplicate: bool, event_id: string} */
    public function receive(string $rawBody, ?string $callbackToken, ?string $webhookId): array
    {
        $expected = config('services.xendit.webhook_token');
        if (! is_string($expected) || trim($expected) === '') {
            throw new AuthenticationException('WEBHOOK_NOT_CONFIGURED', 'The provider notification endpoint is not configured.', 503);
        }
        if (! is_string($callbackToken) || ! hash_equals($expected, $callbackToken)) {
            Log::warning('payment_webhook.rejected', ['reason' => 'TOKEN_INVALID']);
            throw new AuthenticationException('WEBHOOK_INVALID', 'The provider notification could not be verified.', 401);
        }
        if (strlen($rawBody) > (int) config('payments.webhook_max_bytes', 65536)) {
            throw new AuthenticationException('WEBHOOK_TOO_LARGE', 'The provider notification is too large.', 413);
        }
        try {
            $payload = json_decode($rawBody, true, 32, JSON_THROW_ON_ERROR);
        } catch (\JsonException) {
            throw new AuthenticationException('WEBHOOK_INVALID', 'The provider notification is not valid JSON.', 400);
        }
        if (! is_array($payload) || ! is_string($payload['event'] ?? null) || ! is_array($payload['data'] ?? null)) {
            throw new AuthenticationException('WEBHOOK_INVALID', 'The provider notification is incomplete.', 422);
        }
        $event = mb_substr($payload['event'], 0, 96);
        $data = $payload['data'];
        $eventId = is_string($webhookId) && preg_match('/^[A-Za-z0-9._:-]{1,120}$/', $webhookId) === 1
            ? 'wh:'.$webhookId
            : 'digest:'.hash('sha256', $event.'|'.self::scalar($data['payment_session_id'] ?? $data['id'] ?? null).'|'.self::scalar($data['status'] ?? null).'|'.self::scalar($payload['created'] ?? null));
        $reference = is_string($data['reference_id'] ?? null) && preg_match('/^[A-Za-z0-9._:-]{1,128}$/', $data['reference_id']) === 1 ? $data['reference_id'] : null;
        $id = (string) Str::uuid7();
        $inserted = DB::transaction(function () use ($id, $eventId, $event, $reference, $rawBody): bool {
            $inserted = DB::table('webhook_events')->insertOrIgnore(['id' => $id, 'provider' => 'XENDIT', 'provider_event_id' => $eventId, 'payload_hash' => hash('sha256', $rawBody),
                'state' => 'RECEIVED', 'event_type' => $event, 'resource_reference' => $reference, 'payload_encrypted' => Crypt::encryptString($rawBody), 'verification' => 'TOKEN_VERIFIED',
                'received_at' => now(), 'attempts' => 0, 'created_at' => now(), 'updated_at' => now()]) === 1;
            if ($inserted) {
                $this->outbox->publish('XENDIT_WEBHOOK_RECEIVED', 'WEBHOOK_EVENT', $id, ['webhook_event_id' => $id]);
            }

            return $inserted;
        });

        return ['received' => true, 'duplicate' => ! $inserted, 'event_id' => $inserted ? $id : (string) DB::table('webhook_events')->where('provider', 'XENDIT')->where('provider_event_id', $eventId)->value('id')];
    }

    private static function scalar(mixed $value): string
    {
        return is_scalar($value) ? (string) $value : '';
    }
}
