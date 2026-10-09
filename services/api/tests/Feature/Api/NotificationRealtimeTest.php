<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Notifications\NotificationBroadcast;
use App\Domain\Notifications\NotificationChannel;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\OutboxProcessor;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Broadcasting\Broadcasters\Broadcaster;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Mockery;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\TestCase;

final class NotificationRealtimeTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Queue::fake();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_all_audiences_count_only_authorized_enabled_unread_notices_and_keep_archived_history(): void
    {
        $foreign = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $this->notice($foreign);
        foreach (['buyers', 'vendor', 'admin'] as $audience) {
            $user = $this->account($audience);
            $securityCount = $audience === 'buyers' ? 55 : 1;
            for ($i = 0; $i < $securityCount; $i++) {
                $this->notice($user);
            }
            $optional = $this->notice($user, 'INVENTORY');
            $archived = $this->notice($user);
            DB::table('notifications')->where('id', $archived)->update(['read_at' => now()->subDay()]);
            $this->notice($user, 'MARKETING');
            $this->notice($user, 'ORDERS', 'ORDER', (string) Str::uuid7());
            $this->disableInApp($user, 'MARKETING');
            $this->signIn($user);
            $this->getJson('/api/v1/'.$audience.'/notifications/unread-count')->assertOk()
                ->assertJsonPath('data.unread_count', $securityCount + 1)->assertJsonPath('errors', [])
                ->assertHeader('Cache-Control', 'no-store, private');
            $this->postJson('/api/v1/'.$audience.'/notifications/read-all', ['through_id' => $archived, 'category' => 'SECURITY'])
                ->assertOk()->assertJsonPath('data.read_count', $securityCount);
            $this->getJson('/api/v1/'.$audience.'/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 1);
            $this->postJson('/api/v1/'.$audience.'/notifications/'.$optional.'/read')->assertOk();
            $this->getJson('/api/v1/'.$audience.'/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 0);
            $items = [];
            $cursor = null;
            do {
                $page = $this->getJson('/api/v1/'.$audience.'/notifications'.($cursor ? '?cursor='.$cursor : ''))->assertOk();
                $items = [...$items, ...$page->json('data')];
                $cursor = $page->json('meta.next_cursor');
            } while ($cursor);
            self::assertCount($securityCount + 2, $items);
            self::assertCount($securityCount + 2, array_filter($items, static fn (array $item): bool => $item['read_at'] !== null));
            $this->assertDatabaseHas('notifications', ['id' => $archived, 'user_id' => $user->id]);
        }
    }

    public function test_realtime_config_is_public_and_each_audience_can_only_sign_its_current_channel(): void
    {
        $this->enableReverb();
        $users = [];
        $channels = [];
        foreach (['buyers', 'vendor', 'admin'] as $audience) {
            $users[$audience] = $this->account($audience);
            $this->signIn($users[$audience]);
            $response = $this->getJson('/api/v1/'.$audience.'/notifications/realtime')->assertOk()
                ->assertJsonPath('data.enabled', true)->assertJsonPath('data.key', 'notification-test-public-key')
                ->assertJsonPath('data.host', 'notify.example.test')->assertJsonPath('data.port', 443)->assertJsonPath('data.scheme', 'https')
                ->assertJsonStructure(['data' => ['enabled', 'key', 'host', 'port', 'scheme', 'inbox_channel']]);
            $channels[$audience] = $response->json('data.inbox_channel');
            self::assertMatchesRegularExpression('/^notifications\.[a-f0-9]{64}$/', $channels[$audience]);
            self::assertStringNotContainsString((string) config('broadcasting.connections.reverb.secret'), $response->getContent());
            self::assertStringNotContainsString($users[$audience]->public_id, $channels[$audience]);
        }
        self::assertCount(3, array_unique($channels));
        foreach ($users as $audience => $user) {
            $this->signIn($user);
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($channels[$audience]))->assertOk()
                ->assertJsonStructure(['data' => ['auth']])->assertJsonPath('errors', []);
            foreach ($channels as $foreignAudience => $foreignChannel) {
                if ($foreignAudience !== $audience) {
                    $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($foreignChannel))->assertForbidden();
                    $this->getJson('/api/v1/'.$foreignAudience.'/notifications/unread-count')->assertForbidden();
                    $this->getJson('/api/v1/'.$foreignAudience.'/notifications/realtime')->assertForbidden();
                }
            }
        }
    }

    public function test_buyer_bearer_transport_validation_and_rest_fallback_remain_available(): void
    {
        $this->getJson('/api/v1/buyers/notifications/unread-count')->assertUnauthorized();
        $this->getJson('/api/v1/buyers/notifications/realtime')->assertUnauthorized();
        $this->postJson('/api/v1/buyers/notifications/auth', $this->subscription('notifications.'.str_repeat('a', 64)))->assertUnauthorized();
        $this->enableReverb();
        $buyer = $this->buyer();
        $this->notice($buyer);
        $tokens = app(TokenSessionService::class)->start($buyer, 'MOBILE', null, null, null);
        $this->app['auth']->forgetGuards();
        $this->flushHeaders();
        $this->withToken($tokens->accessToken);
        $this->getJson('/api/v1/buyers/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 1);
        $channel = $this->getJson('/api/v1/buyers/notifications/realtime')->assertOk()->json('data.inbox_channel');
        $this->postJson('/api/v1/buyers/notifications/auth', $this->subscription($channel))->assertOk()->assertJsonStructure(['data' => ['auth']]);
        $this->postJson('/api/v1/buyers/notifications/auth', [])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/notifications/auth', ['socket_id' => 'invalid', 'channel_name' => 'private-'.$channel])->assertUnprocessable();
        $this->postJson('/api/v1/buyers/notifications/auth', ['socket_id' => '12.34', 'channel_name' => $channel])->assertForbidden();
        config()->set('broadcasting.default', 'null');
        $this->getJson('/api/v1/buyers/notifications/realtime')->assertOk()->assertJsonPath('data.enabled', false);
        $this->postJson('/api/v1/buyers/notifications/auth', $this->subscription($channel))->assertStatus(503);
        $this->getJson('/api/v1/buyers/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 1);
    }

    public function test_vendor_and_admin_cookie_auth_requires_csrf_for_subscriptions(): void
    {
        $this->enableReverb();
        foreach (['vendor', 'admin'] as $audience) {
            $user = $this->account($audience);
            $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
            $this->app['auth']->forgetGuards();
            $this->flushHeaders();
            $this->withUnencryptedCookie('mp_access', $tokens->accessToken);
            $this->getJson('/api/v1/'.$audience.'/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 0);
            $channel = $this->getJson('/api/v1/'.$audience.'/notifications/realtime')->assertOk()->json('data.inbox_channel');
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($channel))->assertStatus(419);
            $this->withHeader('X-CSRF-Token', 'test-csrf');
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($channel))->assertOk()->assertJsonStructure(['data' => ['auth']]);
        }
    }

    public function test_channels_rotate_for_account_membership_and_permission_changes_and_revoke_access(): void
    {
        $this->enableReverb();
        foreach (['buyers', 'vendor', 'admin'] as $audience) {
            $user = $this->account($audience);
            $this->signIn($user);
            $channel = $this->getJson('/api/v1/'.$audience.'/notifications/realtime')->assertOk()->json('data.inbox_channel');
            if ($audience === 'buyers') {
                DB::table('users')->where('id', $user->id)->update(['updated_at' => now()->addMinute()]);
            } elseif ($audience === 'vendor') {
                DB::table('vendor_memberships')->where('user_id', $user->id)->update(['role' => 'STORE_MANAGER']);
            } else {
                $this->notice($user, 'FINANCE_MANDATORY');
                $this->getJson('/api/v1/admin/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 1);
                $permission = DB::table('permissions')->where('code', 'finance.view')->value('id');
                $role = DB::table('admin_memberships')->where('user_id', $user->id)->value('platform_role_id');
                DB::table('role_permissions')->where('platform_role_id', $role)->where('permission_id', $permission)->delete();
                $this->getJson('/api/v1/admin/notifications/unread-count')->assertOk()->assertJsonPath('data.unread_count', 0);
            }
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($channel))->assertForbidden();
            self::assertFalse(app(NotificationChannel::class)->join($user, substr($channel, strlen('notifications.'))));
            $fresh = $this->getJson('/api/v1/'.$audience.'/notifications/realtime')->assertOk()->json('data.inbox_channel');
            self::assertNotSame($channel, $fresh);
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($fresh))->assertOk();
            if ($audience === 'buyers') {
                DB::table('users')->where('id', $user->id)->update(['account_status' => 'SUSPENDED']);
            } else {
                DB::table($audience === 'vendor' ? 'vendor_memberships' : 'admin_memberships')->where('user_id', $user->id)->update(['status' => 'SUSPENDED']);
            }
            self::assertNull(app(NotificationChannel::class)->name($user));
            $this->getJson('/api/v1/'.$audience.'/notifications/unread-count')->assertForbidden();
            $this->getJson('/api/v1/'.$audience.'/notifications/realtime')->assertForbidden();
            $this->postJson('/api/v1/'.$audience.'/notifications/auth', $this->subscription($fresh))->assertForbidden();
        }
    }

    public function test_admin_delivery_uses_content_free_current_channel_and_rechecks_queued_access(): void
    {
        $this->enableReverb();
        $admin = $this->account('admin');
        $channel = app(NotificationChannel::class)->name($admin);
        self::assertNull(app(BuyerInboxChannel::class)->name($admin));
        $broadcast = Mockery::mock(Broadcaster::class);
        $broadcast->shouldReceive('broadcast')->once()->with(['private-'.$channel], 'notifications.changed', []);
        Broadcast::shouldReceive('connection')->twice()->with('reverb')->andReturn($broadcast);
        $notice = app(NotificationService::class)->record((int) $admin->id, 'SECURITY', 'Account security update', 'Synthetic private notice.', 'ACCOUNT', $admin->public_id, 'admin-live-notice');
        $ready = DB::table('outbox_events')->where('event_type', 'NOTIFICATION_READY')->where('aggregate_id', $notice)->value('id');
        app(OutboxProcessor::class)->process($ready);
        $this->signIn($admin);
        $this->postJson('/api/v1/admin/notifications/'.$notice.'/read')->assertOk();
        $changed = DB::table('outbox_events')->where('event_type', 'NOTIFICATIONS_CHANGED')->value('id');
        DB::table('users')->where('id', $admin->id)->update(['updated_at' => now()->addMinute()]);
        $fresh = app(NotificationChannel::class)->name($admin);
        self::assertNotSame($channel, $fresh);
        $broadcast->shouldReceive('broadcast')->once()->with(['private-'.$fresh], 'notifications.changed', []);
        app(OutboxProcessor::class)->process($changed);
        $optional = app(NotificationService::class)->record((int) $admin->id, 'MARKETING', 'Optional update', 'Synthetic optional notice.', 'ACCOUNT', $admin->public_id, 'admin-optional-notice');
        $this->disableInApp($admin, 'MARKETING');
        app(NotificationBroadcast::class)->created($optional);
        app(NotificationBroadcast::class)->publish($admin);
        $revoked = DB::table('outbox_events')->where('event_type', 'NOTIFICATIONS_CHANGED')->whereNull('processed_at')->value('id');
        DB::table('admin_memberships')->where('user_id', $admin->id)->update(['status' => 'SUSPENDED']);
        app(OutboxProcessor::class)->process($revoked);
        app(NotificationBroadcast::class)->created($notice);
        self::assertNull(app(NotificationChannel::class)->name($admin));
        self::assertNotNull(DB::table('outbox_events')->where('id', $revoked)->value('processed_at'));
        $this->assertDatabaseHas('outbox_events', ['id' => $revoked, 'attempts' => 0]);
        $this->assertDatabaseHas('notifications', ['id' => $notice, 'body' => 'Synthetic private notice.']);
    }

    private function account(string $audience): User
    {
        if ($audience === 'buyers') {
            return $this->buyer();
        }
        if ($audience === 'vendor') {
            [, $owner] = $this->activeStore('Notification realtime store', false);

            return $owner;
        }
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id,
            'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString('SYNTHETICADMINFACTOR'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signIn(User $user): void
    {
        if ($user->account_type === 'BUYER') {
            $this->signInBuyer($user);
        } elseif ($user->account_type === 'VENDOR') {
            $this->signInStoreMember($user);
        } else {
            $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
            $session = AuthSession::query()->findOrFail($tokens->sessionId);
            $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
            $this->actingAs($user, 'api');
        }
    }

    private function notice(User $user, string $category = 'SECURITY', string $resourceType = 'ACCOUNT', ?string $resource = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $id, 'user_id' => $user->id, 'category' => $category, 'title' => 'Synthetic notification',
            'body' => 'Synthetic retained notice.', 'resource_type' => $resourceType, 'resource_id' => $resource ?? $user->public_id, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    private function disableInApp(User $user, string $category): void
    {
        DB::table('notification_preferences')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'category' => $category,
            'in_app' => false, 'email' => true, 'push' => true, 'created_at' => now(), 'updated_at' => now()]);
    }

    /** @return array{socket_id: string, channel_name: string} */
    private function subscription(string $channel): array
    {
        return ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel];
    }

    private function enableReverb(): void
    {
        config()->set('broadcasting.default', 'reverb');
        config()->set('broadcasting.connections.reverb.key', 'notification-test-public-key');
        config()->set('broadcasting.connections.reverb.secret', Str::random(40));
        config()->set('broadcasting.connections.reverb.app_id', 'notification-test-app');
        config()->set('reverb.public.host', 'notify.example.test');
        config()->set('reverb.public.port', 443);
        config()->set('reverb.public.scheme', 'https');
    }
}
