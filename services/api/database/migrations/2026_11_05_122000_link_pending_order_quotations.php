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
        Schema::table('quotations', fn (Blueprint $t) => $t->foreignUuid('replaces_order_id')->nullable()->unique()->constrained('orders')->restrictOnDelete());
    }

    public function down(): void
    {
        if (DB::table('quotations')->whereNotNull('replaces_order_id')->exists()) {
            throw new RuntimeException('Replacement quotation links retain commercial history and cannot be rolled back after use.');
        }
        Schema::table('quotations', fn (Blueprint $t) => $t->dropConstrainedForeignId('replaces_order_id'));
    }
};
