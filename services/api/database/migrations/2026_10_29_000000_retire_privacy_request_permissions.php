<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Owner-approved retirement: remove grants from predefined and custom roles.
        // Historical requests, events and audit records keep their existing retention guards.
        $permissionIds = DB::table('permissions')->whereIn('code', ['privacy.manage', 'privacy.handle'])->pluck('id');
        DB::table('role_permissions')->whereIn('permission_id', $permissionIds)->delete();
        DB::table('permissions')->whereIn('id', $permissionIds)->delete();
    }

    public function down(): void
    {
        // Retirement is forward-only; rolling back must not silently restore access.
    }
};
