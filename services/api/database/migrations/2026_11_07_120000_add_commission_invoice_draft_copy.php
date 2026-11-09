<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('fee_statements', function (Blueprint $table): void {
            $table->string('invoice_heading', 100)->default('Platform service invoice');
            $table->text('invoice_message')->default('');
        });
    }

    public function down(): void
    {
        Schema::table('fee_statements', fn (Blueprint $table) => $table->dropColumn(['invoice_heading', 'invoice_message']));
    }
};
