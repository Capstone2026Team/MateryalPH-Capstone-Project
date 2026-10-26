<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        // GAL remains the original whole can. No conversions or historical updates.
        if (! DB::table('units')->where('code', 'US_GAL')->exists()) {
            DB::table('units')->insert(['id' => (string) Str::uuid7(), 'code' => 'US_GAL', 'name' => 'US gallon (measured volume)',
                'dimension' => 'VOLUME', 'precision' => 3, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    public function down(): void
    {
        // A referenced selling unit is retained to protect commercial history.
    }
};
