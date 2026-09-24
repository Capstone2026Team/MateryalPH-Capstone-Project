<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->string('pending_store_email')->nullable();
            $table->timestampTz('pending_store_email_expires_at')->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->dropColumn(['pending_store_email', 'pending_store_email_expires_at']);
        });
    }
};
