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
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->timestampTz('account_deleted_at')->nullable();
        });
        DB::statement("ALTER TABLE vendor_organizations ADD CONSTRAINT vendor_account_deleted_check CHECK ((account_status = 'DELETED') = (account_deleted_at IS NOT NULL) AND (account_deleted_at IS NULL OR (store_activation_status = 'NOT_READY' AND marketplace_discoverability_status = 'NOT_DISCOVERABLE')))");
    }

    public function down(): void
    {
        // An applied closure must never become an account that activation can restore.
        if (DB::table('vendor_organizations')->whereNotNull('account_deleted_at')->exists()) {
            throw new LogicException('Vendor account deletions require a forward migration.');
        }
        DB::statement('ALTER TABLE vendor_organizations DROP CONSTRAINT vendor_account_deleted_check');
        Schema::table('vendor_organizations', fn (Blueprint $table) => $table->dropColumn('account_deleted_at'));
    }
};
