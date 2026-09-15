<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class CompleteAdminSetup
{
    public function __construct(private readonly TotpService $totp, private readonly AuditRecorder $audit) {}

    public function handle(User $user, Request $request): void
    {
        if ($user->account_type !== 'ADMIN' || $user->account_status !== 'PENDING_VERIFICATION') {
            return;
        }
        DB::transaction(function () use ($user, $request): void {
            $locked = User::query()->whereKey($user->getKey())->lockForUpdate()->firstOrFail();
            $member = DB::table('admin_memberships')->where('user_id', $user->getKey())->lockForUpdate()->first();
            if ($locked->account_status !== 'PENDING_VERIFICATION' || $locked->email_verified_at === null
                || $member === null || $member->status !== 'PENDING' || ! $this->totp->hasConfirmedFactor($locked)) {
                throw new AuthenticationException('ACCOUNT_SETUP_INCOMPLETE', 'Admin setup cannot be activated. Contact your administrator.', 403);
            }
            $locked->forceFill(['account_status' => 'ACTIVE'])->save();
            DB::table('admin_memberships')->where('id', $member->id)->update(['status' => 'ACTIVE', 'activated_at' => now(), 'updated_at' => now()]);
            $context = clone $request;
            $context->setUserResolver(fn () => $locked);
            $context->attributes->set('account_scope', ['role' => DB::table('platform_roles')->where('id', $member->platform_role_id)->value('code')]);
            $this->audit->account($context, 'ADMIN_ACCOUNT_ACTIVATED', 'USER', $locked->public_id, ['status' => 'PENDING_VERIFICATION'], ['status' => 'ACTIVE']);
            $user->refresh();
        });
    }
}
