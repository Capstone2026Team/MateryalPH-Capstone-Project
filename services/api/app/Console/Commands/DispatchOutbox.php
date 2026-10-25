<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Operations\ImportedOutboxBoundary;
use App\Domain\Operations\OutboxProcessor;
use App\Jobs\ProcessOutboxEvent;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

final class DispatchOutbox extends Command
{
    protected $signature = 'materyalph:outbox-dispatch {--limit=100 : Maximum pending events to enqueue}';

    protected $description = 'Enqueue available MateryalPH outbox events for idempotent processing';

    public function handle(): int
    {
        $limit = max(1, min(1000, (int) $this->option('limit')));
        $ids = DB::transaction(function () use ($limit) {
            $ids = ImportedOutboxBoundary::apply(DB::table('outbox_events'))
                ->whereNull('processed_at')
                ->where('attempts', '<', OutboxProcessor::MAX_ATTEMPTS)
                ->where('available_at', '<=', now())
                ->where(fn ($query) => $query->whereNull('dispatched_until')->orWhere('dispatched_until', '<=', now()))
                ->orderBy('available_at')
                ->orderBy('id')
                ->lock('FOR UPDATE SKIP LOCKED')
                ->limit($limit)
                ->pluck('id');
            // Cover the queue's retry/backoff window. A lost queue job becomes eligible again.
            DB::table('outbox_events')->whereIn('id', $ids)->update(['dispatched_until' => now()->addHour()]);

            return $ids;
        });

        foreach ($ids as $id) {
            try {
                ProcessOutboxEvent::dispatch((string) $id);
            } catch (\Throwable $exception) {
                DB::table('outbox_events')->where('id', $id)->whereNull('processed_at')->update(['dispatched_until' => null]);
                throw $exception;
            }
        }

        $this->components->info(sprintf('Enqueued %d pending outbox event(s).', $ids->count()));

        return self::SUCCESS;
    }
}
