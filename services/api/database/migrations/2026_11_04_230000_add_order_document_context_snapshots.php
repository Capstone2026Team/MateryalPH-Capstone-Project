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
        Schema::table('order_document_renditions', function (Blueprint $table): void {
            $table->jsonb('context_snapshot')->nullable();
            $table->string('context_hash', 64)->nullable();
        });
        DB::statement('ALTER TABLE order_document_renditions ADD CONSTRAINT order_document_context_check CHECK ((context_snapshot IS NULL) = (context_hash IS NULL) AND (layout_version < 3 OR context_snapshot IS NOT NULL))');
    }

    public function down(): void
    {
        // Forward-only: retain the party details recorded with every issued rendition.
    }
};
