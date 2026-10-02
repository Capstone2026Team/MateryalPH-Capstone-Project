<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationAccess;
use App\Domain\Messaging\ConversationBroadcast;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Contracts\Broadcasting\Broadcaster;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
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

    private function draftInput(string $variant, string $qty = '4'): array
    {
        return ['lines' => [['variant_id' => $variant, 'quantity' => $qty, 'unit_price_centavos' => 1700]], 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'fulfillment_date' => now()->addDays(3)->toDateString()];
    }

    private function publishQuote(string $id, array $draft, int $lock = 1): array
    {
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => $lock, 'draft' => $draft])->assertOk();

        return $this->postJson('/api/v1/vendor/conversations/'.$id.'/quotation/publish', ['lock_version' => $lock + 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
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
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $old['id'], 'content_hash' => $old['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'QUOTATION_VERSION_CONFLICT');
        $latest = $second['versions'][0];
        $key = (string) Str::uuid7();
        $payload = ['version_id' => $latest['id'], 'content_hash' => $latest['content_hash']];
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
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $quote['id'], 'content_hash' => $quote['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'STOCK_REVALIDATION_REQUIRED');
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
        $this->getJson('/api/v1/vendor/messaging/realtime')->assertOk()->assertJsonPath('data.inbox_channel', null);
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
        $this->putJson('/api/v1/vendor/conversations/'.$id.'/quotation/draft', ['lock_version' => 1, 'draft' => $draft])->assertForbidden();
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
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $v['id'], 'content_hash' => $v['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'QUOTATION_EXPIRED');
        self::assertSame(0, DB::table('orders')->count());
        self::assertSame(0, DB::table('inventory_holds')->where('state', 'ACTIVE')->count());
    }

    public function test_two_published_quotes_cannot_both_reserve_the_last_units(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Contended', [['price' => 1800, 'qty' => '5']]);
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $first = $this->inquiry($store->id, $variant);
        $second = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $a = $this->publishQuote($first, $this->draftInput($variant))['versions'][0];
        $b = $this->publishQuote($second, $this->draftInput($variant))['versions'][0];
        self::assertSame('0.0000', $this->reserved($variant));
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', ['version_id' => $a['id'], 'content_hash' => $a['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->postJson('/api/v1/buyers/conversations/'.$second.'/quotation/accept', ['version_id' => $b['id'], 'content_hash' => $b['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'STOCK_REVALIDATION_REQUIRED');
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
        $payload = ['version_id' => $a['id'], 'content_hash' => $a['content_hash']];
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk();
        $this->postJson('/api/v1/buyers/conversations/'.$first.'/quotation/accept', $payload, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame($store->id, DB::table('work_packages')->where('id', $package)->value('selected_vendor_organization_id'));
        $this->getJson('/api/v1/buyers/conversations/'.$second)->assertOk()->assertJsonPath('data.quotations.quotation.state', 'EXPIRED')->assertJsonCount(1, 'data.quotations.versions');
        self::assertSame(1, DB::table('orders')->where('work_package_id', $package)->count());
    }

    public function test_fulfillment_service_cannot_open_early_and_is_idempotent_at_milestone(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Fulfillment');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        try {
            app(FulfillmentThreadService::class)->ensureForMilestone($order);
            self::fail('Early thread creation must fail');
        } catch (AuthenticationException $e) {
            self::assertSame('FULFILLMENT_THREAD_NOT_READY', $e->errorCode);
        }
        self::assertFalse(FulfillmentThreadService::ENTRY_ENABLED);
        DB::table('orders')->where('id', $order)->update(['order_state' => 'READY_FOR_PICKUP']);
        $assigned = $this->teamMember($store, 'FULFILLMENT');
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'user_id' => $assigned->id, 'assigned_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        $id = app(FulfillmentThreadService::class)->ensureForMilestone($order);
        self::assertSame($id, app(FulfillmentThreadService::class)->ensureForMilestone($order));
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
        $request = Request::create('/internal');
        $request->setUserResolver(fn () => $owner);
        app(FulfillmentThreadService::class)->assign($request, $order, $replacement->id, 'Shift handover');
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
        app(FulfillmentThreadService::class)->assign($request, $otherOrder, (int) $assigned->id, 'Separate order assignment');
        $otherThread = app(FulfillmentThreadService::class)->ensureForMilestone($otherOrder);
        $this->signInStoreMember($replacement);
        $this->getJson('/api/v1/vendor/conversations/'.$otherThread)->assertNotFound();
        $this->signInStoreMember($assigned);
        $this->get('/api/v1/vendor/conversations/'.$otherThread.'/attachments/'.$attachment)->assertNotFound();
    }

    public function test_nrpc_quotation_acceptance_freezes_terms_and_allocations_once(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('NRPC quote');
        $variant = $this->variantIds($listing)[0];
        $buyer = $this->buyer();
        $id = $this->inquiry($store->id, $variant);
        $this->signInStoreMember($owner);
        $draft = $this->draftInput($variant);
        $draft['nrpc'] = ['amount_centavos' => 1000, 'reason' => 'Custom preparation for these materials', 'allocations' => [$variant => 1000]];
        $v = $this->publishQuote($id, $draft)['versions'][0];
        $this->signInBuyer($buyer);
        $payload = ['version_id' => $v['id'], 'content_hash' => $v['content_hash']];
        $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $payload += ['nrpc_acknowledged' => true, 'nrpc_terms_version_id' => $v['content']['nrpc']['terms']['id']];
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', $payload, ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame(6800, (int) DB::table('financial_snapshots')->where('order_id', $order)->value('buyer_total_centavos'));
        self::assertSame(1000, (int) DB::table('nrpc_line_allocations')->sum('principal_centavos'));
        self::assertSame(1, DB::table('nrpc_acceptances')->where('order_id', $order)->count());
    }

    public function test_delivery_quote_preserves_buyer_access_and_confirmed_vehicle_calculation(): void
    {
        [$store, $owner] = $this->activeStore('Quoted delivery', false, true);
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
        $this->signInBuyer($buyer);
        $order = $this->postJson('/api/v1/buyers/conversations/'.$id.'/quotation/accept', ['version_id' => $v['id'], 'content_hash' => $v['content_hash']], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data.order_id');
        self::assertSame(60500, (int) DB::table('order_delivery_snapshots')->where('order_id', $order)->value('final_charge_centavos'));
        self::assertSame($site, json_decode(DB::table('orders')->where('id', $order)->value('destination'), true)['intended']['location_id']);
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
