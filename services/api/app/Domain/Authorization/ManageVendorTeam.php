<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ManageAccount;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\IssueVendorInvitation;
use App\Models\AuthSession;
use App\Models\VendorMembership;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class ManageVendorTeam
{
    public function __construct(private readonly MembershipPolicy $policy, private readonly RecentAuthentication $recent, private readonly AuditRecorder $audit, private readonly TokenSessionService $sessions, private readonly ManageAccount $accounts, private readonly AccountAgreements $agreements, private readonly CurrentVendorTeamAuthority $authority) {}

    /** @param array<string, mixed> $input */
    public function update(Request $request, string $id, array $input): void
    {
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $id, $input): void {
            $organizationId = $request->attributes->get('account_scope')['organization_id'];
            $scope = $this->authority->lock($request, $organizationId);
            $target = VendorMembership::query()->whereKey($id)->where('vendor_organization_id', $scope['organization_id'])->lockForUpdate()->first();
            if ($target === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This team member is unavailable.', 404);
            }
            if (! $this->policy->manage($request->user(), $target) || ! in_array($input['role'], IssueVendorInvitation::ROLES, true)
                || ($scope['role'] !== 'OWNER' && $input['role'] === 'STORE_MANAGER')) {
                throw new AuthenticationException('PERMISSION_DENIED', 'You cannot assign this staff role.', 403);
            }
            if ((int) $target->getAttribute('lock_version') !== (int) $input['lock_version']) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This team member changed. Refresh before trying again.', 409);
            }
            $user = DB::table('users')->where('id', $target->user_id)->lockForUpdate()->first();
            $before = ['role' => $target->role, 'can_manage_staff' => $target->can_manage_staff];
            $target->update(['role' => $input['role'], 'can_manage_staff' => $input['role'] === 'STORE_MANAGER' && $target->can_manage_staff]);
            DB::table('vendor_memberships')->where('id', $id)->increment('lock_version');
            DB::table('users')->where('id', $target->user_id)->update(['name' => $input['full_name'], 'updated_at' => now()]);
            DB::table('users')->where('id', $target->user_id)->increment('lock_version');
            DB::table('user_profiles')->where('user_id', $target->user_id)->update(['full_name' => $input['full_name'], 'updated_at' => now()]);
            foreach (AuthSession::query()->where('user_id', $target->user_id)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'MEMBERSHIP_CHANGED');
            }
            $this->audit->account($request, 'VENDOR_STAFF_UPDATED', 'VENDOR_MEMBERSHIP', $id, $before, ['role' => $input['role'], 'can_manage_staff' => $target->can_manage_staff, 'name_changed' => $user?->name !== $input['full_name']]);
            $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $scope['organization_id'])->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.email', 'u.public_id']);
            if ($owner !== null) {
                $this->accounts->notice($owner->email, $owner->public_id, 'A Vendor team member was updated. Review Team Accounts.');
            }
        });
    }

    public function disputes(Request $request, bool $enabled, int $version): void
    {
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $enabled, $version): void {
            $organizationId = $request->attributes->get('account_scope')['organization_id'];
            $scope = $this->authority->lock($request, $organizationId);
            $org = DB::table('vendor_organizations')->where('id', $organizationId)->first();
            if ($scope['role'] !== 'OWNER') {
                throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner may change staff dispute access.', 403);
            }
            if ($org === null || (int) $org->lock_version !== $version) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Store settings changed. Refresh before trying again.', 409);
            }
            DB::table('vendor_organizations')->where('id', $org->id)->update(['staff_disputes_enabled' => $enabled, 'lock_version' => $version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_STAFF_DISPUTES_CHANGED', 'VENDOR_ORGANIZATION', $org->id, ['enabled' => (bool) $org->staff_disputes_enabled], ['enabled' => $enabled]);
        });
    }
}
