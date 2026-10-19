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
        Schema::create('project_procurement_arrangements', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('work_package_version_id')->constrained('work_package_versions')->restrictOnDelete();
            $t->foreignUuid('source_candidate_id')->constrained('compiled_estimate_vendors')->restrictOnDelete();
            $t->unsignedInteger('lock_version')->default(1);
            $t->jsonb('preferences');
            $t->timestampTz('submitted_at')->nullable();
            $t->timestampsTz();
        });
        Schema::create('project_arrangement_vendors', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('arrangement_id')->constrained('project_procurement_arrangements')->restrictOnDelete();
            $t->foreignUuid('vendor_organization_id')->constrained('vendor_organizations')->restrictOnDelete();
            $t->string('fulfillment_method', 16);
            $t->foreignUuid('order_id')->nullable()->constrained('orders')->restrictOnDelete();
            $t->foreignUuid('conversation_id')->nullable()->constrained('conversations')->restrictOnDelete();
            $t->timestampTz('requested_at')->nullable();
            $t->timestampsTz();
            $t->unique(['arrangement_id', 'vendor_organization_id'], 'project_arrangement_vendor_unique');
            $t->unique(['id', 'arrangement_id'], 'project_arrangement_vendor_scope');
        });
        DB::statement("ALTER TABLE project_arrangement_vendors ADD CONSTRAINT project_arrangement_method CHECK (fulfillment_method IN ('DELIVERY','PICKUP'))");
        Schema::create('project_arrangement_items', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('arrangement_id')->constrained('project_procurement_arrangements')->restrictOnDelete();
            $t->uuid('arrangement_vendor_id');
            $t->foreign(['arrangement_vendor_id', 'arrangement_id'], 'project_arrangement_item_vendor_scope')->references(['id', 'arrangement_id'])->on('project_arrangement_vendors')->restrictOnDelete();
            $t->foreignUuid('work_package_line_id')->constrained('work_package_lines')->restrictOnDelete();
            $t->foreignUuid('listing_variant_id')->constrained('listing_variants')->restrictOnDelete();
            $t->decimal('quantity', 14, 4);
            $t->jsonb('snapshot');
            $t->timestampTz('removed_at')->nullable();
            $t->timestampsTz();
        });
        DB::statement('ALTER TABLE project_arrangement_items ADD CONSTRAINT project_arrangement_quantity_positive CHECK (quantity > 0)');
        DB::statement('CREATE UNIQUE INDEX project_arrangement_item_unique ON project_arrangement_items(arrangement_id, work_package_line_id, listing_variant_id) WHERE removed_at IS NULL');
        Schema::table('orders', function (Blueprint $t): void {
            $t->foreignUuid('project_arrangement_id')->nullable()->constrained('project_procurement_arrangements')->restrictOnDelete();
            $t->foreignUuid('project_arrangement_vendor_id')->nullable()->constrained('project_arrangement_vendors')->restrictOnDelete();
            $t->foreign(['project_arrangement_vendor_id', 'project_arrangement_id'], 'order_project_arrangement_scope')->references(['id', 'arrangement_id'])->on('project_arrangement_vendors')->restrictOnDelete();
        });
        DB::statement("ALTER TABLE orders ADD CONSTRAINT project_arrangement_order_context CHECK ((project_arrangement_id IS NULL AND project_arrangement_vendor_id IS NULL) OR (project_arrangement_id IS NOT NULL AND project_arrangement_vendor_id IS NOT NULL AND procurement_type = 'PROJECT_BASED'))");
        Schema::table('work_packages', function (Blueprint $t): void {
            $t->foreignUuid('selected_arrangement_id')->nullable()->constrained('project_procurement_arrangements')->restrictOnDelete();
        });
        DB::statement('DROP INDEX one_project_order_per_version');
        DB::statement("CREATE UNIQUE INDEX one_project_order_per_version ON orders(work_package_version_id) WHERE procurement_type = 'PROJECT_BASED' AND project_arrangement_id IS NULL AND order_state NOT IN ('CANCELLED','DECLINED','EXPIRED')");
        DB::statement("CREATE UNIQUE INDEX one_project_order_per_arrangement_vendor ON orders(project_arrangement_id, vendor_organization_id) WHERE project_arrangement_id IS NOT NULL AND order_state NOT IN ('CANCELLED','DECLINED','EXPIRED')");
    }

    public function down(): void
    {
        if (DB::table('project_procurement_arrangements')->exists()) {
            throw new RuntimeException('Procurement arrangements retain commercial history and cannot be rolled back after use.');
        }
        DB::statement('DROP INDEX one_project_order_per_arrangement_vendor');
        DB::statement('DROP INDEX one_project_order_per_version');
        DB::statement("CREATE UNIQUE INDEX one_project_order_per_version ON orders(work_package_version_id) WHERE procurement_type = 'PROJECT_BASED' AND order_state NOT IN ('CANCELLED','DECLINED','EXPIRED')");
        Schema::table('work_packages', fn (Blueprint $t) => $t->dropConstrainedForeignId('selected_arrangement_id'));
        Schema::table('orders', function (Blueprint $t): void {
            $t->dropForeign('order_project_arrangement_scope');
            $t->dropConstrainedForeignId('project_arrangement_vendor_id');
            $t->dropConstrainedForeignId('project_arrangement_id');
        });
        Schema::dropIfExists('project_arrangement_items');
        Schema::dropIfExists('project_arrangement_vendors');
        Schema::dropIfExists('project_procurement_arrangements');
    }
};
