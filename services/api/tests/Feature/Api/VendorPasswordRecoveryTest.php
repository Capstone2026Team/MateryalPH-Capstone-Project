<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\IssuedAccessToken;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Models\AuthSession;
use App\Models\BotRiskChallenge;
use App\Models\EmailOtp;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class VendorPasswordRecoveryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config()->set(['materyalph.bot_protection.enabled' => false, 'app.vendor_frontend_url' => 'http://localhost:5173', 'app.admin_frontend_url' => 'http://localhost:5174']);
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

    public function test_vendor_email_recovery_preserves_twelve_character_policy_and_pending_verification(): void
    {
        foreach (['ACTIVE', 'PENDING_VERIFICATION'] as $status) {
            $vendor = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => $status]);
            app(EmailOtpService::class)->issue($vendor->email, 'PASSWORD_RESET', $vendor);
            $response = $this->vendorPost('/verify', ['email' => $vendor->email, 'code' => '123456'])->assertOk();
            $proof = $response->getCookie('mp_password_recovery_vendor', false);
            self::assertNotNull($proof);
            self::assertTrue($proof->isHttpOnly());
            $this->withUnencryptedCookie('mp_password_recovery_vendor', (string) $proof->getValue());
            $this->vendorPost('/complete', ['email' => $vendor->email, 'password' => 'VendorPass12', 'password_confirmation' => 'VendorPass12'])->assertOk();
            self::assertTrue(Hash::check('VendorPass12', $vendor->fresh()->password));
            self::assertSame($status, $vendor->fresh()->account_status);
            $this->vendorPost('/complete', ['email' => $vendor->email, 'password' => 'VendorPass12', 'password_confirmation' => 'VendorPass12'])->assertUnprocessable();
        }
    }

    public function test_vendor_saved_backup_code_rotates_the_set_and_revokes_sessions_without_removing_mfa(): void
    {
        $vendor = User::factory()->create(['account_type' => 'VENDOR']);
        $totp = app(TotpService::class);
        $totp->startEnrollment($vendor);
        DB::table('totp_factors')->where('user_id', $vendor->getKey())->update(['confirmed_at' => now()]);
        $codes = $totp->replaceRecoveryCodes($vendor);
        app(TokenSessionService::class)->start($vendor, 'WEB', null, null, null);
        $response = $this->vendorPost('/verify', ['email' => $vendor->email, 'recovery_code' => $codes[0]])->assertOk()->assertJsonCount(8, 'data.recovery_codes');
        self::assertNotSame($codes, $response->json('data.recovery_codes'));
        self::assertSame(0, AuthSession::query()->whereNull('revoked_at')->count());
        self::assertTrue($totp->hasConfirmedFactor($vendor));
        $this->vendorPost('/verify', ['email' => $vendor->email, 'recovery_code' => $codes[1]])->assertUnprocessable();
    }

    public function test_vendor_email_fallback_verifies_once_and_rejects_other_portal_challenges(): void
    {
        $vendor = User::factory()->create(['account_type' => 'VENDOR']);
        config()->set([
            'materyalph.bot_protection.enabled' => true,
            'materyalph.bot_protection.site_keys.WEB' => 'test-site',
            'materyalph.bot_protection.allowed_identities.WEB' => ['localhost'],
            'services.recaptcha.project_id' => 'test-project', 'services.recaptcha.api_key' => 'test-api-key',
        ]);
        $challengeId = $this->withCredentials()->withHeader('Origin', 'http://localhost:5173')->withHeader('X-CSRF-Token', 'test-csrf')->withUnencryptedCookie('mp_csrf_vendor', 'test-csrf')
            ->postJson('/api/v1/auth/password/forgot', ['email' => $vendor->email, 'portal' => 'VENDOR', 'bot_protection' => ['request_email_step_up' => true]])->assertForbidden()->json('errors.0.details.challenge_id');
        $challenge = BotRiskChallenge::query()->findOrFail($challengeId);
        $challenge->update(['portal' => 'ADMIN', 'action' => 'admin_password_recovery']);
        $this->vendorPost('/verify', ['email' => $vendor->email, 'code' => '123456', 'challenge_id' => $challengeId])->assertUnprocessable();
        $challenge->update(['portal' => 'VENDOR', 'action' => 'vendor_password_recovery']);
        $this->vendorPost('/verify', ['email' => $vendor->email, 'code' => '123456', 'challenge_id' => $challengeId])->assertOk();
        self::assertSame(1, EmailOtp::query()->count());
        self::assertNotNull($challenge->fresh()->consumed_at);
    }

    public function test_vendor_recovery_rejects_admin_accounts_and_suspended_vendors(): void
    {
        foreach (['ADMIN', 'VENDOR'] as $type) {
            $user = User::factory()->create(['account_type' => $type, 'account_status' => $type === 'VENDOR' ? 'SUSPENDED' : 'ACTIVE']);
            app(EmailOtpService::class)->issue($user->email, 'PASSWORD_RESET', $user);
            $this->vendorPost('/verify', ['email' => $user->email, 'code' => '123456'])->assertUnprocessable();
        }
    }

    public function test_vendor_proof_cannot_reset_an_admin_account_or_be_read_by_the_admin_origin(): void
    {
        $vendor = User::factory()->create(['account_type' => 'VENDOR']);
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        app(EmailOtpService::class)->issue($vendor->email, 'PASSWORD_RESET', $vendor);
        $proof = $this->vendorPost('/verify', ['email' => $vendor->email, 'code' => '123456'])->assertOk()->getCookie('mp_password_recovery_vendor', false);
        $this->withUnencryptedCookie('mp_password_recovery_vendor', (string) $proof?->getValue());
        $this->vendorPost('/complete', ['email' => $admin->email, 'portal' => 'ADMIN', 'password' => 'ChangedPassword123', 'password_confirmation' => 'ChangedPassword123'])->assertUnprocessable();
        $this->withHeader('Origin', 'http://localhost:5174')->withUnencryptedCookie('mp_csrf_admin', 'test-csrf')
            ->postJson('/api/v1/auth/password/complete', ['email' => $vendor->email, 'portal' => 'VENDOR', 'password' => 'ChangedPassword123', 'password_confirmation' => 'ChangedPassword123'])->assertUnprocessable();
    }

    /** @param array<string, mixed> $input */
    private function vendorPost(string $suffix, array $input): TestResponse
    {
        return $this->withCredentials()->withHeader('Origin', 'http://localhost:5173')->withHeader('X-CSRF-Token', 'test-csrf')
            ->withUnencryptedCookie('mp_csrf_vendor', 'test-csrf')->postJson('/api/v1/auth/password'.$suffix, $input + ['portal' => 'VENDOR']);
    }
}
