<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Support\Facades\DB;

final class VerifyEmailAddress
{
    public function __construct(private readonly EmailOtpService $otps) {}

    /** @param list<string> $allowedAccountTypes */
    public function handle(string $email, string $code, array $allowedAccountTypes): User
    {
        $otp = $this->otps->verify($email, 'EMAIL_VERIFICATION', $code);

        return DB::transaction(function () use ($otp, $allowedAccountTypes): User {
            $user = User::query()->whereKey($otp->user_id)->lockForUpdate()->firstOrFail();
            if (! in_array($user->account_type, $allowedAccountTypes, true)) {
                throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
            }
            if (! in_array($user->account_status, ['PENDING_VERIFICATION', 'ACTIVE'], true)) {
                throw new AuthenticationException('ACCOUNT_NOT_ACTIVE', 'This account cannot be activated through email verification.', 403);
            }
            $user->forceFill([
                'email_verified_at' => now(),
                'account_status' => 'ACTIVE',
            ])->save();

            return $user;
        });
    }
}
