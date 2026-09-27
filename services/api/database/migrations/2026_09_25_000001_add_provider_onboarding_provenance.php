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
            $table->timestampTz('provider_associated_at')->nullable();
            $table->timestampTz('onboarding_requested_at')->nullable();
        });
        // Legacy client-entered references remain historical data, never trusted
        // association evidence. Only backend-issued associations are unique.
        DB::statement('CREATE UNIQUE INDEX vendor_payment_provider_association_unique ON vendor_payment_accounts (provider, environment, provider_account_id) WHERE provider_associated_at IS NOT NULL');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS vendor_payment_provider_association_unique');
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            $table->dropColumn(['provider_associated_at', 'onboarding_requested_at']);
        });
    }
};
