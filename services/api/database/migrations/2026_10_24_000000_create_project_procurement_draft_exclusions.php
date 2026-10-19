<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('project_procurement_draft_exclusions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('work_package_version_id')->constrained('work_package_versions')->restrictOnDelete();
            $table->foreignUuid('primary_vendor_id')->constrained('vendor_organizations')->restrictOnDelete();
            $table->foreignUuid('work_package_line_id')->constrained('work_package_lines')->restrictOnDelete();
            $table->timestampsTz();
            $table->unique(['work_package_version_id', 'primary_vendor_id', 'work_package_line_id'], 'project_draft_exclusion_unique');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('project_procurement_draft_exclusions');
    }
};
