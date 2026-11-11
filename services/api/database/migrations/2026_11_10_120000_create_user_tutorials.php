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
        Schema::create('user_tutorials', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->constrained('users')->restrictOnDelete();
            $table->string('tutorial_key', 32);
            $table->string('status', 16);
            $table->timestampsTz();
            $table->unique(['user_id', 'tutorial_key']);
        });
        DB::statement("ALTER TABLE user_tutorials ADD CONSTRAINT user_tutorial_status_check CHECK (status IN ('COMPLETED', 'SKIPPED'))");
        DB::statement("ALTER TABLE user_tutorials ADD CONSTRAINT user_tutorial_key_check CHECK (tutorial_key IN ('overview', 'discovery', 'procurement', 'projects', 'messages', 'orders', 'store', 'products', 'inventory'))");
    }

    public function down(): void
    {
        Schema::dropIfExists('user_tutorials');
    }
};
