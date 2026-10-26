<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Analytics\Geo\GeoFactsBuilder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

final class GeoRunRetentionTest extends TestCase
{
    use RefreshDatabase;

    public function test_revisions_advance_under_the_lock_and_only_unreferenced_old_metadata_is_pruned(): void
    {
        $old = (string) Str::uuid7();
        DB::table('analytics_geo_runs')->insert(['id' => $old, 'environment' => 'TEST', 'through_date' => now()->subDays(31)->toDateString(), 'revision' => 1,
            'state' => 'FAILED', 'error_code' => 'AGGREGATION_FAILED', 'trigger' => 'COMMAND', 'started_at' => now()->subDays(31), 'created_at' => now()->subDays(31), 'updated_at' => now()->subDays(31)]);
        $builder = app(GeoFactsBuilder::class);
        $first = $builder->build('COMMAND');
        self::assertSame('PUBLISHED', $first['state']);
        self::assertSame(1, $first['revision']);
        self::assertFalse(DB::table('analytics_geo_runs')->where('id', $old)->exists());
        $second = $builder->build('COMMAND');
        self::assertSame('PUBLISHED', $second['state']);
        self::assertSame(2, $second['revision']);
        self::assertSame('SUPERSEDED', DB::table('analytics_geo_runs')->where('id', $first['run_id'])->value('state'));
        self::assertSame(2, DB::table('analytics_geo_runs')->count());
    }
}
