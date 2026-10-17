<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * A Work Package line is either a canonical catalog material or an unlisted
 * material the Buyer named. Unlisted lines are never machine-matched, so they
 * always surface as missing lines (owner decision 2026-10-12).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('work_package_lines', function (Blueprint $table): void {
            $table->string('material_kind', 16)->default('CATALOG');
            $table->string('description', 500)->nullable();
            $table->string('color', 60)->nullable();
        });
        DB::statement('ALTER TABLE work_package_lines ALTER COLUMN material_id DROP NOT NULL');
        DB::statement("ALTER TABLE work_package_lines ADD CONSTRAINT work_package_lines_material_kind_check CHECK ((material_kind = 'CATALOG' AND material_id IS NOT NULL) OR (material_kind = 'UNLISTED' AND material_id IS NULL))");
    }

    public function down(): void
    {
        // Restoring NOT NULL is only possible while no unlisted line exists; history is never deleted to force it.
        DB::statement('ALTER TABLE work_package_lines DROP CONSTRAINT IF EXISTS work_package_lines_material_kind_check');
        DB::statement('ALTER TABLE work_package_lines ALTER COLUMN material_id SET NOT NULL');
        Schema::table('work_package_lines', function (Blueprint $table): void {
            $table->dropColumn(['material_kind', 'description', 'color']);
        });
    }
};
