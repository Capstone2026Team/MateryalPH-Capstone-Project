<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AccountPassword;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Hashing\Argon2IdHasher;
use PHPUnit\Framework\TestCase;

final class AccountPasswordTest extends TestCase
{
    private function passwords(): AccountPassword
    {
        return new AccountPassword(new Argon2IdHasher(['memory' => 1024, 'time' => 1, 'threads' => 1, 'verify' => true]));
    }

    public function test_imported_argon2i_password_is_verified_and_upgraded_to_argon2id(): void
    {
        $legacy = password_hash('Correct-password-123', PASSWORD_ARGON2I, ['memory_cost' => 1024, 'time_cost' => 1, 'threads' => 1]);
        $passwords = $this->passwords();

        self::assertTrue($passwords->matches('Correct-password-123', $legacy));
        self::assertFalse($passwords->matches('Incorrect-password-123', $legacy));
        $upgraded = $passwords->replacementHash('Correct-password-123', $legacy);
        self::assertNotNull($upgraded);
        self::assertSame('argon2id', password_get_info($upgraded)['algoName']);
        self::assertTrue(password_verify('Correct-password-123', $upgraded));
        self::assertFalse(password_verify('Incorrect-password-123', $upgraded));
    }

    public function test_wrong_password_cannot_produce_an_upgraded_hash(): void
    {
        $legacy = password_hash('Correct-password-123', PASSWORD_ARGON2I, ['memory_cost' => 1024, 'time_cost' => 1, 'threads' => 1]);
        $this->expectException(AuthenticationException::class);

        $this->passwords()->replacementHash('Incorrect-password-123', $legacy);
    }

    public function test_current_argon2id_hash_is_kept_after_correct_verification(): void
    {
        $current = password_hash('Correct-password-123', PASSWORD_ARGON2ID, ['memory_cost' => 1024, 'time_cost' => 1, 'threads' => 1]);
        $passwords = $this->passwords();

        self::assertTrue($passwords->matches('Correct-password-123', $current));
        self::assertFalse($passwords->matches('Incorrect-password-123', $current));
        self::assertNull($passwords->replacementHash('Correct-password-123', $current));
    }

    public function test_unsupported_or_malformed_password_hashes_fail_closed(): void
    {
        $passwords = $this->passwords();

        self::assertFalse($passwords->matches('Correct-password-123', ''));
        self::assertFalse($passwords->matches('Correct-password-123', null));
        self::assertFalse($passwords->matches('Correct-password-123', 'malformed'));
        self::assertFalse($passwords->matches('Correct-password-123', password_hash('Correct-password-123', PASSWORD_BCRYPT, ['cost' => 4])));
    }
}
