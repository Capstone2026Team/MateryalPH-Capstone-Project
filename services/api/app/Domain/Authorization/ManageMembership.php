<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ManageAccount;
use App\Domain\Identity\TokenSessionService;
use App\Models\AuthSession;
use App\Models\VendorMembership;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class ManageMembership
{
    public function __construct(private readonly RecentAuthentication $recent, private readonly MembershipPolicy $policy, private readonly AuditRecorder $audit, private readonly TokenSessionService $sessions, private readonly ManageAccount $accounts, private readonly AccountAgreements $agreements) {}

    public function change(Request $request, string $id, string $field, bool|string $value): void
    {
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        DB::transaction(function () use ($request, $id, $field, $value): void {
            $organization = $request->attributes->get('account_scope')['organization_id'];
            $target = VendorMembership::query()->whereKey($id)->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            if ($target === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The membership is unavailable.', 404);
            }
            $allowed = $field === 'can_manage_staff' ? $this->policy->delegate($request->user(), $target) : $this->policy->manage($request->user(), $target);
            if (! $allowed) {
                throw new AuthenticationException('PERMISSION_DENIED', 'You cannot change this membership.', 403);
            }
            $before = [$field => $target->getAttribute($field)];
            $target->update([$field => $value]);
            DB::table('vendor_memberships')->where('id', $id)->increment('lock_version');
            foreach (AuthSession::query()->where('user_id', $target->user_id)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'MEMBERSHIP_CHANGED');
            }
            $this->audit->account($request, 'VENDOR_MEMBERSHIP_CHANGED', 'VENDOR_MEMBERSHIP', $id, $before, [$field => $value]);
            $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.email', 'u.public_id']);
            if ($owner !== null) {
                $this->accounts->notice($owner->email, $owner->public_id, 'A Vendor membership was changed. Review your account security audit.');
            }
        });
    }
}
