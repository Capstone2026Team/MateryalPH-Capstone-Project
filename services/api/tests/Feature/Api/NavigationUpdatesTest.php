<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Notifications\NavigationBroadcast;
use App\Domain\Notifications\NotificationChannel;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderQueries;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
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
use RuntimeException;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\TestCase;

final class NavigationUpdatesTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Queue::fake();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_buyer_totals_span_pages_exclude_terminal_records_and_use_exact_cart_quantity(): void
    {
        [$store, $owner] = $this->activeStore('Buyer navigation', false);
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('NAV-QUANTITY', [['qty' => '100'], ['qty' => '100'], ['qty' => '100']]);
        $variants = $this->variantIds($listing);
        $buyer = $this->buyer();
        $foreign = $this->buyer();
        $this->signInBuyer($buyer);
        $profile = DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id');
        $cart = (string) Str::uuid7();
        DB::table('carts')->insert(['id' => $cart, 'buyer_profile_id' => $profile, 'lock_version' => 7, 'created_at' => now(), 'updated_at' => now()]);
        foreach (['2.5001', '3.5000', '90.0000'] as $index => $quantity) {
            DB::table('cart_items')->insert(['id' => (string) Str::uuid7(), 'cart_id' => $cart, 'listing_variant_id' => $variants[$index], 'quantity' => $quantity,
                'saved_for_later_at' => $index === 2 ? now() : null, 'created_at' => now(), 'updated_at' => now()]);
        }
        for ($i = 0; $i < 26; $i++) {
            $order = $this->navigationOrder($store, $buyer, 'CONFIRMED');
            $this->navigationCase($store, $buyer, $order, $i === 0 ? 'DECIDED' : 'OPEN_AWAITING_RESPONSE');
        }
        foreach (OrderQueries::VENDOR_GROUPS['CLOSED'] as $state) {
            $order = $this->navigationOrder($store, $buyer, $state);
            $this->navigationCase($store, $buyer, $order, 'RESOLVED');
        }
        $this->navigationOrder($store, $foreign, 'CONFIRMED');
        $this->getJson('/api/v1/buyers/navigation-updates')->assertOk()->assertJsonPath('data.sections./orders', 26)
            ->assertJsonPath('data.sections./disputes', 26)->assertJsonPath('data.cart_quantity', '6.0001')->assertJsonPath('data.cart_version', 7);
        DB::table('orders')->where('buyer_profile_id', $profile)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        DB::table('dispute_cases')->where('buyer_profile_id', $profile)->update(['status' => 'CLOSED_INCONCLUSIVE']);
        DB::table('cart_items')->where('cart_id', $cart)->update(['saved_for_later_at' => now()]);
        $this->getJson('/api/v1/buyers/navigation-updates')->assertOk()->assertJsonPath('data.sections./orders', 0)
            ->assertJsonPath('data.sections./disputes', 0)->assertJsonPath('data.cart_quantity', '0');
    }

    public function test_buyer_message_count_is_received_unread_sales_messages_and_clears_after_read(): void
    {
        [$store, $owner] = $this->activeStore('Message counts', false);
        $buyer = $this->buyer();
        $id = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'),
            'vendor_organization_id' => $store->id, 'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'handler_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $through = '';
        for ($i = 0; $i < 27; $i++) {
            $through = (string) Str::uuid7();
            DB::table('messages')->insert(['id' => $through, 'conversation_id' => $id, 'sender_user_id' => $i === 26 ? $buyer->id : $owner->id,
                'client_message_id' => (string) Str::uuid7(), 'body' => 'Synthetic message', 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->getJson('/api/v1/buyers/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 26);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/read', ['through_message_id' => $through])->assertOk();
        $this->getJson('/api/v1/buyers/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
    }

    public function test_vendor_messages_badge_includes_fulfillment_with_current_role_and_assignment_scope(): void
    {
        [$store, $owner] = $this->activeStore('Fulfillment sidebar', false);
        $buyer = $this->buyer();
        $profile = DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id');
        $sales = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $sales, 'buyer_profile_id' => $profile, 'vendor_organization_id' => $store->id,
            'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'handler_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $order = $this->navigationOrder($store, $buyer, 'CONFIRMED');
        $first = app(FulfillmentThreadService::class)->ensureForOrder($order);
        $historyOrder = $this->navigationOrder($store, $buyer, 'CONFIRMED');
        $second = app(FulfillmentThreadService::class)->ensureForOrder($historyOrder);
        DB::table('orders')->where('id', $historyOrder)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        [$foreignStore] = $this->activeStore('Foreign sidebar store', false);
        $foreign = app(FulfillmentThreadService::class)->ensureForOrder($this->navigationOrder($foreignStore, $buyer, 'CONFIRMED'));
        $through = [];
        foreach ([[$sales, $buyer], [$first, $buyer], [$first, $buyer], [$first, $owner], [$second, $buyer], [$foreign, $buyer]] as [$conversation, $sender]) {
            $through[$conversation] = $id = (string) Str::uuid7();
            DB::table('messages')->insert(['id' => $id, 'conversation_id' => $conversation, 'sender_user_id' => $sender->id,
                'client_message_id' => (string) Str::uuid7(), 'body' => 'Synthetic fulfillment badge message', 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 4);
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.purpose', 'SALES');
        $this->postJson('/api/v1/vendor/conversations/'.$first.'/read', ['through_message_id' => $through[$first]])->assertOk();
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 2);
        $staff = $this->teamMember($store, 'STORE_STAFF');
        DB::table('conversations')->where('id', $sales)->update(['handler_user_id' => $staff->id]);
        app(ConversationService::class)->participant($sales, (int) $staff->id, 'STORE_STAFF');
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 1);
        $assigned = $this->teamMember($store, 'FULFILLMENT');
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'user_id' => $assigned->id,
            'assigned_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($assigned);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 3);
        DB::table('order_fulfillment_assignments')->where('order_id', $order)->update(['ended_at' => now()]);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
        $this->signInStoreMember($owner);
        foreach ([$sales, $second] as $conversation) {
            $this->postJson('/api/v1/vendor/conversations/'.$conversation.'/read', ['through_message_id' => $through[$conversation]])->assertOk();
        }
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
    }

    public function test_buyer_fulfillment_detail_badge_counts_vendor_replies_and_excludes_own_messages(): void
    {
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        [$store, $owner, $listing] = $this->pickupStore('Buyer fulfillment badge');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        $thread = app(FulfillmentThreadService::class)->ensureForOrder($order);
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', ['body' => 'Buyer request', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->getJson('/api/v1/buyers/orders/'.$order)->assertOk()->assertJsonPath('data.fulfillment.thread.unread_count', 0);
        $this->signInStoreMember($owner);
        $reply = $this->postJson('/api/v1/vendor/conversations/'.$thread.'/messages', ['body' => 'Vendor reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$order)->assertOk()->assertJsonPath('data.fulfillment.thread.unread_count', 1);
        $this->getJson('/api/v1/buyers/orders')->assertOk()->assertJsonPath('data.0.fulfillment_conversation.unread_count', 1);
        $this->getJson('/api/v1/buyers/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/read', ['through_message_id' => $reply])->assertOk();
        $this->getJson('/api/v1/buyers/orders/'.$order)->assertOk()->assertJsonPath('data.fulfillment.thread.unread_count', 0);
        $this->signInBuyer($this->buyer());
        $this->getJson('/api/v1/buyers/orders/'.$order)->assertNotFound();
    }

    public function test_admin_pending_counts_follow_current_role_and_status_instead_of_notice_history(): void
    {
        [$first] = $this->activeStore('First pending verification', false);
        [$second] = $this->activeStore('Second pending verification', false);
        DB::table('vendor_organizations')->whereIn('id', [$first->id, $second->id])->update(['store_verification_status' => 'PENDING_VERIFICATION']);
        $admin = $this->navigationAdmin('ADMIN_VENDOR_VERIFICATION');
        $this->getJson('/api/v1/admin/navigation-updates')->assertOk()->assertJsonPath('data.sections./vendor-verification', 2)->assertJsonMissingPath('data.sections./disputes');
        DB::table('vendor_organizations')->where('id', $first->id)->update(['store_verification_status' => 'APPROVED']);
        $this->getJson('/api/v1/admin/navigation-updates')->assertOk()->assertJsonPath('data.sections./vendor-verification', 1);
        DB::table('admin_memberships')->where('user_id', $admin->id)->update(['platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_ORDER_DISPUTE')->value('id')]);
        $this->getJson('/api/v1/admin/navigation-updates')->assertOk()->assertJsonMissingPath('data.sections./vendor-verification');
    }

    public function test_outbox_order_change_signals_current_parties_and_authorized_admins_without_contents(): void
    {
        [$store, $owner] = $this->activeStore('Broadcast navigation', false);
        $buyer = $this->buyer();
        $admin = $this->navigationAdmin('ADMIN_ORDER_DISPUTE');
        $this->navigationAdmin('ADMIN_VENDOR_VERIFICATION');
        $this->activeStore('Unrelated organization', false);
        $id = $this->navigationOrder($store, $buyer, 'CONFIRMED');
        config()->set('broadcasting.default', 'reverb');
        $expected = array_map(fn (User $user): string => 'private-'.app(NotificationChannel::class)->name($user), [$owner, $buyer, $admin]);
        $received = [];
        $broadcaster = Mockery::mock(Broadcaster::class);
        $broadcaster->shouldReceive('broadcast')->times(3)->andReturnUsing(function (array $channels, string $event, array $payload) use (&$received): void {
            self::assertSame('navigation.changed', $event);
            self::assertSame([], $payload);
            $received = [...$received, ...$channels];
        });
        Broadcast::shouldReceive('connection')->with('reverb')->andReturn($broadcaster);
        $event = app(OutboxPublisher::class)->publish('ORDER_STATE_CHANGED', 'ORDER', $id, ['order_id' => $id]);
        app(OutboxProcessor::class)->process($event);
        app(OutboxProcessor::class)->process($event); // A replay emits nothing and never increments counts.
        sort($received);
        sort($expected);
        self::assertSame($expected, $received);
    }

    public function test_queue_invalidations_are_transactional_and_recheck_admin_permissions_at_delivery(): void
    {
        $admin = $this->navigationAdmin('ADMIN_VENDOR_VERIFICATION');
        $before = DB::table('outbox_events')->count();
        DB::beginTransaction();
        app(NavigationBroadcast::class)->fromAudit('VENDOR_VERIFICATION_SUBMITTED', 'VENDOR_ORGANIZATION', (string) Str::uuid7());
        DB::rollBack();
        self::assertSame($before, DB::table('outbox_events')->count());
        app(NavigationBroadcast::class)->fromAudit('VENDOR_VERIFICATION_SUBMITTED', 'VENDOR_ORGANIZATION', (string) Str::uuid7());
        $event = DB::table('outbox_events')->where('event_type', 'NAVIGATION_CHANGED')->first();
        DB::table('admin_memberships')->where('user_id', $admin->id)->update(['platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_ORDER_DISPUTE')->value('id')]);
        config()->set('broadcasting.default', 'reverb');
        Broadcast::shouldReceive('connection')->never();
        app(OutboxProcessor::class)->process($event->id);
        $this->assertDatabaseHas('outbox_events', ['id' => $event->id, 'attempts' => 0]);
    }

    public function test_terminal_job_failure_invalidates_the_admin_queue_without_recursive_failure_jobs(): void
    {
        $event = app(OutboxPublisher::class)->publish('UNSUPPORTED_TEST_JOB', 'SYSTEM', (string) Str::uuid7(), []);
        DB::table('outbox_events')->where('id', $event)->update(['attempts' => OutboxProcessor::MAX_ATTEMPTS - 1]);
        $this->assertThrows(fn () => app(OutboxProcessor::class)->process($event), RuntimeException::class);
        $this->assertDatabaseHas('outbox_events', ['id' => $event, 'attempts' => OutboxProcessor::MAX_ATTEMPTS]);
        $signal = DB::table('outbox_events')->where('event_type', 'NAVIGATION_CHANGED')->where('aggregate_id', $event)->sole();
        $this->navigationAdmin('ADMIN_SUPERADMIN');
        config()->set('broadcasting.default', 'reverb');
        Broadcast::shouldReceive('connection')->once()->andThrow(new RuntimeException('Synthetic unavailable transport'));
        DB::table('outbox_events')->where('id', $signal->id)->update(['attempts' => OutboxProcessor::MAX_ATTEMPTS - 1]);
        $this->assertThrows(fn () => app(OutboxProcessor::class)->process($signal->id), RuntimeException::class);
        self::assertSame(1, DB::table('outbox_events')->where('event_type', 'NAVIGATION_CHANGED')->count());
    }

    private function navigationOrder(VendorOrganization $store, User $buyer, string $state): string
    {
        $id = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $id, 'reference' => 'COUNT-'.$id, 'buyer_profile_id' => DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'),
            'vendor_organization_id' => $store->id, 'procurement_type' => 'ITEM_BASED', 'order_state' => $state, 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE',
            'commercial_total_centavos' => 0, 'closed_at' => in_array($state, OrderQueries::VENDOR_GROUPS['CLOSED'], true) ? now() : null, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    private function navigationCase(VendorOrganization $store, User $buyer, string $order, string $state): void
    {
        $id = (string) Str::uuid7();
        DB::table('dispute_cases')->insert(['id' => $id, 'reference' => 'CASE-'.$id, 'order_id' => $order, 'vendor_organization_id' => $store->id,
            'buyer_profile_id' => DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'), 'status' => $state,
            'filed_by_party' => 'BUYER', 'responding_party' => 'VENDOR', 'description' => 'Synthetic dispute with a sufficient description.',
            'issue_type' => 'WRONG_ITEM', 'requested_remedy' => 'REPLACEMENT', 'response_due_at' => now()->addDays(2), 'created_at' => now(), 'updated_at' => now()]);
    }

    private function navigationAdmin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'),
            'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString(Str::random(32)), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');

        return $user;
    }
}
