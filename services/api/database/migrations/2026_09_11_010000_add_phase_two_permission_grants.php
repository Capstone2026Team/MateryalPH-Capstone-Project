<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        $roles = [
            'ADMIN_SUPERADMIN' => 'Super Admin', 'ADMIN_VENDOR_VERIFICATION' => 'Vendor Verification Staff',
            'ADMIN_PRODUCT_COMPLIANCE' => 'Product Compliance Staff', 'ADMIN_ORDER_DISPUTE' => 'Order and Dispute Staff',
            'ADMIN_USER_MANAGEMENT' => 'User Management Staff', 'ADMIN_SUPPORT' => 'Support Staff',
        ];
        foreach ($roles as $code => $name) {
            if (! DB::table('platform_roles')->where('code', $code)->exists()) {
                DB::table('platform_roles')->insert(['id' => (string) Str::uuid7(), 'code' => $code, 'name' => $name, 'platform' => 'ADMIN', 'system_role' => true, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
        foreach (['admin.invite', 'admin.manage_accounts', 'finance.view', 'finance.review_tax', 'finance.approve_statements', 'finance.export', 'finance.record_external_evidence', 'materials_analytics.inspect_sources', 'analytics.view_aggregates'] as $code) {
            $permissionId = DB::table('permissions')->where('code', $code)->value('id');
            if ($permissionId === null) {
                $permissionId = (string) Str::uuid7();
                DB::table('permissions')->insert(['id' => $permissionId, 'code' => $code, 'description' => $code, 'created_at' => now(), 'updated_at' => now()]);
            }
            $roleId = DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id');
            if (! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permissionId)->exists()) {
                DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
    }

    public function down(): void
    {
        // Grants and role identities may already be referenced by immutable audit history.
    }
};
