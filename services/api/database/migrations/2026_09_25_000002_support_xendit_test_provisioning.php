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
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            $table->timestampTz('provider_created_at')->nullable();
        });
        DB::statement('ALTER TABLE vendor_payment_accounts DROP CONSTRAINT vendor_payment_provider_check');
        DB::statement("ALTER TABLE vendor_payment_accounts ADD CONSTRAINT vendor_payment_provider_check CHECK (provider = 'XENDIT' AND environment IN ('TEST','DEMO','LIVE') AND connection_status IN ('UNVERIFIED','PENDING','CONNECTED','FAILED','REVOKED','NOT_CONNECTED','CONNECTING','CONNECTED_TEST','CONNECTION_FAILED'))");
        // No legacy record is promoted to confirmed TEST provisioning.
    }

    public function down(): void
    {
        DB::statement("UPDATE vendor_payment_accounts SET connection_status = CASE connection_status WHEN 'CONNECTED_TEST' THEN 'CONNECTED' WHEN 'CONNECTING' THEN 'PENDING' WHEN 'CONNECTION_FAILED' THEN 'FAILED' ELSE 'UNVERIFIED' END WHERE connection_status IN ('NOT_CONNECTED','CONNECTING','CONNECTED_TEST','CONNECTION_FAILED')");
        DB::statement('ALTER TABLE vendor_payment_accounts DROP CONSTRAINT vendor_payment_provider_check');
        DB::statement("ALTER TABLE vendor_payment_accounts ADD CONSTRAINT vendor_payment_provider_check CHECK (provider = 'XENDIT' AND environment IN ('TEST','DEMO','LIVE') AND connection_status IN ('UNVERIFIED','PENDING','CONNECTED','FAILED','REVOKED'))");
        Schema::table('vendor_payment_accounts', fn (Blueprint $table) => $table->dropColumn('provider_created_at'));
    }
};
