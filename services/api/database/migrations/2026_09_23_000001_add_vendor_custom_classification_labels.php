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
        Schema::table('vendor_classifications', function (Blueprint $table): void {
            $table->jsonb('custom_labels')->default('[]');
        });
        DB::statement("UPDATE vendor_classifications SET custom_labels = jsonb_build_array(custom_label) WHERE custom_label IS NOT NULL AND trim(custom_label) <> ''");
    }

    public function down(): void
    {
        Schema::table('vendor_classifications', fn (Blueprint $table) => $table->dropColumn('custom_labels'));
    }
};
