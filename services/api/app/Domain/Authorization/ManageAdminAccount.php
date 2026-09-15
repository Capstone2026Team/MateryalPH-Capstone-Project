<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\IssueAdminInvitation;
use App\Domain\Identity\ManageAccount;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class ManageAdminAccount
{
    public function __construct(private readonly AccountAccess $access, private readonly RecentAuthentication $recent, private readonly AccountAgreements $agreements, private readonly TokenSessionService $sessions, private readonly AuditRecorder $audit, private readonly ManageAccount $accounts, private readonly TotpService $totp) {}

    public function authorize(Request $request): void
    {
        $scope = $this->access->resolve($request->user()->refresh());
        if ($scope['role'] !== 'ADMIN_SUPERADMIN' || ! in_array('admin.manage_accounts', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot manage Admin accounts.', 403);
        }
    }

    /** @param array{lock_version: int, reason: string, status?: string, role_id?: string} $input */
    public function change(Request $request, string $publicId, array $input): void
    {
        $this->authorize($request);
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $publicId, $input): void {
            // Serialize administrators before target changes to avoid concurrent privilege changes.
            DB::table('admin_memberships')->orderBy('id')->lockForUpdate()->get();
            $this->authorize($request);
            $this->recent->require($request);
            $user = User::query()->where('public_id', $publicId)->where('account_type', 'ADMIN')->lockForUpdate()->first();
            $member = $user === null ? null : DB::table('admin_memberships')->where('user_id', $user->getKey())->first();
            if ($user === null || $member === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The Admin account is unavailable.', 404);
            }
            $role = DB::table('platform_roles')->where('id', $member->platform_role_id)->value('code');
            if ($user->getKey() === $request->user()->getKey() || $role === 'ADMIN_SUPERADMIN') {
                throw new AuthenticationException('PERMISSION_DENIED', 'This account cannot be changed through staff administration.', 403);
            }
            if ((int) $user->lock_version !== $input['lock_version']) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Reload this Admin account before changing it.', 409);
            }
            $before = ['role_id' => $member->platform_role_id, 'status' => $member->status, 'lock_version' => $user->lock_version];
            $changes = ['updated_at' => now()];
            if (isset($input['role_id'])) {
                if (! DB::table('platform_roles')->where('id', $input['role_id'])->where('platform', 'ADMIN')->whereIn('code', IssueAdminInvitation::ROLES)->exists()) {
                    throw new AuthenticationException('ROLE_UNAVAILABLE', 'This role cannot be assigned.', 422);
                }
                $changes['platform_role_id'] = $input['role_id'];
            }
            if (isset($input['status'])) {
                if ($input['status'] === 'ACTIVE' && ($user->email_verified_at === null || ! $this->totp->hasConfirmedFactor($user))) {
                    throw new AuthenticationException('ACCOUNT_SETUP_INCOMPLETE', 'Email verification and authenticator setup must be completed first.', 409);
                }
                $changes['status'] = $input['status'];
                $changes['deactivated_at'] = $input['status'] === 'DEACTIVATED' ? now() : null;
                $user->account_status = $input['status'];
            }
            $user->lock_version++;
            $user->save();
            DB::table('admin_memberships')->where('id', $member->id)->update($changes);
            foreach (AuthSession::query()->where('user_id', $user->getKey())->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'ADMIN_ACCESS_CHANGED');
            }
            $this->audit->account($request, 'ADMIN_ACCOUNT_CHANGED', 'USER', $publicId, $before, ['role_id' => $input['role_id'] ?? $member->platform_role_id, 'status' => $input['status'] ?? $member->status, 'lock_version' => $user->lock_version, 'reason' => $input['reason']]);
            $this->accounts->notice($user->email, $publicId, 'Your Admin access was changed. Existing sessions have been signed out.');
        });
    }
}
