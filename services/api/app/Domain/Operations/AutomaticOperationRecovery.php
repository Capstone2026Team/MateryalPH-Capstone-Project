<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Re-enqueues canonical outbox work, never arbitrary serialized failed jobs or provider mutations. */
final class AutomaticOperationRecovery
{
    public const DELAYS_MINUTES = [15, 60, 360];

    public const COMMAND = 'materyalph:operations-recover';

    public function __construct(private readonly JobHealthService $health) {}

    public function sweep(int $limit = 100): int
    {
        $recovered = 0;
        $limit = max(1, min(1000, $limit));
        // Existing outbox processing uses this same lock. No payload is decrypted here.
        foreach (ImportedOutboxBoundary::apply(DB::table('outbox_events'))->whereNull('processed_at')
            ->whereIn('event_type', JobHealthService::RETRYABLE_OUTBOX)->where('attempts', '>=', OutboxProcessor::MAX_ATTEMPTS)
            ->where('automatic_recovery_count', '<', count(self::DELAYS_MINUTES))->orderBy('id')->lazyById(100) as $event) {
            $recovered += $this->recover((string) $event->id) ? 1 : 0;
            if ($recovered >= $limit) {
                return $recovered;
            }
        }
        // Worker timeouts may create a failed job before the outbox attempt counter is exhausted.
        foreach (DB::table('failed_jobs')->orderBy('id')->lazyById(100) as $failed) {
            $event = $this->health->failedOutboxEvent((string) $failed->payload);
            if ($event === null || ! in_array($event->event_type, JobHealthService::RETRYABLE_OUTBOX, true)) {
                continue;
            }
            $recovered += $this->recover((string) $event->id, (string) $failed->uuid) ? 1 : 0;
            if ($recovered >= $limit) {
                break;
            }
        }

        return $recovered;
    }

    private function recover(string $id, ?string $failedJob = null): bool
    {
        return (bool) Cache::lock('outbox-event:'.$id, 120)->get(function () use ($id, $failedJob): bool {
            return DB::transaction(function () use ($id, $failedJob): bool {
                $event = ImportedOutboxBoundary::apply(DB::table('outbox_events'))->where('id', $id)->lockForUpdate()->first();
                if ($event === null || ! in_array($event->event_type, JobHealthService::RETRYABLE_OUTBOX, true)) {
                    return false;
                }
                if ($event->processed_at !== null) {
                    $cleared = $this->clearFailures($id);
                    if ($cleared > 0) {
                        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => 'SYSTEM',
                            'action' => 'OPERATION_FAILURE_RESOLVED', 'resource_type' => 'OUTBOX_EVENT', 'resource_id' => $id,
                            'before' => '{}', 'after' => json_encode(['resolved_failed_jobs' => $cleared], JSON_THROW_ON_ERROR),
                            'reason' => 'Canonical outbox event already completed; stale queue failure resolved without replay.',
                            'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
                    }

                    return false;
                }
                $cycle = (int) $event->automatic_recovery_count;
                $delay = self::DELAYS_MINUTES[$cycle] ?? null;
                if ($delay === null || CarbonImmutable::parse((string) $event->updated_at)->addMinutes($delay)->isFuture()
                    || ($event->dispatched_until !== null && CarbonImmutable::parse((string) $event->dispatched_until)->isFuture())) {
                    return false;
                }
                if ((int) $event->attempts < OutboxProcessor::MAX_ATTEMPTS
                    && ($failedJob === null || ! DB::table('failed_jobs')->where('uuid', $failedJob)->exists())) {
                    return false;
                }
                $this->health->resetOutbox($event);
                DB::table('outbox_events')->where('id', $id)->update(['automatic_recovery_count' => $cycle + 1]);
                $cleared = $this->clearFailures($id);
                $correlation = (string) Str::uuid7();
                $reason = 'Automatic recovery of allowlisted idempotent work after cooldown; cycle '.($cycle + 1).' of '.count(self::DELAYS_MINUTES).'.';
                DB::table('operation_retries')->insert(['id' => (string) Str::uuid7(), 'target_type' => 'OUTBOX_EVENT', 'target_reference' => $id,
                    'target_label' => $event->event_type, 'reason' => $reason, 'outcome' => 'QUEUED', 'actor_user_id' => null, 'actor_role' => 'SYSTEM',
                    'correlation_id' => $correlation, 'created_at' => now()]);
                DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => 'SYSTEM',
                    'action' => 'OPERATION_AUTO_RECOVERY_QUEUED', 'resource_type' => 'OUTBOX_EVENT', 'resource_id' => $id,
                    'before' => json_encode(['attempts' => (int) $event->attempts], JSON_THROW_ON_ERROR),
                    'after' => json_encode(['cycle' => $cycle + 1, 'resolved_failed_jobs' => $cleared], JSON_THROW_ON_ERROR),
                    'reason' => $reason, 'correlation_id' => $correlation, 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);

                // The normal dispatcher durably picks up this event; no network/queue call while locked.
                return true;
            });
        });
    }

    private function clearFailures(string $eventId): int
    {
        $cleared = 0;
        foreach (DB::table('failed_jobs')->where('payload', 'like', '%'.$eventId.'%')->orderBy('id')->lazyById(100) as $row) {
            if ($this->health->failedOutboxEvent((string) $row->payload)?->id === $eventId) {
                $cleared += DB::table('failed_jobs')->where('id', $row->id)->delete();
            }
        }

        return $cleared;
    }

    /** @return array{recovery_status: string, recovery_attempts: int, next_retry_at: ?string, retry_note?: string} */
    public static function state(?object $event): array
    {
        $cycle = (int) ($event->automatic_recovery_count ?? 0);
        $state = ['recovery_status' => 'OWNING_PROCESS', 'recovery_attempts' => $cycle, 'next_retry_at' => null];
        if ($event === null || ! in_array($event->event_type, JobHealthService::RETRYABLE_OUTBOX, true)) {
            return $state;
        }
        if (app()->environment('staging') && ! ImportedOutboxBoundary::apply(DB::table('outbox_events'))->where('id', $event->id)->exists()) {
            return [...$state, 'retry_note' => 'Imported history is quarantined in this environment.'];
        }
        if ($event->processed_at !== null) {
            return array_replace($state, ['recovery_status' => 'RESOLVED']);
        }
        if (! isset(self::DELAYS_MINUTES[$cycle])) {
            return array_replace($state, ['recovery_status' => 'LIMIT_REACHED']);
        }
        $next = CarbonImmutable::parse((string) $event->updated_at)->addMinutes(self::DELAYS_MINUTES[$cycle]);
        if ($event->dispatched_until !== null) {
            $next = $next->max(CarbonImmutable::parse((string) $event->dispatched_until));
        }

        return array_replace($state, ['recovery_status' => 'SCHEDULED', 'next_retry_at' => $next->toIso8601String()]);
    }
}
