<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;

final class AuthenticateAccount
{
    public function __construct(private readonly AccountPassword $passwords) {}

    public function handle(string $email, string $password, string $requestedPortal): User
    {
        $user = User::query()->whereRaw('LOWER(email) = ?', [mb_strtolower(trim($email))])->first();

        if ($user === null || ! $this->passwords->matches($password, $user->password)) {
            throw new AuthenticationException('INVALID_CREDENTIALS', 'The email or password is incorrect.', 401);
        }
        $this->assertEligible($user, $requestedPortal);

        return $user;
    }

    public function recheck(User $authenticated, string $requestedPortal): User
    {
        $current = User::query()->find($authenticated->getKey());
        if ($current === null || ! hash_equals((string) $authenticated->password, (string) $current->password)) {
            throw new AuthenticationException('INVALID_CREDENTIALS', 'The email or password is incorrect.', 401);
        }
        $this->assertEligible($current, $requestedPortal);

        return $current;
    }

    public function upgradePassword(User $user, #[\SensitiveParameter] string $password): bool
    {
        $original = $user->password;
        $replacement = $this->passwords->replacementHash($password, $original);
        if ($replacement === null) {
            return false;
        }
        // A password reset during provider verification or hashing must never be overwritten.
        $updated = User::query()->whereKey($user->getKey())->where('password', $original)->update(['password' => $replacement]);
        if ($updated !== 1) {
            throw new AuthenticationException('INVALID_CREDENTIALS', 'The email or password is incorrect.', 401);
        }
        $user->forceFill(['password' => $replacement])->syncOriginalAttribute('password');

        return true;
    }

    private function assertEligible(User $user, string $requestedPortal): void
    {
        if ($user->account_status !== 'ACTIVE' && ! app(MfaChallengeService::class)->pendingAdminSetup($user)) {
            throw new AuthenticationException('ACCOUNT_NOT_ACTIVE', 'Verify your account or contact support before signing in.', 403);
        }
        if ($user->account_type !== $requestedPortal) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot sign in to the selected portal.', 403);
        }
    }

    public function markAuthenticated(User $user): void
    {
        $user->forceFill(['last_authenticated_at' => now()])->save();
    }
}
