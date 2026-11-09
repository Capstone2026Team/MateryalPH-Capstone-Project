<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\TestCase;

final class ProjectArchiveMigrationTest extends TestCase
{
    use CreatesDiscoveryFixtures, RefreshDatabase;

    public function test_forward_migration_gives_legacy_archives_a_full_restoration_window(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $buyer = $this->buyer();
        $project = (string) Str::uuid7();
        DB::table('projects')->insert(['id' => $project, 'buyer_profile_id' => $this->buyerProfileId($buyer), 'name' => 'Retained legacy project',
            'budget_centavos' => 500000, 'starts_on' => now()->toDateString(), 'ends_on' => now()->addMonth()->toDateString(), 'created_at' => now(), 'updated_at' => now()]);
        $migration = require database_path('migrations/2026_11_09_180000_add_project_procurement_archives.php');
        $migration->down();
        DB::table('projects')->where('id', $project)->update(['status' => 'ARCHIVED']);
        $before = CarbonImmutable::now('UTC')->subSecond();
        $migration->up();
        $row = DB::table('projects')->where('id', $project)->first();
        $archivedAt = CarbonImmutable::parse($row->archived_at);
        self::assertTrue($archivedAt->between($before, CarbonImmutable::now('UTC')->addSecond()));
        self::assertSame(720, (int) $archivedAt->diffInHours(CarbonImmutable::parse($row->delete_after)));
        self::assertSame('ARCHIVED', $row->status);
        self::assertSame('ACTIVE', $row->archived_from_status);
        self::assertNull($row->deleted_at);
        self::assertSame(500000, $row->budget_centavos);
    }
}
