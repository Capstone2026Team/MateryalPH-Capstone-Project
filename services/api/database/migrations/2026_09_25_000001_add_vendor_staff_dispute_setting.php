<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->boolean('staff_disputes_enabled')->default(true);
        });
    }

    public function down(): void
    {
        Schema::table('vendor_organizations', fn (Blueprint $table) => $table->dropColumn('staff_disputes_enabled'));
    }
};
