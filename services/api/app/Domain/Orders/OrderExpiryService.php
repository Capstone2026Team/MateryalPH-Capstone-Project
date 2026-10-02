<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Operations\OutboxPublisher;
use App\Domain\Payments\PaymentReconciliationService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Expires orders whose response or payment window has passed: the Vendor's 24-hour confirmation window, the
 * Buyer's 24-hour revision/NRPC window and the 24-hour Pending Payment window (`orders.payment_expires_at`,
 * the single source of truth; the client countdown is display only). Expiry releases every hard
 * reservation, returns auto-accept allotment without clearing a pause, cancels the fee estimate and marks a
 * pending online payment EXPIRED. It runs from the scheduler and on read, so a client whose countdown reached
 * zero sees the resolved state instead of a stuck pending one. Idempotent: a closed order is never touched.
 */
final class OrderExpiryService
{
    public function __construct(
        private readonly OrderTransitionService $transitions,
        private readonly OrderRelease $release,
        private readonly OrderNotifier $notifier,
        private readonly OutboxPublisher $outbox,
    ) {}

    public function sweep(int $limit = 200): int
    {
        $now = now();
        $due = DB::table('orders')->whereNull('closed_at')->where(fn ($query) => $query
            ->where(fn ($vendor) => $vendor->where('order_state', OrderStates::AWAITING_VENDOR_CONFIRMATION)->where('vendor_response_due_at', '<=', $now))
            ->orWhere(fn ($buyer) => $buyer->whereIn('order_state', [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE])->where('buyer_response_due_at', '<=', $now))
            ->orWhere(fn ($payment) => $payment->where('order_state', OrderStates::AWAITING_PAYMENT)->where('payment_expires_at', '<=', $now)))
            ->orderBy('id')->limit(max(1, $limit))->pluck('id');
        $expired = 0;
        foreach ($due as $orderId) {
            $expired += $this->expireIfDue((string) $orderId) ? 1 : 0;
        }

        return $expired;
    }

    /** Expires the due open orders of one Buyer or Vendor before their list is read. */
    public function expireDueFor(string $column, string $value): void
    {
        if (! in_array($column, ['buyer_profile_id', 'vendor_organization_id'], true)) {
            throw new \InvalidArgumentException('Unsupported expiry scope.');
        }
        $now = now();
        $ids = DB::table('orders')->where($column, $value)->whereNull('closed_at')->where(fn ($query) => $query->where('vendor_response_due_at', '<=', $now)
            ->orWhere('buyer_response_due_at', '<=', $now)->orWhere('payment_expires_at', '<=', $now))->limit(100)->pluck('id');
        foreach ($ids as $id) {
            $this->expireIfDue((string) $id);
        }
    }

    public function expireIfDue(string $orderId): bool
    {
        $current = DB::table('orders')->where('id', $orderId)->first();
        if ($current !== null && self::dueReason($current, CarbonImmutable::now()) === 'PAYMENT_WINDOW_EXPIRED') {
            // Rule out a verified capture first, outside any lock; a payment that arrived on time confirms the order.
            app(PaymentReconciliationService::class)->reconcileOrder($orderId);
        }

        return DB::transaction(function () use ($orderId): bool {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $reason = $order === null ? null : self::dueReason($order, CarbonImmutable::now());
            if ($reason === null) {
                return false;
            }
            $actor = OrderActor::system();
            // Open attempts close with the order; the provider session is cancelled after commit and a capture
            // that still arrives later is compensated, never applied to the expired order.
            foreach (DB::table('payments')->where('order_id', $orderId)->whereIn('state', ['CREATING', 'PENDING', 'UNCERTAIN'])->lockForUpdate()->get() as $payment) {
                DB::table('payments')->where('id', $payment->id)->update(['state' => 'EXPIRED', 'expired_at' => now(), 'reconciliation_state' => $payment->provider_session_id === null ? 'PENDING' : 'RECONCILED',
                    'lock_version' => (int) $payment->lock_version + 1, 'updated_at' => now()]);
                DB::table('payment_events')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $payment->id, 'state' => 'EXPIRED', 'from_state' => $payment->state, 'source' => 'SYSTEM',
                    'correlation_id' => $actor->correlationId, 'safe_payload' => json_encode(['reason' => 'ORDER_PAYMENT_WINDOW_EXPIRED'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                $this->outbox->publish('PAYMENT_SESSION_CANCEL_REQUESTED', 'PAYMENT', (string) $payment->id, ['payment_id' => (string) $payment->id]);
            }
            $this->release->release($order, OrderStates::EXPIRED, $reason, $actor);
            $changes = [OrderStates::ORDER => OrderStates::EXPIRED] + ($order->payment_state === 'PENDING' ? [OrderStates::PAYMENT => 'EXPIRED'] : []);
            $order = $this->transitions->apply($order, $changes, $actor, $reason, null, ['vendor_response_due_at' => null, 'buyer_response_due_at' => null]);
            $message = match ($reason) {
                'VENDOR_RESPONSE_TIMEOUT' => 'The Vendor did not respond within 24 hours, so the request expired. You were not charged.',
                'BUYER_RESPONSE_TIMEOUT' => 'The confirmed version was not accepted within 24 hours, so the request expired and the stock was released.',
                default => 'Payment was not completed by the deadline, so the order was cancelled automatically and the reserved stock was released. You were not charged.',
            };
            $title = $reason === 'PAYMENT_WINDOW_EXPIRED' ? 'Order '.$order->reference.' cancelled: payment expired' : 'Order '.$order->reference.' expired';
            $this->notifier->buyer($order, $title, $message);
            $this->notifier->vendor($order, $title, $reason === 'PAYMENT_WINDOW_EXPIRED'
                ? 'The Buyer did not complete payment by the deadline, so the order was cancelled automatically and the reserved stock was released.'
                : $message);

            return true;
        });
    }

    public static function dueReason(object $order, CarbonImmutable $now): ?string
    {
        $passed = static fn (mixed $at): bool => $at !== null && CarbonImmutable::parse((string) $at)->lessThanOrEqualTo($now);

        return match (true) {
            $order->closed_at !== null => null,
            $order->order_state === OrderStates::AWAITING_VENDOR_CONFIRMATION && $passed($order->vendor_response_due_at) => 'VENDOR_RESPONSE_TIMEOUT',
            in_array($order->order_state, [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE], true) && $passed($order->buyer_response_due_at) => 'BUYER_RESPONSE_TIMEOUT',
            $order->order_state === OrderStates::AWAITING_PAYMENT && $passed($order->payment_expires_at) => 'PAYMENT_WINDOW_EXPIRED',
            default => null,
        };
    }
}
