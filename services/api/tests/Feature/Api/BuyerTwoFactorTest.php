<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

/** Optional Buyer authenticator 2FA: self-service enrollment, native sign-in challenge and turning it off. */
final class BuyerTwoFactorTest extends TestCase
{
    use RefreshDatabase;

    private const PASSWORD = 'OriginalPassword123';

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_enrollment_requires_recent_authentication_and_returns_a_stable_setup_key_until_confirmed(): void
    {
        [$user, $current] = $this->signedInBuyer();
        $other = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $this->postJson('/api/v1/buyers/account/two-factor')->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        $this->postJson('/api/v1/buyers/account/reauthentication', ['password' => self::PASSWORD])->assertOk();

        $setup = $this->postJson('/api/v1/buyers/account/two-factor')->assertOk()->assertJsonPath('data.issuer', 'MateryalPH')->json('data');
        self::assertMatchesRegularExpression('/^[A-Z2-7]{32}$/', $setup['secret']);
        self::assertStringStartsWith('otpauth://totp/', $setup['provisioning_uri']);
        self::assertStringContainsString('secret='.$setup['secret'], $setup['provisioning_uri']);
        self::assertSame($setup['secret'], $this->postJson('/api/v1/buyers/account/two-factor')->assertOk()->json('data.secret'));

        $code = $this->totpCode($setup['secret'], intdiv(time(), 30));
        $this->postJson('/api/v1/buyers/account/two-factor/confirm', ['code' => $this->wrong($code)])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'MFA_CODE_INVALID');
        // A wrong setup code never signs the Buyer out.
        $this->getJson('/api/v1/buyers/account/profile')->assertOk();
        $this->getJson('/api/v1/buyers/account/security')->assertOk()->assertJsonPath('data.totp_enrolled', false);

        $this->postJson('/api/v1/buyers/account/two-factor/confirm', ['code' => $code])->assertOk()->assertJsonCount(8, 'data.recovery_codes');
        $this->getJson('/api/v1/buyers/account/security')->assertOk()->assertJsonPath('data.totp_enrolled', true);
        self::assertNull($current->refresh()->revoked_at);
        self::assertNotNull(AuthSession::query()->findOrFail($other->sessionId)->revoked_at);
        $this->postJson('/api/v1/buyers/account/two-factor')->assertConflict()->assertJsonPath('errors.0.code', 'MFA_ALREADY_ENROLLED');
        $this->assertDatabaseHas('audit_logs', ['action' => 'MFA_ENROLLMENT_CONFIRMED', 'actor_user_id' => $user->getKey()]);
        $this->assertDatabaseHas('outbox_events', ['event_type' => 'ACCOUNT_SECURITY_NOTICE']);
    }

    public function test_enrolled_buyer_password_sign_in_returns_a_native_challenge_instead_of_tokens(): void
    {
        [$user, $secret] = $this->enrolledBuyer();
        $login = $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])
            ->assertOk()->assertJsonPath('data.mfa_required', true)->assertJsonMissingPath('data.access_token')->assertJsonMissingPath('data.refresh_token')
            ->assertCookieMissing('mp_mfa_challenge');
        $token = (string) $login->json('data.challenge_token');
        self::assertNotSame('', $token);

        $this->postJson('/api/v1/mobile/auth/mfa/challenge', ['code' => '123456'])->assertUnprocessable();
        $code = $this->totpCode($secret, intdiv(time(), 30));
        $this->postJson('/api/v1/mobile/auth/mfa/challenge', ['challenge_token' => $token, 'code' => $this->wrong($code)])
            ->assertUnauthorized()->assertJsonPath('errors.0.code', 'MFA_CODE_INVALID');
        $this->postJson('/api/v1/mobile/auth/mfa/challenge', ['challenge_token' => $token, 'code' => $code])
            ->assertOk()->assertJsonPath('data.user.account_type', 'BUYER')->assertJsonStructure(['data' => ['access_token', 'refresh_token']]);
        // Single-use challenge, and the same TOTP step cannot be replayed on a fresh challenge.
        $this->postJson('/api/v1/mobile/auth/mfa/challenge', ['challenge_token' => $token, 'code' => $code])->assertUnauthorized();
        $fresh = (string) $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])->json('data.challenge_token');
        $this->postJson('/api/v1/mobile/auth/mfa/challenge', ['challenge_token' => $fresh, 'code' => $code])->assertUnauthorized();
        $this->assertDatabaseHas('login_events', ['user_id' => $user->getKey(), 'event_type' => 'MFA_CHALLENGE_SUCCEEDED']);
    }

    public function test_a_native_challenge_cannot_be_completed_through_the_web_cookie_route(): void
    {
        [$user, $secret] = $this->enrolledBuyer();
        $token = (string) $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])->json('data.challenge_token');
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withUnencryptedCookie('mp_mfa_challenge', $token)->withHeader('X-CSRF-Token', 'test-csrf')
            ->postJson('/api/v1/auth/mfa/challenge', ['code' => $this->totpCode($secret, intdiv(time(), 30))])
            ->assertUnauthorized()->assertJsonPath('errors.0.code', 'MFA_CHALLENGE_INVALID')->assertCookieMissing('mp_access');
    }

    public function test_recovery_code_completes_the_native_challenge_once_and_replaces_every_code(): void
    {
        [$user, , $codes] = $this->enrolledBuyer();
        $token = (string) $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])->json('data.challenge_token');
        $replacement = $this->postJson('/api/v1/mobile/auth/mfa/recovery', ['challenge_token' => $token, 'recovery_code' => strtolower($codes[0])])
            ->assertOk()->assertJsonCount(8, 'data.recovery_codes')->assertJsonStructure(['data' => ['access_token']])->json('data.recovery_codes');
        self::assertNotContains($codes[1], $replacement);
        $again = (string) $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])->json('data.challenge_token');
        $this->postJson('/api/v1/mobile/auth/mfa/recovery', ['challenge_token' => $again, 'recovery_code' => $codes[1]])->assertUnauthorized();
    }

    public function test_buyer_without_an_authenticator_still_signs_in_directly(): void
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'password' => self::PASSWORD]);
        $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])
            ->assertOk()->assertJsonMissingPath('data.mfa_required')->assertJsonStructure(['data' => ['access_token', 'refresh_token']]);
    }

    public function test_turning_2fa_off_requires_recent_authentication_and_possession(): void
    {
        [$user, $secret, $codes] = $this->enrolledBuyer();
        $session = $this->signIn($user);
        $this->postJson('/api/v1/buyers/account/two-factor/disable', ['code' => '123456'])->assertForbidden();
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $this->postJson('/api/v1/buyers/account/two-factor/disable', [])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/account/two-factor/disable', ['code' => '123456', 'recovery_code' => $codes[0]])->assertUnprocessable();
        $wrong = $this->wrong($this->totpCode($secret, intdiv(time(), 30)));
        $this->postJson('/api/v1/buyers/account/two-factor/disable', ['code' => $wrong])->assertUnprocessable()->assertJsonPath('errors.0.code', 'MFA_CODE_INVALID');
        $this->getJson('/api/v1/buyers/account/profile')->assertOk();

        $this->postJson('/api/v1/buyers/account/two-factor/disable', ['recovery_code' => $codes[2]])->assertOk()->assertJsonPath('data.changed', true);
        self::assertFalse(app(TotpService::class)->hasConfirmedFactor($user));
        self::assertNull($session->refresh()->reauthenticated_at);
        self::assertSame(0, DB::table('recovery_codes')->where('user_id', $user->getKey())->whereNull('used_at')->count());
        $this->assertDatabaseHas('audit_logs', ['action' => 'MFA_DISABLED', 'actor_user_id' => $user->getKey()]);
        $this->postJson('/api/v1/mobile/auth/login', ['email' => $user->email, 'password' => self::PASSWORD])->assertOk()->assertJsonStructure(['data' => ['access_token']]);

        // Re-enrolling issues a different secret.
        $this->signIn($user)->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        self::assertNotSame($secret, $this->postJson('/api/v1/buyers/account/two-factor')->assertOk()->json('data.secret'));
    }

    public function test_buyer_can_regenerate_recovery_codes_only_while_enrolled(): void
    {
        [, $plainSession] = $this->signedInBuyer();
        $plainSession->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $this->postJson('/api/v1/buyers/account/recovery-codes')->assertConflict()->assertJsonPath('errors.0.code', 'MFA_NOT_ENROLLED');

        [$user, , $codes] = $this->enrolledBuyer();
        $this->signIn($user)->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $this->postJson('/api/v1/buyers/account/recovery-codes')->assertOk()->assertJsonCount(8, 'data.recovery_codes');
        self::assertFalse(app(TotpService::class)->hasUnusedRecoveryCode($user, $codes[0]));
    }

    public function test_buyer_two_factor_routes_reject_other_portals(): void
    {
        $vendor = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $tokens = app(TokenSessionService::class)->start($vendor, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $vendor->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($vendor, 'api');
        $this->postJson('/api/v1/buyers/account/two-factor')->assertForbidden();
        $this->getJson('/api/v1/buyers/account/deletion')->assertForbidden();
    }

    /** @return array{User, AuthSession} */
    private function signedInBuyer(): array
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'password' => self::PASSWORD]);

        return [$user, $this->signIn($user)];
    }

    /** @return array{User, string, list<string>} */
    private function enrolledBuyer(): array
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'password' => self::PASSWORD]);
        $totp = app(TotpService::class);
        $totp->startEnrollment($user);
        $secret = Crypt::decryptString((string) DB::table('totp_factors')->where('user_id', $user->getKey())->value('encrypted_secret'));
        // Confirm on the previous step so the current step is still unused for the sign-in under test.
        $codes = $totp->confirm($user, $this->totpCode($secret, intdiv(time(), 30) - 1));

        return [$user, $secret, $codes];
    }

    private function signIn(User $user): AuthSession
    {
        $tokens = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['BUYER']]));
        $this->actingAs($user, 'api');

        return $session;
    }

    private function wrong(string $code): string
    {
        return str_pad((string) (((int) $code + 1) % 1000000), 6, '0', STR_PAD_LEFT);
    }

    private function totpCode(string $secret, int $counter): string
    {
        $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        $buffer = 0;
        $bits = 0;
        $decoded = '';
        foreach (str_split($secret) as $character) {
            $position = strpos($alphabet, $character);
            self::assertNotFalse($position);
            $buffer = ($buffer << 5) | $position;
            $bits += 5;
            if ($bits >= 8) {
                $bits -= 8;
                $decoded .= chr(($buffer >> $bits) & 0xFF);
            }
        }

        $hash = hash_hmac('sha1', pack('N2', 0, $counter), $decoded, true);
        $offset = ord($hash[19]) & 0x0F;
        $value = ((ord($hash[$offset]) & 0x7F) << 24)
            | ((ord($hash[$offset + 1]) & 0xFF) << 16)
            | ((ord($hash[$offset + 2]) & 0xFF) << 8)
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($value % 1_000_000), 6, '0', STR_PAD_LEFT);
    }
}
