<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ManageAccount;
use App\Domain\Identity\TokenSessionService;
use App\Models\AuthSession;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class DeleteVendorTeamRecords
{
    public function __construct(
        private readonly CurrentVendorTeamAuthority $authority,
        private readonly RecentAuthentication $recent,
        private readonly AccountAgreements $agreements,
        private readonly AuditRecorder $audit,
        private readonly TokenSessionService $sessions,
        private readonly ManageAccount $accounts,
    ) {}

    public function membership(Request $request, string $id, int $version): void
    {
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $id, $version): void {
            $organization = $this->owner($request);
            $member = DB::table('vendor_memberships')->where('id', $id)->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            if ($member === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This team account is unavailable.', 404);
            }
            if ($member->role === 'OWNER' || (string) $member->user_id === (string) $request->user()->getKey()) {
                throw new AuthenticationException('PERMISSION_DENIED', 'The Owner account cannot be deleted through Team Accounts.', 403);
            }
            if ($member->deleted_at !== null) {
                return;
            }
            $this->version((int) $member->lock_version, $version);
            if ($member->status !== 'DEACTIVATED') {
                throw new AuthenticationException('TEAM_ACCOUNT_NOT_DEACTIVATED', 'Deactivate this team account before deleting it.', 409);
            }
            DB::table('users')->where('id', $member->user_id)->lockForUpdate()->first();
            DB::table('vendor_memberships')->where('id', $id)->update(['deleted_at' => now(), 'can_manage_staff' => false, 'lock_version' => $version + 1, 'updated_at' => now()]);
            foreach (AuthSession::query()->where('user_id', $member->user_id)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'MEMBERSHIP_DELETED');
            }
            $this->audit->account($request, 'VENDOR_MEMBERSHIP_DELETED', 'VENDOR_MEMBERSHIP', $id, ['status' => $member->status, 'role' => $member->role], ['deleted' => true]);
            $this->accounts->notice($request->user()->email, $request->user()->public_id, 'A deactivated team account was deleted. Its work history remains available.');
        });
    }

    public function invitation(Request $request, string $id, int $version): void
    {
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $id, $version): void {
            $organization = $this->owner($request);
            $invitation = DB::table('vendor_invitations')->where('id', $id)->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            if ($invitation === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This invitation is unavailable.', 404);
            }
            if ($invitation->deleted_at !== null) {
                return;
            }
            $this->version((int) $invitation->lock_version, $version);
            $accountDeleted = $invitation->accepted_membership_id !== null && DB::table('vendor_memberships')
                ->where('id', $invitation->accepted_membership_id)->where('vendor_organization_id', $organization)->whereNotNull('deleted_at')->exists();
            $expired = $invitation->accepted_at === null && now()->greaterThanOrEqualTo($invitation->expires_at);
            if (! $expired && ! $accountDeleted) {
                throw new AuthenticationException('TEAM_INVITATION_NOT_DELETABLE', 'An invitation can be deleted after it expires or its accepted team account is deleted.', 409);
            }
            DB::table('vendor_invitations')->where('id', $id)->update(['deleted_at' => now(), 'lock_version' => $version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_INVITATION_DELETED', 'VENDOR_INVITATION', $id, after: ['deleted' => true, 'reason' => $accountDeleted ? 'TEAM_ACCOUNT_DELETED' : 'EXPIRED']);
        });
    }

    private function owner(Request $request): string
    {
        $organization = $request->attributes->get('account_scope')['organization_id'];
        $scope = $this->authority->lock($request, $organization);
        if ($scope['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner may delete team accounts or invitations.', 403);
        }

        return $organization;
    }

    private function version(int $current, int $expected): void
    {
        if ($current !== $expected) {
            throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This team record changed. Refresh before trying again.', 409);
        }
    }
}
