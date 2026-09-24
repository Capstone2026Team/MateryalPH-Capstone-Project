<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        foreach (['addresses', 'vendor_address_versions'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->string('psgc_source', 32)->nullable();
                $table->string('province_code', 16)->nullable();
                $table->string('city_code', 16)->nullable();
            });
        }
        Schema::table('psgc_areas', function (Blueprint $table): void {
            $table->index(['psgc_version_id', 'level', 'parent_id'], 'psgc_address_lookup');
        });
    }

    public function down(): void
    {
        foreach (['addresses', 'vendor_address_versions'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->dropColumn('psgc_source');
                $table->dropColumn(['province_code', 'city_code']);
            });
        }
        Schema::table('psgc_areas', fn (Blueprint $table) => $table->dropIndex('psgc_address_lookup'));
    }
};
