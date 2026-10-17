<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\RecentAuthentication;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Optional authenticator-app TOTP for Buyers (Buyer Workflow: "The Buyer may later enroll a stronger authenticator").
 * Once confirmed, every Buyer sign-in — password or Google — completes a TOTP or recovery-code challenge. Enrolling and
 * turning it off are security-factor changes, so both require session-bound recent authentication (System Workflow).
 */
final class ManageBuyerTwoFactor
{
    public const ISSUER = 'MateryalPH';

    public function __construct(
        private readonly RecentAuthentication $recent,
        private readonly TotpService $totp,
        private readonly ManageAccount $accounts,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array{secret: string, provisioning_uri: string, issuer: string, account_name: string} */
    public function start(Request $request): array
    {
        $this->recent->require($request);
        $user = $request->user();
        // Reopening setup before confirmation returns the same pending secret, so an app already scanned keeps working.
        $enrollment = $this->totp->startEnrollment($user);
        $this->audit->account($request, 'MFA_ENROLLMENT_STARTED', 'USER', $user->public_id);

        return $enrollment + ['issuer' => self::ISSUER, 'account_name' => $user->email];
    }

    /** @return list<string> Recovery codes, shown once. */
    public function confirm(Request $request, string $code): array
    {
        $this->recent->require($request);

        return DB::transaction(function () use ($request, $code): array {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            try {
                $codes = $this->totp->confirm($user, $code);
            } catch (AuthenticationException $exception) {
                // A wrong setup code is a validation failure, never a session failure (401 would sign the Buyer out).
                throw $exception->errorCode === 'MFA_CODE_INVALID'
                    ? new AuthenticationException('MFA_CODE_INVALID', 'That code did not match. Check the time on your phone and enter the newest 6-digit code.', 422)
                    : $exception;
            }
            // Other devices signed in without the new factor; they must sign in again and pass it.
            $this->accounts->revokeSessions($request, 'OTHERS');
            $this->audit->account($request, 'MFA_ENROLLMENT_CONFIRMED', 'USER', $user->public_id);
            $this->accounts->notice($user->email, $user->public_id, 'Two-factor authentication was turned on for your MateryalPH account. Other devices were signed out.');

            return $codes;
        });
    }

    public function disable(Request $request, ?string $code, ?string $recoveryCode): void
    {
        $this->recent->require($request);
        $user = $request->user();
        if (! $this->totp->hasConfirmedFactor($user)) {
            throw new AuthenticationException('MFA_NOT_ENROLLED', 'Two-factor authentication is already off.', 409);
        }
        // Possession is proven outside the final transaction so the replay counter advance is committed even on failure.
        $proven = $code !== null ? $this->totp->verify($user, $code) : $this->totp->hasUnusedRecoveryCode($user, (string) $recoveryCode);
        if (! $proven) {
            $this->audit->account($request, 'MFA_DISABLE_FAILED', 'USER', $user->public_id, succeeded: false);
            throw new AuthenticationException('MFA_CODE_INVALID', $code !== null
                ? 'That authenticator code is incorrect or was already used. Enter the newest 6-digit code.'
                : 'That recovery code is incorrect or was already used.', 422);
        }

        DB::transaction(function () use ($request): void {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            $this->totp->revoke($user);
            // The step-up proof is spent on this change; another security change needs a new verification.
            $this->recent->session($request)->update(['reauthenticated_at' => null, 'reauthentication_method' => null]);
            $this->audit->account($request, 'MFA_DISABLED', 'USER', $user->public_id);
            $this->accounts->notice($user->email, $user->public_id, 'Two-factor authentication was turned off for your MateryalPH account. Contact support if you did not make this change.');
        });
    }
}
