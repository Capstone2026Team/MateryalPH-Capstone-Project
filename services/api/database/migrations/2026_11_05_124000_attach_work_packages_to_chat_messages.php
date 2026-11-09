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
        Schema::table('messages', function (Blueprint $table): void {
            $table->foreignUuid('work_package_inquiry_id')->nullable()->constrained('conversations')->restrictOnDelete();
            $table->foreignUuid('work_package_order_id')->nullable()->constrained('orders')->restrictOnDelete();
            $table->jsonb('work_package_snapshot')->nullable();
        });
        DB::statement('ALTER TABLE messages ADD CONSTRAINT message_work_package_snapshot_pair CHECK ((work_package_snapshot IS NULL) = (work_package_inquiry_id IS NULL AND work_package_order_id IS NULL))');
        DB::statement('ALTER TABLE messages ADD CONSTRAINT message_work_package_single_source CHECK (work_package_inquiry_id IS NULL OR work_package_order_id IS NULL)');
        DB::statement("ALTER TABLE messages ADD CONSTRAINT message_work_package_snapshot_object CHECK (work_package_snapshot IS NULL OR jsonb_typeof(work_package_snapshot) = 'object')");
    }

    public function down(): void
    {
        if (DB::table('messages')->whereNotNull('work_package_snapshot')->exists()) {
            throw new RuntimeException('Work Package message attachments retain immutable history and cannot be removed after use.');
        }
        DB::statement('ALTER TABLE messages DROP CONSTRAINT message_work_package_snapshot_pair, DROP CONSTRAINT message_work_package_snapshot_object, DROP CONSTRAINT message_work_package_single_source');
        Schema::table('messages', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('work_package_inquiry_id');
            $table->dropConstrainedForeignId('work_package_order_id');
            $table->dropColumn('work_package_snapshot');
        });
    }
};
