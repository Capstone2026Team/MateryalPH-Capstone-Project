<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderActor;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The one chronological case surface. Every filing, response, proposal, clarification, decision, appeal, remedy and
 * handler change appends exactly one event with its actor, role, party and exact instant; evidence rows point at
 * the event that introduced them. Events are append-only (enforced by a database trigger) and numbered per case
 * under the case row lock, so the order shown to every party is the order in which they happened. Each append
 * publishes a post-commit invalidation for realtime subscribers; no case content is ever sent over a socket.
 */
final class DisputeTimeline
{
    public function __construct(private readonly OutboxPublisher $outbox) {}

    /**
     * The caller holds the case row lock inside its transaction.
     *
     * @param  array<string, mixed>  $payload
     */
    public function append(object $case, string $type, OrderActor $actor, string $party, ?string $body = null, array $payload = []): string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Dispute events are appended only inside the case transaction.');
        }
        $sequence = (int) DB::table('dispute_cases')->where('id', $case->id)->value('event_sequence') + 1;
        DB::table('dispute_cases')->where('id', $case->id)->update(['event_sequence' => $sequence, 'updated_at' => now()]);
        $id = (string) Str::uuid7();
        DB::table('dispute_events')->insert([
            'id' => $id, 'dispute_case_id' => $case->id, 'sequence' => $sequence, 'event_type' => $type, 'actor_user_id' => $actor->userId,
            'actor_role' => $actor->role, 'actor_party' => $party, 'body' => $body === null ? null : mb_substr(trim($body), 0, 4000),
            'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'correlation_id' => mb_substr($actor->correlationId, 0, 64), 'occurred_at' => now(), 'created_at' => now(),
        ]);
        $this->outbox->publish('DISPUTE_CASE_CHANGED', 'DISPUTE_CASE', (string) $case->id, ['dispute_case_id' => (string) $case->id, 'event_type' => $type]);

        return $id;
    }

    /**
     * Attaches stored evidence files to the event that introduced them.
     *
     * @param  array<int, string|null>  $fileIds
     */
    public function evidence(object $case, string $eventId, string $party, OrderActor $actor, string $label, array $fileIds, ?string $description = null): void
    {
        foreach (array_values(array_filter($fileIds)) as $fileId) {
            DB::table('dispute_evidence')->insert(['id' => (string) Str::uuid7(), 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'SUBMITTED',
                'payload' => json_encode(['source' => $label], JSON_THROW_ON_ERROR), 'file_id' => $fileId, 'dispute_event_id' => $eventId, 'party' => $party, 'actor_role' => $actor->role,
                'label' => $label, 'description' => $description === null ? null : mb_substr(trim($description), 0, 500), 'created_at' => now(), 'updated_at' => now()]);
        }
    }
}
