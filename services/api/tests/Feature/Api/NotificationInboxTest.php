<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Notifications\NotificationBroadcast;
use App\Domain\Notifications\NotificationChannel;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\OutboxProcessor;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Broadcasting\Broadcasters\Broadcaster;
use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use Mockery;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\TestCase;

final class NotificationInboxTest extends TestCase
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

    private function notice(User $user, string $title = 'Account security update', string $category = 'SECURITY', string $type = 'ACCOUNT', ?string $resource = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $id, 'user_id' => $user->id, 'category' => $category, 'title' => $title,
            'body' => 'Synthetic retained notice.', 'resource_type' => $type, 'resource_id' => $resource ?? $user->public_id,
            'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    public function test_filtered_bulk_read_retains_all_pages_and_leaves_other_types_and_new_arrivals_unread(): void
    {
        [$store, $owner] = $this->activeStore('Retained inbox', false);
        [, $other] = $this->activeStore('Foreign inbox', false);
        for ($i = 0; $i < 205; $i++) {
            $this->notice($owner);
        }
        $team = $this->notice($owner, 'Team access changed', 'TEAM', 'VENDOR_ORGANIZATION', $store->id);
        $read = $this->notice($owner);
        DB::table('notifications')->where('id', $read)->update(['read_at' => now()->subDay()]);
        $originalRead = DB::table('notifications')->where('id', $read)->value('read_at');
        $foreign = $this->notice($other);
        $arrival = $this->notice($owner);
        $this->signInStoreMember($owner);
        $input = ['through_id' => $read, 'title' => 'Account security update'];
        $this->postJson('/api/v1/vendor/notifications/read-all', $input)->assertOk()
            ->assertJsonPath('data.read', true)->assertJsonPath('data.read_count', 205)->assertJsonStructure(['data' => ['read_at']]);
        self::assertSame(209, DB::table('notifications')->count());
        self::assertSame($originalRead, DB::table('notifications')->where('id', $read)->value('read_at'));
        foreach ([$team, $foreign, $arrival] as $id) {
            self::assertNull(DB::table('notifications')->where('id', $id)->value('read_at'));
        }
        $this->postJson('/api/v1/vendor/notifications/read-all', $input)->assertOk()->assertJsonPath('data.read_count', 0);
        self::assertSame(1, DB::table('audit_logs')->where('action', 'NOTIFICATIONS_MARKED_READ')->count());
        self::assertSame(1, DB::table('outbox_events')->where('event_type', 'NOTIFICATIONS_CHANGED')->count());
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 2);
        $items = [];
        $cursor = null;
        do {
            $page = $this->getJson('/api/v1/vendor/notifications'.($cursor ? '?cursor='.$cursor : ''))->assertOk();
            $items = [...$items, ...$page->json('data')];
            $cursor = $page->json('meta.next_cursor');
        } while ($cursor);
        self::assertCount(208, $items);
        self::assertCount(206, array_filter($items, fn (array $item): bool => $item['read_at'] !== null));
        $this->postJson('/api/v1/vendor/notifications/'.$read.'/resolve')->assertOk()->assertJsonPath('data.path', '/settings');
        $this->assertDatabaseHas('notifications', ['id' => $read, 'body' => 'Synthetic retained notice.']);
    }

    public function test_bulk_read_rechecks_delegation_resource_authorization_and_optional_preferences(): void
    {
        [$store] = $this->activeStore('Scoped inbox', false);
        $manager = $this->storeMember($store, 'STORE_MANAGER');
        DB::table('vendor_memberships')->where('user_id', $manager->id)->update(['can_manage_staff' => true]);
        $team = $this->notice($manager, 'Team access changed', 'TEAM', 'VENDOR_ORGANIZATION', $store->id);
        $optional = $this->notice($manager, 'Optional update', 'MARKETING');
        $missing = $this->notice($manager, 'Order update', 'ORDERS', 'ORDER', (string) Str::uuid7());
        $security = $this->notice($manager);
        DB::table('notification_preferences')->insert(['id' => (string) Str::uuid7(), 'user_id' => $manager->id,
            'category' => 'MARKETING', 'in_app' => false, 'email' => true, 'push' => true, 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($manager);
        DB::table('vendor_memberships')->where('user_id', $manager->id)->update(['can_manage_staff' => false]);
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => $security])->assertOk()->assertJsonPath('data.read_count', 1);
        foreach ([$team, $optional, $missing] as $id) {
            self::assertNull(DB::table('notifications')->where('id', $id)->value('read_at'));
        }
        $this->getJson('/api/v1/vendor/notifications')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $security);
    }

    public function test_category_filter_marks_different_titles_and_retains_archived_notices(): void
    {
        [, $owner] = $this->activeStore('Category inbox', false);
        $first = $this->notice($owner, 'New order request ORD-SYNTHETIC-A', 'ORDERS');
        $second = $this->notice($owner, 'Order ORD-SYNTHETIC-B completed', 'ORDERS');
        $security = $this->notice($owner);
        $arrival = $this->notice($owner, 'New order request ORD-SYNTHETIC-C', 'ORDERS');
        $this->signInStoreMember($owner);
        $input = ['through_id' => $security, 'category' => 'ORDERS'];
        $this->postJson('/api/v1/vendor/notifications/read-all', $input)->assertOk()->assertJsonPath('data.read_count', 2);
        foreach ([$first, $second] as $id) {
            self::assertNotNull(DB::table('notifications')->where('id', $id)->value('read_at'));
        }
        foreach ([$security, $arrival] as $id) {
            self::assertNull(DB::table('notifications')->where('id', $id)->value('read_at'));
        }
        $this->postJson('/api/v1/vendor/notifications/read-all', $input)->assertOk()->assertJsonPath('data.read_count', 0);
        $this->getJson('/api/v1/vendor/notifications')->assertOk()->assertJsonCount(4, 'data');
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 2);
        $this->postJson('/api/v1/vendor/notifications/'.$security.'/read')->assertOk();
        self::assertSame(4, DB::table('notifications')->count());
        self::assertSame(3, DB::table('notifications')->whereNotNull('read_at')->count());
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 1);
        $this->postJson('/api/v1/vendor/notifications/'.$security.'/resolve')->assertOk()->assertJsonPath('data.path', '/settings');
    }

    public function test_bulk_failure_rolls_back_all_batches_and_does_not_publish_an_invalidation(): void
    {
        [, $owner] = $this->activeStore('Atomic inbox', false);
        $through = '';
        for ($i = 0; $i < 205; $i++) {
            $through = $this->notice($owner);
        }
        $this->signInStoreMember($owner);
        DB::listen(static function (QueryExecuted $query): void {
            if (str_contains($query->sql, 'insert into "audit_logs"')) {
                throw new \RuntimeException('Synthetic audit failure.');
            }
        });
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => $through])->assertStatus(500);
        self::assertSame(0, DB::table('notifications')->whereNotNull('read_at')->count());
        self::assertSame(0, DB::table('outbox_events')->where('event_type', 'NOTIFICATIONS_CHANGED')->count());
    }

    public function test_private_realtime_invalidations_have_no_content_and_reauthorize_queued_reads(): void
    {
        [, $owner] = $this->activeStore('Private inbox', false);
        config()->set('broadcasting.default', 'reverb');
        $channel = app(BuyerInboxChannel::class)->name($owner);
        $broadcast = Mockery::mock(Broadcaster::class);
        $broadcast->shouldReceive('broadcast')->once()->with(['private-'.app(NotificationChannel::class)->name($owner), 'private-'.$channel], 'notifications.changed', []);
        Broadcast::shouldReceive('connection')->once()->with('reverb')->andReturn($broadcast);
        $notice = app(NotificationService::class)->record((int) $owner->id, 'SECURITY', 'Account security update', 'Synthetic retained notice.', 'ACCOUNT', $owner->public_id, 'inbox-live-test');
        $ready = DB::table('outbox_events')->where('event_type', 'NOTIFICATION_READY')->value('id');
        app(OutboxProcessor::class)->process($ready);
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/notifications/'.$notice.'/read')->assertOk();
        $changed = DB::table('outbox_events')->where('event_type', 'NOTIFICATIONS_CHANGED')->value('id');
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['status' => 'SUSPENDED']);
        self::assertFalse(app(BuyerInboxChannel::class)->join($owner, substr($channel, strlen('vendor-inbox.'))));
        app(OutboxProcessor::class)->process($changed);
        app(NotificationBroadcast::class)->created($notice);
        $this->assertDatabaseHas('outbox_events', ['id' => $changed, 'attempts' => 0]);
        self::assertNotNull(DB::table('outbox_events')->where('id', $changed)->value('processed_at'));
    }

    public function test_bulk_read_requires_matching_portal_csrf_and_valid_capture(): void
    {
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => (string) Str::uuid7()])->assertUnauthorized();
        [, $owner] = $this->activeStore('Inbox access', false);
        $id = $this->notice($owner);
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/admin/notifications/read-all', ['through_id' => $id])->assertForbidden();
        $this->postJson('/api/v1/vendor/notifications/read-all', [])->assertUnprocessable();
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => 'invalid'])->assertUnprocessable();
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => $id, 'title' => str_repeat('x', 256)])->assertUnprocessable();
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => $id, 'category' => str_repeat('x', 65)])->assertUnprocessable();
        $this->withHeader('X-CSRF-Token', 'incorrect-csrf');
        $this->postJson('/api/v1/vendor/notifications/read-all', ['through_id' => $id])->assertStatus(419);
        self::assertNull(DB::table('notifications')->where('id', $id)->value('read_at'));
    }
}
