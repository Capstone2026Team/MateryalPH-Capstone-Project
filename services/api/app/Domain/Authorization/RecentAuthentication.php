<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\MfaChallengeService;
use App\Domain\Identity\TotpService;
use App\Models\AuthSession;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

final class RecentAuthentication
{
    public function __construct(private readonly MfaChallengeService $mfa, private readonly TotpService $totp, private readonly AuditRecorder $audit, private readonly EmailOtpService $otp) {}

    public function session(Request $request): AuthSession
    {
        $session = $request->attributes->get('auth_session');
        if (! $session instanceof AuthSession) {
            throw new AuthenticationException('UNAUTHENTICATED', 'Sign in to continue.', 401);
        }

        return $session;
    }

    public function sendEmail(Request $request): void
    {
        $session = $this->session($request);
        $user = $request->user();
        $otp = $this->otp->issue($user->email, 'ACCOUNT_REAUTHENTICATION', $user);
        $session->update(['reauthentication_email_otp_id' => $otp->getKey()]);
    }

    public function confirm(Request $request, ?string $password, ?string $code, ?string $emailCode = null): void
    {
        $user = $request->user();
        $privileged = $this->mfa->requiredFor($user);
        $verified = $password !== null && Hash::check($password, $user->password);
        $method = 'PASSWORD';
        if ($emailCode !== null && $this->session($request)->reauthentication_email_otp_id !== null) {
            $otp = $this->otp->verifyForRequest($user->email, 'ACCOUNT_REAUTHENTICATION', $emailCode, $this->session($request)->reauthentication_email_otp_id);
            $verified = (string) $otp->getKey() === $this->session($request)->reauthentication_email_otp_id && (string) $otp->user_id === (string) $user->getKey();
            $method = 'EMAIL';
        }
        if (! $verified || ($privileged && ! $this->totp->verify($user, $code ?? ''))) {
            $this->audit->account($request, 'REAUTHENTICATION_FAILED', 'AUTH_SESSION', (string) $this->session($request)->getKey(), succeeded: false);
            throw new AuthenticationException('REAUTHENTICATION_FAILED', 'The verification details are incorrect.', 422);
        }
        $this->session($request)->update(['reauthenticated_at' => now(), 'reauthentication_method' => $method.($privileged ? '_TOTP' : ''), 'reauthentication_email_otp_id' => null]);
        $this->audit->account($request, 'REAUTHENTICATION_SUCCEEDED', 'AUTH_SESSION', (string) $this->session($request)->getKey());
    }

    public function require(Request $request): void
    {
        $session = $this->session($request)->refresh();
        if ($session->revoked_at !== null || $session->expires_at->isPast() || $session->reauthenticated_at === null
            || $session->reauthenticated_at->addMinutes(15)->isPast()
            || ($this->mfa->requiredFor($request->user()) && ! in_array($session->reauthentication_method, ['PASSWORD_TOTP', 'EMAIL_TOTP'], true))) {
            throw new AuthenticationException('RECENT_AUTHENTICATION_REQUIRED', 'Verify your identity again to continue.', 403);
        }
    }
}
