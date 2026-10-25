<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\AuthSession;
use App\Models\BotRiskChallenge;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use SensitiveParameter;

final class RecoverWebPassword
{
    public function __construct(
        private readonly EmailOtpService $otps,
        private readonly TotpService $totp,
        private readonly TokenSessionService $sessions,
        private readonly AuditRecorder $audit,
        private readonly ManageAccount $accounts,
        private readonly BotProtectionService $bots,
        private readonly MfaChallengeService $mfa,
    ) {}

    /** @return array{token: string, expires_in: int, recovery_codes: list<string>|null} */
    public function verify(Request $request, string $portal, string $email, #[SensitiveParameter] ?string $code, #[SensitiveParameter] ?string $recoveryCode, ?string $challengeId = null): array
    {
        $email = mb_strtolower(trim($email));
        $limitKey = 'web-password-recovery:'.$portal.':'.hash_hmac('sha256', $email, (string) config('app.key'));
        if (RateLimiter::tooManyAttempts($limitKey, 5)) {
            throw new AuthenticationException('PASSWORD_RECOVERY_THROTTLED', 'Too many verification attempts. Try again later.', 429);
        }

        $result = DB::transaction(function () use ($request, $portal, $email, $code, $recoveryCode, $challengeId): array|AuthenticationException {
            $user = User::query()->whereRaw('LOWER(email) = ?', [$email])->where('account_type', $portal)->lockForUpdate()->first();
            if ($user === null || ! $this->eligible($user)) {
                return $this->invalidCode();
            }

            $replacement = null;
            if ($recoveryCode !== null) {
                if (! $this->totp->hasConfirmedFactor($user)) {
                    return $this->invalidCode();
                }
                $replacement = $this->totp->consumeRecoveryCode($user, $recoveryCode);
                if ($replacement === null) {
                    return $this->invalidCode();
                }
                $this->revokeSessions($user, 'MFA_RECOVERY');
                $this->accounts->notice($user->email, $user->public_id, 'A recovery code was used to recover your MateryalPH password. All sessions were signed out and your recovery codes were replaced.');
            } else {
                try {
                    if ($challengeId !== null) {
                        $challenge = BotRiskChallenge::query()->lockForUpdate()->find($challengeId);
                        if ($challenge === null || $challenge->action !== strtolower($portal).'_password_recovery' || $challenge->platform !== 'WEB') {
                            return $this->invalidCode();
                        }
                        $this->bots->verifyChallenge($request, $challengeId, $email, (string) $code, $portal);
                        $challenge->update(['consumed_at' => now()]);
                    } else {
                        $this->otps->verify($email, 'PASSWORD_RESET', (string) $code);
                    }
                } catch (AuthenticationException $exception) {
                    // Return the failure so OTP attempt accounting commits.
                    return $exception;
                }
            }

            $token = bin2hex(random_bytes(32));
            $expiresIn = (int) config('materyalph.auth.otp_ttl_minutes', 10) * 60;
            DB::table('password_reset_tokens')->updateOrInsert(['email' => $email], [
                'token' => $this->proofHash($token, $user), 'created_at' => now(),
            ]);
            $this->audit->record($request, 'PASSWORD_RECOVERY_VERIFIED', true, $user, ['method' => $recoveryCode !== null ? 'RECOVERY_CODE' : 'EMAIL_OTP']);

            return ['token' => $token, 'expires_in' => $expiresIn, 'recovery_codes' => $replacement];
        });

        if ($result instanceof AuthenticationException) {
            $attempts = RateLimiter::hit($limitKey, 15 * 60);
            $this->audit->record($request, 'PASSWORD_RECOVERY_VERIFIED', false, safeContext: ['email' => $email]);
            if ($attempts >= 5) {
                throw new AuthenticationException('PASSWORD_RECOVERY_THROTTLED', 'Too many verification attempts. Try again later.', 429);
            }
            throw $this->invalidCode();
        }
        RateLimiter::clear($limitKey);

        return $result;
    }

    public function reset(Request $request, string $portal, string $email, #[SensitiveParameter] string $token, #[SensitiveParameter] string $password): void
    {
        $email = mb_strtolower(trim($email));
        DB::transaction(function () use ($request, $portal, $email, $token, $password): void {
            $user = User::query()->whereRaw('LOWER(email) = ?', [$email])->where('account_type', $portal)->lockForUpdate()->first();
            $proof = DB::table('password_reset_tokens')->where('email', $email)->lockForUpdate()->first();
            if ($user === null || ! $this->eligible($user) || $proof === null || $token === ''
                || $proof->created_at === null
                || CarbonImmutable::parse($proof->created_at)->addMinutes((int) config('materyalph.auth.otp_ttl_minutes', 10))->isPast()
                || ! hash_equals((string) $proof->token, $this->proofHash($token, $user))) {
                throw new AuthenticationException('PASSWORD_RECOVERY_EXPIRED', 'Verify your email code or a recovery code again before setting a password.');
            }

            $user->forceFill(['password' => Hash::make($password)])->save();
            DB::table('password_reset_tokens')->where('email', $email)->delete();
            $this->revokeSessions($user, 'PASSWORD_RESET');
            $this->audit->record($request, 'PASSWORD_RESET', true, $user);
            $this->accounts->notice($user->email, $user->public_id, 'Your MateryalPH password was reset. All sessions were signed out. Contact support if you did not make this change.');
        });
    }

    private function revokeSessions(User $user, string $reason): void
    {
        foreach (AuthSession::query()->where('user_id', $user->getKey())->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
            $this->sessions->revoke($session, $reason);
        }
    }

    private function eligible(User $user): bool
    {
        return $user->account_status === 'ACTIVE' || $this->mfa->pendingAdminSetup($user)
            || ($user->account_type === 'VENDOR' && $user->account_status === 'PENDING_VERIFICATION');
    }

    private function proofHash(#[SensitiveParameter] string $token, User $user): string
    {
        return hash_hmac('sha256', $user->account_type.'|'.$user->getKey().'|'.$user->password.'|'.$token, (string) config('app.key'));
    }

    private function invalidCode(): AuthenticationException
    {
        return new AuthenticationException('PASSWORD_RECOVERY_CODE_INVALID', 'The code is invalid or expired. Check it or request another email code.');
    }
}
