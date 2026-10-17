<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * A Buyer may delete any Work Package that has no order. Saved originals, estimates
 * and quotation history are commercial records, so a package with retained history
 * is hidden from the Buyer with this marker instead of being physically removed.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('work_packages', function (Blueprint $table): void {
            $table->timestampTz('deleted_at')->nullable();
        });
        DB::statement('CREATE INDEX work_packages_project_visible_idx ON work_packages (project_id) WHERE deleted_at IS NULL');
        DB::statement("ALTER TABLE work_packages ADD CONSTRAINT work_packages_deleted_is_cancelled_check CHECK (deleted_at IS NULL OR status = 'CANCELLED')");
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE work_packages DROP CONSTRAINT IF EXISTS work_packages_deleted_is_cancelled_check');
        DB::statement('DROP INDEX IF EXISTS work_packages_project_visible_idx');
        Schema::table('work_packages', function (Blueprint $table): void {
            $table->dropColumn('deleted_at');
        });
    }
};
