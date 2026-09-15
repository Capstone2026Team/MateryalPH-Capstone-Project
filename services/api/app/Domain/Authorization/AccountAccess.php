<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class AccountAccess
{
    public const VENDOR_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'];

    /** @return array{role: string, organization_id: ?string, membership_id: ?string, can_manage_staff: bool, permissions: list<string>} */
    public function resolve(User $user): array
    {
        if ($user->account_status !== 'ACTIVE') {
            throw new AuthenticationException('ACCOUNT_NOT_ACTIVE', 'This account cannot access this service.', 403);
        }
        $role = 'BUYER';
        $organization = null;
        $membershipId = null;
        $delegated = false;
        $permissions = [];
        if ($user->account_type === 'VENDOR') {
            $member = DB::table('vendor_memberships as m')->join('vendor_organizations as o', 'o.id', '=', 'm.vendor_organization_id')
                ->where('m.user_id', $user->getKey())->where('m.status', 'ACTIVE')->where('o.account_status', 'ACTIVE')
                ->first(['m.id', 'm.role', 'm.vendor_organization_id', 'm.can_manage_staff']);
            if ($member === null || ! in_array($member->role, self::VENDOR_ROLES, true)) {
                throw new AuthenticationException('MEMBERSHIP_NOT_ACTIVE', 'Your membership does not permit access.', 403);
            }
            $role = $member->role;
            $organization = $member->vendor_organization_id;
            $membershipId = $member->id;
            $delegated = $role === 'STORE_MANAGER' && (bool) $member->can_manage_staff;
            $permissions = $this->vendorPermissions($role, $delegated);
        } elseif ($user->account_type === 'ADMIN') {
            $member = DB::table('admin_memberships as m')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')
                ->where('m.user_id', $user->getKey())->where('m.status', 'ACTIVE')->where('r.platform', 'ADMIN')
                ->first(['m.id', 'r.id as role_id', 'r.code']);
            if ($member === null) {
                throw new AuthenticationException('MEMBERSHIP_NOT_ACTIVE', 'Your membership does not permit access.', 403);
            }
            $role = $member->code;
            $membershipId = $member->id;
            $permissions = DB::table('role_permissions as rp')->join('permissions as p', 'p.id', '=', 'rp.permission_id')
                ->where('rp.platform_role_id', $member->role_id)->orderBy('p.code')->pluck('p.code')->all();
        } elseif ($user->account_type !== 'BUYER') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access this portal.', 403);
        }

        return ['role' => $role, 'organization_id' => $organization, 'membership_id' => $membershipId, 'can_manage_staff' => $delegated, 'permissions' => $permissions];
    }

    public function allows(User $user, string $permission): bool
    {
        return in_array($permission, $this->resolve($user)['permissions'], true);
    }

    /** @return list<string> */
    public function vendorPermissions(string $role, bool $delegated = false): array
    {
        $permissions = match ($role) {
            'OWNER', 'STORE_MANAGER' => ['quotations.publish', 'orders.set_nrpc', 'orders.confirm', 'catalog.manage', 'inventory.manage', 'compliance.submit', 'auto_accept.configure', 'fulfillment.record', 'finance.view', 'finance.draft_corrections', 'materials_analytics.view_competitors'],
            'STORE_STAFF' => ['quotations.publish', 'orders.set_nrpc', 'orders.confirm', 'catalog.manage', 'inventory.manage', 'compliance.submit', 'auto_accept.view_outcomes'],
            'CUSTOMER_SERVICE' => ['orders.confirm', 'auto_accept.view_outcomes'],
            'INVENTORY' => ['catalog.manage', 'inventory.manage', 'compliance.submit', 'auto_accept.manage_allotment'],
            'FULFILLMENT' => ['fulfillment.record'],
            default => [],
        };
        if ($role === 'OWNER') {
            $permissions = [...$permissions, 'staff.manage', 'managers.manage', 'staff.delegate', 'organization.legal', 'organization.delete', 'payments.configure', 'finance.attest', 'finance.pay'];
        } elseif ($role === 'STORE_MANAGER' && $delegated) {
            $permissions[] = 'staff.manage';
        }

        return $permissions;
    }
}
