<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxProcessor;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Contracts\Debug\ExceptionHandler;
use Illuminate\Support\Facades\Artisan;
use ReflectionClass;
use Tests\TestCase;

final class SystemAuditRegistrationTest extends TestCase
{
    public function test_every_scheduled_artisan_command_is_registered(): void
    {
        $commands = Artisan::all();
        foreach (app(Schedule::class)->events() as $event) {
            if ($event->command === null) {
                continue;
            }
            self::assertSame(1, preg_match('/[\x27\x22]?artisan[\x27\x22]?\s+([^\s]+)/', $event->command, $matches), $event->command);
            self::assertArrayHasKey(trim($matches[1], "'\""), $commands, $event->command);
        }
    }

    public function test_every_project_domain_event_has_an_outbox_consumer(): void
    {
        $recorded = (new ReflectionClass(OutboxProcessor::class))->getConstant('RECORDED_DOMAIN_EVENTS');
        $events = [];
        foreach (glob(app_path('Domain/Projects/*.php')) as $file) {
            preg_match_all('/->record\([^;]+;/s', file_get_contents($file), $calls);
            foreach ($calls[0] as $call) {
                preg_match_all('/\x27((?:PROJECT|WORK_PACKAGE)_[A-Z_]+)\x27/', $call, $names);
                $events = [...$events, ...$names[1]];
            }
        }
        self::assertNotEmpty($events);
        foreach (array_unique($events) as $event) {
            self::assertContains($event, $recorded, $event);
        }
    }

    public function test_expected_client_errors_are_not_reported_but_server_errors_are(): void
    {
        $handler = app(ExceptionHandler::class);
        self::assertFalse($handler->shouldReport(new AuthenticationException('SESSION_EXPIRED', 'Sign in again.', 401)));
        self::assertFalse($handler->shouldReport(new AuthenticationException('VERSION_CONFLICT', 'Refresh.', 409)));
        self::assertTrue($handler->shouldReport(new AuthenticationException('FAILED', 'Unavailable.', 500)));
    }
}
