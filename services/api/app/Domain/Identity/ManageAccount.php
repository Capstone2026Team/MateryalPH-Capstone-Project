<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Operations\OutboxPublisher;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

final class ManageAccount
{
    public function __construct(private readonly RecentAuthentication $recent, private readonly TokenSessionService $sessions, private readonly AuditRecorder $audit, private readonly EmailOtpService $otp, private readonly OutboxPublisher $outbox) {}

    /** @param array<string, mixed> $input */
    public function updateProfile(Request $request, array $input): User
    {
        return DB::transaction(function () use ($request, $input): User {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            if ((int) $user->lock_version !== (int) $input['lock_version']) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Your profile changed. Reload before saving.', 409);
            }
            if ($user->account_type !== 'BUYER' && (isset($input['buyer_type']) || array_key_exists('company_name', $input))) {
                throw new AuthenticationException('PROFILE_FIELD_NOT_ALLOWED', 'These fields are not available for this account.', 422);
            }
            $user->forceFill(['name' => trim($input['full_name']), 'lock_version' => $user->lock_version + 1])->save();
            UserProfile::query()->updateOrCreate(['user_id' => $user->getKey()], ['full_name' => $user->name]);
            $buyer = array_intersect_key($input, ['buyer_type' => true, 'company_name' => true]);
            if ($buyer !== []) {
                DB::table('buyer_profiles')->where('user_id', $user->getKey())->update($buyer + ['updated_at' => now()]);
            }
            $this->audit->account($request, 'PROFILE_UPDATED', 'USER', $user->public_id, after: ['fields' => array_keys($input), 'lock_version' => $user->lock_version]);

            return $user;
        });
    }

    public function revokeSessions(Request $request, string $scope, ?string $id = null): void
    {
        DB::transaction(function () use ($request, $scope, $id): void {
            $current = $this->recent->session($request);
            $query = AuthSession::query()->where('user_id', $request->user()->getKey());
            if ($id !== null) {
                $query->whereKey($id);
                if (! (clone $query)->exists()) {
                    throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The session is unavailable.', 404);
                }
            } elseif ($scope === 'OTHERS') {
                $query->whereKeyNot($current->getKey());
            }
            foreach ($query->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'USER_REVOKED');
                $this->audit->account($request, 'SESSION_REVOKED', 'AUTH_SESSION', (string) $session->getKey());
            }
        });
    }

    public function changePassword(Request $request, string $password): void
    {
        $this->recent->require($request);
        DB::transaction(function () use ($request, $password): void {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            $user->forceFill(['password' => Hash::make($password)])->save();
            $this->revokeSessions($request, $user->account_type === 'BUYER' ? 'OTHERS' : 'ALL');
            $this->recent->session($request)->update(['reauthenticated_at' => null, 'reauthentication_method' => null]);
            $this->audit->account($request, 'PASSWORD_CHANGED', 'USER', $user->public_id);
            $this->notice($user->email, $user->public_id, 'Your MateryalPH password was changed.');
        });
    }

    /** @return array{id: string, expires_at: string} */
    public function startEmailChange(Request $request, string $email): array
    {
        $this->recent->require($request);
        $email = mb_strtolower(trim($email));

        return DB::transaction(function () use ($request, $email): array {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            if (User::query()->whereRaw('LOWER(email) = ?', [$email])->exists()) {
                throw new AuthenticationException('EMAIL_CHANGE_UNAVAILABLE', 'This email cannot be used for this change.', 422);
            }
            DB::table('account_email_changes')->where('user_id', $user->getKey())->whereNull('completed_at')->update(['invalidated_at' => now()]);
            $otp = $this->otp->issue($email, 'PRIMARY_EMAIL_CHANGE', $user);
            $id = (string) Str::uuid7();
            DB::table('account_email_changes')->insert([
                'id' => $id, 'user_id' => $user->getKey(), 'auth_session_id' => $this->recent->session($request)->getKey(),
                'normalized_email' => $email, 'email_otp_id' => $otp->getKey(), 'expires_at' => $otp->expires_at, 'created_at' => now(), 'updated_at' => now(),
            ]);
            $this->audit->account($request, 'EMAIL_CHANGE_REQUESTED', 'USER', $user->public_id);

            return ['id' => $id, 'expires_at' => $otp->expires_at->toIso8601String()];
        });
    }

    public function confirmEmailChange(Request $request, string $id, string $code): void
    {
        $this->recent->require($request);
        $change = DB::table('account_email_changes')->where('id', $id)->where('user_id', $request->user()->getKey())
            ->where('auth_session_id', $this->recent->session($request)->getKey())->whereNull('completed_at')->whereNull('invalidated_at')->where('expires_at', '>', now())->first();
        if ($change === null) {
            throw new AuthenticationException('EMAIL_CHANGE_INVALID', 'The email change is unavailable or expired.', 404);
        }
        // Verify outside the final transaction so failed attempt counters are committed.
        $otp = $this->otp->verifyForRequest($change->normalized_email, 'PRIMARY_EMAIL_CHANGE', $code, $change->email_otp_id);
        if ((string) $otp->getKey() !== $change->email_otp_id || (string) $otp->user_id !== (string) $request->user()->getKey()) {
            throw new AuthenticationException('EMAIL_CHANGE_INVALID', 'The email change is unavailable or expired.', 422);
        }
        DB::transaction(function () use ($request, $change): void {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            $locked = DB::table('account_email_changes')->where('id', $change->id)->lockForUpdate()->first();
            if ($locked->completed_at !== null || $locked->invalidated_at !== null || now()->greaterThanOrEqualTo($locked->expires_at) || User::query()->whereRaw('LOWER(email) = ?', [$change->normalized_email])->exists()) {
                throw new AuthenticationException('EMAIL_CHANGE_UNAVAILABLE', 'This email change can no longer be completed.', 409);
            }
            $previousEmail = $user->email;
            try {
                $user->forceFill(['email' => $change->normalized_email, 'email_verified_at' => now(), 'lock_version' => $user->lock_version + 1])->save();
            } catch (UniqueConstraintViolationException) {
                throw new AuthenticationException('EMAIL_CHANGE_UNAVAILABLE', 'This email change can no longer be completed.', 409);
            }
            DB::table('account_email_changes')->where('id', $change->id)->update(['completed_at' => now(), 'updated_at' => now()]);
            $this->revokeSessions($request, 'ALL');
            $this->audit->account($request, 'PRIMARY_EMAIL_CHANGED', 'USER', $user->public_id);
            $this->notice($previousEmail, $user->public_id, 'Your MateryalPH primary email was changed. Contact support if you did not make this change.');
        });
    }

    public function notice(string $recipient, string $id, string $message): void
    {
        $this->outbox->publish('ACCOUNT_SECURITY_NOTICE', 'USER', $id, ['recipient' => $recipient, 'message' => $message]);
    }
}
