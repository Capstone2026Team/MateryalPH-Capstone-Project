<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
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

/**
 * Buyer My Orders (approved by the project owner on 2026-10-10): the order's Fulfillment Messages thread opens at
 * submission and stays writable until the order closes; Item/Project tabs and the Processing / To Ship / To Receive /
 * Completed / Cancelled / Disputed chips; card actions the server would also allow in Order Details; and Buy Again,
 * which re-adds lines at today's prices without revealing exact stock.
 */
final class BuyerMyOrdersTest extends TestCase
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

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    public function test_fulfillment_thread_opens_at_submission_is_writable_until_the_order_closes_and_shows_on_the_card(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Thread at submission');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $thread = (string) DB::table('conversations')->where('order_id', $orderId)->where('purpose', 'FULFILLMENT')->value('id');
        self::assertNotSame('', $thread, 'The thread opens in the submission transaction.');
        self::assertSame(1, DB::table('outbox_events')->where('event_type', 'CONVERSATION_CHANGED')->where('aggregate_id', $thread)->count());

        // The store can message while the request still awaits confirmation; the Buyer sees it as unread on the card.
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/conversations/'.$thread.'/messages', ['body' => 'We are checking stock now.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $this->signInBuyer($buyer);
        $row = $this->getJson('/api/v1/buyers/orders?group=CONFIRMATION')->assertOk()->json('data.0');
        self::assertSame(['id' => $thread, 'read_only' => false, 'unread_count' => 1], $row['fulfillment_conversation']);
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', ['body' => 'Thanks, please confirm today.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        // It stays out of the Buyer's inquiry inbox: fulfillment and inquiry conversations are separate.
        self::assertNotContains($thread, array_column($this->getJson('/api/v1/buyers/conversations')->assertOk()->json('data.items'), 'id'));

        $this->signInStoreMember($owner);
        $lock = (int) DB::table('orders')->where('id', $orderId)->value('lock_version');
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/decline', ['lock_version' => $lock, 'reason_code' => 'STOCK_UNAVAILABLE', 'reason' => 'Sold out today.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertSame(1, DB::table('messages')->where('conversation_id', $thread)->where('body', 'like', 'The store declined this order request.%')->count());

        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/conversations/'.$thread.'/messages', ['body' => 'Still there?', 'client_message_id' => (string) Str::uuid7()])
            ->assertConflict()->assertJsonPath('errors.0.code', 'CONVERSATION_READ_ONLY');
        $cancelled = $this->getJson('/api/v1/buyers/orders?group=CANCELLED')->assertOk()->json('data.0');
        self::assertTrue($cancelled['fulfillment_conversation']['read_only']);
        self::assertSame(['code' => 'VENDOR_STOCK_UNAVAILABLE', 'label' => 'Item out of stock'], $cancelled['closure_reason']);
        self::assertSame(['BUY_AGAIN', 'VIEW_CANCELLATION'], $cancelled['card_actions']);
    }

    public function test_buyer_opens_a_thread_for_an_older_open_order_but_never_for_a_closed_or_foreign_one(): void
    {
        [$store, , $listing] = $this->pickupStore('Older orders');
        [$buyer, $open] = $this->pickupOrder($store, $listing);
        [, $closed] = $this->pickupOrder($store, $listing, buyer: $buyer);
        // Simulate orders submitted before threads opened at submission.
        foreach ([$open, $closed] as $orderId) {
            $id = DB::table('conversations')->where('order_id', $orderId)->value('id');
            DB::table('conversation_assignments')->where('conversation_id', $id)->delete();
            DB::table('conversation_participants')->where('conversation_id', $id)->delete();
            DB::table('conversations')->where('id', $id)->delete();
        }
        DB::table('orders')->where('id', $closed)->update(['order_state' => 'CANCELLED', 'closed_at' => now()]);

        $this->signInBuyer($buyer);
        self::assertNull($this->getJson('/api/v1/buyers/orders')->assertOk()->json('data.0.fulfillment_conversation'));
        $this->postJson('/api/v1/buyers/orders/'.$open.'/fulfillment-conversation')->assertUnprocessable()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_KEY_REQUIRED');
        $first = $this->postJson('/api/v1/buyers/orders/'.$open.'/fulfillment-conversation', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.read_only', false)->json('data.conversation_id');
        $this->postJson('/api/v1/buyers/orders/'.$open.'/fulfillment-conversation', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.conversation_id', $first);
        self::assertSame(1, DB::table('conversations')->where('order_id', $open)->count());
        $this->postJson('/api/v1/buyers/orders/'.$closed.'/fulfillment-conversation', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'FULFILLMENT_THREAD_CLOSED');
        self::assertSame(0, DB::table('conversations')->where('order_id', $closed)->count());

        $this->buyer();
        $this->postJson('/api/v1/buyers/orders/'.$open.'/fulfillment-conversation', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertNotFound();
    }

    public function test_status_chips_procurement_tabs_and_card_actions(): void
    {
        [$store, , $listing] = $this->pickupStore('Order chips', [['price' => 1800, 'qty' => '100']]);
        [$buyer, $awaiting] = $this->pickupOrder($store, $listing);
        $ids = ['PROCESSING' => 'PROCESSING', 'TO_SHIP' => 'READY_FOR_PICKUP', 'TO_RECEIVE' => 'PICKED_UP', 'COMPLETED' => 'COMPLETED', 'DISPUTED' => 'DISPUTED', 'CANCELLED' => 'EXPIRED'];
        $orders = ['CONFIRMATION' => $awaiting];
        foreach ($ids as $group => $state) {
            [, $orders[$group]] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']], $buyer);
            DB::table('orders')->where('id', $orders[$group])->update(['order_state' => $state, 'closed_at' => in_array($state, ['COMPLETED', 'EXPIRED'], true) ? now() : null,
                'terminal_reason_code' => $state === 'EXPIRED' ? 'PAYMENT_WINDOW_EXPIRED' : null]);
        }
        DB::table('orders')->where('id', $orders['DISPUTED'])->update(['procurement_type' => 'PROJECT_BASED']);

        $this->signInBuyer($buyer);
        $all = $this->getJson('/api/v1/buyers/orders')->assertOk();
        self::assertSame(['ALL' => 7, 'CONFIRMATION' => 1, 'PROCESSING' => 1, 'TO_SHIP' => 1, 'TO_RECEIVE' => 1, 'COMPLETED' => 1, 'CANCELLED' => 1, 'DISPUTED' => 1], $all->json('meta.counts'));
        foreach ($orders as $group => $orderId) {
            $this->getJson('/api/v1/buyers/orders?group='.$group)->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $orderId);
        }
        $items = $this->getJson('/api/v1/buyers/orders?procurement_type=ITEM_BASED')->assertOk()->assertJsonPath('meta.counts.ALL', 6)->assertJsonPath('meta.counts.DISPUTED', 0);
        self::assertNotContains($orders['DISPUTED'], array_column($items->json('data'), 'id'));
        $this->getJson('/api/v1/buyers/orders?procurement_type=PROJECT_BASED')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $orders['DISPUTED']);
        $this->getJson('/api/v1/buyers/orders?group=AWAITING_ACTION')->assertUnprocessable();
        $this->getJson('/api/v1/buyers/orders?procurement_type=SERVICE')->assertUnprocessable();

        $rows = collect($all->json('data'))->keyBy('id');
        self::assertSame([], $rows[$orders['CONFIRMATION']]['card_actions']);
        self::assertSame([], $rows[$orders['PROCESSING']]['card_actions']);
        self::assertSame([], $rows[$orders['TO_SHIP']]['card_actions']);
        self::assertSame(['CONFIRM_RECEIPT', 'REPORT_PROBLEM'], $rows[$orders['TO_RECEIVE']]['card_actions']);
        self::assertSame(['FILE_DISPUTE', 'BUY_AGAIN'], $rows[$orders['COMPLETED']]['card_actions']);
        self::assertNotNull($rows[$orders['COMPLETED']]['return_refund_due_at']);
        self::assertSame([], $rows[$orders['DISPUTED']]['card_actions'], 'Project-Based orders have no Buy Again.');
        self::assertSame('Payment was not completed in time', $rows[$orders['CANCELLED']]['closure_reason']['label']);
        self::assertNull($rows[$orders['CONFIRMATION']]['payment_channel_name']);
    }

    public function test_profile_cancellation_refund_history_excludes_unrelated_states_and_foreign_orders(): void
    {
        [$store, , $listing] = $this->pickupStore('Profile history', [['price' => 1800, 'qty' => '100']]);
        [$buyer, $cancelled] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $cancelled)->update(['order_state' => 'CANCELLED', 'refund_state' => 'REFUND_PENDING', 'closed_at' => now()]);
        $included = [$cancelled];
        $partial = null;
        foreach ([['COMPLETED', 'REFUNDED'], ['COMPLETED', 'PARTIALLY_REFUNDED'], ['DECLINED', 'NOT_REQUESTED'],
            ['EXPIRED', 'NOT_REQUESTED'], ['CANCELLATION_REQUESTED', 'NOT_REQUESTED'], ['COMPLETED', 'REFUND_PENDING'],
            ['COMPLETED', 'REFUND_FAILED'], ['COMPLETED', 'NOT_REQUESTED']] as [$state, $refund]) {
            [, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']], $buyer);
            DB::table('orders')->where('id', $orderId)->update(['order_state' => $state, 'refund_state' => $refund, 'closed_at' => $state === 'CANCELLATION_REQUESTED' ? null : now()]);
            if (in_array($refund, ['REFUNDED', 'PARTIALLY_REFUNDED'], true)) {
                $included[] = $orderId;
            }
            if ($refund === 'PARTIALLY_REFUNDED') {
                $partial = $orderId;
                DB::table('orders')->where('id', $orderId)->update(['procurement_type' => 'PROJECT_BASED']);
            }
        }
        [, $foreign] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $foreign)->update(['order_state' => 'COMPLETED', 'refund_state' => 'REFUNDED', 'closed_at' => now()]);

        $this->signInBuyer($buyer);
        $history = $this->getJson('/api/v1/buyers/orders?group=CANCELLED_REFUNDED')->assertOk()
            ->assertJsonPath('meta.group', 'CANCELLED_REFUNDED')->assertJsonPath('meta.total', 3);
        self::assertEqualsCanonicalizing($included, array_column($history->json('data'), 'id'));
        self::assertNotContains($foreign, array_column($history->json('data'), 'id'));
        $this->getJson('/api/v1/buyers/orders?group=CANCELLED_REFUNDED&procurement_type=PROJECT_BASED')->assertOk()
            ->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $partial)->assertJsonPath('meta.total', 1);
    }

    public function test_profile_cancellation_refund_history_filters_before_pagination(): void
    {
        [$store, , $listing] = $this->pickupStore('History pagination', [['price' => 1800, 'qty' => '100']]);
        [$buyer, $unrelated] = $this->pickupOrder($store, $listing);
        $included = [];
        for ($index = 0; $index < 21; $index++) {
            [, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']], $buyer);
            DB::table('orders')->where('id', $orderId)->update(['order_state' => 'CANCELLED', 'closed_at' => now()]);
            $included[] = $orderId;
        }
        $this->signInBuyer($buyer);
        $first = $this->getJson('/api/v1/buyers/orders?group=CANCELLED_REFUNDED')->assertOk()->assertJsonCount(20, 'data')
            ->assertJsonPath('meta.total', 21)->assertJsonPath('meta.has_more', true);
        $second = $this->getJson('/api/v1/buyers/orders?group=CANCELLED_REFUNDED&page=2')->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('meta.total', 21)->assertJsonPath('meta.has_more', false);
        $ids = array_merge(array_column($first->json('data'), 'id'), array_column($second->json('data'), 'id'));
        self::assertEqualsCanonicalizing($included, $ids);
        self::assertNotContains($unrelated, $ids);
    }

    public function test_paid_channel_name_shows_on_the_card(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Paid channel');
        $this->startPayment($buyer, $orderId, 'GCASH');
        $this->completePayment((string) DB::table('payments')->where('order_id', $orderId)->value('id'))->assertOk();
        $this->signInBuyer($buyer);
        $name = $this->getJson('/api/v1/buyers/orders')->assertOk()->json('data.0.payment_channel_name');
        self::assertSame((string) DB::table('payments as p')->join('payment_channel_fee_versions as f', 'f.id', '=', 'p.channel_fee_version_id')->where('p.order_id', $orderId)->value('f.display_name'), $name);
    }

    public function test_buy_again_uses_todays_price_skips_what_cannot_be_added_and_is_idempotent(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Buy again', [['price' => 1800, 'qty' => '20'], ['price' => 2500, 'qty' => '20']]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '4'], ['variant' => 1, 'quantity' => '6']]);
        $this->savedLocation($buyer, 'Site', 300, 0, 'DELIVERY', true);
        [$first, $second] = $this->variantIds($listing);

        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/buy-again', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'BUY_AGAIN_UNAVAILABLE');
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);

        // Today's price differs from the order's; the second variant can no longer cover the old quantity.
        DB::table('listing_price_versions')->where('listing_variant_id', $first)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->update(['retired_at' => now()]);
        $current = (string) Str::uuid7();
        DB::table('listing_price_versions')->insert(['id' => $current, 'listing_variant_id' => $first, 'version' => 2, 'amount_centavos' => 2100, 'currency' => 'PHP', 'tax_category' => 'NON_VAT',
            'price_kind' => 'ORDINARY', 'effective_at' => now(), 'created_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('inventory_items')->where('listing_variant_id', $second)->update(['quantity_on_hand' => '5']);
        DB::table('cart_items')->delete();

        $key = (string) Str::uuid7();
        $result = $this->postJson('/api/v1/buyers/orders/'.$orderId.'/buy-again', [], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('meta.replayed', false)->json('data');
        self::assertCount(1, $result['added']);
        self::assertSame('QUANTITY_UNAVAILABLE', $result['skipped'][0]['reason_code']);
        self::assertStringNotContainsString('5', $result['skipped'][0]['message'], 'Exact stock is never revealed.');
        $line = DB::table('cart_items')->where('listing_variant_id', $first)->first();
        self::assertSame([$current, 2100, '4.0000'], [(string) $line->listing_price_version_id, (int) $line->unit_price_centavos, (string) $line->quantity]);
        self::assertSame(0, DB::table('cart_items')->where('listing_variant_id', $second)->count());
        self::assertSame(0, (int) DB::table('inventory_items')->where('listing_variant_id', $first)->value('hard_reserved_quantity'), 'Buy Again reserves nothing.');

        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/buy-again', [], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('meta.replayed', true);
        self::assertSame('4.0000', (string) DB::table('cart_items')->where('listing_variant_id', $first)->value('quantity'));

        $this->buyer();
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/buy-again', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertNotFound();
    }
}
