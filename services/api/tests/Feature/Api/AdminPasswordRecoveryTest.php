<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\IssuedAccessToken;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Models\AdminMembership;
use App\Models\AuthSession;
use App\Models\BotRiskChallenge;
use App\Models\EmailOtp;
use App\Models\PlatformRole;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class AdminPasswordRecoveryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config()->set([
            'materyalph.bot_protection.enabled' => false,
            'app.admin_frontend_url' => 'http://localhost:5174',
            'app.vendor_frontend_url' => 'http://localhost:5173',
            'materyalph.auth.cookie_secure' => true,
        ]);
        $this->app->instance(OtpCodeGenerator::class, new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '123456';
            }
        });
        $this->app->instance(AccessTokenIssuer::class, new class implements AccessTokenIssuer
        {
            public function issue(User $user, string $clientKind): IssuedAccessToken
            {
                return new IssuedAccessToken('test-access', (string) Str::uuid7());
            }

            public function revoke(?string $identifier): void {}
        });
    }

    public function test_email_verification_issues_only_an_httponly_password_bound_single_use_proof(): void
    {
        $admin = $this->adminWithOtp();
        app(TokenSessionService::class)->start($admin, 'WEB', null, null, null);
        $response = $this->verify($admin)->assertOk()->assertJsonPath('data.verified', true)->assertJsonPath('data.recovery_codes', null);
        $cookie = $response->getCookie('mp_password_recovery_admin', false);
        self::assertNotNull($cookie);
        self::assertTrue($cookie->isHttpOnly());
        self::assertTrue($cookie->isSecure());
        self::assertSame('/api/v1/auth/password', $cookie->getPath());
        self::assertSame('lax', $cookie->getSameSite());
        self::assertStringNotContainsString((string) $cookie->getValue(), $response->getContent());
        self::assertNotSame($cookie->getValue(), DB::table('password_reset_tokens')->where('email', $admin->email)->value('token'));
        self::assertNotNull(EmailOtp::query()->sole()->consumed_at);
        self::assertTrue(Hash::check('password', $admin->fresh()->password));

        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $cookie->getValue());
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertOk()->assertJsonPath('data.password_reset', true);
        self::assertTrue(Hash::check('ChangedPassword123', $admin->fresh()->password));
        self::assertSame(0, AuthSession::query()->whereNull('revoked_at')->count());
        self::assertSame(1, DB::table('login_events')->where('event_type', 'PASSWORD_RESET')->where('user_id', $admin->getKey())->count());
        self::assertSame(1, DB::table('outbox_events')->where('event_type', 'ACCOUNT_SECURITY_NOTICE')->count());
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertUnprocessable()->assertJsonPath('errors.0.code', 'PASSWORD_RECOVERY_EXPIRED');
    }

    public function test_reset_requires_verification_and_cannot_use_another_accounts_proof(): void
    {
        $admin = $this->adminWithOtp();
        $other = User::factory()->create(['account_type' => 'ADMIN']);
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertUnprocessable();
        $proof = $this->verify($admin)->assertOk()->getCookie('mp_password_recovery_admin', false);
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $proof?->getValue());
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($other))->assertUnprocessable();
        self::assertTrue(Hash::check('password', $other->fresh()->password));
    }

    public function test_invalid_email_attempts_commit_and_stop_after_five_failures(): void
    {
        $admin = $this->adminWithOtp();
        for ($attempt = 1; $attempt <= 5; $attempt++) {
            $response = $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'code' => '000000']);
            self::assertSame($attempt, EmailOtp::query()->sole()->attempts);
            $response->assertStatus($attempt === 5 ? 429 : 422);
        }
        $this->verify($admin)->assertStatus(429)->assertJsonPath('errors.0.code', 'PASSWORD_RECOVERY_THROTTLED');
        self::assertSame(0, DB::table('password_reset_tokens')->count());
    }

    public function test_expired_and_consumed_email_codes_cannot_verify(): void
    {
        $admin = $this->adminWithOtp();
        $this->travel(11)->minutes();
        $this->verify($admin)->assertUnprocessable();
        $this->travelBack();
        $this->verify($admin)->assertOk();
        $this->verify($admin)->assertUnprocessable();
    }

    public function test_proof_expires_and_password_changes_invalidate_it(): void
    {
        $admin = $this->adminWithOtp();
        $proof = $this->verify($admin)->assertOk()->getCookie('mp_password_recovery_admin', false);
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $proof?->getValue());
        $this->travel(11)->minutes();
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertUnprocessable();
        $this->travelBack();
        $admin->forceFill(['password' => Hash::make('ConcurrentChange123')])->save();
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertUnprocessable();
        self::assertTrue(Hash::check('ConcurrentChange123', $admin->fresh()->password));
    }

    public function test_backup_code_use_replaces_the_set_revokes_sessions_and_preserves_the_authenticator(): void
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        $totp = app(TotpService::class);
        $totp->startEnrollment($admin);
        DB::table('totp_factors')->where('user_id', $admin->getKey())->update(['confirmed_at' => now()]);
        $codes = $totp->replaceRecoveryCodes($admin);
        app(TokenSessionService::class)->start($admin, 'WEB', null, null, null);

        $response = $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'recovery_code' => strtolower($codes[0])])
            ->assertOk()->assertJsonCount(8, 'data.recovery_codes');
        self::assertNotSame($codes, $response->json('data.recovery_codes'));
        self::assertSame(0, AuthSession::query()->whereNull('revoked_at')->count());
        self::assertTrue($totp->hasConfirmedFactor($admin));
        self::assertSame(8, DB::table('recovery_codes')->where('user_id', $admin->getKey())->whereNull('used_at')->count());
        $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'recovery_code' => $codes[1]])->assertUnprocessable();
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $response->getCookie('mp_password_recovery_admin', false)?->getValue());
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertOk();
    }

    public function test_recovery_does_not_accept_buyer_vendor_inactive_or_unknown_accounts(): void
    {
        foreach (['BUYER', 'VENDOR', 'ADMIN'] as $type) {
            $user = User::factory()->create(['account_type' => $type, 'account_status' => $type === 'ADMIN' ? 'SUSPENDED' : 'ACTIVE']);
            app(EmailOtpService::class)->issue($user->email, 'PASSWORD_RESET', $user);
            $this->verify($user)->assertUnprocessable()->assertJsonPath('errors.0.code', 'PASSWORD_RECOVERY_CODE_INVALID');
        }
        $this->webPost('/api/v1/auth/password/verify', ['email' => 'unknown@example.test', 'code' => '123456'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PASSWORD_RECOVERY_CODE_INVALID');
        self::assertSame(0, DB::table('password_reset_tokens')->count());
    }

    public function test_an_invited_admin_can_recover_while_awaiting_initial_mfa_without_becoming_active(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $inviter = User::factory()->create(['account_type' => 'ADMIN']);
        $admin = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'PENDING_VERIFICATION']);
        AdminMembership::query()->create([
            'user_id' => $admin->getKey(), 'platform_role_id' => PlatformRole::query()->where('code', 'ADMIN_SUPERADMIN')->sole()->getKey(),
            'status' => 'PENDING', 'invited_by_user_id' => $inviter->getKey(),
        ]);
        app(EmailOtpService::class)->issue($admin->email, 'PASSWORD_RESET', $admin);
        $proof = $this->verify($admin)->assertOk()->getCookie('mp_password_recovery_admin', false);
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $proof?->getValue());
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertOk();
        self::assertSame('PENDING_VERIFICATION', $admin->fresh()->account_status);
        self::assertSame('PENDING', AdminMembership::query()->where('user_id', $admin->getKey())->sole()->status);
    }

    public function test_password_recovery_email_security_check_does_not_require_a_second_email_code(): void
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        config()->set([
            'materyalph.bot_protection.enabled' => true,
            'materyalph.bot_protection.site_keys.ADMIN_WEB' => 'test-site',
            'materyalph.bot_protection.allowed_identities.ADMIN_WEB' => ['localhost'],
            'services.recaptcha.project_id' => 'test-project',
            'services.recaptcha.api_key' => 'test-api-key',
        ]);
        $challengeId = $this->webPost('/api/v1/auth/password/forgot', ['email' => $admin->email, 'portal' => 'ADMIN', 'bot_protection' => ['request_email_step_up' => true]])
            ->assertForbidden()->json('errors.0.details.challenge_id');
        $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'code' => '123456', 'challenge_id' => $challengeId])->assertOk();
        self::assertSame(1, EmailOtp::query()->count());
        self::assertNotNull(BotRiskChallenge::query()->findOrFail($challengeId)->consumed_at);
        $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'code' => '123456', 'challenge_id' => $challengeId])->assertUnprocessable();
    }

    public function test_login_or_invitation_security_challenges_cannot_authorize_password_recovery(): void
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        foreach (['admin_login', 'admin_invitation_accept'] as $action) {
            $challenge = BotRiskChallenge::query()->create([
                'normalized_email_hash' => hash_hmac('sha256', strtolower($admin->email), (string) config('app.key')),
                'portal' => 'ADMIN', 'action' => $action, 'platform' => 'WEB', 'outcome' => 'ACCESSIBLE_FALLBACK', 'delivery_allowed' => true, 'expires_at' => now()->addMinutes(5),
            ]);
            $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'code' => '123456', 'challenge_id' => $challenge->getKey()])->assertUnprocessable();
        }
        self::assertSame(0, DB::table('password_reset_tokens')->count());
    }

    public function test_both_steps_require_csrf_and_validate_exclusive_codes_and_password_policy(): void
    {
        $this->postJson('/api/v1/auth/password/verify', ['email' => 'admin@example.test', 'code' => '123456'])->assertStatus(419);
        $this->postJson('/api/v1/auth/password/complete', ['email' => 'admin@example.test'])->assertStatus(419);
        $this->webPost('/api/v1/auth/password/verify', ['email' => 'admin@example.test', 'code' => '123456', 'recovery_code' => 'TEST-ONLY'])->assertUnprocessable();
        $this->webPost('/api/v1/auth/password/verify', ['email' => 'admin@example.test'])->assertUnprocessable();
        $admin = $this->adminWithOtp();
        $proof = $this->verify($admin)->assertOk()->getCookie('mp_password_recovery_admin', false);
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $proof?->getValue());
        $this->webPost('/api/v1/auth/password/complete', ['email' => $admin->email, 'password' => 'short', 'password_confirmation' => 'short'])->assertUnprocessable();
        $this->webPost('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertOk();
    }

    public function test_other_portal_cookies_cannot_complete_admin_password_recovery(): void
    {
        $admin = $this->adminWithOtp();
        $proof = $this->verify($admin)->assertOk()->getCookie('mp_password_recovery_admin', false);
        $this->withUnencryptedCookie('mp_password_recovery_admin', (string) $proof?->getValue());
        $this->withHeader('Origin', 'http://localhost:5173')->withUnencryptedCookie('mp_csrf_vendor', 'test-csrf')
            ->postJson('/api/v1/auth/password/complete', $this->passwordInput($admin))->assertUnprocessable();
    }

    private function adminWithOtp(): User
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        app(EmailOtpService::class)->issue($admin->email, 'PASSWORD_RESET', $admin);

        return $admin;
    }

    private function verify(User $admin): TestResponse
    {
        return $this->webPost('/api/v1/auth/password/verify', ['email' => $admin->email, 'code' => '123456']);
    }

    /** @return array<string, string> */
    private function passwordInput(User $admin): array
    {
        return ['email' => $admin->email, 'portal' => 'ADMIN', 'password' => 'ChangedPassword123', 'password_confirmation' => 'ChangedPassword123'];
    }

    /** @param array<string, mixed> $input */
    private function webPost(string $path, array $input): TestResponse
    {
        return $this->withCredentials()->withHeader('Origin', 'http://localhost:5174')->withHeader('X-CSRF-Token', 'test-csrf')
            ->withUnencryptedCookie('mp_csrf_admin', 'test-csrf')->postJson($path, $input + ['portal' => 'ADMIN']);
    }
}
