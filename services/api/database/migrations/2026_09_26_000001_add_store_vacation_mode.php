<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->boolean('vacation_mode')->default(false);
        });
    }

    public function down(): void
    {
        Schema::table('store_profiles', function (Blueprint $table): void {
            $table->dropColumn('vacation_mode');
        });
    }
};
