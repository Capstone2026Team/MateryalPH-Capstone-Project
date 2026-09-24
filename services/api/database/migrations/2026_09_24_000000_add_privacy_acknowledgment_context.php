<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('privacy_acknowledgments', function (Blueprint $table): void {
            // Historical immutable acknowledgments retain unknown context.
            $table->string('processing_activity', 96)->nullable();
            $table->string('source', 64)->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('privacy_acknowledgments', function (Blueprint $table): void {
            $table->dropColumn(['processing_activity', 'source']);
        });
    }
};
