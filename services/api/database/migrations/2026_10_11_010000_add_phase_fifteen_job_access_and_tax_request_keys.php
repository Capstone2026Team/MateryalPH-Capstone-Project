<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tax_report_packages', function (Blueprint $table): void {
            $table->string('request_key', 64)->nullable();
            $table->string('request_hash', 64)->nullable();
            $table->unique(['prepared_by_user_id', 'request_key']);
        });
        $permission = (string) Str::uuid7();
        DB::table('permissions')->insert(['id' => $permission, 'code' => 'integrations.view', 'description' => 'View redacted integration and delivery job health', 'created_at' => now(), 'updated_at' => now()]);
        // Super Admin has platform oversight. Other roles need an explicit permission grant.
        DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'), 'permission_id' => $permission, 'created_at' => now(), 'updated_at' => now()]);
    }

    public function down(): void {}
};
