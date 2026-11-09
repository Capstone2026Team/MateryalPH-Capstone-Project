<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\FinancialLedgerService;
use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\RemittanceReconciliationService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Jobs\ProcessOutboxEvent;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class RemittanceReconciliationTest extends TestCase
{
    use CreatesDiscoveryFixtures, CreatesOrderFixtures, CreatesPaymentFixtures, RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        config()->set('finance.withholding_scenario', 'DEMO_PLATFORM_WITHHOLDER');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
        $this->fakePayments();
    }

    public function test_outbox_reconciles_matching_recorded_flow_once_without_rewriting_money_or_claiming_real_evidence(): void
    {
        $assessment = $this->assessment();
        $before = $this->moneyHistory();
        $event = DB::table('outbox_events')->where('event_type', 'REMITTANCE_RECONCILIATION_REQUESTED')->where('aggregate_id', $assessment->id)->sole();
        app(OutboxProcessor::class)->process((string) $event->id);
        app(OutboxProcessor::class)->process((string) $event->id);
        self::assertSame('SKIPPED', app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id));
        self::assertSame('RECONCILED', DB::table('remittance_assessments')->where('id', $assessment->id)->value('reconciliation_state'));
        self::assertSame('SIMULATED_WITHHELD', DB::table('remittance_assessments')->where('id', $assessment->id)->value('deduction_evidence_state'));
        self::assertNull(DB::table('remittance_assessments')->where('id', $assessment->id)->value('reported_withheld_centavos'));
        $decision = DB::table('remittance_reconciliation_decisions')->sole();
        self::assertSame(['AUTOMATIC', 'SYSTEM', null], [$decision->method, $decision->actor_role, $decision->actor_user_id]);
        self::assertSame('SIMULATED', json_decode($decision->evidence, true)['origin']);
        self::assertSame(1, DB::table('audit_logs')->where('action', 'REMITTANCE_RECONCILED')->where('resource_id', $assessment->id)->count());
        self::assertSame($before, $this->moneyHistory());
        self::assertSame(0, DB::table('external_filing_evidence')->count());
    }

    public function test_scheduled_command_recovers_missed_records_and_is_safe_to_repeat(): void
    {
        $assessment = $this->assessment();
        $this->artisan('materyalph:remittances-reconcile')->assertExitCode(0);
        $this->artisan('materyalph:remittances-reconcile')->assertExitCode(0);
        self::assertSame('RECONCILED', DB::table('remittance_assessments')->where('id', $assessment->id)->value('reconciliation_state'));
        self::assertSame(1, DB::table('remittance_reconciliation_decisions')->count());
    }

    /** @return array<string, array{string}> */
    public static function approverRoles(): array
    {
        return ['Superadmin' => ['ADMIN_SUPERADMIN'], 'Accountant using Finance Admin' => ['ADMIN_FINANCE']];
    }

    #[DataProvider('approverRoles')]
    public function test_backup_approval_requires_fresh_source_and_is_idempotent_for_the_two_authorized_roles(string $role): void
    {
        $assessment = $this->assessment();
        $before = $this->moneyHistory();
        $this->signInAdmin($this->admin($role));
        $row = $this->getJson('/api/v1/admin/finance/remittances?reconciliation_state=PENDING')->assertOk()->assertJsonPath('data.0.can_approve_reconciliation', true)->json('data.0');
        $body = ['source_version' => $row['source_version'], 'reason' => 'Checked the recorded collection and ledger after the automatic worker was interrupted.'];
        $url = '/api/v1/admin/finance/remittances/'.$assessment->id.'/approve-reconciliation';
        $this->postJson($url, $body)->assertUnprocessable()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_KEY_REQUIRED');
        $this->postJson($url, ['source_version' => str_repeat('0', 64), 'reason' => $body['reason']], ['Idempotency-Key' => 'stale-approval-key'])->assertConflict()->assertJsonPath('errors.0.code', 'SOURCE_VERSION_CHANGED');
        $headers = ['Idempotency-Key' => 'stable-approval-key'];
        $first = $this->postJson($url, $body, $headers)->assertOk()->assertJsonPath('data.method', 'BACKUP_APPROVAL')->assertJsonPath('data.actor_role', $role)
            ->assertJsonPath('data.environment', 'TEST')->assertJsonPath('data.origin', 'SIMULATED')->json('data');
        $this->postJson($url, $body, $headers)->assertOk()->assertJsonPath('data.id', $first['id']);
        $this->postJson($url, ['source_version' => $body['source_version'], 'reason' => 'A different approval request with a reused key.'], $headers)->assertConflict()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_CONFLICT');
        self::assertSame(1, DB::table('remittance_reconciliation_decisions')->count());
        self::assertSame($before, $this->moneyHistory());
        $this->getJson('/api/v1/admin/finance/remittances?reconciliation_state=RECONCILED')->assertOk()
            ->assertJsonPath('data.0.can_approve_reconciliation', false)->assertJsonPath('data.0.reconciliation_method', 'BACKUP_APPROVAL');
    }

    public function test_automatic_mismatch_creates_one_exception_and_backup_cannot_override_it(): void
    {
        $assessment = $this->assessment();
        DB::table('remittance_assessments')->where('id', $assessment->id)->update(['reported_withheld_centavos' => (int) $assessment->withheld_centavos + 1]);
        self::assertSame('RECONCILIATION_EXCEPTION', app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id));
        app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id);
        self::assertSame(1, DB::table('finance_review_items')->where('reason_code', 'AUTOMATIC_REMITTANCE_CHECK_FAILED')->count());
        $this->signInAdmin($this->admin());
        $row = $this->getJson('/api/v1/admin/finance/remittances?reconciliation_state=RECONCILIATION_EXCEPTION')->assertOk()->json('data.0');
        $this->postJson('/api/v1/admin/finance/remittances/'.$assessment->id.'/approve-reconciliation', ['source_version' => $row['source_version'], 'reason' => 'This approval must not ignore a one-centavo mismatch.'], ['Idempotency-Key' => 'mismatched-approval-key'])
            ->assertUnprocessable()->assertJsonPath('errors.0.code', 'REMITTANCE_EVIDENCE_MISMATCH');
        self::assertSame(0, DB::table('remittance_reconciliation_decisions')->count());
        self::assertSame('RECONCILIATION_EXCEPTION', DB::table('remittance_assessments')->where('id', $assessment->id)->value('reconciliation_state'));
    }

    public function test_open_tax_adjustments_and_voided_assessments_do_not_auto_reconcile(): void
    {
        $assessment = $this->assessment();
        app(RemittanceAssessmentService::class)->openAdjustmentForRefund((string) $assessment->id, null, 100, 'Synthetic refund requires an independent tax adjustment review.');
        self::assertSame('RECONCILIATION_EXCEPTION', app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id));
        $voided = $this->assessment('Voided reconciliation source');
        DB::table('remittance_assessments')->where('id', $voided->id)->update(['calculation_state' => 'VOIDED']);
        self::assertSame('SKIPPED', app(RemittanceReconciliationService::class)->reconcile((string) $voided->id));
        self::assertSame(0, DB::table('remittance_reconciliation_decisions')->count());
    }

    public function test_duplicate_deduction_entries_are_an_exception_and_are_never_silently_reconciled(): void
    {
        $assessment = $this->assessment();
        DB::transaction(function () use ($assessment): void {
            app(FinancialLedgerService::class)->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_CWT', 'SYNTHETIC_DUPLICATE_CWT', [
                FinancialLedgerService::debit('VENDOR_PAYABLE', (int) $assessment->withheld_centavos, 'ASSESSMENT', (string) $assessment->id),
                FinancialLedgerService::credit('CWT_CONTROL', (int) $assessment->withheld_centavos, 'ASSESSMENT', (string) $assessment->id),
            ], (string) Str::uuid7());
        });
        $before = $this->moneyHistory();
        self::assertSame('RECONCILIATION_EXCEPTION', app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id));
        self::assertSame($before, $this->moneyHistory());
        self::assertSame(0, DB::table('remittance_reconciliation_decisions')->count());
        self::assertStringContainsString('LEDGER_MISMATCH:SIMULATED_CWT', DB::table('finance_review_items')->where('source_id', $assessment->id)->value('reported'));
    }

    public function test_other_roles_cannot_approve_even_with_a_copied_permission_and_recent_authentication_is_required(): void
    {
        $assessment = $this->assessment();
        $staff = $this->admin('ADMIN_SUPPORT');
        $role = DB::table('platform_roles')->where('code', 'ADMIN_SUPPORT')->value('id');
        foreach (['finance.view', RemittanceReconciliationService::PERMISSION] as $permission) {
            DB::table('role_permissions')->insertOrIgnore(['id' => (string) Str::uuid7(), 'platform_role_id' => $role, 'permission_id' => DB::table('permissions')->where('code', $permission)->value('id'), 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->signInAdmin($staff);
        $url = '/api/v1/admin/finance/remittances/'.$assessment->id.'/approve-reconciliation';
        $body = ['source_version' => RemittanceReconciliationService::version($assessment), 'reason' => 'An unrelated staff role must not be able to approve.'];
        $this->getJson('/api/v1/admin/finance/remittances')->assertOk()->assertJsonPath('data.0.can_approve_reconciliation', false);
        $this->postJson($url, $body, ['Idempotency-Key' => 'forbidden-approval-key'])->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        $admin = $this->admin();
        $this->signInAdmin($admin);
        AuthSession::query()->where('user_id', $admin->id)->update(['reauthenticated_at' => now()->subMinutes(16)]);
        $this->postJson($url, $body, ['Idempotency-Key' => 'expired-auth-approval'])->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        self::assertSame(0, DB::table('remittance_reconciliation_decisions')->count());
    }

    public function test_an_automatic_decision_wins_a_stale_backup_request_and_decisions_are_append_only(): void
    {
        $assessment = $this->assessment();
        $version = RemittanceReconciliationService::version($assessment);
        app(RemittanceReconciliationService::class)->reconcile((string) $assessment->id);
        $this->signInAdmin($this->admin());
        $this->postJson('/api/v1/admin/finance/remittances/'.$assessment->id.'/approve-reconciliation', ['source_version' => $version, 'reason' => 'The automatic process completed before this backup request.'], ['Idempotency-Key' => 'race-approval-request'])->assertConflict();
        foreach ([fn () => DB::table('remittance_reconciliation_decisions')->update(['reason' => 'Rewrite history']), fn () => DB::table('remittance_reconciliation_decisions')->delete()] as $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Reconciliation decisions must be append-only.');
            } catch (QueryException $exception) {
                self::assertSame('P0001', $exception->errorInfo[0]);
            }
        }
        self::assertSame(1, DB::table('remittance_reconciliation_decisions')->count());
    }

    public function test_a_finance_admin_loses_backup_access_when_permission_or_membership_is_revoked(): void
    {
        $assessment = $this->assessment();
        $admin = $this->admin('ADMIN_FINANCE');
        $this->signInAdmin($admin);
        $role = DB::table('platform_roles')->where('code', 'ADMIN_FINANCE')->value('id');
        $permission = DB::table('permissions')->where('code', RemittanceReconciliationService::PERMISSION)->value('id');
        DB::table('role_permissions')->where('platform_role_id', $role)->where('permission_id', $permission)->delete();
        $url = '/api/v1/admin/finance/remittances/'.$assessment->id.'/approve-reconciliation';
        $body = ['source_version' => RemittanceReconciliationService::version($assessment), 'reason' => 'Approval requires the currently active role and grant.'];
        $this->postJson($url, $body, ['Idempotency-Key' => 'revoked-permission-key'])->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
        DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $role, 'permission_id' => $permission, 'created_at' => now(), 'updated_at' => now()]);
        DB::table('admin_memberships')->where('user_id', $admin->id)->update(['status' => 'INACTIVE']);
        $this->postJson($url, $body, ['Idempotency-Key' => 'revoked-membership-key'])->assertForbidden();
        self::assertSame(0, DB::table('remittance_reconciliation_decisions')->count());
    }

    private function assessment(string $name = 'Reconciliation sample'): object
    {
        [, , $buyer, $order] = $this->awaitingPayment($name);
        $payment = $this->startPayment($buyer, $order);
        // Simulate an unavailable outbox worker; authoritative payment recovery still records the paid collection.
        Queue::fake([ProcessOutboxEvent::class]);
        $this->completePayment($payment['id'])->assertOk();
        app(PaymentReconciliationService::class)->reconcile($payment['id']);
        app(RemittanceAssessmentService::class)->assessCollection($payment['id']);

        return DB::table('remittance_assessments')->where('order_id', $order)->sole();
    }

    private function moneyHistory(): string
    {
        return hash('sha256', json_encode([
            DB::table('remittance_assessments')->orderBy('id')->get(['id', 'collections_centavos', 'gross_basis_centavos', 'withheld_centavos', 'expected_vendor_cash_centavos', 'tax_profile_version_id', 'effective_rate_basis_points']),
            DB::table('financial_ledger_entries')->orderBy('id')->get(), DB::table('vendor_withholding_accumulators')->orderBy('id')->get(),
        ], JSON_THROW_ON_ERROR));
    }

    private function admin(string $role = 'ADMIN_SUPERADMIN'): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString('SYNTHETICREMCON'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
