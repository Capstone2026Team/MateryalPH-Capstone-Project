<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use Illuminate\Console\Events\ScheduledTaskFailed;
use Illuminate\Console\Events\ScheduledTaskFinished;
use Illuminate\Console\Events\ScheduledTaskSkipped;
use Illuminate\Console\Events\ScheduledTaskStarting;
use Illuminate\Console\Scheduling\Event;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Records each scheduled task's start, outcome, exit code and duration for Integration and Job Health. Only the
 * task name is kept — never command output, arguments with values, exception text or payloads. Recording is best
 * effort: a health-table failure must never stop the scheduled work itself.
 */
final class ScheduledTaskRecorder
{
    /** @var array<int, array{id: string, started: float}> */
    private static array $running = [];

    public function starting(ScheduledTaskStarting $event): void
    {
        $id = (string) Str::uuid7();
        self::$running[spl_object_id($event->task)] = ['id' => $id, 'started' => microtime(true)];
        $this->write(static fn () => DB::table('scheduled_task_runs')->insert(['id' => $id, 'task' => self::name($event->task), 'outcome' => 'RUNNING', 'started_at' => now()]));
    }

    public function finished(ScheduledTaskFinished $event): void
    {
        $this->close($event->task, ($event->task->exitCode ?? 0) === 0 ? 'SUCCEEDED' : 'FAILED', $event->task->exitCode);
    }

    public function failed(ScheduledTaskFailed $event): void
    {
        $this->close($event->task, 'FAILED', $event->task->exitCode ?? 1);
    }

    public function skipped(ScheduledTaskSkipped $event): void
    {
        $this->write(static fn () => DB::table('scheduled_task_runs')->insert(['id' => (string) Str::uuid7(), 'task' => self::name($event->task), 'outcome' => 'SKIPPED',
            'started_at' => now(), 'finished_at' => now(), 'duration_ms' => 0]));
    }

    /** The artisan command name (or a closure description) without the PHP binary path or option values. */
    public static function name(Event $task): string
    {
        $command = (string) ($task->command ?? '');
        if (preg_match("/artisan'?\\s+'?([a-z0-9:._-]+)/i", $command, $match) === 1) {
            return mb_substr($match[1], 0, 160);
        }

        return mb_substr((string) ($task->description ?: 'Scheduled closure'), 0, 160);
    }

    private function close(Event $task, string $outcome, ?int $exitCode): void
    {
        $running = self::$running[spl_object_id($task)] ?? null;
        unset(self::$running[spl_object_id($task)]);
        if ($running === null) {
            return;
        }
        $this->write(static fn () => DB::table('scheduled_task_runs')->where('id', $running['id'])->update(['outcome' => $outcome, 'exit_code' => $exitCode,
            'duration_ms' => (int) round((microtime(true) - $running['started']) * 1000), 'finished_at' => now()]));
    }

    private function write(callable $statement): void
    {
        try {
            $statement();
        } catch (Throwable $exception) {
            report($exception);
        }
    }
}
