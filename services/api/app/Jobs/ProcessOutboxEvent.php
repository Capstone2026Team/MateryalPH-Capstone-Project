<?php

declare(strict_types=1);

namespace App\Jobs;

use App\Domain\Operations\ImportedOutboxBoundary;
use App\Domain\Operations\OutboxProcessor;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Throwable;

final class ProcessOutboxEvent implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;
    use SerializesModels;

    public int $tries = OutboxProcessor::MAX_ATTEMPTS;

    public function __construct(public readonly string $eventId) {}

    public function handle(OutboxProcessor $processor): void
    {
        $processor->process($this->eventId);
    }

    public function failed(?Throwable $exception): void
    {
        // Worker timeouts and exhausted reservations never reach OutboxProcessor's catch block.
        DB::transaction(function (): void {
            $event = ImportedOutboxBoundary::apply(DB::table('outbox_events'))->where('id', $this->eventId)->lockForUpdate()->first();
            if ($event === null || $event->processed_at !== null || $event->event_type !== 'DOCUMENT_EXPORT_REQUESTED') {
                return;
            }
            DB::table('outbox_events')->where('id', $event->id)->update(['attempts' => OutboxProcessor::MAX_ATTEMPTS, 'dispatched_until' => null, 'updated_at' => now()]);
            DB::table('data_exports')->where('id', $event->aggregate_id)->where('state', 'QUEUED')
                ->update(['state' => 'FAILED', 'failure_code' => 'GENERATION_FAILED', 'updated_at' => now()]);
        });
    }

    /** @return list<int> */
    public function backoff(): array
    {
        return [30, 120, 300, 900];
    }
}
