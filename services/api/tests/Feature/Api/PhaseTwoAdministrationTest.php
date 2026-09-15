<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\FinancePolicy;
use App\Domain\Identity\TokenSessionService;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseTwoAdministrationTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_admin_status_change_is_versioned_audited_and_revokes_sessions(): void
    {
        $actor = $this->admin('ADMIN_SUPERADMIN');
        $target = $this->admin('ADMIN_SUPPORT');
        $tokens = app(TokenSessionService::class)->start($target, 'WEB', null, null, null);
        $this->signIn($actor);
        $url = '/api/v1/admin/account/administrators/'.$target->public_id;
        $this->patchJson($url, ['status' => 'SUSPENDED', 'lock_version' => 1, 'reason' => 'Access review'])->assertOk();
        self::assertSame('SUSPENDED', $target->refresh()->account_status);
        self::assertNotNull(AuthSession::query()->findOrFail($tokens->sessionId)->revoked_at);
        $this->assertDatabaseHas('audit_logs', ['actor_user_id' => $actor->getKey(), 'actor_role' => 'ADMIN_SUPERADMIN', 'resource_id' => $target->public_id, 'action' => 'ADMIN_ACCOUNT_CHANGED']);
        $this->patchJson($url, ['status' => 'ACTIVE', 'lock_version' => 1, 'reason' => 'Stale review'])->assertConflict();
        $this->patchJson($url, ['status' => 'ACTIVE', 'lock_version' => 2, 'reason' => 'Review completed'])->assertOk();
        self::assertNotNull(AuthSession::query()->findOrFail($tokens->sessionId)->revoked_at);
    }

    public function test_support_admin_cannot_list_invite_or_change_admins(): void
    {
        $actor = $this->admin('ADMIN_SUPPORT');
        $this->signIn($actor);
        $this->getJson('/api/v1/admin/account/administrators')->assertForbidden();
        $this->getJson('/api/v1/admin/account/roles')->assertForbidden();
        $this->postJson('/api/v1/admin/account/invitations', ['email' => 'staff@example.test', 'role_id' => (string) Str::uuid7()])->assertForbidden();
        $this->patchJson('/api/v1/admin/account/administrators/'.$actor->public_id, ['status' => 'DEACTIVATED', 'lock_version' => 1, 'reason' => 'Review'])->assertForbidden();
        $this->getJson('/api/v1/vendors/account/profile')->assertForbidden();
        $this->getJson('/api/v1/buyers/account/profile')->assertForbidden();
    }

    public function test_admin_changes_require_recent_totp_and_cannot_assign_superadmin(): void
    {
        $actor = $this->admin('ADMIN_SUPERADMIN');
        $target = $this->admin('ADMIN_SUPPORT');
        $session = $this->signIn($actor);
        $url = '/api/v1/admin/account/administrators/'.$target->public_id;
        $input = ['role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'), 'lock_version' => 1, 'reason' => 'Role review'];
        $session->update(['reauthentication_method' => 'PASSWORD']);
        $this->patchJson($url, $input)->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        $session->update(['reauthentication_method' => 'PASSWORD_TOTP']);
        $this->patchJson($url, $input)->assertUnprocessable();
        $this->patchJson('/api/v1/admin/account/administrators/'.$actor->public_id, ['status' => 'SUSPENDED', 'lock_version' => 1, 'reason' => 'Self review'])->assertForbidden();
    }

    public function test_vendor_invitation_rejects_wrong_identity_and_cannot_override_role_or_organization(): void
    {
        [$token, $id] = $this->vendorInvitation();
        $payload = ['token' => $token, 'email' => 'wrong@example.test', 'full_name' => 'Invited employee', 'password' => 'InvitationPassword123', 'password_confirmation' => 'InvitationPassword123'];
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable();
        $payload['email'] = 'invited@example.test';
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload + ['role' => 'OWNER'])->assertUnprocessable();
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertCreated();
        $user = User::query()->where('email', $payload['email'])->firstOrFail();
        self::assertSame('PENDING_VERIFICATION', $user->account_status);
        $this->assertDatabaseHas('vendor_memberships', ['user_id' => $user->getKey(), 'role' => 'STORE_STAFF', 'can_manage_staff' => false]);
        self::assertNotNull(DB::table('vendor_invitations')->where('id', $id)->value('accepted_at'));
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable();
        $this->assertDatabaseCount('auth_sessions', 0);
    }

    public function test_vendor_invitation_rejects_expiry_revocation_and_suspended_inviter(): void
    {
        [$token, $id, $owner] = $this->vendorInvitation();
        $payload = ['token' => $token, 'email' => 'invited@example.test', 'full_name' => 'Invited employee', 'password' => 'InvitationPassword123', 'password_confirmation' => 'InvitationPassword123'];
        DB::table('vendor_invitations')->where('id', $id)->update(['expires_at' => now()->subSecond()]);
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable();
        DB::table('vendor_invitations')->where('id', $id)->update(['expires_at' => now()->addDay(), 'revoked_at' => now()]);
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable();
        DB::table('vendor_invitations')->where('id', $id)->update(['revoked_at' => null]);
        $owner->update(['account_status' => 'SUSPENDED']);
        $this->postJson('/api/v1/auth/vendor-invitations/accept', $payload)->assertUnprocessable();
        self::assertFalse(User::query()->where('email', $payload['email'])->exists());
    }

    public function test_admin_invitation_creates_pending_security_setup_and_is_single_use(): void
    {
        $actor = $this->admin('ADMIN_SUPERADMIN');
        $this->signIn($actor);
        $role = DB::table('platform_roles')->where('code', 'ADMIN_SUPPORT')->value('id');
        $this->withHeader('Idempotency-Key', (string) Str::uuid7());
        $this->postJson('/api/v1/admin/account/invitations', ['email' => ' NewAdmin@example.test ', 'role_id' => $role])->assertStatus(202);
        $this->postJson('/api/v1/admin/account/invitations', ['email' => ' NewAdmin@example.test ', 'role_id' => $role])->assertStatus(202);
        $this->assertDatabaseCount('admin_invitations', 1);
        $invitation = DB::table('admin_invitations')->where('normalized_email', 'newadmin@example.test')->first();
        self::assertNotNull($invitation);
        $sealed = json_decode(DB::table('outbox_events')->where('aggregate_id', $invitation->id)->value('payload'), true);
        $payload = json_decode(Crypt::decryptString($sealed['sealed_payload']), true);
        parse_str(parse_url($payload['invitation_url'], PHP_URL_QUERY), $query);
        $input = ['token' => $query['token'], 'full_name' => 'Invited Admin', 'password' => 'NewAdminPassword123', 'password_confirmation' => 'NewAdminPassword123', 'terms_accepted' => true, 'privacy_accepted' => true];
        $this->postJson('/api/v1/auth/admin-invitations/accept', $input)->assertCreated();
        $user = User::query()->where('email', 'newadmin@example.test')->firstOrFail();
        self::assertSame('ADMIN', $user->account_type);
        self::assertSame('PENDING_VERIFICATION', $user->account_status);
        self::assertNotNull($user->email_verified_at);
        $this->assertDatabaseHas('admin_memberships', ['user_id' => $user->getKey(), 'platform_role_id' => $role, 'status' => 'PENDING', 'invited_by_user_id' => $actor->getKey()]);
        self::assertSame(0, AuthSession::query()->where('user_id', $user->getKey())->count());
        $this->postJson('/api/v1/auth/admin-invitations/accept', $input)->assertStatus(410);
    }

    public function test_finance_requires_distinct_named_reviewers_and_explicit_grants(): void
    {
        $preparer = $this->admin('ADMIN_SUPERADMIN');
        $preparer->update(['name' => 'Finance Preparer']);
        $reviewer = $this->admin('ADMIN_SUPERADMIN');
        $reviewer->update(['name' => 'Finance Reviewer']);
        $support = $this->admin('ADMIN_SUPPORT');
        $policy = app(FinancePolicy::class);
        self::assertFalse($policy->review($preparer, 'finance.review_tax', $preparer->getKey()));
        self::assertTrue($policy->review($reviewer, 'finance.review_tax', $preparer->getKey()));
        self::assertTrue($policy->review($reviewer, 'finance.approve_statements', $preparer->getKey()));
        self::assertFalse($policy->review($support, 'finance.review_tax', $preparer->getKey()));
        self::assertFalse(app(AccountAccess::class)->allows($support, 'materials_analytics.inspect_sources'));
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString(bin2hex(random_bytes(20))), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        foreach (DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->whereIn('d.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE'])->whereNull('v.retired_at')->get(['v.id']) as $agreement) {
            DB::table('agreement_acceptances')->insert([
                'id' => (string) Str::uuid7(),
                'user_id' => $user->getKey(),
                'agreement_version_id' => $agreement->id,
                'vendor_organization_id' => null,
                'source' => 'TEST_FIXTURE',
                'accepted_at' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        return $user;
    }

    private function signIn(User $user): AuthSession
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');

        return $session;
    }

    /** @return array{string, string, User} */
    private function vendorInvitation(): array
    {
        $org = VendorOrganization::query()->create(['legal_name' => 'Invitation test organization', 'store_name' => 'Invitation test store']);
        $owner = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $org->getKey(), 'user_id' => $owner->getKey(), 'role' => 'OWNER', 'status' => 'ACTIVE']);
        $token = bin2hex(random_bytes(32));
        $id = (string) Str::uuid7();
        DB::table('vendor_invitations')->insert(['id' => $id, 'normalized_email' => 'invited@example.test', 'vendor_organization_id' => $org->getKey(), 'invited_by_user_id' => $owner->getKey(), 'role' => 'STORE_STAFF', 'can_manage_staff' => false, 'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);

        return [$token, $id, $owner];
    }
}
