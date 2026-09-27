<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\ManageAdminAccount;
use App\Domain\Authorization\ManageMembership;
use App\Domain\Authorization\ManageVendorTeam;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\IssueAdminInvitation;
use App\Domain\Vendors\IssueVendorInvitation;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\AccountRequest;
use App\Http\Requests\Vendor\VendorInvitationRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class AccountAdministrationController extends Controller
{
    public function administrators(Request $request, ManageAdminAccount $accounts): JsonResponse
    {
        $accounts->authorize($request);
        $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $rows = DB::table('admin_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')->orderBy('u.public_id')->paginate(20, ['u.public_id as id', 'u.name', 'u.lock_version', 'm.status', 'r.code as role', 'r.id as role_id']);

        return ApiResponse::success($rows->items(), ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage()]);
    }

    public function changeAdmin(AccountRequest $request, string $publicId, ManageAdminAccount $accounts): JsonResponse
    {
        $accounts->change($request, $publicId, $request->validated());

        return ApiResponse::success(['changed' => true]);
    }

    public function memberships(Request $request, AccountAccess $access): JsonResponse
    {
        if (! $access->allows($request->user(), 'staff.manage')) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Staff management is not delegated to this account.', 403);
        }
        $scope = $access->resolve($request->user());
        $query = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $scope['organization_id'])->where('m.role', '!=', 'OWNER');
        if ($scope['role'] !== 'OWNER') {
            $query->where('m.role', '!=', 'STORE_MANAGER');
        }
        $rows = $query->orderBy('m.id')->paginate(20, ['m.id', 'u.name', 'm.role', 'm.status', 'm.can_manage_staff', 'm.lock_version']);

        return ApiResponse::success($rows->items(), ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage()]);
    }

    public function delegate(AccountRequest $request, string $membershipId, ManageMembership $memberships): JsonResponse
    {
        $memberships->change($request, $membershipId, 'can_manage_staff', (bool) $request->validated('can_manage_staff'));

        return ApiResponse::success(['changed' => true]);
    }

    public function updateStaff(AccountRequest $request, string $membershipId, ManageVendorTeam $team): JsonResponse
    {
        $team->update($request, $membershipId, $request->validated());

        return ApiResponse::success(['changed' => true]);
    }

    public function staffDisputes(AccountRequest $request, ManageVendorTeam $team): JsonResponse
    {
        $team->disputes($request, (bool) $request->validated('enabled'), (int) $request->validated('lock_version'));

        return ApiResponse::success(['changed' => true]);
    }

    public function changeMembership(AccountRequest $request, string $membershipId, ManageMembership $memberships): JsonResponse
    {
        $memberships->change($request, $membershipId, 'status', $request->validated('status'));

        return ApiResponse::success(['changed' => true]);
    }

    public function roles(Request $request, AccountAccess $access): JsonResponse
    {
        if (! $access->allows($request->user(), 'admin.invite')) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot invite Admin accounts.', 403);
        }

        return ApiResponse::success(DB::table('platform_roles')->where('platform', 'ADMIN')->whereIn('code', IssueAdminInvitation::ROLES)->orderBy('name')->get(['id', 'code', 'name']));
    }

    public function inviteAdmin(AccountRequest $request, IssueAdminInvitation $invitations): JsonResponse
    {
        $invitations->handle($request, $request->validated('email'), $request->validated('role_id'));

        return ApiResponse::success(['queued' => true], status: 202);
    }

    public function inviteVendor(VendorInvitationRequest $request, IssueVendorInvitation $invitations): JsonResponse
    {
        return ApiResponse::success($invitations->handle($request, $request->validated()), status: 202);
    }

    public function vendorInvitations(Request $request, AccountAccess $access): JsonResponse
    {
        $scope = $access->resolve($request->user());
        if (! in_array('staff.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot view team invitations.', 403);
        }
        $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $query = DB::table('vendor_invitations as i')->join('users as u', 'u.id', '=', 'i.invited_by_user_id')->where('i.vendor_organization_id', $scope['organization_id']);
        if ($scope['role'] !== 'OWNER') {
            $query->where('i.role', '!=', 'STORE_MANAGER');
        }
        $rows = $query->orderByDesc('i.created_at')->orderByDesc('i.id')->paginate(20, ['i.id', 'i.invitee_name', 'i.normalized_email as email', 'i.invitee_mobile', 'i.vendor_organization_id', 'i.role', 'i.can_manage_staff', 'i.expires_at', 'i.created_at', 'i.accepted_at', 'i.revoked_at', 'u.public_id as invited_by_id', 'u.name as invited_by_name']);
        $items = collect($rows->items())->map(function (object $row): array {
            $status = $row->accepted_at !== null ? 'ACCEPTED' : ($row->revoked_at !== null ? 'REVOKED' : (now()->greaterThanOrEqualTo($row->expires_at) ? 'EXPIRED' : 'PENDING'));
            unset($row->revoked_at);

            return (array) $row + ['status' => $status];
        })->all();

        return ApiResponse::success($items, ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage()]);
    }

    public function vendorActivity(Request $request, AccountAccess $access): JsonResponse
    {
        $scope = $access->resolve($request->user());
        if (! in_array('staff.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot view team activity.', 403);
        }
        $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $query = DB::table('audit_logs as a')->leftJoin('users as u', 'u.id', '=', 'a.actor_user_id')->where('a.vendor_organization_id', $scope['organization_id']);
        if ($scope['role'] !== 'OWNER') {
            $query->whereIn('a.actor_role', ['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT']);
        }
        $rows = $query->orderByDesc('a.created_at')->orderByDesc('a.id')->paginate(20, ['a.id', 'u.name as actor_name', 'a.actor_role', 'a.action', 'a.resource_type', 'a.resource_id', 'a.created_at', 'a.succeeded', 'a.before', 'a.after']);
        $safeFields = array_flip(['role', 'status', 'can_manage_staff', 'enabled', 'name_changed']);
        $items = collect($rows->items())->map(function (object $row) use ($safeFields): array {
            // Only predefined non-sensitive change fields belong in this staff-facing projection.
            $row->before = (object) array_intersect_key(json_decode($row->before ?? '{}', true, flags: JSON_THROW_ON_ERROR), $safeFields);
            $row->after = (object) array_intersect_key(json_decode($row->after ?? '{}', true, flags: JSON_THROW_ON_ERROR), $safeFields);

            return (array) $row;
        })->all();

        return ApiResponse::success($items, ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage()]);
    }
}
