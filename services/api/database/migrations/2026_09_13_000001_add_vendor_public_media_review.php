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
        Schema::table('store_media', function (Blueprint $table): void {
            $table->string('review_status', 32)->default('PENDING_VERIFICATION');
            $table->timestampTz('replaced_at')->nullable();
        });
        Schema::create('vendor_business_submissions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('submitted_by_user_id')->constrained('users')->restrictOnDelete();
            $table->unsignedInteger('organization_version');
            $table->jsonb('business_information');
            $table->char('content_hash', 64);
            $table->timestampsTz();
            $table->unique(['vendor_organization_id', 'organization_version']);
        });
        DB::statement('CREATE TRIGGER phase_three_immutable BEFORE UPDATE OR DELETE ON vendor_business_submissions FOR EACH ROW EXECUTE FUNCTION phase_three_immutable()');
        DB::statement("ALTER TABLE store_media ADD CONSTRAINT vendor_media_review_status CHECK (review_status IN ('PENDING_VERIFICATION','APPROVED','RETURN_FOR_CORRECTION','REJECTED'))");
    }

    public function down(): void
    {
        Schema::dropIfExists('vendor_business_submissions');
        DB::statement('ALTER TABLE store_media DROP CONSTRAINT vendor_media_review_status');
        Schema::table('store_media', fn (Blueprint $table) => $table->dropColumn(['review_status', 'replaced_at']));
    }
};
