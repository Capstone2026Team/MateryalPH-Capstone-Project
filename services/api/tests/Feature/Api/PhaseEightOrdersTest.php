<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\PriceVersionService;
use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderExpiryService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
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

final class PhaseEightOrdersTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    private FakeRouteProvider $routes;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->routes = new FakeRouteProvider;
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, $this->routes);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    // ── Submission ──────────────────────────────────────────────────────────────────────────────────

    public function test_submission_creates_one_parent_and_one_child_per_vendor_without_reserving_and_is_idempotent(): void
    {
        [$alpha, , $alphaListing] = $this->pickupStore('Alpha Orders');
        [$bravo, , $bravoListing] = $this->pickupStore('Bravo Orders', [['price' => 2500, 'qty' => '30']], 1500);
        $buyer = $this->buyer();
        $this->addToCart($alphaListing, '3');
        $this->addToCart($bravoListing, '2');
        $variant = $this->variantIds($alphaListing)[0];

        $this->submitCheckout([$alpha->id])->assertStatus(422)->assertJsonPath('errors.0.code', 'SPLIT_CONFIRMATION_REQUIRED');
        $key = (string) Str::uuid7();
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $body = ['cart_lock_version' => $lock, 'vendor_ids' => [$alpha->id, $bravo->id]];
        $checkout = $this->postJson('/api/v1/buyers/checkouts', $body, ['Idempotency-Key' => $key])->assertCreated()->assertJsonCount(2, 'data.orders')
            ->assertJsonPath('data.derived_status', 'AWAITING_CONFIRMATIONS');
        foreach ($checkout->json('data.orders') as $order) {
            self::assertSame(['AWAITING_VENDOR_CONFIRMATION', 'NOT_REQUIRED', 'PICKUP', 'ONLINE'], [$order['order_state'], $order['payment_state'], $order['fulfillment_method'], $order['payment_method']]);
            self::assertEqualsWithDelta(CarbonImmutable::now()->addDay()->getTimestamp(), CarbonImmutable::parse($order['vendor_response_due_at'])->getTimestamp(), 5);
        }
        // Same key and body replays the same checkout; a changed body under the key is a conflict.
        $this->postJson('/api/v1/buyers/checkouts', $body, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.id', $checkout->json('data.id'))->assertJsonPath('meta.replayed', true);
        $this->postJson('/api/v1/buyers/checkouts', ['vendor_ids' => [$alpha->id]] + $body, ['Idempotency-Key' => $key])->assertStatus(409)->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        self::assertSame(1, DB::table('checkout_groups')->count());
        self::assertSame(2, DB::table('orders')->count());

        // No reservation, no hold, no stock change at submission; the cart lines became orders.
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame('0.0000', $this->reserved($variant));
        $this->getJson('/api/v1/buyers/cart')->assertOk()->assertJsonCount(0, 'data.groups');

        // Each child keeps a price, tax and image snapshot; later listing price changes never rewrite it.
        $alphaOrder = collect($checkout->json('data.orders'))->firstWhere('vendor.id', $alpha->id)['id'];
        $line = DB::table('order_lines')->where('order_id', $alphaOrder)->first();
        self::assertSame([1800, 5400, 'NON_VAT'], [(int) $line->unit_price_centavos, (int) $line->payable_centavos, $line->tax_category]);
        self::assertSame('Listing', explode(' ', (string) json_decode((string) $line->snapshot, true)['display_name'])[0]);
        DB::transaction(fn () => app(PriceVersionService::class)->saveOrdinary(DB::table('vendor_memberships')->where('vendor_organization_id', $alpha->id)->value('user_id'), $variant, 2100, 'NON_VAT', null));
        $detail = $this->buyerOrder($buyer, $alphaOrder);
        self::assertSame(1800, $detail['lines'][0]['unit_price_centavos']);
        self::assertSame(5400, $detail['money']['materials_subtotal_centavos']);
        self::assertSame(['ORDER', 'PAYMENT', 'FULFILLMENT', 'REFUND', 'DISPUTE'], array_column($detail['states'], 'family'));
        self::assertSame('ADVISORY_UNTIL_VENDOR_CONFIRMATION', $detail['money']['status']);
        self::assertSame(['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'], $detail['money']['excludes']);
        // Without a configured policy the order was evaluated for auto-accept and left for manual review.
        self::assertFalse(json_decode((string) DB::table('orders')->where('id', $alphaOrder)->value('auto_accept_outcome'), true)['accepted']);

        // Another Buyer cannot read it.
        $this->buyer();
        $this->getJson('/api/v1/buyers/orders/'.$alphaOrder)->assertNotFound()->assertJsonPath('errors.0.code', 'ORDER_NOT_FOUND');
        $this->getJson('/api/v1/buyers/checkouts/'.$checkout->json('data.id'))->assertNotFound();
    }

    // ── Manual confirmation, acceptance snapshot and payment expiry ──────────────────────────────────

    public function test_unchanged_manual_confirmation_reserves_freezes_the_snapshot_and_the_45_minute_window_expires_cleanly(): void
    {
        CarbonImmutable::setTestNow(CarbonImmutable::parse('2026-10-05 09:00:00', 'Asia/Manila'));
        Carbon::setTestNow(Carbon::parse('2026-10-05 09:00:00', 'Asia/Manila'));
        [$store, $owner, $listing] = $this->pickupStore('Confirm Hardware');
        $variant = $this->variantIds($listing)[0];
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);

        $this->confirmOrder($owner, $orderId)->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT')->assertJsonPath('data.states.1.state', 'PENDING')
            ->assertJsonPath('data.primary_action', 'WAITING_FOR_PAYMENT')->assertJsonPath('data.reservations.0.state', 'ACTIVE');
        self::assertSame('4.0000', $this->reserved($variant));
        self::assertSame('20.0000', (string) DB::table('inventory_items')->where('listing_variant_id', $variant)->value('quantity_on_hand'), 'Reservation never changes physical stock.');
        $order = DB::table('orders')->where('id', $orderId)->first();
        self::assertSame('2026-10-05 01:45:00', CarbonImmutable::parse((string) $order->payment_expires_at)->utc()->format('Y-m-d H:i:s'), '45 minutes from entering AWAITING_PAYMENT.');
        $snapshot = DB::table('financial_snapshots')->where('order_id', $orderId)->first();
        self::assertSame([1, 7200, 7200, 0, 7200, 0, 7200], [(int) $snapshot->version, (int) $snapshot->materials_gross_centavos, (int) $snapshot->materials_payable_centavos, (int) $snapshot->materials_vat_centavos,
            (int) $snapshot->materials_exclusive_centavos, (int) $snapshot->delivery_centavos, (int) $snapshot->buyer_total_centavos]);
        $fee = DB::table('fee_assessments')->where('order_id', $orderId)->first();
        self::assertSame(['ESTIMATED', 144, 0], [$fee->state, (int) $fee->earned_target_centavos, (int) $fee->earned_centavos], 'ESTIMATED money(7,200 × 2%); nothing earned at confirmation.');
        $this->expectFeeNotEarnable($orderId);

        // Buyer sees the countdown target and exact time; the order history is append-only.
        $detail = $this->buyerOrder($buyer, $orderId);
        self::assertSame($detail['deadlines']['payment_expires_at'], CarbonImmutable::parse((string) $order->payment_expires_at)->toIso8601String());
        self::assertSame(['available' => false, 'reason' => 'ONLINE_PAYMENT_NOT_YET_ENABLED'], array_intersect_key($detail['payment'], array_flip(['available', 'reason'])));
        self::assertSame([7200, 7200, null, 'PENDING_PAYMENT_CHANNEL', 'FULL_ORDER_PAYMENT', 0], [$detail['money']['commercial_total_centavos'], $detail['money']['online_principal_centavos'],
            $detail['money']['amount_due_online_centavos'], $detail['money']['processing_fee']['status'], $detail['money']['payment_purpose'], $detail['money']['physical_balance_centavos']]);
        try {
            DB::transaction(fn () => DB::table('order_status_history')->where('order_id', $orderId)->update(['reason' => 'rewritten']));
            self::fail('Order history is append-only.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('append-only', $exception->getMessage());
        }
        try {
            DB::transaction(fn () => DB::table('financial_snapshots')->where('order_id', $orderId)->update(['materials_payable_centavos' => 1]));
            self::fail('Financial snapshots are immutable.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('append-only', $exception->getMessage());
        }

        // At 44:59 nothing expires; at 45:00 the read resolves the order to EXPIRED and releases the stock.
        $this->travelTo(CarbonImmutable::parse('2026-10-05 09:44:59', 'Asia/Manila'));
        self::assertSame(0, app(OrderExpiryService::class)->sweep());
        $this->travelTo(CarbonImmutable::parse('2026-10-05 09:45:00', 'Asia/Manila'));
        $expired = $this->buyerOrder($buyer, $orderId);
        self::assertSame(['EXPIRED', 'EXPIRED'], [$expired['states'][0]['state'], $expired['states'][1]['state']]);
        self::assertSame('PAYMENT_WINDOW_EXPIRED', $expired['terminal_reason_code']);
        self::assertSame('0.0000', $this->reserved($variant));
        self::assertSame(['RELEASED', 'PAYMENT_WINDOW_EXPIRED'], [(string) DB::table('inventory_holds')->where('source_id', $orderId)->value('state'), (string) DB::table('inventory_holds')->where('source_id', $orderId)->value('release_reason')]);
        self::assertSame('CANCELLED', DB::table('fee_assessments')->where('order_id', $orderId)->value('state'));
        self::assertSame(['ESTIMATED', 'CANCELLED'], DB::table('fee_assessment_events')->where('order_id', $orderId)->orderBy('created_at')->pluck('event_type')->all());
        self::assertSame(0, app(OrderExpiryService::class)->sweep(), 'Expiry is idempotent.');
    }

    public function test_vendor_response_window_expires_after_24_hours_without_any_reservation(): void
    {
        [$store, , $listing] = $this->pickupStore('Slow Hardware');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->travel(24)->hours();
        $this->travel(1)->seconds();
        self::assertSame(1, app(OrderExpiryService::class)->sweep());
        self::assertSame(['EXPIRED', 'NOT_REQUIRED', 'VENDOR_RESPONSE_TIMEOUT'], [$this->buyerOrder($buyer, $orderId)['states'][0]['state'], $this->buyerOrder($buyer, $orderId)['states'][1]['state'], $this->buyerOrder($buyer, $orderId)['terminal_reason_code']]);
        self::assertSame(0, DB::table('inventory_holds')->count());
    }

    // ── Revision, Buyer approval and roles ───────────────────────────────────────────────────────────

    public function test_revision_is_published_only_by_authorized_roles_allocates_discount_exactly_and_needs_buyer_approval(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Revise Hardware', [['price' => 1000, 'qty' => '50'], ['price' => 2000, 'qty' => '50'], ['price' => 3000, 'qty' => '50']]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1'], ['variant' => 1, 'quantity' => '1'], ['variant' => 2, 'quantity' => '5']]);
        $service = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $inventory = $this->teamMember($store, 'INVENTORY');
        $lines = $this->vendorOrder($owner, $orderId)['lines'];
        $reduce = [$lines[2]['id'] => '3'];

        $this->confirmOrder($inventory, $orderId)->assertForbidden();
        $this->confirmOrder($service, $orderId, $reduce)->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        $this->confirmOrder($service, $orderId, [], ['vendor_discount_centavos' => 100])->assertForbidden();
        $this->confirmOrder($staff, $orderId, [$lines[0]['id'] => '2'])->assertStatus(422)->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        self::assertSame(0, DB::table('inventory_holds')->count(), 'A denied or invalid confirmation reserves nothing.');

        // 1×₱10 + 1×₱20 + 3×₱30 = ₱120.00 gross; a ₱1.00 discount by largest remainder (ties by line id).
        $revised = $this->confirmOrder($staff, $orderId, $reduce, ['vendor_discount_centavos' => 100])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_BUYER_APPROVAL');
        self::assertSame(['QUANTITY_REDUCED', 'VENDOR_DISCOUNT'], array_column($revised->json('data.changes'), 'type'));
        $money = $revised->json('data.money');
        self::assertSame([12000, 100, 11900], [$money['materials_gross_centavos'], $money['vendor_discount_centavos'], $money['materials_subtotal_centavos']]);
        self::assertSame(100, array_sum(array_column($revised->json('data.lines'), 'discount_centavos')), 'Allocated discounts sum exactly to the order discount.');
        self::assertSame('3.0000', $this->reserved($this->variantIds($listing)[2]), 'The revised confirmed quantity is reserved.');

        // The Buyer must approve the exact version; a stale version is rejected.
        $detail = $this->buyerOrder($buyer, $orderId);
        self::assertContains('APPROVE_REVISION', $detail['available_actions']);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/approve', ['snapshot_version' => 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'STALE_VERSION');
        $key = (string) Str::uuid7();
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/approve', ['snapshot_version' => 2], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/approve', ['snapshot_version' => 2], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT');
        $frozen = DB::table('financial_snapshots')->where('order_id', $orderId)->first();
        self::assertSame([12000, 100, 11900], [(int) $frozen->materials_gross_centavos, (int) $frozen->vendor_discount_centavos, (int) $frozen->materials_payable_centavos]);
        self::assertSame(100, (int) DB::table('financial_allocations')->where('financial_snapshot_id', $frozen->id)->where('allocation_type', 'VENDOR_DISCOUNT')->sum('amount_centavos'));
        self::assertSame(1, DB::table('financial_snapshots')->where('order_id', $orderId)->count());
        self::assertSame('BUYER_APPROVED_REVISION', DB::table('order_status_history')->where('order_id', $orderId)->where('to_state', 'AWAITING_PAYMENT')->value('reason_code'));
    }

    public function test_buyer_rejecting_a_revision_cancels_and_releases_the_reservation(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Reject Hardware');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '6']]);
        $line = $this->vendorOrder($owner, $orderId)['lines'][0];
        $this->confirmOrder($owner, $orderId, [$line['id'] => '4'])->assertOk();
        self::assertSame('4.0000', $this->reserved($this->variantIds($listing)[0]));
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/reject', ['snapshot_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'CANCELLED')->assertJsonPath('data.terminal_reason_code', 'BUYER_REJECTED_REVISION');
        self::assertSame('0.0000', $this->reserved($this->variantIds($listing)[0]));
    }

    /** @return array<string, array{bool, bool}> */
    public static function buyerExpiryCases(): array
    {
        return ['revision read' => [false, false], 'revision sweep' => [false, true], 'nrpc read' => [true, false], 'nrpc sweep' => [true, true]];
    }

    #[DataProvider('buyerExpiryCases')]
    public function test_buyer_window_is_24_hours_from_vendor_revision_and_releases_on_read_or_sweep(bool $nrpc, bool $sweep): void
    {
        $this->travelTo(Carbon::parse('2026-10-05 01:00:00', 'UTC'));
        [$store, $owner, $listing] = $this->pickupStore('Response Window');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->travel(3)->hours();
        $revisionAt = CarbonImmutable::now();
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $extra = $nrpc ? ['nrpc' => ['amount_centavos' => 1000, 'reason' => 'Special cutting for this order', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 1000]]]] : [];
        $response = $this->confirmOrder($owner, $orderId, $nrpc ? [] : [$line => '3'], $extra)->assertOk();
        $pending = $nrpc ? 'AWAITING_NRPC_ACCEPTANCE' : 'AWAITING_BUYER_APPROVAL';
        $response->assertJsonPath('data.states.0.state', $pending);
        self::assertSame($revisionAt->addDay()->timestamp, CarbonImmutable::parse($response->json('data.deadlines.buyer_response_due_at'))->timestamp);
        self::assertSame($nrpc ? '4.0000' : '3.0000', $this->reserved($this->variantIds($listing)[0]));
        $this->travelTo(Carbon::instance($revisionAt->addDay()->subSecond()));
        self::assertSame($pending, $this->buyerOrder($buyer, $orderId)['states'][0]['state']);
        self::assertSame(0, app(OrderExpiryService::class)->sweep());
        $this->travel(1)->seconds();
        if ($sweep) {
            self::assertSame(1, app(OrderExpiryService::class)->sweep());
        }
        $expired = $this->buyerOrder($buyer, $orderId);
        self::assertSame('EXPIRED', $expired['states'][0]['state']);
        self::assertSame('BUYER_RESPONSE_TIMEOUT', $expired['terminal_reason_code']);
        self::assertSame('0.0000', $this->reserved($this->variantIds($listing)[0]));
        self::assertSame(0, $this->activeHolds($orderId));
        self::assertSame(0, app(OrderExpiryService::class)->sweep());
    }

    public function test_only_owner_and_manager_can_edit_auto_accept_pickup_lead_time(): void
    {
        [$store, $owner] = $this->pickupStore('Lead Time Authority');
        foreach (['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $this->signInStoreMember($role === 'OWNER' ? $owner : $this->teamMember($store, $role));
            $version = (int) (DB::table('vendor_inventory_settings')->where('vendor_organization_id', $store->id)->value('lock_version') ?? 0);
            $response = $this->putJson('/api/v1/vendor/inventory/settings', ['lock_version' => $version, 'reminder_local_time' => '08:00', 'email_reminders' => true, 'auto_accept_ready_lead_days' => 2]);
            if (in_array($role, ['OWNER', 'STORE_MANAGER'], true)) {
                $response->assertOk()->assertJsonPath('data.auto_accept_ready_lead_days', 2);
            } else {
                $response->assertForbidden();
                self::assertSame($version, (int) DB::table('vendor_inventory_settings')->where('vendor_organization_id', $store->id)->value('lock_version'));
            }
        }
    }

    public function test_submission_cannot_offer_cash_and_revision_cannot_override_the_snapshotted_price(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Price Boundary');
        foreach (['COD', 'IN_STORE'] as $method) {
            $buyer = $this->buyer();
            $this->addToCart($listing, '2');
            $lock = $this->getJson('/api/v1/buyers/cart')->assertOk()->json('data.lock_version');
            $orderId = $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => [$store->id], 'payment_method' => $method], ['Idempotency-Key' => (string) Str::uuid7()])
                ->assertCreated()->assertJsonPath('data.orders.0.payment_method', 'ONLINE')->json('data.orders.0.id');
            $line = $this->vendorOrder($owner, $orderId)['lines'][0];
            $this->confirmOrder($owner, $orderId, [], ['vendor_discount_centavos' => -1])->assertStatus(422);
            $this->confirmOrder($owner, $orderId, [], ['lines' => [['order_line_id' => $line['id'], 'confirmed_quantity' => '1', 'unit_price_centavos' => 999999]]])
                ->assertOk()->assertJsonPath('data.lines.0.unit_price_centavos', 1800)->assertJsonPath('data.money.materials_subtotal_centavos', 1800);
            self::assertSame('AWAITING_BUYER_APPROVAL', $this->buyerOrder($buyer, $orderId)['states'][0]['state']);
        }
    }

    // ── NRPC ─────────────────────────────────────────────────────────────────────────────────────────

    public function test_manual_nrpc_needs_amount_reason_lines_and_terms_and_the_buyer_accepts_or_flags_it_separately(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Cut Hardware', [['price' => 2500, 'qty' => '40']]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '10']]);
        $service = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $nrpc = static fn (int $amount, int $principal): array => ['nrpc' => ['amount_centavos' => $amount, 'reason' => 'Custom cutting to the Buyer drawings', 'lines' => [['order_line_id' => $line, 'principal_centavos' => $principal]]]];

        $this->confirmOrder($service, $orderId, [], $nrpc(5000, 5000))->assertForbidden();
        $this->confirmOrder($owner, $orderId, [], $nrpc(25001, 25001))->assertStatus(422)->assertJsonPath('errors.0.code', 'FINANCIAL_RULE_VIOLATION');
        $this->confirmOrder($owner, $orderId, [], $nrpc(5000, 4000))->assertStatus(422)->assertJsonPath('errors.0.code', 'FINANCIAL_RULE_VIOLATION');
        $this->confirmOrder($owner, $orderId, [], ['nrpc' => ['amount_centavos' => 5000, 'reason' => 'short', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 5000]]]])->assertStatus(422);
        self::assertSame(0, DB::table('inventory_holds')->count());

        // N equal to the full prepared subtotal is allowed: there is no platform cap.
        $proposed = $this->confirmOrder($owner, $orderId, [], $nrpc(25000, 25000))->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_NRPC_ACCEPTANCE');
        self::assertSame(25000, $proposed->json('data.money.nrpc.amount_centavos'));
        self::assertSame(25000, $proposed->json('data.money.materials_subtotal_centavos'), 'NRPC is part of the order value, never added on top.');

        $detail = $this->buyerOrder($buyer, $orderId);
        $terms = $detail['nrpc']['terms'];
        self::assertSame(['ACCEPT_NRPC', 'REJECT_NRPC', 'FLAG_NRPC'], $detail['available_actions']);
        self::assertSame([25000, 'Custom cutting to the Buyer drawings', 1], [$detail['nrpc']['amount_centavos'], $detail['nrpc']['reason'], $terms['version']]);
        self::assertNotNull($terms['content']);
        self::assertSame($line, $detail['nrpc']['affected_lines'][0]['order_line_id']);

        // Flagging is separate: it neither accepts nor changes the order.
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/flag', ['nrpc_id' => $detail['nrpc']['id'], 'reason' => 'This looks disproportionate for simple cuts.'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_NRPC_ACCEPTANCE')->assertJsonPath('data.nrpc.flag.review_state', 'PENDING_ADMIN_REVIEW')->assertJsonPath('data.nrpc.status', 'PROPOSED');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/flag', ['nrpc_id' => $detail['nrpc']['id'], 'reason' => 'Flagging the same NRPC a second time.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409);

        $accept = ['snapshot_version' => 2, 'nrpc_id' => $detail['nrpc']['id'], 'terms_version_id' => $terms['id'], 'acknowledged' => true];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', ['acknowledged' => false] + $accept, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', ['terms_version_id' => (string) Str::uuid7()] + $accept, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'NRPC_TERMS_CHANGED');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', $accept, ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT')->assertJsonPath('data.nrpc.status', 'ACCEPTED')->assertJsonPath('data.nrpc.flag.review_state', 'PENDING_ADMIN_REVIEW');
        $acceptance = DB::table('nrpc_acceptances')->where('order_id', $orderId)->where('decision', 'ACCEPTED')->first();
        self::assertSame($terms['id'], (string) $acceptance->agreement_version_id);
        $frozen = DB::table('financial_snapshots')->where('order_id', $orderId)->first();
        self::assertSame(25000, (int) $frozen->nrpc_centavos);
        self::assertSame(25000, (int) DB::table('financial_allocations')->where('financial_snapshot_id', $frozen->id)->where('allocation_type', 'NRPC_PRINCIPAL')->sum('amount_centavos'), 'NRPC is allocated once.');
        self::assertSame(25000, (int) $frozen->buyer_total_centavos, 'The NRPC stays inside the commercial total.');

        // NRPC can never be introduced after acceptance, nor can a confirmed order be confirmed again.
        $this->confirmOrder($owner, $orderId, [], $nrpc(1000, 1000))->assertStatus(409);
        self::assertSame(1, DB::table('nrpc_records')->where('order_id', $orderId)->count());
    }

    public function test_rejecting_an_nrpc_cancels_the_order_and_releases_stock(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Mix Hardware');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $this->confirmOrder($owner, $orderId, [], ['nrpc' => ['amount_centavos' => 1000, 'reason' => 'Special mixing batch for this order', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 1000]]]])->assertOk();
        $nrpcId = $this->buyerOrder($buyer, $orderId)['nrpc']['id'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/reject', ['snapshot_version' => 2, 'nrpc_id' => $nrpcId], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'CANCELLED')->assertJsonPath('data.nrpc.status', 'REJECTED');
        self::assertSame('0.0000', $this->reserved($this->variantIds($listing)[0]));
        self::assertSame(0, DB::table('financial_snapshots')->where('order_id', $orderId)->count(), 'Nothing was accepted, so nothing is frozen.');
    }

    // ── Auto-accept ──────────────────────────────────────────────────────────────────────────────────

    public function test_eligible_pickup_order_auto_accepts_atomically_consumes_allotment_and_pauses_at_zero(): void
    {
        $this->travelTo(Carbon::parse('2026-10-05 01:00:00', 'UTC'));
        [$store, $owner, $listing] = $this->pickupStore('Auto Hardware');
        $variant = $this->variantIds($listing)[0];
        $this->enableAutoAccept($owner, $store->id, $variant, '4', null, null, 2);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '4']]);

        $detail = $this->buyerOrder($buyer, $orderId);
        self::assertSame(CarbonImmutable::now()->addMinutes(45)->timestamp, CarbonImmutable::parse($detail['deadlines']['payment_expires_at'])->timestamp);
        self::assertSame(['AWAITING_PAYMENT', 'PENDING', 'AUTO_ACCEPT'], [$detail['states'][0]['state'], $detail['states'][1]['state'], $detail['confirmation_source']]);
        self::assertSame(CarbonImmutable::now('Asia/Manila')->addDays(2)->toDateString(), $detail['expected_fulfillment_date']);
        self::assertSame('4.0000', $this->reserved($variant));
        $policy = DB::table('auto_accept_policies')->where('listing_variant_id', $variant)->first();
        self::assertSame(['0', true, 'ALLOTMENT_EXHAUSTED'], [bcadd((string) $policy->remaining_allotment_quantity, '0', 0), (bool) $policy->paused, $policy->pause_reason]);
        $confirmation = DB::table('vendor_confirmations')->where('order_id', $orderId)->first();
        self::assertSame(['AUTO_ACCEPT', null], [$confirmation->source, $confirmation->actor_user_id]);
        self::assertSame(1, DB::table('vendor_confirmation_policy_versions')->where('vendor_confirmation_id', $confirmation->id)->count());
        self::assertSame(1, DB::table('financial_snapshots')->where('order_id', $orderId)->count());

        // The next order finds the policy paused and goes to manual review with no partial change.
        [, $second] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']]);
        $outcome = json_decode((string) DB::table('orders')->where('id', $second)->value('auto_accept_outcome'), true);
        self::assertFalse($outcome['accepted']);
        self::assertContains('POLICY_NOT_ACTIVE', array_column($outcome['reasons'], 'code'));
        self::assertSame('AWAITING_VENDOR_CONFIRMATION', DB::table('orders')->where('id', $second)->value('order_state'));
        self::assertSame('4.0000', $this->reserved($variant));

        // Payment expiry releases the reservation and restores allotment, but never clears the pause.
        $this->travel(46)->minutes();
        self::assertTrue(app(OrderExpiryService::class)->expireIfDue($orderId));
        $policy = DB::table('auto_accept_policies')->where('listing_variant_id', $variant)->first();
        self::assertSame(['4', true], [bcadd((string) $policy->remaining_allotment_quantity, '0', 0), (bool) $policy->paused]);
        self::assertSame('0.0000', $this->reserved($variant));
        self::assertSame('ALLOTMENT_UPDATED', DB::table('auto_accept_policy_versions')->where('auto_accept_policy_id', $policy->id)->orderByDesc('version')->value('change_kind'));
    }

    public function test_any_failed_auto_accept_check_routes_the_whole_order_to_manual_review(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Guard Hardware', [['price' => 1000, 'qty' => '50'], ['price' => 1000, 'qty' => '50']]);
        [$first, $second] = $this->variantIds($listing);
        $this->enableAutoAccept($owner, $store->id, $first, '10', '5');
        $this->signInStoreMember($owner);
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$second, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '10', 'max_order_amount_centavos' => 5000])->assertOk();

        // Line 1 is within its caps; line 2 pushes the order over line 2's amount cap: nothing is accepted.
        [, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2'], ['variant' => 1, 'quantity' => '4']]);
        $outcome = json_decode((string) DB::table('orders')->where('id', $orderId)->value('auto_accept_outcome'), true);
        self::assertSame(['AMOUNT_CAP_EXCEEDED'], array_values(array_unique(array_column($outcome['reasons'], 'code'))));
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(['10', '10'], DB::table('auto_accept_policies')->orderBy('listing_variant_id')->pluck('remaining_allotment_quantity')->map(static fn (mixed $value): string => bcadd((string) $value, '0', 0))->all());

        // Unit cap, missing lead time and Site Delivery are independent reasons.
        [, $overCap] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '6']]);
        self::assertContains('UNIT_CAP_EXCEEDED', array_column(json_decode((string) DB::table('orders')->where('id', $overCap)->value('auto_accept_outcome'), true)['reasons'], 'code'));
        DB::table('vendor_inventory_settings')->where('vendor_organization_id', $store->id)->update(['auto_accept_ready_lead_days' => null]);
        [, $noDate] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']]);
        self::assertSame(['FULFILLMENT_DATE_NOT_CONFIGURED'], array_column(json_decode((string) DB::table('orders')->where('id', $noDate)->value('auto_accept_outcome'), true)['reasons'], 'code'));
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(0, DB::table('vendor_confirmations')->count());
    }

    // ── Site Delivery: authority, snapshot retention and address separation ─────────────────────────

    public function test_delivery_confirmation_is_owner_or_manager_only_and_freezes_the_drop_off_vehicles_and_fee(): void
    {
        [$store, $owner] = $this->activeStore('Delivery Orders', false, true);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('DLV', [['price' => 1800, 'qty' => '50']]);
        $vehicle = $this->addVehicle($store->id);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->placeStore($store->id, 1000);
        $this->connectOnlinePayments($store->id);
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Project site', 0, 0, 'PROJECT_SITE', true);
        $gate = $this->savedLocation($buyer, 'North gate', 1500, 0);
        $this->addToCart($listing, '10', 'DELIVERY');
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'Forklift at the north gate.'])->assertOk();
        $orderId = (string) $this->submitCheckout([$store->id])->assertCreated()->json('data.orders.0.id');

        $submitted = $this->buyerOrder($buyer, $orderId);
        self::assertSame(['Project site', 'North gate', 'ALTERNATE_DROP_OFF'], [$submitted['destination']['intended']['label'], $submitted['destination']['alternate_drop_off']['label'], $submitted['destination']['vehicle_endpoint']]);
        self::assertArrayNotHasKey('latitude', $submitted['destination']['intended'], 'Coordinates never leave the server.');
        self::assertSame(['PENDING_VENDOR_CONFIRMATION', 60500, 60500], [$submitted['money']['delivery']['status'], $submitted['money']['delivery']['estimate']['min_centavos'], $submitted['money']['delivery']['estimate']['max_centavos']]);
        self::assertContains('DELIVERY_REQUIRES_VENDOR_CONFIRMATION', array_column(json_decode((string) DB::table('orders')->where('id', $orderId)->value('auto_accept_outcome'), true)['reasons'], 'code'), 'An advisory suggestion is never an auto-accepted confirmation.');

        // The Vendor sees the advisory plan to the drop-off, not the intended site.
        $this->signInStoreMember($owner);
        $plan = $this->postJson('/api/v1/vendor/orders/'.$orderId.'/delivery-recommendations', [])->assertOk()->json('data');
        self::assertSame([true, 'ALTERNATE_DROP_OFF', 4200, 60500], [$plan['advisory'], $plan['endpoint']['kind'], $plan['route']['distance_meters'], $plan['groups'][0]['candidates'][0]['estimated_charge_centavos']]);
        $delivery = ['delivery' => ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60500,
            'fulfillment_date' => CarbonImmutable::now('Asia/Manila')->addDays(2)->toDateString(), 'arrangement' => 'One box-truck trip to the north gate.', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true]];

        // Store Staff may confirm pickup orders but never the delivery arrangement; nothing is reserved.
        $this->confirmOrder($staff, $orderId, [], $delivery)->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(0, DB::table('order_delivery_snapshots')->count());
        // An undisclosed fee is rejected; the formula fee is required.
        $this->confirmOrder($owner, $orderId, [], array_replace_recursive($delivery, ['delivery' => ['final_fee_centavos' => 70000]]))->assertStatus(409)->assertJsonPath('errors.0.code', 'DELIVERY_FEE_CHANGED');
        self::assertSame(0, DB::table('inventory_holds')->count());

        $this->confirmOrder($owner, $orderId, [], $delivery)->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_BUYER_APPROVAL');
        $review = $this->buyerOrder($buyer, $orderId);
        $confirmed = $review['delivery']['confirmed'];
        self::assertSame(['ALTERNATE_DROP_OFF', 'Project site', 'North gate', 4200, 60500, 'Box truck', 'Isuzu', 1, 'OWNER'],
            [$confirmed['endpoint'], $confirmed['intended']['label'], $confirmed['alternate_drop_off']['label'], $confirmed['distance_meters'], $confirmed['final_fee_centavos'],
                $confirmed['vehicles'][0]['name'], $confirmed['vehicles'][0]['brand'], $confirmed['vehicles'][0]['total_vehicle_trips'], $confirmed['confirmed_by_role']]);
        self::assertNotNull($confirmed['fulfillment_date']);
        self::assertNotNull($confirmed['confirmed_at']);
        self::assertSame(['CONFIRMED', 60500, 18000 + 60500], [$review['money']['delivery']['status'], $review['money']['delivery']['amount_centavos'], $review['money']['commercial_total_centavos']]);
        self::assertSame($site, DB::table('carts')->where('buyer_profile_id', $this->buyerProfileId($buyer))->value('intended_location_id'), 'The intended site is never replaced by the drop-off.');

        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/approve', ['snapshot_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT');
        $before = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->first();
        $financial = DB::table('financial_snapshots')->where('order_id', $orderId)->first();

        // Later vehicle, rate, profile and schedule changes never rewrite the accepted snapshot.
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['name' => 'Renamed truck', 'capacity_kg' => 800, 'number_available' => 1]);
        DB::table('vehicle_rate_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $vehicle, 'version' => (int) DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicle)->max('version') + 1,
            'base_fee_centavos' => 90000, 'per_km_centavos' => 5000, 'maximum_distance_km' => 40, 'effective_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        app(StoreOperatingSchedule::class)->replaceWeekly((string) DB::table('store_profiles')->where('vendor_organization_id', $store->id)->value('id'),
            array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['public_store_name' => 'Renamed Delivery Orders']);
        self::assertEquals($before, DB::table('order_delivery_snapshots')->where('order_id', $orderId)->first());
        self::assertEquals($financial, DB::table('financial_snapshots')->where('order_id', $orderId)->first());
        self::assertSame('Box truck', $this->buyerOrder($buyer, $orderId)['delivery']['confirmed']['vehicles'][0]['name']);
    }

    // ── Current eligibility, restriction and stock ───────────────────────────────────────────────────

    public function test_restriction_or_public_media_invalidation_blocks_new_confirmation_but_preserves_accepted_orders(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Restricted Hardware');
        [, $accepted] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        [, $pending] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        $this->confirmOrder($owner, $accepted)->assertOk();

        DB::table('vendor_organizations')->where('id', $store->id)->update(['activation_hold_code' => 'ADMIN_HOLD', 'activation_hold_reason' => 'Review']);
        $this->confirmOrder($owner, $pending)->assertStatus(409)->assertJsonPath('errors.0.code', 'STORE_NOT_ELIGIBLE')->assertJsonPath('errors.0.details.blockers.0', 'STORE_RESTRICTED');
        DB::table('vendor_organizations')->where('id', $store->id)->update(['activation_hold_code' => null, 'activation_hold_reason' => null]);
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['status' => 'IN_PROGRESS']);
        $this->confirmOrder($owner, $pending)->assertStatus(409)->assertJsonPath('errors.0.details.blockers.0', 'STORE_PROFILE_INCOMPLETE');
        self::assertSame(0, $this->activeHolds($pending));

        // The accepted order keeps its reservation, snapshot and state through the restriction.
        self::assertSame('AWAITING_PAYMENT', DB::table('orders')->where('id', $accepted)->value('order_state'));
        self::assertSame(1, $this->activeHolds($accepted));
        self::assertSame(1, DB::table('financial_snapshots')->where('order_id', $accepted)->count());
    }

    public function test_multi_line_confirmation_is_all_or_nothing_and_never_oversells(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Atomic Hardware', [['price' => 1000, 'qty' => '10'], ['price' => 1000, 'qty' => '10']]);
        [$first, $second] = $this->variantIds($listing);
        [, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '5'], ['variant' => 1, 'quantity' => '8']]);
        // Another confirmed order takes stock of the second variant after submission.
        [, $other] = $this->pickupOrder($store, $listing, [['variant' => 1, 'quantity' => '5']]);
        $this->confirmOrder($owner, $other)->assertOk();

        $this->confirmOrder($owner, $orderId)->assertStatus(409)->assertJsonPath('errors.0.code', 'STOCK_INSUFFICIENT')->assertJsonPath('errors.0.details.lines.0.available_to_sell', '5.0000');
        self::assertSame(['0.0000', '5.0000'], [$this->reserved($first), $this->reserved($second)], 'The first line was not reserved on its own.');
        self::assertSame(0, $this->activeHolds($orderId));
        foreach (DB::table('inventory_items')->get() as $item) {
            self::assertLessThanOrEqual(0, bccomp((string) $item->hard_reserved_quantity, (string) $item->quantity_on_hand, 4));
        }
        // A revision to the available quantity reserves both lines together.
        $lines = $this->vendorOrder($owner, $orderId)['lines'];
        $this->confirmOrder($owner, $orderId, [$lines[1]['id'] => '5'])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_BUYER_APPROVAL');
        self::assertSame(['5.0000', '10.0000'], [$this->reserved($first), $this->reserved($second)]);
    }

    public function test_decline_needs_a_reason_reserves_nothing_and_only_pending_orders_accept_vendor_actions(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Decline Hardware');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $detail = $this->vendorOrder($owner, $orderId);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/decline', ['lock_version' => $detail['lock_version'], 'reason_code' => 'STOCK_UNAVAILABLE', 'reason' => ''], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/decline', ['lock_version' => $detail['lock_version'] + 1, 'reason_code' => 'STOCK_UNAVAILABLE', 'reason' => 'Out of this batch'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'STALE_VERSION');
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/decline', ['lock_version' => $detail['lock_version'], 'reason_code' => 'STOCK_UNAVAILABLE', 'reason' => 'Out of this batch'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'DECLINED')->assertJsonPath('data.primary_action', 'NONE');
        $this->confirmOrder($owner, $orderId)->assertStatus(409);
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame('DECLINED', $this->buyerOrder($buyer, $orderId)['states'][0]['state']);

        // Another store never sees it; Fulfillment Staff do not see pending requests.
        [, $foreignOwner] = $this->pickupStore('Foreign Hardware');
        $this->signInStoreMember($foreignOwner);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        [, $pending] = $this->pickupOrder($store, $listing);
        $fulfillment = $this->teamMember($store, 'FULFILLMENT');
        $this->signInStoreMember($fulfillment);
        $this->getJson('/api/v1/vendor/orders/'.$pending)->assertNotFound();
        self::assertSame(0, $this->getJson('/api/v1/vendor/orders')->assertOk()->json('meta.total'));
        $this->signInStoreMember($owner);
        $list = $this->getJson('/api/v1/vendor/orders?group=NEW')->assertOk();
        self::assertSame([$pending], array_column($list->json('data'), 'id'));
        self::assertSame(1, $list->json('meta.counts.NEW'));
    }

    private function expectFeeNotEarnable(string $orderId): void
    {
        try {
            app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
            self::fail('A fee is never earned before completion.');
        } catch (AuthenticationException $exception) {
            self::assertSame('FEE_NOT_EARNABLE', $exception->errorCode);
        }
    }
}
