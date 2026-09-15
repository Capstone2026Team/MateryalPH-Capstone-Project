<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('auth_sessions', function (Blueprint $table): void {
            $table->foreignUuid('reauthentication_email_otp_id')->nullable()->constrained('email_otps')->restrictOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('auth_sessions', function (Blueprint $table): void {
            $table->dropForeign(['reauthentication_email_otp_id']);
            $table->dropColumn('reauthentication_email_otp_id');
        });
    }
};
