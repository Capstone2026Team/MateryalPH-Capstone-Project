<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The only writer of order, payment, fulfillment, refund and dispute states. The caller holds the order row
 * lock inside its transaction. Every changed family appends an immutable history row with the actor, role,
 * source, reason and commercial version, and one committed outbox event describes the change for
 * post-commit notification. An illegal transition changes nothing.
 */
final class OrderTransitionService
{
    public function __construct(private readonly OutboxPublisher $outbox) {}

    /**
     * @param  array<string, string>  $changes  family => next state
     * @param  array<string, mixed>  $columns  other order columns written in the same update
     */
    public function apply(object $order, array $changes, OrderActor $actor, ?string $reasonCode = null, ?string $reason = null, array $columns = [], ?int $snapshotVersion = null): object
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Order states change only inside the order transaction.');
        }
        $update = $columns;
        $history = [];
        foreach ($changes as $family => $to) {
            $column = OrderStates::COLUMNS[$family] ?? null;
            if ($column === null) {
                throw new \LogicException('Unknown order state family '.$family.'.');
            }
            $from = $order->{$column} ?? null;
            if ($from === $to) {
                continue;
            }
            if (! OrderStates::allows($family, $from, $to)) {
                throw new AuthenticationException('ORDER_STATE_CONFLICT', 'This order changed and the action is no longer available. Refresh to see its current state.', 409, ['family' => $family, 'current_state' => $from]);
            }
            $update[$column] = $to;
            $history[] = [$family, $from, $to];
        }
        if (isset($update['order_state']) && OrderStates::isClosed((string) $update['order_state'])) {
            $update['closed_at'] = now();
            $update['terminal_reason_code'] = $reasonCode;
        }
        DB::table('orders')->where('id', $order->id)->update($update + ['lock_version' => (int) $order->lock_version + 1, 'updated_at' => now()]);
        foreach ($history as [$family, $from, $to]) {
            DB::table('order_status_history')->insert([
                'id' => (string) Str::uuid7(), 'order_id' => $order->id, 'state_family' => $family, 'from_state' => $from, 'to_state' => $to,
                'actor_user_id' => $actor->userId, 'actor_role' => $actor->role, 'source' => $actor->source, 'reason_code' => $reasonCode,
                'reason' => $reason === null ? null : mb_substr($reason, 0, 2000), 'snapshot_version' => $snapshotVersion, 'correlation_id' => $actor->correlationId,
                'created_at' => now(), 'updated_at' => now(),
            ]);
        }
        if ($history !== []) {
            $this->outbox->publish('ORDER_STATE_CHANGED', 'ORDER', (string) $order->id, [
                'order_id' => (string) $order->id, 'vendor_organization_id' => (string) $order->vendor_organization_id,
                'changes' => implode(',', array_map(static fn (array $row): string => $row[0].':'.($row[1] ?? '').'>'.$row[2], $history)),
                'reason_code' => (string) $reasonCode, 'source' => $actor->source, 'correlation_id' => $actor->correlationId,
            ]);
        }

        return DB::table('orders')->where('id', $order->id)->first();
    }

    /** Records the initial AWAITING_VENDOR_CONFIRMATION state of a newly inserted order. */
    public function opened(object $order, OrderActor $actor): void
    {
        DB::table('order_status_history')->insert([
            'id' => (string) Str::uuid7(), 'order_id' => $order->id, 'state_family' => OrderStates::ORDER, 'from_state' => null, 'to_state' => $order->order_state,
            'actor_user_id' => $actor->userId, 'actor_role' => $actor->role, 'source' => $actor->source, 'reason_code' => 'ORDER_SUBMITTED', 'reason' => null,
            'snapshot_version' => 1, 'correlation_id' => $actor->correlationId, 'created_at' => now(), 'updated_at' => now(),
        ]);
    }
}
