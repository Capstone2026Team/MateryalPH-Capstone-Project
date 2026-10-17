<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * An Item-Based cart line, and the order line it becomes, may name the Work
 * Package line it is bought for (owner decision 2026-10-12: missing materials
 * are bought through separate, linked Item-Based orders). The tag is advisory;
 * linking still verifies material, unit, brand, specifications and quantity.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('cart_items', function (Blueprint $table): void {
            $table->foreignUuid('work_package_line_id')->nullable()->constrained('work_package_lines')->nullOnDelete();
        });
        Schema::table('order_lines', function (Blueprint $table): void {
            $table->foreignUuid('work_package_line_id')->nullable()->constrained('work_package_lines')->restrictOnDelete();
            $table->index('work_package_line_id');
        });
    }

    public function down(): void
    {
        Schema::table('order_lines', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('work_package_line_id');
        });
        Schema::table('cart_items', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('work_package_line_id');
        });
    }
};
