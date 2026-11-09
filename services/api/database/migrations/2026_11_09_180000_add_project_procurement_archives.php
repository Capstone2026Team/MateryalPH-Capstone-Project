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
        foreach (['projects', 'work_packages'] as $name) {
            Schema::table($name, function (Blueprint $table) use ($name): void {
                $table->timestampTz('archived_at')->nullable();
                $table->timestampTz('delete_after')->nullable()->index();
                if ($name === 'projects') {
                    $table->string('archived_from_status', 32)->nullable();
                    $table->timestampTz('deleted_at')->nullable();
                }
            });
        }
        // Older archives receive a full restoration window at migration time.
        DB::statement("UPDATE projects SET archived_at = CURRENT_TIMESTAMP, delete_after = CURRENT_TIMESTAMP + interval '720 hours', archived_from_status = 'ACTIVE' WHERE status = 'ARCHIVED'");
        foreach (['projects', 'work_packages'] as $name) {
            DB::statement("ALTER TABLE {$name} ADD CONSTRAINT {$name}_archive_window_check CHECK ((archived_at IS NULL AND delete_after IS NULL) OR (archived_at IS NOT NULL AND delete_after IS NOT NULL AND delete_after = archived_at + interval '720 hours'))");
        }
        DB::statement("ALTER TABLE projects ADD CONSTRAINT projects_archive_state_check CHECK ((status = 'ARCHIVED') = (archived_at IS NOT NULL) AND (archived_from_status IS NULL OR archived_from_status IN ('ACTIVE','COMPLETED')) AND (deleted_at IS NULL OR status = 'ARCHIVED'))");
    }

    public function down(): void
    {
        if (DB::table('projects')->whereNotNull('archived_at')->exists() || DB::table('work_packages')->whereNotNull('archived_at')->exists()) {
            throw new LogicException('Procurement archives exist. Use a reviewed forward migration.');
        }
        DB::statement('ALTER TABLE projects DROP CONSTRAINT projects_archive_state_check');
        foreach (['projects', 'work_packages'] as $name) {
            DB::statement("ALTER TABLE {$name} DROP CONSTRAINT {$name}_archive_window_check");
            Schema::table($name, function (Blueprint $table) use ($name): void {
                $table->dropColumn(['archived_at', 'delete_after']);
                if ($name === 'projects') {
                    $table->dropColumn(['archived_from_status', 'deleted_at']);
                }
            });
        }
    }
};
