<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\ManageAdminAccount;
use App\Domain\Authorization\ManageMembership;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\IssueAdminInvitation;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\AccountRequest;
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
        $rows = $query->orderBy('m.id')->paginate(20, ['m.id', 'u.name', 'm.role', 'm.status', 'm.can_manage_staff']);

        return ApiResponse::success($rows->items(), ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage()]);
    }

    public function delegate(AccountRequest $request, string $membershipId, ManageMembership $memberships): JsonResponse
    {
        $memberships->change($request, $membershipId, 'can_manage_staff', (bool) $request->validated('can_manage_staff'));

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
}
