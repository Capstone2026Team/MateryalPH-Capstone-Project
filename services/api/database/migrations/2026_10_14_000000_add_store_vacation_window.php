<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('store_profiles', function (Blueprint $table): void {
            // Start is the first instant of the first Asia/Manila day; end is exclusive (midnight after the last day).
            $table->timestampTz('vacation_starts_at')->nullable();
            $table->timestampTz('vacation_ends_at')->nullable();
        });
        DB::statement('ALTER TABLE store_profiles ADD CONSTRAINT store_profiles_vacation_window_check CHECK ((vacation_starts_at IS NULL AND vacation_ends_at IS NULL) OR (vacation_starts_at IS NOT NULL AND vacation_ends_at IS NOT NULL AND vacation_ends_at > vacation_starts_at))');
        DB::statement('CREATE INDEX store_profiles_vacation_window_index ON store_profiles (vacation_starts_at, vacation_ends_at) WHERE vacation_starts_at IS NOT NULL');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS store_profiles_vacation_window_index');
        DB::statement('ALTER TABLE store_profiles DROP CONSTRAINT IF EXISTS store_profiles_vacation_window_check');
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->dropColumn(['vacation_starts_at', 'vacation_ends_at']);
        });
    }
};
