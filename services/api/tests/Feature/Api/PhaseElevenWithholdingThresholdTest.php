<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\CreatesWithholdingFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * FIN-04A acceptance fixtures (Technical Design delta §7) against live PostgreSQL, in exact centavos. Fixture 8
 * (two concurrent settlements) runs in PhaseElevenThresholdConcurrencyTest with two real database sessions.
 */
final class PhaseElevenWithholdingThresholdTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use CreatesWithholdingFixtures;
    use RefreshDatabase;

    private VendorOrganization $store;

    private User $owner;

    private string $orderId;

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
        [$this->store, $this->owner, , $this->orderId] = $this->awaitingPayment('Threshold Hardware');
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    public function test_fixtures_1_and_2_relief_holds_up_to_and_exactly_at_the_limit(): void
    {
        $this->grantRelief($this->store->id);
        $this->seedAccumulator($this->store->id, 49000000, 'RELIEF_ACTIVE');
        $first = $this->assessGroup($this->store->id, $this->orderId, 'F1', 100000);
        self::assertSame([49100000, 'RELIEF_ACTIVE', 0, 0], [(int) $first->g_effective_after_centavos, $first->threshold_status_after, (int) $first->withheld_centavos, (int) $first->effective_rate_basis_points]);
        self::assertNotNull($first->relief_basis_id);

        $second = $this->assessGroup($this->store->id, $this->orderId, 'F2', 900000);
        self::assertSame([50000000, 'RELIEF_ACTIVE', 0], [(int) $second->g_effective_after_centavos, $second->threshold_status_after, (int) $second->withheld_centavos], 'Exactly ₱500,000.00 is not a breach.');
        self::assertNull($this->accumulatorFor($this->store->id)->crossed_at);
    }

    public function test_fixtures_3_5_and_6_one_centavo_over_taxes_the_whole_group_and_stays_breached_despite_a_new_declaration(): void
    {
        $this->grantRelief($this->store->id);
        $this->seedAccumulator($this->store->id, 49900000, 'RELIEF_ACTIVE');
        $crossing = $this->assessGroup($this->store->id, $this->orderId, 'F3', 100001);
        self::assertSame([49900000, 50000001, 'RELIEF_ACTIVE', 'SUBJECT_THRESHOLD_BREACHED', 500], [(int) $crossing->g_effective_before_centavos, (int) $crossing->g_effective_after_centavos,
            $crossing->threshold_status_before, $crossing->threshold_status_after, (int) $crossing->withheld_centavos]);
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertSame(['SUBJECT_THRESHOLD_BREACHED', 'THRESHOLD_CROSSED', $crossing->id], [$accumulator->withholding_status, $accumulator->status_reason_code, $accumulator->crossing_assessment_id]);
        self::assertNotNull($accumulator->crossed_at);
        self::assertSame(1, DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->where('to_status', 'SUBJECT_THRESHOLD_BREACHED')->count());

        // Fixture 5: the next remittance is taxed without re-evaluating any declaration.
        $next = $this->assessGroup($this->store->id, $this->orderId, 'F5', 50000);
        self::assertSame(['SUBJECT_THRESHOLD_BREACHED', 250], [$next->threshold_status_after, (int) $next->withheld_centavos]);

        // Fixture 6: a fresh BIR-received declaration uploaded and even approved after crossing changes nothing.
        $evidence = $this->declaration($this->store->id, 'APPROVED', $this->owner->id);
        self::assertSame('ACKNOWLEDGED_NO_EFFECT', app(WithholdingThresholdService::class)->declarationRecorded($this->store->id, $evidence, 'VENDOR', $this->owner->id, (string) Str::uuid7()));
        self::assertSame('ACKNOWLEDGED_NO_EFFECT', app(WithholdingThresholdService::class)->reliefBasisApproved($this->store->id, $evidence, $this->owner->id, (string) Str::uuid7()));
        self::assertSame(1, DB::table('audit_logs')->where('action', 'WITHHOLDING_DECLARATION_AFTER_CROSSING_ACKNOWLEDGED')->count(), 'One audit event for the stored declaration.');
        self::assertSame('SUBJECT_THRESHOLD_BREACHED', $this->accumulatorFor($this->store->id)->withholding_status);
        self::assertSame(250, (int) $this->assessGroup($this->store->id, $this->orderId, 'F6', 50000)->withheld_centavos);

        // The crossing is final: the database refuses to forget it or lower the posted total.
        $this->expectException(QueryException::class);
        DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->update(['withholding_status' => 'RELIEF_ACTIVE', 'crossed_at' => null]);
    }

    public function test_fixture_4_the_whole_crossing_remittance_is_taxed_not_the_excess_and_the_owner_alone_is_notified(): void
    {
        $manager = $this->teamMember($this->store, 'STORE_MANAGER');
        $this->grantRelief($this->store->id);
        $this->seedAccumulator($this->store->id, 49900000, 'RELIEF_ACTIVE');
        $crossing = $this->assessGroup($this->store->id, $this->orderId, 'F4', 200000);
        self::assertSame([50100000, 'SUBJECT_THRESHOLD_BREACHED', 1000], [(int) $crossing->g_effective_after_centavos, $crossing->threshold_status_after, (int) $crossing->withheld_centavos]);
        self::assertSame(1, DB::table('notifications')->where('user_id', $this->owner->id)->where('category', 'FINANCE_MANDATORY')->count(), 'Mandatory, non-disableable notice on the flip.');
        self::assertSame(0, DB::table('notifications')->where('user_id', $manager->id)->whereIn('category', ['FINANCE', 'FINANCE_MANDATORY'])->count(), 'Finance notices are Owner-only.');
    }

    public function test_fixture_7_and_9_no_declaration_is_subject_and_a_repeated_group_returns_the_stored_result(): void
    {
        $first = $this->assessGroup($this->store->id, $this->orderId, 'F7', 200000);
        self::assertSame(['SUBJECT_STANDARD', 1000, 200000], [$first->threshold_status_after, (int) $first->withheld_centavos, (int) $first->g_effective_after_centavos]);
        self::assertSame('NO_DECLARATION', $this->accumulatorFor($this->store->id)->status_reason_code);

        $again = $this->assessGroup($this->store->id, $this->orderId, 'F7', 200000);
        self::assertSame($first->id, $again->id);
        self::assertSame(200000, (int) $this->accumulatorFor($this->store->id)->g_accumulated_centavos, 'A retry never increments the counter.');
        self::assertSame(1, DB::table('remittance_assessments')->count());
    }

    public function test_fixture_10_year_rollover_starts_subject_prior_year_when_the_prior_year_closed_above_the_threshold(): void
    {
        $year = (int) $this->taxpayer($this->store->id)['taxable_year'];
        $this->seedAccumulator($this->store->id, 51000000, 'SUBJECT_THRESHOLD_BREACHED', 'THRESHOLD_CROSSED', $year - 1);
        $this->grantRelief($this->store->id);
        $first = $this->assessGroup($this->store->id, $this->orderId, 'F10', 100000);
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertSame(['SUBJECT_PRIOR_YEAR', 'PRIOR_YEAR_BREACH', 51000000, 0], [$accumulator->withholding_status, $accumulator->status_reason_code, (int) $accumulator->prior_year_total_centavos, $accumulator->crossed_at === null ? 0 : 1]);
        self::assertSame(['SUBJECT_PRIOR_YEAR', 500], [$first->threshold_status_after, (int) $first->withheld_centavos], 'January never grants a fresh automatic allowance, even with an older declaration.');
        self::assertSame(1, DB::table('notifications')->where('user_id', $this->owner->id)->where('category', 'FINANCE_MANDATORY')->count());

        // Only an Admin-reviewed relief basis for the new year leaves SUBJECT_PRIOR_YEAR, with an ADMIN event.
        $evidence = $this->declaration($this->store->id, 'APPROVED', $this->owner->id);
        self::assertSame('RELIEF_ACTIVE', app(WithholdingThresholdService::class)->reliefBasisApproved($this->store->id, $evidence, 1, (string) Str::uuid7()));
        self::assertSame('ADMIN', DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->orderByDesc('occurred_at')->value('actor_type'));

        // The scheduled rollover creates next year's accumulator once.
        $this->travelTo(CarbonImmutable::create($year + 1, 1, 1, 0, 30, 0, 'Asia/Manila'));
        self::assertSame(1, app(WithholdingThresholdService::class)->rollover(CarbonImmutable::now()));
        self::assertSame(0, app(WithholdingThresholdService::class)->rollover(CarbonImmutable::now()));
        $next = DB::table('vendor_withholding_accumulators')->where('taxable_year', $year + 1)->first();
        self::assertSame([0, 100000], [(int) $next->g_accumulated_centavos, (int) $next->prior_year_total_centavos]);
    }

    public function test_fixture_11_a_declared_outside_platform_total_breaches_on_the_first_remittance(): void
    {
        $this->grantRelief($this->store->id);
        $this->taxDetails($this->store->id, ['outside_platform_amount_centavos' => 60000000, 'outside_platform_overlap' => false]);
        $first = $this->assessGroup($this->store->id, $this->orderId, 'F11', 100000);
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertSame([60000000, 60100000, 'SUBJECT_THRESHOLD_BREACHED', 'EXTERNAL_BREACH_REPORTED', 500], [(int) $accumulator->g_external_declared_centavos, (int) $accumulator->g_effective_centavos,
            $accumulator->withholding_status, $accumulator->status_reason_code, (int) $first->withheld_centavos]);
    }

    public function test_fixture_12_unresolved_overlap_is_under_review_assessed_at_standard_and_queued_for_admin(): void
    {
        $this->grantRelief($this->store->id);
        $this->taxDetails($this->store->id, ['outside_platform_amount_centavos' => 30000000, 'outside_platform_overlap' => true]);
        $first = $this->assessGroup($this->store->id, $this->orderId, 'F12', 100000);
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertSame(['UNDER_REVIEW', 'OVERLAP_UNRESOLVED', 'UNRESOLVED', 500], [$accumulator->withholding_status, $accumulator->status_reason_code, $accumulator->external_overlap_state, (int) $first->withheld_centavos]);
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'OVERLAP_UNRESOLVED')->where('state', 'OPEN')->count());

        // The reviewer records the represented part; the effective total and reviewed relief decide the status.
        $resolved = app(WithholdingThresholdService::class)->resolveOverlap($accumulator->id, 100000, (int) $accumulator->lock_version, $this->owner->id, 'The declared total already includes this platform remittance.', (string) Str::uuid7());
        self::assertSame(['RELIEF_ACTIVE', 30000000, 'RESOLVED'], [$resolved->withholding_status, (int) $resolved->g_effective_centavos, $resolved->external_overlap_state]);
        self::assertSame(0, DB::table('finance_review_items')->where('kind', 'OVERLAP_UNRESOLVED')->where('state', 'OPEN')->count());
    }

    public function test_fixture_13_a_full_refund_of_the_crossing_order_opens_an_adjustment_and_never_restores_relief(): void
    {
        $this->grantRelief($this->store->id);
        $this->seedAccumulator($this->store->id, 49900000, 'RELIEF_ACTIVE');
        $crossing = $this->assessGroup($this->store->id, $this->orderId, 'F13', 200000);
        $adjustment = app(RemittanceAssessmentService::class)->openAdjustmentForRefund($crossing->id, null, 200000, 'Full refund of the crossing order after remittance.');
        self::assertSame($adjustment, app(RemittanceAssessmentService::class)->openAdjustmentForRefund($crossing->id, null, 200000, 'Retry'));
        $row = DB::table('tax_adjustments')->where('id', $adjustment)->first();
        self::assertSame(['ADJUSTMENT_REQUIRED', 'SYSTEM', null], [$row->state, $row->opened_by, $row->prepared_by_user_id]);
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertSame(['SUBJECT_THRESHOLD_BREACHED', 50100000], [$accumulator->withholding_status, (int) $accumulator->g_accumulated_centavos]);
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'THRESHOLD_ADJUSTMENT_REQUIRED')->count());
        self::assertSame(1000, (int) DB::table('remittance_assessments')->where('id', $crossing->id)->value('withheld_centavos'), 'No automatic reversal of a posted assessment.');
        $this->expectException(QueryException::class);
        DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->update(['g_accumulated_centavos' => 49900000]);
    }

    public function test_advisory_notice_at_80_percent_is_sent_once_and_status_events_are_append_only(): void
    {
        $this->grantRelief($this->store->id);
        $this->seedAccumulator($this->store->id, 39000000, 'RELIEF_ACTIVE');
        $this->assessGroup($this->store->id, $this->orderId, 'A1', 1000000);
        $this->assessGroup($this->store->id, $this->orderId, 'A2', 100000);
        self::assertSame(1, DB::table('notifications')->where('user_id', $this->owner->id)->where('category', 'FINANCE')->where('title', 'like', '%80%')->count());
        $accumulator = $this->accumulatorFor($this->store->id);
        self::assertNotNull($accumulator->advisory_notified_at);
        $crossing = $this->assessGroup($this->store->id, $this->orderId, 'A3', 9900001);
        self::assertSame(50000001, (int) $crossing->g_effective_after_centavos);
        self::assertSame('SUBJECT_THRESHOLD_BREACHED', $crossing->threshold_status_after);
        self::assertSame(1, DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->count());
        $this->expectException(QueryException::class);
        DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->update(['reason_code' => 'EDITED']);
    }

    public function test_posted_assessment_amounts_are_immutable_and_a_negative_base_needs_review(): void
    {
        $assessment = $this->assessGroup($this->store->id, $this->orderId, 'I1', 100000);
        DB::table('remittance_assessments')->where('id', $assessment->id)->update(['reconciliation_state' => 'RECONCILED']);
        $snapshot = (string) DB::table('financial_snapshots')->where('order_id', $this->orderId)->value('id');
        $negative = app(RemittanceAssessmentService::class)->assess(['environment' => 'TEST', 'organization_id' => $this->store->id, 'order_id' => $this->orderId, 'financial_snapshot_id' => $snapshot,
            'payment_id' => null, 'group_key' => 'NEG', 'instant' => CarbonImmutable::now(), 'evidence_origin' => 'SIMULATED', 'collected' => 100, 'refunds' => 0, 'delivery' => 500, 'vat' => 0,
            'provider_charge' => 0, 'principal' => 100, 'basis' => []], (string) Str::uuid7());
        self::assertSame('BASE_REVIEW_REQUIRED', DB::table('remittance_assessments')->where('id', $negative)->value('calculation_state'));
        self::assertSame(100000, (int) $this->accumulatorFor($this->store->id)->g_accumulated_centavos, 'A base under review never touches the counter.');
        self::assertSame(1, DB::table('finance_review_items')->where('kind', 'BASE_REVIEW_REQUIRED')->count());
        $this->expectException(QueryException::class);
        DB::table('remittance_assessments')->where('id', $assessment->id)->update(['withheld_centavos' => 0]);
    }

    public function test_provider_withholder_alternate_records_the_deduction_once_and_reconciles_expected_versus_reported(): void
    {
        $this->taxDetails($this->store->id, ['withholding_scenario' => 'DEMO_PROVIDER_WITHHOLDER']);
        $assessment = $this->assessGroup($this->store->id, $this->orderId, 'P1', 200000);
        self::assertSame(['DEMO_PROVIDER_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER', 1000, 1000, 'RECONCILED', 'SIMULATED_WITHHELD'], [$assessment->withholding_scenario, $assessment->deduction_actor,
            (int) $assessment->withheld_centavos, (int) $assessment->reported_withheld_centavos, $assessment->reconciliation_state, $assessment->deduction_evidence_state]);
        $cwt = DB::table('financial_ledger_entries')->where('source_id', $assessment->id)->where('account_code', 'CWT_CONTROL')->get();
        self::assertCount(1, $cwt, 'One deduction event, never a second platform deduction.');
        self::assertSame('DEMO_PROVIDER', $cwt[0]->actor_role);
    }
}
