<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Finance\StatementService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
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
            foreach (['/api/v1/vendor/finance', '/api/v1/vendor/finance/transactions', '/api/v1/vendor/finance/earnings', '/api/v1/vendor/finance/transactions/export?tab=PAYMENTS'] as $path) {
                $this->getJson($path)->assertForbidden()->assertJsonPath('errors.0.code', 'FINANCE_OWNER_ONLY');
            }
            $this->putJson('/api/v1/vendor/finance/physical-payments', ['lock_version' => 0, 'cod_enabled' => true, 'in_store_enabled' => true])->assertForbidden();
            $snapshot = $this->getJson('/api/v1/vendors/onboarding')->json('data');
            self::assertNotContains('finance.view', $snapshot['permissions'] ?? []);
            self::assertNotContains('portal.wallet', $snapshot['permissions'] ?? []);
        }
        self::assertSame(1, DB::table('audit_logs')->where('action', 'FINANCE_EXPORT_DOWNLOADED')->count());
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

        $this->signInBuyer($buyer);
        $record = collect($this->getJson('/api/v1/buyers/orders/'.$orderId)->json('data.payment.physical.records'))->firstWhere('kind', 'COLLECTION');
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/physical-payments/'.$record['id'].'/acknowledge', [], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        self::assertNotNull(DB::table('physical_payment_records')->where('id', $record['id'])->value('buyer_acknowledged_at'));
        self::assertSame([0, 0, 'NOT_REQUIRED'], [DB::table('payments')->count(), DB::table('remittance_assessments')->count(), (string) DB::table('orders')->where('id', $orderId)->value('payment_state')],
            'Direct cash never creates an online success or a platform CWT event.');
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
        self::assertSame(0, collect($view['channels'])->firstWhere('code', 'GCASH')['fee_centavos'], 'The platform absorbs its own bill processing charge.');
        $first = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH', 'amount_centavos' => 5000], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $payment = DB::table('payments')->where('id', $first['id'])->first();
        self::assertSame(['PLATFORM_FEE_PAYMENT', 'PLATFORM_ACCOUNT', null, 0, 5000], [$payment->purpose, $payment->account_scope, $payment->provider_account_id, (int) $payment->processing_fee_centavos, (int) $payment->total_centavos]);
        self::assertEqualsWithDelta(45, CarbonImmutable::parse((string) $payment->created_at)->diffInMinutes(CarbonImmutable::parse((string) $payment->expires_at)), 0.1);
        $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'GCASH'], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'PAYMENT_ATTEMPT_IN_PROGRESS');
        $this->completePayment($first['id'])->assertOk();
        self::assertSame(['PARTIALLY_PAID', 15000], [(string) DB::table('fee_statements')->where('id', $statement->id)->value('state'), (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos')]);

        $second = $this->postJson('/api/v1/vendor/finance/statements/'.$statement->id.'/payments', ['channel_code' => 'CARDS'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $this->completePayment($second['id'])->assertOk();
        self::assertSame(['PAID', 0, 20000], [(string) DB::table('fee_statements')->where('id', $statement->id)->value('state'), (int) DB::table('fee_statements')->where('id', $statement->id)->value('outstanding_centavos'),
            (int) DB::table('fee_payment_allocations')->where('fee_statement_id', $statement->id)->sum('amount_centavos')]);
        self::assertSame(0, DB::table('remittance_assessments')->whereIn('payment_id', [$first['id'], $second['id']])->count(), 'A platform fee receipt is never a merchant remittance.');
        foreach (DB::table('financial_posting_batches')->where('ledger', 'PLATFORM_FEE')->get() as $batch) {
            self::assertSame((int) $batch->debit_total_centavos, (int) $batch->credit_total_centavos);
        }
        self::assertSame(20000, (int) DB::table('financial_ledger_entries')->where('ledger', 'PLATFORM_FEE')->where('account_code', 'FEE_RECEIVABLE')->where('direction', 'CREDIT')->sum('amount_centavos'));
        self::assertGreaterThan(0, (int) DB::table('financial_ledger_entries')->where('account_code', 'PLATFORM_PROCESSING_EXPENSE')->sum('amount_centavos'));
        self::assertSame(1, DB::table('notifications')->where('user_id', $owner->id)->where('category', 'FINANCE_MANDATORY')->where('title', 'like', '%issued%')->count());
        self::assertSame(0, DB::table('notifications')->where('user_id', $manager->id)->where('category', 'like', 'FINANCE%')->count());
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
