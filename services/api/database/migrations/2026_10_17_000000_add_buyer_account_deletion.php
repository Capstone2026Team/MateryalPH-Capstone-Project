<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Buyer self-service account deletion (Buyer Workflow §Account; System Workflow §Privacy). A deleted account is
 * deactivated first: the row and its commercial, financial, dispute and audit history are retained and a DELETION
 * privacy request tracks minimization. DELETED is final and distinct from enforcement statuses, so lifting a
 * sanction can never reactivate it.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            $table->timestampTz('account_deleted_at')->nullable();
        });
        DB::statement("ALTER TABLE users ADD CONSTRAINT users_account_deleted_check CHECK ((account_status = 'DELETED') = (account_deleted_at IS NOT NULL))");
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE users DROP CONSTRAINT IF EXISTS users_account_deleted_check');
        Schema::table('users', function (Blueprint $table): void {
            $table->dropColumn('account_deleted_at');
        });
    }
};
