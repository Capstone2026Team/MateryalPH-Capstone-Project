<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Reporting\DocumentExportService;
use App\Domain\Reporting\TaxReminderService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
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

final class PhaseFifteenExportsTest extends TestCase
{
    use CreatesDiscoveryFixtures, CreatesOrderFixtures, CreatesPaymentFixtures, RefreshDatabase;

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

    private function export(string $audience, string $type, string $resource, string $format = 'CSV', ?string $key = null): array
    {
        return $this->postJson('/api/v1/'.$audience.'/reports', ['type' => $type, 'resource_id' => $resource, 'format' => $format, 'purpose' => 'Sample procurement review'], ['Idempotency-Key' => $key ?? (string) Str::uuid7()])->assertAccepted()->json('data');
    }

    public function test_order_snapshot_pdf_csv_idempotency_checksum_expiry_and_foreign_download(): void
    {
        [, , $buyer, $order] = $this->awaitingPayment('Snapshot export');
        Queue::fake();
        $key = (string) Str::uuid7();
        $export = $this->export('buyers', 'PURCHASE_ORDER', $order, 'CSV', $key);
        self::assertSame($export['id'], $this->export('buyers', 'PURCHASE_ORDER', $order, 'CSV', $key)['id']);
        $snapshot = DB::table('data_exports')->where('id', $export['id'])->value('source_snapshot');
        DB::table('orders')->where('id', $order)->increment('lock_version');
        app(DocumentExportService::class)->process($export['id']);
        app(DocumentExportService::class)->process($export['id']);
        self::assertSame($snapshot, DB::table('data_exports')->where('id', $export['id'])->value('source_snapshot'));
        $download = $this->get('/api/v1/buyers/reports/'.$export['id'].'/download')->assertOk()->streamedContent();
        self::assertStringContainsString('NOT A TAX INVOICE', $download);
        self::assertStringContainsString('Source version hash', $download);
        $file = DB::table('files')->where('id', DB::table('data_exports')->where('id', $export['id'])->value('file_id'))->first();
        self::assertSame(hash('sha256', $download), $file->checksum_sha256);
        self::assertSame('PRIVATE', $file->visibility);
        $pdf = $this->export('buyers', 'PURCHASE_ORDER', $order, 'PDF');
        app(DocumentExportService::class)->process($pdf['id']);
        self::assertStringStartsWith('%PDF-', $this->get('/api/v1/buyers/reports/'.$pdf['id'].'/download')->assertOk()->streamedContent());
        $this->buyer();
        $this->getJson('/api/v1/buyers/reports/'.$export['id'].'/download')->assertForbidden();
        $this->signInBuyer($buyer);
        DB::table('data_exports')->where('id', $export['id'])->update(['expires_at' => now()->subMinute()]);
        $this->getJson('/api/v1/buyers/reports/'.$export['id'].'/download')->assertGone()->assertJsonPath('errors.0.code', 'EXPORT_EXPIRED');
    }

    public function test_revoked_membership_blocks_queued_generation_and_ready_download_preserving_audit(): void
    {
        [, $owner, , $order] = $this->awaitingPayment('Revoked export');
        $this->signInStoreMember($owner);
        Queue::fake();
        $ready = $this->export('vendor', 'OPERATIONAL_ORDER', $order);
        app(DocumentExportService::class)->process($ready['id']);
        $queued = $this->export('vendor', 'OPERATIONAL_ORDER', $order);
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['role' => 'FULFILLMENT']);
        app(DocumentExportService::class)->process($queued['id']);
        self::assertSame('REVOKED', DB::table('data_exports')->where('id', $queued['id'])->value('state'));
        $this->getJson('/api/v1/vendor/reports/'.$ready['id'].'/download')->assertForbidden();
        self::assertNotNull(DB::table('data_exports')->where('id', $ready['id'])->value('file_id'));
        self::assertTrue(DB::table('export_access_events')->where('data_export_id', $ready['id'])->where('action', 'ACCESS_DENIED')->exists());
    }

    public function test_tax_packages_require_independent_cited_review_and_are_sample_only(): void
    {
        $preparer = $this->admin();
        $reviewer = $this->admin();
        Queue::fake();
        $this->signInAdmin($preparer);
        $input = ['form' => '1601-EQ', 'period_start' => '2026-07-01', 'withholding_entity' => 'DEMO_PLATFORM_WITHHOLDER'];
        $key = ['Idempotency-Key' => (string) Str::uuid7()];
        $draft = $this->postJson('/api/v1/admin/reports/tax', $input, $key)->assertCreated()->assertJsonPath('data.nominal_due_date', '2026-10-31')->assertJsonPath('data.due_date_status', 'DUE_DATE_REVIEW_REQUIRED')->json('data');
        $this->postJson('/api/v1/admin/reports/tax', $input, $key)->assertCreated()->assertJsonPath('data.id', $draft['id']);
        $review = ['lock_version' => 1, 'actual_due_date' => '2026-11-02', 'due_date_source' => 'Demo deadline review fixture', 'reason' => 'Independent reconciliation of the sample period', 'reconciled' => true];
        $this->postJson('/api/v1/admin/reports/tax/'.$draft['id'].'/review', $review)->assertForbidden()->assertJsonPath('errors.0.code', 'INDEPENDENT_REVIEW_REQUIRED');
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/reports/tax/'.$draft['id'].'/review', $review)->assertOk()->assertJsonPath('data.due_date_reviewer_id', $reviewer->id);
        $export = $this->export('admin', 'TAX_PACKAGE', $draft['id']);
        app(DocumentExportService::class)->process($export['id']);
        self::assertStringContainsString('NOT FOR BIR FILING', $this->get('/api/v1/admin/reports/'.$export['id'].'/download')->assertOk()->streamedContent());
        $this->postJson('/api/v1/admin/reports/tax/'.$draft['id'].'/simulation')->assertOk()->assertJsonPath('data.authentic_evidence', false);
        DB::table('admin_memberships')->where('user_id', $reviewer->id)->update(['platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPPORT')->value('id')]);
        $this->getJson('/api/v1/admin/reports/'.$export['id'].'/download')->assertForbidden();
    }

    public function test_paid_confirmation_and_tax_sources_preserve_calendar_month_atc_and_versions(): void
    {
        [$store, , $buyer, $order] = $this->awaitingPayment('Paid document');
        $payment = $this->startPayment($buyer, $order);
        $this->completePayment($payment['id'])->assertOk();
        Queue::fake();
        $export = $this->export('buyers', 'PAYMENT_CONFIRMATION', $order);
        app(DocumentExportService::class)->process($export['id']);
        self::assertStringContainsString($payment['id'], $this->get('/api/v1/buyers/reports/'.$export['id'].'/download')->assertOk()->streamedContent());
        $assessment = DB::table('remittance_assessments')->where('order_id', $order)->sole();
        self::assertNotNull($assessment->tax_profile_version_id);
        self::assertContains($assessment->reporting_atc, ['WI820', 'WC820', 'WI830', 'WC830']);
        $this->signInAdmin($this->admin());
        $draft = $this->postJson('/api/v1/admin/reports/tax', ['form' => '2307', 'period_start' => now('Asia/Manila')->startOfQuarter()->toDateString(), 'withholding_entity' => $assessment->assigned_withholding_entity, 'vendor_organization_id' => $store->id], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        self::assertSame($assessment->reporting_atc, $draft['snapshot']['versions']['assessments'][0]['atc']);
        self::assertSame(now('Asia/Manila')->format('Y-m'), $draft['snapshot']['versions']['assessments'][0]['month']);
        self::assertSame((int) $assessment->gross_basis_centavos, $draft['snapshot']['basis_centavos']);
        self::assertSame($assessment->reporting_atc, $draft['snapshot']['monthly_totals'][0]['atc']);
        self::assertSame((int) $assessment->gross_basis_centavos, $draft['snapshot']['monthly_totals'][0]['basis_centavos']);
    }

    public function test_project_documents_capture_the_authorized_budget_and_version(): void
    {
        $buyer = $this->buyer();
        $this->signInBuyer($buyer);
        $site = $this->savedLocation($buyer, 'Project export site', 0, 0, 'PROJECT_SITE');
        $project = $this->postJson('/api/v1/buyers/projects', ['name' => 'Sample construction', 'budget_centavos' => 125001, 'starts_on' => now()->toDateString(), 'ends_on' => now()->addMonth()->toDateString(), 'location_id' => $site], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        Queue::fake();
        foreach (['PROJECT_SUMMARY', 'BUDGET_REPORT'] as $type) {
            $export = $this->export('buyers', $type, $project['id']);
            app(DocumentExportService::class)->process($export['id']);
            $csv = $this->get('/api/v1/buyers/reports/'.$export['id'].'/download')->assertOk()->streamedContent();
            self::assertStringContainsString('1250.01', $csv);
            self::assertSame($project['lock_version'], $export['source_versions']->version ?? $export['source_versions']['version']);
        }
    }

    public function test_tax_reminders_keep_fifteen_seven_one_day_and_overdue_cadence_and_deduplicate(): void
    {
        $admin = $this->admin();
        $this->signInAdmin($admin);
        Queue::fake();
        $draft = $this->postJson('/api/v1/admin/reports/tax', ['form' => '1601-EQ', 'period_start' => '2026-07-01', 'withholding_entity' => 'DEMO_PLATFORM_WITHHOLDER'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data');
        $due = CarbonImmutable::parse($draft['nominal_due_date'], 'Asia/Manila');
        $expected = 0;
        foreach ([16, 15, 14, 7, 6, 1, 0, -1, -2] as $days) {
            $this->travelTo($due->subDays($days)->setTime(8, 0));
            app(TaxReminderService::class)->sweep();
            app(TaxReminderService::class)->sweep();
            if (in_array($days, [15, 7, 1, -1], true)) {
                $expected++;
            }
            self::assertSame($expected, DB::table('notifications')->where('resource_type', 'TAX_REPORT_PACKAGE')->where('resource_id', $draft['id'])->count());
        }
        self::assertStringContainsString('DUE_DATE_REVIEW_REQUIRED', DB::table('notifications')->where('resource_id', $draft['id'])->value('body'));
        $this->travelBack();
    }

    public function test_database_refuses_export_snapshot_rewrites_and_access_history_deletion(): void
    {
        [, , , $order] = $this->awaitingPayment('Immutable document');
        Queue::fake();
        $export = $this->export('buyers', 'PURCHASE_ORDER', $order);
        app(DocumentExportService::class)->process($export['id']);
        foreach ([fn () => DB::table('data_exports')->where('id', $export['id'])->update(['source_hash' => str_repeat('0', 64)]),
            fn () => DB::table('export_access_events')->where('data_export_id', $export['id'])->delete()] as $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Immutable history must reject mutation.');
            } catch (QueryException $exception) {
                self::assertSame('P0001', $exception->errorInfo[0]);
            }
        }
        self::assertSame($export['source_hash'], DB::table('data_exports')->where('id', $export['id'])->value('source_hash'));
    }

    private function admin(): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString('PHASE15SYNTHETIC'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
