<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Notifications\NotificationChannel;
use App\Domain\Notifications\NotificationDelivery;
use App\Domain\Notifications\NotificationService;
use App\Domain\Notifications\PushGateway;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Vendors\VendorFileScanner;
use App\Infrastructure\Notifications\FakePushGateway;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Contracts\Broadcasting\Broadcaster;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Mockery;
use PHPUnit\Framework\Attributes\DataProvider;
use RuntimeException;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\TestCase;

final class MessageNotificationsTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Queue::fake();
        Mail::fake();
        Storage::fake('local');
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->app->instance(PushGateway::class, new FakePushGateway);
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    /** @return array{string, User, User} */
    private function conversation(string $purpose = 'SALES'): array
    {
        if ($purpose === 'FULFILLMENT') {
            [$store, $owner, $listing] = $this->pickupStore('Sample Hardware');
            [$buyer, $order] = $this->pickupOrder($store, $listing);
            DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP']);

            return [app(FulfillmentThreadService::class)->ensureForOrder($order), $buyer, $owner];
        }
        [$store, $owner] = $this->activeStore('Sample Hardware', withListing: false);
        $buyer = $this->buyer();
        $id = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $this->buyerProfileId($buyer),
            'vendor_organization_id' => $store->id, 'purpose' => 'SALES', 'context_type' => 'ITEM_BASED',
            'handler_user_id' => $owner->id, 'locked_reference' => '{}', 'created_at' => now(), 'updated_at' => now()]);
        app(ConversationService::class)->participant($id, (int) $buyer->id, 'BUYER');
        app(ConversationService::class)->participant($id, (int) $owner->id, 'OWNER');

        return [$id, $buyer, $owner];
    }

    private function send(string $conversation, User $sender, string $body = 'Synthetic private message'): string
    {
        $buyer = $sender->account_type === 'BUYER';
        $buyer ? $this->signInBuyer($sender) : $this->signInStoreMember($sender);

        return $this->postJson('/api/v1/'.($buyer ? 'buyers' : 'vendor').'/conversations/'.$conversation.'/messages',
            ['body' => $body, 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
    }

    /** @return array<string, array{string}> */
    public static function purposes(): array
    {
        return ['sales' => ['SALES'], 'fulfillment' => ['FULFILLMENT']];
    }

    #[DataProvider('purposes')]
    public function test_vendor_message_creates_a_buyer_notice_and_authorized_conversation_link(string $purpose): void
    {
        [$conversation, $buyer, $owner] = $this->conversation($purpose);
        DB::table('user_profiles')->updateOrInsert(['user_id' => $owner->id],
            ['id' => (string) Str::uuid7(), 'full_name' => 'Juan Cruz', 'created_at' => now(), 'updated_at' => now()]);
        $message = $this->send($conversation, $owner);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertSame((int) $buyer->id, (int) $notice->user_id);
        self::assertSame($message, $notice->resume_key);
        self::assertSame('Juan Cruz · Sample Hardware', $notice->title);
        self::assertSame('Synthetic private message', $notice->body);
        self::assertStringNotContainsString($owner->email, $notice->title);
        DB::table('user_profiles')->where('user_id', $owner->id)->update(['full_name' => 'Changed public name']);
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/notifications')->assertOk()->assertJsonFragment(['id' => $notice->id, 'category' => 'MESSAGES',
            'title' => 'Juan Cruz · Sample Hardware', 'body' => 'Synthetic private message', 'mandatory' => false]);
        $this->postJson('/api/v1/buyers/notifications/'.$notice->id.'/resolve')->assertOk()->assertJsonPath('data.path', '/messages/'.$conversation);
        $other = $this->buyer();
        $this->signInBuyer($other);
        $this->getJson('/api/v1/buyers/notifications')->assertOk()->assertJsonCount(0, 'data');
        $this->postJson('/api/v1/buyers/notifications/'.$notice->id.'/resolve')->assertForbidden();
    }

    public function test_retry_and_rejected_sends_cannot_create_duplicate_or_unauthorized_notices(): void
    {
        [$conversation, , $owner] = $this->conversation();
        $this->signInStoreMember($owner);
        $input = ['body' => 'Synthetic private message', 'client_message_id' => (string) Str::uuid7()];
        $endpoint = '/api/v1/vendor/conversations/'.$conversation.'/messages';
        $message = $this->postJson($endpoint, $input)->assertCreated()->json('data.id');
        $this->postJson($endpoint, $input)->assertCreated()->assertJsonPath('data.id', $message);
        $this->postJson($endpoint, ['body' => 'Changed body', 'client_message_id' => $input['client_message_id']])->assertConflict();
        [, $otherOwner] = $this->activeStore('Other Hardware', withListing: false);
        $this->signInStoreMember($otherOwner);
        $this->postJson($endpoint, ['body' => 'Unauthorized', 'client_message_id' => (string) Str::uuid7()])->assertNotFound();
        self::assertSame(1, DB::table('notifications')->where('category', 'MESSAGES')->count());
        self::assertSame(1, DB::table('messages')->where('conversation_id', $conversation)->count());
    }

    public function test_long_multiline_message_is_previewed_without_changing_immutable_chat_text(): void
    {
        [$conversation, , $owner] = $this->conversation();
        $body = "Cement\n\tready ".str_repeat('🧱', 500);
        $message = $this->send($conversation, $owner, $body);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertStringStartsWith('Cement ready ', $notice->body);
        self::assertStringEndsWith('…', $notice->body);
        self::assertLessThanOrEqual(320, mb_strlen($notice->body));
        self::assertSame($body, DB::table('messages')->where('id', $message)->value('body'));
    }

    public function test_vendor_product_only_message_previews_the_public_product_name(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Sample Hardware');
        $this->buyer();
        $variant = $this->variantIds($listing)[0];
        $conversation = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id, 'listing_variant_id' => $variant],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $message = $this->postJson('/api/v1/vendor/conversations/'.$conversation.'/messages',
            ['product_id' => $variant, 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $product = json_decode(DB::table('messages')->where('id', $message)->value('product_snapshot'), true, flags: JSON_THROW_ON_ERROR);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertSame('Sent a product: '.$product['name'], $notice->body);
        self::assertStringNotContainsString((string) $product['price_centavos'], $notice->body);
    }

    public function test_buyer_and_system_messages_do_not_notify_the_buyer_of_their_own_activity(): void
    {
        [$conversation, $buyer, $owner] = $this->conversation();
        $this->send($conversation, $buyer);
        DB::transaction(fn () => app(ConversationService::class)->append(DB::table('conversations')->where('id', $conversation)->first(), $owner, 'Synthetic system event'));
        self::assertSame(0, DB::table('notifications')->where('category', 'MESSAGES')->count());
    }

    public function test_a_maximum_length_public_store_name_cannot_break_message_submission(): void
    {
        [$conversation, , $owner] = $this->conversation();
        $organization = DB::table('conversations')->where('id', $conversation)->value('vendor_organization_id');
        DB::table('store_profiles')->where('vendor_organization_id', $organization)->update(['public_store_name' => str_repeat('A', 255)]);
        $this->send($conversation, $owner);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertLessThanOrEqual(255, mb_strlen($notice->title));
    }

    public function test_clean_vendor_attachments_notify_once_without_exposing_private_file_names(): void
    {
        [$conversation, , $owner] = $this->conversation();
        $this->signInStoreMember($owner);
        $input = ['file' => UploadedFile::fake()->image('synthetic-private-attachment.png'), 'client_message_id' => (string) Str::uuid7()];
        $endpoint = '/api/v1/vendor/conversations/'.$conversation.'/attachments';
        $this->post($endpoint, $input)->assertCreated();
        $this->post($endpoint, $input)->assertCreated();
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertSame('Sent an attachment', $notice->body);
        self::assertStringNotContainsString('synthetic-private-attachment', $notice->body);
        self::assertSame(1, DB::table('message_attachments')->count());
    }

    public function test_message_and_notification_rollback_together(): void
    {
        [$conversation, , $owner] = $this->conversation();
        try {
            DB::transaction(function () use ($conversation, $owner): void {
                app(ConversationService::class)->append(DB::table('conversations')->where('id', $conversation)->first(), $owner, 'Synthetic rollback', 'TEXT');
                throw new RuntimeException('Synthetic rollback');
            });
            self::fail('The transaction must roll back.');
        } catch (RuntimeException $error) {
            self::assertSame('Synthetic rollback', $error->getMessage());
        }
        self::assertSame(0, DB::table('messages')->where('conversation_id', $conversation)->count());
        self::assertSame(0, DB::table('notifications')->where('category', 'MESSAGES')->count());
    }

    public function test_message_preferences_default_to_in_app_and_push_and_can_be_disabled(): void
    {
        [$conversation, $buyer, $owner] = $this->conversation();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/notifications/preferences')->assertOk()->assertJsonFragment([
            'category' => 'MESSAGES', 'mandatory' => false, 'in_app' => true, 'push' => true, 'email' => false,
        ]);
        $this->putJson('/api/v1/buyers/notifications/preferences', ['category' => 'MESSAGES', 'in_app' => false, 'push' => false, 'email' => false])->assertOk();
        $this->send($conversation, $owner);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        self::assertFalse(NotificationService::enabled($notice, 'PUSH'));
        self::assertFalse(NotificationService::enabled($notice, 'EMAIL'));
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/notifications')->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_message_notice_outbox_refreshes_the_private_buyer_channel_and_sends_push(): void
    {
        [$conversation, $buyer, $owner] = $this->conversation();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/notifications/devices', ['platform' => 'ANDROID', 'token' => 'synthetic-message-device-registration'])->assertCreated();
        $this->send($conversation, $owner);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        config()->set('broadcasting.default', 'reverb');
        $channels = ['private-'.app(NotificationChannel::class)->name($buyer), 'private-'.app(BuyerInboxChannel::class)->name($buyer)];
        $broadcast = Mockery::mock(Broadcaster::class);
        $broadcast->shouldReceive('broadcast')->once()->with($channels, 'notifications.changed', []);
        Broadcast::shouldReceive('connection')->once()->with('reverb')->andReturn($broadcast);
        $event = DB::table('outbox_events')->where('event_type', 'NOTIFICATION_READY')->where('aggregate_id', $notice->id)->value('id');
        app(OutboxProcessor::class)->process($event);
        $delivery = DB::table('notification_deliveries')->where('notification_id', $notice->id)->where('channel', 'PUSH')->sole();
        app(NotificationDelivery::class)->send($delivery->id);
        self::assertSame(1, app(PushGateway::class)->sent);
        $push = app(PushGateway::class)->lastNotification;
        self::assertNotNull($push);
        self::assertSame($notice->id, $push->id);
        self::assertSame($notice->title, $push->title);
        self::assertSame('Synthetic private message', $push->body);
        $this->assertDatabaseHas('notification_deliveries', ['id' => $delivery->id, 'state' => 'SENT']);
        $this->assertDatabaseMissing('notification_deliveries', ['notification_id' => $notice->id, 'channel' => 'EMAIL']);
        Mail::assertNothingSent();
    }

    public function test_reading_the_conversation_clears_only_corresponding_notices_and_skips_stale_push(): void
    {
        [$conversation, $buyer, $owner] = $this->conversation();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/notifications/devices', ['platform' => 'ANDROID', 'token' => 'synthetic-message-device-registration'])->assertCreated();
        $first = $this->send($conversation, $owner);
        $firstNotice = DB::table('notifications')->where('resume_key', $first)->sole();
        app(NotificationService::class)->enqueue($firstNotice->id);
        $second = $this->send($conversation, $owner);
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$conversation.'/read', ['through_message_id' => $first])->assertOk();
        self::assertNotNull(DB::table('notifications')->where('resume_key', $first)->value('read_at'));
        self::assertNull(DB::table('notifications')->where('resume_key', $second)->value('read_at'));
        $delivery = DB::table('notification_deliveries')->where('notification_id', $firstNotice->id)->where('channel', 'PUSH')->sole();
        app(NotificationDelivery::class)->send($delivery->id);
        $this->assertDatabaseHas('notification_deliveries', ['id' => $delivery->id, 'state' => 'SKIPPED']);
        self::assertSame(0, app(PushGateway::class)->sent);
    }

    public function test_queued_message_delivery_rechecks_current_buyer_access(): void
    {
        [$conversation, $buyer, $owner] = $this->conversation();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/notifications/devices', ['platform' => 'ANDROID', 'token' => 'synthetic-message-device-registration'])->assertCreated();
        $this->send($conversation, $owner);
        $notice = DB::table('notifications')->where('category', 'MESSAGES')->sole();
        app(NotificationService::class)->enqueue($notice->id);
        $buyer->update(['account_status' => 'SUSPENDED']);
        $delivery = DB::table('notification_deliveries')->where('notification_id', $notice->id)->where('channel', 'PUSH')->sole();
        app(NotificationDelivery::class)->send($delivery->id);
        $this->assertDatabaseHas('notification_deliveries', ['id' => $delivery->id, 'state' => 'REVOKED']);
        self::assertSame(0, app(PushGateway::class)->sent);
    }
}
