<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Fulfillment\ReceiptService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Orders\CancellationService;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Filesystem\FilesystemAdapter;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Phase 12 acceptance: fulfillment milestones and proof through the shared state machine, milestone-gated fulfillment
 * threads with exact assignment scope and revocation, accepted delivery snapshots that staff cannot change, receipt
 * confirmation with the paused 48-hour auto-confirmation, completion earning the commission once, and FIN-07
 * cancellations with one idempotent Cancellation Refund per original payment that only verified provider evidence
 * completes. Every provider is the deterministic SIMULATED adapter; no real Xendit call or credential is used.
 */
final class PhaseTwelveFulfillmentTest extends TestCase
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

    // ── Milestones, proof, receipt and completion ───────────────────────────────────────────────────

    public function test_pickup_milestones_reject_duplicate_and_reordered_events_and_completion_earns_once(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Pickup Milestones');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $storeStaff = $this->teamMember($store, 'STORE_STAFF');
        $variant = (string) DB::table('order_lines')->where('order_id', $orderId)->value('listing_variant_id');

        // Exact assignment scope: an unassigned Fulfillment Staff cannot even see the order; Store Staff never records.
        $this->milestone($staff, $orderId, 'PROCESSING')->assertNotFound();
        $this->milestone($storeStaff, $orderId, 'PROCESSING')->assertForbidden();
        $this->assign($staff, $owner, $orderId)->assertOk();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/orders')->assertOk()->assertJsonCount(1, 'data');

        $key = (string) Str::uuid7();
        $same = ['lock_version' => (string) DB::table('orders')->where('id', $orderId)->value('lock_version')];
        $this->milestone($staff, $orderId, 'PROCESSING', $same, $key)->assertOk()->assertJsonPath('data.states.0.state', 'PROCESSING');
        $this->milestone($staff, $orderId, 'PROCESSING', $same, $key)->assertOk();
        $this->milestone($staff, $orderId, 'PROCESSING', [], $key)->assertStatus(409)->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        $this->milestone($staff, $orderId, 'PROCESSING')->assertStatus(409)->assertJsonPath('errors.0.code', 'MILESTONE_ALREADY_RECORDED');
        $this->milestone($staff, $orderId, 'PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana', 'receiver_kind' => 'BUYER'])->assertStatus(409)->assertJsonPath('errors.0.code', 'ORDER_STATE_CONFLICT');
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY')->assertStatus(409)->assertJsonPath('errors.0.code', 'ORDER_STATE_CONFLICT');
        self::assertSame(1, DB::table('fulfillment_milestones')->where('order_id', $orderId)->where('event_type', 'PROCESSING')->count());
        self::assertSame(1, DB::table('conversations')->where('order_id', $orderId)->count(), 'The thread opened with the order (approved 2026-10-10).');

        $this->milestone($staff, $orderId, 'READY_FOR_PICKUP')->assertOk()->assertJsonPath('data.fulfillment.thread.available', true);
        $thread = DB::table('conversations')->where('order_id', $orderId)->first();
        self::assertSame(['FULFILLMENT', (int) $staff->id], [$thread->purpose, (int) $thread->handler_user_id]);
        $this->milestone($staff, $orderId, 'READY_FOR_PICKUP')->assertStatus(409);
        self::assertSame(1, DB::table('conversations')->where('order_id', $orderId)->count(), 'One thread per order.');

        $this->milestone($staff, $orderId, 'PICKED_UP', ['receiver_name' => 'Ana Buyer', 'receiver_kind' => 'BUYER'])->assertStatus(422)->assertJsonPath('errors.0.code', 'PROOF_REQUIRED');
        self::assertSame('READY_FOR_PICKUP', $this->orderState($orderId));
        $onHandBefore = (string) DB::table('inventory_items')->where('listing_variant_id', $variant)->value('quantity_on_hand');
        $this->milestone($staff, $orderId, 'PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana Buyer', 'receiver_kind' => 'AUTHORIZED_RECEIVER'])->assertOk()
            ->assertJsonPath('data.states.0.state', 'PICKED_UP')->assertJsonPath('data.fulfillment.proof.receiver_name', 'Ana Buyer');
        $item = DB::table('inventory_items')->where('listing_variant_id', $variant)->first();
        self::assertSame(bcsub($onHandBefore, '10', 4), (string) $item->quantity_on_hand, 'Physical stock leaves only at pickup.');
        self::assertSame('0.0000', (string) $item->hard_reserved_quantity);
        self::assertSame(1, DB::table('inventory_movements')->where('source_id', $orderId)->where('movement_type', 'FULFILLED')->count());

        $this->signInBuyer($buyer);
        $detail = $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->json('data');
        self::assertContains('CONFIRM_RECEIPT', $detail['available_actions']);
        self::assertNotContains('CANCEL', $detail['available_actions']);
        self::assertSame(['COMPLETE', 'COMPLETE', 'COMPLETE', 'COMPLETE', 'CURRENT'], array_column($detail['fulfillment']['steps'], 'status'));
        self::assertSame('Ana Buyer', $detail['fulfillment']['steps'][3]['proof']['receiver_name']);
        self::assertEqualsWithDelta(48 * 3600, CarbonImmutable::now()->diffInSeconds(CarbonImmutable::parse($detail['fulfillment']['receipt']['due_at'])), 5);

        $confirm = (string) Str::uuid7();
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/receipt/confirm', [], ['Idempotency-Key' => $confirm])->assertOk()->assertJsonPath('data.states.0.state', 'COMPLETED');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/receipt/confirm', [], ['Idempotency-Key' => $confirm])->assertOk();
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/receipt/confirm', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409);
        $assessment = DB::table('fee_assessments')->where('order_id', $orderId)->first();
        self::assertSame(['EARNED', 20000], [$assessment->state, (int) $assessment->earned_centavos], 'Commission = money(E × 0.02), earned only at COMPLETED.');
        self::assertSame(1, DB::table('fee_assessment_events')->where('order_id', $orderId)->where('event_type', 'EARNED')->count(), 'Completion replay never earns twice.');
        self::assertSame(1, DB::table('financial_posting_batches')->where('source_event_key', 'PLATFORM_FEE:EARNED:'.$assessment->id)->count());

        // Closed thread: read-only, history kept for the Buyer and Owner, staff access ended.
        $this->postJson('/api/v1/buyers/conversations/'.$thread->id.'/messages', ['body' => 'Thanks!', 'client_message_id' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'CONVERSATION_READ_ONLY');
        $this->getJson('/api/v1/buyers/conversations/'.$thread->id)->assertOk()->assertJsonPath('data.conversation.read_only', true);
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/conversations/'.$thread->id)->assertNotFound();
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/conversations/'.$thread->id)->assertOk();
    }

    public function test_dispatch_must_follow_the_accepted_snapshot_and_staff_cannot_change_commercial_terms(): void
    {
        [$store, $owner, $buyer, $orderId, $vehicle] = $this->paidDelivery('Snapshot Delivery');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $this->assign($staff, $owner, $orderId)->assertOk();
        $snapshotBefore = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->first();
        $orderBefore = DB::table('orders')->where('id', $orderId)->first(['delivery_centavos', 'commercial_total_centavos']);

        // Later vehicle and rate settings never change the accepted arrangement or its fee.
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['name' => 'Renamed truck', 'capacity_kg' => 500]);
        DB::table('vehicle_rate_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $vehicle, 'version' => (int) DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicle)->max('version') + 1,
            'base_fee_centavos' => 99000, 'per_km_centavos' => 9000, 'maximum_distance_km' => 40, 'effective_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        $this->milestone($staff, $orderId, 'PROCESSING')->assertOk();
        $arrangement = $this->vendorOrder($staff, $orderId)['fulfillment']['accepted_arrangement'];
        self::assertSame(['Box truck', 1, 60500], [$arrangement['vehicles'][0]['name'], $arrangement['vehicles'][0]['total_vehicle_trips'], $arrangement['final_fee_centavos']]);
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => '3', 'trip_number' => '1'])->assertStatus(422)->assertJsonPath('errors.0.code', 'VEHICLE_NOT_IN_ACCEPTED_ARRANGEMENT');
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => '0', 'trip_number' => '2'])->assertStatus(422)->assertJsonPath('errors.0.code', 'VEHICLE_NOT_IN_ACCEPTED_ARRANGEMENT');
        self::assertSame(1, DB::table('conversations')->where('order_id', $orderId)->count(), 'The thread opened with the order; rejected dispatches add none.');
        // Extra commercial fields are not part of the milestone contract and are ignored.
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => '0', 'trip_number' => '1', 'final_fee_centavos' => '1', 'delivery_centavos' => '1'])->assertOk()
            ->assertJsonPath('data.states.0.state', 'OUT_FOR_DELIVERY');
        self::assertSame(1, DB::table('conversations')->where('order_id', $orderId)->where('purpose', 'FULFILLMENT')->count());
        $this->signInStoreMember($staff);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/trips', ['vehicle_index' => 0, 'trip_number' => 1], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'TRIP_ALREADY_RECORDED');
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/vehicle-issues', ['category' => 'ACCESS_BLOCKED', 'description' => 'The north gate is closed for road works.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        self::assertSame('OUT_FOR_DELIVERY', $this->orderState($orderId), 'A vehicle issue report never changes the order.');
        // Staff cannot alter configuration, the confirmed order or another commercial arrangement.
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/confirm', ['lock_version' => 1, 'lines' => [['order_line_id' => (string) DB::table('order_lines')->where('order_id', $orderId)->value('id'), 'confirmed_quantity' => '1']]],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/cancel', ['lock_version' => 1, 'reason_code' => 'DELIVERY_INABILITY', 'reason' => 'Truck broke down on the way.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();

        $this->milestone($staff, $orderId, 'DELIVERED', ['receiver_name' => 'Site foreman'])->assertStatus(422)->assertJsonPath('errors.0.code', 'PROOF_REQUIRED');
        $this->milestone($staff, $orderId, 'DELIVERED', ['receiver_name' => 'Site foreman'], null, ['file' => UploadedFile::fake()->image('delivered.png'), 'signature' => UploadedFile::fake()->image('signature.png')])->assertOk()
            ->assertJsonPath('data.states.0.state', 'DELIVERED');
        $snapshotAfter = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->first();
        self::assertSame([$snapshotBefore->snapshot, (int) $snapshotBefore->final_charge_centavos], [$snapshotAfter->snapshot, (int) $snapshotAfter->final_charge_centavos]);
        self::assertSame([(int) $orderBefore->delivery_centavos, (int) $orderBefore->commercial_total_centavos],
            [(int) DB::table('orders')->where('id', $orderId)->value('delivery_centavos'), (int) DB::table('orders')->where('id', $orderId)->value('commercial_total_centavos')]);

        // Proof bytes reach only this order's Buyer and authorized Vendor users.
        $this->signInBuyer($buyer);
        $proof = $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->json('data.fulfillment.proof');
        self::assertStringStartsWith('/buyers/orders/'.$orderId.'/files/', $proof['photo_path']);
        $this->get('/api/v1'.$proof['photo_path'])->assertOk();
        $this->buyer('stranger@example.test');
        $this->get('/api/v1'.$proof['photo_path'])->assertNotFound();
        self::assertSame(Crypt::decryptString((string) DB::table('fulfillment_proofs')->where('order_id', $orderId)->value('receiver_name_encrypted')), 'Site foreman');
    }

    public function test_auto_confirmation_waits_48_hours_reminds_and_pauses_for_an_open_problem_or_dispute(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Auto Confirm');
        $this->toPickedUp($owner, $orderId);
        // Public Closed hours must never postpone statutory or transaction reminder clocks.
        app(StoreOperatingSchedule::class)->replaceWeekly((string) DB::table('store_profiles')->where('vendor_organization_id', $store->id)->value('id'), array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));

        $this->travel(24)->hours();
        $this->travel(1)->minutes();
        self::assertSame(0, app(ReceiptService::class)->sweep()['completed']);
        self::assertNotNull(DB::table('fulfillments')->where('order_id', $orderId)->value('reminder_24h_sent_at'));

        // Report a Problem pauses the window; it is not a dispute and opens no refund.
        $this->signInBuyer($buyer);
        $this->post('/api/v1/buyers/orders/'.$orderId.'/problems', ['category' => 'DAMAGED', 'description' => 'Two blocks arrived cracked at the corners.', 'files' => [UploadedFile::fake()->image('crack.png')]],
            ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertCreated()->assertJsonPath('data.fulfillment.receipt.paused', true);
        self::assertSame(['NONE', 'NOT_REQUESTED'], [(string) DB::table('orders')->where('id', $orderId)->value('dispute_state'), (string) DB::table('orders')->where('id', $orderId)->value('refund_state')]);
        $this->post('/api/v1/buyers/orders/'.$orderId.'/problems', ['category' => 'OTHER', 'description' => 'A second report on the same order.'], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PROBLEM_ALREADY_OPEN');
        $this->travel(30)->hours();
        self::assertSame(0, app(ReceiptService::class)->sweep()['completed'], 'An open problem pauses automatic confirmation.');
        self::assertSame('PICKED_UP', $this->orderState($orderId));

        $issue = (string) DB::table('fulfillment_issues')->where('order_id', $orderId)->value('id');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/problems/'.$issue.'/respond', ['response' => 'We will replace the two blocks tomorrow.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/problems/'.$issue.'/resolve', ['note' => 'Replaced.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.fulfillment.receipt.paused', false);
        $due = CarbonImmutable::parse((string) DB::table('fulfillments')->where('order_id', $orderId)->value('auto_confirm_due_at'));
        self::assertEqualsWithDelta(24 * 3600 - 60, CarbonImmutable::now()->diffInSeconds($due), 10, 'The remaining time resumes; the window does not restart.');

        $this->travel(23)->hours();
        app(ReceiptService::class)->sweep();
        self::assertNotNull(DB::table('fulfillments')->where('order_id', $orderId)->value('reminder_2h_sent_at'));
        $this->travel(2)->hours();
        self::assertSame(1, app(ReceiptService::class)->sweep()['completed']);
        self::assertSame(['COMPLETED', 'AUTO_CONFIRMATION'], [$this->orderState($orderId), (string) DB::table('fulfillments')->where('order_id', $orderId)->value('receipt_confirmation_source')]);
        self::assertSame('EARNED', (string) DB::table('fee_assessments')->where('order_id', $orderId)->value('state'));

        // An active dispute also pauses it (the dispute flow itself is Phase 13).
        [, $otherOwner, , $other] = $this->paidPickup('Disputed Pickup');
        $this->toPickedUp($otherOwner, $other);
        DB::table('orders')->where('id', $other)->update(['dispute_state' => 'OPEN_AWAITING_RESPONSE']);
        $this->travel(49)->hours();
        app(ReceiptService::class)->sweep();
        self::assertSame('PICKED_UP', $this->orderState($other));
    }

    // ── Cancellation and Cancellation Refunds ───────────────────────────────────────────────────────

    public function test_buyer_cancellation_follows_the_state_table_and_explains_unavailability_in_text(): void
    {
        // Before Vendor confirmation: immediate withdrawal, nothing captured, nothing refunded.
        [$store, $owner, $listing] = $this->pickupStore('Withdraw Hardware', [['price' => 100000, 'qty' => '50']]);
        [$buyer, $pending] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '2']]);
        $lock = (int) $this->buyerOrder($buyer, $pending)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$pending.'/cancel', ['lock_version' => $lock], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.states.0.state', 'CANCELLED');
        self::assertSame([0, 'BUYER_WITHDRAWAL'], [DB::table('refunds')->where('order_id', $pending)->count(), (string) DB::table('orders')->where('id', $pending)->value('terminal_reason_code')]);

        // Awaiting payment: cancel before paying; the reservation is released and nothing is due.
        [, , $payer, $unpaid] = $this->awaitingPayment('Unpaid Hardware');
        $this->startPayment($payer, $unpaid);
        $lock = (int) $this->buyerOrder($payer, $unpaid)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$unpaid.'/cancel', ['lock_version' => $lock], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.states.1.state', 'NOT_REQUIRED');
        self::assertSame([0, 0, 'EXPIRED'], [$this->activeHolds($unpaid), DB::table('refunds')->where('order_id', $unpaid)->count(), (string) DB::table('payments')->where('order_id', $unpaid)->value('state')]);

        // Confirmed and paid: reasoned cancellation, final at once, one refund of the whole capture incl. the fee.
        [$paidStore, , $paidBuyer, $paid, $paymentId] = $this->paidPickup('Confirmed Cancel');
        $lock = (int) $this->buyerOrder($paidBuyer, $paid)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$paid.'/cancel', ['lock_version' => $lock], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422)->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
        $this->postJson('/api/v1/buyers/orders/'.$paid.'/cancel', ['lock_version' => $lock, 'reason_code' => 'OTHER'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422);
        $key = (string) Str::uuid7();
        $body = ['lock_version' => $lock, 'reason_code' => 'BUDGET_CHANGE'];
        $this->postJson('/api/v1/buyers/orders/'.$paid.'/cancel', $body, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.states.0.state', 'CANCELLED')->assertJsonPath('data.states.3.state', 'REFUND_PENDING')
            ->assertJsonPath('data.refund_timeline.refunds.0.display_state', 'INITIATED');
        $this->postJson('/api/v1/buyers/orders/'.$paid.'/cancel', $body, ['Idempotency-Key' => $key])->assertOk();
        $this->postJson('/api/v1/buyers/orders/'.$paid.'/cancel', $body, ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409);
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        $refund = DB::table('refunds')->where('order_id', $paid)->first();
        self::assertSame([1, 'CANCELLATION', (int) $payment->total_centavos, (int) $payment->processing_fee_centavos, 'REFUND_PENDING'],
            [DB::table('refunds')->where('order_id', $paid)->count(), $refund->trigger, (int) $refund->amount_centavos, (int) $refund->processing_fee_centavos, $refund->state]);
        self::assertSame(1, $this->gateway->refundCalls, 'The provider request was submitted immediately after commit, once.');
        self::assertSame([0, 'CANCELLED', 0], [$this->activeHolds($paid), (string) DB::table('fee_assessments')->where('order_id', $paid)->value('state'), DB::table('nfr_events')->count()]);
        self::assertSame(0, DB::table('dispute_cases')->count(), 'A cancellation never opens a dispute.');

        // While the refund is only pending, the collection still counts toward the FIN-04A counter.
        $assessment = DB::table('remittance_assessments')->where('payment_id', $paymentId)->first();
        $counterBefore = (int) DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->value('g_accumulated_centavos');
        self::assertSame(['POSTED', true], [$assessment->calculation_state, (int) $assessment->gross_basis_centavos > 0 && $counterBefore >= (int) $assessment->gross_basis_centavos]);

        // Only a verified provider event completes it; duplicate and reordered events change nothing.
        $success = $this->gateway->settleRefund((string) $refund->provider_reference);
        $this->deliverWebhook($success, 'wh-refund-1')->assertOk();
        $this->deliverWebhook($success, 'wh-refund-1')->assertOk();
        $this->deliverWebhook($success, 'wh-refund-2')->assertOk();
        self::assertSame(['REFUNDED', 'REFUNDED'], [(string) DB::table('refunds')->where('id', $refund->id)->value('state'), (string) DB::table('orders')->where('id', $paid)->value('refund_state')]);

        // Refunded money is not paid: the fully refunded collection is voided once and leaves the uncrossed counter.
        self::assertSame('VOIDED', (string) DB::table('remittance_assessments')->where('id', $assessment->id)->value('calculation_state'));
        self::assertSame($counterBefore - (int) $assessment->gross_basis_centavos, (int) DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->value('g_accumulated_centavos'));
        self::assertSame(1, DB::table('vendor_withholding_status_events')->where('assessment_id', $assessment->id)->where('reason_code', 'COLLECTION_REFUNDED_VOIDED')->count());
        self::assertSame(0, (int) DB::table('financial_ledger_entries')->where('ledger', 'DEMO_FLOW')->where('source_id', $assessment->id)->where('account_code', 'COLLECTION_CONTROL')
            ->selectRaw("COALESCE(SUM(CASE WHEN direction = 'DEBIT' THEN amount_centavos ELSE -amount_centavos END), 0) AS net")->value('net'), 'The simulated postings net to zero after the void.');
        self::assertSame(['NOT_REQUIRED', 'SYSTEM'], [(string) DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment->id)->value('state'), (string) DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment->id)->value('opened_by')],
            'Nothing is left to review once the collection is voided; the case is kept, never deleted.');
        self::assertSame(1, DB::table('audit_logs')->where('action', 'TAX_ADJUSTMENT_NOT_REQUIRED')->count());
        $failedLater = $success;
        $failedLater['event'] = 'refund.failed';
        $failedLater['data']['status'] = 'FAILED';
        $this->deliverWebhook($failedLater, 'wh-refund-3')->assertOk();
        self::assertSame('REFUNDED', (string) DB::table('refunds')->where('id', $refund->id)->value('state'), 'A refunded instruction is final.');
        self::assertSame(1, DB::table('refund_events')->where('refund_id', $refund->id)->where('state', 'REFUNDED')->count());
        $this->signInBuyer($paidBuyer);
        $this->getJson('/api/v1/buyers/orders/'.$paid)->assertOk()->assertJsonPath('data.refund_timeline.refunds.0.display_state', 'PROCESSED');

        // Ready for pickup: no cancellation; the reason and remaining remedies are explained in text.
        [, $readyOwner, $readyBuyer, $ready] = $this->paidPickup('Ready Cancel');
        $this->milestone($readyOwner, $ready, 'PROCESSING')->assertOk();
        $this->milestone($readyOwner, $ready, 'READY_FOR_PICKUP')->assertOk();
        $detail = $this->buyerOrder($readyBuyer, $ready);
        self::assertSame([false, 'UNAVAILABLE'], [$detail['cancellation']['available'], $detail['cancellation']['mode']]);
        self::assertStringContainsString('report a problem', $detail['cancellation']['explanation']);
        self::assertSame(['REPORT_PROBLEM', 'DISPUTE', 'RETURN', 'WARRANTY', 'STATUTORY_REMEDIES'], array_column($detail['cancellation']['remedies'], 'code'));
        self::assertTrue($detail['cancellation']['remedies'][0]['available']);
        self::assertContains('REPORT_PROBLEM', $detail['available_actions']);
        self::assertNotContains('CANCEL', $detail['available_actions']);
        $this->postJson('/api/v1/buyers/orders/'.$ready.'/cancel', ['lock_version' => $detail['lock_version'], 'reason_code' => 'BUDGET_CHANGE'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'CANCELLATION_UNAVAILABLE');
        self::assertSame('READY_FOR_PICKUP', $this->orderState($ready));
        self::assertNotNull($paidStore);

        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->getJson('/api/v1/admin/order-operations/summary')->assertOk()
            ->assertJsonPath('data.refunds_total', 1)->assertJsonPath('data.refunds_failed', 0)->assertJsonPath('data.refunds_pending', 0);
        $this->getJson('/api/v1/admin/order-operations/refunds')->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.display_state', 'PROCESSED');
    }

    public function test_processing_request_lets_the_vendor_retain_only_evidenced_nrpc_and_a_timeout_refunds_everything(): void
    {
        [$store, $owner, $buyer, $orderId, $paymentId] = $this->paidNrpcOnline('Nrpc Request');
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->signInBuyer($buyer);
        $preview = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/cancellation-preview')->assertOk()->json('data');
        self::assertSame(['REQUEST', 100000], [$preview['availability']['mode'], $preview['nrpc_retainable_centavos']]);
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        self::assertSame([(int) $payment->total_centavos, (int) $payment->total_centavos - 100000], [$preview['full_refund']['online_refund_total_centavos'], $preview['with_nrpc_retained']['online_refund_total_centavos']]);
        $lock = (int) $this->buyerOrder($buyer, $orderId)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'PROJECT_DELAY'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'CANCELLATION_REQUESTED')->assertJsonPath('data.cancellation.can_withdraw_request', true);
        self::assertSame(0, DB::table('refunds')->count(), 'A request is not final and creates no refund.');
        $this->milestone($owner, $orderId, 'READY_FOR_PICKUP')->assertStatus(409)->assertJsonPath('errors.0.code', 'CANCELLATION_PENDING');

        // Retaining NRPC needs evidence of the actual preparation.
        $this->signInStoreMember($owner);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/cancellation-request/finalize', ['retain_nrpc' => '1', 'note' => 'Blocks were cut to the Buyer drawings.'], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'NRPC_EVIDENCE_REQUIRED');
        $this->post('/api/v1/vendor/orders/'.$orderId.'/cancellation-request/finalize', ['retain_nrpc' => '1', 'note' => 'Blocks were cut to the Buyer drawings.', 'file' => UploadedFile::fake()->image('cut-blocks.png')],
            ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertOk()->assertJsonPath('data.states.0.state', 'CANCELLED');
        $decision = DB::table('cancellation_decisions')->where('order_id', $orderId)->first();
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        self::assertSame(['BUYER', 'VENDOR', 100000, (int) $payment->total_centavos - 100000], [$decision->cause, $decision->decided_by, (int) $decision->nrpc_retained_centavos, (int) $refund->amount_centavos]);
        $allocation = json_decode((string) $refund->allocation, true);
        self::assertSame(100000, $allocation['lines'][0]['retained_nrpc_centavos'], 'Retention consumes the original NRPC line allocation.');
        self::assertSame((int) $refund->amount_centavos, array_sum(array_column($allocation['lines'], 'payable_centavos')) + $allocation['delivery_centavos'] + $allocation['processing_fee_centavos']);
        self::assertSame([0, 'CANCELLED'], [DB::table('nfr_events')->count(), (string) DB::table('fee_assessments')->where('order_id', $orderId)->value('state')], 'No NFR or commission on a Buyer cancellation.');

        // A Buyer may withdraw an open request; a request the Vendor ignores is finalized with a full refund.
        [, $ownerTwo, $buyerTwo, $withdrawn] = $this->paidPickup('Withdraw Request');
        $this->milestone($ownerTwo, $withdrawn, 'PROCESSING')->assertOk();
        $this->requestCancellation($buyerTwo, $withdrawn);
        $this->postJson('/api/v1/buyers/orders/'.$withdrawn.'/cancellation-request/withdraw', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.states.0.state', 'PROCESSING');

        [$closedStore, $ownerThree, $buyerThree, $ignored, $ignoredPayment] = $this->paidPickup('Ignored Request');
        $this->milestone($ownerThree, $ignored, 'PROCESSING')->assertOk();
        $this->requestCancellation($buyerThree, $ignored);
        app(StoreOperatingSchedule::class)->replaceWeekly((string) DB::table('store_profiles')->where('vendor_organization_id', $closedStore->id)->value('id'), array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'CLOSED', 'opens_at' => null, 'closes_at' => null], range(1, 7)));
        $this->travel(23)->hours();
        self::assertSame(0, app(CancellationService::class)->sweep());
        $this->travel(61)->minutes();
        self::assertSame(1, app(CancellationService::class)->sweep());
        self::assertSame(1, app(CancellationService::class)->sweep() + 1, 'The sweep is idempotent.');
        self::assertSame(['CANCELLED', 'VENDOR_RESPONSE_TIMEOUT_FULL_REFUND', (int) DB::table('payments')->where('id', $ignoredPayment)->value('total_centavos')],
            [$this->orderState($ignored), (string) DB::table('cancellation_decisions')->where('order_id', $ignored)->value('decision_code'), (int) DB::table('refunds')->where('order_id', $ignored)->value('amount_centavos')]);
        self::assertNotNull($store);
    }

    public function test_vendor_cancellation_of_a_mixed_paid_nrpc_order_refunds_the_online_payment_forfeits_nrpc_and_keeps_tax_review_separate(): void
    {
        [$store, $owner, $buyer, $orderId, $nrpcPayment] = $this->paidInStoreNrpc('Mixed Cancel');
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $this->signInStoreMember($staff);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/physical-payments', ['amount_centavos' => 400000, 'file' => UploadedFile::fake()->image('cash.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertCreated();
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $assessment = DB::table('remittance_assessments')->where('payment_id', $nrpcPayment)->first();
        $accumulator = DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->first();
        self::assertSame([100000, 500], [(int) $assessment->gross_basis_centavos, (int) $assessment->withheld_centavos]);

        foreach (['CUSTOMER_SERVICE', 'FULFILLMENT', 'INVENTORY'] as $role) {
            $this->signInStoreMember($this->teamMember($store, $role));
            $this->postJson('/api/v1/vendor/orders/'.$orderId.'/cancel', ['lock_version' => 1, 'reason_code' => 'STOCK_FAILURE', 'reason' => 'Supplier failed to deliver stock.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        }
        $lock = (int) $this->vendorOrder($staff, $orderId)['lock_version'];
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'STOCK_FAILURE', 'reason' => 'Supplier failed to deliver the cement stock.'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertOk()->assertJsonPath('data.states.0.state', 'CANCELLED')->assertJsonPath('data.refund_timeline.no_longer_due_centavos', 500000);

        $payment = DB::table('payments')->where('id', $nrpcPayment)->first();
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        self::assertSame(['CANCELLATION', (int) $payment->total_centavos, (int) $payment->processing_fee_centavos], [$refund->trigger, (int) $refund->amount_centavos, (int) $refund->processing_fee_centavos],
            'The original online NRPC payment, including its disclosed processing fee, is refunded; NRPC is forfeited.');
        $decision = DB::table('cancellation_decisions')->where('order_id', $orderId)->first();
        self::assertSame(['VENDOR', 0, 400000, 500000], [$decision->cause, (int) $decision->nrpc_retained_centavos, (int) $decision->cash_reimbursement_centavos, (int) $decision->released_unpaid_centavos]);
        self::assertSame(1, DB::table('nfr_events')->where('order_id', $orderId)->count());
        self::assertSame(['CANCELLED', 0], [(string) DB::table('fee_assessments')->where('order_id', $orderId)->value('state'), DB::table('fee_assessment_events')->where('order_id', $orderId)->where('event_type', 'EARNED')->count()]);
        $reimbursement = DB::table('physical_reimbursements')->where('order_id', $orderId)->first();
        self::assertSame(['VENDOR_REIMBURSEMENT_PENDING', 400000, null], [$reimbursement->state, (int) $reimbursement->amount_centavos, $reimbursement->refund_id], 'Cash is reimbursed by the Vendor, never through a Refund API.');
        self::assertSame(1, DB::table('refunds')->where('order_id', $orderId)->count(), 'No provider refund is invented for cash or an uncollected balance.');

        // FIN-07: posted CWT goes to ADJUSTMENT_REQUIRED; the FIN-04A counter and status never move back.
        $adjustment = DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment->id)->first();
        self::assertSame(['ADJUSTMENT_REQUIRED', 'SYSTEM', (string) $refund->id], [$adjustment->state, $adjustment->opened_by, (string) $adjustment->refund_id]);
        $after = DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->first();
        self::assertSame([(int) $accumulator->g_accumulated_centavos, $accumulator->withholding_status], [(int) $after->g_accumulated_centavos, $after->withholding_status]);

        // Evidenced reimbursement, then the Buyer's acknowledgment confirms it.
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/reimbursements/'.$reimbursement->id.'/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409);
        $this->signInStoreMember($staff);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/reimbursements/'.$reimbursement->id, ['file' => UploadedFile::fake()->image('returned-cash.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertOk();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/reimbursements/'.$reimbursement->id.'/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertSame('REIMBURSEMENT_CONFIRMED', (string) DB::table('physical_reimbursements')->where('id', $reimbursement->id)->value('state'));

        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->getJson('/api/v1/admin/order-operations/summary')->assertOk()
            ->assertJsonPath('data.reimbursements_total', 1)->assertJsonPath('data.reimbursements_pending', 0);
    }

    public function test_a_fully_refunded_collection_in_a_crossed_taxable_year_is_never_voided_or_lowered(): void
    {
        [, , $buyer, $orderId, $paymentId] = $this->paidPickup('Crossed Year Refund');
        $assessment = DB::table('remittance_assessments')->where('payment_id', $paymentId)->first();
        DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->update(['withholding_status' => 'SUBJECT_THRESHOLD_BREACHED', 'status_reason_code' => 'THRESHOLD_CROSSED',
            'crossed_at' => now(), 'crossing_assessment_id' => $assessment->id]);
        $counter = (int) DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->value('g_accumulated_centavos');

        $this->cancelConfirmed($buyer, $orderId);
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        $this->deliverWebhook($this->gateway->settleRefund((string) $refund->provider_reference), 'wh-crossed-refund')->assertOk();

        self::assertSame('REFUNDED', (string) DB::table('refunds')->where('id', $refund->id)->value('state'));
        self::assertSame('POSTED', (string) DB::table('remittance_assessments')->where('id', $assessment->id)->value('calculation_state'), 'A crossing is final for the year; the posted assessment stays.');
        self::assertSame($counter, (int) DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->value('g_accumulated_centavos'));
        self::assertSame(0, DB::table('vendor_withholding_status_events')->where('assessment_id', $assessment->id)->where('reason_code', 'COLLECTION_REFUNDED_VOIDED')->count());
        self::assertSame(1, DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment->id)->count(), 'The FIN-07 tax review is the only follow-up.');
    }

    public function test_provider_timeouts_rejections_and_authorized_retry_keep_refunds_pending_until_verified(): void
    {
        // A timeout after the provider created the refund: the resend reuses the key, so there is one provider refund.
        [, , $buyer, $orderId] = $this->paidPickup('Timeout Refund');
        $this->gateway->nextRefund = 'TIMEOUT_AFTER_CREATE';
        $this->cancelConfirmed($buyer, $orderId);
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        self::assertSame(['REFUND_PENDING', null], [$refund->state, $refund->provider_reference]);
        $this->travel(3)->minutes();
        app(PaymentReconciliationService::class)->sweep();
        $refund = DB::table('refunds')->where('id', $refund->id)->first();
        self::assertSame(['REFUND_PENDING', 2], [$refund->state, $this->gateway->refundCalls]);
        self::assertNotNull($refund->provider_reference);
        $this->travel(2)->minutes();
        app(PaymentReconciliationService::class)->sweep();
        self::assertSame('REFUND_PENDING', (string) DB::table('refunds')->where('id', $refund->id)->value('state'), 'Reconciliation reads a pending provider refund and waits.');
        $this->gateway->settleRefund((string) $refund->provider_reference);
        $this->travel(2)->minutes();
        app(PaymentReconciliationService::class)->sweep();
        self::assertSame('REFUNDED', (string) DB::table('refunds')->where('id', $refund->id)->value('state'), 'Reconciliation completes it without a webhook.');

        // A definitive rejection (insufficient balance) stays visible; only the Owner or an Admin may retry.
        [$store, $owner, $rejectedBuyer, $rejected] = $this->paidPickup('Rejected Refund');
        $this->gateway->nextRefund = 'REJECT';
        $this->cancelConfirmed($rejectedBuyer, $rejected);
        $failed = DB::table('refunds')->where('order_id', $rejected)->first();
        self::assertSame(['REFUND_FAILED', 'INSUFFICIENT_BALANCE', 'REFUND_FAILED'], [$failed->state, $failed->failure_code, (string) DB::table('orders')->where('id', $rejected)->value('refund_state')]);
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'REFUND_EXCEPTION')->where('source_id', $failed->id)->where('state', 'OPEN')->count());
        self::assertSame(1, DB::table('notifications')->where('user_id', $owner->id)->where('category', 'FINANCE_MANDATORY')->where('title', 'like', 'Refund failed%')->count());
        $this->signInBuyer($rejectedBuyer);
        $this->getJson('/api/v1/buyers/orders/'.$rejected)->assertOk()->assertJsonPath('data.refund_timeline.refunds.0.display_state', 'FAILED')->assertJsonPath('data.refund_timeline.refunds.0.failure_code', null);
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $this->signInStoreMember($manager);
        $this->postJson('/api/v1/vendor/orders/'.$rejected.'/refunds/'.$failed->id.'/retry', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$rejected.'/refunds/'.$failed->id.'/retry', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.refund_timeline.refunds.0.display_state', 'INITIATED');
        $retried = DB::table('refunds')->where('id', $failed->id)->first();
        self::assertSame(['REFUND_PENDING', 2, 'REFUND_PENDING'], [$retried->state, (int) $retried->attempt_number, (string) DB::table('orders')->where('id', $rejected)->value('refund_state')]);
        $this->postJson('/api/v1/vendor/orders/'.$rejected.'/refunds/'.$failed->id.'/retry', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)->assertJsonPath('errors.0.code', 'REFUND_NOT_RETRYABLE');
        $this->deliverWebhook($this->gateway->settleRefund((string) $retried->provider_reference), 'wh-retried')->assertOk();
        self::assertSame(['REFUNDED', 'RESOLVED'], [(string) DB::table('refunds')->where('id', $failed->id)->value('state'),
            (string) DB::table('finance_review_items')->where('kind', 'REFUND_EXCEPTION')->where('source_id', $failed->id)->value('state')]);
    }

    public function test_forged_mismatched_and_unknown_refund_events_never_complete_a_refund(): void
    {
        [, , $buyer, $orderId] = $this->paidPickup('Forged Refund');
        $this->cancelConfirmed($buyer, $orderId);
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        $body = $this->gateway->settleRefund((string) $refund->provider_reference, 'SUCCEEDED', (int) $refund->amount_centavos + 1);
        $this->deliverWebhook($body, 'wh-mismatch')->assertOk();
        self::assertSame('REFUND_PENDING', (string) DB::table('refunds')->where('id', $refund->id)->value('state'));
        self::assertSame('REJECTED', (string) DB::table('webhook_events')->where('provider_event_id', 'wh:wh-mismatch')->value('state'));
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'REFUND_MISMATCH')->count());

        $unknown = $this->gateway->settleRefund((string) $refund->provider_reference);
        $unknown['data']['reference_id'] = (string) Str::uuid7();
        $this->deliverWebhook($unknown, 'wh-unknown')->assertOk();
        $this->deliverWebhook($unknown, 'wh-forged', 'not-the-token')->assertUnauthorized();
        self::assertSame('IGNORED', (string) DB::table('webhook_events')->where('provider_event_id', 'wh:wh-unknown')->value('state'));
        self::assertSame('REFUND_PENDING', (string) DB::table('refunds')->where('id', $refund->id)->value('state'));
    }

    public function test_fulfillment_thread_access_follows_current_assignment_and_keeps_history_after_revocation(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Thread Scope');
        $first = $this->teamMember($store, 'FULFILLMENT');
        $second = $this->teamMember($store, 'FULFILLMENT');
        $sales = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $this->assign($first, $owner, $orderId)->assertOk();
        $this->milestone($first, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($first, $orderId, 'READY_FOR_PICKUP')->assertOk();
        $thread = (string) DB::table('conversations')->where('order_id', $orderId)->value('id');

        $this->signInStoreMember($first);
        $this->postJson('/api/v1/vendor/conversations/'.$thread.'/messages', ['body' => 'Your order is at counter 2.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
        $channel = $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertOk()->json('data.conversation.channel');
        self::assertSame(['FULFILLMENT'], array_column($this->getJson('/api/v1/vendor/conversations')->assertOk()->json('data.items'), 'purpose'), 'Fulfillment Staff see only assigned fulfillment threads.');
        $this->signInStoreMember($sales);
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertNotFound();

        // Reassignment revokes REST, realtime and order access immediately; history keeps its attribution.
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', ['user_id' => $second->id, 'reason' => 'Shift handover'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.fulfillment.assignment.user_id', (int) $second->id);
        $this->signInStoreMember($first);
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertNotFound();
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        $this->postJson('/api/v1/vendor/messaging/auth', ['channel_name' => 'private-'.$channel, 'socket_id' => '1.2'])->assertForbidden();
        $this->milestone($first, $orderId, 'PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana', 'receiver_kind' => 'BUYER'])->assertNotFound();
        $this->signInStoreMember($second);
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertOk();
        $this->signInBuyer($buyer);
        $messages = $this->getJson('/api/v1/buyers/conversations/'.$thread)->assertOk()->json('data.messages.items');
        $original = collect($messages)->firstWhere('body', 'Your order is at counter 2.');
        self::assertSame('FULFILLMENT', $original['sender']['role']);
        self::assertArrayNotHasKey('email', $original['sender']);

        // Deactivation also removes access while the assignment row still exists.
        DB::table('vendor_memberships')->where('user_id', $second->id)->update(['status' => 'SUSPENDED', 'updated_at' => now()]);
        $this->signInStoreMember($second);
        $this->getJson('/api/v1/vendor/conversations/'.$thread)->assertStatus(403);

        // Teams are optional: an Owner-only store still gets the one thread at the milestone.
        [, $soloOwner, $soloBuyer, $solo] = $this->paidPickup('Solo Owner');
        $this->milestone($soloOwner, $solo, 'PROCESSING')->assertOk();
        $this->milestone($soloOwner, $solo, 'READY_FOR_PICKUP')->assertOk();
        $soloThread = DB::table('conversations')->where('order_id', $solo)->first();
        self::assertSame((int) $soloOwner->id, (int) $soloThread->handler_user_id);
        $this->signInBuyer($soloBuyer);
        $this->postJson('/api/v1/buyers/conversations/'.$soloThread->id.'/messages', ['body' => 'On my way.', 'client_message_id' => (string) Str::uuid7()])->assertCreated();
    }

    public function test_admin_order_operations_are_permissioned_and_a_paid_fee_credit_refunds_the_original_fee_capture(): void
    {
        [, , $buyer, $orderId] = $this->paidPickup('Admin Ops');
        $this->gateway->nextRefund = 'REJECT';
        $this->cancelConfirmed($buyer, $orderId);
        $refund = (string) DB::table('refunds')->where('order_id', $orderId)->value('id');

        $support = $this->admin('ADMIN_SUPPORT');
        $this->signInAdmin($support);
        $this->getJson('/api/v1/admin/order-operations/summary')->assertForbidden();
        $this->getJson('/api/v1/admin/order-operations/refunds')->assertForbidden();
        $operations = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->signInAdmin($operations);
        $this->getJson('/api/v1/admin/order-operations/summary')->assertOk()->assertJsonPath('data.refunds_total', 1)->assertJsonPath('data.refunds_failed', 1)
            ->assertJsonPath('data.reimbursements_total', 0);
        $this->getJson('/api/v1/admin/order-operations/refunds?state=REFUND_FAILED')->assertOk()->assertJsonPath('data.0.id', $refund)->assertJsonPath('data.0.can_retry', true);
        $this->postJson('/api/v1/admin/order-operations/refunds/'.$refund.'/retry', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertSame(['REFUND_PENDING', 2], [(string) DB::table('refunds')->where('id', $refund)->value('state'), (int) DB::table('refunds')->where('id', $refund)->value('attempt_number')]);

        // FIN-07 PLATFORM_FEE / FEE_CREDIT: tied to the original fee capture, never a Buyer payment.
        [, $feeOwner, $feeBuyer, $feeOrder] = $this->paidPickup('Fee Credit');
        $this->toPickedUp($feeOwner, $feeOrder);
        $this->signInBuyer($feeBuyer);
        $this->postJson('/api/v1/buyers/orders/'.$feeOrder.'/receipt/confirm', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $assessment = DB::table('fee_assessments')->where('order_id', $feeOrder)->first();
        $statement = (string) Str::uuid7();
        DB::table('fee_statements')->insert(['id' => $statement, 'vendor_organization_id' => $assessment->vendor_organization_id, 'environment' => 'TEST', 'period_start' => now()->startOfMonth()->toDateString(),
            'period_end' => now()->endOfMonth()->toDateString(), 'issued_on' => now()->toDateString(), 'due_on' => now()->addDays(12)->toDateString(), 'charges_centavos' => 20000, 'credits_centavos' => 0,
            'paid_centavos' => 20000, 'balance_centavos' => 0, 'outstanding_centavos' => 0, 'state' => 'PAID', 'statement_reference' => 'FS-TEST-1', 'approved_at' => now(),
            'approved_by_user_id' => $operations->id, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('fee_statement_lines')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $statement, 'fee_assessment_id' => $assessment->id, 'line_type' => 'EARNED_COMMISSION', 'amount_centavos' => 20000,
            'description' => 'Completed order commission', 'created_at' => now(), 'updated_at' => now()]);
        $feePayment = (string) Str::uuid7();
        DB::table('payments')->insert(['id' => $feePayment, 'fee_statement_id' => $statement, 'vendor_organization_id' => $assessment->vendor_organization_id, 'purpose' => 'PLATFORM_FEE_PAYMENT', 'account_scope' => 'PLATFORM_ACCOUNT',
            'principal_centavos' => 20000, 'processing_fee_centavos' => 0, 'total_centavos' => 20000, 'state' => 'PAID', 'paid_at' => now(), 'provider_session_id' => 'ps-simfee'.Str::lower(Str::random(16)),
            'provider_payment_request_id' => 'pr-sim-fee', 'gateway_mode' => 'SIMULATED', 'evidence_origin' => 'SIMULATED', 'idempotency_key' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('fee_payment_allocations')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $statement, 'payment_id' => $feePayment, 'amount_centavos' => 20000, 'statement_outstanding_before_centavos' => 20000,
            'payment_unallocated_before_centavos' => 20000, 'allocated_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $preparer = $this->admin('ADMIN_SUPERADMIN');
        $approver = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($preparer);
        $proposal = (string) $this->postJson('/api/v1/admin/finance/fee-credits', ['fee_assessment_id' => $assessment->id, 'returned_exclusive_centavos' => 200000, 'reason' => 'Approved return of damaged blocks after completion.'])
            ->assertCreated()->json('data.proposal_id');
        $this->signInAdmin($approver);
        $this->postJson('/api/v1/admin/finance/fee-credits/'.$proposal.'/approve')->assertOk();
        $credit = DB::table('refunds')->where('trigger', 'FEE_CREDIT')->first();
        self::assertSame(['PLATFORM_FEE', $feePayment, $statement, 4000, null], [$credit->target_type, (string) $credit->source_payment_id, (string) $credit->fee_statement_id, (int) $credit->amount_centavos, $credit->order_id]);
        $this->deliverWebhook($this->gateway->settleRefund((string) $credit->provider_reference), 'wh-fee-credit')->assertOk();
        self::assertSame('REFUNDED', (string) DB::table('refunds')->where('id', $credit->id)->value('state'));
        self::assertSame(1, DB::table('financial_posting_batches')->where('source_event_key', 'PLATFORM_FEE:FEE_CREDIT_REFUND:'.$credit->id)->count());
        self::assertSame(0, DB::table('refunds')->where('trigger', 'FEE_CREDIT')->whereIn('source_payment_id', DB::table('payments')->where('purpose', '<>', 'PLATFORM_FEE_PAYMENT')->select('id'))->count());
        self::assertNotNull($buyer);
    }

    // ── Fixtures ─────────────────────────────────────────────────────────────────────────────────────

    /** @return array{0: VendorOrganization, 1: User, 2: User, 3: string, 4: string} a CONFIRMED, verified-paid Self-Pickup order */
    private function paidPickup(string $name): array
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment($name);
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return [$store, $owner, $buyer, $orderId, (string) $attempt['id']];
    }

    /** @return array{0: VendorOrganization, 1: User, 2: User, 3: string, 4: string} a paid online order with an accepted NRPC of ₱1,000 */
    private function paidNrpcOnline(string $name): array
    {
        [$store, $owner, $listing] = $this->pickupStore($name, [['price' => 100000, 'qty' => '50']]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '10']]);
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $this->confirmOrder($owner, $orderId, [], ['nrpc' => ['amount_centavos' => 100000, 'reason' => 'Custom cutting to the Buyer drawings', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 100000]]]])->assertOk();
        $detail = $this->buyerOrder($buyer, $orderId);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', ['snapshot_version' => 2, 'nrpc_id' => $detail['nrpc']['id'], 'terms_version_id' => $detail['nrpc']['terms']['id'], 'acknowledged' => true],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();

        return [$store, $owner, $buyer, $orderId, (string) $attempt['id']];
    }

    /** @return array{0: VendorOrganization, 1: User, 2: User, 3: string, 4: string} In-Store with an online NRPC assurance payment */
    private function paidInStoreNrpc(string $name): array
    {
        [$store, $owner, $listing] = $this->pickupStore($name, [['price' => 100000, 'qty' => '50']]);
        $this->signInStoreMember($owner);
        $this->putJson('/api/v1/vendor/finance/physical-payments', ['lock_version' => 0, 'cod_enabled' => false, 'in_store_enabled' => true])->assertOk();
        $buyer = $this->buyer();
        $this->addToCart($listing, '10');
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $orderId = (string) $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => [$store->id], 'payment_methods' => [$store->id => 'IN_STORE']], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertCreated()->json('data.orders.0.id');
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $this->confirmOrder($owner, $orderId, [], ['nrpc' => ['amount_centavos' => 100000, 'reason' => 'Custom cutting to the Buyer drawings', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 100000]]]])->assertOk();
        $detail = $this->buyerOrder($buyer, $orderId);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', ['snapshot_version' => 2, 'nrpc_id' => $detail['nrpc']['id'], 'terms_version_id' => $detail['nrpc']['terms']['id'], 'acknowledged' => true],
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return [$store, $owner, $buyer, $orderId, (string) $attempt['id']];
    }

    /** @return array{0: VendorOrganization, 1: User, 2: User, 3: string, 4: string} a paid Site Delivery order and its vehicle */
    private function paidDelivery(string $name, ?array $fleet = null): array
    {
        [$store, $owner] = $fleet ?? $this->activeStore($name, false, true);
        $this->signInStoreMember($owner);
        $listing = $this->orderListing('DLV'.Str::upper(Str::random(3)), [['price' => 1800, 'qty' => '50']]);
        $vehicle = $fleet[2] ?? $this->addVehicle($store->id);
        DB::table('delivery_service_areas')->where('vendor_organization_id', $store->id)->update(['maximum_distance_km' => 10]);
        $this->placeStore($store->id, 1000);
        if ($fleet === null) {
            $this->connectOnlinePayments($store->id);
        }
        $buyer = $this->buyer();
        $site = $this->savedLocation($buyer, 'Project site', 0, 0, 'PROJECT_SITE', true);
        $gate = $this->savedLocation($buyer, 'North gate', 1500, 0);
        $this->addToCart($listing, '10', 'DELIVERY');
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->putJson('/api/v1/buyers/cart/destination', ['lock_version' => $lock, 'intended_location_id' => $site, 'heavy_vehicle_restriction' => 'YES', 'alternate_drop_off_location_id' => $gate, 'access_instructions' => 'Forklift at the north gate.'])->assertOk();
        $orderId = (string) $this->submitCheckout([$store->id])->assertCreated()->json('data.orders.0.id');
        $this->confirmOrder($owner, $orderId, [], ['delivery' => ['vehicles' => [['vehicle_id' => $vehicle, 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], 'final_fee_centavos' => 60500,
            'fulfillment_date' => CarbonImmutable::now('Asia/Manila')->addDays(2)->toDateString(), 'arrangement' => 'One box-truck trip to the north gate.', 'access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true]])->assertOk();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/revision/approve', ['snapshot_version' => 2], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return [$store, $owner, $buyer, $orderId, $vehicle];
    }

    public function test_delivery_dispatch_requires_current_assignment_and_vehicle_and_preserves_existing_obligations(): void
    {
        [$store, $owner, $buyer, $orderId, $vehicle] = $this->paidDelivery('Delivery requirements');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $snapshot = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot');
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $dispatch = ['vehicle_index' => '0', 'trip_number' => '1'];
        $this->milestone($owner, $orderId, 'OUT_FOR_DELIVERY', $dispatch)->assertStatus(422)->assertJsonPath('errors.0.code', 'FULFILLMENT_STAFF_REQUIRED');
        $this->assign($staff, $owner, $orderId)->assertOk();
        $assignment = DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->value('id');
        DB::table('vendor_memberships')->where('user_id', $staff->id)->update(['status' => 'INACTIVE']);
        $this->milestone($owner, $orderId, 'OUT_FOR_DELIVERY', $dispatch)->assertStatus(422)->assertJsonPath('errors.0.code', 'FULFILLMENT_STAFF_REQUIRED');
        DB::table('vendor_memberships')->where('user_id', $staff->id)->update(['status' => 'ACTIVE']);
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->milestone($owner, $orderId, 'OUT_FOR_DELIVERY', $dispatch)->assertStatus(422)->assertJsonPath('errors.0.code', 'DELIVERY_VEHICLE_REQUIRED');
        self::assertSame('PROCESSING', $this->orderState($orderId));
        self::assertSame($snapshot, DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot'));
        self::assertSame($assignment, DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->value('id'));

        $this->signInStoreMember($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version, 'fulfillment_method' => 'SELF_PICKUP'])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'ACTIVE_DELIVERY_OBLIGATIONS');
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version, 'vendor_delivery_enabled' => false])->assertOk();
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => true]);
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY', $dispatch)->assertOk();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->assertJsonPath('data.fulfillment.assignment.role', 'FULFILLMENT')
            ->assertJsonPath('data.fulfillment.assignment.user_id', null)->assertJsonPath('data.fulfillment.accepted_arrangement.vehicles.0.name', 'Box truck');
        $this->milestone($staff, $orderId, 'DELIVERED', ['receiver_name' => 'Delivery Receiver'], files: ['file' => UploadedFile::fake()->image('delivery.png')])->assertOk();
        $this->signInStoreMember($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version, 'fulfillment_method' => 'SELF_PICKUP'])->assertOk();
        self::assertSame($snapshot, DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot'));
        self::assertSame($assignment, DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->value('id'));
    }

    /**
     * @param  array<string, string>  $fields
     * @param  array<string, UploadedFile>  $files
     */
    private function milestone(User $member, string $orderId, string $milestone, array $fields = [], ?string $key = null, array $files = []): TestResponse
    {
        $this->signInStoreMember($member);
        $lock = (int) (DB::table('orders')->where('id', $orderId)->value('lock_version') ?? 1);

        return $this->post('/api/v1/vendor/orders/'.$orderId.'/fulfillment/milestones', array_replace(['milestone' => $milestone, 'lock_version' => (string) $lock], $fields) + $files,
            ['Idempotency-Key' => $key ?? (string) Str::uuid7(), 'Accept' => 'application/json']);
    }

    private function assign(User $staff, User $owner, string $orderId): TestResponse
    {
        $this->signInStoreMember($owner);

        return $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', ['user_id' => $staff->id, 'reason' => 'Morning pickup shift'], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    public function test_assignment_and_dispatch_commit_together_and_workspace_is_assignee_only(): void
    {
        [$store, $owner, $buyer, $orderId, $vehicle] = $this->paidDelivery('Atomic dispatch');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $other = $this->teamMember($store, 'FULFILLMENT');
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/fulfillment')->assertForbidden();
        $version = (int) DB::table('orders')->where('id', $orderId)->value('lock_version');
        $input = ['user_id' => $staff->id, 'reason' => 'Morning delivery dispatch', 'vehicle_index' => 0, 'lock_version' => $version, 'dispatch' => true];
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => false]);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', $input, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertSame(0, DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->count());
        self::assertSame('PROCESSING', $this->orderState($orderId));
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['available' => true]);
        $key = (string) Str::uuid7();
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', $input, ['Idempotency-Key' => $key])->assertOk()
            ->assertJsonPath('data.fulfillment.state', 'OUT_FOR_DELIVERY')->assertJsonPath('data.fulfillment.assignment.vehicle.name', 'Box truck');
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', $input, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame(1, DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->count());
        self::assertSame(1, DB::table('fulfillment_milestones')->where('order_id', $orderId)->where('event_type', 'OUT_FOR_DELIVERY')->count());
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/fulfillment?status=OUT_FOR_DELIVERY&q='.urlencode((string) DB::table('orders')->where('id', $orderId)->value('reference')))->assertOk()->assertJsonCount(1, 'data');
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertSame(1, DB::table('fulfillment_milestones')->where('order_id', $orderId)->where('event_type', 'ASSIGNMENT_ACKNOWLEDGED')->count());
        $this->getJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/route')->assertOk()->assertJsonPath('data.distance_meters', 4200);
        $this->signInStoreMember($other);
        $this->getJson('/api/v1/vendor/fulfillment')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/route')->assertNotFound();
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertNotFound();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->assertJsonPath('data.fulfillment.assignment.vehicle.name', 'Box truck')
            ->assertJsonPath('data.fulfillment.assignment.user_id', null)->assertJsonCount(0, 'data.fulfillment.assignment_history');
    }

    public function test_vehicle_allocations_conflict_until_delivery_and_proof_keeps_additional_private_photos(): void
    {
        [$store, $owner, $buyer, $first, $vehicle] = $this->paidDelivery('Vehicle allocation');
        [, , , $second] = $this->paidDelivery('Second delivery', [$store, $owner, $vehicle]);
        DB::table('vendor_vehicles')->where('id', $vehicle)->update(['number_available' => 1]);
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $other = $this->teamMember($store, 'FULFILLMENT');
        $before = DB::table('order_delivery_snapshots')->where('order_id', $first)->value('snapshot');
        $this->assign($staff, $owner, $first)->assertOk();
        $this->assign($other, $owner, $second)->assertUnprocessable()->assertJsonPath('errors.0.code', 'DELIVERY_VEHICLE_REQUIRED');
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/orders/'.$second.'/fulfillment/vehicles')->assertOk()->assertJsonPath('data.0.available', false);
        $this->milestone($staff, $first, 'PROCESSING')->assertOk();
        $this->milestone($staff, $first, 'OUT_FOR_DELIVERY', ['vehicle_index' => 0, 'trip_number' => 1])->assertOk();
        $this->milestone($staff, $first, 'DELIVERED', ['receiver_name' => 'Site Receiver', 'note' => 'Received all materials.'], null,
            ['file' => UploadedFile::fake()->image('pod.png'), 'additional_photos' => [UploadedFile::fake()->image('extra.png')]])->assertOk()
            ->assertJsonPath('data.fulfillment.proof.note', 'Received all materials.')->assertJsonCount(1, 'data.fulfillment.proof.additional_photo_paths');
        $proof = DB::table('fulfillment_proofs')->where('order_id', $first)->first();
        $photo = json_decode((string) $proof->payload, true)['additional_photo_ids'][0];
        $this->signInStoreMember($other);
        $this->get('/api/v1/vendor/orders/'.$first.'/files/'.$photo)->assertNotFound();
        $this->signInBuyer($buyer);
        $this->get('/api/v1/buyers/orders/'.$first.'/files/'.$photo)->assertOk();
        $this->assign($other, $owner, $second)->assertOk();
        $this->assign($other, $owner, $first)->assertConflict()->assertJsonPath('errors.0.code', 'ASSIGNMENT_NOT_AVAILABLE');
        self::assertSame($before, DB::table('order_delivery_snapshots')->where('order_id', $first)->value('snapshot'));
        self::assertSame('DELIVERED', $this->orderState($first), 'Receipt confirmation remains a separate Buyer step.');
    }

    public function test_only_assigned_staff_complete_delivery_and_publish_proof_to_owner_and_buyer(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidDelivery('Staff delivery proof');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $other = $this->teamMember($store, 'FULFILLMENT');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/assignment', [
            'user_id' => $staff->id, 'reason' => 'Assigned delivery staff', 'vehicle_index' => 0,
            'lock_version' => (int) DB::table('orders')->where('id', $orderId)->value('lock_version'), 'dispatch' => true,
        ], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.permissions.can_record_milestone', false)->assertJsonPath('data.permissions.can_report_vehicle_issue', true)
            ->assertJsonPath('data.fulfillment.next_action', 'NONE')->assertJsonPath('data.primary_action', 'NONE');

        $this->milestone($owner, $orderId, 'DELIVERED')->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        foreach ([$owner, $manager] as $member) {
            $this->milestone($member, $orderId, 'DELIVERED', ['receiver_name' => 'Site Receiver'], files: ['file' => UploadedFile::fake()->image('owner-proof.png')])
                ->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        }
        self::assertSame('OUT_FOR_DELIVERY', $this->orderState($orderId));
        self::assertSame(0, DB::table('fulfillment_proofs')->where('order_id', $orderId)->count());
        self::assertSame(0, DB::table('files')->where('owner_type', 'ORDER')->where('owner_id', $orderId)->count(), 'Owner/Manager proof is rejected before upload storage.');
        $this->milestone($other, $orderId, 'DELIVERED', ['receiver_name' => 'Site Receiver'], files: ['file' => UploadedFile::fake()->image('other-proof.png')])->assertNotFound();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.permissions.can_record_milestone', true)
            ->assertJsonPath('data.fulfillment.next_action', 'RECORD_DELIVERY')->assertJsonPath('data.primary_action', 'RECORD_DELIVERY');
        $this->milestone($staff, $orderId, 'DELIVERED', ['receiver_name' => 'Site Receiver'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PROOF_REQUIRED');
        $this->milestone($staff, $orderId, 'DELIVERED', files: ['file' => UploadedFile::fake()->image('missing-name.png')])->assertUnprocessable()->assertJsonPath('errors.0.code', 'PROOF_REQUIRED');
        $key = (string) Str::uuid7();
        $fields = ['receiver_name' => 'Site Receiver', 'lock_version' => (string) DB::table('orders')->where('id', $orderId)->value('lock_version')];
        for ($attempt = 0; $attempt < 2; $attempt++) {
            $this->milestone($staff, $orderId, 'DELIVERED', $fields, $key, ['file' => UploadedFile::fake()->image('staff-proof.png')])->assertOk()
                ->assertJsonPath('data.fulfillment.state', 'DELIVERED')->assertJsonPath('data.fulfillment.proof.signature_path', null);
        }
        $proof = DB::table('fulfillment_proofs')->where('order_id', $orderId)->first();
        self::assertSame((int) $staff->id, (int) $proof->actor_user_id);
        self::assertSame(1, DB::table('fulfillment_proofs')->where('order_id', $orderId)->count());
        self::assertSame(1, DB::table('files')->where('owner_type', 'ORDER')->where('owner_id', $orderId)->count(), 'Replayed proof does not retain another upload.');
        foreach ([$owner, $manager] as $member) {
            $this->signInStoreMember($member);
            $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.fulfillment.state', 'DELIVERED')
                ->assertJsonPath('data.fulfillment.proof.receiver_name', 'Site Receiver');
            self::assertSame(1, DB::table('notifications')->where('user_id', $member->id)->where('resource_id', $orderId)->where('title', 'like', '%was delivered')->count());
        }
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->assertJsonPath('data.fulfillment.state', 'DELIVERED')
            ->assertJsonPath('data.fulfillment.proof.receiver_name', 'Site Receiver')->assertJsonPath('data.fulfillment.assignment.user_id', null);
        $this->get('/api/v1/buyers/orders/'.$orderId.'/files/'.$proof->photo_file_id)->assertOk();
        self::assertSame(1, DB::table('notifications')->where('user_id', $buyer->id)->where('resource_id', $orderId)->where('title', 'like', '%was delivered')->count());
        self::assertSame('DELIVERED', $this->orderState($orderId), 'Buyer confirmation remains a separate action.');
    }

    public function test_delivery_submission_rechecks_assignment_after_scanning_and_discards_revoked_proof(): void
    {
        [$store, $owner, , $orderId] = $this->paidDelivery('Proof authorization race');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $other = $this->teamMember($store, 'FULFILLMENT');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->once()->andReturnUsing(static function () use ($orderId, $other): void {
            DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->update(['user_id' => $other->id]);
        });
        $this->assign($staff, $owner, $orderId)->assertOk();
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($owner, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => 0, 'trip_number' => 1])->assertOk();
        $this->milestone($staff, $orderId, 'DELIVERED', ['receiver_name' => 'Site Receiver'], files: ['file' => UploadedFile::fake()->image('revoked-proof.png')])->assertNotFound();
        self::assertSame('OUT_FOR_DELIVERY', $this->orderState($orderId));
        self::assertSame(0, DB::table('fulfillment_proofs')->where('order_id', $orderId)->count());
        self::assertSame(0, DB::table('files')->where('owner_type', 'ORDER')->where('owner_id', $orderId)->count());
    }

    public function test_migration_backfills_the_accepted_vehicle_for_existing_dispatched_assignments(): void
    {
        [$store, $owner, , $orderId, $vehicle] = $this->paidDelivery('Legacy vehicle allocation');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $this->assign($staff, $owner, $orderId)->assertOk();
        $this->milestone($staff, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($staff, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => 0, 'trip_number' => 1])->assertOk();
        $snapshot = DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot');
        $migration = require database_path('migrations/2026_10_13_140000_extend_delivery_assignments.php');
        $migration->down();
        $migration->up();
        $allocation = DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->first();
        self::assertSame($vehicle, (string) $allocation->vehicle_id);
        self::assertSame(0, (int) $allocation->vehicle_index);
        self::assertSame(1, (int) $allocation->number_of_vehicles);
        self::assertSame($snapshot, DB::table('order_delivery_snapshots')->where('order_id', $orderId)->value('snapshot'));
        $this->signInStoreMember($staff);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $acknowledged = DB::table('order_fulfillment_assignments')->where('id', $allocation->id)->value('acknowledged_at');
        $this->assign($staff, $owner, $orderId)->assertOk();
        self::assertSame(1, DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->count(), 'An unchanged confirmed assignment keeps its acknowledgement and timestamp.');
        self::assertSame($acknowledged, DB::table('order_fulfillment_assignments')->where('id', $allocation->id)->value('acknowledged_at'));
    }

    public function test_route_rechecks_account_authorization_after_the_provider_call(): void
    {
        [$store, $owner, , $orderId] = $this->paidDelivery('Route authorization');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $this->assign($staff, $owner, $orderId)->assertOk();
        $this->app->instance(RouteProvider::class, new class((int) $staff->id) implements RouteProvider
        {
            public function __construct(private readonly int $userId) {}

            public function configured(): bool
            {
                return true;
            }

            /** @return array{distance_meters: int, duration_seconds: int, encoded_polyline: string, duration_basis: string}|null */
            public function drive(float $originLatitude, float $originLongitude, float $destinationLatitude, float $destinationLongitude): ?array
            {
                DB::table('users')->where('id', $this->userId)->update(['account_status' => 'SUSPENDED']);

                return ['distance_meters' => 4200, 'duration_seconds' => 1080, 'encoded_polyline' => 'route', 'duration_basis' => 'TRAFFIC_AWARE'];
            }
        });
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/orders/'.$orderId.'/fulfillment/route')->assertForbidden()->assertJsonPath('errors.0.code', 'ACCOUNT_NOT_ACTIVE');
    }

    public function test_delivery_buyer_contact_and_photo_follow_current_role_assignment_and_closure(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidDelivery('Delivery Buyer contact');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $replacement = $this->teamMember($store, 'FULFILLMENT');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $storeStaff = $this->teamMember($store, 'STORE_STAFF');
        $phone = '+639170000001';
        $photo = 'synthetic sanitized profile photo';
        DB::table('user_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $buyer->id, 'full_name' => 'Sample delivery Buyer',
            'mobile_e164' => $phone, 'created_at' => now(), 'updated_at' => now()]);
        $buyer->forceFill(['profile_photo_key' => 'private/profile-photos/contact-test.png', 'profile_photo_disk' => 'local'])->save();
        Storage::disk('local')->put($buyer->profile_photo_key, $photo);
        $photoPath = '/vendor/orders/'.$orderId.'/fulfillment/buyer-photo?version='.$buyer->lock_version;
        $this->assign($staff, $owner, $orderId)->assertOk();

        foreach ([$owner, $manager, $staff] as $member) {
            $this->signInStoreMember($member);
            $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.buyer.display_name', 'Sample delivery Buyer')->assertJsonPath('data.buyer.mobile_e164', $phone)
                ->assertJsonPath('data.buyer.avatar_path', $photoPath)->assertJsonMissingPath('data.buyer.email')
                ->assertJsonMissingPath('data.buyer.user_id')->assertJsonMissingPath('data.buyer.profile_photo_key');
            $this->get('/api/v1'.$photoPath)->assertOk()->assertHeader('Content-Type', 'image/png')
                ->assertHeader('Cache-Control', 'no-store, private')->assertHeader('X-Content-Type-Options', 'nosniff')->assertStreamedContent($photo);
            $this->get('/api/v1/vendor/orders/'.$orderId.'/fulfillment/buyer-photo?version=999999')->assertNotFound();
        }
        $this->signInStoreMember($storeStaff);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.buyer.mobile_e164', null)->assertJsonPath('data.buyer.avatar_path', null);
        $this->get('/api/v1'.$photoPath)->assertForbidden();
        $this->signInStoreMember($replacement);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        $this->get('/api/v1'.$photoPath)->assertNotFound();
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId)->assertOk()->assertJsonMissingPath('data.buyer');
        [, $foreignOwner] = $this->activeStore('Different contact store');
        $this->signInStoreMember($foreignOwner);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        $this->get('/api/v1'.$photoPath)->assertNotFound();

        $this->assign($replacement, $owner, $orderId)->assertOk();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertNotFound();
        $this->get('/api/v1'.$photoPath)->assertNotFound();
        $this->signInStoreMember($replacement);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.buyer.mobile_e164', $phone);
        $this->get('/api/v1'.$photoPath)->assertOk();
        DB::table('vendor_memberships')->where('user_id', $replacement->id)->update(['status' => 'INACTIVE']);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertForbidden();
        $this->get('/api/v1'.$photoPath)->assertForbidden();
        DB::table('vendor_memberships')->where('user_id', $replacement->id)->update(['status' => 'ACTIVE']);

        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($owner, $orderId, 'OUT_FOR_DELIVERY', ['vehicle_index' => '0', 'trip_number' => '1'])->assertOk();
        $this->milestone($replacement, $orderId, 'DELIVERED', ['receiver_name' => 'Sample receiver'], files: ['file' => UploadedFile::fake()->image('delivery.png')])->assertOk();
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/receipt/confirm', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInStoreMember($replacement);
        $this->get('/api/v1'.$photoPath)->assertNotFound();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.buyer.mobile_e164', null)->assertJsonPath('data.buyer.avatar_path', null);
        $this->get('/api/v1'.$photoPath)->assertNotFound();
    }

    public function test_delivery_buyer_photo_rechecks_assignment_after_private_storage_read(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidDelivery('Buyer photo revocation');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $buyer->forceFill(['profile_photo_key' => 'private/profile-photos/revocation-test.png', 'profile_photo_disk' => 'local'])->save();
        $this->assign($staff, $owner, $orderId)->assertOk();
        $disk = \Mockery::mock(FilesystemAdapter::class);
        $disk->shouldReceive('get')->once()->with($buyer->profile_photo_key)->andReturnUsing(static function () use ($orderId): string {
            DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->update(['ended_at' => now()]);

            return 'synthetic photo that must not leave the API';
        });
        Storage::shouldReceive('disk')->with('local')->once()->andReturn($disk);
        $this->signInStoreMember($staff);
        $this->get('/api/v1/vendor/orders/'.$orderId.'/fulfillment/buyer-photo')->assertNotFound()->assertJsonPath('errors.0.code', 'ORDER_NOT_FOUND');
    }

    public function test_delivery_buyer_contact_missing_data_and_pickup_orders_do_not_expose_contact(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidDelivery('Missing Buyer contact');
        $staff = $this->teamMember($store, 'FULFILLMENT');
        DB::table('user_profiles')->where('user_id', $buyer->id)->update(['mobile_e164' => null]);
        $this->assign($staff, $owner, $orderId)->assertOk();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk()->assertJsonPath('data.buyer.mobile_e164', null)->assertJsonPath('data.buyer.avatar_path', null);
        $this->get('/api/v1/vendor/orders/'.$orderId.'/fulfillment/buyer-photo')->assertNotFound();
        [, $pickupOwner, , $pickupOrder] = $this->paidPickup('Pickup Buyer contact');
        $this->signInStoreMember($pickupOwner);
        $this->getJson('/api/v1/vendor/orders/'.$pickupOrder)->assertOk()->assertJsonPath('data.buyer.mobile_e164', null)->assertJsonPath('data.buyer.avatar_path', null);
        $this->get('/api/v1/vendor/orders/'.$pickupOrder.'/fulfillment/buyer-photo')->assertNotFound();
    }

    private function toPickedUp(User $owner, string $orderId): void
    {
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($owner, $orderId, 'READY_FOR_PICKUP')->assertOk();
        $this->milestone($owner, $orderId, 'PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana Buyer', 'receiver_kind' => 'BUYER'])->assertOk();
    }

    private function cancelConfirmed(User $buyer, string $orderId): void
    {
        $lock = (int) $this->buyerOrder($buyer, $orderId)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'CHANGE_OF_REQUIREMENT'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
    }

    private function requestCancellation(User $buyer, string $orderId): void
    {
        $lock = (int) $this->buyerOrder($buyer, $orderId)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'SCHEDULE_CONFLICT'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()
            ->assertJsonPath('data.states.0.state', 'CANCELLATION_REQUESTED');
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE12ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInAdmin(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');
    }
}
