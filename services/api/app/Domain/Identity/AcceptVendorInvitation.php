<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Vendors\OnboardingRequirementResolver;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\VendorMembership;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rules\Password;

final class AcceptVendorInvitation
{
    public function __construct(private readonly AuditRecorder $audit, private readonly EmailOtpService $otp) {}

    public function assertInvitationAvailable(string $token, string $email): void
    {
        // Check the recipient before a provider call or email security challenge.
        // Acceptance rechecks current invitation and inviter authority under locks.
        $available = DB::table('vendor_invitations')
            ->where('token_hash', hash_hmac('sha256', $token, (string) config('app.key')))
            ->where('normalized_email', mb_strtolower(trim($email)))
            ->whereNull('deleted_at')->whereNull('accepted_at')->whereNull('revoked_at')
            ->where('expires_at', '>', now())
            ->exists();
        if (! $available) {
            throw new AuthenticationException('VENDOR_INVITATION_INVALID', 'This invitation is invalid or expired.', 422);
        }
    }

    public function handle(Request $request, string $token, string $email, string $name, string $password): void
    {
        DB::transaction(function () use ($request, $token, $email, $name, $password): void {
            $tokenHash = hash_hmac('sha256', $token, (string) config('app.key'));
            $candidate = DB::table('vendor_invitations')->where('token_hash', $tokenHash)->whereNull('deleted_at')->first(['vendor_organization_id', 'invited_by_user_id']);
            if ($candidate === null) {
                throw new AuthenticationException('VENDOR_INVITATION_INVALID', 'This invitation is invalid or expired.', 422);
            }
            $organization = DB::table('vendor_organizations')->where('id', $candidate->vendor_organization_id)->lockForUpdate()->first();
            $inviterUser = User::query()->whereKey($candidate->invited_by_user_id)->lockForUpdate()->first();
            $inviter = DB::table('vendor_memberships')->where('user_id', $candidate->invited_by_user_id)
                ->where('vendor_organization_id', $candidate->vendor_organization_id)->whereNull('deleted_at')->lockForUpdate()->first();
            $invitation = DB::table('vendor_invitations')->where('token_hash', $tokenHash)->whereNull('deleted_at')->lockForUpdate()->first();
            $email = mb_strtolower(trim($email));
            if ($invitation === null || $invitation->accepted_at !== null || $invitation->revoked_at !== null
                || now()->greaterThanOrEqualTo($invitation->expires_at) || $invitation->normalized_email !== $email
                || ! in_array($invitation->role, ['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'], true)
                || $organization === null || $organization->account_status !== 'ACTIVE'
                || $invitation->vendor_organization_id !== $candidate->vendor_organization_id
                || $invitation->invited_by_user_id !== $candidate->invited_by_user_id) {
                throw new AuthenticationException('VENDOR_INVITATION_INVALID', 'This invitation is invalid or expired.', 422);
            }
            if ($inviter === null || $inviter->status !== 'ACTIVE' || $inviterUser === null || $inviterUser->account_type !== 'VENDOR' || $inviterUser->account_status !== 'ACTIVE'
                || ($inviter->role !== 'OWNER' && ! ($inviter->role === 'STORE_MANAGER' && $inviter->can_manage_staff && $invitation->role !== 'STORE_MANAGER'))
                || ($invitation->can_manage_staff && ($inviter->role !== 'OWNER' || $invitation->role !== 'STORE_MANAGER'))) {
                throw new AuthenticationException('VENDOR_INVITATION_INVALID', 'This invitation is invalid or expired.', 422);
            }
            $user = User::query()->whereRaw('LOWER(email) = ?', [$email])->lockForUpdate()->first();
            if ($user !== null) {
                if ($user->account_type !== 'VENDOR' || ! in_array($user->account_status, ['ACTIVE', 'PENDING_VERIFICATION'], true) || ! Hash::check($password, $user->password)
                    || VendorMembership::query()->where('user_id', $user->getKey())->whereNull('deleted_at')->exists()) {
                    throw new AuthenticationException('VENDOR_INVITATION_INVALID', 'This invitation cannot be accepted with these details.', 422);
                }
                if ($user->account_status === 'PENDING_VERIFICATION') {
                    $this->otp->issue($email, 'EMAIL_VERIFICATION', $user);
                }
            } else {
                Validator::make(['password' => $password], ['password' => [Password::min(14)->mixedCase()->numbers()]])->validate();
                $user = User::query()->create(['name' => trim($name), 'email' => $email, 'password' => Hash::make($password), 'account_type' => 'VENDOR', 'account_status' => 'PENDING_VERIFICATION']);
                UserProfile::query()->create(['user_id' => $user->getKey(), 'full_name' => $user->name, 'locale' => 'en']);
                $this->otp->issue($email, 'EMAIL_VERIFICATION', $user);
            }
            $membership = VendorMembership::query()->create([
                'user_id' => $user->getKey(), 'vendor_organization_id' => $invitation->vendor_organization_id, 'role' => $invitation->role,
                'can_manage_staff' => (bool) $invitation->can_manage_staff, 'status' => 'ACTIVE', 'activated_at' => now(),
            ]);
            DB::table('vendor_invitations')->where('id', $invitation->id)->update(['accepted_at' => now(), 'accepted_membership_id' => $membership->getKey(), 'lock_version' => $invitation->lock_version + 1, 'updated_at' => now()]);
            $request->setUserResolver(fn () => $user);
            $request->attributes->set('account_scope', ['role' => $invitation->role, 'organization_id' => $invitation->vendor_organization_id]);
            $this->audit->account($request, 'VENDOR_INVITATION_ACCEPTED', 'VENDOR_MEMBERSHIP', (string) $membership->getKey(), after: ['invitation_id' => $invitation->id, 'inviter_id' => $invitation->invited_by_user_id]);
            $this->audit->account($request, 'VENDOR_MEMBERSHIP_ACTIVATED', 'VENDOR_MEMBERSHIP', (string) $membership->getKey(), after: ['role' => $invitation->role, 'status' => 'ACTIVE']);
            if ($invitation->role === 'FULFILLMENT') {
                app(OnboardingRequirementResolver::class)->synchronize((string) $invitation->vendor_organization_id);
            }
        });
    }
}
