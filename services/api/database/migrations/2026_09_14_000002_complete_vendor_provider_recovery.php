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
        Schema::create('vendor_public_media_recoveries', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('store_media_id')->nullable()->constrained('store_media')->restrictOnDelete();
            $table->string('object_key')->unique();
            $table->string('state', 32);
            $table->string('provider_asset_id')->nullable();
            $table->string('provider_format', 12)->nullable();
            $table->string('last_error', 64)->nullable();
            $table->unsignedSmallInteger('cleanup_attempts')->default(0);
            $table->timestampTz('recovered_at')->nullable();
            $table->timestampsTz();
            $table->index(['state', 'updated_at']);
            $table->index(['vendor_organization_id', 'state']);
        });
        DB::statement("ALTER TABLE vendor_public_media_recoveries ADD CONSTRAINT vendor_public_media_recovery_state CHECK (state IN ('PLANNED','UPLOAD_UNCONFIRMED','UPLOAD_CONFIRMED','LINKED','CLEANUP_REQUIRED','CLEANED'))");
        DB::statement("CREATE UNIQUE INDEX store_media_current_approved_identity_unique ON store_media (store_profile_id, kind) WHERE replaced_at IS NULL AND review_status = 'APPROVED' AND kind IN ('LOGO','BANNER')");
        DB::statement("CREATE UNIQUE INDEX store_media_current_pending_identity_unique ON store_media (store_profile_id, kind) WHERE replaced_at IS NULL AND review_status = 'PENDING_VERIFICATION' AND kind IN ('LOGO','BANNER')");
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS store_media_current_pending_identity_unique');
        DB::statement('DROP INDEX IF EXISTS store_media_current_approved_identity_unique');
        Schema::dropIfExists('vendor_public_media_recoveries');
    }
};
