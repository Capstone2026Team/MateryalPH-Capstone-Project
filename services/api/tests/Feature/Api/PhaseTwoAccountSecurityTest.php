<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\FinancePolicy;
use App\Domain\Authorization\MembershipPolicy;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\TokenSessionService;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseTwoAccountSecurityTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_profile_ownership_mass_assignment_and_version_conflicts(): void
    {
        [$user] = $this->buyer();
        $this->getJson('/api/v1/buyers/account/profile')->assertOk()->assertJsonPath('data.id', $user->public_id);
        $this->patchJson('/api/v1/buyers/account/profile', ['full_name' => 'Changed name', 'lock_version' => 1, 'account_type' => 'ADMIN'])->assertUnprocessable();
        $this->patchJson('/api/v1/buyers/account/profile', ['full_name' => 'Changed name', 'lock_version' => 1])->assertOk()->assertJsonPath('data.lock_version', 2);
        $this->patchJson('/api/v1/buyers/account/profile', ['full_name' => 'Stale name', 'lock_version' => 1])->assertConflict();
        self::assertSame('BUYER', $user->refresh()->account_type);
        $this->assertDatabaseHas('audit_logs', ['action' => 'PROFILE_UPDATED', 'actor_user_id' => $user->getKey()]);
    }

    public function test_recent_authentication_is_session_bound_and_password_change_revokes_others(): void
    {
        [$user, $current] = $this->buyer();
        $other = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $payload = ['password' => 'NewPasswordLong123', 'password_confirmation' => 'NewPasswordLong123'];
        $this->postJson('/api/v1/buyers/account/password', $payload)->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        $this->postJson('/api/v1/buyers/account/reauthentication', ['password' => 'WrongPassword123'])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/account/reauthentication', ['password' => 'OriginalPassword123'])->assertOk();
        $this->postJson('/api/v1/buyers/account/password', $payload)->assertOk();
        self::assertNotNull(AuthSession::query()->findOrFail($other->sessionId)->revoked_at);
        self::assertNull($current->refresh()->revoked_at);
        self::assertNull($current->reauthenticated_at);
    }

    public function test_sessions_are_owned_and_revocation_blocks_stale_access(): void
    {
        [$user, $current] = $this->buyer();
        $foreign = app(TokenSessionService::class)->start(User::factory()->create(['account_status' => 'ACTIVE']), 'MOBILE', null, null, null);
        $this->getJson('/api/v1/buyers/account/sessions')->assertOk()->assertJsonPath('data.0.current', true)->assertJsonMissingPath('data.0.refresh_token_hash');
        $this->deleteJson('/api/v1/buyers/account/sessions/'.$foreign->sessionId)->assertNotFound();
        $this->postJson('/api/v1/buyers/account/sessions/revoke', ['scope' => 'ALL'])->assertOk();
        $this->getJson('/api/v1/buyers/account/profile')->assertUnauthorized();
        self::assertNotNull($current->refresh()->revoked_at);
    }

    public function test_account_status_and_portal_are_checked_on_every_request(): void
    {
        [$user] = $this->buyer();
        $this->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->getJson('/api/v1/vendors/account/profile')->assertForbidden();
        $this->getJson('/api/v1/admin/account/profile')->assertForbidden();
        $user->update(['account_status' => 'SUSPENDED']);
        $this->getJson('/api/v1/buyers/account/profile')->assertForbidden();
    }

    public function test_vendor_fixed_roles_and_delegation_cannot_escalate(): void
    {
        $access = app(AccountAccess::class);
        foreach (AccountAccess::VENDOR_ROLES as $role) {
            self::assertSame(in_array($role, ['OWNER', 'STORE_MANAGER'], true), in_array('materials_analytics.view_competitors', $access->vendorPermissions($role, true), true));
            self::assertSame($role === 'OWNER', in_array('finance.pay', $access->vendorPermissions($role, true), true));
            self::assertSame(in_array($role, ['OWNER', 'STORE_MANAGER'], true), in_array('auto_accept.configure', $access->vendorPermissions($role, true), true));
            self::assertSame($role === 'INVENTORY', in_array('auto_accept.manage_allotment', $access->vendorPermissions($role, true), true));
        }
        $organization = VendorOrganization::query()->create(['legal_name' => 'Test organization', 'store_name' => 'Test store']);
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $membership = VendorMembership::query()->create(['user_id' => $manager->getKey(), 'vendor_organization_id' => $organization->getKey(), 'role' => 'STORE_MANAGER']);
        $target = VendorMembership::query()->create(['user_id' => User::factory()->create()->getKey(), 'vendor_organization_id' => $organization->getKey(), 'role' => 'STORE_STAFF']);
        self::assertFalse(app(MembershipPolicy::class)->manage($manager, $target));
        $membership->update(['can_manage_staff' => true]);
        self::assertTrue(app(MembershipPolicy::class)->manage($manager, $target));
        self::assertFalse(app(MembershipPolicy::class)->manage($manager, $membership));
        $target->update(['role' => 'STORE_MANAGER']);
        self::assertFalse(app(MembershipPolicy::class)->manage($manager, $target));
        self::assertFalse(app(MembershipPolicy::class)->delegate($manager, $target));
    }

    public function test_auto_accept_authority_is_resolved_from_fixed_membership_roles(): void
    {
        $access = app(AccountAccess::class);
        $organization = VendorOrganization::query()->create(['legal_name' => 'Authority test', 'store_name' => 'Authority test']);
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $membership = VendorMembership::query()->create(['user_id' => $user->getKey(), 'vendor_organization_id' => $organization->getKey(), 'role' => 'STORE_STAFF']);
        foreach (AccountAccess::VENDOR_ROLES as $role) {
            foreach ($role === 'STORE_MANAGER' ? [false, true] : [false] as $delegated) {
                $membership->update(['role' => $role, 'can_manage_staff' => $delegated]);
                self::assertSame(in_array($role, ['OWNER', 'STORE_MANAGER'], true), $access->allows($user, 'auto_accept.configure'));
                self::assertSame($role === 'INVENTORY', $access->allows($user, 'auto_accept.manage_allotment'));
                self::assertSame(in_array($role, ['STORE_STAFF', 'CUSTOMER_SERVICE'], true), $access->allows($user, 'auto_accept.view_outcomes'));
                self::assertFalse($access->allows($user, 'auto_accept.unapproved_operation'));
            }
        }
    }

    public function test_finance_self_review_is_denied_without_superadmin_bypass(): void
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE']);
        $role = DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id');
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => $role, 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        self::assertFalse(app(FinancePolicy::class)->review($user, 'finance.review_tax', $user->getKey()));
        self::assertFalse(app(AccountAccess::class)->allows($user, 'audit.delete'));
    }

    /** @return array{User, AuthSession} */
    public function test_email_reauthentication_cannot_consume_another_requests_code(): void
    {
        [$user, $session] = $this->buyer();
        $code = (string) random_int(100000, 999999);
        $this->mock(OtpCodeGenerator::class)->shouldReceive('sixDigits')->andReturn($code);
        $this->postJson('/api/v1/buyers/account/reauthentication/email')->assertOk();
        $firstId = $session->refresh()->reauthentication_email_otp_id;
        $this->travel(61)->seconds();
        $new = app(EmailOtpService::class)->issue($user->email, 'ACCOUNT_REAUTHENTICATION', $user);
        $this->postJson('/api/v1/buyers/account/reauthentication', ['email_code' => $code])->assertUnprocessable();
        self::assertNull($new->refresh()->consumed_at);
        self::assertNull($session->refresh()->reauthenticated_at);
        self::assertSame($firstId, $session->reauthentication_email_otp_id);
    }

    public function test_email_reauthentication_is_single_use_and_expires(): void
    {
        [$user, $session] = $this->buyer();
        $code = (string) random_int(100000, 999999);
        $this->mock(OtpCodeGenerator::class)->shouldReceive('sixDigits')->andReturn($code);
        $this->postJson('/api/v1/buyers/account/reauthentication/email')->assertOk();
        $this->postJson('/api/v1/buyers/account/reauthentication', ['email_code' => $code])->assertOk();
        self::assertSame('EMAIL', $session->refresh()->reauthentication_method);
        self::assertNull($session->reauthentication_email_otp_id);
        $this->postJson('/api/v1/buyers/account/reauthentication', ['email_code' => $code])->assertUnprocessable();
        $this->travel(16)->minutes();
        $this->postJson('/api/v1/buyers/account/password', ['password' => 'ReplacementPassword123', 'password_confirmation' => 'ReplacementPassword123'])->assertForbidden();
    }

    public function test_primary_email_change_is_bound_to_request_and_revokes_all_sessions(): void
    {
        [$user, $session] = $this->buyer();
        $code = (string) random_int(100000, 999999);
        $this->mock(OtpCodeGenerator::class)->shouldReceive('sixDigits')->andReturn($code);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $other = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $id = $this->postJson('/api/v1/buyers/account/email', ['email' => 'changed@example.test'])->assertOk()->json('data.id');
        $this->postJson('/api/v1/buyers/account/email/confirm', ['id' => (string) Str::uuid7(), 'code' => $code])->assertNotFound();
        $this->postJson('/api/v1/buyers/account/email/confirm', ['id' => $id, 'code' => $code])->assertOk()->assertJsonPath('data.sign_in_required', true);
        self::assertSame('changed@example.test', $user->refresh()->email);
        self::assertNotNull($session->refresh()->revoked_at);
        self::assertNotNull(AuthSession::query()->findOrFail($other->sessionId)->revoked_at);
        $this->assertDatabaseHas('audit_logs', ['action' => 'PRIMARY_EMAIL_CHANGED', 'actor_user_id' => $user->getKey()]);
        $this->getJson('/api/v1/buyers/account/profile')->assertUnauthorized();
    }

    public function test_failed_email_confirmation_commits_attempt_count_without_changing_identity(): void
    {
        [$user, $session] = $this->buyer();
        $original = $user->email;
        $code = (string) random_int(100000, 999998);
        $this->mock(OtpCodeGenerator::class)->shouldReceive('sixDigits')->andReturn($code);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $id = $this->postJson('/api/v1/buyers/account/email', ['email' => 'unconfirmed@example.test'])->assertOk()->json('data.id');
        $this->postJson('/api/v1/buyers/account/email/confirm', ['id' => $id, 'code' => (string) ((int) $code + 1)])->assertUnprocessable();
        $this->assertDatabaseHas('email_otps', ['purpose' => 'PRIMARY_EMAIL_CHANGE', 'attempts' => 1]);
        self::assertSame($original, $user->refresh()->email);
        self::assertNull($session->refresh()->revoked_at);
    }

    /** @return array{User, AuthSession} */
    private function buyer(): array
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'password' => 'OriginalPassword123']);
        $tokens = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['BUYER']]));
        $this->actingAs($user, 'api');

        return [$user, $session];
    }
}
