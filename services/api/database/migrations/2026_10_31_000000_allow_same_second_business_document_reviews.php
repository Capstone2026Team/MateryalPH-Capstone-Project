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
        Schema::table('business_document_reviews', function (Blueprint $table): void {
            // Separate decisions can share a timestamp; their UUIDv7 IDs identify the history.
            $table->index(['business_document_version_id', 'reviewed_at', 'id'], 'business_document_reviews_version_reviewed_index');
            $table->dropUnique(['business_document_version_id', 'reviewed_at']);
        });
    }

    public function down(): void
    {
        if (DB::table('business_document_reviews')->selectRaw('1')->groupBy('business_document_version_id', 'reviewed_at')->havingRaw('COUNT(*) > 1')->exists()) {
            throw new RuntimeException('Same-second document review history must be retained; the timestamp uniqueness constraint cannot be restored.');
        }

        Schema::table('business_document_reviews', function (Blueprint $table): void {
            $table->unique(['business_document_version_id', 'reviewed_at']);
            $table->dropIndex('business_document_reviews_version_reviewed_index');
        });
    }
};
