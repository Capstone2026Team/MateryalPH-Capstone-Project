<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Disputes\DisputeAdminService;
use App\Domain\Disputes\DisputeChannel;
use App\Domain\Disputes\DisputeExportService;
use App\Domain\Disputes\DisputeRemedyService;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Invoices\InvoiceService;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderActor;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
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
 * Phase 13 acceptance: filing creates a Case ID and dispute state only (never a refund or REFUND_PENDING) and refuses
 * any refund destination; the 48-hour response, 72-hour mutual resolution, 24-hour clarification and five-business-
 * day appeal timers; immutable evidence, timeline and decisions; exactly one DISPUTE_CONCLUSION refund per decision
 * version and original payment, separate from CANCELLATION, that keeps the case open until the provider confirms
 * it; the Owner's staff dispute flag (default, revocation during an open case and export job, reassignment,
 * retained history, re-enable); and FIN-09 invoice records, requests and narrow access. Every provider is the
 * deterministic SIMULATED adapter.
 */
final class PhaseThirteenDisputesTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use RefreshDatabase;

    private const PROTECTED_FINANCE = ['commission', 'withholding', 'earned_centavos', 'fee_statement', 'earnings', 'payout', 'taxpayer', 'remittance'];

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

    // ── Filing ───────────────────────────────────────────────────────────────────────────────────────

    public function test_filing_creates_a_case_and_dispute_state_only_refuses_refund_destinations_and_links_duplicates(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Filing Store');
        $this->toPickedUp($owner, $orderId);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');

        $this->signInBuyer($buyer);
        $eligibility = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/dispute-eligibility')->assertOk()->json('data');
        self::assertTrue($eligibility['available']);
        self::assertFalse($eligibility['filing_creates_refund']);
        self::assertStringContainsString('original payment method', $eligibility['original_payment_method']['label']);
        self::assertSame([$line], array_column($eligibility['lines'], 'order_line_id'));
        self::assertContains('FILE_DISPUTE', $this->buyerOrder($buyer, $orderId)['available_actions']);

        // No field anywhere accepts a different refund destination.
        foreach (['refund_destination' => 'GCash 0917', 'bank_account' => '1234567890', 'ewallet_number' => '09170000000'] as $field => $value) {
            $this->fileCase($buyer, $orderId, [$field => $value])->assertStatus(422)->assertJsonPath('errors.0.code', 'REFUND_DESTINATION_NOT_ACCEPTED');
        }
        $this->fileCase($buyer, $orderId, ['requested_remedy' => 'PARTIAL_REFUND', 'requested_amount_centavos' => 99999999])->assertStatus(422);
        self::assertSame(0, DB::table('dispute_cases')->count());

        $key = (string) Str::uuid7();
        $case = $this->fileCase($buyer, $orderId, [], $key)->assertCreated()
            ->assertJsonPath('data.status', 'OPEN_AWAITING_RESPONSE')->assertJsonPath('data.responsible_party', 'VENDOR')->assertJsonPath('data.refund_state', 'NOT_REQUESTED')
            ->assertJsonPath('data.timeline.0.type', 'CASE_FILED')->assertJsonPath('data.timeline.0.actor.party', 'BUYER')->json('data');
        self::assertMatchesRegularExpression('/^CASE-\d{6}-[A-Z0-9]{6}$/', $case['reference']);
        self::assertSame('RESPONSE', $case['deadlines'][0]['kind']);
        self::assertEqualsWithDelta(48 * 3600, CarbonImmutable::now()->diffInSeconds(CarbonImmutable::parse($case['deadlines'][0]['at'])), 5);
        self::assertStringEndsWith('(Asia/Manila)', $case['deadlines'][0]['label']);
        $this->fileCase($buyer, $orderId, [], $key)->assertCreated()->assertJsonPath('data.id', $case['id']);
        $this->fileCase($buyer, $orderId)->assertStatus(409)->assertJsonPath('errors.0.code', 'DISPUTE_ALREADY_OPEN')->assertJsonPath('errors.0.details.case_id', $case['id']);

        // Filing alone: no refund, no REFUND_PENDING; the order waits in DISPUTED with receipt paused; the fee keeps its state.
        $order = DB::table('orders')->where('id', $orderId)->first();
        self::assertSame(['DISPUTED', 'OPEN_AWAITING_RESPONSE', 'NOT_REQUESTED', 0], [$order->order_state, $order->dispute_state, $order->refund_state, DB::table('refunds')->where('order_id', $orderId)->count()]);
        self::assertNotNull(DB::table('fulfillments')->where('order_id', $orderId)->value('auto_confirm_paused_at'));
        $fee = DB::table('fee_assessments')->where('order_id', $orderId)->first();
        self::assertSame(['ESTIMATED', true], [$fee->state, (bool) $fee->dispute_hold], 'A dispute hold never overwrites the fee state.');

        // Evidence opens only through a short-lived signed URL and only for authorized callers.
        $evidence = $case['timeline'][0]['evidence'][0];
        self::assertStringContainsString('signature=', $evidence['url']);
        $this->get($evidence['url'])->assertOk();
        $this->get(preg_replace('/signature=[0-9a-f]+/', 'signature=deadbeef', $evidence['url']))->assertForbidden();
        $this->buyer('stranger@example.test');
        $this->get($evidence['url'])->assertNotFound();
        $this->travel(6)->minutes();
        $this->signInBuyer($buyer);
        $this->get($evidence['url'])->assertForbidden();

        // Evidence and the timeline are append-only.
        $this->expectAppendOnly(fn () => DB::table('dispute_events')->where('dispute_case_id', $case['id'])->update(['body' => 'rewritten']));
        $this->expectAppendOnly(fn () => DB::table('dispute_evidence')->where('dispute_case_id', $case['id'])->delete());

        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/disputes')->assertOk()->assertJsonPath('data.0.id', $case['id'])->assertJsonPath('data.0.buyer_name', fn ($name) => is_string($name));
        self::assertNotNull($store);
    }

    // ── Mutual resolution and the Dispute-Conclusion Refund ─────────────────────────────────────────

    public function test_agreed_partial_refund_creates_one_linked_dispute_refund_and_the_case_resolves_only_after_the_provider(): void
    {
        [$store, $owner, $buyer, $orderId, $paymentId] = $this->paidPickup('Agreement Store');
        $this->toPickedUp($owner, $orderId);
        $caseId = (string) $this->fileCase($buyer, $orderId, ['requested_remedy' => 'PARTIAL_REFUND', 'requested_amount_centavos' => 200000])->assertCreated()->json('data.id');

        // Only the Owner offers a voluntary refund; Store Staff may respond without money.
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $this->signInStoreMember($staff);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'OFFER_REFUND', 'body' => 'We can refund two thousand pesos.', 'amount_centavos' => 200000], $this->key())
            ->assertForbidden();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'OFFER_REFUND', 'body' => 'We refund two thousand pesos for the cracked blocks.', 'amount_centavos' => 200000], $this->key())
            ->assertOk()->assertJsonPath('data.status', 'MUTUAL_RESOLUTION')->assertJsonPath('data.deadlines.0.kind', 'MUTUAL_RESOLUTION');
        self::assertSame(0, DB::table('refunds')->where('order_id', $orderId)->count(), 'An offer is not an award.');

        $this->signInBuyer($buyer);
        $detail = $this->getJson('/api/v1/buyers/disputes/'.$caseId)->assertOk()->json('data');
        self::assertContains('ANSWER_PROPOSAL', $detail['available_actions']);
        $proposal = $detail['proposals'][0]['id'];
        $accept = $this->key();
        $this->postJson('/api/v1/buyers/disputes/'.$caseId.'/proposals/'.$proposal.'/answer', ['decision' => 'ACCEPT'], $accept)->assertOk()
            ->assertJsonPath('data.status', 'MUTUAL_RESOLUTION')->assertJsonPath('data.remedy_state', 'PENDING')->assertJsonPath('data.refunds.0.trigger', 'DISPUTE_CONCLUSION');
        $this->postJson('/api/v1/buyers/disputes/'.$caseId.'/proposals/'.$proposal.'/answer', ['decision' => 'ACCEPT'], $accept)->assertOk();

        $refunds = DB::table('refunds')->where('order_id', $orderId)->get();
        $decision = DB::table('dispute_decisions')->where('dispute_case_id', $caseId)->first();
        self::assertCount(1, $refunds, 'A concluded award creates exactly one linked refund per original payment.');
        $refund = $refunds->first();
        self::assertSame(['DISPUTE_CONCLUSION', $caseId, (string) $decision->id, 200000, 'REFUND_PENDING', $paymentId, 0],
            [$refund->trigger, (string) $refund->dispute_case_id, (string) $refund->dispute_decision_id, (int) $refund->amount_centavos, $refund->state, (string) $refund->source_payment_id, (int) $refund->processing_fee_centavos]);
        self::assertSame(['MUTUAL_AGREEMENT', 'PARTIAL_REFUND', 1], [$decision->kind, $decision->outcome, (int) $decision->version]);
        self::assertSame(['DISPUTED', 'REFUND_PENDING'], [$this->orderState($orderId), (string) DB::table('orders')->where('id', $orderId)->value('refund_state')]);
        self::assertSame(200000, (int) DB::table('financial_snapshot_lines as l')->join('financial_snapshots as s', 's.id', '=', 'l.financial_snapshot_id')->where('s.order_id', $orderId)->sum('l.refund_allocated_centavos'));
        self::assertSame(1, DB::table('financial_allocations')->where('source_type', 'DISPUTE_DECISION')->where('source_id', $decision->id)->count());

        // The case stays open until the provider confirms the refund, then resolves and completes the order once.
        $this->deliverWebhook($this->gateway->settleRefund((string) $refund->provider_reference), 'wh-dispute-1')->assertOk();
        $this->deliverWebhook($this->gateway->settleRefund((string) $refund->provider_reference), 'wh-dispute-1')->assertOk();
        $case = DB::table('dispute_cases')->where('id', $caseId)->first();
        self::assertSame(['RESOLVED', 'COMPLETED', 'REFUNDED'], [$case->status, (string) $case->remedy_state, (string) DB::table('refunds')->where('id', $refund->id)->value('state')]);
        self::assertSame(['COMPLETED', 'RESOLVED', 'PARTIALLY_REFUNDED'], array_values((array) DB::table('orders')->where('id', $orderId)->first(['order_state', 'dispute_state', 'refund_state'])));
        $fee = DB::table('fee_assessments')->where('order_id', $orderId)->first();
        self::assertSame(['EARNED', false], [$fee->state, (bool) $fee->dispute_hold]);
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'FEE_CREDIT_PROPOSAL')->where('source_id', $fee->id)->count(), 'The commission credit is a separate reviewed proposal.');
        self::assertSame(1, DB::table('dispute_events')->where('dispute_case_id', $caseId)->where('event_type', 'CASE_RESOLVED')->count());
        $assessment = DB::table('remittance_assessments')->where('payment_id', $paymentId)->where('calculation_state', 'POSTED')->value('id');
        if ($assessment !== null) {
            self::assertSame('DISPUTE_REFUND_AFTER_ASSESSMENT', (string) DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment)->value('kind'), 'A tax review, never an automatic amendment.');
        }
        // Decisions are immutable; a settled refund instruction cannot be rewritten.
        $this->expectAppendOnly(fn () => DB::table('dispute_decisions')->where('id', $decision->id)->update(['awarded_centavos' => 1]));
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/disputes/'.$caseId)->assertOk()->assertJsonPath('data.refunds.0.display_state', 'PROCESSED')->assertJsonPath('data.available_actions', []);
    }

    // ── Admin review, clarification, decision and the one appeal ────────────────────────────────────

    public function test_escalation_clarification_conflict_checked_decision_and_one_appeal_with_final_execution(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Admin Review Store');
        $this->toPickedUp($owner, $orderId);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');
        $caseId = (string) $this->fileCase($buyer, $orderId, ['requested_remedy' => 'FULL_REFUND'])->assertCreated()->json('data.id');

        $this->travel(47)->hours();
        self::assertSame(0, app(DisputeAdminService::class)->sweep()['escalated']);
        $this->travel(61)->minutes();
        self::assertSame(1, app(DisputeAdminService::class)->sweep()['escalated'], 'No response within 48 hours escalates.');
        self::assertSame(['ESCALATED_ADMIN_REVIEW', 'NO_RESPONSE'], array_values((array) DB::table('dispute_cases')->where('id', $caseId)->first(['status', 'escalation_reason'])));
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'ACCEPT_REQUEST', 'body' => 'We accept the requested refund now.'], $this->key())->assertStatus(409);

        $support = $this->admin('ADMIN_SUPPORT');
        $this->signInAdmin($support);
        $this->getJson('/api/v1/admin/disputes')->assertForbidden();
        $first = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->signInAdmin($first);
        $this->getJson('/api/v1/admin/disputes')->assertOk()->assertJsonPath('data.0.id', $caseId)->assertJsonPath('meta.counts.NEEDS_ADMIN', 1);

        // Clarification: 24 hours for each requested party; silence expires it and is recorded as a limitation.
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/clarifications', ['parties' => ['BUYER', 'VENDOR'], 'question' => 'Please send photos of the blocks as received.'], $this->key())
            ->assertOk()->assertJsonPath('data.status', 'AWAITING_CLARIFICATION');
        $this->signInBuyer($buyer);
        $clarification = collect($this->getJson('/api/v1/buyers/disputes/'.$caseId)->json('data.clarifications'))->firstWhere('requested_party', 'BUYER');
        $this->post('/api/v1/buyers/disputes/'.$caseId.'/clarifications/'.$clarification['id'].'/answer', ['response' => 'Photos of the cracked blocks attached.', 'files' => [UploadedFile::fake()->image('photo.png')]],
            $this->key() + ['Accept' => 'application/json'])->assertOk()->assertJsonPath('data.status', 'AWAITING_CLARIFICATION');
        $this->travel(25)->hours();
        self::assertSame(1, app(DisputeAdminService::class)->sweep()['clarifications_expired']);
        self::assertSame('ESCALATED_ADMIN_REVIEW', (string) DB::table('dispute_cases')->where('id', $caseId)->value('status'));

        $this->signInAdmin($first);
        $lock = (int) DB::table('dispute_cases')->where('id', $caseId)->value('lock_version');
        $decision = ['outcome' => 'FULL_REFUND', 'reason' => 'The photos show cracked blocks at handover; the Vendor did not respond.', 'enforceable' => false, 'conflict_check_confirmed' => true,
            'lock_version' => $lock, 'evidence_limitation' => 'The Vendor did not answer the clarification request.',
            'sanctions' => [['subject' => 'VENDOR', 'action' => 'WARNING', 'reason' => 'Failure to respond to a case.'], ['subject' => 'VENDOR', 'action' => 'SUSPENSION', 'reason' => 'Repeated unanswered cases.', 'restoration_condition' => 'Respond to all open cases.']],
            'metric_event' => 'VALIDATED_DEFECT_RETURN'];
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['conflict_check_confirmed' => false] + $decision, $this->key())->assertStatus(422)->assertJsonPath('errors.0.code', 'CONFLICT_CHECK_REQUIRED');
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['evidence_limitation' => null] + $decision, $this->key())->assertStatus(422);
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['reason' => 'Too short'] + $decision, $this->key())->assertStatus(422);
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['lock_version' => $lock + 7] + $decision, $this->key())->assertStatus(409)->assertJsonPath('errors.0.code', 'RESOURCE_VERSION_CONFLICT');
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['outcome' => 'PARTIAL_REFUND', 'amount_centavos' => 99999999, 'affected_line_ids' => [$line]] + $decision, $this->key())
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'AWARD_EXCEEDS_LINES');
        $decided = $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', $decision, $this->key())->assertOk()->assertJsonPath('data.status', 'DECIDED')->json('data');
        self::assertSame(0, DB::table('refunds')->where('order_id', $orderId)->count(), 'A decision that is not immediately enforceable waits for the appeal window.');
        self::assertSame(0, DB::table('enforcement_actions')->count());
        $appealDue = CarbonImmutable::parse($decided['deadlines'][0]['at']);
        self::assertSame('APPEAL', $decided['deadlines'][0]['kind']);
        self::assertEqualsWithDelta(DisputeRules::addBusinessDays(CarbonImmutable::now(), 5)->timestamp, $appealDue->timestamp, 5, 'Five business days, Asia/Manila.');

        // One appeal per case, with new evidence; the decider cannot review it.
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/appeal', ['grounds' => 'NEW_EVIDENCE', 'statement' => 'Our dispatch photos show intact blocks at loading.'], $this->key())
            ->assertStatus(422);
        $this->post('/api/v1/vendor/disputes/'.$caseId.'/appeal', ['grounds' => 'NEW_EVIDENCE', 'statement' => 'Our dispatch photos show intact blocks at loading.', 'files' => [UploadedFile::fake()->image('dispatch.png')]],
            $this->key() + ['Accept' => 'application/json'])->assertCreated()->assertJsonPath('data.status', 'APPEAL_OPEN');
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/disputes/'.$caseId.'/appeal', ['grounds' => 'MATERIAL_PROCESS_ERROR', 'statement' => 'The case was decided without my second set of photos.'], $this->key())->assertStatus(409);

        $this->signInAdmin($first);
        $lock = (int) DB::table('dispute_cases')->where('id', $caseId)->value('lock_version');
        $appeal = ['result' => 'MODIFIED', 'outcome' => 'PARTIAL_REFUND', 'amount_centavos' => 300000, 'affected_line_ids' => [$line], 'reason' => 'Dispatch photos show some blocks intact; three were cracked on site.',
            'conflict_check_confirmed' => true, 'lock_version' => $lock, 'sanctions' => [['subject' => 'VENDOR', 'action' => 'WARNING', 'reason' => 'Late evidence in a case.']]];
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/appeal-decision', $appeal, $this->key())->assertStatus(409)->assertJsonPath('errors.0.code', 'CONFLICT_OF_INTEREST');
        $reviewer = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/appeal-decision', $appeal, $this->key())->assertOk()->assertJsonPath('data.status', 'DECIDED');

        $decisions = DB::table('dispute_decisions')->where('dispute_case_id', $caseId)->orderBy('version')->get();
        self::assertSame([['ADMIN_DECISION', 'FULL_REFUND'], ['APPEAL_DECISION', 'PARTIAL_REFUND']], $decisions->map(fn ($row) => [$row->kind, $row->outcome])->all(), 'The original decision is kept.');
        self::assertSame((string) $decisions[0]->id, (string) $decisions[1]->supersedes_decision_id);
        $refunds = DB::table('refunds')->where('order_id', $orderId)->get();
        self::assertSame([1, 300000, (string) $decisions[1]->id], [$refunds->count(), (int) $refunds[0]->amount_centavos, (string) $refunds[0]->dispute_decision_id], 'The final appeal decision executes once.');
        self::assertSame(['WARNING:EFFECTIVE'], DB::table('enforcement_actions')->orderBy('created_at')->get()->map(fn ($row) => $row->action.':'.$row->state)->all(),
            'Only the final decision\'s sanctions take effect.');
        self::assertSame(0, DB::table('metric_events')->count());

        // Duplicate execution of the same decision changes nothing.
        DB::transaction(function () use ($orderId, $caseId, $decisions): void {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $case = DB::table('dispute_cases')->where('id', $caseId)->lockForUpdate()->first();
            app(DisputeRemedyService::class)->execute($order, $case, $decisions[1], OrderActor::system());
        });
        self::assertSame(1, DB::table('refunds')->where('order_id', $orderId)->count());
        self::assertNotNull($store);
    }

    public function test_an_unappealed_decision_becomes_final_after_five_business_days_and_suspension_is_referred_not_applied(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Final Decision Store');
        $this->toPickedUp($owner, $orderId);
        $caseId = (string) $this->fileCase($buyer, $orderId, ['requested_remedy' => 'FULL_REFUND'])->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'REQUEST_ADMIN_REVIEW', 'body' => 'We disagree and ask MateryalPH to review.'], $this->key())
            ->assertOk()->assertJsonPath('data.status', 'ESCALATED_ADMIN_REVIEW');
        $admin = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->signInAdmin($admin);
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['outcome' => 'FULL_REFUND', 'reason' => 'Wrong item delivered according to the handover photos.', 'enforceable' => false,
            'conflict_check_confirmed' => true, 'lock_version' => (int) DB::table('dispute_cases')->where('id', $caseId)->value('lock_version'), 'metric_event' => 'VENDOR_NON_FULFILLMENT',
            'sanctions' => [['subject' => 'VENDOR', 'action' => 'SUSPENSION', 'reason' => 'Wrong items delivered repeatedly.', 'restoration_condition' => 'Corrective plan approved.']]], $this->key())->assertOk();
        $due = CarbonImmutable::parse((string) DB::table('dispute_cases')->where('id', $caseId)->value('appeal_due_at'));

        CarbonImmutable::setTestNow($due->subMinute());
        Carbon::setTestNow($due->subMinute());
        app(DisputeAdminService::class)->sweep();
        self::assertSame(0, DB::table('refunds')->where('order_id', $orderId)->count());
        // The provider definitively rejects the first attempt (for example an unfunded TEST balance).
        $this->gateway->nextRefund = 'REJECT';
        CarbonImmutable::setTestNow($due->addMinute());
        Carbon::setTestNow($due->addMinute());
        app(DisputeAdminService::class)->sweep();
        $refund = DB::table('refunds')->where('order_id', $orderId)->first();
        self::assertSame(['DISPUTE_CONCLUSION', (int) DB::table('payments')->where('order_id', $orderId)->where('state', 'PAID')->value('total_centavos')], [$refund->trigger, (int) $refund->amount_centavos],
            'A full award returns every Buyer-paid amount, including the processing fee.');
        self::assertSame(['DECIDED', 'REFUND_FAILED'], [(string) DB::table('dispute_cases')->where('id', $caseId)->value('status'), (string) DB::table('refunds')->where('id', $refund->id)->value('state')], 'Still open: the remedy has not completed.');
        self::assertSame(['SUSPENSION', 'REFERRED', null], array_values((array) DB::table('enforcement_actions')->first(['action', 'state', 'effective_at'])));
        self::assertSame(1, DB::table('metric_events')->where('metric', 'VENDOR_NON_FULFILLMENT')->count());
        self::assertSame('ACTIVE', (string) DB::table('vendor_organizations')->where('id', $store->id)->value('store_activation_status'), 'A referred sanction is not applied here.');

        // A failed refund keeps the case open and is retried to the same original payment only.
        self::assertSame(['DECIDED', 'FAILED'], array_values((array) DB::table('dispute_cases')->where('id', $caseId)->first(['status', 'remedy_state'])));
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/refunds/'.$refund->id.'/retry', [], $this->key())->assertOk();
        $retried = DB::table('refunds')->where('id', $refund->id)->first();
        self::assertSame([1, 2, 'PENDING'], [DB::table('refunds')->where('order_id', $orderId)->count(), (int) $retried->attempt_number, (string) DB::table('dispute_cases')->where('id', $caseId)->value('remedy_state')]);
        $this->deliverWebhook($this->gateway->settleRefund((string) $retried->provider_reference), 'wh-dispute-retried')->assertOk();
        self::assertSame(['RESOLVED', 'COMPLETED'], [(string) DB::table('dispute_cases')->where('id', $caseId)->value('status'), $this->orderState($orderId)]);
    }

    public function test_a_full_award_before_handover_cancels_the_order_without_a_cancellation_refund(): void
    {
        [, $owner, $buyer, $orderId] = $this->paidPickup('Pre Handover Store');
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $caseId = (string) $this->fileCase($buyer, $orderId, ['issue_type' => 'LATE_OR_MISSING', 'requested_remedy' => 'FULL_REFUND'])->assertCreated()->json('data.id');
        self::assertSame(['PROCESSING', 'OPEN_AWAITING_RESPONSE'], array_values((array) DB::table('orders')->where('id', $orderId)->first(['order_state', 'dispute_state'])), 'Fulfillment keeps running before handover.');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'ACCEPT_REQUEST', 'body' => 'We cannot supply in time; full refund agreed.'], $this->key())->assertOk();
        $this->signInBuyer($buyer);
        $proposal = $this->getJson('/api/v1/buyers/disputes/'.$caseId)->json('data.proposals.0.id');
        $this->postJson('/api/v1/buyers/disputes/'.$caseId.'/proposals/'.$proposal.'/answer', ['decision' => 'ACCEPT'], $this->key())->assertOk();
        self::assertSame(['CANCELLED', 'CANCELLED'], [$this->orderState($orderId), (string) DB::table('fee_assessments')->where('order_id', $orderId)->value('state')]);
        self::assertSame(['DISPUTE_CONCLUSION'], DB::table('refunds')->where('order_id', $orderId)->pluck('trigger')->all(), 'Separate from CANCELLATION.');
        self::assertSame(0, DB::table('cancellation_decisions')->where('order_id', $orderId)->count());
        self::assertSame(0, $this->activeHolds($orderId));
    }

    // ── Owner-controlled staff dispute handling ──────────────────────────────────────────────────────

    public function test_staff_dispute_flag_defaults_on_revokes_everything_routes_work_to_the_owner_keeps_history_and_re_enables_current_scope_only(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Flag Store');
        $this->toPickedUp($owner, $orderId);
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $service = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $inventory = $this->teamMember($store, 'INVENTORY');
        $fulfillment = $this->teamMember($store, 'FULFILLMENT');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $caseId = (string) $this->fileCase($buyer, $orderId)->assertCreated()->json('data.id');

        // Default: on for Store Staff and Customer Service; never for Inventory; Fulfillment only for an assigned order's evidence.
        self::assertTrue((bool) DB::table('vendor_organizations')->where('id', $store->id)->value('staff_disputes_enabled'));
        foreach ([$staff, $service, $manager] as $member) {
            $this->signInStoreMember($member);
            $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertOk()->assertJsonPath('data.limited_view', false);
        }
        $this->signInStoreMember($inventory);
        $this->getJson('/api/v1/vendor/disputes')->assertForbidden();
        $this->signInStoreMember($fulfillment);
        $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertNotFound();
        $this->signInStoreMember($service);
        $detail = $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertOk()->json('data');
        self::assertFalse($detail['permissions']['can_offer_refund'], 'The flag never grants voluntary-refund authority.');
        foreach (self::PROTECTED_FINANCE as $key) {
            self::assertStringNotContainsString('"'.$key, json_encode($detail, JSON_THROW_ON_ERROR), 'No protected finance in a staff case view: '.$key);
        }

        $this->signInStoreMember($staff);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'OFFER_REPLACEMENT', 'body' => 'We will replace the cracked blocks this week.'], $this->key())->assertOk();
        $evidenceUrl = $this->post('/api/v1/vendor/disputes/'.$caseId.'/evidence', ['description' => 'Loading photo', 'files' => [UploadedFile::fake()->image('loading.png')]], $this->key() + ['Accept' => 'application/json'])
            ->assertCreated()->json('data.timeline');
        $evidenceUrl = collect($evidenceUrl)->firstWhere('type', 'EVIDENCE_ADDED')['evidence'][0]['url'];
        self::assertSame(['STORE_STAFF', (int) $staff->id], [(string) DB::table('dispute_cases')->where('id', $caseId)->value('vendor_handler_role'), (int) DB::table('dispute_cases')->where('id', $caseId)->value('vendor_handler_user_id')]);
        $this->postJson('/api/v1/vendor/disputes/exports', ['group' => 'ALL'], $this->key())->assertStatus(202);
        $export = DB::table('data_exports')->where('requested_by_user_id', $staff->id)->first();
        self::assertSame('READY', $export->state);
        $queued = (string) Str::uuid7();
        DB::table('data_exports')->insert(['id' => $queued, 'requested_by_user_id' => $service->id, 'export_type' => DisputeExportService::TYPE, 'filters' => '{"group":"ALL"}', 'reason' => 'Vendor dispute case export',
            'state' => 'QUEUED', 'vendor_organization_id' => $store->id, 'requested_role' => 'CUSTOMER_SERVICE', 'created_at' => now(), 'updated_at' => now()]);
        $staffChannel = app(DisputeChannel::class)->name($staff);
        self::assertNotNull($staffChannel);

        foreach (DB::table('agreement_versions')->pluck('id') as $version) {
            DB::table('agreement_acceptances')->insertOrIgnore(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'vendor_organization_id' => $store->id, 'agreement_version_id' => $version, 'source' => 'VENDOR_ONBOARDING', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        // Only the Owner changes the flag.
        $this->signInStoreMember($manager);
        $this->patchJson('/api/v1/vendors/account/staff-disputes', ['enabled' => false, 'lock_version' => (int) $store->fresh()->lock_version])->assertForbidden();
        $this->signInStoreMember($owner);
        $this->patchJson('/api/v1/vendors/account/staff-disputes', ['enabled' => false, 'lock_version' => (int) $store->fresh()->lock_version])->assertOk();

        // Revoked at once: navigation, direct route, API actions, files, exports, realtime and queued notices.
        foreach ([$staff, $service] as $member) {
            $this->signInStoreMember($member);
            self::assertNotContains('portal.disputes', $this->getJson('/api/v1/vendors/onboarding')->json('data.permissions') ?? []);
            $this->getJson('/api/v1/vendor/disputes')->assertForbidden();
            $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertForbidden();
            $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/messages', ['body' => 'Still here?'], $this->key())->assertForbidden();
            $this->getJson('/api/v1/vendor/disputes/exports')->assertForbidden();
            $this->postJson('/api/v1/vendor/disputes/realtime/auth', ['socket_id' => '1.2', 'channel_name' => 'private-'.$staffChannel])->assertForbidden();
        }
        $this->signInStoreMember($staff);
        $this->get($evidenceUrl)->assertNotFound();
        $this->get('/api/v1/vendor/disputes/exports/'.$export->id.'/download')->assertForbidden();
        self::assertSame('REVOKED', (string) DB::table('data_exports')->where('id', $export->id)->value('state'));
        self::assertSame(['REVOKED', 'STAFF_DISPUTE_ACCESS_DISABLED'], array_values((array) DB::table('data_exports')->where('id', $queued)->first(['state', 'revocation_reason'])), 'A queued staff export is revoked with the flag.');
        $late = (string) Str::uuid7();
        DB::table('data_exports')->insert(['id' => $late, 'requested_by_user_id' => $staff->id, 'export_type' => DisputeExportService::TYPE, 'filters' => '{"group":"ALL"}', 'reason' => 'Vendor dispute case export',
            'state' => 'QUEUED', 'vendor_organization_id' => $store->id, 'requested_role' => 'STORE_STAFF', 'created_at' => now(), 'updated_at' => now()]);
        app(DisputeExportService::class)->process($late);
        self::assertSame(['REVOKED', 'ACCESS_REVOKED', null], array_values((array) DB::table('data_exports')->where('id', $late)->first(['state', 'revocation_reason', 'file_id'])), 'A job that runs after revocation re-checks access and delivers nothing.');
        self::assertNull(app(DisputeChannel::class)->name($staff->fresh()));
        Mail::fake();
        $notice = app(OutboxPublisher::class)->publish('DISPUTE_NOTICE', 'DISPUTE_CASE', $caseId, ['user_id' => (int) $staff->id, 'dispute_case_id' => $caseId, 'subject' => 'Queued before revocation', 'message' => 'Should not arrive.', 'notification_id' => (string) Str::uuid7()]);
        app(OutboxProcessor::class)->process($notice);
        Mail::assertNothingSent();

        // Open work moved to the Owner; earlier staff actions keep their author and role.
        $case = DB::table('dispute_cases')->where('id', $caseId)->first();
        self::assertSame(['OWNER', (int) $owner->id], [$case->vendor_handler_role, (int) $case->vendor_handler_user_id]);
        self::assertSame(1, DB::table('dispute_events')->where('dispute_case_id', $caseId)->where('event_type', 'HANDLER_REASSIGNED')->count());
        $response = DB::table('dispute_events')->where('dispute_case_id', $caseId)->where('event_type', 'RESPONSE_SUBMITTED')->first();
        self::assertSame([(int) $staff->id, 'STORE_STAFF'], [(int) $response->actor_user_id, $response->actor_role]);
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertOk()->assertJsonPath('data.handler.vendor.role', 'OWNER');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/messages', ['body' => 'The Owner is handling this case now.'], $this->key())->assertCreated();

        // Re-enabling restores only the current scope: access returns, the reassignment and revoked export stay.
        $this->patchJson('/api/v1/vendors/account/staff-disputes', ['enabled' => true, 'lock_version' => (int) $store->fresh()->lock_version])->assertOk();
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertOk()->assertJsonPath('data.handler.vendor.role', 'OWNER');
        self::assertSame('REVOKED', (string) DB::table('data_exports')->where('id', $export->id)->value('state'));
        $this->signInStoreMember($inventory);
        $this->getJson('/api/v1/vendor/disputes')->assertForbidden();

        // Assigned Fulfillment Staff may add fulfillment evidence only, never manage the case.
        $this->signInStoreMember($owner);
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'user_id' => $fulfillment->id, 'assigned_by_user_id' => $owner->id,
            'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($fulfillment);
        $this->getJson('/api/v1/vendor/disputes/'.$caseId)->assertOk()->assertJsonPath('data.limited_view', true)->assertJsonPath('data.available_actions', ['ADD_FULFILLMENT_EVIDENCE'])
            ->assertJsonPath('data.description', null);
        $this->post('/api/v1/vendor/disputes/'.$caseId.'/evidence', ['files' => [UploadedFile::fake()->image('handover.png')]], $this->key() + ['Accept' => 'application/json'])->assertCreated();
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/messages', ['body' => 'I can decide this.'], $this->key())->assertForbidden();
        self::assertSame('FULFILLMENT', (string) DB::table('dispute_evidence')->where('dispute_case_id', $caseId)->orderByDesc('created_at')->value('label'));
    }

    // ── FIN-09 invoices ──────────────────────────────────────────────────────────────────────────────

    public function test_invoice_records_are_available_before_completion_with_narrow_upload_scope_reconciliation_requests_and_audited_downloads(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Invoice Store');
        DB::table('vendor_organizations')->where('id', $store->id)->update(['legal_business_name' => 'Invoice Store Trading Corp.']);
        $staff = $this->teamMember($store, 'STORE_STAFF');
        $service = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $inventory = $this->teamMember($store, 'INVENTORY');
        $totalBefore = (int) DB::table('orders')->where('id', $orderId)->value('commercial_total_centavos');

        $this->signInBuyer($buyer);
        $view = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/invoices')->assertOk()->assertJsonPath('data.status', 'NOT_YET_UPLOADED')->assertJsonPath('data.can_request_copy', true)->json('data');
        self::assertSame([true, true], array_column($view['platform_documents'], 'not_tax_invoice'), 'MateryalPH documents are labelled not a tax invoice.');
        self::assertStringContainsString('does not wait for order completion', $view['issuance_notice']);
        $this->putJson('/api/v1/buyers/orders/'.$orderId.'/invoices/details', ['billing_name' => 'Ana Buyer Construction', 'billing_address' => '12 Rizal St, Quezon City', 'tin' => '123-456-789-000'])
            ->assertOk()->assertJsonPath('data.billing_details.tin_masked', '•••• 9000');
        self::assertNotSame('123456789000', DB::table('order_invoice_details')->where('order_id', $orderId)->value('tin_encrypted'));
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/invoices/requests', ['kind' => 'COPY', 'details' => 'Please send the sales invoice copy.'], $this->key())->assertCreated();
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/invoices/requests', ['kind' => 'COPY', 'details' => 'Please send it again.'], $this->key())->assertStatus(409);
        $request = DB::table('invoice_requests')->where('order_id', $orderId)->first();
        self::assertEqualsWithDelta(DisputeRules::addBusinessDays(CarbonImmutable::now(), 3)->timestamp, CarbonImmutable::parse((string) $request->service_target_at)->timestamp, 5, 'Three business days.');

        // Upload scope: Owner/Manager/Store Staff only; Customer Service sees status; Inventory sees nothing.
        $upload = ['invoice_type' => 'VENDOR_GOODS_INVOICE', 'issuer_name' => 'Invoice Store Trading Corp', 'invoice_number' => 'SI-0001', 'issued_on' => CarbonImmutable::now('Asia/Manila')->toDateString(),
            'amount_centavos' => '1000001', 'source_system' => 'REGISTERED_CAS', 'invoicing_method' => 'COMPUTERIZED', 'file' => UploadedFile::fake()->create('invoice.pdf', 10, 'application/pdf')];
        $this->signInStoreMember($service);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/invoices', $upload, $this->key() + ['Accept' => 'application/json'])->assertForbidden();
        $this->getJson('/api/v1/vendor/orders/'.$orderId.'/invoices')->assertOk()->assertJsonPath('data.can_upload', false)->assertJsonPath('data.billing_details.tin', null);
        $this->signInStoreMember($inventory);
        $this->getJson('/api/v1/vendor/orders/'.$orderId.'/invoices')->assertForbidden();
        $this->signInStoreMember($staff);
        $this->post('/api/v1/vendor/orders/'.$orderId.'/invoices', ['issuer_name' => 'Somebody Else Inc', 'file' => $this->validPdf()] + $upload, $this->key() + ['Accept' => 'application/json'])->assertStatus(422)->assertJsonPath('errors.0.code', 'INVOICE_ISSUER_MISMATCH');
        $this->post('/api/v1/vendor/orders/'.$orderId.'/invoices', ['invoice_type' => 'PLATFORM_SERVICE_INVOICE'] + $upload, $this->key() + ['Accept' => 'application/json'])->assertStatus(422);
        $pdf = $this->validPdf();
        $vendorView = $this->post('/api/v1/vendor/orders/'.$orderId.'/invoices', ['file' => $pdf] + $upload, $this->key() + ['Accept' => 'application/json'])->assertCreated()
            ->assertJsonPath('data.records.0.reconciliation_state', 'INVOICE_RECONCILIATION_REQUIRED')->assertJsonPath('data.records.0.origin_label', 'DEMO sample (TEST)')
            ->assertJsonPath('data.records.0.verification_state', 'UNVERIFIED')->assertJsonPath('data.billing_details.tin', '123456789000')->json('data');
        self::assertSame(1000001 - (int) $vendorView['records'][0]['expected_total_centavos'], $vendorView['records'][0]['reconciliation_difference_centavos']);
        self::assertNotSame(0, $vendorView['records'][0]['reconciliation_difference_centavos']);
        self::assertSame($totalBefore, (int) DB::table('orders')->where('id', $orderId)->value('commercial_total_centavos'), 'A difference never changes the accepted Buyer total.');
        self::assertSame('UPLOADED', (string) DB::table('invoice_requests')->where('id', $request->id)->value('state'));
        $this->post('/api/v1/vendor/orders/'.$orderId.'/invoices', ['file' => $this->validPdf()] + $upload, $this->key() + ['Accept' => 'application/json'])->assertStatus(409)->assertJsonPath('errors.0.code', 'INVOICE_NUMBER_DUPLICATE');
        foreach (self::PROTECTED_FINANCE as $key) {
            self::assertStringNotContainsString('"'.$key, json_encode($vendorView, JSON_THROW_ON_ERROR));
        }
        $record = (string) $vendorView['records'][0]['id'];
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/invoices/'.$record.'/explanation', ['note' => 'Rounding on the printed invoice; correction to follow.'], $this->key())->assertOk()
            ->assertJsonPath('data.records.0.reconciliation_state', 'EXPLAINED');
        $this->expectAppendOnly(fn () => DB::table('invoice_records')->where('id', $record)->update(['amount_centavos' => 1]));

        // Audited, short-lived downloads; the Buyer's download moves the request to DOWNLOADED.
        $this->signInBuyer($buyer);
        $link = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/invoices')->assertOk()->assertJsonPath('data.status', 'ISSUED')->json('data.records.0.download.url');
        $this->get($link)->assertOk();
        self::assertSame(['DOWNLOADED', 1], [(string) DB::table('invoice_requests')->where('id', $request->id)->value('state'), DB::table('invoice_record_downloads')->where('audience', 'BUYER')->count()]);
        $this->buyer('outsider@example.test');
        $this->get($link)->assertNotFound();

        // Admin log is read-only and permissioned.
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->getJson('/api/v1/admin/invoices')->assertForbidden();
        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->getJson('/api/v1/admin/invoices?view=RECORDS')->assertOk()->assertJsonPath('data.0.downloads', 1)->assertJsonPath('data.0.compliance_note', fn ($note) => str_contains($note, 'not proof'));

        // A correction request has its own three-business-day target, reminder and overdue notice.
        $this->signInBuyer($buyer);
        $this->postJson('/api/v1/buyers/orders/'.$orderId.'/invoices/requests', ['kind' => 'CORRECTION', 'details' => 'The billing name is misspelled.', 'invoice_record_id' => $record], $this->key())->assertCreated();
        $this->travel(5)->days();
        $counts = app(InvoiceService::class)->sweep();
        self::assertSame(1, $counts['overdue']);
        self::assertSame(1, app(InvoiceService::class)->sweep()['overdue'] + 1, 'The overdue notice is sent once.');
        self::assertNotNull($owner);
    }

    // ── Fixtures ─────────────────────────────────────────────────────────────────────────────────────

    /** @param array<string, mixed> $overrides */
    private function fileCase(User $buyer, string $orderId, array $overrides = [], ?string $key = null): TestResponse
    {
        $this->signInBuyer($buyer);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');

        return $this->post('/api/v1/buyers/disputes', array_replace(['order_id' => $orderId, 'issue_type' => 'DEFECTIVE', 'requested_remedy' => 'REPLACEMENT', 'affected_line_ids' => [$line],
            'description' => 'Two of the hollow blocks arrived cracked at the corners.', 'preferred_contact_channel' => 'IN_APP', 'files' => [UploadedFile::fake()->image('cracked.png')]], $overrides),
            ['Idempotency-Key' => $key ?? (string) Str::uuid7(), 'Accept' => 'application/json']);
    }

    /** @return array<string, string> */
    private function key(): array
    {
        return ['Idempotency-Key' => (string) Str::uuid7()];
    }

    private function validPdf(): UploadedFile
    {
        $path = tempnam(sys_get_temp_dir(), 'inv').'.pdf';
        file_put_contents($path, "%PDF-1.4\n1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n2 0 obj << /Type /Pages /Kids [] /Count 0 >> endobj\ntrailer << /Root 1 0 R >>\n%%EOF\n");

        return new UploadedFile($path, 'invoice.pdf', 'application/pdf', null, true);
    }

    private function expectAppendOnly(callable $mutation): void
    {
        $this->assertThrows(static fn () => DB::transaction(static fn () => $mutation()), QueryException::class);
    }

    /** @return array{0: VendorOrganization, 1: User, 2: User, 3: string, 4: string} */
    private function paidPickup(string $name): array
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment($name);
        $attempt = $this->startPayment($buyer, $orderId);
        $this->completePayment($attempt['id'])->assertOk();
        self::assertSame('CONFIRMED', $this->orderState($orderId));

        return [$store, $owner, $buyer, $orderId, (string) $attempt['id']];
    }

    /** @param array<string, string> $fields */
    private function milestone(User $member, string $orderId, string $milestone, array $fields = []): TestResponse
    {
        $this->signInStoreMember($member);
        $lock = (int) (DB::table('orders')->where('id', $orderId)->value('lock_version') ?? 1);

        return $this->post('/api/v1/vendor/orders/'.$orderId.'/fulfillment/milestones', array_replace(['milestone' => $milestone, 'lock_version' => (string) $lock], $fields),
            ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json']);
    }

    private function toPickedUp(User $owner, string $orderId): void
    {
        $this->milestone($owner, $orderId, 'PROCESSING')->assertOk();
        $this->milestone($owner, $orderId, 'READY_FOR_PICKUP')->assertOk();
        $this->milestone($owner, $orderId, 'PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana Buyer', 'receiver_kind' => 'BUYER'])->assertOk();
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE13ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
