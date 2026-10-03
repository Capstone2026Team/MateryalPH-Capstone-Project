<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Orders\OrderActor;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The per-order fulfillment row and its append-only event log. A milestone or trip carries a dedupe key, so the same
 * milestone can be stored once only; a repeated request is a replay or a conflict, never a second record. Callers
 * hold the order row lock inside their transaction.
 */
final class FulfillmentRecords
{
    /** The 48-hour receipt window after Delivered/Picked up (approved by the project owner on 2026-10-02). */
    public const RECEIPT_WINDOW_HOURS = 48;

    public function ensure(object $order): object
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Fulfillment records change only inside the order transaction.');
        }
        DB::table('fulfillments')->insertOrIgnore(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'state' => (string) ($order->fulfillment_state ?? 'NOT_STARTED'),
            'method' => (string) $order->fulfillment_method, 'expected_fulfillment_date' => $order->expected_fulfillment_date, 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('fulfillments')->where('order_id', $order->id)->lockForUpdate()->first();
    }

    /**
     * Appends one event. Returns null when the dedupe key already exists for this fulfillment.
     *
     * @param  array<string, mixed>  $payload
     */
    public function event(object $fulfillment, string $type, OrderActor $actor, array $payload = [], ?string $dedupeKey = null): ?string
    {
        if ($dedupeKey !== null && DB::table('fulfillment_milestones')->where('fulfillment_id', $fulfillment->id)->where('dedupe_key', $dedupeKey)->exists()) {
            return null;
        }
        $id = (string) Str::uuid7();
        DB::table('fulfillment_milestones')->insert(['id' => $id, 'fulfillment_id' => $fulfillment->id, 'order_id' => $fulfillment->order_id, 'actor_user_id' => $actor->userId,
            'actor_role' => $actor->role, 'source' => $actor->source === 'AUTO_ACCEPT' ? 'SYSTEM' : $actor->source, 'event_type' => $type,
            'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'occurred_at' => now(), 'dedupe_key' => $dedupeKey, 'correlation_id' => mb_substr($actor->correlationId, 0, 64),
            'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** @param array<string, mixed> $columns */
    public function update(object $fulfillment, array $columns): void
    {
        DB::table('fulfillments')->where('id', $fulfillment->id)->update($columns + ['lock_version' => (int) $fulfillment->lock_version + 1, 'updated_at' => now()]);
    }
}
