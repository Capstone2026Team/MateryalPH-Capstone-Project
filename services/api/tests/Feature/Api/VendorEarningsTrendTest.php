<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\VendorFinanceService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
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
 * Earnings charts (FIN-11): every figure is bucketed by the same Asia/Manila date its total is filtered on, so the
 * points always sum to the totals; long periods switch to calendar months; the comparison is the equal-length period
 * just before; a period after today is empty rather than faked; and the series stays Owner-only.
 */
final class VendorEarningsTrendTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        // Seed effective policies at the same instant as the simulated orders.
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
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

    public function test_points_sum_to_the_totals_by_manila_day_with_the_previous_period_for_comparison(): void
    {
        [, $owner, $paymentId] = $this->paidAndCompletedOrder();
        $this->signInStoreMember($owner);

        $all = $this->earnings();
        self::assertSame(['DAY', 'Asia/Manila', '2026-10-20', '2026-10-20', 1], [$all['trend']['granularity'], $all['trend']['timezone'], $all['trend']['from'], $all['trend']['to'], $all['trend']['days']],
            'All dates starts at the first order and ends today.');
        self::assertSame(20000, $all['earned_commission_centavos']);
        $this->assertPointsSumToTotals($all);

        $week = $this->earnings('?from=2026-10-14&to=2026-10-20');
        self::assertCount(7, $week['trend']['points']);
        self::assertSame(['2026-10-14', '2026-10-20'], [$week['trend']['points'][0]['date'], $week['trend']['points'][6]['date']]);
        self::assertSame($week['online_collections_centavos'], $week['trend']['points'][6]['online_collections_centavos']);
        self::assertGreaterThan(0, $week['online_collections_centavos']);
        $this->assertPointsSumToTotals($week);
        self::assertSame(['2026-10-07', '2026-10-13'], [$week['trend']['previous']['from'], $week['trend']['previous']['to']]);
        self::assertSame(array_fill_keys(VendorFinanceService::TREND_FIGURES, 0), $week['trend']['previous']['totals']);
        self::assertSame(array_fill_keys(VendorFinanceService::TREND_FIGURES, null), $week['trend']['previous']['change_percent'], 'No change is claimed against an empty period.');

        // 00:30 on Oct 13 in Manila is still Oct 12 in UTC: the payment belongs to the Manila day.
        $principal = (int) $week['online_collections_centavos'];
        DB::table('payments')->where('id', $paymentId)->update(['paid_at' => '2026-10-12 16:30:00+00']);
        $day = $this->earnings('?from=2026-10-13&to=2026-10-13');
        self::assertSame([['2026-10-13', $principal]], array_map(static fn (array $p): array => [$p['date'], $p['online_collections_centavos']], $day['trend']['points']));

        $moved = $this->earnings('?from=2026-10-14&to=2026-10-20');
        self::assertSame(0, $moved['online_collections_centavos']);
        self::assertSame($principal, $moved['trend']['previous']['totals']['online_collections_centavos']);
        self::assertEqualsWithDelta(-100.0, $moved['trend']['previous']['change_percent']['online_collections_centavos'], 0.001);
    }

    public function test_long_periods_chart_by_month_and_a_period_after_today_is_empty(): void
    {
        [, $owner] = $this->paidAndCompletedOrder();
        $this->signInStoreMember($owner);

        $months = $this->earnings('?from=2026-04-15&to=2026-10-20');
        self::assertSame(['MONTH', 189], [$months['trend']['granularity'], $months['trend']['days']]);
        self::assertSame(['2026-04-01', '2026-05-01', '2026-06-01', '2026-07-01', '2026-08-01', '2026-09-01', '2026-10-01'], array_column($months['trend']['points'], 'date'));
        $this->assertPointsSumToTotals($months);

        $quarter = $this->earnings('?from=2026-07-21&to=2026-10-20');
        self::assertSame(['DAY', 92], [$quarter['trend']['granularity'], $quarter['trend']['days']], 'Up to 92 days stays daily.');

        $capped = $this->earnings('?from=2026-10-18&to=2026-12-31');
        self::assertSame(['2026-10-20', 3], [$capped['trend']['to'], $capped['trend']['days']], 'The chart never runs past today.');

        $future = $this->earnings('?from=2026-10-25&to=2026-10-30');
        self::assertSame([[], null, 0], [$future['trend']['points'], $future['trend']['previous'], $future['trend']['days']]);
        self::assertSame(0, $future['commercial_sales_centavos']);
    }

    public function test_each_card_breakdown_and_the_product_list_reconcile_to_the_headline_figures(): void
    {
        [, $owner] = $this->paidAndCompletedOrder();
        $this->signInStoreMember($owner);

        $data = $this->earnings();
        $sales = $data['breakdown']['sales'];
        self::assertSame(1, $sales['orders']);
        self::assertSame($sales['materials_before_discount_centavos'] - $sales['vendor_discounts_centavos'], $sales['materials_after_discount_centavos']);
        self::assertSame($data['commercial_sales_centavos'], $sales['materials_after_discount_centavos'] + $sales['delivery_centavos'], 'Materials plus delivery are commercial sales.');
        $online = $data['breakdown']['online'];
        self::assertSame([1, 0], [$online['payments'], $online['refunded_principal_centavos']]);
        self::assertSame($data['online_collections_centavos'], $online['principal_paid_centavos'] - $online['refunded_principal_centavos']);
        $physical = $data['breakdown']['physical'];
        self::assertSame($data['physical_collections_centavos'], $physical['cash_on_delivery_centavos'] + $physical['in_store_centavos']);

        $products = $data['products'];
        self::assertSame([false, count($products['items'])], [$products['truncated'], $products['total']]);
        self::assertGreaterThan(0, $products['total']);
        self::assertSame($sales['materials_after_discount_centavos'], array_sum(array_column($products['items'], 'value_centavos')), 'The products add up to the materials in commercial sales.');
        self::assertSame($products['items'], collect($products['items'])->sortByDesc('value_centavos')->values()->all(), 'Largest sales value first.');
        self::assertArrayNotHasKey('buyer_profile_id', $products['items'][0]);

        $empty = $this->earnings('?from=2026-10-25&to=2026-10-30');
        self::assertSame([[], 0, 0], [$empty['products']['items'], $empty['products']['total'], $empty['breakdown']['sales']['orders']]);
    }

    public function test_the_series_is_owner_only(): void
    {
        [$store] = $this->paidAndCompletedOrder();
        $this->signInStoreMember($this->teamMember($store, 'STORE_MANAGER'));
        $this->getJson('/api/v1/vendor/finance/earnings?from=2026-10-14')->assertForbidden()->assertJsonPath('errors.0.code', 'FINANCE_OWNER_ONLY')->assertJsonMissingPath('data.trend');
    }

    public function test_only_confirmed_refunds_reduce_collections_and_cash_without_rewriting_posted_tax(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Refund Reporting Hardware');
        $payment = $this->startPayment($buyer, $orderId);
        $this->completePayment($payment['id'])->assertOk();
        $this->signInStoreMember($owner);
        $before = $this->earnings();
        $assessment = DB::table('remittance_assessments')->where('payment_id', $payment['id'])->first();
        $accumulator = DB::table('vendor_withholding_accumulators')->where('organization_id', $store->id)->first();

        $lock = (int) $this->buyerOrder($buyer, $orderId)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'BUDGET_CHANGE'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $refund = DB::table('refunds')->where('source_payment_id', $payment['id'])->first();
        $this->signInStoreMember($owner);
        $this->assertRefundReporting($payment, 'REFUND_PENDING', 0);
        $pending = $this->earnings();
        self::assertSame($before['estimated_remittance_cash_centavos'], $pending['estimated_remittance_cash_centavos'], 'Cancellation alone does not pretend the provider refunded the collection.');

        $this->deliverWebhook($this->gateway->settleRefund((string) $refund->provider_reference, 'FAILED'))->assertOk();
        $this->assertRefundReporting($payment, 'REFUND_FAILED', 0);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/refunds/'.$refund->id.'/retry', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $providerId = (string) DB::table('refunds')->where('id', $refund->id)->value('provider_reference');
        $event = $this->gateway->settleRefund($providerId);
        $this->deliverWebhook($event, 'wh-reporting-refund')->assertOk();
        $this->deliverWebhook($event, 'wh-reporting-refund')->assertOk();
        $this->assertRefundReporting($payment, 'REFUNDED', (int) $payment['total_centavos']);

        $after = $this->earnings();
        // Refunded money is not paid: a fully refunded collection adds no remittance cash, provider charge or CWT, and no sale.
        self::assertGreaterThan(0, $before['estimated_remittance_cash_centavos']);
        self::assertSame([0, 0, 0, 0], [$after['estimated_remittance_cash_centavos'], $after['provider_charges_centavos'], $after['simulated_cwt_centavos'], $after['commercial_sales_centavos']]);
        self::assertSame([0, 0, []], [$after['breakdown']['sales']['orders'], $after['products']['total'], $after['products']['items']], 'A fully refunded order is not sold, so it lists no product.');
        self::assertSame($after['breakdown']['online']['principal_paid_centavos'], $after['breakdown']['online']['refunded_principal_centavos'], 'The refunded principal cancels the verified payment.');
        $voided = DB::table('remittance_assessments')->where('id', $assessment->id)->first();
        self::assertSame(['VOIDED', (int) $assessment->gross_basis_centavos, (int) $assessment->withheld_centavos, (int) $assessment->expected_vendor_cash_centavos],
            [$voided->calculation_state, (int) $voided->gross_basis_centavos, (int) $voided->withheld_centavos, (int) $voided->expected_vendor_cash_centavos], 'Posted amounts are never rewritten; only the state changes.');
        self::assertSame((int) $accumulator->g_accumulated_centavos - (int) $assessment->gross_basis_centavos, (int) DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->value('g_accumulated_centavos'),
            'A fully refunded collection leaves the uncrossed FIN-04A counter.');
        self::assertSame('PAID', $this->paymentState($payment['id']));
        $csv = $this->get('/api/v1/vendor/finance/transactions/export?tab=PAYMENTS')->assertOk()->streamedContent();
        self::assertStringContainsString('refund_state,refunded_centavos,net_collected_centavos', $csv);
        self::assertStringContainsString('REFUNDED,'.$payment['total_centavos'].',0', $csv);

        // Later refunds still adjust the original collection date, including historical comparisons.
        DB::table('payments')->where('id', $payment['id'])->update(['paid_at' => '2026-10-12 16:30:00+00']);
        $day = $this->earnings('?from=2026-10-13&to=2026-10-13');
        self::assertSame((int) $payment['total_centavos'], $day['online_refunds_centavos']);
        self::assertSame(0, $day['remittance_refunds_centavos'], 'The remittance breakdown uses the assessment date, not the payment date.');
        $this->assertPointsSumToTotals($day);
        $week = $this->earnings('?from=2026-10-14&to=2026-10-20');
        self::assertSame((int) $payment['total_centavos'], $week['remittance_refunds_centavos'], 'A fully refunded assessment remains visible as a refund in its original assessment period.');
        self::assertSame((int) $payment['total_centavos'], $week['trend']['previous']['totals']['online_refunds_centavos']);
        self::assertSame(0, $week['trend']['previous']['totals']['online_collections_centavos']);
        $this->assertPointsSumToTotals($this->earnings('?from=2026-04-15&to=2026-10-20'));
    }

    public function test_a_confirmed_partial_refund_counts_only_the_retained_principal(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Partial Refund Reporting', [['price' => 100000, 'qty' => '50']]);
        [$buyer, $orderId] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '10']]);
        $line = $this->vendorOrder($owner, $orderId)['lines'][0]['id'];
        $nrpc = ['nrpc' => ['amount_centavos' => 100000, 'reason' => 'Custom cutting to the Buyer drawings', 'lines' => [['order_line_id' => $line, 'principal_centavos' => 100000]]]];
        $this->confirmOrder($owner, $orderId, [], $nrpc)->assertUnprocessable()->assertJsonPath('errors.0.message', 'NRPC is available only for COD or In-Store Payment orders awaiting Vendor confirmation.');
        // New NRPC is proposed only on COD or In-Store orders. Build the record through that path, then restore the
        // online payment method: online NRPC orders accepted before the 2026-10-23 rule still report their refunds.
        DB::table('orders')->where('id', $orderId)->update(['payment_method' => 'IN_STORE']);
        $this->confirmOrder($owner, $orderId, [], $nrpc)->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['payment_method' => 'ONLINE']);
        $detail = $this->buyerOrder($buyer, $orderId);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/nrpc/accept', ['snapshot_version' => 2, 'nrpc_id' => $detail['nrpc']['id'], 'terms_version_id' => $detail['nrpc']['terms']['id'], 'acknowledged' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $payment = $this->startPayment($buyer, $orderId);
        $this->completePayment($payment['id'])->assertOk();
        $detail = $this->vendorOrder($owner, $orderId);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/fulfillment/milestones', ['lock_version' => $detail['lock_version'], 'milestone' => 'PROCESSING'], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertOk();
        $lock = (int) $this->buyerOrder($buyer, $orderId)['lock_version'];
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/cancel', ['lock_version' => $lock, 'reason_code' => 'PROJECT_DELAY'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $this->signInStoreMember($owner);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/cancellation-request/finalize', ['retain_nrpc' => '1', 'note' => 'Blocks were cut to the Buyer drawings.', 'file' => UploadedFile::fake()->image('cut-blocks.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertOk();
        $refund = DB::table('refunds')->where('source_payment_id', $payment['id'])->first();
        $this->deliverWebhook($this->gateway->settleRefund((string) $refund->provider_reference))->assertOk();
        $this->assertRefundReporting($payment, 'PARTIALLY_REFUNDED', (int) $payment['total_centavos'] - 100000);
        $partial = $this->earnings();
        self::assertSame(100000, $partial['online_collections_centavos']);
        self::assertSame((int) $payment['principal_centavos'] - 100000, $partial['breakdown']['online']['refunded_principal_centavos'], 'Only the refunded part of the principal is deducted.');
        self::assertSame(0, $partial['breakdown']['sales']['orders'], 'This order ended cancelled, so it is not a sale; the retained NRPC shows as online collections.');
    }

    public function test_threshold_explains_delivery_and_vat_without_replacing_the_taxpayer_year_basis_with_cash(): void
    {
        [$store, $owner, , $orderId] = $this->awaitingPayment('Threshold Breakdown');
        $snapshotId = (string) DB::table('financial_snapshots')->where('order_id', $orderId)->orderByDesc('created_at')->orderByDesc('id')->value('id');
        $assess = function (CarbonImmutable $instant, int $collected = 43957, int $charge = 1132) use ($store, $orderId, $snapshotId): void {
            app(RemittanceAssessmentService::class)->assess([
                'environment' => 'TEST', 'organization_id' => (string) $store->id, 'order_id' => $orderId,
                'financial_snapshot_id' => $snapshotId, 'payment_id' => null, 'group_key' => 'THRESHOLD:'.Str::uuid7(),
                'instant' => $instant, 'evidence_origin' => 'XENDIT_TEST', 'collected' => $collected, 'refunds' => 0,
                'delivery' => 14275, 'vat' => 3059, 'provider_charge' => $charge, 'principal' => 42825, 'basis' => [],
            ], (string) Str::uuid7());
        };
        $assess(CarbonImmutable::now());
        $assess(CarbonImmutable::now());
        $assess(CarbonImmutable::now(), 43958, 1133);
        $assess(CarbonImmutable::now()->subYear());
        $this->paidAndCompletedOrder(); // A different taxpayer's collections must not enter this breakdown.
        $this->signInStoreMember($owner);
        $threshold = $this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.threshold');
        self::assertSame([76473, 49923527], [$threshold['cumulative_gross_centavos'], $threshold['remaining_allowance_centavos']]);
        self::assertSame([
            'collections_centavos' => 131872, 'refunds_centavos' => 0, 'delivery_centavos' => 42825, 'material_vat_centavos' => 9177,
            'provider_charges_centavos' => 3397, 'gross_basis_centavos' => 76473, 'withheld_centavos' => 381, 'assessed_cash_centavos' => 128094,
        ], $threshold['calculation_breakdown']);
        self::assertSame(128094, $threshold['local_gross_centavos'] + 42825 + 9177 - 381, 'Delivery and material VAT remain in cash; withholding is deducted only from cash.');

        $counter = DB::table('vendor_withholding_accumulators')->where('organization_id', $store->id)->where('taxable_year', 2026);
        $counter->update(['g_external_declared_centavos' => 20000, 'g_external_overlap_centavos' => 5000, 'external_overlap_state' => 'RESOLVED']);
        $this->getJson('/api/v1/vendor/finance')->assertOk()->assertJsonPath('data.threshold.cumulative_gross_centavos', 91473)
            ->assertJsonPath('data.threshold.calculation_breakdown.gross_basis_centavos', 76473);
        $counter->update(['g_accumulated_centavos' => 80000]);
        $this->getJson('/api/v1/vendor/finance')->assertOk()->assertJsonPath('data.threshold.calculation_breakdown', null);
    }

    public function test_the_payments_status_filter_matches_exactly_the_status_each_row_shows(): void
    {
        [, $owner, $paymentId] = $this->paidAndCompletedOrder();
        $this->signInStoreMember($owner);
        $this->assertOnlyPaymentStatusMatches($paymentId, 'PAID');

        DB::table('payments')->where('id', $paymentId)->update(['late_capture' => true]);
        $this->assertOnlyPaymentStatusMatches($paymentId, 'LATE_CAPTURE');
        DB::table('payments')->where('id', $paymentId)->update(['late_capture' => false]);

        foreach (['FAILED' => 'FAILED', 'EXPIRED' => 'EXPIRED', 'CANCELLED' => 'EXPIRED', 'PENDING' => 'PENDING', 'UNCERTAIN' => 'PENDING'] as $state => $filter) {
            DB::table('payments')->where('id', $paymentId)->update(['state' => $state]);
            $this->assertOnlyPaymentStatusMatches($paymentId, $filter);
        }

        $this->getJson('/api/v1/vendor/finance/transactions?tab=PAYMENTS&status=PAID_ALMOST')->assertUnprocessable();
        $this->get('/api/v1/vendor/finance/transactions/export?tab=PAYMENTS&status=FAILED')->assertOk();
        $csv = $this->get('/api/v1/vendor/finance/transactions/export?tab=PAYMENTS&status=PAID')->assertOk()->streamedContent();
        self::assertStringNotContainsString($paymentId, $csv, 'The export honours the same status filter as the list.');
        $this->getJson('/api/v1/vendor/finance/transactions?tab=PAYMENTS&status=PENDING&page=1')->assertOk()->assertJsonPath('meta.total', 1);
    }

    /** The row's own filter returns it and every other Payments status filter excludes it, so list and badge never disagree. */
    private function assertOnlyPaymentStatusMatches(string $paymentId, string $expected): void
    {
        foreach (VendorFinanceService::PAYMENT_STATUSES as $status) {
            $ids = array_column($this->getJson('/api/v1/vendor/finance/transactions?tab=PAYMENTS&status='.$status)->assertOk()->json('data'), 'id');
            self::assertSame($status === $expected ? [$paymentId] : [], $ids, "Filter {$status} for a row that is {$expected}.");
        }
    }

    /** @param array<string, mixed> $payment */
    private function assertRefundReporting(array $payment, string $state, int $refunded): void
    {
        $rows = $this->getJson('/api/v1/vendor/finance/transactions?tab=PAYMENTS')->assertOk()->json('data');
        self::assertCount(1, $rows, 'Refund instructions never duplicate the original payment row.');
        self::assertSame([$payment['id'], 'PAID', $state, (int) $payment['total_centavos'], $refunded, (int) $payment['total_centavos'] - $refunded],
            [$rows[0]['id'], $rows[0]['status'], $rows[0]['refund_state'], $rows[0]['gross_centavos'], $rows[0]['refunded_centavos'], $rows[0]['net_collected_centavos']]);
        $this->assertOnlyPaymentStatusMatches($payment['id'], 'PAID_'.$state);
        $earnings = $this->earnings();
        self::assertSame($refunded, $earnings['online_refunds_centavos']);
        self::assertSame((int) $payment['total_centavos'], $earnings['remittance_collections_centavos'], 'Show the original collection before full or partial refunds.');
        self::assertSame($refunded, $earnings['remittance_refunds_centavos'], 'Show confirmed full and partial refunds once, including VOIDED assessments.');
        self::assertSame($refunded === 0 ? (int) $payment['principal_centavos'] : (int) $payment['total_centavos'] - $refunded, $earnings['online_collections_centavos']);
        self::assertSame($refunded === 0 ? (int) $payment['processing_fee_centavos'] : 0, $earnings['buyer_processing_fees_centavos']);
        $this->assertPointsSumToTotals($earnings);
        $assessment = DB::table('remittance_assessments')->where('payment_id', $payment['id'])->first();
        $threshold = $this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.threshold');
        $gross = $assessment->calculation_state === 'VOIDED' ? 0 : (int) $assessment->gross_basis_centavos;
        self::assertSame($gross, $threshold['local_gross_centavos']);
        self::assertSame($gross, $threshold['calculation_breakdown']['gross_basis_centavos'], 'Pending, failed and partial refunds preserve the assessed basis; a voided full refund contributes zero.');
    }

    /** @return array{0: VendorOrganization, 1: User, 2: string} */
    private function paidAndCompletedOrder(): array
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Trend Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());

        return [$store, $owner, (string) $attempt['id']];
    }

    /** @return array<string, mixed> */
    private function earnings(string $query = ''): array
    {
        $data = $this->getJson('/api/v1/vendor/finance/earnings'.$query)->assertOk()->json('data');
        self::assertSame($data['estimated_remittance_cash_centavos'], $data['remittance_collections_centavos'] - $data['remittance_refunds_centavos'] - $data['provider_charges_centavos'] - $data['simulated_cwt_centavos'],
            'The displayed components use one assessment-date scope and reconcile to the authoritative remittance estimate, including date boundaries and refunds.');

        return $data;
    }

    /** @param array<string, mixed> $earnings */
    private function assertPointsSumToTotals(array $earnings): void
    {
        foreach (VendorFinanceService::TREND_FIGURES as $figure) {
            self::assertSame($earnings[$figure], array_sum(array_column($earnings['trend']['points'], $figure)), "{$figure} points sum to its total");
        }
    }
}
