<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vendor_document_expiry_notices', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('business_document_version_id')->constrained()->restrictOnDelete();
            $table->string('notice_kind', 24);
            $table->timestampTz('sent_at');
            $table->timestampsTz();
            $table->unique(['business_document_version_id', 'notice_kind']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vendor_document_expiry_notices');
    }
};
