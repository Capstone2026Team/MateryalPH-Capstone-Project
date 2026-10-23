<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationAccess;
use App\Domain\Messaging\ConversationBroadcast;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Messaging\QuotationTerms;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Contracts\Broadcasting\Broadcaster;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class PhaseNineMessagingTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
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
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    private function inquiry(string $vendor, string $variant): string
    {
        return $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $vendor, 'listing_variant_id' => $variant], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
    }

    private function projectInquiryThread(string $main, string $name): string
    {
        $source = DB::table('conversations')->where('id', $main)->first();
        $id = (string) Str::uuid7();
        $project = (string) Str::uuid7();
        $package = (string) Str::uuid7();
        $version = (string) Str::uuid7();
        DB::table('projects')->insert(['id' => $project, 'buyer_profile_id' => $source->buyer_profile_id,
            'name' => $name, 'status' => 'ACTIVE', 'budget_centavos' => 100000, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('work_packages')->insert(['id' => $package, 'project_id' => $project, 'name' => $name,
            'status' => 'QUOTATION_INQUIRY', 'budget_centavos' => 100000, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('work_package_versions')->insert(['id' => $version, 'work_package_id' => $package, 'version' => 1,
            'content_hash' => hash('sha256', $name), 'locked_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('work_packages')->where('id', $package)->update(['current_version_id' => $version]);
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $source->buyer_profile_id, 'vendor_organization_id' => $source->vendor_organization_id,
            'purpose' => 'SALES', 'context_type' => 'PROJECT_BASED', 'context_id' => $package, 'handler_user_id' => $source->handler_user_id,
            'locked_reference' => json_encode(['version_id' => $version, 'work_package' => ['name' => $name]], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('quotations')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id,
            'buyer_profile_id' => $source->buyer_profile_id, 'vendor_organization_id' => $source->vendor_organization_id,
            'procurement_type' => 'PROJECT_BASED', 'work_package_id' => $package, 'state' => 'DRAFT', 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    public function test_project_picker_and_badges_only_include_open_current_workflows_for_both_portals(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Open inquiry supplier');
        $buyer = $this->buyer();
        $main = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $open = [];
        $history = [];
        $pastDeadline = null;
        foreach (['DRAFT', 'PUBLISHED', 'VIEWED', 'COUNTERED', 'STOCK_REVALIDATION_REQUIRED', 'ACCEPTED', 'EXPIRED', 'REJECTED', 'WITHDRAWN'] as $state) {
            $id = $this->projectInquiryThread($main, $state);
            DB::table('quotations')->where('conversation_id', $id)->update(['state' => $state, 'response_due_at' => now()->addHour()]);
            if (in_array($state, ['ACCEPTED', 'EXPIRED', 'REJECTED', 'WITHDRAWN'], true)) {
                $history[] = $id;
            } else {
                $open[] = $id;
            }
        }
        foreach (['past_deadline', 'old_version', 'selected', 'cancelled', 'draft_package', 'deleted', 'archived', 'completed'] as $reason) {
            $id = $this->projectInquiryThread($main, $reason);
            $package = DB::table('conversations')->where('id', $id)->value('context_id');
            if ($reason === 'past_deadline') {
                $pastDeadline = $id;
                // The expiry worker has not run yet; navigation must still exclude it.
                DB::table('quotations')->where('conversation_id', $id)->update(['state' => 'PUBLISHED', 'response_due_at' => now()]);
            } elseif ($reason === 'old_version') {
                DB::table('work_packages')->where('id', $package)->update(['current_version_id' => null]);
            } elseif ($reason === 'selected') {
                DB::table('work_packages')->where('id', $package)->update(['selected_vendor_organization_id' => $store->id]);
            } elseif ($reason === 'deleted') {
                DB::table('work_packages')->where('id', $package)->update(['status' => 'CANCELLED', 'deleted_at' => now()]);
            } elseif (in_array($reason, ['cancelled', 'draft_package'], true)) {
                DB::table('work_packages')->where('id', $package)->update(['status' => $reason === 'cancelled' ? 'CANCELLED' : 'DRAFT']);
            } else {
                DB::table('projects')->where('id', DB::table('work_packages')->where('id', $package)->value('project_id'))->update(['status' => strtoupper($reason)]);
            }
            $history[] = $id;
        }
        $this->signInStoreMember($owner);
        foreach ([$open[0], $history[0]] as $id) {
            $this->postJson('/api/v1/vendor/conversations/'.$id.'/messages', ['body' => 'Inquiry reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        }
        foreach (['vendor', 'buyers'] as $portal) {
            if ($portal === 'buyers') {
                $this->signInBuyer($buyer);
            }
            $rows = $this->getJson('/api/v1/'.$portal.'/conversations/'.$main.'/project-inquiries')->assertOk()
                ->assertJsonCount(count($open), 'data.items')->assertJsonPath('data.has_more', false)->json('data.items');
            self::assertEqualsCanonicalizing($open, array_column($rows, 'id'));
            $this->getJson('/api/v1/'.$portal.'/conversations/'.$main)->assertOk()
                ->assertJsonPath('data.conversation.project_inquiry_count', count($open))
                ->assertJsonPath('data.conversation.project_unread_count', $portal === 'buyers' ? 1 : 0);
            foreach ($history as $id) {
                // This synthetic deadline-only row has no published version for lazy expiry.
                if ($id === $pastDeadline) {
                    continue;
                }
                $this->getJson('/api/v1/'.$portal.'/conversations/'.$id)->assertOk()->assertJsonPath('data.conversation.id', $id);
            }
        }
    }

    public function test_sales_inbox_groups_item_and_project_inquiries_with_paginated_history_and_separate_receipts(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Grouped inquiries');
        [$buyer] = $this->pickupOrder($store, $listing);
        $main = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $projects = [];
        for ($i = 0; $i < 27; $i++) {
            $projects[] = $this->projectInquiryThread($main, 'Foundation '.$i);
        }
        $project = $projects[26];
        $this->signInStoreMember($owner);
        $mainMessage = $this->postJson('/api/v1/vendor/conversations/'.$main.'/messages', ['body' => 'Item reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $projectMessage = $this->postJson('/api/v1/vendor/conversations/'.$project.'/messages', ['body' => 'Project reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $main);
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $main)
            ->assertJsonPath('data.items.0.last_message_preview', 'Project reply')->assertJsonPath('data.items.0.unread_count', 2);
        $this->postJson('/api/v1/buyers/conversations/'.$main.'/read', ['through_message_id' => $mainMessage])->assertOk();
        $this->getJson('/api/v1/buyers/conversations/'.$main)->assertOk()->assertJsonPath('data.conversation.unread_count', 0)
            ->assertJsonPath('data.conversation.project_unread_count', 1)->assertJsonPath('data.conversation.project_inquiry_count', 27);
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonPath('data.items.0.unread_count', 1);
        $endpoint = '/api/v1/buyers/conversations/'.$main.'/project-inquiries';
        $first = $this->getJson($endpoint)->assertOk()->assertJsonCount(25, 'data.items')->assertJsonPath('data.has_more', true)->json('data.items');
        $second = $this->getJson($endpoint.'?page=2')->assertOk()->assertJsonCount(2, 'data.items')->assertJsonPath('data.has_more', false)->json('data.items');
        self::assertCount(27, array_unique(array_column([...$first, ...$second], 'id')));
        $this->getJson($endpoint.'?page=0')->assertUnprocessable();
        $this->getJson('/api/v1/buyers/conversations/'.$project)->assertOk()->assertJsonPath('data.conversation.main_conversation_id', $main)
            ->assertJsonPath('data.conversation.inquiry_label', 'Foundation 26')->assertJsonCount(1, 'data.messages.items');
        $this->putJson('/api/v1/buyers/conversations/'.$main.'/archive')->assertOk();
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(0, 'data.items');
        $this->getJson('/api/v1/buyers/conversations?archived=true')->assertOk()->assertJsonCount(1, 'data.items');
        $this->deleteJson('/api/v1/buyers/conversations/'.$project.'/archive')->assertOk();
        self::assertSame(0, DB::table('conversation_archives')->count());
        $this->putJson('/api/v1/buyers/conversations/'.$main.'/archive')->assertOk();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$project.'/messages', ['body' => 'Project update', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        self::assertSame(0, DB::table('conversation_archives')->count());
        self::assertSame($project, DB::table('messages')->where('id', $projectMessage)->value('conversation_id'));
        $this->buyer();
        $this->getJson($endpoint)->assertNotFound();
    }

    public function test_grouped_project_navigation_never_exposes_another_handlers_threads(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Scoped grouped inquiries');
        $this->buyer();
        $main = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $project = $this->projectInquiryThread($main, 'Assigned foundation');
        $hidden = $this->projectInquiryThread($main, 'Private sibling');
        $staff = $this->teamMember($store, 'CUSTOMER_SERVICE');
        DB::table('conversations')->where('id', $project)->update(['handler_user_id' => $staff->id]);
        app(ConversationService::class)->participant($project, (int) $staff->id, 'CUSTOMER_SERVICE');
        $this->postJson('/api/v1/buyers/conversations/'.$hidden.'/messages', ['body' => 'Private sibling message', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $project)
            ->assertJsonPath('data.items.0.unread_count', 0)->assertJsonPath('data.items.0.project_inquiry_count', 1)->assertJsonPath('data.items.0.main_conversation_id', null);
        $endpoint = '/api/v1/vendor/conversations/'.$project.'/project-inquiries';
        $this->getJson($endpoint)->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $project);
        $this->getJson('/api/v1/vendor/conversations/'.$main.'/project-inquiries')->assertNotFound();
        $this->getJson('/api/v1/vendor/conversations/'.$hidden)->assertNotFound();
        DB::table('conversation_participants')->where('conversation_id', $project)->where('user_id', $staff->id)->update(['revoked_at' => now()]);
        $this->getJson($endpoint)->assertNotFound();
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(0, 'data.items');
        $this->signInStoreMember($this->teamMember($store, 'FULFILLMENT'));
        $this->getJson($endpoint)->assertNotFound();
        [$other, $otherOwner] = $this->pickupStore('Other scoped store');
        $this->signInStoreMember($otherOwner);
        $this->getJson($endpoint)->assertNotFound();
    }

    public function test_project_only_backfill_adds_one_main_thread_without_moving_history(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Project-only store');
        $buyer = $this->buyer();
        $project = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        DB::table('conversations')->where('id', $project)->update(['context_type' => 'PROJECT_BASED']);
        $message = $this->postJson('/api/v1/buyers/conversations/'.$project.'/messages', ['body' => 'Keep project history', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->putJson('/api/v1/buyers/conversations/'.$project.'/archive')->assertOk();
        $activity = now()->subDays(3)->toDateTimeString();
        DB::table('conversations')->where('id', $project)->update(['updated_at' => $activity]);
        $migration = require database_path('migrations/2026_10_15_000000_add_main_store_threads_for_project_inquiries.php');
        $migration->up();
        $migration->up();
        $main = DB::table('conversations')->where('context_type', 'ITEM_BASED')->value('id');
        self::assertNotNull($main);
        self::assertSame(2, DB::table('conversations')->count());
        self::assertSame($project, DB::table('messages')->where('id', $message)->value('conversation_id'));
        self::assertTrue(Carbon::parse($activity)->equalTo(DB::table('conversations')->where('id', $main)->value('updated_at')));
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(0, 'data.items');
        $this->getJson('/api/v1/buyers/conversations?archived=true')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $main);
        $this->deleteJson('/api/v1/buyers/conversations/'.$main.'/archive')->assertOk();
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $main);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$main)->assertOk();
        $migration->down();
        self::assertSame(2, DB::table('conversations')->count());
    }

    public function test_project_invalidation_refreshes_only_currently_authorized_main_thread_viewers(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Grouped invalidation');
        $buyer = $this->buyer();
        $main = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $project = $this->projectInquiryThread($main, 'Foundation');
        $staff = $this->teamMember($store, 'CUSTOMER_SERVICE');
        DB::table('conversations')->where('id', $main)->update(['handler_user_id' => $staff->id]);
        app(ConversationService::class)->participant($main, (int) $staff->id, 'CUSTOMER_SERVICE');
        config()->set('broadcasting.default', 'reverb');
        $broadcast = \Mockery::mock(Broadcaster::class);
        Broadcast::shouldReceive('connection')->with('reverb')->andReturn($broadcast);
        $access = app(ConversationAccess::class);
        $mainThread = DB::table('conversations')->where('id', $main)->first();
        $projectThread = DB::table('conversations')->where('id', $project)->first();
        foreach ([$buyer, $owner] as $viewer) {
            $broadcast->shouldReceive('broadcast')->with(['private-'.$access->channel($viewer, $mainThread)], 'conversation.changed', ['conversation_id' => $main])->once();
            $broadcast->shouldReceive('broadcast')->with(['private-'.$access->channel($viewer, $projectThread)], 'conversation.changed', ['conversation_id' => $project])->once();
            $broadcast->shouldReceive('broadcast')->with(['private-'.app(BuyerInboxChannel::class)->name($viewer)], 'inbox.changed', [])->once();
        }
        // The main handler cannot see this project; it produces no invalidation to that handler.
        app(ConversationBroadcast::class)->deliver($project);
    }

    public function test_vendor_fulfillment_list_is_buyer_scoped_paginated_and_preserves_closed_history(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Fulfillment list');
        [$buyer, $firstOrder] = $this->pickupOrder($store, $listing);
        $sales = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $endpoint = '/api/v1/vendor/conversations/'.$sales.'/fulfillment-conversations';
        $this->signInStoreMember($owner);
        $before = DB::table('conversations')->count();
        // The first order's thread opened at submission (approved 2026-10-10).
        $this->getJson($endpoint)->assertOk()->assertJsonCount(1, 'data.items');
        self::assertSame($before, DB::table('conversations')->count());
        $active = [];
        $history = [];
        for ($i = 0; $i < 28; $i++) {
            $order = $i === 0 ? $firstOrder : $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']], $buyer)[1];
            DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP', 'procurement_type' => $i === 1 ? 'PROJECT_BASED' : 'ITEM_BASED']);
            $id = app(FulfillmentThreadService::class)->ensureForOrder($order);
            if ($i < 26) {
                $active[] = $id;
                DB::table('conversations')->where('id', $id)->update(['updated_at' => now()->subDay()]);
            } else {
                $state = $i === 26 ? 'COMPLETED' : 'CANCELLED';
                DB::table('orders')->where('id', $order)->update(['order_state' => $state]);
                $history[] = $id;
            }
        }
        rsort($active);
        rsort($history);
        $this->signInBuyer($buyer);
        $originalUpdatedAt = DB::table('conversations')->where('id', $active[25])->value('updated_at');
        $this->postJson('/api/v1/buyers/conversations/'.$active[25].'/messages', ['body' => 'Message on the second page', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        DB::table('conversations')->where('id', $active[25])->update(['updated_at' => $originalUpdatedAt]);
        // Other buyers and other vendors never enter this account-linked list.
        [, $otherBuyerOrder] = $this->pickupOrder($store, $listing);
        [$otherStore, $otherOwner, $otherListing] = $this->pickupStore('Other fulfillment store');
        [, $otherStoreOrder] = $this->pickupOrder($otherStore, $otherListing, buyer: $buyer);
        foreach ([$otherBuyerOrder, $otherStoreOrder] as $order) {
            DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP']);
            app(FulfillmentThreadService::class)->ensureForOrder($order);
        }
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$sales)->assertOk()->assertJsonPath('data.conversation.can_list_fulfillment_conversations', true)
            ->assertJsonPath('data.conversation.fulfillment_unread_count', 1);
        $first = $this->getJson($endpoint)->assertOk()->assertJsonCount(25, 'data.items')->assertJsonPath('data.has_more', true)->json('data.items');
        self::assertSame(array_slice($active, 0, 25), array_column($first, 'conversation_id'));
        $second = $this->getJson($endpoint.'?page=2')->assertOk()->assertJsonCount(3, 'data.items')->assertJsonPath('data.has_more', false)->json('data.items');
        self::assertSame([$active[25], ...$history], array_column($second, 'conversation_id'));
        self::assertFalse($second[0]['read_only']);
        self::assertSame(1, $second[0]['unread_count']);
        self::assertTrue($second[1]['read_only']);
        self::assertTrue($second[2]['read_only']);
        $this->getJson($endpoint.'?page=0')->assertUnprocessable();
        $this->getJson('/api/v1/vendor/conversations/'.$active[0].'/fulfillment-conversations')->assertForbidden();
        foreach ($history as $id) {
            $this->getJson('/api/v1/vendor/conversations/'.$id)->assertOk()->assertJsonPath('data.conversation.read_only', true);
            $this->postJson('/api/v1/vendor/conversations/'.$id.'/messages', ['body' => 'Closed', 'client_message_id' => (string) Str::uuid7()])->assertConflict();
        }
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $this->signInStoreMember($manager);
        $this->getJson($endpoint)->assertOk();
        DB::table('vendor_memberships')->where('user_id', $manager->id)->update(['role' => 'STORE_STAFF']);
        $this->getJson($endpoint)->assertNotFound();
        $staff = $this->teamMember($store, 'STORE_STAFF');
        DB::table('conversations')->where('id', $sales)->update(['handler_user_id' => $staff->id]);
        app(ConversationService::class)->participant($sales, (int) $staff->id, 'STORE_STAFF');
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/conversations/'.$sales)->assertOk()->assertJsonPath('data.conversation.can_list_fulfillment_conversations', false);
        $this->getJson('/api/v1/vendor/conversations/'.$sales)->assertOk()->assertJsonPath('data.conversation.fulfillment_unread_count', 0);
        $this->getJson($endpoint)->assertForbidden();
        $this->signInStoreMember($this->teamMember($store, 'FULFILLMENT'));
        $this->getJson($endpoint)->assertNotFound();
        $this->signInStoreMember($otherOwner);
        $this->getJson($endpoint)->assertNotFound();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations/'.$sales)->assertOk()->assertJsonPath('data.conversation.can_list_fulfillment_conversations', false);
        $this->getJson('/api/v1/buyers/conversations/'.$sales)->assertOk()->assertJsonPath('data.conversation.fulfillment_unread_count', 0);
        $this->getJson('/api/v1/buyers/conversations/'.$sales.'/fulfillment-conversations')->assertNotFound();
    }

    public function test_fulfillment_badges_count_only_received_unread_messages_for_the_authorized_buyer_and_store(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Fulfillment badges');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        $sales = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $thread = app(FulfillmentThreadService::class)->ensureForOrder($order);
        $input = ['body' => 'When can I pick up?', 'client_message_id' => (string) Str::uuid7()];
        $message = $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', $input)->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', $input)->assertCreated()->assertJsonPath('data.id', $message);
        $this->postJson('/api/v1/buyers/conversations/'.$sales.'/messages', ['body' => 'A sales inquiry', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        [, $historyOrder] = $this->pickupOrder($store, $listing, buyer: $buyer);
        $history = app(FulfillmentThreadService::class)->ensureForOrder($historyOrder);
        $historyMessage = $this->postJson('/api/v1/buyers/conversations/'.$history.'/messages', ['body' => 'Thank you', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        DB::table('orders')->where('id', $historyOrder)->update(['order_state' => 'COMPLETED']);
        [, $otherOrder] = $this->pickupOrder($store, $listing);
        $other = app(FulfillmentThreadService::class)->ensureForOrder($otherOrder);
        $this->postJson('/api/v1/buyers/conversations/'.$other.'/messages', ['body' => 'Other buyer', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        [$otherStore, , $otherListing] = $this->pickupStore('Other badge store');
        [, $otherStoreOrder] = $this->pickupOrder($otherStore, $otherListing, buyer: $buyer);
        $otherStoreThread = app(FulfillmentThreadService::class)->ensureForOrder($otherStoreOrder);
        $this->postJson('/api/v1/buyers/conversations/'.$otherStoreThread.'/messages', ['body' => 'Other store', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$thread.'/messages', ['body' => 'We are preparing it', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertOk()->assertJsonPath('data.conversation.unread_count', 1);
        $header = '/api/v1/vendor/conversations/'.$sales;
        $this->getJson($header)->assertOk()->assertJsonPath('data.conversation.fulfillment_unread_count', 2);
        $this->postJson('/api/v1/vendor/conversations/'.$thread.'/read', ['through_message_id' => $message])->assertOk();
        $this->getJson($header)->assertOk()->assertJsonPath('data.conversation.fulfillment_unread_count', 1);
        $this->postJson('/api/v1/vendor/conversations/'.$history.'/read', ['through_message_id' => $historyMessage])->assertOk();
        $this->postJson('/api/v1/vendor/conversations/'.$history.'/read', ['through_message_id' => $historyMessage])->assertOk();
        $this->getJson($header)->assertOk()->assertJsonPath('data.conversation.fulfillment_unread_count', 0);
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertOk()->assertJsonPath('data.conversation.unread_count', 0);
    }

    public function test_store_chat_can_start_later_quotations_without_mutating_accepted_terms_or_replaying_into_another_order(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Repeat quotations', [['price' => 1800, 'qty' => '50']]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $vendorPath = '/api/v1/vendor/conversations/'.$id.'/quotation';
        $buyerPath = '/api/v1/buyers/conversations/'.$id.'/quotation';
        $this->signInStoreMember($owner);
        $first = $this->publishQuote($id, $this->draftInput($variant));
        $v = $first['versions'][0];
        $this->postJson($vendorPath.'/start', ['lock_version' => $first['quotation']['lock_version']], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        $this->signInBuyer($buyer);
        $acceptKey = (string) Str::uuid7();
        $decision = ['version_id' => $v['id'], 'content_hash' => $v['content_hash'], 'payment_method' => 'ONLINE'];
        $order = $this->postJson($buyerPath.'/accept', $decision, ['Idempotency-Key' => $acceptKey])->assertOk()->json('data.order_id');
        $frozen = DB::table('quotation_versions')->where('id', $v['id'])->first();
        $accepted = DB::table('quotations')->where('id', $first['quotation']['id'])->first();
        $this->signInStoreMember($owner);
        $startKey = (string) Str::uuid7();
        $next = $this->postJson($vendorPath.'/start', ['lock_version' => $accepted->lock_version], ['Idempotency-Key' => $startKey])->assertOk()
            ->assertJsonPath('data.versions.0.state', 'ACCEPTED')->assertJsonPath('data.versions.0.accepted_order_id', $order)->json('data');
        $this->postJson($vendorPath.'/start', ['lock_version' => $accepted->lock_version], ['Idempotency-Key' => $startKey])->assertOk()->assertJsonPath('data.quotation.id', $next['quotation']['id']);
        self::assertNotSame($accepted->id, $next['quotation']['id']);
        self::assertSame((int) $accepted->lock_version + 1, $next['quotation']['lock_version']);
        $this->putJson($vendorPath.'/draft', ['lock_version' => $accepted->lock_version, 'draft' => $this->draftInput($variant)])->assertConflict();
        $saved = $this->putJson($vendorPath.'/draft', ['lock_version' => $next['quotation']['lock_version'], 'draft' => $this->draftInput($variant)])->assertOk()->json('data.quotation.lock_version');
        $later = $this->postJson($vendorPath.'/publish', ['lock_version' => $saved], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.versions.0');
        $this->signInBuyer($buyer);
        $this->postJson($buyerPath.'/accept', $decision, ['Idempotency-Key' => $acceptKey])->assertOk()->assertJsonPath('data.order_id', $order);
        $this->postJson($buyerPath.'/accept', $decision, ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        $secondOrder = $this->postJson($buyerPath.'/accept', ['version_id' => $later['id'], 'content_hash' => $later['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertNotSame($order, $secondOrder);
        self::assertEquals($frozen, DB::table('quotation_versions')->where('id', $v['id'])->first());
        self::assertEquals($accepted, DB::table('quotations')->where('id', $accepted->id)->first());
        self::assertSame(2, DB::table('quotations')->where('conversation_id', $id)->count());
        self::assertSame(1, DB::table('conversations')->where('purpose', 'SALES')->count());
        // Each accepted order has its own Fulfillment Messages thread, separate from the sales chat.
        self::assertSame([$order, $secondOrder], DB::table('conversations')->where('purpose', 'FULFILLMENT')->orderBy('created_at')->orderBy('id')->pluck('order_id')->all());
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->assertJsonPath('data.quotations.versions.1.accepted_order_id', $order);
        $this->signInStoreMember($owner);
        DB::table('conversations')->where('id', $id)->update(['context_type' => 'PROJECT_BASED']);
        $this->postJson($vendorPath.'/start', ['lock_version' => 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
    }

    public function test_order_accepted_from_a_chat_quotation_opens_without_the_quotation_diff_as_order_changes(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Quotation order details', [['price' => 1800, 'qty' => '50']]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $version = $this->publishQuote($id, $this->draftInput($variant))['versions'][0];
        self::assertNotSame([], $version['content']['changes'], 'The quotation itself still shows the Buyer what changed.');
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $version['id'], 'content_hash' => $version['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertOk()->json('data.order_id');

        // The snapshot keeps the accepted quotation intact; order details only report order-shaped changes.
        $detail = $this->getJson('/api/v1/buyers/orders/'.$order)->assertOk()->json('data');
        self::assertSame([], $detail['changes']);
        // The Buyer's chat location is not the destination of a Self-Pickup order.
        self::assertSame('PICKUP', $detail['destination']['type']);
        self::assertSame('PICKUP', json_decode((string) DB::table('orders')->where('id', $order)->value('destination'), true)['type']);
        self::assertContains($detail['destination']['heavy_vehicle_restriction'] ?? null, [null, 'YES', 'NO']);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/orders/'.$order)->assertOk()->assertJsonPath('data.changes', []);
    }

    public function test_message_sender_names_follow_profile_edits_without_rewriting_history_or_handler_attribution(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Current sender names');
        $staff = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $this->patchJson('/api/v1/vendors/account/profile', ['full_name' => 'Original Owner', 'lock_version' => $owner->fresh()->lock_version])->assertOk();
        $buyer = $this->buyer();
        $this->patchJson('/api/v1/buyers/account/profile', ['full_name' => 'Original Buyer', 'lock_version' => $buyer->fresh()->lock_version])->assertOk();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $buyerPath = '/api/v1/buyers/conversations/'.$id;
        $vendorPath = '/api/v1/vendor/conversations/'.$id;
        $buyerMessage = $this->postJson($buyerPath.'/messages', ['body' => 'Buyer inquiry', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInStoreMember($owner->fresh());
        $ownerMessage = $this->postJson($vendorPath.'/messages', ['body' => 'Owner reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->postJson($vendorPath.'/transfer', ['handler_user_id' => $staff->id, 'lock_version' => 1, 'reason' => 'Sales assistance'])->assertOk();
        $history = DB::table('messages')->where('conversation_id', $id)->orderBy('id')->get()->all();
        $this->getJson($vendorPath)->assertOk()->assertJsonPath('data.messages.items.1.sender.display_name', 'Original Owner');

        $this->patchJson('/api/v1/vendors/account/profile', ['full_name' => 'Updated Owner', 'lock_version' => $owner->fresh()->lock_version])->assertOk();
        $newMessage = $this->postJson($vendorPath.'/messages', ['body' => 'New owner reply', 'client_message_id' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInBuyer($buyer->fresh());
        $this->patchJson('/api/v1/buyers/account/profile', ['full_name' => 'Updated Buyer', 'lock_version' => $buyer->fresh()->lock_version])->assertOk();

        foreach ([$buyerPath, $vendorPath] as $path) {
            if ($path === $vendorPath) {
                $this->signInStoreMember($owner->fresh());
            }
            foreach (['', '?before='.$newMessage] as $cursor) {
                $response = $this->getJson($path.$cursor)->assertOk()
                    ->assertJsonPath('data.messages.items.0.id', $buyerMessage)
                    ->assertJsonPath('data.messages.items.0.sender.display_name', 'Updated Buyer')
                    ->assertJsonPath('data.messages.items.0.sender.role', 'BUYER')
                    ->assertJsonPath('data.messages.items.1.id', $ownerMessage)
                    ->assertJsonPath('data.messages.items.1.sender.display_name', 'Updated Owner')
                    ->assertJsonPath('data.messages.items.1.sender.role', 'OWNER')
                    ->assertJsonPath('data.messages.items.2.kind', 'SYSTEM')
                    ->assertJsonPath('data.messages.items.2.sender.display_name', 'MateryalPH')
                    ->assertJsonPath('data.messages.items.2.sender.role', 'SYSTEM');
                if ($cursor === '') {
                    $response->assertJsonPath('data.messages.items.3.sender.display_name', 'Updated Owner');
                }
                foreach ($response->json('data.messages.items') as $message) {
                    self::assertEqualsCanonicalizing(['avatar_path', 'display_name', 'role'], array_keys($message['sender']));
                }
            }
        }
        self::assertEquals($history, DB::table('messages')->whereIn('id', array_column($history, 'id'))->orderBy('id')->get()->all());
        DB::table('user_profiles')->where('user_id', $owner->id)->delete();
        $this->getJson($vendorPath)->assertOk()
            ->assertJsonPath('data.messages.items.1.sender.display_name', 'Original Owner')
            ->assertJsonPath('data.messages.items.3.sender.display_name', 'Updated Owner');
        $this->buyer();
        $this->getJson($buyerPath)->assertNotFound();
    }

    public function test_inboxes_with_real_profiles_use_user_photo_storage_and_allow_product_free_reuse(): void
    {
        [$store, $owner] = $this->pickupStore('Profile regression');
        $buyer = $this->buyer();
        foreach ([$owner, $buyer] as $user) {
            DB::table('user_profiles')->updateOrInsert(['user_id' => $user->id], ['id' => (string) Str::uuid7(), 'full_name' => 'Public participant', 'created_at' => now(), 'updated_at' => now()]);
        }
        $owner->forceFill(['profile_photo_key' => 'test-avatar.png', 'profile_photo_disk' => 'local'])->save();
        Storage::disk('local')->put('test-avatar.png', 'fixture');
        $key = (string) Str::uuid7();
        $id = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => $key])->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->assertJsonPath('data.id', $id);
        $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => $key])->assertCreated()->assertJsonPath('data.id', $id);
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonPath('data.items.0.handler.avatar_path', '/conversations/'.$id.'/avatars/'.$owner->id);
        $this->get('/api/v1/buyers/conversations/'.$id.'/avatars/'.$owner->id)->assertOk();
        // Exercise the real mobile bearer transport rather than only actingAs.
        $tokens = app(TokenSessionService::class)->start($buyer, 'MOBILE', null, null, null);
        $this->app['auth']->forgetGuards();
        $response = $this->withToken($tokens->accessToken)->getJson('/api/v1/buyers/conversations');
        $response->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('errors', []);
        $this->flushHeaders();
        $this->withHeader('X-CSRF-Token', 'test-csrf');
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonPath('data.items.0.buyer.display_name', 'Public participant');
        self::assertSame(1, DB::table('conversations')->where('buyer_profile_id', $this->buyerProfileId($buyer))->count());
    }

    public function test_product_free_chat_can_set_owned_delivery_details_but_not_change_published_terms(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Delivery later');
        $buyer = $this->buyer();
        $location = $this->savedLocation($buyer, 'Delivery site', 0, 0);
        $id = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $path = '/api/v1/buyers/conversations/'.$id;
        $input = ['lock_version' => 1, 'location_id' => $location, 'heavy_vehicle_restriction' => 'NO'];
        $this->putJson($path.'/destination', $input)->assertOk();
        $this->getJson($path)->assertOk()->assertJsonPath('data.conversation.locked_reference.destination.intended.location_id', $location);
        $this->putJson($path.'/destination', $input)->assertConflict();
        $this->putJson($path.'/destination', array_replace($input, ['lock_version' => 2, 'heavy_vehicle_restriction' => 'YES']))->assertUnprocessable();
        $other = $this->buyer();
        $otherLocation = $this->savedLocation($other, 'Private site', 0, 0);
        $this->putJson($path.'/destination', array_replace($input, ['location_id' => $otherLocation]))->assertNotFound();
        $this->signInBuyer($buyer);
        $this->putJson($path.'/destination', array_replace($input, ['location_id' => $otherLocation, 'lock_version' => 2]))->assertUnprocessable();
        $this->signInStoreMember($owner);
        $variant = $this->variantIds($listing)[0];
        $published = $this->publishQuote($id, $this->draftInput($variant));
        $this->signInBuyer($buyer);
        $this->putJson($path.'/destination', array_replace($input, ['lock_version' => 2]))->assertConflict()->assertJsonPath('errors.0.code', 'DESTINATION_LOCKED');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/withdraw', ['version_id' => $published['versions'][0]['id']], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $before = DB::table('quotations')->where('conversation_id', $id)->value('lock_version');
        $this->signInBuyer($buyer);
        $this->putJson($path.'/destination', array_replace($input, ['lock_version' => 2]))->assertOk();
        self::assertSame((int) $before + 1, (int) DB::table('quotations')->where('conversation_id', $id)->value('lock_version'));
        self::assertSame(1, DB::table('quotation_versions')->count());
    }

    public function test_product_messages_snapshot_reject_cross_store_and_retry_without_duplicate(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Product cards', [['price' => 1800], ['price' => 2200]]);
        [$other, , $otherListing] = $this->pickupStore('Other store');
        $variants = $this->variantIds($listing);
        $this->buyer();
        $id = $this->inquiry($store->id, $variants[0]);
        $path = '/api/v1/buyers/conversations/'.$id;
        $this->getJson($path.'/products')->assertOk()->assertJsonCount(2, 'data.items');
        $this->getJson($path.'/products?q=does-not-exist')->assertOk()->assertJsonCount(0, 'data.items');
        $key = (string) Str::uuid7();
        $input = ['product_id' => $variants[0], 'client_message_id' => $key];
        $message = $this->postJson($path.'/messages', $input)->assertCreated()->json('data.id');
        $this->postJson($path.'/messages', $input)->assertCreated()->assertJsonPath('data.id', $message);
        $this->postJson($path.'/messages', $input + ['body' => 'Changed'])->assertConflict();
        $this->postJson($path.'/messages', ['product_id' => $this->variantIds($otherListing)[0], 'client_message_id' => (string) Str::uuid7()])->assertUnprocessable();
        $this->postJson($path.'/messages', ['client_message_id' => (string) Str::uuid7()])->assertUnprocessable();
        $this->postJson($path.'/messages', ['product_id' => $variants[1], 'body' => 'And this one', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $snapshot = $this->getJson($path)->assertOk()->json('data.messages.items.0.product');
        DB::table('vendor_listings')->where('id', $listing)->update(['display_name' => 'Changed product', 'status' => 'INACTIVE']);
        $this->getJson($path)->assertOk()->assertJsonPath('data.messages.items.0.product.name', $snapshot['name'])->assertJsonPath('data.messages.items.0.product.price_centavos', 1800)->assertJsonPath('data.messages.items.0.product.available', false);
        $this->postJson($path.'/messages', $input)->assertCreated()->assertJsonPath('data.id', $message);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonPath('data.items.0.unread_count', 2);
        $last = DB::table('messages')->where('conversation_id', $id)->orderByDesc('id')->value('id');
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/read', ['through_message_id' => $last])->assertOk();
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonPath('data.items.0.unread_count', 0);
    }

    public function test_typing_and_product_picker_require_current_participation(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Typing access');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/typing', ['typing' => true])->assertOk();
        self::assertSame(0, DB::table('messages')->where('conversation_id', $id)->count());
        $this->buyer();
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/typing', ['typing' => true])->assertNotFound();
        $this->getJson('/api/v1/buyers/conversations/'.$id.'/products')->assertNotFound();
        $this->signInBuyer($buyer);
        $this->signInStoreMember($owner);
        $channel = $this->getJson('/api/v1/vendor/messaging/realtime')->assertOk()->json('data.inbox_channel');
        self::assertStringStartsWith('vendor-inbox.', $channel);
        $this->buyer();
        $this->postJson('/api/v1/buyers/messaging/auth', ['channel_name' => 'private-'.$channel, 'socket_id' => '1.2'])->assertForbidden();
    }

    public function test_typing_broadcast_is_ephemeral_and_excludes_unassigned_staff(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Ephemeral typing');
        $this->teamMember($store, 'STORE_STAFF');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $c = DB::table('conversations')->where('id', $id)->first();
        $channel = app(ConversationAccess::class)->channel($owner, $c);
        $outbox = DB::table('outbox_events')->count();
        config()->set('broadcasting.default', 'reverb');
        $broadcast = \Mockery::mock(Broadcaster::class);
        Broadcast::shouldReceive('connection')->with('reverb')->andReturn($broadcast);
        $broadcast->shouldReceive('broadcast')->withArgs(fn ($channels, $event, $payload) => $channels === ['private-'.$channel] && $event === 'conversation.typing' && $payload['typing'] === true && is_int($payload['at']) && count($payload) === 2)->once();
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/typing', ['typing' => true])->assertOk();
        self::assertSame(0, DB::table('messages')->where('conversation_id', $id)->count());
        self::assertSame($outbox, DB::table('outbox_events')->count());
        $owner->update(['account_status' => 'SUSPENDED']);
        app(ConversationBroadcast::class)->typing($id, $buyer->id, false);
    }

    private function draftInput(string $variant, string $qty = '4'): array
    {
        return ['lines' => [['variant_id' => $variant, 'quantity' => $qty, 'unit_price_centavos' => 1700]], 'fulfillment_method' => 'PICKUP', 'fulfillment_date' => now()->addDays(3)->toDateString()];
    }

    public function test_duplicate_migration_preserves_message_and_quotation_history_and_enforces_unique_store_thread(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Legacy duplicate');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $this->signInStoreMember($owner);
        $quote = $this->publishQuote($id, $this->draftInput($this->variantIds($listing)[0]));
        $originalMessages = DB::table('messages')->where('conversation_id', $id)->pluck('id')->all();
        $migration = require database_path('migrations/2026_10_06_000000_improve_store_conversations.php');
        $migration->down();
        $duplicate = (array) DB::table('conversations')->where('id', $id)->first();
        $duplicate['id'] = (string) Str::uuid7();
        $duplicate['created_at'] = now()->addSecond();
        DB::table('conversations')->insert($duplicate);
        $migration->up();
        self::assertSame($id, DB::table('conversations')->where('id', $duplicate['id'])->value('canonical_conversation_id'));
        self::assertSame($originalMessages, DB::table('messages')->where('conversation_id', $id)->pluck('id')->all());
        self::assertSame($quote['versions'][0]['content_hash'], DB::table('quotation_versions')->where('id', $quote['versions'][0]['id'])->value('content_hash'));
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.legacy_conversation_ids.0', $duplicate['id']);
        $this->getJson('/api/v1/buyers/conversations/'.$duplicate['id'])->assertOk();
        $this->postJson('/api/v1/buyers/conversations/'.$duplicate['id'].'/messages', ['body' => 'Use current chat', 'client_message_id' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'CONVERSATION_MERGED');
        $duplicate['id'] = (string) Str::uuid7();
        $this->expectException(UniqueConstraintViolationException::class);
        DB::table('conversations')->insert($duplicate);
    }

    private function publishQuote(string $id, array $draft, int $lock = 1): array
    {
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => $lock, 'draft' => $draft])->assertOk();

        return $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => $lock + 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
    }

    public function test_buyer_must_choose_an_offered_payment_method_before_quotation_acceptance(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Buyer payment choice');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant) + ['payment_method' => 'CASH_ON_DELIVERY'];
        $published = $this->publishQuote($id, $draft)['versions'][0];
        self::assertArrayNotHasKey('payment_method', $published['content']);
        self::assertSame(['ONLINE'], $published['available_payment_methods']);
        self::assertNull($published['selected_payment_method']);
        $this->signInBuyer($buyer);
        $path = '/api/v1/buyers/conversations/'.$id.'/quotation/accept';
        $decision = ['version_id' => $published['id'], 'content_hash' => $published['content_hash']];
        $this->postJson($path, $decision, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.details.payment_method.0', 'The payment method field is required.');
        foreach (['IN_STORE', 'CASH_ON_DELIVERY'] as $unavailable) {
            $this->postJson($path, $decision + ['payment_method' => $unavailable], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PAYMENT_METHOD_UNAVAILABLE');
        }
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame('0.0000', $this->reserved($variant));
        $order = $this->postJson($path, $decision + ['payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame('ONLINE', DB::table('orders')->where('id', $order)->value('payment_method'));
        self::assertSame('AWAITING_PAYMENT', DB::table('orders')->where('id', $order)->value('order_state'));
    }

    public function test_buyer_in_store_choice_is_frozen_once_and_current_vendor_settings_are_rechecked(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('In store quotation');
        $variant = $this->variantIds($listing)[0];
        DB::table('vendor_payment_settings')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id, 'in_store_enabled' => true, 'cod_enabled' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $published = $this->publishQuote($id, $this->draftInput($variant))['versions'][0];
        self::assertSame(['ONLINE', 'IN_STORE'], $published['available_payment_methods']);
        $frozen = DB::table('quotation_versions')->where('id', $published['id'])->first();
        $this->signInBuyer($buyer);
        $path = '/api/v1/buyers/conversations/'.$id.'/quotation/accept';
        $decision = ['version_id' => $published['id'], 'content_hash' => $published['content_hash'], 'payment_method' => 'IN_STORE'];
        DB::table('vendor_payment_settings')->where('vendor_organization_id', $store->id)->update(['in_store_enabled' => false]);
        $this->postJson($path, $decision, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PAYMENT_METHOD_UNAVAILABLE');
        self::assertSame(0, DB::table('orders')->count());
        DB::table('vendor_payment_settings')->where('vendor_organization_id', $store->id)->update(['in_store_enabled' => true]);
        $key = (string) Str::uuid7();
        $order = $this->postJson($path, $decision, ['Idempotency-Key' => $key])->assertOk()->json('data.order_id');
        $this->postJson($path, $decision, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.order_id', $order);
        $changed = array_replace($decision, ['payment_method' => 'ONLINE']);
        $this->postJson($path, $changed, ['Idempotency-Key' => $key])->assertConflict()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        self::assertSame('IN_STORE', DB::table('orders')->where('id', $order)->value('payment_method'));
        self::assertSame('CONFIRMED', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertSame(1, DB::table('physical_payment_records')->where('order_id', $order)->where('record_kind', 'OBLIGATION_OPENED')->count());
        self::assertSame(1, DB::table('orders')->count());
        self::assertEquals($frozen, DB::table('quotation_versions')->where('id', $published['id'])->first());
        $snapshot = json_decode(DB::table('order_snapshots')->where('order_id', $order)->value('snapshot'), true);
        self::assertSame('IN_STORE', $snapshot['payment_method']);
        foreach (['buyers', 'vendor'] as $portal) {
            if ($portal === 'vendor') {
                $this->signInStoreMember($owner);
            }
            $this->getJson('/api/v1/'.$portal.'/conversations/'.$id)->assertOk()->assertJsonPath('data.quotations.versions.0.selected_payment_method', 'IN_STORE');
        }
    }

    public function test_both_portals_keep_published_product_details_after_the_listing_changes(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Quoted specifications');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $published = $this->publishQuote($id, $this->draftInput($variant))['versions'][0];
        $line = $published['content']['lines'][0];
        self::assertSame('BrandCo', $line['brand']);
        self::assertSame('Variant 1', $line['variant_label']);
        self::assertSame(['thickness_mm' => '100'], $line['specifications']);
        self::assertSame(6800, $published['content']['commercial']['materials_gross_centavos']);

        // A later catalog edit must never replace the terms being reviewed.
        DB::table('vendor_listings')->where('id', $listing)->update(['technical_attributes' => json_encode(['thickness_mm' => '150'])]);
        DB::table('listing_variants')->where('id', $variant)->update(['label' => 'Updated catalog variant']);
        DB::table('products')->where('id', DB::table('vendor_listings')->where('id', $listing)->value('product_id'))->update(['brand' => 'New catalog brand']);
        foreach (['vendor', 'buyers'] as $portal) {
            if ($portal === 'buyers') {
                $this->signInBuyer($buyer);
            }
            $this->getJson('/api/v1/'.$portal.'/conversations/'.$id)->assertOk()
                ->assertJsonPath('data.quotations.versions.0.content.lines.0.brand', 'BrandCo')
                ->assertJsonPath('data.quotations.versions.0.content.lines.0.variant_label', 'Variant 1')
                ->assertJsonPath('data.quotations.versions.0.content.lines.0.specifications.thickness_mm', '100')
                ->assertJsonPath('data.quotations.versions.0.content.commercial.materials_gross_centavos', 6800)
                ->assertJsonPath('data.quotations.versions.0.content_hash', $published['content_hash']);
        }
    }

    public function test_versions_are_immutable_soft_holds_do_not_reserve_and_stale_acceptance_is_recoverable(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Quotation store');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $first = $this->publishQuote($id, $this->draftInput($variant));
        self::assertSame('0.0000', $this->reserved($variant));
        self::assertSame(1, DB::table('inventory_holds')->where('state', 'ACTIVE')->where('hold_type', 'SOFT')->count());
        $old = $first['versions'][0];
        $second = $this->publishQuote($id, $this->draftInput($variant, '3'), $first['quotation']['lock_version']);
        self::assertSame([], $second['versions'][1]['actions']);
        self::assertSame('SUPERSEDED', $second['versions'][1]['state']);
        self::assertSame($old['content_hash'], DB::table('quotation_versions')->where('id', $old['id'])->value('content_hash'));
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $old['id'], 'content_hash' => $old['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'QUOTATION_VERSION_CONFLICT');
        $latest = $second['versions'][0];
        $key = (string) Str::uuid7();
        $payload = ['version_id' => $latest['id'], 'content_hash' => $latest['content_hash'], 'payment_method' => 'ONLINE'];
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk()->json('data.order_id');
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.order_id', $order);
        self::assertSame('3.0000', $this->reserved($variant));
        self::assertSame(1, DB::table('orders')->count());
        self::assertSame('AWAITING_PAYMENT', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertSame('PRIVATE_TRANSACTION', DB::table('financial_snapshots')->where('order_id', $order)->value('price_source'));
        self::assertNotNull(json_decode(DB::table('order_lines')->where('order_id', $order)->value('snapshot'), true)['source_tax_version_id']);
        self::assertSame(0, DB::table('payments')->count());
        self::assertSame([1800], array_column(app(EligibleOfferQuery::class)->currentOffers([$store->id]), 'ordinary_payable_centavos'));
        self::assertSame(1800, (int) DB::table('listing_price_versions')->where('listing_variant_id', $variant)->whereNull('retired_at')->value('amount_centavos'));
    }

    public function test_stock_shortage_commits_revalidation_state_and_no_partial_order(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Limited stock', [['price' => 1800, 'qty' => '3'], ['price' => 2000, 'qty' => '20']]);
        $variants = $this->variantIds($listing);
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variants[0]);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variants[0], '4');
        $draft['lines'][] = ['variant_id' => $variants[1], 'quantity' => '2', 'unit_price_centavos' => 1800];
        $quote = $this->publishQuote($id, $draft)['versions'][0];
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'STOCK_REVALIDATION_REQUIRED');
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame('0.0000', $this->reserved($variants[1]));
        self::assertSame('STOCK_REVALIDATION_REQUIRED', DB::table('quotations')->where('conversation_id', $id)->value('state'));
    }

    public function test_sales_scope_transfer_customer_service_draft_only_and_no_private_contacts(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Team');
        $variant = $this->variantIds($listing)[0];
        $cs = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $fulfillment = $this->teamMember($store, 'FULFILLMENT');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $cs->id, 'lock_version' => 1, 'reason' => 'Sales assistance'])->assertOk();
        $this->signInStoreMember($cs);
        $header = $this->getJson('/api/v1/vendor/conversations/'.$id)->assertOk()->json('data.conversation');
        $oldChannel = $header['channel'];
        self::assertStringNotContainsString($cs->email, json_encode($header));
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $this->draftInput($variant)])->assertOk();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/messages', ['body' => 'Hello Buyer', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $staff->id, 'lock_version' => 2, 'reason' => 'Product help'])->assertOk();
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
        $this->postJson('/api/v1/vendor/messaging/auth', ['channel_name' => 'private-'.$oldChannel, 'socket_id' => '1.2'])->assertForbidden();
        $this->signInStoreMember($fulfillment);
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->assertJsonFragment(['body' => 'Hello Buyer']);
        $this->buyer();
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertNotFound();
        self::assertSame(3, DB::table('conversation_assignments')->where('conversation_id', $id)->count());
    }

    public function test_both_participants_can_read_version_scoped_change_requests_after_revision_but_outsiders_cannot(): void
    {
        Carbon::setTestNow(CarbonImmutable::now()->startOfSecond());
        CarbonImmutable::setTestNow(Carbon::now());
        [$store, $owner, $listing] = $this->pickupStore('Requested changes');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $published = $this->publishQuote($id, $this->draftInput($variant));
        $quote = $published['versions'][0];
        self::assertArrayNotHasKey('requested_changes', $quote);
        $this->signInBuyer($buyer);
        $key = (string) Str::uuid7();
        $input = ['version_id' => $quote['id'], 'reason' => "Please reduce quantity to 3.\nKeep Self-Pickup."];
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/counter', $input, ['Idempotency-Key' => $key])->assertOk();
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/counter', $input, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame(1, DB::table('quotation_counter_offers')->where('quotation_version_id', $quote['id'])->count());
        $expected = ['requested_changes' => $input['reason'], 'change_requested_at' => CarbonImmutable::now()->toIso8601String(),
            'vendor_response_due_at' => CarbonImmutable::now()->addDay()->toIso8601String()];
        foreach (['buyers' => $buyer, 'vendor' => $owner] as $portal => $actor) {
            $portal === 'buyers' ? $this->signInBuyer($actor) : $this->signInStoreMember($actor);
            $response = $this->getJson('/api/v1/'.$portal.'/conversations/'.$id)->assertOk();
            foreach ($expected as $field => $value) {
                $response->assertJsonPath('data.quotations.versions.0.'.$field, $value);
            }
        }
        $this->signInStoreMember($owner);
        $lock = DB::table('quotations')->where('conversation_id', $id)->value('lock_version');
        $revised = $this->publishQuote($id, $this->draftInput($variant, '3'), $lock);
        self::assertArrayNotHasKey('requested_changes', $revised['versions'][0]);
        self::assertSame('SUPERSEDED', $revised['versions'][1]['state']);
        self::assertSame($expected, array_intersect_key($revised['versions'][1], $expected));
        self::assertSame($quote['content_hash'], $revised['versions'][1]['content_hash']);
        $this->buyer();
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertNotFound();
        $fulfillment = $this->teamMember($store, 'FULFILLMENT');
        $this->signInStoreMember($fulfillment);
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
    }

    public function test_fake_clock_reminder_expiry_and_counter_deadline_release_holds(): void
    {
        Carbon::setTestNow(CarbonImmutable::now()->startOfSecond());
        CarbonImmutable::setTestNow(Carbon::now());
        [$store, $owner, $listing] = $this->pickupStore('Deadlines');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $quote = $this->publishQuote($id, $this->draftInput($variant))['versions'][0];
        self::assertSame(CarbonImmutable::now()->addDay()->timestamp, CarbonImmutable::parse($quote['expires_at'])->timestamp);
        $this->travel(20)->hours();
        app(QuotationService::class)->sweep();
        app(QuotationService::class)->sweep();
        self::assertSame(1, DB::table('quotation_events')->where('event_type', 'REMINDER')->count());
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/counter', ['version_id' => $quote['id'], 'reason' => 'Please reduce quantity'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertSame(0, DB::table('inventory_holds')->where('state', 'ACTIVE')->count());
        $this->travel(24)->hours();
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED');
    }

    public function test_reverb_signature_is_viewer_bound_and_role_changes_revoke_it(): void
    {
        config()->set('broadcasting.default', 'reverb');
        config()->set('broadcasting.connections.reverb.key', 'test-public-key');
        config()->set('broadcasting.connections.reverb.secret', Str::random(40));
        config()->set('broadcasting.connections.reverb.app_id', 'test-app');
        [$store, $owner, $listing] = $this->pickupStore('Channels');
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $channel = $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->json('data.conversation.channel');
        $this->postJson('/api/v1/buyers/messaging/auth', ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel])->assertOk()->assertJsonStructure(['auth']);
        $this->postJson('/api/v1/buyers/messaging/auth', ['socket_id' => '12.34', 'channel_name' => str_replace('SALES', 'FULFILLMENT', 'private-'.$channel)])->assertForbidden();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/messaging/auth', ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel])->assertForbidden();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $staff->id, 'lock_version' => 1, 'reason' => 'Assigned sales'])->assertOk();
        $this->signInStoreMember($staff);
        $channel = $this->getJson('/api/v1/vendor/conversations/'.$id)->assertOk()->json('data.conversation.channel');
        $this->postJson('/api/v1/vendor/messaging/auth', ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel])->assertOk();
        DB::table('vendor_memberships')->where('user_id', $staff->id)->update(['role' => 'CUSTOMER_SERVICE']);
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
        $this->postJson('/api/v1/vendor/messaging/auth', ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel])->assertForbidden();
        $staff->update(['account_status' => 'SUSPENDED']);
        self::assertFalse(app(ConversationAccess::class)->allows($staff, DB::table('conversations')->where('id', $id)->first()));
    }

    public function test_buyer_inbox_channel_is_private_epoch_bound_and_available_before_first_conversation(): void
    {
        config()->set('broadcasting.default', 'reverb');
        config()->set('broadcasting.connections.reverb.key', 'test-public-key');
        config()->set('broadcasting.connections.reverb.secret', Str::random(40));
        config()->set('broadcasting.connections.reverb.app_id', 'test-app');
        $buyer = $this->buyer();
        $channel = $this->getJson('/api/v1/buyers/messaging/realtime')->assertOk()->json('data.inbox_channel');
        self::assertStringStartsWith('buyer-inbox.', $channel);
        $payload = ['socket_id' => '12.34', 'channel_name' => 'private-'.$channel];
        $this->postJson('/api/v1/buyers/messaging/auth', $payload)->assertOk()->assertJsonStructure(['auth']);
        $this->buyer();
        $this->postJson('/api/v1/buyers/messaging/auth', $payload)->assertForbidden();
        [$store, $owner] = $this->pickupStore('Inbox channel restriction');
        $this->signInStoreMember($owner);
        self::assertStringStartsWith('vendor-inbox.', $this->getJson('/api/v1/vendor/messaging/realtime')->assertOk()->json('data.inbox_channel'));
        $this->postJson('/api/v1/vendor/messaging/auth', $payload)->assertForbidden();
        $this->signInBuyer($buyer);
        DB::table('users')->where('id', $buyer->id)->update(['updated_at' => now()->addMinute()]);
        $this->postJson('/api/v1/buyers/messaging/auth', $payload)->assertForbidden();
        $fresh = $this->getJson('/api/v1/buyers/messaging/realtime')->assertOk()->json('data.inbox_channel');
        self::assertNotSame($channel, $fresh);
        $buyer->update(['account_status' => 'SUSPENDED']);
        self::assertNull(app(BuyerInboxChannel::class)->name($buyer));
    }

    public function test_buyer_inbox_broadcast_contains_only_invalidation_and_respects_revocation(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Inbox invalidations');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        self::assertTrue(DB::table('outbox_events')->where('aggregate_id', $id)->where('event_type', 'CONVERSATION_CHANGED')->exists());
        config()->set('broadcasting.default', 'reverb');
        $channel = app(BuyerInboxChannel::class)->name($buyer);
        $broadcast = \Mockery::mock(Broadcaster::class);
        Broadcast::shouldReceive('connection')->with('reverb')->andReturn($broadcast);
        $broadcast->shouldReceive('broadcast')->withArgs(fn ($channels, $event, $payload) => $event === 'conversation.changed' && $payload === ['conversation_id' => $id])->times(3);
        $broadcast->shouldReceive('broadcast')->with(['private-'.$channel], 'inbox.changed', [])->once();
        $broadcast->shouldReceive('broadcast')->with(['private-'.app(BuyerInboxChannel::class)->name($owner)], 'inbox.changed', [])->twice();
        app(ConversationBroadcast::class)->deliver($id);
        $buyer->update(['account_status' => 'SUSPENDED']);
        app(ConversationBroadcast::class)->deliver($id);
    }

    public function test_private_files_are_scoped_and_transferred_handlers_cannot_download(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Files');
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $file = UploadedFile::fake()->image('coordination.png', 20, 20);
        $messageKey = (string) Str::uuid7();
        $this->post('/api/v1/buyers/conversations/'.$id.'/attachments', ['file' => $file, 'client_message_id' => $messageKey], ['Accept' => 'application/json'])->assertCreated();
        $this->post('/api/v1/buyers/conversations/'.$id.'/attachments', ['file' => $file, 'client_message_id' => $messageKey], ['Accept' => 'application/json'])->assertCreated();
        self::assertSame(1, DB::table('message_attachments')->count());
        $attachment = DB::table('message_attachments')->value('id');
        $this->get('/api/v1/buyers/conversations/'.$id.'/attachments/'.$attachment)->assertOk()->assertHeader('X-Content-Type-Options', 'nosniff');
        $this->buyer();
        $other = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $this->get('/api/v1/buyers/conversations/'.$other.'/attachments/'.$attachment)->assertNotFound();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $staff->id, 'lock_version' => 1, 'reason' => 'Review attachment'])->assertOk();
        $this->signInStoreMember($staff);
        $this->get('/api/v1/vendor/conversations/'.$id.'/attachments/'.$attachment)->assertOk();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $owner->id, 'lock_version' => 2, 'reason' => 'Owner follow-up'])->assertOk();
        $this->get('/api/v1/vendor/conversations/'.$id.'/attachments/'.$attachment)->assertNotFound();
        [, $outsider] = $this->pickupStore('Another Vendor');
        $this->signInStoreMember($outsider);
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
        $this->get('/api/v1/vendor/conversations/'.$id.'/attachments/'.$attachment)->assertNotFound();
        $this->signInBuyer($buyer);
        $this->post('/api/v1/buyers/conversations/'.$id.'/attachments', ['file' => UploadedFile::fake()->createWithContent('fake.png', '<?php echo 1;'), 'client_message_id' => (string) Str::uuid7()], ['Accept' => 'application/json'])->assertUnprocessable();
    }

    public function test_customer_service_cannot_set_nrpc(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('NRPC authority');
        $variant = $this->variantIds($listing)[0];
        $cs = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/transfer', ['handler_user_id' => $cs->id, 'lock_version' => 1, 'reason' => 'Prepare draft'])->assertOk();
        $this->signInStoreMember($cs);
        $draft = $this->draftInput($variant);
        $draft['nrpc'] = ['amount_centavos' => 100, 'reason' => 'Preparation', 'allocations' => [$variant => 100]];
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $draft])->assertUnprocessable();
    }

    public function test_one_hour_deadline_reminder_and_exact_expiry_boundary(): void
    {
        Carbon::setTestNow(CarbonImmutable::now()->startOfSecond());
        CarbonImmutable::setTestNow(Carbon::now());
        [$store, $owner, $listing] = $this->pickupStore('Short deadline');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        foreach ([0, 73] as $invalid) {
            $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $this->draftInput($variant) + ['deadline_hours' => $invalid]])->assertUnprocessable();
        }
        $v = $this->publishQuote($id, $this->draftInput($variant) + ['deadline_hours' => 1])['versions'][0];
        $this->travel(29)->minutes();
        app(QuotationService::class)->sweep();
        self::assertSame(0, DB::table('quotation_events')->where('event_type', 'REMINDER')->count());
        $this->travel(1)->minutes();
        app(QuotationService::class)->sweep();
        self::assertSame(1, DB::table('quotation_events')->where('event_type', 'REMINDER')->count());
        $this->travel(30)->minutes();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $v['id'], 'content_hash' => $v['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'QUOTATION_EXPIRED');
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame(0, DB::table('inventory_holds')->where('state', 'ACTIVE')->count());
    }

    public function test_two_published_quotes_cannot_both_reserve_the_last_units(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Contended', [['price' => 1800, 'qty' => '5']]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $first = $this->inquiry($store->id, $variant);
        $secondBuyer = $this->buyer();
        $second = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $a = $this->publishQuote($first, $this->draftInput($variant))['versions'][0];
        $b = $this->publishQuote($second, $this->draftInput($variant))['versions'][0];
        self::assertSame('0.0000', $this->reserved($variant));
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', ['version_id' => $a['id'], 'content_hash' => $a['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInBuyer($secondBuyer);
        $this->postJson('/api/v1/buyers/conversations/'.$second.'/quotation/accept', ['version_id' => $b['id'], 'content_hash' => $b['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'STOCK_REVALIDATION_REQUIRED');
        self::assertSame('4.0000', $this->reserved($variant));
        self::assertSame(1, DB::table('orders')->count());
    }

    public function test_project_quote_acceptance_selects_one_vendor_and_preserves_other_history(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Project Vendor');
        [$otherStore, $otherOwner, $otherListing] = $this->pickupStore('Competing Vendor');
        DB::table('store_profiles')->whereIn('vendor_organization_id', [$store->id, $otherStore->id])->update(['bulk_capability' => true]);
        $buyer = $this->buyer();
        $first = $this->inquiry($store->id, $this->variantIds($listing)[0]);
        $second = $this->inquiry($otherStore->id, $this->variantIds($otherListing)[0]);
        $profile = DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id');
        $project = (string) Str::uuid7();
        $package = (string) Str::uuid7();
        DB::table('projects')->insert(['id' => $project, 'buyer_profile_id' => $profile, 'name' => 'Build', 'budget_centavos' => 1000000, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('work_packages')->insert(['id' => $package, 'project_id' => $project, 'name' => 'Foundation', 'status' => 'QUOTATION_INQUIRY', 'budget_centavos' => 1000000, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('conversations')->whereIn('id', [$first, $second])->update(['context_type' => 'PROJECT_BASED', 'context_id' => $package]);
        $this->signInStoreMember($owner);
        $a = $this->publishQuote($first, $this->draftInput($this->variantIds($listing)[0]))['versions'][0];
        $this->signInStoreMember($otherOwner);
        $this->publishQuote($second, $this->draftInput($this->variantIds($otherListing)[0]));
        $this->signInBuyer($buyer);
        $key = (string) Str::uuid7();
        $payload = ['version_id' => $a['id'], 'content_hash' => $a['content_hash'], 'payment_method' => 'ONLINE'];
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk();
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame($store->id, DB::table('work_packages')->where('id', $package)->value('selected_vendor_organization_id'));
        $this->getJson('/api/v1/buyers/conversations/'.$second)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED')->assertJsonCount(1, 'data.quotations.versions');
        self::assertSame(1, DB::table('orders')->where('work_package_id', $package)->count());
    }

    public function test_fulfillment_thread_opens_at_submission_and_is_idempotent_at_milestone(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Fulfillment');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        // Approved 2026-10-10: the one thread opens with the order instead of at the first handover milestone.
        self::assertTrue(FulfillmentThreadService::ENTRY_ENABLED);
        $opened = DB::table('conversations')->where('order_id', $order)->where('purpose', 'FULFILLMENT')->value('id');
        self::assertNotNull($opened);
        DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP']);
        $assigned = $this->teamMember($store, 'FULFILLMENT');
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'user_id' => $assigned->id, 'assigned_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $id = app(FulfillmentThreadService::class)->ensureForOrder($order);
        self::assertSame($opened, $id);
        self::assertSame($id, app(FulfillmentThreadService::class)->ensureForOrder($order));
        self::assertSame(1, DB::table('conversations')->where('order_id', $order)->where('purpose', 'FULFILLMENT')->count());
        $c = DB::table('conversations')->where('id', $id)->first();
        self::assertTrue(app(ConversationAccess::class)->allows($assigned, $c));
        $this->signInStoreMember($assigned);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/messages', ['body' => 'The delivery is ready.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->post('/api/v1/vendor/conversations/'.$id.'/attachments', ['file' => UploadedFile::fake()->image('handover.png'), 'client_message_id' => (string) Str::uuid7()], ['Accept' => 'application/json'])->assertCreated();
        $attachment = DB::table('message_attachments')->value('id');
        $this->get('/api/v1/vendor/conversations/'.$id.'/attachments/'.$attachment)->assertOk();
        $this->post('/api/v1/vendor/conversations/'.$id.'/attachments', ['file' => UploadedFile::fake()->createWithContent('receipt.pdf', '%PDF-1.4 financial receipt'), 'client_message_id' => (string) Str::uuid7()], ['Accept' => 'application/json'])->assertUnprocessable();
        $channel = $this->getJson('/api/v1/vendor/conversations/'.$id)->assertOk()->json('data.conversation.channel');
        $replacement = $this->teamMember($store, 'FULFILLMENT');
        DB::transaction(fn () => app(FulfillmentThreadService::class)->assign(DB::table('orders')->where('id', $order)->lockForUpdate()->first(), $owner, (int) $replacement->id, 'Shift handover'));
        self::assertFalse(app(ConversationAccess::class)->allows($assigned, $c));
        $this->getJson('/api/v1/vendor/conversations/'.$id)->assertNotFound();
        $this->get('/api/v1/vendor/conversations/'.$id.'/attachments/'.$attachment)->assertNotFound();
        $this->postJson('/api/v1/vendor/messaging/auth', ['channel_name' => 'private-'.$channel, 'socket_id' => '1.2'])->assertForbidden();
        self::assertTrue(app(ConversationAccess::class)->allows($replacement, $c));
        self::assertSame(2, DB::table('conversation_assignments')->where('conversation_id', $id)->count());
        self::assertSame('READY_FOR_PICKUP', DB::table('orders')->where('id', $order)->value('order_state'));
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations/'.$id)->assertOk()->assertJsonFragment(['body' => 'The delivery is ready.']);
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => (string) Str::uuid7()], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        [, $otherOrder] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $otherOrder)->update(['order_state' => 'READY_FOR_PICKUP']);
        DB::transaction(fn () => app(FulfillmentThreadService::class)->assign(DB::table('orders')->where('id', $otherOrder)->lockForUpdate()->first(), $owner, (int) $assigned->id, 'Separate order assignment'));
        $otherThread = app(FulfillmentThreadService::class)->ensureForOrder($otherOrder);
        $this->signInStoreMember($replacement);
        $this->getJson('/api/v1/vendor/conversations/'.$otherThread)->assertNotFound();
        $this->signInStoreMember($assigned);
        $this->get('/api/v1/vendor/conversations/'.$otherThread.'/attachments/'.$attachment)->assertNotFound();
    }

    public function test_buyer_inbox_excludes_fulfillment_threads_and_archiving_is_personal_reversible_and_history_safe(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Archive inbox');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        $this->signInBuyer($buyer);
        $sales = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->postJson('/api/v1/buyers/conversations/'.$sales.'/messages', ['body' => 'Is this in stock?', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP']);
        $assigned = $this->teamMember($store, 'FULFILLMENT');
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'user_id' => $assigned->id, 'assigned_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $fulfillment = app(FulfillmentThreadService::class)->ensureForOrder($order);

        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $sales);
        $this->getJson('/api/v1/buyers/conversations/'.$fulfillment)->assertOk()->assertJsonPath('data.conversation.purpose', 'FULFILLMENT');
        $this->putJson('/api/v1/buyers/conversations/'.$fulfillment.'/archive')->assertConflict()->assertJsonPath('errors.0.code', 'CONVERSATION_NOT_ARCHIVABLE');

        $this->putJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertOk();
        $this->putJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertOk();
        self::assertSame(1, DB::table('conversation_archives')->where('conversation_id', $sales)->count());
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(0, 'data.items');
        $this->getJson('/api/v1/buyers/conversations?archived=true')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $sales);
        $this->getJson('/api/v1/buyers/conversations/'.$sales)->assertOk()->assertJsonFragment(['body' => 'Is this in stock?']);
        self::assertSame(1, DB::table('messages')->where('conversation_id', $sales)->count());

        $this->buyer();
        $this->putJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertNotFound();
        $this->deleteJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertNotFound();
        self::assertSame(1, DB::table('conversation_archives')->where('conversation_id', $sales)->count());

        $this->signInBuyer($buyer);
        $this->deleteJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertOk();
        $this->getJson('/api/v1/buyers/conversations')->assertOk()->assertJsonCount(1, 'data.items');
        $this->putJson('/api/v1/buyers/conversations/'.$sales.'/archive')->assertOk();

        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$sales.'/messages', ['body' => 'Yes, available.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->putJson('/api/v1/vendor/conversations/'.$sales.'/archive')->assertNotFound();
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $sales);
        $this->getJson('/api/v1/vendor/conversations/'.$fulfillment)->assertOk();
        $this->signInStoreMember($assigned);
        $this->getJson('/api/v1/vendor/conversations')->assertOk()->assertJsonCount(1, 'data.items')->assertJsonPath('data.items.0.id', $fulfillment);
        self::assertSame(0, DB::table('conversation_archives')->where('conversation_id', $sales)->count());
        self::assertSame(2, DB::table('messages')->where('conversation_id', $sales)->count());
    }

    public function test_historical_nrpc_quotation_acceptance_preserves_terms_and_allocations(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('NRPC quote');
        DB::table('vendor_payment_settings')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id, 'in_store_enabled' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['nrpc'] = ['amount_centavos' => 1000, 'reason' => 'Custom preparation for these materials', 'allocations' => [$variant => 1000]];
        // Seed an immutable version published under the previous policy.
        $withoutNrpc = $draft;
        unset($withoutNrpc['nrpc']);
        $v = $this->publishQuote($id, $withoutNrpc)['versions'][0];
        $content = app(QuotationTerms::class)->freeze($owner, DB::table('conversations')->where('id', $id)->first(), $draft, null);
        $json = json_encode($content, JSON_THROW_ON_ERROR);
        $v['content'] = $content;
        $v['content_hash'] = hash('sha256', $json);
        $historical = (array) DB::table('quotation_versions')->where('id', $v['id'])->first();
        $historical['supersedes_version_id'] = $v['id'];
        $v['id'] = (string) Str::uuid7();
        DB::table('quotation_versions')->insert(array_replace($historical, ['id' => $v['id'], 'version' => 2, 'content' => $json, 'content_hash' => $v['content_hash'], 'nrpc_centavos' => 1000]));
        DB::table('quotations')->where('conversation_id', $id)->update(['current_version_id' => $v['id']]);
        $this->signInBuyer($buyer);
        $payload = ['version_id' => $v['id'], 'content_hash' => $v['content_hash'], 'payment_method' => 'IN_STORE'];
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $payload += ['nrpc_acknowledged' => true, 'nrpc_terms_version_id' => $v['content']['nrpc']['terms']['id']];
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame(6800, (int) DB::table('financial_snapshots')->where('order_id', $order)->value('buyer_total_centavos'));
        self::assertSame(1000, (int) DB::table('nrpc_line_allocations')->sum('principal_centavos'));
        self::assertSame(1, DB::table('nrpc_acceptances')->where('order_id', $order)->count());
        self::assertSame('IN_STORE', DB::table('orders')->where('id', $order)->value('payment_method'));
        self::assertSame('AWAITING_PAYMENT', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertSame(0, DB::table('physical_payment_records')->where('order_id', $order)->count());
    }

    public function test_new_nrpc_is_rejected_in_quotation_drafts_and_publication(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('NRPC quote');
        DB::table('vendor_payment_settings')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id, 'in_store_enabled' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['nrpc'] = ['amount_centavos' => 1000, 'reason' => 'Custom preparation for these materials', 'allocations' => [$variant => 1000]];
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $draft])->assertUnprocessable();
        self::assertSame(0, DB::table('quotation_versions')->count());
        // An old persisted draft must also be rejected at publication.
        DB::table('quotations')->where('conversation_id', $id)->update(['draft' => json_encode($draft)]);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertSame(0, DB::table('nrpc_records')->count());
    }

    public function test_delivery_quote_preserves_buyer_access_and_confirmed_vehicle_calculation(): void
    {
        [$store, $owner] = $this->activeStore('Quoted delivery', false, true);
        DB::table('vendor_payment_settings')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id, 'cod_enabled' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('QUOTE-DELIVERY');
        $vehicle = $this->addVehicle($store->id);
        $this->placeStore($store->id, 1000);
        $this->connectOnlinePayments($store->id);
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Project site', 0, 0, 'PROJECT_SITE', true);
        $gate = $this->savedLocation($buyer, 'North gate', 1500, 0);
        $variant = $this->variantIds($listing)[0];
        $id = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id, 'listing_variant_id' => $variant, 'location_id' => $site,
            'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'Unload at the north gate.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['fulfillment_method'] = 'DELIVERY';
        $draft['delivery'] = ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60500,
            'arrangement' => 'Delivery and unloading at the north gate', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
        $v = $this->publishQuote($id, $draft)['versions'][0];
        self::assertSame(60500, $v['content']['delivery']['final_charge_centavos']);
        self::assertSame($gate, $v['content']['destination']['alternate_drop_off']['location_id']);
        self::assertSame(['ONLINE', 'CASH_ON_DELIVERY'], $v['available_payment_methods']);
        $this->signInBuyer($buyer);
        $decision = ['version_id' => $v['id'], 'content_hash' => $v['content_hash']];
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $decision + ['payment_method' => 'IN_STORE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PAYMENT_METHOD_UNAVAILABLE');
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $decision + ['payment_method' => 'CASH_ON_DELIVERY'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame('CASH_ON_DELIVERY', DB::table('orders')->where('id', $order)->value('payment_method'));
        self::assertSame('CONFIRMED', DB::table('orders')->where('id', $order)->value('order_state'));
        self::assertSame(60500, (int) DB::table('order_delivery_snapshots')->where('order_id', $order)->value('final_charge_centavos'));
        self::assertSame($site, json_decode(DB::table('orders')->where('id', $order)->value('destination'), true)['intended']['location_id']);
    }

    public function test_percentage_materials_discount_is_frozen_and_preserved_after_acceptance(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Percentage materials');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['discount'] = ['scope' => 'MATERIALS', 'percent' => '20'];
        $v = $this->publishQuote($id, $draft)['versions'][0];
        self::assertSame(['scope' => 'MATERIALS', 'percent' => '20.00', 'basis_centavos' => 6800, 'deduction_centavos' => 1360], $v['content']['discount']);
        self::assertSame(5440, $v['content']['commercial']['commercial_total_centavos']);
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $v['id'], 'content_hash' => $v['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame(5440, (int) DB::table('orders')->where('id', $order)->value('commercial_total_centavos'));
        self::assertSame(1360, (int) DB::table('financial_snapshots')->where('order_id', $order)->value('vendor_discount_centavos'));
        $this->signInStoreMember($owner);
        $lock = (int) DB::table('quotations')->where('conversation_id', $id)->value('lock_version');
        $draft['discount']['percent'] = '10';
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => $lock, 'draft' => $draft])->assertConflict()->assertJsonPath('errors.0.code', 'QUOTATION_CLOSED');
        self::assertSame($v['content_hash'], DB::table('quotation_versions')->where('id', $v['id'])->value('content_hash'));
    }

    /** @return array<string, array{string, int, int}> */
    public static function deliveryDiscountRates(): array
    {
        return ['partial delivery discount' => ['20', 12100, 48400], 'full delivery discount' => ['100', 60500, 0]];
    }

    #[DataProvider('deliveryDiscountRates')]
    public function test_percentage_delivery_discount_preserves_gross_fee_validation_and_net_accepted_fee(string $percent, int $deduction, int $netFee): void
    {
        [$store, $owner] = $this->activeStore('Delivery discount', false, true);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('QUOTE-DEL-DISCOUNT');
        $vehicle = $this->addVehicle($store->id);
        $this->placeStore($store->id, 1000);
        $this->connectOnlinePayments($store->id);
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Discount site', 0, 0, 'PROJECT_SITE', true);
        $gate = $this->savedLocation($buyer, 'Discount gate', 1500, 0);
        $variant = $this->variantIds($listing)[0];
        $id = $this->postJson('/api/v1/buyers/conversations', ['vendor_id' => $store->id, 'listing_variant_id' => $variant, 'location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'Unload at the gate.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['fulfillment_method'] = 'DELIVERY';
        $draft['discount'] = ['scope' => 'DELIVERY', 'percent' => $percent];
        $draft['delivery'] = ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60499, 'arrangement' => 'Delivery and unloading at the gate', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $draft])->assertOk();
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'DELIVERY_FEE_CHANGED');
        self::assertSame(0, DB::table('quotation_versions')->count());
        $draft['delivery']['final_fee_centavos'] = 60500;
        $v = $this->publishQuote($id, $draft, 2)['versions'][0];
        self::assertSame(60500, $v['content']['delivery']['gross_charge_centavos']);
        self::assertSame($deduction, $v['content']['discount']['deduction_centavos']);
        self::assertSame($netFee, $v['content']['delivery']['final_charge_centavos']);
        self::assertSame([6800, 0, $netFee, 6800 + $netFee], [$v['content']['commercial']['materials_payable_centavos'], $v['content']['commercial']['vendor_discount_centavos'], $v['content']['commercial']['delivery_centavos'], $v['content']['commercial']['commercial_total_centavos']]);
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $v['id'], 'content_hash' => $v['content_hash'], 'payment_method' => 'ONLINE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame($netFee, (int) DB::table('order_delivery_snapshots')->where('order_id', $order)->value('final_charge_centavos'));
        self::assertSame(6800 + $netFee, (int) DB::table('financial_snapshots')->where('order_id', $order)->value('buyer_total_centavos'));
    }

    public function test_percentage_discount_validation_rejects_wrong_scope_precision_and_double_discounts(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Discount validation');
        $variant = $this->variantIds($listing)[0];
        $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        foreach ([[], ['scope' => 'MATERIALS'], ['scope' => 'DELIVERY', 'percent' => '10'], ['scope' => 'MATERIALS', 'percent' => '100.01'], ['scope' => 'MATERIALS', 'percent' => '1.001'], ['scope' => 'ORDER', 'percent' => '10']] as $discount) {
            $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $this->draftInput($variant) + ['discount' => $discount]])->assertUnprocessable();
        }
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $this->draftInput($variant) + ['vendor_discount_centavos' => 100, 'discount' => ['scope' => 'MATERIALS', 'percent' => '10']]])->assertUnprocessable();
    }

    public function test_unknown_payable_tax_and_scanner_failure_never_publish_private_content(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Fail closed');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $this->draftInput($variant)])->assertOk();
        DB::table('vendor_tax_profiles')->where('vendor_organization_id', $store->id)->update(['current_version_id' => null]);
        $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PAYABLE_TAX_CATEGORY_UNKNOWN');
        self::assertSame(0, DB::table('quotation_versions')->count());
        $this->signInBuyer($buyer);
        $scanner = \Mockery::mock(VendorFileScanner::class);
        $scanner->shouldReceive('assertClean')->andThrow(new AuthenticationException('FILE_SCANNER_UNAVAILABLE', 'Scanning is unavailable.', 503));
        $this->app->instance(VendorFileScanner::class, $scanner);
        $this->post('/api/v1/buyers/conversations/'.$id.'/attachments', ['file' => UploadedFile::fake()->image('photo.png'), 'client_message_id' => (string) Str::uuid7()], ['Accept' => 'application/json'])->assertStatus(503);
        self::assertSame(0, DB::table('message_attachments')->count());
    }
}
