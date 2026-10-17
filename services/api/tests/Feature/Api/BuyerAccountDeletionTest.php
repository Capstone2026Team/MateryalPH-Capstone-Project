<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/** Buyer self-service deletion: retained-record preview, open-obligation blockers, deactivation and the privacy case. */
final class BuyerAccountDeletionTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
        $this->fakePayments();
    }

    public function test_deletion_deactivates_revokes_and_opens_a_privacy_case_without_removing_history(): void
    {
        $buyer = $this->buyer();
        $other = app(TokenSessionService::class)->start($buyer, 'MOBILE', null, null, null);
        app(TotpService::class)->startEnrollment($buyer);
        DB::table('notification_devices')->insert(['id' => (string) Str::uuid7(), 'user_id' => $buyer->id, 'platform' => 'ANDROID', 'environment' => 'TEST',
            'token_hash' => hash('sha256', 'device'), 'sealed_token' => 'sealed', 'last_seen_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        $this->getJson('/api/v1/buyers/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true)
            ->assertJsonPath('data.confirmation_phrase', 'DELETE')->assertJsonPath('data.blockers.active_orders', 0)->assertJsonCount(5, 'data.retained_records');
        $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'DELETE'])->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        $this->reauthenticate($buyer);
        $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'delete'])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'DELETE', 'account_type' => 'ADMIN'])->assertUnprocessable();

        $reference = $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'DELETE'])->assertOk()
            ->assertJsonPath('data.sign_in_required', true)->json('data.reference');
        self::assertMatchesRegularExpression('/^PR-\d{4}-[0-9A-F]{6}$/', $reference);
        $buyer->refresh();
        self::assertSame('DELETED', $buyer->account_status);
        self::assertNotNull($buyer->account_deleted_at);
        self::assertSame(0, AuthSession::query()->where('user_id', $buyer->id)->whereNull('revoked_at')->count());
        self::assertNotNull(AuthSession::query()->findOrFail($other->sessionId)->revoked_at);
        self::assertSame(0, DB::table('notification_devices')->where('user_id', $buyer->id)->whereNull('revoked_at')->count());
        self::assertNotNull(DB::table('totp_factors')->where('user_id', $buyer->id)->value('revoked_at'));
        $this->assertDatabaseHas('privacy_requests', ['user_id' => $buyer->id, 'reference' => $reference, 'request_type' => 'DELETION', 'state' => 'RECEIVED', 'intake_channel' => 'IN_APP']);
        $this->assertDatabaseHas('privacy_request_events', ['actor_user_id' => $buyer->id, 'event' => 'RECEIVED', 'actor_role' => 'BUYER']);
        $this->assertDatabaseHas('audit_logs', ['action' => 'ACCOUNT_DELETED', 'actor_user_id' => $buyer->id]);
        // History is retained: the Buyer profile row still exists.
        self::assertNotNull(DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'));

        $this->getJson('/api/v1/buyers/account/profile')->assertUnauthorized();
        $this->postJson('/api/v1/mobile/auth/login', ['email' => $buyer->email, 'password' => 'password'])->assertForbidden();
    }

    public function test_open_orders_block_deletion_and_closed_orders_do_not(): void
    {
        [$store, , $listing] = $this->pickupStore('Deletion blockers');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->getJson('/api/v1/buyers/account/deletion')->assertOk()->assertJsonPath('data.can_delete', false)->assertJsonPath('data.blockers.active_orders', 1);
        $this->reauthenticate($buyer);
        $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'DELETE'])->assertConflict()
            ->assertJsonPath('errors.0.code', 'ACCOUNT_DELETION_BLOCKED');
        self::assertSame('ACTIVE', $buyer->refresh()->account_status);
        $this->getJson('/api/v1/buyers/account/profile')->assertOk();

        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'EXPIRED', 'terminal_reason_code' => 'PAYMENT_WINDOW_EXPIRED', 'closed_at' => now()]);
        $this->getJson('/api/v1/buyers/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true);
        $this->postJson('/api/v1/buyers/account/deletion', ['confirmation' => 'DELETE'])->assertOk();
        self::assertNotNull(DB::table('orders')->where('id', $orderId)->value('id'), 'Order history is never deleted.');
    }

    public function test_deleted_status_requires_its_deletion_timestamp(): void
    {
        $buyer = $this->buyer();
        $this->expectException(QueryException::class);
        DB::table('users')->where('id', $buyer->id)->update(['account_status' => 'DELETED']);
    }

    private function reauthenticate(User $buyer): void
    {
        AuthSession::query()->where('user_id', $buyer->id)->whereNull('revoked_at')->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
    }
}
