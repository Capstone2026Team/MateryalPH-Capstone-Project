<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TutorialProgress;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class TutorialProgressTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_tutorials_require_authentication_and_are_scoped_to_the_current_account(): void
    {
        $this->getJson('/api/v1/buyers/account/tutorials')->assertUnauthorized();
        $first = $this->buyer();
        $this->getJson('/api/v1/buyers/account/tutorials')->assertOk()->assertJsonPath('data', []);
        $this->putJson('/api/v1/buyers/account/tutorials/overview', ['status' => 'COMPLETED'])
            ->assertOk()->assertJsonPath('data.0.tutorial_key', 'overview')->assertJsonPath('data.0.status', 'COMPLETED');
        $this->buyer();
        $this->getJson('/api/v1/buyers/account/tutorials')->assertOk()->assertJsonPath('data', []);
        $this->assertDatabaseHas('user_tutorials', ['user_id' => $first->getKey(), 'status' => 'COMPLETED']);
    }

    public function test_acknowledgments_are_idempotent_and_replays_cannot_downgrade_completion(): void
    {
        $user = $this->buyer();
        $path = '/api/v1/buyers/account/tutorials/overview';
        foreach (['SKIPPED', 'SKIPPED', 'COMPLETED', 'SKIPPED', 'COMPLETED'] as $status) {
            $this->putJson($path, ['status' => $status])->assertOk();
        }
        $this->getJson('/api/v1/buyers/account/tutorials')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.status', 'COMPLETED');
        self::assertSame(2, DB::table('audit_logs')->where('action', 'TUTORIAL_ACKNOWLEDGED')->where('actor_user_id', $user->getKey())->count());
        self::assertSame(1, $user->refresh()->lock_version);
    }

    public function test_tutorial_keys_status_and_input_are_validated_without_changing_profile_or_store_state(): void
    {
        $user = $this->buyer();
        foreach (['store', 'products', 'inventory', 'invoices', 'vehicles', 'tracking', 'dashboard', 'finance', 'unknown'] as $key) {
            $this->putJson('/api/v1/buyers/account/tutorials/'.$key, ['status' => 'COMPLETED'])->assertUnprocessable();
        }
        foreach ([[], ['status' => 'UNSEEN'], ['status' => 'SKIPPED', 'user_id' => $user->public_id]] as $body) {
            $this->putJson('/api/v1/buyers/account/tutorials/overview', $body)->assertUnprocessable();
        }
        $this->putJson('/api/v1/buyers/account/tutorials/projects', ['status' => 'SKIPPED'])->assertOk();
        $this->assertDatabaseCount('user_tutorials', 1);
        self::assertSame('ACTIVE', $user->refresh()->account_status);
        self::assertSame(1, $user->lock_version);
        $this->getJson('/api/v1/vendors/account/tutorials')->assertForbidden();
        $this->getJson('/api/v1/admin/account/tutorials')->assertNotFound();
    }

    public function test_vendor_progress_is_per_person_and_independent_of_organization_setup(): void
    {
        $service = app(TutorialProgress::class);
        $owner = User::factory()->create(['account_type' => 'VENDOR']);
        $staff = User::factory()->create(['account_type' => 'VENDOR']);
        $request = Request::create('/api/v1/vendors/account/tutorials/overview', 'PUT');
        $request->setUserResolver(fn () => $owner);
        $service->acknowledge($request, 'overview', 'SKIPPED');
        self::assertSame('SKIPPED', $service->read($owner)[0]['status']);
        self::assertSame([], $service->read($staff));
        self::assertSame(['overview', 'store', 'products', 'inventory', 'messages', 'orders', 'dashboard', 'fulfillment', 'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions', 'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support'], TutorialProgress::keys('VENDOR'));
        self::assertSame(1, $owner->refresh()->lock_version);
    }

    public function test_vendor_staff_use_the_existing_cookie_csrf_and_role_scoped_account_routes(): void
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Tutorial Test Supply', 'store_name' => 'Tutorial Test Supply']);
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $user->getKey(), 'role' => 'INVENTORY', 'status' => 'ACTIVE']);
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api');
        $this->getJson('/api/v1/vendors/account/tutorials')->assertOk()->assertJsonPath('data', []);
        $this->putJson('/api/v1/vendors/account/tutorials/inventory', ['status' => 'COMPLETED'])->assertStatus(419);
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'tutorial-test-csrf')->withHeader('X-CSRF-Token', 'tutorial-test-csrf');
        $this->putJson('/api/v1/vendors/account/tutorials/inventory', ['status' => 'COMPLETED'])->assertOk()->assertJsonPath('data.0.status', 'COMPLETED');
        $this->putJson('/api/v1/vendors/account/tutorials/discovery', ['status' => 'SKIPPED'])->assertUnprocessable();
        foreach (TutorialProgress::keys('VENDOR') as $key) {
            $this->putJson('/api/v1/vendors/account/tutorials/'.$key, ['status' => 'SKIPPED'])->assertOk();
        }
        $this->getJson('/api/v1/vendors/account/tutorials')->assertOk()->assertJsonCount(23, 'data');
        self::assertSame(1, $organization->refresh()->lock_version);
    }

    public function test_page_key_migration_preserves_existing_user_acknowledgments_on_upgrade_and_rollback(): void
    {
        $service = app(TutorialProgress::class);
        $user = User::factory()->create(['account_type' => 'VENDOR']);
        $request = Request::create('/api/v1/vendors/account/tutorials/vehicles', 'PUT');
        $request->setUserResolver(fn () => $user);
        $service->acknowledge($request, 'overview', 'COMPLETED');
        $service->acknowledge($request, 'vehicles', 'SKIPPED');
        $before = DB::table('user_tutorials')->where('user_id', $user->getKey())->orderBy('tutorial_key')->get()->toJson();
        $migration = require database_path('migrations/2026_11_11_120000_expand_vendor_page_tutorial_keys.php');
        $migration->down();
        self::assertSame($before, DB::table('user_tutorials')->where('user_id', $user->getKey())->orderBy('tutorial_key')->get()->toJson());
        $migration->up();
        self::assertSame($before, DB::table('user_tutorials')->where('user_id', $user->getKey())->orderBy('tutorial_key')->get()->toJson());
        $service->acknowledge($request, 'tracking', 'COMPLETED');
        self::assertCount(3, $service->read($user));
    }

    private function buyer(): User
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $tokens = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['BUYER']]));
        $this->actingAs($user, 'api');

        return $user;
    }
}
