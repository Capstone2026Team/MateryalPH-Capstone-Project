<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use Illuminate\Contracts\Hashing\Hasher;

final class AccountPassword
{
    public function __construct(private readonly Hasher $hasher) {}

    public function matches(#[\SensitiveParameter] string $password, ?string $hash): bool
    {
        // Imported Argon2i hashes remain verifiable while new hashes use the configured Argon2id driver.
        return $hash !== null && in_array(password_get_info($hash)['algoName'], ['argon2i', 'argon2id'], true)
            && password_verify($password, $hash);
    }

    public function replacementHash(#[\SensitiveParameter] string $password, string $hash): ?string
    {
        if (! $this->matches($password, $hash)) {
            throw new AuthenticationException('INVALID_CREDENTIALS', 'The email or password is incorrect.', 401);
        }

        return $this->hasher->needsRehash($hash) ? $this->hasher->make($password) : null;
    }
}
