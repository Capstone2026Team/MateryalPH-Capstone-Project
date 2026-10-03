<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Tells the Buyer how long an order has left in Pending Payment, once at each configured point (by default 12 hours
 * and 1 hour before the deadline). The server clock and `orders.payment_expires_at` decide everything. A reminder is
 * recorded and sent in one transaction under the order lock, and the unique (order, hours) row makes a repeat run a
 * no-op. If the scheduler was late and the 1-hour point is already inside, only the most urgent reminder is sent.
 */
final class OrderPaymentReminders
{
    public function __construct(private readonly OrderNotifier $notifier) {}

    public function send(int $limit = 500): int
    {
        $points = collect((array) config('payments.order_reminder_hours', [12, 1]))->map(static fn (mixed $hours): int => (int) $hours)->filter(static fn (int $hours): bool => $hours > 0)->sort()->values()->all();
        if ($points === []) {
            return 0;
        }
        $now = CarbonImmutable::now();
        $candidates = DB::table('orders')->where('order_state', OrderStates::AWAITING_PAYMENT)->where('payment_state', 'PENDING')->whereNull('closed_at')
            ->where('payment_expires_at', '>', $now)->where('payment_expires_at', '<=', $now->addHours(max($points)))
            ->where(function ($due) use ($points, $now): void {
                foreach ($points as $index => $hours) {
                    $due->orWhere(function ($window) use ($points, $index, $hours, $now): void {
                        $window->where('payment_expires_at', '<=', $now->addHours($hours));
                        if ($index > 0) {
                            $window->where('payment_expires_at', '>', $now->addHours($points[$index - 1]));
                        }
                        $window->whereNotExists(fn ($sent) => $sent->selectRaw('1')->from('order_payment_reminders')
                            ->whereColumn('order_payment_reminders.order_id', 'orders.id')->where('hours_before', $hours));
                    });
                }
            })
            ->orderBy('payment_expires_at')->limit(max(1, $limit))->pluck('id');
        $sent = 0;
        foreach ($candidates as $orderId) {
            $sent += $this->remind((string) $orderId, $points) ? 1 : 0;
        }

        return $sent;
    }

    /** @param list<int> $points ascending hours before the deadline */
    private function remind(string $orderId, array $points): bool
    {
        return DB::transaction(function () use ($orderId, $points): bool {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $now = CarbonImmutable::now();
            if ($order === null || $order->order_state !== OrderStates::AWAITING_PAYMENT || $order->payment_state !== 'PENDING' || $order->closed_at !== null || $order->payment_expires_at === null) {
                return false;
            }
            $deadline = CarbonImmutable::parse((string) $order->payment_expires_at);
            if ($deadline->lessThanOrEqualTo($now)) {
                return false;
            }
            // The most urgent point that has been reached.
            $due = null;
            foreach ($points as $hours) {
                if ($deadline->lessThanOrEqualTo($now->addHours($hours))) {
                    $due = $hours;
                    break;
                }
            }
            if ($due === null) {
                return false;
            }
            $recorded = DB::table('order_payment_reminders')->insertOrIgnore(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'hours_before' => $due, 'sent_at' => $now, 'created_at' => $now, 'updated_at' => $now]);
            if ($recorded === 0) {
                return false;
            }
            $left = $due === 1 ? '1 hour' : $due.' hours';
            $this->notifier->buyer($order, 'Order '.$order->reference.': about '.$left.' left to pay', 'Pay by '.$deadline->setTimezone('Asia/Manila')->format('M j, Y g:i A')
                .' (Philippine time) to keep your order. After that it is cancelled automatically and the reserved stock is released.');

            return true;
        });
    }
}
