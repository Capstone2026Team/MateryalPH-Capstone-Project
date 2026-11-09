<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class AutomatedResponseTest extends TestCase
{
    use CreatesDiscoveryFixtures, CreatesOrderFixtures, RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Storage::fake('local');
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    private function configure(): array
    {
        [$store, $owner, $listing] = $this->pickupStore('Static responses');
        $this->putJson('/api/v1/vendor/messaging/automated-response', ['enabled' => true, 'welcome_message' => 'Welcome to our store.',
            'options' => [['label' => 'Store hours', 'response' => 'Monday to Friday, 8 AM to 5 PM.']], 'lock_version' => 0], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $buyer = $this->buyer();
        $chat = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');

        return [$store, $owner, $buyer, $chat];
    }

    private function message(string $chat, string $portal = 'buyers', ?string $key = null): void
    {
        $this->postJson('/api/v1/'.$portal.'/conversations/'.$chat.'/messages', ['body' => 'Hello', 'client_message_id' => $key ?? (string) Str::uuid7()])->assertCreated();
    }

    public function test_buyer_trigger_is_idempotent_capped_at_24_hours_and_stays_open_for_a_human(): void
    {
        Carbon::setTestNow(now()->startOfSecond());
        [, $owner, $buyer, $chat] = $this->configure();
        self::assertSame(0, DB::table('messages')->where('conversation_id', $chat)->count());
        $key = (string) Str::uuid7();
        $this->message($chat, key: $key);
        $this->message($chat, key: $key);
        $this->message($chat);
        self::assertSame(1, DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->count());
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$chat)->assertOk()->assertJsonPath('data.conversation.needs_human_response', true);
        $this->signInBuyer($buyer);
        Carbon::setTestNow(now()->addHours(24));
        $this->message($chat);
        self::assertSame(2, DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->count());
        self::assertSame(0, DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->where('kind', '<>', 'SYSTEM')->count());
    }

    public function test_explicit_buttons_use_saved_text_once_and_manual_reply_ends_the_sequence(): void
    {
        [, $owner, $buyer, $chat] = $this->configure();
        $this->message($chat);
        $welcome = DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->value('id');
        $choice = ['welcome_message_id' => $welcome, 'option_index' => 0, 'client_message_id' => (string) Str::uuid7()];
        $endpoint = '/api/v1/buyers/conversations/'.$chat.'/automated-response';
        $first = $this->postJson($endpoint, $choice)->assertCreated()->json('data.id');
        $this->postJson($endpoint, $choice)->assertCreated()->assertJsonPath('data.id', $first);
        self::assertSame(1, DB::table('messages')->where('conversation_id', $chat)->where('body', 'Monday to Friday, 8 AM to 5 PM.')->count());
        $this->postJson($endpoint, array_replace($choice, ['client_message_id' => (string) Str::uuid7()]))->assertConflict();
        $this->signInStoreMember($owner);
        $this->message($chat, 'vendor');
        $this->getJson('/api/v1/vendor/conversations/'.$chat)->assertOk()->assertJsonPath('data.conversation.needs_human_response', false);
        $this->signInBuyer($buyer);
        $this->message($chat);
        self::assertFalse((bool) DB::table('conversations')->where('id', $chat)->value('automated_sequence_active'));
        self::assertSame(2, DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->count());
    }

    public function test_another_buyer_cannot_select_options_and_disabling_prevents_more_responses(): void
    {
        [, $owner, $buyer, $chat] = $this->configure();
        $this->message($chat);
        $welcome = DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->value('id');
        $choice = ['welcome_message_id' => $welcome, 'option_index' => 0, 'client_message_id' => (string) Str::uuid7()];
        $this->buyer();
        $this->postJson('/api/v1/buyers/conversations/'.$chat.'/automated-response', $choice)->assertNotFound();
        $this->signInStoreMember($owner);
        $settings = $this->getJson('/api/v1/vendor/messaging/automated-response')->assertOk()->json('data');
        $settings['enabled'] = false;
        $this->putJson('/api/v1/vendor/messaging/automated-response', $settings, ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$chat.'/automated-response', $choice)->assertConflict();
        $this->message($chat);
        self::assertSame(1, DB::table('messages')->where('conversation_id', $chat)->whereNotNull('automation')->count());
    }

    public function test_settings_enforce_roles_limit_and_optimistic_versions(): void
    {
        [$store, $owner] = $this->configure();
        $this->signInStoreMember($this->teamMember($store, 'STORE_STAFF'));
        $this->getJson('/api/v1/vendor/messaging/automated-response')->assertForbidden();
        $this->signInStoreMember($owner);
        $settings = ['enabled' => true, 'welcome_message' => 'Hello', 'options' => [], 'lock_version' => 0];
        $this->putJson('/api/v1/vendor/messaging/automated-response', $settings, ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        $settings['lock_version'] = 1;
        $this->putJson('/api/v1/vendor/messaging/automated-response', $settings, ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonCount(0, 'data.options');
        $settings['lock_version'] = 2;
        $settings['options'] = array_map(static fn (int $i): array => ['label' => 'Option '.$i, 'response' => 'Saved text'], range(1, 4));
        $this->putJson('/api/v1/vendor/messaging/automated-response', $settings, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
    }
}
