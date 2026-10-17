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
            $table->boolean('vendor_delivery_enabled')->default(false);
        });
        // Retain existing delivery intent; current eligibility still controls new orders.
        DB::table('store_profiles')->whereIn('fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])
            ->update(['vendor_delivery_enabled' => true]);
    }

    public function down(): void
    {
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->dropColumn('vendor_delivery_enabled');
        });
    }
};
