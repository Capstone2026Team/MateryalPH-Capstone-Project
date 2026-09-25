<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class CurrentVendorTeamAuthority
{
    public function __construct(private readonly AccountAccess $access) {}

    /**
     * Lock the organization before the actor and membership in every team mutation.
     * The caller must keep this transaction open until its writes and audit are complete.
     *
     * @return array{role: string, organization_id: string, membership_id: string, can_manage_staff: bool, permissions: list<string>}
     */
    public function lock(Request $request, string $organizationId): array
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->where('account_status', 'ACTIVE')->lockForUpdate()->first();
        $actor = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->first();
        $member = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)
            ->where('user_id', $request->user()->getKey())->lockForUpdate()->first();
        if ($organization === null || $actor === null || $actor->account_type !== 'VENDOR' || $actor->account_status !== 'ACTIVE'
            || $member === null || $member->status !== 'ACTIVE') {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Vendor team action is unavailable.', 403);
        }

        $scope = $this->access->resolve($actor);
        if ($scope['organization_id'] !== $organizationId || $scope['membership_id'] !== $member->id) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Vendor team action is unavailable.', 403);
        }
        $request->attributes->set('account_scope', $scope);

        /** @var array{role: string, organization_id: string, membership_id: string, can_manage_staff: bool, permissions: list<string>} $scope */
        return $scope;
    }
}
