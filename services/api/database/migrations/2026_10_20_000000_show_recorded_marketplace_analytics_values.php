<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Project-owner request of 2026-10-17: the Admin dashboard and Philippine geographic analytics show the recorded
 * marketplace figures instead of "Suppressed". The small-cell threshold stays a versioned, Super-Admin-editable
 * setting (now 1 to 50); this migration only lowers the seeded value, and only where no Super Admin has ever edited it.
 */
return new class extends Migration
{
    private const KEY = 'analytics.disclosure_min_persons';

    public function up(): void
    {
        $row = DB::table('platform_settings')->where('key', self::KEY)->lockForUpdate()->first();
        if ($row === null || (int) $row->version !== 1 || (int) json_decode((string) $row->value, true) !== 5) {
            return;
        }
        DB::table('platform_settings')->where('id', $row->id)->update(['value' => json_encode(1), 'version' => 2, 'updated_at' => now()]);
        DB::table('platform_setting_versions')->insert(['id' => (string) Str::uuid7(), 'setting_key' => self::KEY, 'version' => 2, 'value' => json_encode(1), 'previous_value' => $row->value,
            'source' => 'SEED', 'reason' => 'Project owner asked on 2026-10-17 for recorded values to be shown instead of Suppressed.', 'effective_from' => now(), 'created_at' => now()]);
    }

    public function down(): void
    {
        // A recorded settings version is append-only history; raising the threshold again is a reasoned Super Admin change.
    }
};
