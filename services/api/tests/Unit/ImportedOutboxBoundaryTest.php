<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Operations\ImportedOutboxBoundary;
use Illuminate\Config\Repository;
use Illuminate\Container\Container;
use Illuminate\Database\PostgresConnection;
use Illuminate\Foundation\Application;
use PHPUnit\Framework\TestCase;
use RuntimeException;

final class ImportedOutboxBoundaryTest extends TestCase
{
    protected function tearDown(): void
    {
        Container::setInstance(null);
        parent::tearDown();
    }

    public function test_boundary_applies_before_both_dispatch_and_direct_processing_queries(): void
    {
        $this->configure('staging', '2026-10-22T01:02:03Z');
        $query = (new PostgresConnection(null))->table('outbox_events')->where('id', 'example');
        ImportedOutboxBoundary::apply($query);
        self::assertStringContainsString('"created_at" >= ?', $query->toSql());
        self::assertSame('2026-10-22 01:02:03', $query->getBindings()[1]->format('Y-m-d H:i:s'));
    }

    public function test_default_and_other_environments_keep_existing_delivery_behavior(): void
    {
        foreach ([['staging', null], ['development', '2026-10-22T01:02:03Z']] as [$environment, $boundary]) {
            $this->configure($environment, $boundary);
            $query = (new PostgresConnection(null))->table('outbox_events');
            self::assertSame('select * from "outbox_events"', ImportedOutboxBoundary::apply($query)->toSql());
        }
    }

    public function test_invalid_calendar_date_fails_closed(): void
    {
        $this->configure('staging', '2026-02-30T01:02:03Z');
        $this->expectException(RuntimeException::class);
        ImportedOutboxBoundary::apply((new PostgresConnection(null))->table('outbox_events'));
    }

    private function configure(string $environment, ?string $boundary): void
    {
        $app = new Application;
        $app->instance('env', $environment);
        $app->instance('config', new Repository(['mail' => ['outbox_delivery_not_before' => $boundary]]));
        Container::setInstance($app);
    }
}
