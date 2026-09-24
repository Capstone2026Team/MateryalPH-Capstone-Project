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

            if ($user->account_type === 'VENDOR') {
                $organizationIds = DB::table('vendor_memberships')
                    ->where('user_id', $user->getKey())
                    ->where('role', 'OWNER')
                    ->where('status', 'ACTIVE')
                    ->pluck('vendor_organization_id');

                DB::table('vendor_organizations')
                    ->whereIn('id', $organizationIds->all())
                    ->whereNull('store_email')
                    ->whereNull('pending_store_email')
                    ->update([
                        'store_email' => mb_strtolower((string) $user->email),
                        'store_email_verified_at' => now(),
                        'updated_at' => now(),
                    ]);
            }

            return $user;
        });
    }
}
