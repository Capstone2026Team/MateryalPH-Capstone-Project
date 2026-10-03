<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /** A personal inbox filter only: archiving hides a thread from one Buyer's inbox and never touches messages, quotations or orders. */
    public function up(): void
    {
        Schema::create('conversation_archives', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('conversation_id')->constrained('conversations')->restrictOnDelete();
            $table->foreignId('user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('archived_at');
            $table->timestampsTz();
            $table->unique(['conversation_id', 'user_id']);
            $table->index('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('conversation_archives');
    }
};
