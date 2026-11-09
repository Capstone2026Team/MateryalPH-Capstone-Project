<?php

declare(strict_types=1);

namespace Tests\Feature\Operations;

use App\Domain\Operations\AutomaticOperationRecovery;
use App\Domain\Operations\OutboxProcessor;
use App\Jobs\ProcessOutboxEvent;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use Tests\TestCase;

final class AutomaticOperationRecoveryTest extends TestCase
{
    use RefreshDatabase;

    public function test_cooldowns_bounded_recovery_canonical_dispatch_and_immutable_system_history(): void
    {
        Queue::fake();
        $id = $this->event('NOTIFICATIONS_CHANGED');
        $this->failedJob($id);
        $this->failedJob($id);
        $recovery = app(AutomaticOperationRecovery::class);
        self::assertSame(0, $recovery->sweep());
        foreach (AutomaticOperationRecovery::DELAYS_MINUTES as $cycle => $delay) {
            DB::table('outbox_events')->where('id', $id)->update(['attempts' => OutboxProcessor::MAX_ATTEMPTS, 'dispatched_until' => null, 'updated_at' => now()->subMinutes($delay + 1)]);
            self::assertSame(1, $recovery->sweep());
            $event = DB::table('outbox_events')->where('id', $id)->first();
            self::assertSame($cycle + 1, (int) $event->automatic_recovery_count);
            self::assertSame(0, (int) $event->attempts);
            self::assertNull($event->processed_at);
            self::assertSame(0, DB::table('failed_jobs')->count());
            self::assertSame(0, $recovery->sweep());
        }
        self::assertSame(3, DB::table('operation_retries')->whereNull('actor_user_id')->where('actor_role', 'SYSTEM')->count());
        self::assertSame(3, DB::table('audit_logs')->where('action', 'OPERATION_AUTO_RECOVERY_QUEUED')->count());
        $this->artisan('materyalph:outbox-dispatch')->assertSuccessful();
        Queue::assertPushed(ProcessOutboxEvent::class, fn (ProcessOutboxEvent $job): bool => $job->eventId === $id);
        DB::table('outbox_events')->where('id', $id)->update(['attempts' => 5, 'dispatched_until' => null, 'updated_at' => now()->subDay()]);
        $this->failedJob($id);
        self::assertSame(0, $recovery->sweep());
        self::assertSame('LIMIT_REACHED', AutomaticOperationRecovery::state(DB::table('outbox_events')->where('id', $id)->first())['recovery_status']);
        self::assertSame(1, DB::table('failed_jobs')->count());
        $this->assertThrows(static fn () => DB::transaction(static fn () => DB::table('operation_retries')->update(['reason' => 'Rewrite system recovery history'])), QueryException::class);
    }

    public function test_protected_and_malformed_jobs_are_never_replayed_or_removed(): void
    {
        foreach (['PAYMENT_REFUND_REQUESTED', 'AUTH_EMAIL_OTP_REQUESTED', 'VENDOR_INVITATION_REQUESTED', 'UNKNOWN_EVENT'] as $type) {
            $this->failedJob($this->event($type, old: true));
        }
        $safe = $this->event('NOTIFICATIONS_CHANGED', old: true);
        $malformed = $this->failedJob($safe);
        DB::table('failed_jobs')->where('uuid', $malformed)->update(['payload' => json_encode(['displayName' => ProcessOutboxEvent::class, 'data' => ['command' => serialize((object) ['eventId' => $safe])]])]);
        self::assertSame(1, app(AutomaticOperationRecovery::class)->sweep());
        self::assertSame(5, DB::table('failed_jobs')->count());
        self::assertSame(4, DB::table('outbox_events')->where('attempts', 5)->count());
        self::assertTrue(DB::table('failed_jobs')->where('uuid', $malformed)->exists());
    }

    public function test_worker_timeout_recovery_respects_active_lease_and_the_processor_lock(): void
    {
        $id = $this->event('NOTIFICATIONS_CHANGED', old: true);
        $this->failedJob($id);
        DB::table('outbox_events')->where('id', $id)->update(['attempts' => 0, 'dispatched_until' => now()->addHour()]);
        $recovery = app(AutomaticOperationRecovery::class);
        self::assertSame(0, $recovery->sweep());
        DB::table('outbox_events')->where('id', $id)->update(['dispatched_until' => now()->subMinute()]);
        $lock = Cache::lock('outbox-event:'.$id, 120);
        self::assertTrue($lock->get());
        self::assertSame(0, $recovery->sweep());
        $lock->release();
        self::assertSame(1, $recovery->sweep());
        self::assertSame(0, DB::table('failed_jobs')->count());
    }

    public function test_completed_work_clears_only_its_correlated_failure_without_replay(): void
    {
        $id = $this->event('NOTIFICATIONS_CHANGED', old: true);
        $this->failedJob($id);
        DB::table('outbox_events')->where('id', $id)->update(['processed_at' => now()]);
        $this->failedJob($this->event('PAYMENT_REFUND_REQUESTED', old: true));
        self::assertSame(0, app(AutomaticOperationRecovery::class)->sweep());
        self::assertSame(1, DB::table('failed_jobs')->count());
        self::assertSame(0, DB::table('operation_retries')->count());
        self::assertSame(1, DB::table('audit_logs')->where('action', 'OPERATION_FAILURE_RESOLVED')->count());
    }

    public function test_staging_import_boundary_still_quarantines_historical_side_effects(): void
    {
        $this->app->instance('env', 'staging');
        config()->set('mail.outbox_delivery_not_before', now()->subHour()->utc()->format('Y-m-d\TH:i:s\Z'));
        $id = $this->event('NOTIFICATIONS_CHANGED', old: true);
        $this->failedJob($id);
        DB::table('outbox_events')->where('id', $id)->update(['created_at' => now()->subDays(2)]);
        self::assertSame(0, app(AutomaticOperationRecovery::class)->sweep());
        self::assertSame(1, DB::table('failed_jobs')->count());
        self::assertSame(0, DB::table('outbox_events')->where('id', $id)->value('automatic_recovery_count'));
        $state = AutomaticOperationRecovery::state(DB::table('outbox_events')->where('id', $id)->first());
        self::assertSame('OWNING_PROCESS', $state['recovery_status']);
        self::assertSame('Imported history is quarantined in this environment.', $state['retry_note']);
    }

    private function event(string $type, bool $old = false): string
    {
        $id = (string) Str::uuid7();
        DB::table('outbox_events')->insert(['id' => $id, 'event_type' => $type, 'aggregate_type' => 'TEST', 'aggregate_id' => (string) Str::uuid7(),
            'payload' => '{}', 'attempts' => 5, 'available_at' => now(), 'created_at' => now(), 'updated_at' => $old ? now()->subDay() : now()]);

        return $id;
    }

    private function failedJob(string $event): string
    {
        $id = (string) Str::uuid();
        DB::table('failed_jobs')->insert(['uuid' => $id, 'connection' => 'database', 'queue' => 'default', 'failed_at' => now(),
            'payload' => json_encode(['displayName' => ProcessOutboxEvent::class, 'data' => ['command' => serialize(new ProcessOutboxEvent($event))]]),
            'exception' => 'RuntimeException: Synthetic delivery failure']);

        return $id;
    }
}
