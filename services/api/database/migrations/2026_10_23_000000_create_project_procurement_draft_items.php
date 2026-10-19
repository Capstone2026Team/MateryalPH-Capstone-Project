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
        Schema::create('project_procurement_draft_items', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('work_package_version_id')->constrained('work_package_versions')->restrictOnDelete();
            $table->foreignUuid('primary_vendor_id')->constrained('vendor_organizations')->restrictOnDelete();
            $table->foreignUuid('work_package_line_id')->constrained('work_package_lines')->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->constrained('listing_variants')->restrictOnDelete();
            $table->decimal('quantity', 14, 4);
            $table->jsonb('snapshot');
            $table->foreignUuid('order_id')->nullable()->constrained('orders')->restrictOnDelete();
            $table->timestampsTz();
            $table->unique(['work_package_version_id', 'primary_vendor_id', 'work_package_line_id', 'listing_variant_id'], 'project_draft_item_unique');
        });
        DB::statement('ALTER TABLE project_procurement_draft_items ADD CONSTRAINT project_draft_quantity_positive CHECK (quantity > 0)');
    }

    public function down(): void
    {
        Schema::dropIfExists('project_procurement_draft_items');
    }
};
