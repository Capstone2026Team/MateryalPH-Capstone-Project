<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AccountPassword;
use Illuminate\Config\Repository;
use Illuminate\Container\Container;
use Illuminate\Hashing\HashManager;
use PHPUnit\Framework\TestCase;

final class PasswordHashingConfigTest extends TestCase
{
    public function test_an_environment_without_hash_driver_still_hashes_with_argon2id(): void
    {
        $saved = [getenv('HASH_DRIVER'), $_ENV['HASH_DRIVER'] ?? null, $_SERVER['HASH_DRIVER'] ?? null];
        putenv('HASH_DRIVER');
        unset($_ENV['HASH_DRIVER'], $_SERVER['HASH_DRIVER']);
        try {
            $config = require dirname(__DIR__, 2).'/config/hashing.php';
        } finally {
            if ($saved[0] !== false) {
                putenv('HASH_DRIVER='.$saved[0]);
            }
            if ($saved[1] !== null) {
                $_ENV['HASH_DRIVER'] = $saved[1];
            }
            if ($saved[2] !== null) {
                $_SERVER['HASH_DRIVER'] = $saved[2];
            }
        }

        self::assertSame('argon2id', $config['driver']);
    }

    public function test_a_reset_hash_from_the_default_driver_can_sign_in(): void
    {
        $app = new Container;
        $app->instance('config', new Repository(['hashing' => [
            'driver' => 'argon2id',
            'argon' => ['memory' => 1024, 'threads' => 1, 'time' => 1, 'verify' => true],
        ]]));
        $hasher = new HashManager($app);
        $hash = $hasher->make('Reset-password-456');

        self::assertSame('argon2id', password_get_info($hash)['algoName']);
        self::assertTrue((new AccountPassword($hasher))->matches('Reset-password-456', $hash));
        // A bcrypt hash, as written when HASH_DRIVER was missing, is never accepted.
        self::assertFalse((new AccountPassword($hasher))->matches('Reset-password-456', password_hash('Reset-password-456', PASSWORD_BCRYPT)));
    }
}
