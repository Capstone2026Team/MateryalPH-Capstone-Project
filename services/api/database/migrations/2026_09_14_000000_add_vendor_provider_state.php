<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            $table->string('provider_status', 32)->nullable();
            $table->uuid('connection_attempt_id')->nullable()->unique();
            $table->string('connection_error', 64)->nullable();
            $table->unique(['provider', 'environment', 'provider_account_reference'], 'vendor_provider_account_unique');
        });
        Schema::table('files', function (Blueprint $table): void {
            $table->string('storage_provider', 24)->default('S3');
            $table->string('provider_asset_id')->nullable();
            $table->string('provider_format', 12)->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            $table->dropUnique('vendor_provider_account_unique');
            $table->dropUnique(['connection_attempt_id']);
            $table->dropColumn(['provider_status', 'connection_attempt_id', 'connection_error']);
        });
        Schema::table('files', fn (Blueprint $table) => $table->dropColumn(['storage_provider', 'provider_asset_id', 'provider_format']));
    }
};
