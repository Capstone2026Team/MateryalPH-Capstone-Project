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
        Schema::create('vendor_invoice_presets', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->jsonb('defaults');
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignId('updated_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
        });
        Schema::create('invoice_drafts', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->jsonb('payload');
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->foreignUuid('sent_record_id')->nullable()->constrained('invoice_records')->restrictOnDelete();
            $table->timestampTz('sent_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignId('updated_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
        });
        Schema::table('invoice_records', fn (Blueprint $table) => $table->jsonb('commercial_snapshot')->nullable());
        DB::statement('ALTER TABLE invoice_drafts ADD CONSTRAINT invoice_draft_sent_check CHECK ((sent_record_id IS NULL) = (sent_at IS NULL) AND lock_version > 0)');
        DB::statement('ALTER TABLE vendor_invoice_presets ADD CONSTRAINT invoice_preset_version_check CHECK (lock_version > 0)');
    }

    public function down(): void
    {
        if (DB::table('invoice_drafts')->exists() || DB::table('vendor_invoice_presets')->exists()
            || DB::table('invoice_records')->whereNotNull('commercial_snapshot')->exists()) {
            throw new RuntimeException('Invoice preparation and sent history must be retained. Roll forward instead.');
        }
        Schema::table('invoice_records', fn (Blueprint $table) => $table->dropColumn('commercial_snapshot'));
        Schema::dropIfExists('invoice_drafts');
        Schema::dropIfExists('vendor_invoice_presets');
    }
};
