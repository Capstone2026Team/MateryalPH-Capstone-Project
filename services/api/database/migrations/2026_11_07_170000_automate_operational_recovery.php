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
        Schema::table('outbox_events', function (Blueprint $table): void {
            $table->smallInteger('automatic_recovery_count')->default(0);
        });
        DB::statement('ALTER TABLE outbox_events ADD CONSTRAINT outbox_automatic_recovery_check CHECK (automatic_recovery_count BETWEEN 0 AND 3)');
        Schema::table('operation_retries', function (Blueprint $table): void {
            $table->foreignId('actor_user_id')->nullable()->change();
        });
        DB::statement("ALTER TABLE operation_retries ADD CONSTRAINT operation_retry_system_check CHECK (actor_user_id IS NOT NULL OR (actor_role = 'SYSTEM' AND target_type = 'OUTBOX_EVENT'))");
    }

    public function down(): void
    {
        // Recovery counters and append-only system history must survive a rollback.
    }
};
