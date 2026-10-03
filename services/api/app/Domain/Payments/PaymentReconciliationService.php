<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Authoritative reconciliation of payment attempts with the provider, on a bounded schedule (every five minutes for
 * the capstone), before an order's payment window is expired, and on an explicit status check. It reads the
 * provider session outside every lock and hands the result to PaymentSettlement; it never creates a session.
 *
 * An attempt whose create outcome is unknown and has no provider session reference is closed only after its
 * provider expiry plus a grace period has passed, so a late success of an earlier attempt is ruled out before
 * another charge; any capture that still arrives later is compensated, never double-applied.
 */
final class PaymentReconciliationService
{
    public function __construct(
        private readonly PaymentGateway $gateway,
        private readonly PaymentSettlement $settlement,
    ) {}

    /** @return string settlement result, PENDING, UNAVAILABLE or CLOSED */
    public function reconcile(string $paymentId, string $source = 'RECONCILIATION', ?string $webhookEventId = null): string
    {
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        if ($payment === null) {
            return 'MISMATCH';
        }
        $correlation = (string) Str::uuid7();
        if ($payment->provider_session_id === null) {
            $grace = (int) config('payments.uncertain_grace_minutes', 15);
            if (in_array($payment->state, PaymentSettlement::OPEN_STATES, true) && $payment->expires_at !== null && CarbonImmutable::parse((string) $payment->expires_at)->addMinutes($grace)->isPast()) {
                return $this->closeUnresolved($payment, $correlation);
            }

            return 'PENDING';
        }
        try {
            $session = $this->gateway->retrieveSession((string) $payment->provider_session_id, self::forUserId($payment));
        } catch (PaymentProviderException $exception) {
            DB::table('payments')->where('id', $paymentId)->update(['last_reconciled_at' => now(), 'updated_at' => now()]);
            app(PaymentAttemptService::class)->log($paymentId, 'RETRIEVE', 'UNAVAILABLE', $exception->httpStatus, $exception->providerRequestId, ['code' => $exception->safeCode], $correlation);

            return 'UNAVAILABLE';
        }
        app(PaymentAttemptService::class)->log($paymentId, 'RETRIEVE', 'RETRIEVED', 200, null, ['session_status' => $session->status], $correlation);
        DB::table('payments')->where('id', $paymentId)->update(['last_reconciled_at' => now(), 'updated_at' => now()]);

        return $this->settlement->apply($paymentId, $session, $source, $webhookEventId, $correlation);
    }

    /** Reconciles every open attempt of one order before its payment window is expired. */
    public function reconcileOrder(string $orderId): void
    {
        foreach (DB::table('payments')->where('order_id', $orderId)->whereIn('state', PaymentSettlement::OPEN_STATES)->pluck('id') as $paymentId) {
            try {
                $this->reconcile((string) $paymentId);
            } catch (Throwable $exception) {
                report($exception);
            }
        }
    }

    /** @return array<string, int> */
    public function sweep(int $limit = 100): array
    {
        $counts = ['reconciled' => 0, 'webhooks' => 0, 'refunds' => 0, 'recovered' => 0];
        // A create interrupted before the provider call finished cannot be proven either way: mark it uncertain.
        $counts['recovered'] = DB::table('payments')->where('state', 'CREATING')->where('created_at', '<', now()->subMinutes(2))
            ->update(['state' => 'UNCERTAIN', 'failure_code' => 'CREATE_INTERRUPTED', 'reconciliation_state' => 'PENDING', 'updated_at' => now()]);
        $after = (int) config('payments.reconcile_after_seconds', 120);
        $due = DB::table('payments')->whereIn('state', PaymentSettlement::OPEN_STATES)
            ->where(fn ($query) => $query->where('created_at', '<', now()->subSeconds($after))->orWhere('expires_at', '<=', now()))
            ->where(fn ($query) => $query->whereNull('last_reconciled_at')->orWhere('last_reconciled_at', '<', now()->subMinute()))
            ->orderBy('created_at')->limit($limit)->pluck('id');
        foreach ($due as $paymentId) {
            try {
                $this->reconcile((string) $paymentId);
                $counts['reconciled']++;
            } catch (Throwable $exception) {
                report($exception);
            }
        }
        foreach (DB::table('webhook_events')->where('provider', 'XENDIT')->where('state', 'RECEIVED')->whereNotNull('payload_encrypted')
            ->where('received_at', '<', now()->subMinutes(2))->where('attempts', '<', 10)->orderBy('received_at')->limit($limit)->pluck('id') as $eventId) {
            try {
                app(XenditWebhookProcessor::class)->process((string) $eventId);
                $counts['webhooks']++;
            } catch (Throwable $exception) {
                report($exception);
            }
        }
        // Every pending refund instruction (cancellation, technical compensation, fee credit): resend an unsent or
        // timed-out request with its same idempotency key, or read the provider's authoritative refund state.
        $refunds = app(RefundService::class)->sweep($limit);
        $counts['refunds'] = $refunds['sent'] + $refunds['reconciled'];

        return $counts;
    }

    public static function forUserId(object $payment): ?string
    {
        return $payment->account_scope === 'PLATFORM_ACCOUNT' ? PaymentSettlement::platformAccount() : (string) $payment->provider_account_id;
    }

    private function closeUnresolved(object $payment, string $correlation): string
    {
        return DB::transaction(function () use ($payment, $correlation): string {
            $locked = DB::table('payments')->where('id', $payment->id)->lockForUpdate()->first();
            if (! in_array($locked->state, PaymentSettlement::OPEN_STATES, true) || $locked->provider_session_id !== null) {
                return 'DUPLICATE';
            }
            DB::table('payments')->where('id', $payment->id)->update(['state' => 'EXPIRED', 'expired_at' => now(), 'failure_code' => $locked->failure_code ?? 'CREATE_OUTCOME_UNRESOLVED',
                'reconciliation_state' => 'RECONCILED', 'last_reconciled_at' => now(), 'lock_version' => (int) $locked->lock_version + 1, 'updated_at' => now()]);
            DB::table('payment_events')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $payment->id, 'state' => 'EXPIRED', 'from_state' => $locked->state, 'source' => 'SYSTEM',
                'correlation_id' => $correlation, 'safe_payload' => json_encode(['reason' => 'Provider expiry and grace period passed without a session reference or verified event.'], JSON_THROW_ON_ERROR),
                'created_at' => now(), 'updated_at' => now()]);

            return 'CLOSED';
        });
    }
}
