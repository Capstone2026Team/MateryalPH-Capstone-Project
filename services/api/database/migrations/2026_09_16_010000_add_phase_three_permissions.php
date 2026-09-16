<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        $permissions = [
            'vendor.onboarding.manage' => 'Draft and complete Vendor onboarding information.',
            'vendor.onboarding.private_documents' => 'View and submit private Vendor onboarding evidence.',
            'vendor.onboarding.submit' => 'Submit Store Verification for Admin review.',
            'vendor.payment.configure' => 'Capture and reconcile the Vendor payment connection.',
            'vendor.activation' => 'Evaluate and request Vendor activation.',
            'vendor_verification.review' => 'Review submitted Vendor Verification requirements.',
            'vendor_verification.view_private_documents' => 'View private Vendor Verification evidence.',
            'vendor_verification.restrict' => 'Restrict or restore Vendor activation readiness.',
        ];

        foreach ($permissions as $code => $description) {
            DB::table('permissions')->updateOrInsert(
                ['code' => $code],
                ['id' => DB::table('permissions')->where('code', $code)->value('id') ?? (string) Str::uuid7(), 'description' => $description, 'created_at' => now(), 'updated_at' => now()],
            );
        }

        DB::table('platform_roles')->updateOrInsert(
            ['code' => 'ADMIN_VENDOR_VERIFICATION', 'platform' => 'ADMIN'],
            ['id' => DB::table('platform_roles')->where('code', 'ADMIN_VENDOR_VERIFICATION')->where('platform', 'ADMIN')->value('id') ?? (string) Str::uuid7(), 'name' => 'Vendor Verification Admin', 'system_role' => true, 'created_at' => now(), 'updated_at' => now()],
        );

        $adminGrants = [
            'ADMIN_SUPERADMIN' => array_keys($permissions),
            'ADMIN_VENDOR_VERIFICATION' => ['vendor_verification.review', 'vendor_verification.view_private_documents', 'vendor_verification.restrict'],
        ];
        foreach ($adminGrants as $roleCode => $codes) {
            $roleId = DB::table('platform_roles')->where('code', $roleCode)->where('platform', 'ADMIN')->value('id');
            if ($roleId === null) {
                continue;
            }
            foreach ($codes as $code) {
                $permissionId = DB::table('permissions')->where('code', $code)->value('id');
                if ($permissionId !== null) {
                    DB::table('role_permissions')->updateOrInsert(
                        ['platform_role_id' => $roleId, 'permission_id' => $permissionId],
                        ['id' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()],
                    );
                }
            }
        }
    }

    public function down(): void
    {
        // Permission identities and grants are retained because audit records may reference their meaning.
    }
};
