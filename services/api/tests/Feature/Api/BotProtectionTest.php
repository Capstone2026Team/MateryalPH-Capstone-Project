<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\BotProtectionService;
use App\Domain\Identity\IssuedAccessToken;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\RecaptchaAssessmentResult;
use App\Domain\Identity\RecaptchaProviderUnavailable;
use App\Models\AdminInvitation;
use App\Models\BotRiskChallenge;
use App\Models\PlatformRole;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class BotProtectionTest extends TestCase
{
    use RefreshDatabase;

    private FakeRecaptchaAssessmentGateway $gateway;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set([
            'materyalph.bot_protection.enabled' => true,
            'materyalph.bot_protection.step_up_ttl_minutes' => 5,
            'materyalph.bot_protection.site_keys.WEB' => 'vendor-web-site-key',
            'materyalph.bot_protection.allowed_identities.WEB' => ['localhost'],
            'materyalph.bot_protection.site_keys.ADMIN_WEB' => 'admin-web-site-key',
            'materyalph.bot_protection.allowed_identities.ADMIN_WEB' => ['admin.example.test'],
            'services.recaptcha.project_id' => 'test-project',
            'services.recaptcha.api_key' => 'test-api-key',
        ]);

        $this->gateway = new FakeRecaptchaAssessmentGateway;
        $this->app->instance(RecaptchaAssessmentGateway::class, $this->gateway);
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
                return new IssuedAccessToken('test-access-token', (string) Str::uuid7());
            }

            public function revoke(?string $identifier): void {}
        });
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_buyer_registration_requires_no_captcha_and_never_calls_the_provider(): void
    {
        $this->mobilePost('/api/v1/mobile/auth/register', $this->buyerRegistration())
            ->assertCreated()
            ->assertJsonPath('data.account_type', 'BUYER');

        self::assertSame(0, $this->gateway->calls);
        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    public function test_buyer_login_requires_no_captcha_and_never_calls_the_provider(): void
    {
        User::factory()->create([
            'email' => 'buyer-login@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'BUYER',
        ]);

        $this->mobilePost('/api/v1/mobile/auth/login', [
            'email' => 'buyer-login@example.test',
            'password' => 'CorrectPassword123',
        ])->assertOk()->assertJsonPath('data.access_token', 'test-access-token');

        self::assertSame(0, $this->gateway->calls);
    }

    public function test_buyer_cannot_submit_vendor_captcha_evidence(): void
    {
        $payload = $this->buyerRegistration();
        $payload['bot_protection'] = ['recaptcha_token' => 'must-not-be-accepted'];

        $this->mobilePost('/api/v1/mobile/auth/register', $payload)
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');

        self::assertSame(0, $this->gateway->calls);
        self::assertFalse(User::query()->where('email', 'buyer@example.test')->exists());
    }

    public function test_valid_vendor_checkbox_assessment_allows_registration_without_a_score_gate(): void
    {
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_register', 'localhost');

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'checkbox-token',
        ]))->assertCreated()
            ->assertJsonPath('data.account_type', 'VENDOR');

        self::assertSame(['checkbox-token', 'vendor-web-site-key', 'vendor_register'], $this->gateway->lastCall);
        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    public function test_vendor_invitation_acceptance_requires_its_own_checkbox_action(): void
    {
        [$payload, $id] = $this->vendorInvitation(['recaptcha_token' => 'invitation-checkbox-token']);
        $withoutEvidence = $payload;
        unset($withoutEvidence['bot_protection']);
        $this->webPost('/api/v1/auth/vendor-invitations/accept', $withoutEvidence)->assertUnprocessable()->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        self::assertSame(0, $this->gateway->calls);
        self::assertNull(DB::table('vendor_invitations')->where('id', $id)->value('accepted_at'));
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_invitation_accept', 'localhost');
        $this->webPost('/api/v1/auth/vendor-invitations/accept', $payload)->assertCreated();
        self::assertSame(['invitation-checkbox-token', 'vendor-web-site-key', 'vendor_invitation_accept'], $this->gateway->lastCall);
        $user = User::query()->where('email', $payload['email'])->sole();
        self::assertSame('PENDING_VERIFICATION', $user->account_status);
        $this->assertDatabaseHas('vendor_memberships', ['user_id' => $user->getKey(), 'role' => 'STORE_STAFF']);
        self::assertNotNull(DB::table('vendor_invitations')->where('id', $id)->value('accepted_at'));
        self::assertSame(0, BotRiskChallenge::query()->count());
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_rejected_invitation_assessments_and_provider_failure_require_email_security_check(): void
    {
        foreach ([
            new RecaptchaAssessmentResult(true, 'vendor_register', 'localhost'),
            new RecaptchaAssessmentResult(true, 'vendor_invitation_accept', 'unapproved.example.test'),
            new RecaptchaAssessmentResult(false, null, null),
            null,
        ] as $index => $assessment) {
            [$payload, $id] = $this->vendorInvitation(['recaptcha_token' => 'invitation-checkbox-token'], "invitation-$index@example.test");
            $this->gateway->result = $assessment;
            $this->gateway->unavailable = $assessment === null;
            $this->webPost('/api/v1/auth/vendor-invitations/accept', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
            self::assertNull(DB::table('vendor_invitations')->where('id', $id)->value('accepted_at'));
            self::assertFalse(User::query()->where('email', $payload['email'])->exists());
        }
        self::assertSame(4, BotRiskChallenge::query()->where('action', 'vendor_invitation_accept')->count());
        self::assertSame(4, DB::table('email_otps')->where('purpose', 'BOT_RISK_STEP_UP')->count());
    }

    public function test_invitation_email_security_proof_is_email_and_action_bound_and_single_use(): void
    {
        [$payload, $id] = $this->vendorInvitation(['request_email_step_up' => true]);
        $response = $this->webPost('/api/v1/auth/vendor-invitations/accept', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        $challengeId = (string) $response->json('errors.0.details.challenge_id');
        $service = $this->app->make(BotProtectionService::class);
        $proof = $service->verifyChallenge(Request::create('/api/v1/auth/bot-challenges/'.$challengeId.'/verify', 'POST'), $challengeId, $payload['email'], '123456', 'VENDOR');
        $request = Request::create('/api/v1/auth/vendor-invitations/accept', 'POST', cookies: ['mp_bot_proof' => $proof->token]);
        foreach ([[$payload['email'], 'REGISTER'], ['other@example.test', 'INVITATION_ACCEPT']] as [$email, $operation]) {
            try {
                $service->guard($request, $email, 'VENDOR', $operation, [], null, true);
                self::fail('An invitation security proof must match its email and action.');
            } catch (AuthenticationException $exception) {
                self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
            }
        }
        $payload['bot_protection'] = [];
        $this->withUnencryptedCookie('mp_bot_proof', $proof->token);
        $this->webPost('/api/v1/auth/vendor-invitations/accept', $payload)->assertCreated()->assertCookieExpired('mp_bot_proof');
        self::assertNotNull(BotRiskChallenge::query()->findOrFail($challengeId)->consumed_at);
        self::assertNotNull(DB::table('vendor_invitations')->where('id', $id)->value('accepted_at'));
        try {
            $service->guard($request, $payload['email'], 'VENDOR', 'INVITATION_ACCEPT', [], null, true);
            self::fail('A consumed invitation security proof must not be reusable.');
        } catch (AuthenticationException $exception) {
            self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
        }
    }

    public function test_invalid_invitation_links_cannot_send_bot_security_emails(): void
    {
        [$payload, $id] = $this->vendorInvitation(['request_email_step_up' => true]);
        $this->webPost('/api/v1/auth/vendor-invitations/accept', array_replace($payload, ['email' => 'arbitrary@example.test']))->assertUnprocessable()->assertJsonPath('errors.0.code', 'VENDOR_INVITATION_INVALID');
        $this->webPost('/api/v1/auth/vendor-invitations/accept', array_replace($payload, ['token' => 'invalid-token']))->assertUnprocessable()->assertJsonPath('errors.0.code', 'VENDOR_INVITATION_INVALID');
        foreach (['expires_at', 'revoked_at', 'deleted_at', 'accepted_at'] as $field) {
            DB::table('vendor_invitations')->where('id', $id)->update(['expires_at' => now()->addDay(), 'revoked_at' => null, 'deleted_at' => null, 'accepted_at' => null, $field => now()]);
            $this->webPost('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable()->assertJsonPath('errors.0.code', 'VENDOR_INVITATION_INVALID');
        }
        self::assertSame(0, $this->gateway->calls);
        self::assertSame(0, BotRiskChallenge::query()->count());
        $this->assertDatabaseCount('email_otps', 0);
        self::assertFalse(User::query()->where('email', $payload['email'])->exists());
    }

    public function test_vendor_login_and_recovery_use_their_server_selected_checkbox_actions(): void
    {
        User::factory()->create([
            'email' => 'vendor-auth@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'VENDOR',
        ]);

        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_login', 'localhost');
        $this->webPost('/api/v1/auth/login', [
            'email' => 'vendor-auth@example.test',
            'password' => 'CorrectPassword123',
            'portal' => 'VENDOR',
            'bot_protection' => ['recaptcha_token' => 'login-checkbox-token'],
        ])->assertOk()
            ->assertJsonPath('data.user.account_type', 'VENDOR')
            ->assertCookie('mp_access');
        self::assertSame(['login-checkbox-token', 'vendor-web-site-key', 'vendor_login'], $this->gateway->lastCall);

        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_password_recovery', 'localhost');
        $this->webPost('/api/v1/auth/password/forgot', [
            'email' => 'vendor-auth@example.test',
            'portal' => 'VENDOR',
            'bot_protection' => ['recaptcha_token' => 'recovery-checkbox-token'],
        ])->assertOk();
        self::assertSame(['recovery-checkbox-token', 'vendor-web-site-key', 'vendor_password_recovery'], $this->gateway->lastCall);
    }

    public function test_vendor_submission_without_checkbox_or_accessible_fallback_is_rejected(): void
    {
        $payload = $this->vendorRegistration([]);
        unset($payload['bot_protection']);

        $this->webPost('/api/v1/auth/register', $payload)
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');

        self::assertSame(0, $this->gateway->calls);
    }

    public function test_wrong_vendor_action_hostname_and_invalid_token_use_email_step_up(): void
    {
        foreach ([
            new RecaptchaAssessmentResult(true, 'vendor_login', 'localhost'),
            new RecaptchaAssessmentResult(true, 'vendor_register', 'unapproved.example.test'),
            new RecaptchaAssessmentResult(false, null, null),
        ] as $index => $assessment) {
            $this->gateway->result = $assessment;
            $payload = $this->vendorRegistration(['recaptcha_token' => 'rejected-token-'.$index]);
            $payload['email'] = "rejected-$index@example.test";
            $this->webPost('/api/v1/auth/register', $payload)
                ->assertForbidden()
                ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        }

        self::assertSame(3, BotRiskChallenge::query()->count());
        self::assertSame(3, DB::table('email_otps')->where('purpose', 'BOT_RISK_STEP_UP')->count());
    }

    public function test_provider_failure_uses_the_existing_email_step_up(): void
    {
        $this->gateway->unavailable = true;

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'provider-failure-token',
        ]))->assertForbidden()
            ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');

        self::assertSame('PROVIDER_UNAVAILABLE', BotRiskChallenge::query()->sole()->outcome);
    }

    public function test_accessible_vendor_fallback_and_cookie_proof_remain_single_use(): void
    {
        $response = $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'request_email_step_up' => true,
        ]))->assertForbidden()
            ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');

        $challengeId = (string) $response->json('errors.0.details.challenge_id');
        $proof = $this->app->make(BotProtectionService::class)->verifyChallenge(
            Request::create('/api/v1/auth/bot-challenges/'.$challengeId.'/verify', 'POST'),
            $challengeId,
            'vendor@example.test',
            '123456',
            'VENDOR',
        );
        $request = Request::create('/api/v1/auth/register', 'POST', cookies: ['mp_bot_proof' => $proof->token]);
        $service = $this->app->make(BotProtectionService::class);

        self::assertTrue($service->guard(
            $request,
            'vendor@example.test',
            'VENDOR',
            'REGISTER',
            [],
            null,
            true,
        ));

        try {
            $service->guard($request, 'vendor@example.test', 'VENDOR', 'REGISTER', [], null, true);
            self::fail('A consumed proof must not be reusable.');
        } catch (AuthenticationException $exception) {
            self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
        }
    }

    public function test_buyer_recovery_remains_anti_enumerating_without_captcha(): void
    {
        $this->mobilePost('/api/v1/mobile/auth/password/forgot', [
            'email' => 'unknown@example.test',
        ])->assertOk()
            ->assertJsonPath('data.message', 'If the account exists, a recovery code is being delivered.');

        self::assertSame(0, $this->gateway->calls);
        self::assertSame(0, DB::table('email_otps')->count());
    }

    public function test_admin_login_requires_verified_checkbox_and_still_requires_mfa(): void
    {
        $payload = $this->adminLogin();
        $this->webPost('/api/v1/auth/login', $payload)->assertUnprocessable()->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        self::assertSame(0, $this->gateway->calls);
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'admin_login', 'admin.example.test');
        $payload['bot_protection'] = ['recaptcha_token' => 'admin-login-token'];
        $this->webPost('/api/v1/auth/login', $payload)->assertOk()->assertJsonPath('data.mfa_required', true)
            ->assertCookie('mp_mfa_challenge')->assertCookieMissing('mp_access');
        self::assertSame(['admin-login-token', 'admin-web-site-key', 'admin_login'], $this->gateway->lastCall);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_admin_invitation_acceptance_requires_its_own_checkbox_action(): void
    {
        [$payload, $invitation] = $this->adminInvitation();
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertUnprocessable();
        self::assertNull($invitation->refresh()->accepted_at);
        $payload['bot_protection'] = ['recaptcha_token' => 'admin-invitation-token'];
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'admin_invitation_accept', 'admin.example.test');
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertCreated()->assertJsonPath('data.next', 'SIGN_IN_AND_ENROLL_MFA');
        self::assertSame(['admin-invitation-token', 'admin-web-site-key', 'admin_invitation_accept'], $this->gateway->lastCall);
        self::assertNotNull($invitation->refresh()->accepted_at);
        $this->assertDatabaseHas('users', ['email' => $payload['email'], 'account_type' => 'ADMIN']);
        $this->assertDatabaseHas('audit_logs', ['action' => 'ADMIN_BOOTSTRAP_INVITATION_ACCEPTED']);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_rejected_admin_tokens_and_provider_outage_cannot_create_accounts(): void
    {
        foreach ([
            new RecaptchaAssessmentResult(true, 'vendor_invitation_accept', 'admin.example.test'),
            new RecaptchaAssessmentResult(true, 'admin_login', 'admin.example.test'),
            new RecaptchaAssessmentResult(true, 'admin_invitation_accept', 'localhost'),
            new RecaptchaAssessmentResult(false, null, null),
            null,
        ] as $index => $assessment) {
            [$payload, $invitation] = $this->adminInvitation("invited-admin-$index@example.test");
            $payload['bot_protection'] = ['recaptcha_token' => 'rejected-admin-token'];
            $this->gateway->result = $assessment;
            $this->gateway->unavailable = $assessment === null;
            $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
            self::assertNull($invitation->refresh()->accepted_at);
            self::assertFalse(User::query()->where('email', $payload['email'])->exists());
        }
        self::assertSame(5, BotRiskChallenge::query()->where('portal', 'ADMIN')->count());
        $this->assertDatabaseCount('admin_memberships', 0);
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_admin_email_security_proof_is_portal_email_and_action_bound_and_single_use(): void
    {
        [$payload, $invitation] = $this->adminInvitation();
        $payload['bot_protection'] = ['request_email_step_up' => true];
        $response = $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        $challengeId = (string) $response->json('errors.0.details.challenge_id');
        $verifyPath = '/api/v1/auth/bot-challenges/'.$challengeId.'/verify';
        $this->webPost($verifyPath, ['email' => $payload['email'], 'code' => '123456', 'portal' => 'VENDOR'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_INVALID');
        $verified = $this->webPost($verifyPath, ['email' => $payload['email'], 'code' => '123456', 'portal' => 'ADMIN'])->assertOk()->assertCookie('mp_bot_proof')->assertJsonMissingPath('data.step_up_token');
        $proofToken = (string) $verified->getCookie('mp_bot_proof', false)?->getValue();
        self::assertTrue($verified->getCookie('mp_bot_proof', false)?->isHttpOnly());
        $request = Request::create('/api/v1/auth/admin-invitations/accept', 'POST', cookies: ['mp_bot_proof' => $proofToken]);
        $service = $this->app->make(BotProtectionService::class);
        foreach ([['ADMIN', 'LOGIN', $payload['email']], ['ADMIN', 'INVITATION_ACCEPT', 'other@example.test'], ['VENDOR', 'INVITATION_ACCEPT', $payload['email']]] as [$portal, $operation, $email]) {
            try {
                $service->guard($request, $email, $portal, $operation, [], null, true);
                self::fail('Proof must match portal, action, and email.');
            } catch (AuthenticationException $exception) {
                self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
            }
        }
        $payload['bot_protection'] = [];
        $this->withUnencryptedCookie('mp_bot_proof', $proofToken);
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertCreated()->assertCookieExpired('mp_bot_proof');
        self::assertNotNull($invitation->refresh()->accepted_at);
        self::assertNotNull(BotRiskChallenge::query()->findOrFail($challengeId)->consumed_at);
        try {
            $service->guard($request, $payload['email'], 'ADMIN', 'INVITATION_ACCEPT', [], null, true);
            self::fail('Consumed proof must not be reusable.');
        } catch (AuthenticationException $exception) {
            self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
        }
    }

    public function test_invalid_admin_invitations_never_trigger_security_emails(): void
    {
        [$payload, $invitation] = $this->adminInvitation();
        $payload['bot_protection'] = ['request_email_step_up' => true];
        foreach ([['token' => 'invalid-token'], ['email' => 'other@example.test']] as $changes) {
            $this->webPost('/api/v1/auth/admin-invitations/accept', array_replace($payload, $changes))->assertStatus(410);
        }
        foreach (['expires_at', 'revoked_at', 'accepted_at'] as $field) {
            $invitation->forceFill(['expires_at' => now()->addDay(), 'revoked_at' => null, 'accepted_at' => null, $field => now()->subSecond()])->save();
            $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertStatus(410);
        }
        $inviter = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'SUSPENDED']);
        $invitation->forceFill(['bootstrap' => false, 'invited_by_user_id' => $inviter->getKey(), 'expires_at' => now()->addDay(), 'revoked_at' => null, 'accepted_at' => null])->save();
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertStatus(410);
        self::assertSame(0, $this->gateway->calls);
        $this->assertDatabaseCount('bot_risk_challenges', 0);
        $this->assertDatabaseCount('email_otps', 0);
    }

    public function test_admin_invitation_is_rechecked_after_provider_call_without_holding_locks(): void
    {
        [$payload, $invitation] = $this->adminInvitation();
        $payload['bot_protection'] = ['recaptcha_token' => 'admin-invitation-token'];
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'admin_invitation_accept', 'admin.example.test');
        $transactionLevel = DB::transactionLevel();
        $this->gateway->beforeAssessment = static function () use ($invitation, $transactionLevel): void {
            self::assertSame($transactionLevel, DB::transactionLevel());
            $invitation->forceFill(['revoked_at' => now()])->save();
        };
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertStatus(410);
        self::assertNull($invitation->refresh()->accepted_at);
        self::assertFalse(User::query()->where('email', $payload['email'])->exists());
    }

    public function test_missing_admin_provider_configuration_fails_closed(): void
    {
        [$payload, $invitation] = $this->adminInvitation();
        $payload['bot_protection'] = ['recaptcha_token' => 'admin-token'];
        config()->set('materyalph.bot_protection.site_keys.ADMIN_WEB', '');
        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertStatus(503)->assertJsonPath('errors.0.code', 'BOT_PROTECTION_NOT_CONFIGURED');
        self::assertNull($invitation->refresh()->accepted_at);
        $this->assertDatabaseCount('bot_risk_challenges', 0);
    }

    public function test_admin_login_email_fallback_cannot_replace_authenticator_mfa(): void
    {
        $payload = $this->adminLogin();
        $payload['bot_protection'] = ['request_email_step_up' => true];
        $response = $this->webPost('/api/v1/auth/login', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        $id = (string) $response->json('errors.0.details.challenge_id');
        $proof = $this->app->make(BotProtectionService::class)->verifyChallenge(Request::create('/', 'POST'), $id, $payload['email'], '123456', 'ADMIN');
        $payload['bot_protection'] = [];
        $this->withUnencryptedCookie('mp_bot_proof', $proof->token);
        $this->webPost('/api/v1/auth/login', $payload)->assertOk()->assertJsonPath('data.mfa_required', true)->assertCookieExpired('mp_bot_proof')->assertCookieMissing('mp_access');
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_admin_recovery_uses_its_own_action_and_hides_unknown_accounts(): void
    {
        $this->adminLogin();
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'admin_password_recovery', 'admin.example.test');
        $this->webPost('/api/v1/auth/password/forgot', ['email' => 'admin@example.test', 'portal' => 'ADMIN', 'bot_protection' => ['recaptcha_token' => 'recovery-token']])->assertOk();
        self::assertSame(['recovery-token', 'admin-web-site-key', 'admin_password_recovery'], $this->gateway->lastCall);
        $response = $this->webPost('/api/v1/auth/password/forgot', ['email' => 'unknown-admin@example.test', 'portal' => 'ADMIN', 'bot_protection' => ['request_email_step_up' => true]])->assertForbidden()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        $challenge = BotRiskChallenge::query()->findOrFail($response->json('errors.0.details.challenge_id'));
        self::assertFalse($challenge->delivery_allowed);
        $this->assertDatabaseCount('email_otps', 1);
    }

    public function test_admin_resend_and_native_challenge_routes_enforce_portal_boundaries(): void
    {
        [$payload] = $this->adminInvitation();
        $payload['bot_protection'] = ['request_email_step_up' => true];
        $response = $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)->assertForbidden();
        $id = (string) $response->json('errors.0.details.challenge_id');
        $this->travel(61)->seconds();
        $resendPath = '/api/v1/auth/bot-challenges/'.$id.'/resend';
        $this->webPost($resendPath, ['email' => $payload['email'], 'portal' => 'VENDOR'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_INVALID');
        $this->webPost($resendPath, ['email' => $payload['email'], 'portal' => 'ADMIN'])->assertOk();
        $verifyPath = '/api/v1/mobile/auth/bot-challenges/'.$id.'/verify';
        $this->mobilePost($verifyPath, ['email' => $payload['email'], 'code' => '123456', 'portal' => 'ADMIN'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        $this->mobilePost($verifyPath, ['email' => $payload['email'], 'code' => '123456'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'BOT_STEP_UP_INVALID');
    }

    public function test_admin_suspension_during_assessment_prevents_mfa_challenge(): void
    {
        $payload = $this->adminLogin();
        $payload['bot_protection'] = ['recaptcha_token' => 'admin-login-token'];
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'admin_login', 'admin.example.test');
        $this->gateway->beforeAssessment = static function (): void {
            User::query()->where('email', 'admin@example.test')->update(['account_status' => 'SUSPENDED']);
        };
        $this->webPost('/api/v1/auth/login', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'ACCOUNT_NOT_ACTIVE')->assertCookieMissing('mp_mfa_challenge')->assertCookieMissing('mp_access');
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    /** @return array<string, mixed> */
    private function adminLogin(): array
    {
        User::factory()->create(['email' => 'admin@example.test', 'password' => 'CorrectPassword123', 'account_type' => 'ADMIN', 'account_status' => 'ACTIVE']);

        return ['email' => 'admin@example.test', 'password' => 'CorrectPassword123', 'portal' => 'ADMIN'];
    }

    /** @return array{array<string, mixed>, AdminInvitation} */
    private function adminInvitation(string $email = 'invited-admin@example.test'): array
    {
        $token = bin2hex(random_bytes(32));
        $role = PlatformRole::query()->where('code', 'ADMIN_SUPERADMIN')->sole();
        $invitation = AdminInvitation::query()->create(['normalized_email' => $email, 'platform_role_id' => $role->getKey(), 'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => now()->addDay(), 'bootstrap' => true]);

        return [['token' => $token, 'email' => $email, 'full_name' => 'Invited Admin', 'password' => 'StrongPassword123', 'password_confirmation' => 'StrongPassword123', 'terms_accepted' => true, 'privacy_accepted' => true], $invitation];
    }

    public function test_missing_vendor_provider_configuration_fails_closed(): void
    {
        config()->set('services.recaptcha.api_key', '');

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'checkbox-token',
        ]))->assertStatus(503)
            ->assertJsonPath('errors.0.code', 'BOT_PROTECTION_NOT_CONFIGURED');

        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    /** @param array<string, mixed> $botProtection
     * @return array{array<string, mixed>, string}
     */
    private function vendorInvitation(array $botProtection, string $email = 'invitation@example.test'): array
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Invitation test organization', 'store_name' => 'Invitation test store']);
        $owner = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $owner->getKey(), 'role' => 'OWNER', 'status' => 'ACTIVE']);
        $token = bin2hex(random_bytes(32));
        $id = (string) Str::uuid7();
        DB::table('vendor_invitations')->insert(['id' => $id, 'normalized_email' => $email, 'vendor_organization_id' => $organization->getKey(), 'invited_by_user_id' => $owner->getKey(), 'role' => 'STORE_STAFF', 'can_manage_staff' => false, 'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);

        return [['token' => $token, 'email' => $email, 'full_name' => 'Invited employee', 'password' => 'InvitationPassword123', 'password_confirmation' => 'InvitationPassword123', 'bot_protection' => $botProtection], $id];
    }

    /** @return array<string, mixed> */
    private function buyerRegistration(): array
    {
        $terms = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->where('d.code', 'TERMS_OF_SERVICE')->whereNull('v.retired_at')->first(['v.id', 'v.content_hash']);

        return [
            'terms_version_id' => $terms->id,
            'terms_content_hash' => $terms->content_hash,
            'full_name' => 'Buyer Example',
            'email' => 'buyer@example.test',
            'mobile_e164' => '+639171234567',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'buyer_type' => 'INDIVIDUAL',
            'terms_accepted' => true,
            'privacy_accepted' => true,
        ];
    }

    /** @param array<string, mixed> $botProtection
     * @return array<string, mixed>
     */
    private function vendorRegistration(array $botProtection): array
    {
        return [
            'full_name' => 'Vendor Example',
            'email' => 'vendor@example.test',
            'mobile_e164' => '+639171234568',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'business_name' => 'Example Hardware',
            'terms_accepted' => true,
            'privacy_accepted' => true,
            'bot_protection' => $botProtection,
        ];
    }

    /** @param array<string, mixed> $payload */
    private function mobilePost(string $uri, array $payload): TestResponse
    {
        return $this->postJson($uri, $payload);
    }

    /** @param array<string, mixed> $payload */
    private function webPost(string $uri, array $payload): TestResponse
    {
        return $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson($uri, $payload);
    }
}

final class FakeRecaptchaAssessmentGateway implements RecaptchaAssessmentGateway
{
    public ?RecaptchaAssessmentResult $result = null;

    public bool $unavailable = false;

    public int $calls = 0;

    public ?\Closure $beforeAssessment = null;

    /** @var array{string, string, string}|null */
    public ?array $lastCall = null;

    public function assess(string $token, string $siteKey, string $expectedAction): RecaptchaAssessmentResult
    {
        $this->calls++;
        ($this->beforeAssessment ?? static fn () => null)();
        $this->lastCall = [$token, $siteKey, $expectedAction];
        if ($this->unavailable) {
            throw new RecaptchaProviderUnavailable('Provider unavailable in test.');
        }

        return $this->result ?? throw new \LogicException('A fake assessment result was not configured.');
    }
}
