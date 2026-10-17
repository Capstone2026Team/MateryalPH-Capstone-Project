<?php

declare(strict_types=1);

namespace Tests\Support;

use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\RefreshDatabaseState;

/** Real-connection tests cannot roll back immutable history migrations. TestCase guards this database. */
trait RebuildsIsolatedDatabase
{
    use DatabaseMigrations;

    public function runDatabaseMigrations(): void
    {
        $this->refreshTestDatabase();
        $this->beforeApplicationDestroyed(static function (): void {
            RefreshDatabaseState::$migrated = false;
        });
    }
}
