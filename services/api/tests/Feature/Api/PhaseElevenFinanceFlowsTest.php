<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\CommissionEmails;
use App\Domain\Finance\CommissionPolicyService;
use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Finance\FinanceNotifier;
use App\Domain\Finance\FinancialLedgerService;
use App\Domain\Finance\PlatformFeeInvoiceService;
use App\Domain\Finance\StatementService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Notifications\MailProvider;
use App\Domain\Notifications\NotificationDelivery;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Payments\RefundService;
use App\Domain\Payments\XenditWebhookProcessor;
use App\Domain\Reporting\DocumentExportService;
use App\Domain\Reporting\DocumentSnapshot;
use App\Domain\Reporting\ExportAccess;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Mail\CommissionPolicyMail;
use App\Mail\PlatformFeeInvoiceMail;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Phase 11 finance flows: Owner-only physical-payment settings and protected finance, In-Store/COD obligations
 * with Vendor-recorded evidence, NRPC assurance and online balance payments counted once, monthly statements paid
 * to the platform TEST account under PLATFORM_FEE_PAYMENT, and Admin finance with distinct preparer/reviewer.
 */
final class PhaseElevenFinanceFlowsTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        // These existing accounting tests exercise configurable immediate publishing. Notice defaults are covered separately.
        config()->set('finance.commission_min_notice_days', 0);
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

    public function test_finance_is_owner_only_across_routes_exports_and_dashboard_fields(): void
    {
        [$store, $owner] = $this->pickupStore('Owner Finance Hardware');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $staff = $this->teamMember($store, 'STORE_STAFF');

        $this->signInStoreMember($owner);
        $overview = $this->getJson('/api/v1/vendor/finance')->assertOk()->json('data');
        self::assertSame(['CONNECTED_TEST', 'Connected — TEST', false], [$overview['xendit_connection']['status'], $overview['xendit_connection']['label'], $overview['xendit_connection']['production_capability']]);
        self::assertSame('Production assignment unconfirmed', $overview['withholding_arrangement']['production_assignment_label']);
        self::assertStringContainsString('DEMO', $overview['demo_label']);
        self::assertSame([false, false], [$overview['physical_payments']['cod_enabled'], $overview['physical_payments']['in_store_enabled']]);
        self::assertSame(50000000, $overview['threshold']['remaining_allowance_centavos']);
        self::assertStringContainsString('final for the taxable year', $overview['threshold']['final_for_year_notice']);
        $this->get('/api/v1/vendor/finance/transactions/export?tab=PAYMENTS')->assertOk()->assertHeader('Content-Type', 'text/csv; charset=UTF-8');
        self::assertSame(1, DB::table('audit_logs')->where('action', 'FINANCE_EXPORT_DOWNLOADED')->count());

        foreach ([$manager, $staff] as $member) {
            $this->signInStoreMember($member);
            foreach (['/api/v1/vendor/finance', '/api/v1/vendor/finance/commissions', '/api/v1/vendor/finance/transactions', '/api/v1/vendor/finance/earnings', '/api/v1/vendor/finance/transactions/export?tab=PAYMENTS'] as $path) {
                $this->getJson($path)->assertForbidden()->assertJsonPath('errors.0.code', 'FINANCE_OWNER_ONLY');
            }
            $this->putJson('/api/v1/vendor/finance/physical-payments', ['lock_version' => 0, 'cod_enabled' => true, 'in_store_enabled' => true])->assertForbidden();
            $snapshot = $this->getJson('/api/v1/vendors/onboarding')->json('data');
            self::assertNotContains('finance.view', $snapshot['permissions'] ?? []);
            self::assertNotContains('portal.wallet', $snapshot['permissions'] ?? []);
        }
        self::assertSame(1, DB::table('audit_logs')->where('action', 'FINANCE_EXPORT_DOWNLOADED')->count());
    }

    public function test_the_owner_can_reveal_the_full_tin_on_demand_and_every_reveal_is_audited_without_the_number(): void
    {
        [$store, $owner] = $this->pickupStore('Owner Tin Hardware');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $versionId = (string) DB::table('vendor_tax_profiles')->where('vendor_organization_id', $store->id)->value('current_version_id');
        DB::table('vendor_tax_profile_versions')->where('id', $versionId)->update(['tin_encrypted' => null]);

        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/tax-profile/tin/reveal')->assertNotFound()->assertJsonPath('errors.0.code', 'TIN_NOT_RECORDED');
        self::assertSame(0, DB::table('audit_logs')->where('action', 'VENDOR_TIN_REVEALED')->count());

        DB::table('vendor_tax_profile_versions')->where('id', $versionId)->update(['tin_encrypted' => Crypt::encryptString('123456789000')]);
        $this->postJson('/api/v1/vendor/tax-profile/tin/reveal')->assertOk()->assertJsonPath('data.tin', '123-456-789-000')->assertHeader('Cache-Control', 'no-store, private');
        $audit = DB::table('audit_logs')->where('action', 'VENDOR_TIN_REVEALED')->first();
        self::assertNotNull($audit);
        self::assertSame((string) $store->id, $audit->resource_id);
        self::assertStringNotContainsString('123456789', json_encode($audit, JSON_THROW_ON_ERROR));
        self::assertStringNotContainsString('123-456-789', json_encode($audit, JSON_THROW_ON_ERROR));

        $this->signInStoreMember($manager);
        $this->postJson('/api/v1/vendor/tax-profile/tin/reveal')->assertForbidden()->assertJsonPath('errors.0.code', 'FINANCE_OWNER_ONLY');
        self::assertSame(1, DB::table('audit_logs')->where('action', 'VENDOR_TIN_REVEALED')->count());
    }

    public function test_in_store_payment_opens_an_obligation_recorded_with_evidence_and_creates_no_online_or_cwt_event(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Cash Hardware', [['price' => 100000, 'qty' => '50']]);
        $buyer = $this->buyer();
        $this->addToCart($listing, '10');
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => [$store->id], 'payment_methods' => [$store->id => 'IN_STORE']], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'CHECKOUT_GROUP_NOT_READY');

        $this->signInStoreMember($owner);
        $this->putJson('/api/v1/vendor/finance/physical-payments', ['lock_version' => 0, 'cod_enabled' => true, 'in_store_enabled' => true])->assertOk()->assertJsonPath('data.in_store_enabled', true);
        $this->putJson('/api/v1/vendor/finance/physical-payments', ['lock_version' => 0, 'cod_enabled' => false, 'in_store_enabled' => true])->assertStatus(409)->assertJsonPath('errors.0.code', 'VERSION_CONFLICT');

        $this->signInBuyer($buyer);
        $preview = $this->postJson('/api/v1/buyers/cart/checkout-preview', ['request_version' => 'p11'])->assertOk()->json('data.groups.0.payment_methods');
        self::assertSame([['ONLINE', true], ['CASH_ON_DELIVERY', false], ['IN_STORE', true]], array_map(static fn (array $m): array => [$m['method'], $m['available']], $preview));
        self::assertSame('SITE_DELIVERY_ONLY', $preview[1]['reason']);
        $lock = (int) $this->getJson('/api/v1/buyers/cart')->json('data.lock_version');
        $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => [$store->id], 'payment_methods' => [$store->id => 'CASH_ON_DELIVERY']], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409);
        $orderId = (string) $this->postJson('/api/v1/buyers/checkouts', ['cart_lock_version' => $lock, 'vendor_ids' => [$store->id], 'payment_methods' => [$store->id => 'IN_STORE']], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertCreated()->json('data.orders.0.id');
        $this->confirmOrder($owner, $orderId)->assertOk()->assertJsonPath('data.states.0.state', 'CONFIRMED')->assertJsonPath('data.states.1.state', 'NOT_REQUIRED');
        self::assertSame(1000000, (int) DB::table('physical_payment_records')->where('order_id', $orderId)->where('record_kind', 'OBLIGATION_OPENED')->value('remaining_obligation_centavos'));

        $fulfillment = $this->teamMember($store, 'FULFILLMENT');
        $this->signInStoreMember($fulfillment);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/physical-payments', ['amount_centavos' => 400000, 'file' => UploadedFile::fake()->image('receipt.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertForbidden();
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $this->signInStoreMember($staff);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/physical-payments', ['amount_centavos' => 1000001, 'file' => UploadedFile::fake()->image('receipt.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'PHYSICAL_PAYMENT_EXCEEDS_BALANCE');
        $partial = $this->post('/api/v1/vendor/orders/'.$orderId.'/physical-payments', ['amount_centavos' => 400000, 'file' => UploadedFile::fake()->image('receipt.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])
            ->assertCreated()->json('data');
        self::assertSame(['PARTIALLY_RECORDED', 600000], [$partial['state'], $partial['remaining_centavos']]);
        $done = $this->post('/api/v1/vendor/orders/'.$orderId.'/physical-payments', ['amount_centavos' => 600000, 'file' => UploadedFile::fake()->image('receipt.png')], ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])
            ->assertCreated()->json('data');
        self::assertSame(['PHYSICAL_PAYMENT_RECORDED', 0], [$done['state'], $done['remaining_centavos']]);
        $this->signInStoreMember($owner);
        $earnings = $this->getJson('/api/v1/vendor/finance/earnings')->assertOk()->json('data');
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $kpis = $this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data');
        $market = collect($kpis['commerce'])->pluck('value_centavos', 'key');
        self::assertSame([1000000, 0, 1000000, 0], [$market['in_store'], $market['cash_on_delivery'], $market['buyer_payments'], $market['online_payments']]);
        self::assertSame($earnings['physical_collections_centavos'], $market['in_store'] + $market['cash_on_delivery']);
        self::assertSame([['IN_STORE', 'In-Store Payment', 'PHYSICAL', 2, 1000000]], array_map(static fn (array $m): array => array_values($m), $kpis['payment_methods']));
        self::assertSame(2, $kpis['counts']['cash_records']);
        $this->getJson('/api/v1/admin/finance/kpis?from=2000-01-01&to=2000-01-31')->assertOk()->assertJsonPath('data.payment_methods', [])
            ->assertJsonPath('data.trend_granularity', 'DAY')->assertJsonCount(31, 'data.trend');

        $this->signInBuyer($buyer);
        $record = collect($this->getJson('/api/v1/buyers/orders/'.$orderId)->json('data.payment.physical.records'))->firstWhere('kind', 'COLLECTION');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/physical-payments/'.$record['id'].'/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertNotNull(DB::table('physical_payment_records')->where('id', $record['id'])->value('buyer_acknowledged_at'));
        self::assertSame([0, 0, 'NOT_REQUIRED'], [DB::table('payments')->count(), DB::table('remittance_assessments')->count(), (string) DB::table('orders')->where('id', $orderId)->value('payment_state')],
            'Direct cash never creates an online success or a platform CWT event.');
        $this->postJson('/api/v1/buyers/reports', ['type' => 'PAYMENT_CONFIRMATION', 'resource_id' => $orderId, 'format' => 'CSV', 'purpose' => 'Retired payment document request'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertSame(0, DB::table('order_documents')->where('order_id', $orderId)->where('kind', 'PAYMENT_CONFIRMATION')->count());
    }

    public function test_nrpc_assurance_and_online_balance_are_counted_once_and_assessed_separately(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Nrpc Cash Hardware', [['price' => 100000, 'qty' => '50']]);
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
            ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.states.0.state', 'AWAITING_PAYMENT');

        $options = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->assertOk()->json('data');
        self::assertSame(['NRPC_ASSURANCE_PAYMENT', 100000, 900000], [$options['purpose'], $options['principal_centavos'], $options['breakdown']['physical_balance_after_centavos']]);
        $nrpcPayment = $this->startPayment($buyer, $orderId, 'GCASH');
        $this->completePayment($nrpcPayment['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));
        $opening = DB::table('physical_payment_records')->where('order_id', $orderId)->where('record_kind', 'OBLIGATION_OPENED')->first();
        self::assertSame(900000, (int) $opening->remaining_obligation_centavos, 'The NRPC principal is credited once; its processing fee is not.');
        $nrpcAssessment = DB::table('remittance_assessments')->where('payment_id', $nrpcPayment['id'])->first();
        self::assertSame([100000, 500], [(int) $nrpcAssessment->gross_basis_centavos, (int) $nrpcAssessment->withheld_centavos]);
        $this->getJson('/api/v1/buyers/orders/'.$orderId.'/payment-options')->assertOk()->assertJsonPath('data.payment_due', false);

        // The Vendor approves paying the rest online; the Buyer pays only that balance plus its own fee.
        $this->signInStoreMember($this->teamMember($store, 'CUSTOMER_SERVICE'));
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/online-balance/approve', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/online-balance/approve', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        $balance = $this->startPayment($buyer, $orderId, 'MAYA');
        self::assertSame(['ORDER_BALANCE_PAYMENT', 900000], [$balance['purpose'], $balance['principal_centavos']]);
        $this->completePayment($balance['id'])->assertOk();
        self::assertSame(0, (int) DB::table('physical_payment_records')->where('order_id', $orderId)->orderBy('remaining_obligation_centavos')->value('remaining_obligation_centavos'));
        $balanceAssessment = DB::table('remittance_assessments')->where('payment_id', $balance['id'])->first();
        self::assertSame(900000, (int) $balanceAssessment->gross_basis_centavos, 'The balance collection is assessed alone; the NRPC principal is never assessed twice.');
        self::assertSame(2, DB::table('remittance_assessments')->count());

        $this->signInStoreMember($owner);
        $earnings = $this->getJson('/api/v1/vendor/finance/earnings')->assertOk()->json('data');
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $kpis = $this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data');
        $market = collect($kpis['commerce'])->pluck('value_centavos', 'key');
        $paid = (int) DB::table('payments')->whereIn('id', [$nrpcPayment['id'], $balance['id']])->sum('total_centavos');
        self::assertSame([1000000, 0, 1000000, 1], [$market['gross_gmv'], $market['cancelled_gmv'], $market['net_gmv'], $kpis['counts']['confirmed_orders']],
            'GMV is the order value once, live from the order: the NRPC principal and the balance are not counted twice.');
        self::assertSame([$paid, $paid, 0, $paid], [$market['online_payments'], $market['buyer_payments'], $market['buyer_refunds'], $market['net_buyer_payments']]);
        self::assertSame($earnings['online_collections_centavos'] + $earnings['buyer_processing_fees_centavos'], $market['net_buyer_payments'],
            'Admin Buyer payments equal the Vendor Earnings online collections and Buyer fees for the same records.');
        self::assertSame($earnings['buyer_processing_fees_centavos'], $market['buyer_processing_fees']);
        self::assertSame(['GCASH', 'MAYA'], collect($kpis['payment_methods'])->pluck('method')->sort()->values()->all());
        self::assertSame($paid, array_sum(array_column($kpis['payment_methods'], 'amount_centavos')));
        self::assertSame(['ONLINE', 'ONLINE'], array_column($kpis['payment_methods'], 'kind'));
        self::assertSame([1000000, $paid, 0], [array_sum(array_column($kpis['trend'], 'gmv_centavos')), array_sum(array_column($kpis['trend'], 'buyer_payments_centavos')), array_sum(array_column($kpis['trend'], 'buyer_refunds_centavos'))],
            'The marketplace chart adds up to the cards, even with no commission activity yet.');
        self::assertSame(0, collect($kpis['finance'])->firstWhere('key', 'net_collected')['value_centavos'], 'Buyer payments to the Vendor account are never platform-held funds.');
    }

    public function test_publishing_a_statement_emails_one_immutable_private_platform_invoice_with_retry_and_owner_checks(): void
    {
        Queue::fake();
        Mail::fake();
        config()->set('mail.delivery_not_before', null);
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Platform Invoice Hardware');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 1, 0, 5, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        app(StatementService::class)->draftMonthly(CarbonImmutable::now());
        $statement = DB::table('fee_statements')->where('vendor_organization_id', $store->id)->first();
        self::assertNull($statement->issued_invoice_snapshot);
        self::assertSame(0, DB::table('outbox_events')->where('event_type', PlatformFeeInvoiceService::TEMPLATE)->count());
        Mail::assertNotSent(PlatformFeeInvoiceMail::class);

        $reviewer = $this->admin('ADMIN_SUPERADMIN');
        $invoiceUrl = '/api/v1/admin/finance/statements/'.$statement->id.'/invoice';
        $input = ['lock_version' => 1, 'invoice_heading' => 'October commission invoice', 'invoice_message' => 'Thank you for your completed orders. <script>unsafe</script>'];
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->putJson($invoiceUrl, $input, ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->signInAdmin($reviewer);
        $this->putJson($invoiceUrl, $input)->assertUnprocessable();
        $key = (string) Str::uuid7();
        $this->putJson($invoiceUrl, $input, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.lock_version', 2)->assertJsonPath('data.invoice_heading', 'October commission invoice')->assertJsonPath('data.charges_centavos', 20000);
        $this->putJson($invoiceUrl, $input, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.lock_version', 2);
        $this->putJson($invoiceUrl, $input, ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'VERSION_CONFLICT');
        $this->putJson($invoiceUrl, [...$input, 'invoice_message' => str_repeat('x', 1001)], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertNull(DB::table('fee_statements')->where('id', $statement->id)->value('issued_invoice_snapshot'));
        Mail::assertNotSent(PlatformFeeInvoiceMail::class);
        $issued = app(StatementService::class)->approve((string) $statement->id, (int) $reviewer->id, 2);
        $this->putJson($invoiceUrl, [...$input, 'lock_version' => 3], ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict()->assertJsonPath('errors.0.code', 'STATEMENT_NOT_DRAFT');
        self::assertNotNull($issued->issued_invoice_snapshot);
        self::assertSame(0, DB::table('invoice_records')->where('fee_statement_id', $statement->id)->count(), 'Publication captures the source; the worker generates the PDF after commit.');
        $event = DB::table('outbox_events')->where('event_type', PlatformFeeInvoiceService::TEMPLATE)->sole();
        app(OutboxProcessor::class)->process((string) $event->id);
        app(OutboxProcessor::class)->process((string) $event->id);
        $delivery = DB::table('notification_deliveries')->where('template', PlatformFeeInvoiceService::TEMPLATE)->where('channel', 'EMAIL')->sole();
        $notice = DB::table('notifications')->where('id', $delivery->notification_id)->first();
        self::assertSame((int) $owner->id, (int) $notice->user_id);
        self::assertNull(app(PlatformFeeInvoiceService::class)->mail($manager, $notice));
        $mail = app(PlatformFeeInvoiceService::class)->mail($owner, $notice);
        self::assertInstanceOf(PlatformFeeInvoiceMail::class, $mail);
        self::assertSame('Platform Invoice Hardware', $mail->invoice['billing_name']);
        self::assertSame(20000, $mail->invoice['total_centavos']);
        self::assertStringContainsString('Download', $mail->render());
        self::assertStringContainsString('SAMPLE', $mail->render());
        self::assertStringContainsString('/finance/commissions', $mail->render());
        self::assertSame('October commission invoice', $mail->invoice['heading']);
        self::assertSame($input['invoice_message'], $mail->invoice['message']);
        self::assertStringContainsString('October commission invoice', $mail->render());
        self::assertStringNotContainsString('<script>unsafe</script>', $mail->render());
        $record = DB::table('invoice_records')->where('fee_statement_id', $statement->id)->sole();
        $file = DB::table('files')->where('id', $record->file_id)->first();
        self::assertSame(['PLATFORM_SERVICE_INVOICE', 'PLATFORM_SAMPLE', 'TEST', 'PRIVATE', 'FEE_STATEMENT'], [$record->invoice_type, $record->document_origin, $record->environment, $file->visibility, $file->owner_type]);
        $bytes = Storage::disk('local')->get($file->object_key);
        self::assertStringStartsWith('%PDF-', $bytes);
        self::assertSame(hash('sha256', $bytes), $record->content_hash);
        $mail->assertHasAttachedData($bytes, $file->original_name, ['mime' => 'application/pdf']);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['store_name' => 'Renamed after publication']);
        self::assertSame('Platform Invoice Hardware', app(PlatformFeeInvoiceService::class)->mail($owner, $notice)->invoice['billing_name']);
        try {
            DB::transaction(fn () => DB::table('fee_statements')->where('id', $statement->id)->update(['issued_invoice_snapshot' => '{}']));
            self::fail('Published invoice snapshots must be immutable.');
        } catch (QueryException) {
            self::assertSame($issued->issued_invoice_hash, DB::table('fee_statements')->where('id', $statement->id)->value('issued_invoice_hash'));
        }
        Storage::disk('local')->put($file->object_key, 'Corrupt attachment fixture');
        try {
            app(NotificationDelivery::class)->send((string) $delivery->id);
            self::fail('Corrupt attachments must fail closed.');
        } catch (\RuntimeException) {
            self::assertSame('RETRY', DB::table('notification_deliveries')->where('id', $delivery->id)->value('state'));
            Mail::assertNotSent(PlatformFeeInvoiceMail::class);
        }
        Storage::disk('local')->put($file->object_key, $bytes);
        app(NotificationDelivery::class)->send((string) $delivery->id);
        app(NotificationDelivery::class)->send((string) $delivery->id);
        Mail::assertSent(PlatformFeeInvoiceMail::class, 1);
        self::assertSame(1, DB::table('invoice_records')->where('fee_statement_id', $statement->id)->count());
        self::assertSame('SENT', DB::table('notification_deliveries')->where('id', $delivery->id)->value('state'));
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['status' => 'SUSPENDED']);
        self::assertNull(app(PlatformFeeInvoiceService::class)->mail($owner, $notice));
    }

    public function test_commission_transactions_exclude_buyer_pending_and_late_payments_and_use_paid_dates(): void
    {
        Queue::fake();
        [$owner, $assessmentId, $statement, $preparer, $reviewer] = $this->issuedCommission();
        $this->signInStoreMember($owner);
        $attempt = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH', 'amount_centavos' => 10000], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $this->completePayment($attempt['id'])->assertOk();
        $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        DB::table('payments')->where('id', $attempt['id'])->update(['created_at' => '2026-10-31 15:59:00+00', 'paid_at' => '2026-11-02 16:01:00+00']);
        $this->signInAdmin($reviewer);
        $url = '/api/v1/admin/finance/commission-transactions';
        $this->getJson($url.'?from=2026-11-03&to=2026-11-03')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('meta.total', 1)
            ->assertJsonPath('data.0.id', $attempt['id'])->assertJsonPath('data.0.purpose', 'PLATFORM_FEE_PAYMENT')->assertJsonPath('data.0.account_scope', 'PLATFORM_ACCOUNT')
            ->assertJsonPath('data.0.total_centavos', 10000)->assertJsonPath('data.0.evidence_origin', 'SIMULATED');
        $this->getJson($url.'?from=2026-10-31&to=2026-10-31')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson($url.'?page=2')->assertOk()->assertJsonCount(0, 'data')->assertJsonPath('meta.total', 1);
        $this->getJson($url.'?from=invalid')->assertUnprocessable();
        $this->getJson($url.'?status=PAID')->assertOk()->assertJsonPath('meta.total', 1);
        $this->getJson($url.'?status=PAID_REFUNDED')->assertOk()->assertJsonPath('meta.total', 0);
        $this->getJson($url.'?status=PENDING')->assertUnprocessable();
        $request = Request::create('/');
        $request->setUserResolver(fn () => $reviewer);
        self::assertTrue(app(ExportAccess::class)->allows($reviewer, 'TRANSACTION_HISTORY', null));
        $report = app(DocumentSnapshot::class)->capture($request, 'TRANSACTION_HISTORY', null, ['from' => '2026-11-03', 'to' => '2026-11-03', 'status' => 'PAID']);
        self::assertCount(3, $report['rows']);
        self::assertSame('100.00', $report['rows'][2][5]);
        self::assertSame('100.00', $report['rows'][2][7]);
        $empty = app(DocumentSnapshot::class)->capture($request, 'TRANSACTION_HISTORY', null, ['from' => '2026-10-31', 'to' => '2026-10-31']);
        self::assertCount(2, $empty['rows']);
        $adjustmentId = $this->approveReturn($assessmentId, 600000, $preparer, $reviewer);
        $refund = DB::table('refunds')->where('fee_adjustment_id', $adjustmentId)->first();
        $this->getJson($url.'?status=PAID_REFUND_PENDING')->assertOk()->assertJsonPath('meta.total', 1);
        app(RefundService::class)->send((string) $refund->id, (string) Str::uuid7());
        $providerId = (string) DB::table('refunds')->where('id', $refund->id)->value('provider_reference');
        $this->deliverWebhook($this->gateway->settleRefund($providerId), 'commission-filter-refund')->assertOk();
        $eventId = DB::table('webhook_events')->where('provider_event_id', 'wh:commission-filter-refund')->value('id');
        app(XenditWebhookProcessor::class)->process((string) $eventId);
        $this->signInAdmin($reviewer);
        $this->getJson($url.'?status=PAID_PARTIALLY_REFUNDED')->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.net_collected_centavos', 8000);
        $this->getJson($url.'?status=PAID')->assertOk()->assertJsonPath('meta.total', 0);
        DB::table('payments')->where('id', $attempt['id'])->update(['late_capture' => true]);
        $this->getJson($url)->assertOk()->assertJsonPath('meta.total', 0);
        $support = $this->admin('ADMIN_SUPPORT');
        self::assertFalse(app(ExportAccess::class)->allows($support, 'TRANSACTION_HISTORY', null));
        $this->signInAdmin($support);
        $this->getJson($url)->assertForbidden();
        $this->signInStoreMember($owner);
        $this->getJson($url)->assertForbidden();
    }

    public function test_paid_statement_history_filters_before_pagination_and_exports_with_owner_scope(): void
    {
        Queue::fake();
        [$owner, , $statement] = $this->issuedCommission();
        $original = (array) DB::table('fee_statements')->where('id', $statement->id)->first();
        $make = function (string $state, int $version, string $issuedOn = '2026-11-02') use ($original): array {
            $row = $original;
            $row['id'] = (string) Str::uuid7();
            $row['statement_reference'] = 'SAMPLE-HISTORY-'.$version;
            $row['version'] = $version;
            $row['state'] = $state;
            $row['issued_on'] = $issuedOn;
            $row['issued_invoice_snapshot'] = $row['issued_invoice_hash'] = null;
            $row['paid_centavos'] = $state === 'PAID' ? $row['charges_centavos'] - $row['credits_centavos'] : ($state === 'PARTIALLY_PAID' ? 100 : 0);
            $row['outstanding_centavos'] = $row['balance_centavos'] = $row['charges_centavos'] - $row['credits_centavos'] - $row['paid_centavos'];
            if (in_array($state, ['DRAFT', 'VOIDED'], true)) {
                $row['approved_at'] = $row['approved_by_user_id'] = $row['issued_at'] = null;
            }

            return $row;
        };
        for ($index = 2; $index <= 28; $index++) {
            DB::table('fee_statements')->insert($make('PAID', $index));
        }
        DB::table('fee_statements')->insert($make('PAID', 29, '2026-09-30'));
        DB::table('fee_statements')->insert($make('PARTIALLY_PAID', 30));
        DB::table('fee_statements')->insert($make('VOIDED', 31));
        DB::table('fee_statements')->insert($make('DRAFT', 32));
        [$otherStore, $otherOwner] = $this->activeStore('Other History Store', false);
        $foreign = $make('PAID', 33);
        $foreign['vendor_organization_id'] = $otherStore->id;
        DB::table('fee_statements')->insert($foreign);

        $this->signInStoreMember($owner);
        $query = '/api/v1/vendor/finance/transactions?tab=STATEMENTS&statement_state=PAID&from=2026-11-01&to=2026-11-30';
        $first = $this->getJson($query)->assertOk()->assertJsonPath('meta.total', 27)->assertJsonPath('meta.has_more', true)->assertJsonCount(20, 'data')->json('data');
        $second = $this->getJson($query.'&page=2')->assertOk()->assertJsonPath('meta.total', 27)->assertJsonPath('meta.has_more', false)->assertJsonCount(7, 'data')->json('data');
        self::assertSame(['PAID'], collect([...$first, ...$second])->pluck('state')->unique()->all());
        self::assertCount(27, collect([...$first, ...$second])->pluck('id')->unique());
        $this->getJson('/api/v1/vendor/finance/transactions?tab=STATEMENTS&statement_state=NOT_PAID')->assertOk()->assertJsonPath('meta.total', 3);
        $this->getJson('/api/v1/vendor/finance/transactions?tab=STATEMENTS&statement_state=UNKNOWN')->assertUnprocessable();
        $csv = $this->get('/api/v1/vendor/finance/transactions/export?tab=STATEMENTS&statement_state=PAID&from=2026-11-01&to=2026-11-30')->assertOk()->streamedContent();
        self::assertStringContainsString('SAMPLE-HISTORY-2', $csv);
        foreach ([29, 30, 31, 32, 33] as $excluded) {
            self::assertStringNotContainsString('SAMPLE-HISTORY-'.$excluded, $csv);
        }
        $export = $this->postJson('/api/v1/vendor/reports', ['type' => 'TRANSACTION_HISTORY', 'format' => 'CSV', 'purpose' => 'Review paid commission statement history',
            'filters' => ['tab' => 'STATEMENTS', 'statement_state' => 'PAID', 'from' => '2026-11-01', 'to' => '2026-11-30']], ['Idempotency-Key' => (string) Str::uuid7()])->assertAccepted()->json('data');
        app(DocumentExportService::class)->process($export['id']);
        $report = $this->get('/api/v1/vendor/reports/'.$export['id'].'/download')->assertOk()->streamedContent();
        self::assertStringContainsString('SAMPLE-HISTORY-2', $report);
        self::assertStringNotContainsString('SAMPLE-HISTORY-29', $report);
        self::assertStringNotContainsString('SAMPLE-HISTORY-30', $report);
        $this->signInStoreMember($this->teamMember(VendorOrganization::query()->findOrFail($original['vendor_organization_id']), 'STORE_MANAGER'));
        $this->getJson($query)->assertForbidden();
        $this->get('/api/v1/vendor/finance/transactions/export?tab=STATEMENTS&statement_state=PAID')->assertForbidden();
        $this->signInStoreMember($otherOwner);
        $this->getJson($query)->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.id', $foreign['id']);
    }

    public function test_monthly_statement_is_drafted_approved_by_a_reviewer_and_paid_by_the_owner_in_installments(): void
    {
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Statement Hardware');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
        self::assertSame(20000, app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7()), 'EARNED = money(E × 0.02) only at COMPLETED.');

        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 1, 0, 5, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        self::assertSame(1, app(StatementService::class)->draftMonthly(CarbonImmutable::now()));
        self::assertSame(0, app(StatementService::class)->draftMonthly(CarbonImmutable::now()), 'Drafting is idempotent.');
        $statement = DB::table('fee_statements')->where('vendor_organization_id', $store->id)->first();
        self::assertSame(['DRAFT', 20000, '2026-10-01', '2026-10-31'], [$statement->state, (int) $statement->outstanding_centavos, (string) $statement->period_start, (string) $statement->period_end]);

        $support = $this->admin('ADMIN_SUPPORT');
        $this->signInAdmin($support);
        $this->postJson('/api/v1/admin/finance/statements/'.$statement->id.'/approve', ['lock_version' => 1])->assertForbidden();
        $reviewer = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($reviewer);
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 2, 9, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        $this->postJson('/api/v1/admin/finance/statements/'.$statement->id.'/approve', ['lock_version' => 1])->assertOk()->assertJsonPath('data.state', 'ISSUED')->assertJsonPath('data.due_on', '2026-11-15');

        // A Manager cannot see or pay protected fee statements.
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendor/finance/statements/'.$statement->id)->assertForbidden();
        $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();

        $this->signInStoreMember($owner);
        $view = $this->getJson('/api/v1/vendor/finance/statements/'.$statement->id)->assertOk()->json('data');
        $export = $this->postJson('/api/v1/vendor/reports', ['type' => 'FEE_STATEMENT', 'resource_id' => $statement->id, 'format' => 'PDF', 'purpose' => 'Review monthly platform fee statement'], ['Idempotency-Key' => (string) Str::uuid7()])->assertAccepted()->json('data');
        app(DocumentExportService::class)->process($export['id']);
        self::assertStringStartsWith('%PDF-', $this->get('/api/v1/vendor/reports/'.$export['id'].'/download')->assertOk()->streamedContent());
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendor/reports/'.$export['id'].'/download')->assertForbidden();
        $this->signInStoreMember($owner);
        self::assertSame(0, collect($view['channels'])->firstWhere('code', 'GCASH')['fee_centavos'], 'The platform absorbs its own bill processing charge.');
        $first = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH', 'amount_centavos' => 5000], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $issuedNotice = DB::table('notifications')->where('user_id', $owner->id)->where('resource_type', 'FEE_STATEMENT')->where('resource_id', $statement->id)->sole();
        self::assertContains($issuedNotice->id, array_column($this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.notices'), 'id'), 'A pending payment does not clear the statement notice.');
        $payment = DB::table('payments')->where('id', $first['id'])->first();
        self::assertSame(['PLATFORM_FEE_PAYMENT', 'PLATFORM_ACCOUNT', null, 0, 5000], [$payment->purpose, $payment->account_scope, $payment->provider_account_id, (int) $payment->processing_fee_centavos, (int) $payment->total_centavos]);
        self::assertEqualsWithDelta(45, CarbonImmutable::parse((string) $payment->created_at)->diffInMinutes(CarbonImmutable::parse((string) $payment->expires_at)), 0.1);
        $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ATTEMPT_IN_PROGRESS');
        $this->completePayment($first['id'])->assertOk();
        self::assertSame(['PARTIALLY_PAID', 15000], [(string) DB::table('fee_statements')->where('id', $statement->id)->value('state'), (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos')]);
        self::assertContains($issuedNotice->id, array_column($this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.notices'), 'id'), 'A partial payment keeps the statement notice visible.');

        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 15, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        self::assertSame(1, app(StatementService::class)->overdueScan(CarbonImmutable::now()));
        CarbonImmutable::setTestNow(CarbonImmutable::now()->addDays(7));
        Carbon::setTestNow(CarbonImmutable::now());
        self::assertSame(1, app(StatementService::class)->overdueScan(CarbonImmutable::now()));
        $statementNotices = DB::table('notifications')->where('user_id', $owner->id)->where('resource_type', 'FEE_STATEMENT')->where('resource_id', $statement->id)->get();
        self::assertCount(3, $statementNotices);
        $this->signInStoreMember($owner);
        $beforePayment = array_column($this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.notices'), 'id');
        foreach ($statementNotices as $notice) {
            self::assertContains($notice->id, $beforePayment, 'Issued, due and overdue notices remain visible while money is owed.');
        }

        $second = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'CARDS'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $this->completePayment($second['id'])->assertOk();
        self::assertSame(['PAID', 0, 20000], [(string) DB::table('fee_statements')->where('id', $statement->id)->value('state'), (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos'),
            (int) DB::table('fee_payment_allocations')->where('fee_statement_id', $statement->id)->sum('amount_centavos')]);
        $afterPayment = array_column($this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.notices'), 'id');
        foreach ($statementNotices as $notice) {
            self::assertNotContains($notice->id, $afterPayment, 'Fully paid statements no longer appear in required finance notices.');
            $this->assertDatabaseHas('notifications', ['id' => $notice->id, 'body' => $notice->body, 'read_at' => $notice->read_at]);
        }
        self::assertSame(0, DB::table('remittance_assessments')->whereIn('payment_id', [$first['id'], $second['id']])->count(), 'A platform fee receipt is never a merchant remittance.');
        foreach (DB::table('financial_posting_batches')->where('ledger', 'PLATFORM_FEE')->get() as $batch) {
            self::assertSame((int) $batch->debit_total_centavos, (int) $batch->credit_total_centavos);
        }
        self::assertSame(20000, (int) DB::table('financial_ledger_entries')->where('ledger', 'PLATFORM_FEE')->where('account_code', 'FEE_RECEIVABLE')->where('direction', 'CREDIT')->sum('amount_centavos'));
        self::assertGreaterThan(0, (int) DB::table('financial_ledger_entries')->where('account_code', 'PLATFORM_PROCESSING_EXPENSE')->sum('amount_centavos'));
        self::assertSame(1, DB::table('notifications')->where('user_id', $owner->id)->where('category', FinanceNotifier::MANDATORY)->where('title', 'like', '%issued%')->count());
        self::assertSame(0, DB::table('notifications')->where('user_id', $manager->id)->where('category', 'like', 'FINANCE%')->count());
    }

    public function test_paid_statement_notices_are_filtered_before_the_limit_without_hiding_other_finance_notices(): void
    {
        Queue::fake();
        [$owner, , $statement] = $this->issuedCommission();
        $paid = (array) DB::table('fee_statements')->where('id', $statement->id)->sole();
        $paid['id'] = (string) Str::uuid7();
        $paid['statement_reference'] = 'SAMPLE-PAID-NOTICES';
        $paid['version'] = 2;
        $paid['state'] = 'PAID';
        $paid['paid_centavos'] = $paid['charges_centavos'] - $paid['credits_centavos'];
        $paid['outstanding_centavos'] = $paid['balance_centavos'] = 0;
        $paid['issued_invoice_snapshot'] = $paid['issued_invoice_hash'] = null;
        DB::table('fee_statements')->insert($paid);

        $notifier = app(FinanceNotifier::class);
        $notifier->owner((string) $paid['vendor_organization_id'], 'Withholding status notice', 'This notice remains required.', true, 'VENDOR_ORGANIZATION', (string) $paid['vendor_organization_id']);
        $notifier->owner((string) $paid['vendor_organization_id'], 'Fee credit notice', 'This advisory remains available.', false, 'FEE_ADJUSTMENT', null);
        $retained = DB::table('notifications')->where('user_id', $owner->id)->whereIn('category', [FinanceNotifier::MANDATORY, FinanceNotifier::ADVISORY])->pluck('id')->all();
        self::assertCount(3, $retained);
        CarbonImmutable::setTestNow(CarbonImmutable::now()->addMinute());
        Carbon::setTestNow(CarbonImmutable::now());
        for ($index = 0; $index < 12; $index++) {
            $notifier->owner((string) $paid['vendor_organization_id'], 'Historical paid statement notice '.$index, 'Retained in notification history.', true, 'FEE_STATEMENT', $paid['id']);
        }

        $this->signInStoreMember($owner);
        $visible = array_column($this->getJson('/api/v1/vendor/finance')->assertOk()->json('data.notices'), 'id');
        self::assertEqualsCanonicalizing($retained, $visible, 'Paid-statement notices cannot crowd out unpaid statements or unrelated mandatory/advisory notices.');
        self::assertSame(12, DB::table('notifications')->where('resource_type', 'FEE_STATEMENT')->where('resource_id', $paid['id'])->count());
    }

    public function test_admin_fee_credit_needs_a_different_approver_and_the_finance_queue_is_permissioned(): void
    {
        [, , $buyer, $orderId] = $this->awaitingPayment('Credit Hardware');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'], 1)->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'payment_state' => 'PAID', 'closed_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
        $assessmentId = (string) DB::table('fee_assessments')->where('order_id', $orderId)->value('id');

        $preparer = $this->admin('ADMIN_SUPERADMIN');
        $approver = $this->admin('ADMIN_SUPERADMIN');
        $support = $this->admin('ADMIN_SUPPORT');
        $this->signInAdmin($support);
        $this->getJson('/api/v1/admin/finance/review-items')->assertForbidden();
        $this->getJson('/api/v1/admin/finance/payments')->assertForbidden();

        $this->signInAdmin($preparer);
        $queue = $this->getJson('/api/v1/admin/finance/review-items?kind=PAYMENT_MISMATCH')->assertOk()->json('data');
        self::assertSame('AMOUNT_MISMATCH', $queue[0]['reason_code']);
        $this->getJson('/api/v1/admin/finance/channel-fees')->assertOk()->assertJsonCount(9, 'data');
        $proposal = (string) $this->postJson('/api/v1/admin/finance/fee-credits', ['fee_assessment_id' => $assessmentId, 'returned_exclusive_centavos' => 200000, 'reason' => 'Approved return of damaged blocks after completion.'])
            ->assertCreated()->json('data.proposal_id');
        $this->postJson('/api/v1/admin/finance/fee-credits/'.$proposal.'/approve')->assertForbidden()->assertJsonPath('errors.0.code', 'PREPARER_REVIEWER_SAME');
        $this->signInAdmin($approver);
        $adjustment = (string) $this->postJson('/api/v1/admin/finance/fee-credits/'.$proposal.'/approve')->assertOk()->json('data.fee_adjustment_id');
        $row = DB::table('fee_adjustments')->where('id', $adjustment)->first();
        self::assertSame([4000, 20000, 16000], [(int) $row->amount_centavos, (int) $row->target_fee_before_centavos, (int) $row->target_fee_after_centavos]);
        self::assertSame('PARTIALLY_CREDITED', DB::table('fee_assessments')->where('id', $assessmentId)->value('credited_state'));
        self::assertSame(20000, (int) DB::table('fee_assessments')->where('id', $assessmentId)->value('earned_centavos'), 'A credit never rewrites the earned source amount.');
    }

    public function test_partial_and_full_credits_reduce_original_overdue_debt_and_refund_only_the_collected_excess(): void
    {
        [$owner, $assessmentId, $statement, $preparer, $approver] = $this->issuedCommission();
        $this->signInStoreMember($owner);
        $payment = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH', 'amount_centavos' => 5000], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $this->completePayment($payment['id'])->assertOk();
        $this->completePayment($payment['id'])->assertOk();
        self::assertSame(1, DB::table('fee_payment_allocations')->where('payment_id', $payment['id'])->count());
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 16, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        $this->signInAdmin($approver);
        $this->getJson('/api/v1/admin/finance/statements?overdue=true')->assertOk()->assertJsonPath('data.0.outstanding_centavos', 15000);
        $this->getJson('/api/v1/admin/finance/statements?overdue=true&state=DRAFT')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/admin/finance/statements?overdue=invalid')->assertStatus(422);

        $this->approveReturn($assessmentId, 200000, $preparer, $approver);
        $this->getJson('/api/v1/admin/finance/statements?overdue=true')->assertOk()->assertJsonPath('data.0.outstanding_centavos', 11000)->assertJsonPath('data.0.credits_centavos', 4000)->assertJsonPath('data.0.paid_centavos', 5000);
        $all = $this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data');
        $values = collect($all['finance'])->pluck('value_centavos', 'key');
        self::assertSame([20000, 4000, 16000, 5000, 11000, 11000, 0], [$values['earned_commission'], $values['fee_credits'], $values['net_commission'], $values['collected'], $values['pending_commissions'], $values['overdue'], $values['refunded_commissions']]);
        self::assertSame(20000, array_sum(array_column($all['trend'], 'earned_centavos')));
        self::assertSame($values['net_platform_earnings'], array_sum(array_column($all['trend'], 'net_earnings_centavos')));
        $november = $this->getJson('/api/v1/admin/finance/kpis?from=2026-11-01&to=2026-11-30')->assertOk()->json('data');
        self::assertSame(-4000, collect($november['finance'])->firstWhere('key', 'net_commission')['value_centavos']);
        self::assertSame(['DAY', 30, -4000], [$november['trend_granularity'], count($november['trend']), array_sum(array_map(static fn (array $day): int => $day['earned_centavos'] - $day['credits_centavos'], $november['trend']))],
            'A short range is charted by day, with every day present so the axis stays even.');
        self::assertSame('DAY', $all['trend_granularity']);
        $year = $this->getJson('/api/v1/admin/finance/kpis?from=2026-01-01&to=2026-11-30')->assertOk()->json('data');
        self::assertSame('MONTH', $year['trend_granularity']);
        self::assertSame(20000, array_sum(array_column($year['trend'], 'earned_centavos')));
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/finance/statements/'.$statement->id)->assertOk()->assertJsonPath('data.outstanding_centavos', 11000)->assertJsonPath('data.due_on', '2026-11-15');
        $this->getJson('/api/v1/vendor/finance/earnings')->assertOk()->assertJsonPath('data.earned_commission_centavos', 16000);
        $this->getJson('/api/v1/vendor/finance/earnings?from=2026-11-01&to=2026-11-30')->assertOk()->assertJsonPath('data.earned_commission_centavos', -4000);

        $adjustmentId = $this->approveReturn($assessmentId, 1000000, $preparer, $approver);
        $this->getJson('/api/v1/admin/finance/statements?overdue=true')->assertOk()->assertJsonCount(0, 'data');
        $refund = DB::table('refunds')->where('fee_adjustment_id', $adjustmentId)->first();
        self::assertSame(['PLATFORM_FEE', 5000, $payment['id']], [$refund->target_type, (int) $refund->amount_centavos, $refund->source_payment_id]);
        $this->getJson('/api/v1/admin/finance/kpis')->assertOk()->assertJsonPath('data.label', 'Recorded transactions');
        $this->confirmFeeRefund($refund);
        $this->signInAdmin($approver);
        $values = collect($this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data.finance'))->pluck('value_centavos', 'key');
        self::assertSame([0, 0, 5000, 0, 0], [$values['net_commission'], $values['platform_revenue'], $values['refunded_commissions'], $values['net_collected'], $values['pending_commissions']]);
        self::assertLessThan(0, $values['net_platform_earnings'], 'Recorded nonreturnable platform processing costs remain expenses after a full reversal.');
        $this->getJson('/api/v1/admin/finance/payments?purpose=PLATFORM_FEE_PAYMENT')->assertOk()->assertJsonPath('data.0.status', 'PAID')->assertJsonPath('data.0.refunded_centavos', 5000)->assertJsonPath('data.0.net_collected_centavos', 0);
        self::assertSame(0, app(StatementService::class)->draftMonthly(CarbonImmutable::create(2026, 12, 1, 0, 5, 0, 'Asia/Manila')), 'A credited original bill is never credited again on another statement.');
    }

    public function test_credit_on_a_fully_paid_statement_preserves_payments_and_counts_confirmed_refunds_once(): void
    {
        [$owner, $assessmentId, $statement, $preparer, $approver] = $this->issuedCommission();
        $this->signInStoreMember($owner);
        $payment = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $this->completePayment($payment['id'])->assertOk();
        $adjustment = $this->approveReturn($assessmentId, 200000, $preparer, $approver);
        $refund = DB::table('refunds')->where('fee_adjustment_id', $adjustment)->first();
        self::assertSame(4000, (int) $refund->amount_centavos);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/finance/statements/'.$statement->id)->assertOk()->assertJsonPath('data.paid_centavos', 20000)->assertJsonPath('data.credits_centavos', 4000)->assertJsonPath('data.outstanding_centavos', 0);
        $this->signInAdmin($approver);
        $values = collect($this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data.finance'))->pluck('value_centavos', 'key');
        self::assertSame([16000, 20000, 0], [$values['platform_revenue'], $values['collected'], $values['refunded_commissions']], 'An approved credit reverses earnings before cash refund success.');
        $this->confirmFeeRefund($refund);
        $this->signInAdmin($approver);
        $values = collect($this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data.finance'))->pluck('value_centavos', 'key');
        self::assertSame([16000, 4000, 16000], [$values['platform_revenue'], $values['refunded_commissions'], $values['net_collected']], 'Refund settlement never reverses earned revenue a second time.');
    }

    public function test_historical_unallocated_credit_repair_is_idempotent_and_keeps_the_original_records(): void
    {
        [, $assessmentId, $statement, $preparer, $approver] = $this->issuedCommission();
        $id = (string) Str::uuid7();
        DB::transaction(function () use ($id, $assessmentId, $preparer, $approver): void {
            DB::table('fee_adjustments')->insert(['id' => $id, 'fee_assessment_id' => $assessmentId, 'kind' => 'CREDIT', 'amount_centavos' => 4000,
                'target_fee_before_centavos' => 20000, 'target_fee_after_centavos' => 16000, 'reason' => 'Previously approved return', 'prepared_by_user_id' => $preparer->id,
                'approved_by_user_id' => $approver->id, 'approved_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('fee_assessments')->where('id', $assessmentId)->update(['credited_centavos' => 4000, 'credited_state' => 'PARTIALLY_CREDITED']);
            app(FinancialLedgerService::class)->post('PLATFORM_FEE', 'FEE_CREDIT', 'PLATFORM_FEE:CREDIT:'.$id, [
                FinancialLedgerService::debit('FEE_REVENUE', 4000, 'FEE_ADJUSTMENT', $id), FinancialLedgerService::credit('FEE_RECEIVABLE', 4000, 'FEE_ADJUSTMENT', $id),
            ], (string) Str::uuid7());
        });
        app(StatementService::class)->synchronizeCredits((string) Str::uuid7());
        app(StatementService::class)->synchronizeCredits((string) Str::uuid7());
        self::assertSame(16000, (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos'));
        self::assertSame(1, DB::table('fee_statement_lines')->where('fee_adjustment_id', $id)->count());
        self::assertSame(20000, (int) DB::table('fee_assessments')->where('id', $assessmentId)->value('earned_centavos'));
        self::assertSame(1, DB::table('financial_posting_batches')->where('source_event_key', 'PLATFORM_FEE:CREDIT:'.$id)->count());
    }

    public function test_historical_credit_carried_to_another_bill_is_relocated_without_deleting_its_source_line(): void
    {
        [, $assessmentId, $statement, $preparer, $approver] = $this->issuedCommission();
        $adjustmentId = (string) Str::uuid7();
        $laterId = (string) Str::uuid7();
        $lineId = (string) Str::uuid7();
        $later = (array) DB::table('fee_statements')->where('id', $statement->id)->first();
        $later = array_replace($later, ['id' => $laterId, 'period_start' => '2026-11-01', 'period_end' => '2026-11-30', 'statement_reference' => 'SAMPLE-CARRIED-CREDIT',
            'charges_centavos' => 10000, 'credits_centavos' => 4000, 'paid_centavos' => 0, 'outstanding_centavos' => 6000, 'balance_centavos' => 6000]);
        DB::table('fee_statements')->insert($later);
        DB::table('fee_adjustments')->insert(['id' => $adjustmentId, 'fee_assessment_id' => $assessmentId, 'kind' => 'CREDIT', 'amount_centavos' => 4000,
            'target_fee_before_centavos' => 20000, 'target_fee_after_centavos' => 16000, 'reason' => 'Historic return credit', 'prepared_by_user_id' => $preparer->id,
            'approved_by_user_id' => $approver->id, 'approved_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('fee_statement_lines')->insert(['id' => $lineId, 'fee_statement_id' => $laterId, 'fee_adjustment_id' => $adjustmentId, 'line_type' => 'CREDIT', 'amount_centavos' => 4000,
            'description' => 'Historic credit on next monthly statement', 'created_at' => now(), 'updated_at' => now()]);
        app(StatementService::class)->synchronizeCredits((string) Str::uuid7());
        app(StatementService::class)->synchronizeCredits((string) Str::uuid7());
        self::assertSame(16000, (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos'));
        self::assertSame(10000, (int) DB::table('fee_statements')->where('id', $laterId)->value('outstanding_centavos'));
        self::assertSame($laterId, DB::table('fee_statement_lines')->where('id', $lineId)->value('fee_statement_id'));
        self::assertSame(2, DB::table('fee_statement_lines')->where('corrects_line_id', $lineId)->count(), 'One reversal and one transfer preserve the original line and consume the credit exactly once.');
    }

    public function test_commercial_commission_publishing_is_authorized_versioned_and_idempotent(): void
    {
        [$store, $owner] = $this->pickupStore('Commission Policy Notice Store');
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/admin/finance/commission-policies')->assertForbidden();
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 325, 'expected_version' => 1, 'reason' => 'Commercial rate review'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->getJson('/api/v1/admin/finance/commission-policies')->assertOk()->assertJsonPath('data.current.commission_basis_points', 200)->assertJsonPath('data.can_manage', true);
        $key = (string) Str::uuid7();
        $input = ['commission_basis_points' => 325, 'expected_version' => 1, 'reason' => 'Commercial rate review'];
        $policy = $this->postJson('/api/v1/admin/finance/commission-policies', $input, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.rate_label', '3.25%')->json('data');
        $this->postJson('/api/v1/admin/finance/commission-policies', $input, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.id', $policy['id']);
        $this->postJson('/api/v1/admin/finance/commission-policies', array_replace($input, ['commission_basis_points' => 400]), ['Idempotency-Key' => $key])->assertConflict();
        $this->postJson('/api/v1/admin/finance/commission-policies', array_replace($input, ['commission_basis_points' => 400]), ['Idempotency-Key' => (string) Str::uuid7()])->assertConflict();
        self::assertSame(2, CommissionPolicyService::policies()->count());
        self::assertSame(1, DB::table('audit_logs')->where('action', 'COMMISSION_POLICY_PUBLISHED')->count());
        self::assertSame(1, DB::table('commission_email_events')->where('vendor_organization_id', $store->id)->where('subject_id', $policy['id'])->count());
        $terms = DB::table('agreement_versions')->where('id', $policy['agreement_version_id'])->first();
        self::assertSame(hash('sha256', $terms->published_content), $terms->content_hash);
        self::assertStringContainsString('3.25%', $terms->published_content);
        foreach (['fee_policy_versions' => $policy['id'], 'agreement_versions' => $policy['agreement_version_id']] as $table => $id) {
            try {
                DB::transaction(fn () => DB::table($table)->where('id', $id)->update(['updated_at' => now()->addSecond()]));
                self::fail('Published policy and terms must be immutable.');
            } catch (QueryException $exception) {
                self::assertStringContainsString('immutable', $exception->getMessage());
            }
        }
        self::assertSame(200, (int) CommissionPolicyService::policies()->where('version', 1)->value('commission_basis_points'));
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/onboarding')->assertOk()->assertJsonPath('data.verification.commission_terms.agreement.id', $policy['agreement_version_id'])
            ->assertJsonPath('data.verification.commission_terms.agreement.content_available', true)->assertJsonPath('data.verification.commission_terms.accepted', false);
        $this->getJson('/api/v1/vendor/finance/commissions')->assertOk()->assertJsonPath('data.current_policy.commission_basis_points', 325);
    }

    public function test_scheduled_commission_rates_do_not_change_the_current_rate_and_invalid_rates_do_not_publish(): void
    {
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        foreach ([-1, 10001, 2.5] as $rate) {
            $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => $rate, 'expected_version' => 1, 'reason' => 'Invalid commercial rate'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        }
        $future = CarbonImmutable::now()->addDay()->startOfMinute();
        $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 350, 'expected_version' => 1, 'effective_from' => $future->toIso8601String(), 'reason' => 'Scheduled commercial rate'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.status', 'SCHEDULED');
        $this->getJson('/api/v1/admin/finance/commission-policies')->assertOk()->assertJsonPath('data.current.commission_basis_points', 200)->assertJsonPath('data.next.commission_basis_points', 350);
        $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 400, 'expected_version' => 2, 'effective_from' => CarbonImmutable::now()->subDay()->toIso8601String(), 'reason' => 'Attempt backdated rate'], ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        self::assertSame(2, CommissionPolicyService::policies()->count());
        CarbonImmutable::setTestNow($future->addMinute());
        Carbon::setTestNow(CarbonImmutable::now());
        self::assertSame(350, (int) CommissionPolicyService::current()->commission_basis_points);
        self::assertNull(CommissionPolicyService::next());
    }

    public function test_publishing_a_commercial_rate_requires_recent_authentication_and_does_not_write_on_failure(): void
    {
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        DB::table('auth_sessions')->where('user_id', $admin->id)->update(['reauthenticated_at' => null]);
        $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 300, 'expected_version' => 1, 'reason' => 'Protected commercial rate review'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        self::assertSame(1, CommissionPolicyService::policies()->count());
        self::assertSame(0, DB::table('audit_logs')->where('action', 'COMMISSION_POLICY_PUBLISHED')->count());
    }

    public function test_mixed_rate_monthly_billing_keeps_original_rates_and_return_credits(): void
    {
        [$store, $owner, , $oldOrder] = $this->awaitingPayment('Mixed Commission Rate Store');
        $listing = (string) DB::table('vendor_listings')->where('vendor_organization_id', $store->id)->value('id');
        $oldAssessment = DB::table('fee_assessments')->where('order_id', $oldOrder)->first();
        [, $newOrder] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '1']]);
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $policy = $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 325, 'expected_version' => 1, 'reason' => 'New commercial commission rate'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
        $this->confirmOrder($owner, $newOrder)->assertConflict()->assertJsonPath('errors.0.code', 'COMMISSION_TERMS_ACCEPTANCE_REQUIRED');
        self::assertSame(0, DB::table('fee_assessments')->where('order_id', $newOrder)->count());
        $this->signInStoreMember($owner);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['business_type' => 'SOLE_PROPRIETORSHIP']);
        $snapshot = $this->getJson('/api/v1/vendors/onboarding')->assertOk()->json('data');
        $this->postJson('/api/v1/vendors/onboarding/verification/commission', ['organization_lock_version' => $snapshot['lock_version'], 'agreement_version_id' => $policy['agreement_version_id'], 'accepted' => true], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        // This commerce fixture omits onboarding media; restore its synthetic public-profile readiness.
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['status' => 'COMPLETED']);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['store_setup_status' => 'COMPLETED']);
        $this->confirmOrder($owner, $newOrder)->assertOk();
        $newAssessment = DB::table('fee_assessments')->where('order_id', $newOrder)->first();
        self::assertSame([200, 20000, 325, 3250], [(int) $oldAssessment->commission_basis_points, (int) $oldAssessment->earned_target_centavos, (int) $newAssessment->commission_basis_points, (int) $newAssessment->earned_target_centavos]);
        foreach ([$oldOrder, $newOrder] as $id) {
            DB::table('orders')->where('id', $id)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
            app(FeeAssessmentService::class)->earnOnCompletion($id, (string) Str::uuid7());
            app(FeeAssessmentService::class)->earnOnCompletion($id, (string) Str::uuid7());
        }
        $this->getJson('/api/v1/vendor/finance/commissions')->assertOk()->assertJsonPath('data.summary.earned_centavos', 23250)->assertJsonPath('data.summary.unbilled_centavos', 23250);
        [, $otherOwner] = $this->activeStore('Unrelated Commission Store', false);
        $this->signInStoreMember($otherOwner);
        $this->getJson('/api/v1/vendor/finance/commissions')->assertOk()->assertJsonPath('data.summary.earned_centavos', 0)->assertJsonCount(0, 'data.assessments');
        $this->signInStoreMember($owner);
        $nextMonth = CarbonImmutable::now('Asia/Manila')->startOfMonth()->addMonth()->addDay();
        self::assertSame(1, app(StatementService::class)->draftMonthly($nextMonth));
        $statement = DB::table('fee_statements')->where('vendor_organization_id', $store->id)->first();
        self::assertSame(23250, (int) $statement->charges_centavos);
        self::assertNull($statement->fee_policy_version_id, 'A mixed-rate bill must not claim one policy for all orders.');
        self::assertSame(['Earned 2.00% commission on completed order', 'Earned 3.25% commission on completed order'], DB::table('fee_statement_lines')->where('fee_statement_id', $statement->id)->orderBy('description')->pluck('description')->all());
        app(StatementService::class)->issuePending();
        $snapshot = json_decode((string) DB::table('fee_statements')->where('id', $statement->id)->value('issued_invoice_snapshot'), true, flags: JSON_THROW_ON_ERROR);
        $mail = new PlatformFeeInvoiceMail($snapshot, '%PDF-test-fixture', 'sample.pdf');
        self::assertStringContainsString('2.00%', $mail->render());
        self::assertStringContainsString('3.25%', $mail->render());
        self::assertStringContainsString('P232.50', $mail->envelope()->subject);
        $this->signInAdmin($admin);
        $detail = $this->getJson('/api/v1/admin/finance/statements/'.$statement->id)->assertOk()->json('data');
        self::assertCount(2, $detail['rate_breakdown']);
        self::assertSame(23250, array_sum(array_column($detail['rate_breakdown'], 'commission_centavos')));
        $preparer = $admin;
        $approver = $this->admin('ADMIN_SUPERADMIN');
        $this->approveReturn((string) $oldAssessment->id, 200000, $preparer, $approver);
        self::assertSame(4000, (int) DB::table('fee_assessments')->where('id', $oldAssessment->id)->value('credited_centavos'));
        $this->approveReturn((string) $newAssessment->id, 20000, $preparer, $approver);
        self::assertSame(650, (int) DB::table('fee_assessments')->where('id', $newAssessment->id)->value('credited_centavos'));
    }

    /** @return array{User, string, object, User, User} */
    public function test_monthly_bills_are_issued_automatically_for_each_vendor_once_with_frozen_invoices(): void
    {
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        foreach (['Automatic Billing A', 'Automatic Billing B'] as $name) {
            [, , $buyer, $orderId] = $this->awaitingPayment($name);
            $attempt = $this->startPayment($buyer, $orderId);
            $this->completePayment($attempt['id'])->assertOk();
            DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
            app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
        }
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 1, 0, 5, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        $this->artisan('materyalph:finance-process-commissions')->assertExitCode(0);
        self::assertSame(2, DB::table('fee_statements')->count());
        foreach (DB::table('fee_statements')->get() as $statement) {
            self::assertSame(['ISSUED', 'SYSTEM', null, '2026-11-15'], [$statement->state, $statement->issuance_origin, $statement->approved_by_user_id, (string) $statement->due_on]);
            self::assertNotNull($statement->issued_invoice_snapshot);
            self::assertNotNull($statement->issued_invoice_hash);
            self::assertSame(20000, (int) $statement->outstanding_centavos);
        }
        $snapshots = DB::table('fee_statements')->pluck('issued_invoice_hash', 'id')->all();
        $this->artisan('materyalph:finance-draft-statements')->assertExitCode(0);
        self::assertSame(0, app(StatementService::class)->issuePending());
        self::assertSame($snapshots, DB::table('fee_statements')->pluck('issued_invoice_hash', 'id')->all());
        self::assertSame(2, DB::table('fee_statements')->count());
        self::assertSame(2, DB::table('notifications')->where('resource_type', 'FEE_STATEMENT')->where('category', 'FINANCE_MANDATORY')->count(), 'Retries do not duplicate Owner invoice notifications.');
    }

    public function test_rate_decrease_queues_one_verified_owner_email_per_vendor_and_public_terms_follow_policy(): void
    {
        Queue::fake();
        Mail::fake();
        config()->set('mail.delivery_not_before', null);
        config()->set('finance.commission_min_notice_days', 30);
        [$store, $owner] = $this->activeStore('Rate Notice Store', false);
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        [$unverified, $unverifiedOwner] = $this->activeStore('Unverified Rate Notice Store', false);
        DB::table('users')->where('id', $unverifiedOwner->id)->update(['email_verified_at' => null]);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $input = ['commission_basis_points' => 150, 'expected_version' => 1, 'reason' => 'Internal commercial review', 'vendor_message' => 'A lower rate for future transactions.'];
        $key = (string) Str::uuid7();
        $policy = $this->postJson('/api/v1/admin/finance/commission-policies', $input, ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.status', 'CURRENT')
            ->assertJsonPath('data.delivery.total', 2)->assertJsonPath('data.delivery.blocked', 1)->json('data');
        $this->postJson('/api/v1/admin/finance/commission-policies', $input, ['Idempotency-Key' => $key])->assertOk();
        self::assertSame(2, DB::table('commission_email_events')->where('subject_id', $policy['id'])->count());
        self::assertSame(0, DB::table('notifications')->where('user_id', $manager->id)->count());
        self::assertSame(1, DB::table('notifications')->where('user_id', $owner->id)->count());
        $public = $this->getJson('/api/v1/commission-policy')->assertOk()->assertHeader('Cache-Control', 'no-store, private')->assertJsonPath('data.current.rate_label', '1.50%')->json('data.current');
        self::assertArrayNotHasKey('reason', $public);
        self::assertArrayNotHasKey('delivery', $public);
        self::assertStringContainsString('no Admin approval', $public['terms_content']);
        self::assertSame(hash('sha256', $public['terms_content']), DB::table('agreement_versions')->where('id', $public['agreement_version_id'])->value('content_hash'));
        $event = DB::table('outbox_events')->where('event_type', 'COMMISSION_POLICY')->sole();
        app(OutboxProcessor::class)->process((string) $event->id);
        app(OutboxProcessor::class)->process((string) $event->id);
        $delivery = DB::table('notification_deliveries')->where('template', 'COMMISSION_POLICY')->where('channel', 'EMAIL')->sole();
        app(NotificationDelivery::class)->send((string) $delivery->id);
        app(NotificationDelivery::class)->send((string) $delivery->id);
        Mail::assertSent(CommissionPolicyMail::class, 1);
        Mail::assertSent(CommissionPolicyMail::class, fn (CommissionPolicyMail $mail): bool => str_contains($mail->render(), 'P150.00') && str_contains($mail->render(), 'A lower rate') && str_contains($mail->render(), '/finance/commissions') && ! str_contains($mail->render(), 'Internal commercial review'));
        self::assertSame(1, app(CommissionEmails::class)->summary('POLICY', $policy['id'])['sent']);
        self::assertSame(0, DB::table('fee_statements')->where('vendor_organization_id', $unverified->id)->count());
    }

    public function test_notice_rule_scheduled_activation_and_reasoned_override_are_authoritative(): void
    {
        Queue::fake();
        config()->set('finance.commission_min_notice_days', 30);
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 1, 8, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        $this->activeStore('Scheduled Notice Store', false);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $input = ['commission_basis_points' => 300, 'expected_version' => 1, 'reason' => 'Scheduled commercial review'];
        $this->postJson('/api/v1/admin/finance/commission-policies', $input, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable()->assertJsonPath('errors.0.code', 'COMMISSION_NOTICE_REQUIRED');
        $future = CarbonImmutable::now()->addDays(31);
        $policy = $this->postJson('/api/v1/admin/finance/commission-policies', $input + ['effective_from' => $future->toIso8601String()], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.status', 'SCHEDULED')->json('data');
        self::assertSame(1, DB::table('commission_email_events')->where('subject_id', $policy['id'])->count(), 'Scheduled notices are recorded at publish, without waiting for activation.');
        $this->getJson('/api/v1/commission-policy')->assertOk()->assertJsonPath('data.current.rate_label', '2.00%')->assertJsonPath('data.next.rate_label', '3.00%');
        CarbonImmutable::setTestNow($future);
        Carbon::setTestNow(CarbonImmutable::now());
        $this->getJson('/api/v1/commission-policy')->assertOk()->assertJsonPath('data.current.rate_label', '3.00%')->assertJsonPath('data.next', null);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $override = ['commission_basis_points' => 350, 'expected_version' => 2, 'reason' => 'Urgent commercial review', 'notice_override' => true];
        $this->postJson('/api/v1/admin/finance/commission-policies', $override, ['Idempotency-Key' => (string) Str::uuid7()])->assertUnprocessable();
        $this->postJson('/api/v1/admin/finance/commission-policies', $override + ['notice_override_reason' => 'Explicit exceptional notice decision'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.notice_hours', 0)->assertJsonPath('data.notice_override_reason', 'Explicit exceptional notice decision');
        self::assertSame(2, DB::table('audit_logs')->where('action', 'COMMISSION_POLICY_PUBLISHED')->count());
    }

    public function test_scheduled_corrections_and_cancellation_append_terms_and_unique_notices(): void
    {
        Queue::fake();
        config()->set('finance.commission_min_notice_days', 30);
        $this->activeStore('Corrected Policy Store', false);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $url = '/api/v1/admin/finance/commission-policies';
        $first = $this->postJson($url, ['commission_basis_points' => 300, 'expected_version' => 1, 'effective_from' => CarbonImmutable::now()->addDays(31)->toIso8601String(), 'reason' => 'Original scheduled change'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
        $second = $this->postJson($url, ['commission_basis_points' => 250, 'expected_version' => 2, 'supersedes_policy_id' => $first['id'], 'effective_from' => CarbonImmutable::now()->addDays(32)->toIso8601String(), 'reason' => 'Correct the scheduled change'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
        $cancel = $this->postJson($url, ['commission_basis_points' => 200, 'expected_version' => 3, 'supersedes_policy_id' => $second['id'], 'cancel_scheduled' => true, 'reason' => 'Cancel the scheduled change'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->assertJsonPath('data.rate_label', '2.00%')->json('data');
        self::assertCount(3, array_unique([$first['agreement_version_id'], $second['agreement_version_id'], $cancel['agreement_version_id']]));
        $this->getJson($url)->assertOk()->assertJsonPath('data.next', null)->assertJsonPath('data.versions.1.status', 'CANCELLED')->assertJsonPath('data.versions.2.status', 'SUPERSEDED');
        self::assertSame(['RATE_CANCELLED', 'RATE_CORRECTED', 'RATE_PUBLISHED'], DB::table('commission_email_events')->orderBy('notification_type')->pluck('notification_type')->all());
        self::assertSame(2, DB::table('commission_policy_revisions')->count());
        self::assertSame(300, (int) CommissionPolicyService::policies()->where('id', $first['id'])->value('commission_basis_points'));
        CarbonImmutable::setTestNow(CarbonImmutable::now()->addDays(40));
        Carbon::setTestNow(CarbonImmutable::now());
        self::assertSame(200, (int) CommissionPolicyService::current()->commission_basis_points, 'Cancelled versions never activate later.');
    }

    public function test_failed_rate_mail_retains_attempt_history_and_audited_resend_has_permission_and_throttle(): void
    {
        Queue::fake();
        Mail::fake();
        config()->set('mail.delivery_not_before', null);
        [$store] = $this->activeStore('Retry Policy Store', false);
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $policy = $this->postJson('/api/v1/admin/finance/commission-policies', ['commission_basis_points' => 100, 'expected_version' => 1, 'reason' => 'Reduced rate for future sales'], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk()->json('data');
        $event = DB::table('commission_email_events')->where('subject_id', $policy['id'])->where('vendor_organization_id', $store->id)->sole();
        app(OutboxProcessor::class)->process((string) DB::table('outbox_events')->where('event_type', 'COMMISSION_POLICY')->value('id'));
        $delivery = DB::table('notification_deliveries')->where('notification_id', $event->notification_id)->where('channel', 'EMAIL')->sole();
        $provider = \Mockery::mock(MailProvider::class);
        $provider->shouldReceive('send')->times(5)->andThrow(new \RuntimeException('Synthetic unavailable mail channel'));
        $this->app->instance(MailProvider::class, $provider);
        for ($attempt = 1; $attempt <= 5; $attempt++) {
            try {
                app(NotificationDelivery::class)->send((string) $delivery->id);
            } catch (\RuntimeException) { /* Recorded retry. */
            }
        }
        self::assertSame('FAILED', DB::table('notification_deliveries')->where('id', $delivery->id)->value('state'));
        self::assertSame(5, DB::table('notification_delivery_attempts')->where('notification_delivery_id', $delivery->id)->count());
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->postJson('/api/v1/admin/finance/commission-emails/'.$event->id.'/resend', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
        $this->signInAdmin($admin);
        $key = (string) Str::uuid7();
        $this->postJson('/api/v1/admin/finance/commission-policies/'.$policy['id'].'/resend-failed', [], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.queued', 1);
        $this->postJson('/api/v1/admin/finance/commission-policies/'.$policy['id'].'/resend-failed', [], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.queued', 1);
        $success = \Mockery::mock(MailProvider::class);
        $success->shouldReceive('send')->once();
        $this->app->instance(MailProvider::class, $success);
        app(NotificationDelivery::class)->send((string) $delivery->id);
        app(NotificationDelivery::class)->send((string) $delivery->id);
        self::assertSame(6, DB::table('notification_delivery_attempts')->where('notification_delivery_id', $delivery->id)->count());
        $this->postJson('/api/v1/admin/finance/commission-emails/'.$event->id.'/resend', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(429);
        self::assertSame(1, DB::table('audit_logs')->where('action', 'COMMISSION_EMAIL_RESENT')->count());
    }

    public function test_rate_impact_preview_is_read_only_and_escapes_vendor_copy(): void
    {
        Queue::fake();
        $this->activeStore('Preview Rate Store', false);
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $preview = $this->postJson('/api/v1/admin/finance/commission-policies/preview', ['commission_basis_points' => 150, 'expected_version' => 1, 'reason' => 'Private commercial rationale', 'vendor_message' => '<script>not executable</script>'])
            ->assertOk()->assertJsonPath('data.vendor_count', 1)->assertJsonPath('data.example_commission_centavos', 15000)->assertJsonPath('data.notice_required', false)->json('data');
        self::assertStringNotContainsString('<script>not executable</script>', $preview['email_html']);
        self::assertStringNotContainsString('Private commercial rationale', $preview['email_html']);
        self::assertStringContainsString('1.50%', $preview['new_terms']);
        self::assertSame(1, CommissionPolicyService::policies()->count());
        self::assertSame(0, DB::table('commission_email_events')->count());
    }

    public function test_fully_credited_statement_emails_no_payment_needed_once_and_no_activity_creates_no_bill(): void
    {
        Queue::fake();
        Mail::fake();
        config()->set('mail.delivery_not_before', null);
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        [$store, $owner, , $order] = $this->awaitingPayment('Fully Credited Store');
        DB::table('orders')->where('id', $order)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($order, (string) Str::uuid7());
        $assessment = (string) DB::table('fee_assessments')->where('order_id', $order)->value('id');
        $this->approveReturn($assessment, 1000000, $this->admin('ADMIN_SUPERADMIN'), $this->admin('ADMIN_SUPERADMIN'));
        [$idle] = $this->activeStore('No Billable Activity Store', false);
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 1, 0, 5, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        $this->artisan('materyalph:finance-process-commissions')->assertExitCode(0);
        $this->artisan('materyalph:finance-process-commissions')->assertExitCode(0);
        $statement = DB::table('fee_statements')->where('vendor_organization_id', $store->id)->sole();
        self::assertSame('PAID', $statement->state);
        self::assertSame(0, (int) $statement->outstanding_centavos);
        self::assertSame(0, DB::table('fee_statements')->where('vendor_organization_id', $idle->id)->count());
        self::assertSame(1, DB::table('commission_email_events')->where('subject_id', $statement->id)->where('notification_type', 'STATEMENT_ISSUED')->count());
        $event = DB::table('commission_email_events')->where('subject_id', $statement->id)->sole();
        $notice = DB::table('notifications')->where('id', $event->notification_id)->first();
        $mail = app(PlatformFeeInvoiceService::class)->mail($owner, $notice);
        self::assertNotNull($mail);
        self::assertStringContainsString('No payment needed', $mail->render());
        self::assertStringNotContainsString('Pay now (TEST)', $mail->render());
        self::assertStringContainsString('P0.00', $mail->envelope()->subject);
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->getJson('/api/v1/admin/finance/statements/'.$statement->id)->assertForbidden();
        $this->postJson('/api/v1/admin/finance/commission-emails/'.$event->id.'/resend', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();
    }

    public function test_backfilled_initial_policy_keeps_original_consent_without_creating_a_new_acceptance(): void
    {
        $store = VendorOrganization::query()->create(['legal_name' => 'Legacy Initial Consent', 'store_name' => 'Legacy Initial Consent']);
        $owner = $this->storeMember($store, 'OWNER');
        $policy = CommissionPolicyService::current();
        DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'agreement_version_id' => $policy->legacy_agreement_version_id,
            'vendor_organization_id' => $store->id, 'source' => 'ACCOUNT_SETTINGS', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        CommissionPolicyService::assertAccepted($policy, (string) $store->id);
        self::assertSame(1, DB::table('agreement_acceptances')->where('user_id', $owner->id)->count());
        self::assertFalse(DB::table('agreement_acceptances')->where('user_id', $owner->id)->where('agreement_version_id', $policy->agreement_version_id)->exists());
    }

    private function issuedCommission(): array
    {
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 10, 20, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Commission Records Store');
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'fulfillment_state' => 'PICKED_UP', 'closed_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
        $assessmentId = (string) DB::table('fee_assessments')->where('order_id', $orderId)->value('id');
        CarbonImmutable::setTestNow(CarbonImmutable::create(2026, 11, 2, 10, 0, 0, 'Asia/Manila'));
        Carbon::setTestNow(CarbonImmutable::now());
        app(StatementService::class)->draftMonthly(CarbonImmutable::now());
        $statement = DB::table('fee_statements')->where('vendor_organization_id', $store->id)->first();
        $preparer = $this->admin('ADMIN_SUPERADMIN');
        $approver = $this->admin('ADMIN_SUPERADMIN');
        app(StatementService::class)->approve((string) $statement->id, (int) $approver->id, 1);

        return [$owner, $assessmentId, $statement, $preparer, $approver];
    }

    private function approveReturn(string $assessmentId, int $returned, User $preparer, User $approver): string
    {
        $this->signInAdmin($preparer);
        $proposal = $this->postJson('/api/v1/admin/finance/fee-credits', ['fee_assessment_id' => $assessmentId, 'returned_exclusive_centavos' => $returned, 'reason' => 'Approved cumulative returned materials.'])->assertCreated()->json('data.proposal_id');
        $this->signInAdmin($approver);
        $id = $this->postJson('/api/v1/admin/finance/fee-credits/'.$proposal.'/approve')->assertOk()->json('data.fee_adjustment_id');
        $this->postJson('/api/v1/admin/finance/fee-credits/'.$proposal.'/approve')->assertStatus(409);

        return $id;
    }

    private function confirmFeeRefund(object $refund): void
    {
        app(RefundService::class)->send((string) $refund->id, (string) Str::uuid7());
        $providerId = (string) DB::table('refunds')->where('id', $refund->id)->value('provider_reference');
        $body = $this->gateway->settleRefund($providerId);
        $this->deliverWebhook($body)->assertOk();
        $this->deliverWebhook($body)->assertOk();
        self::assertSame('REFUNDED', DB::table('refunds')->where('id', $refund->id)->value('state'));
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE11ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
