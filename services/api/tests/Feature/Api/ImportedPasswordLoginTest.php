<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticateAccount;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class ImportedPasswordLoginTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('materyalph.bot_protection.enabled', false);
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_imported_password_is_upgraded_after_verification_without_bypassing_admin_mfa(): void
    {
        [$admin, $legacy] = $this->importedAdmin();

        $this->login($admin, 'Correct-password-123')->assertOk()
            ->assertJsonPath('data.mfa_required', true)
            ->assertCookie('mp_mfa_challenge')
            ->assertCookieMissing('mp_access')
            ->assertCookieMissing('mp_refresh');

        $upgraded = $admin->refresh()->password;
        self::assertNotSame($legacy, $upgraded);
        self::assertSame('argon2id', password_get_info($upgraded)['algoName']);
        self::assertTrue(Hash::check('Correct-password-123', $upgraded));
        $this->assertDatabaseHas('login_events', ['user_id' => $admin->getKey(), 'event_type' => 'PASSWORD_HASH_UPGRADED', 'succeeded' => true]);
        $this->assertDatabaseCount('auth_sessions', 0);
        $this->assertDatabaseCount('oauth_access_tokens', 0);
    }

    public function test_wrong_imported_password_is_rejected_without_upgrading_it(): void
    {
        [$admin, $legacy] = $this->importedAdmin();

        $this->login($admin, 'Incorrect-password-123')->assertUnauthorized()
            ->assertJsonPath('errors.0.code', 'INVALID_CREDENTIALS')
            ->assertCookieMissing('mp_mfa_challenge');

        self::assertSame($legacy, $admin->refresh()->password);
        $this->assertDatabaseMissing('login_events', ['event_type' => 'PASSWORD_HASH_UPGRADED']);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_bot_step_up_still_blocks_login_and_leaves_the_legacy_hash_unchanged(): void
    {
        [$admin, $legacy] = $this->importedAdmin();
        config()->set([
            'materyalph.bot_protection.enabled' => true,
            'materyalph.bot_protection.site_keys.ADMIN_WEB' => 'test-admin-site-key',
            'materyalph.bot_protection.allowed_identities.ADMIN_WEB' => ['localhost'],
            'services.recaptcha.project_id' => 'test-project',
            'services.recaptcha.api_key' => 'test-api-key',
        ]);

        $this->login($admin, 'Correct-password-123', ['request_email_step_up' => true])->assertForbidden()
            ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED')
            ->assertCookieMissing('mp_mfa_challenge');

        self::assertSame($legacy, $admin->refresh()->password);
        $this->assertDatabaseMissing('login_events', ['event_type' => 'PASSWORD_HASH_UPGRADED']);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_upgrade_cannot_overwrite_a_concurrent_password_reset(): void
    {
        [$admin] = $this->importedAdmin();
        $authenticate = app(AuthenticateAccount::class);
        $verified = $authenticate->handle($admin->email, 'Correct-password-123', 'ADMIN');
        $resetHash = Hash::make('Reset-password-456');
        DB::table('users')->where('id', $admin->getKey())->update(['password' => $resetHash]);

        try {
            $authenticate->upgradePassword($verified, 'Correct-password-123');
            self::fail('A concurrent password reset must prevent the upgrade.');
        } catch (AuthenticationException $exception) {
            self::assertSame('INVALID_CREDENTIALS', $exception->errorCode);
        }

        self::assertSame($resetHash, $admin->refresh()->password);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    /** @return array{User, string} */
    private function importedAdmin(): array
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE']);
        $legacy = password_hash('Correct-password-123', PASSWORD_ARGON2I, ['memory_cost' => 1024, 'time_cost' => 1, 'threads' => 1]);
        // Simulate an imported hash without passing it through the current model's hashed cast.
        DB::table('users')->where('id', $admin->getKey())->update(['password' => $legacy]);

        return [$admin, $legacy];
    }

    /** @param array<string, bool>|null $botProtection */
    private function login(User $user, string $password, ?array $botProtection = null): TestResponse
    {
        return $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/login', [
                'email' => $user->email, 'password' => $password, 'portal' => 'ADMIN', 'bot_protection' => $botProtection,
            ]);
    }
}
