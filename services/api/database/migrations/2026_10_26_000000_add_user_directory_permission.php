<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The Buyer and Vendor user directories show contact details that the enforcement review deliberately masks, so they
 * sit behind their own least-privilege grant. Every detail opening is audited by the directory service.
 */
return new class extends Migration
{
    private const CODE = 'user_directory.view';

    public function up(): void
    {
        $permissionId = DB::table('permissions')->where('code', self::CODE)->value('id');
        if ($permissionId === null) {
            $permissionId = (string) Str::uuid7();
            DB::table('permissions')->insert(['id' => $permissionId, 'code' => self::CODE, 'description' => 'View the Buyer and Vendor user directories, including contact details, ratings, activity and product listings; each profile opening is audited', 'created_at' => now(), 'updated_at' => now()]);
        }
        foreach (['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT', 'ADMIN_SUPPORT'] as $roleCode) {
            $roleId = DB::table('platform_roles')->where('code', $roleCode)->where('platform', 'ADMIN')->value('id');
            if ($roleId !== null && ! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permissionId)->exists()) {
                DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
    }

    public function down(): void
    {
        // Permission identities and grants are retained because audit records may reference their meaning.
    }
};
