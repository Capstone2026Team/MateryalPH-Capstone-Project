<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Compliance\ComplianceTextExtractor;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Enforcement\EnforcementService;
use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Settings\PlatformSettingRegistry;
use App\Domain\Settings\PlatformSettings;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Jobs\ProcessOutboxEvent;
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
use Illuminate\Support\Facades\Queue;
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
 * Phase 16 acceptance across the new Admin queues: preserved case and history identity, exact decision targets,
 * stale conflicts, source-specific activation restrictions, no provider-ready override, role permissions and
 * private-data suppression — plus versioned Platform Settings wired to new records, append-only audit search and
 * Integration and Job Health retries.
 */
final class PhaseSixteenAdminOperationsTest extends TestCase
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

    public function test_admin_dated_queues_validate_the_range_and_query_their_timestamp_fields(): void
    {
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $paths = ['/api/v1/admin/enforcement', '/api/v1/admin/integrations/failures',
            '/api/v1/admin/integrations/failures?kind=JOBS', '/api/v1/admin/budget-overrides', '/api/v1/admin/finance/kpis',
            '/api/v1/admin/finance/remittances', '/api/v1/admin/finance/evidence', '/api/v1/admin/finance/tax-adjustments',
            '/api/v1/admin/finance/payments', '/api/v1/admin/finance/review-items', '/api/v1/admin/finance/statements',
            '/api/v1/admin/order-operations/refunds', '/api/v1/admin/order-operations/reimbursements',
            '/api/v1/admin/order-operations/cancellation-requests', '/api/v1/admin/disputes', '/api/v1/admin/reviews',
            '/api/v1/admin/product-compliance', '/api/v1/admin/audit-log', '/api/v1/admin/notifications/failures',
            '/api/v1/admin/reports', '/api/v1/admin/reports/tax'];
        foreach (['REQUESTS', 'RECORDS', 'MISMATCHES'] as $view) {
            $paths[] = '/api/v1/admin/invoices?view='.$view;
        }
        foreach ($paths as $path) {
            $separator = str_contains($path, '?') ? '&' : '?';
            $this->getJson($path.$separator.'from=2000-01-01&to=2000-01-01')->assertOk();
            $this->getJson($path.$separator.'from=2000-01-02&to=2000-01-01')->assertUnprocessable();
        }
    }

    public function test_lower_upload_ceiling_preserves_other_saved_limits_and_published_history(): void
    {
        $legacy = PlatformSettingRegistry::defaultValue('uploads.limits_kb');
        $legacy['vendor_document'] = 1024;
        $legacy['review_video'] = 102400;
        DB::table('platform_settings')->where('key', 'uploads.limits_kb')->update(['value' => json_encode($legacy, JSON_THROW_ON_ERROR)]);
        $persisted = (string) DB::table('platform_settings')->where('key', 'uploads.limits_kb')->value('value');
        $history = DB::table('platform_setting_versions')->where('setting_key', 'uploads.limits_kb')->get()->toJson();
        $settings = PlatformSettings::current();
        $settings->forget();

        self::assertSame(25600, $settings->uploadKb('review_video'));
        self::assertSame(1024, $settings->uploadKb('vendor_document'));
        self::assertSame($persisted, (string) DB::table('platform_settings')->where('key', 'uploads.limits_kb')->value('value'));
        self::assertSame($history, DB::table('platform_setting_versions')->where('setting_key', 'uploads.limits_kb')->get()->toJson());
    }

    public function test_platform_settings_are_versioned_validated_wired_to_new_records_and_super_admin_only(): void
    {
        $super = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($super);
        $list = $this->getJson('/api/v1/admin/platform-settings')->assertOk();
        $items = collect($list->json('data'))->keyBy('key');
        self::assertSame([1, null], [$items['ranking.srs.default_weights']['version'], $items['ranking.srs.default_weights']['previous_value']]);
        self::assertStringContainsString('100%', $items['ranking.fms.default_weights']['validation_rule']);
        self::assertFalse($items->keys()->contains(fn (string $key): bool => str_contains($key, 'nrpc') || str_contains($key, 'vps') || str_contains($key, 'secret') || str_contains($key, 'live')),
            'No NRPC cap, VPS weights, secret or LIVE switch is editable.');
        $fixed = collect($list->json('meta.fixed'))->keyBy('key');
        self::assertSame([null, ['vcs' => 50, 'ohs' => 50], false], [$fixed['orders.nrpc_cap']['value'], $fixed['ranking.vps_weights']['value'], $fixed['finance.live_commerce']['value']]);

        $weights = ['distance' => 30, 'price' => 25, 'vps' => 20, 'stock' => 15, 'product_rating' => 5];
        $this->putJson('/api/v1/admin/platform-settings/ranking.srs.default_weights', ['value' => $weights, 'expected_version' => 1, 'reason' => 'Rebalance the default ranking'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'SETTING_INVALID');
        $deadlines = ['response_hours' => 36, 'mutual_resolution_hours' => 72, 'clarification_hours' => 24, 'appeal_business_days' => 5, 'post_completion_filing_days' => 7];
        $this->putJson('/api/v1/admin/platform-settings/disputes.deadlines', ['value' => $deadlines, 'expected_version' => 0, 'reason' => 'Shorter response window for the pilot'])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'SETTING_VERSION_CONFLICT');
        $this->putJson('/api/v1/admin/platform-settings/disputes.deadlines', ['value' => $deadlines, 'expected_version' => 1, 'reason' => 'short'])->assertStatus(422);
        $this->putJson('/api/v1/admin/platform-settings/disputes.deadlines', ['value' => $deadlines, 'expected_version' => 1, 'reason' => 'Shorter response window for the pilot'])->assertOk()
            ->assertJsonPath('data.version', 2)->assertJsonPath('data.previous_value.response_hours', 48)->assertJsonPath('data.value.response_hours', 36);
        self::assertSame(36, DisputeRules::deadline('response_hours'));
        $this->getJson('/api/v1/admin/platform-settings/disputes.deadlines/history')->assertOk()->assertJsonCount(2, 'data')->assertJsonPath('data.0.changed_role', 'ADMIN_SUPERADMIN')
            ->assertJsonPath('data.1.source', 'SEED');
        self::assertTrue(DB::table('audit_logs')->where('action', 'PLATFORM_SETTING_CHANGED')->where('reason', 'Shorter response window for the pilot')->exists());
        $this->expectAppendOnly(static fn () => DB::table('platform_setting_versions')->where('setting_key', 'disputes.deadlines')->update(['reason' => 'Rewritten reason text']));
        // Cross-setting rule: the Pending Payment window must stay longer than every reminder offset.
        $this->putJson('/api/v1/admin/platform-settings/orders.pending_payment_window_hours', ['value' => 12, 'expected_version' => 1, 'reason' => 'Shorter payment window'])->assertStatus(422);
        $this->putJson('/api/v1/admin/platform-settings/discovery.buyer_default_radius_km', ['value' => 15, 'expected_version' => 1, 'reason' => 'Not in the approved list'])->assertStatus(422);
        $this->putJson('/api/v1/admin/platform-settings/orders.nrpc_cap', ['value' => 1000, 'expected_version' => 0, 'reason' => 'There is no NRPC cap setting'])->assertNotFound();

        // New records only: an order submitted before the change keeps its stored Vendor-response deadline.
        [$store, , $listing] = $this->pickupStore('Settings Store');
        [, $before] = $this->pickupOrder($store, $listing);
        $dueBefore = (string) DB::table('orders')->where('id', $before)->value('vendor_response_due_at');
        $this->signInAdmin($super);
        $this->putJson('/api/v1/admin/platform-settings/orders.vendor_response_hours', ['value' => 6, 'expected_version' => 1, 'reason' => 'Faster Vendor response for the pilot'])->assertOk();
        $this->putJson('/api/v1/admin/platform-settings/discovery.buyer_default_radius_km', ['value' => 10, 'expected_version' => 1, 'reason' => 'Wider default radius for new Buyers'])->assertOk();
        self::assertSame(10, RadiusPolicy::buyerDefault());
        [, $after] = $this->pickupOrder($store, $listing);
        $order = DB::table('orders')->where('id', $after)->first();
        self::assertSame(6 * 3600, (int) CarbonImmutable::parse((string) $order->submitted_at)->diffInSeconds(CarbonImmutable::parse((string) $order->vendor_response_due_at)));
        self::assertSame($dueBefore, (string) DB::table('orders')->where('id', $before)->value('vendor_response_due_at'));

        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->getJson('/api/v1/admin/platform-settings')->assertForbidden();
        $this->putJson('/api/v1/admin/platform-settings/orders.vendor_response_hours', ['value' => 8, 'expected_version' => 2, 'reason' => 'Not permitted for this role'])->assertForbidden();
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'), reauthenticated: false);
        $this->putJson('/api/v1/admin/platform-settings/orders.vendor_response_hours', ['value' => 8, 'expected_version' => 2, 'reason' => 'Needs recent re-authentication'])
            ->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
    }

    public function test_a_dispute_referred_suspension_keeps_its_case_identity_and_is_applied_and_lifted_by_user_management_only(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->paidPickup('Referral Store');
        $this->toPickedUp($owner, $orderId);
        $caseId = (string) $this->fileCase($buyer, $orderId)->assertCreated()->json('data.id');
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/disputes/'.$caseId.'/respond', ['position' => 'REQUEST_ADMIN_REVIEW', 'body' => 'We disagree and ask MateryalPH to review.'], $this->key())->assertOk();
        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->postJson('/api/v1/admin/disputes/'.$caseId.'/decision', ['outcome' => 'FULL_REFUND', 'reason' => 'Wrong item delivered according to the handover photos.', 'enforceable' => true,
            'conflict_check_confirmed' => true, 'lock_version' => (int) DB::table('dispute_cases')->where('id', $caseId)->value('lock_version'),
            'sanctions' => [['subject' => 'VENDOR', 'action' => 'SUSPENSION', 'reason' => 'Wrong items delivered repeatedly.', 'restoration_condition' => 'Corrective plan approved.']]], $this->key())->assertOk();
        $referral = DB::table('enforcement_actions')->where('action', 'SUSPENSION')->first();
        self::assertSame(['REFERRED', $caseId], [(string) $referral->state, (string) $referral->dispute_case_id]);

        // Order and Dispute Staff see the referral read-only; they cannot apply it.
        $this->getJson('/api/v1/admin/enforcement?state=REFERRED')->assertOk()->assertJsonPath('data.0.id', $referral->id)->assertJsonPath('data.0.source', 'DISPUTE_REFERRAL')
            ->assertJsonPath('data.0.case_reference', (string) DB::table('dispute_cases')->where('id', $caseId)->value('reference'));
        $this->getJson('/api/v1/admin/enforcement/'.$referral->id)->assertOk()->assertJsonPath('data.allowed_actions', []);
        $this->postJson('/api/v1/admin/enforcement/'.$referral->id.'/apply', ['continuation_plan' => 'MONITORED_FULFILLMENT', 'lock_version' => 1, 'reason' => 'Applying the referred suspension now.'])->assertForbidden();
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));
        $this->getJson('/api/v1/admin/enforcement')->assertForbidden();

        $manager = $this->admin('ADMIN_USER_MANAGEMENT');
        $this->signInAdmin($manager);
        $detail = $this->getJson('/api/v1/admin/enforcement/'.$referral->id)->assertOk()->assertJsonPath('data.allowed_actions', ['APPLY', 'DECLINE'])->json('data');
        self::assertSame(1, $detail['subject_review']['open_orders']);
        $this->assertNoPrivateData(json_encode($detail, JSON_THROW_ON_ERROR), $owner);
        $apply = fn (array $overrides): TestResponse => $this->postJson('/api/v1/admin/enforcement/'.$referral->id.'/apply', array_replace(['continuation_plan' => 'MONITORED_FULFILLMENT', 'lock_version' => 1,
            'reason' => 'Applying the referred suspension after review.'], $overrides));
        $apply(['lock_version' => 9])->assertStatus(409)->assertJsonPath('errors.0.code', 'ENFORCEMENT_VERSION_CONFLICT');
        $apply(['continuation_plan' => 'NO_OPEN_ORDERS'])->assertStatus(422)->assertJsonPath('errors.0.code', 'CONTINUATION_PLAN_REQUIRED');
        $apply(['reason' => 'short'])->assertStatus(422);
        $applied = $apply([])->assertOk()->assertJsonPath('data.state', 'APPLIED')->assertJsonPath('data.continuation_plan', 'MONITORED_FULFILLMENT')->json('data');

        // Preserved case and history identity: the same record, case, decision, reason and issuer.
        $row = DB::table('enforcement_actions')->where('id', $referral->id)->first();
        self::assertSame([$referral->id, $referral->dispute_case_id, $referral->dispute_decision_id, $referral->reason, $referral->issued_by_user_id],
            [$row->id, $row->dispute_case_id, $row->dispute_decision_id, $row->reason, $row->issued_by_user_id]);
        $event = collect($applied['events'])->firstWhere('event', 'APPLIED');
        self::assertSame(['ACTIVE', 'SUSPENDED'], [$event['before']['store_activation_status'], $event['after']['store_activation_status']]);
        self::assertTrue(DB::table('audit_logs')->where('action', 'ENFORCEMENT_APPLIED')->where('resource_id', $referral->id)->where('correlation_id', $event['correlation_id'])->exists());
        self::assertSame(['SUSPENDED', 'ENFORCEMENT_SUSPENSION'], array_values((array) DB::table('vendor_organizations')->where('id', $store->id)->first(['store_activation_status', 'activation_hold_code'])));
        self::assertTrue(DB::table('vendor_activation_history')->where('vendor_organization_id', $store->id)->where('result', 'SUSPENDED')->exists());
        self::assertTrue(DB::table('notifications')->where('user_id', $owner->id)->where('category', 'SUSPENSION')->exists(), 'The Owner is notified.');
        $this->assertThrows(static fn () => DB::transaction(static fn () => DB::table('enforcement_actions')->where('id', $referral->id)->update(['reason' => 'Rewritten after the fact'])), QueryException::class);
        $this->assertThrows(static fn () => DB::transaction(static fn () => DB::table('enforcement_events')->where('enforcement_action_id', $referral->id)->delete()), QueryException::class);
        // Existing fulfillment stays reachable for the store team; new commerce does not.
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/orders/'.$orderId)->assertOk();

        // A Permanent Ban needs a Super Admin; it supersedes the suspension in one transaction and can only be lifted.
        $this->signInAdmin($manager);
        $this->keyedPost('/api/v1/admin/enforcement', ['subject_type' => 'VENDOR_ORGANIZATION', 'subject_id' => $store->id, 'action' => 'PERMANENT_BAN', 'reason' => 'Fraudulent listings confirmed by review.',
            'continuation_plan' => 'MONITORED_FULFILLMENT'])->assertForbidden();
        $super = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($super);
        $ban = $this->keyedPost('/api/v1/admin/enforcement', ['subject_type' => 'VENDOR_ORGANIZATION', 'subject_id' => $store->id, 'action' => 'PERMANENT_BAN', 'reason' => 'Fraudulent listings confirmed by review.',
            'continuation_plan' => 'MONITORED_FULFILLMENT'])->assertCreated()->assertJsonPath('data.state', 'APPLIED')->json('data');
        self::assertSame(['LIFTED', 'SUPERSEDED'], [(string) DB::table('enforcement_actions')->where('id', $referral->id)->value('state'),
            (string) DB::table('enforcement_events')->where('enforcement_action_id', $referral->id)->orderByDesc('occurred_at')->value('event')]);
        $this->postJson('/api/v1/admin/enforcement/'.$referral->id.'/apply', ['continuation_plan' => 'CONTINUE', 'lock_version' => 3, 'reason' => 'A lifted sanction cannot be applied again.'])->assertStatus(409);
        $this->postJson('/api/v1/admin/enforcement/'.$ban['id'].'/lift', ['lock_version' => $ban['lock_version'], 'reason' => 'Appeal upheld after the external review.'])->assertOk()->assertJsonPath('data.state', 'LIFTED');
        $status = (string) DB::table('vendor_organizations')->where('id', $store->id)->value('store_activation_status');
        self::assertContains($status, ['READY', 'NOT_READY'], 'Lifting never activates a store; the Owner re-runs the activation gate.');
        self::assertNull(DB::table('vendor_organizations')->where('id', $store->id)->value('activation_hold_code'));
    }

    public function test_buyer_restriction_blocks_new_commerce_until_it_expires_and_suspension_revokes_sessions(): void
    {
        [$store, , $listing] = $this->pickupStore('Restriction Store');
        $buyer = $this->buyer();
        $buyerId = $this->buyerProfileId($buyer);
        $manager = $this->admin('ADMIN_USER_MANAGEMENT');
        $this->signInAdmin($manager);
        self::assertSame([], $this->getJson('/api/v1/admin/enforcement/subjects?type=BUYER&q='.urlencode(substr($buyer->email, 0, 4)))->assertOk()->json('data'), 'Partial email searches return nothing.');
        $found = $this->getJson('/api/v1/admin/enforcement/subjects?type=BUYER&q='.urlencode($buyer->email))->assertOk()->json('data.0');
        self::assertSame($buyerId, $found['id']);
        self::assertStringNotContainsString($buyer->email, (string) json_encode($found));
        $this->keyedPost('/api/v1/admin/enforcement', ['subject_type' => 'BUYER', 'subject_id' => $buyerId, 'action' => 'TEMPORARY_RESTRICTION', 'reason' => 'Repeated pickup no-shows confirmed.',
            'duration_days' => 3, 'restoration_condition' => 'Restriction ends automatically after three days.', 'continuation_plan' => 'MONITORED_FULFILLMENT'])
            ->assertStatus(422)->assertJsonPath('errors.0.code', 'CONTINUATION_PLAN_REQUIRED');
        $restriction = $this->keyedPost('/api/v1/admin/enforcement', ['subject_type' => 'BUYER', 'subject_id' => $buyerId, 'action' => 'TEMPORARY_RESTRICTION', 'reason' => 'Repeated pickup no-shows confirmed.',
            'duration_days' => 3, 'restoration_condition' => 'Restriction ends automatically after three days.', 'continuation_plan' => 'NO_OPEN_ORDERS'])->assertCreated()->json('data');
        self::assertNull(DB::table('enforcement_actions')->where('id', $restriction['id'])->where('state', 'REFERRED')->first(), 'A direct action leaves no orphan referral.');

        $this->signInBuyer($buyer);
        $this->addToCart($listing, '1');
        $this->submitCheckout([$store->id])->assertForbidden()->assertJsonPath('errors.0.code', 'BUYER_COMMERCE_RESTRICTED');
        self::assertSame('ACTIVE', (string) DB::table('users')->where('id', $buyer->id)->value('account_status'), 'A restriction never blocks sign-in.');

        CarbonImmutable::setTestNow(CarbonImmutable::now()->addDays(3)->addMinute());
        Carbon::setTestNow(Carbon::now()->addDays(3)->addMinute());
        self::assertSame(1, app(EnforcementService::class)->sweep());
        self::assertSame(['LIFTED', 'EXPIRED'], [(string) DB::table('enforcement_actions')->where('id', $restriction['id'])->value('state'),
            (string) DB::table('enforcement_events')->where('enforcement_action_id', $restriction['id'])->orderByDesc('occurred_at')->value('event')]);
        $this->signInBuyer($buyer);
        $this->submitCheckout([$store->id])->assertCreated();

        // Suspension acts on the account: status SUSPENDED, every session revoked, the notice still delivered.
        $this->signInAdmin($manager);
        $this->keyedPost('/api/v1/admin/enforcement', ['subject_type' => 'BUYER', 'subject_id' => $buyerId, 'action' => 'SUSPENSION', 'reason' => 'Abusive communication with Vendor staff.',
            'restoration_condition' => 'Acknowledge the Code of Conduct.', 'continuation_plan' => 'MONITORED_FULFILLMENT'])->assertCreated();
        self::assertSame('SUSPENDED', (string) DB::table('users')->where('id', $buyer->id)->value('account_status'));
        self::assertSame(0, DB::table('auth_sessions')->where('user_id', $buyer->id)->whereNull('revoked_at')->count());
        self::assertTrue(DB::table('notifications')->where('user_id', $buyer->id)->where('category', 'SUSPENSION')->where('title', 'Suspension applied')->exists());
    }

    public function test_retired_privacy_endpoints_permissions_notifications_and_navigation_are_unavailable(): void
    {
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $id = (string) Str::uuid7();
        $this->getJson('/api/v1/admin/privacy-requests')->assertNotFound();
        $this->postJson('/api/v1/admin/privacy-requests', [], $this->key())->assertNotFound();
        $this->getJson('/api/v1/admin/privacy-requests/'.$id)->assertNotFound();
        foreach (['assign', 'verify', 'start', 'complete', 'reject', 'withdraw'] as $command) {
            $this->postJson('/api/v1/admin/privacy-requests/'.$id.'/'.$command, [])->assertNotFound();
        }
        self::assertSame(0, DB::table('permissions')->whereIn('code', ['privacy.manage', 'privacy.handle'])->count());
        $notice = (object) ['user_id' => $admin->id, 'category' => 'ADMIN_OPERATIONS', 'resource_type' => 'PRIVACY_REQUEST', 'resource_id' => $id];
        self::assertFalse(app(NotificationPolicy::class)->allows($admin, $notice));
    }

    public function test_privacy_retirement_migration_removes_all_grants_and_preserves_existing_history(): void
    {
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $id = (string) Str::uuid7();
        DB::table('privacy_requests')->insert([
            'id' => $id, 'user_id' => $admin->id, 'request_type' => 'ACCESS', 'state' => 'RECEIVED',
            'reference' => 'PR-2026-LEGACY', 'subject_account_type' => 'ADMIN', 'intake_channel' => 'DPO_EMAIL',
            'received_at' => now(), 'created_at' => now(), 'updated_at' => now(),
        ]);
        DB::table('privacy_request_events')->insert([
            'id' => (string) Str::uuid7(), 'privacy_request_id' => $id, 'event' => 'RECEIVED',
            'from_state' => null, 'to_state' => 'RECEIVED', 'note' => 'Retained historical intake.',
            'actor_user_id' => $admin->id, 'actor_role' => 'ADMIN_SUPERADMIN',
            'correlation_id' => (string) Str::uuid7(), 'occurred_at' => now(),
        ]);
        $requests = DB::table('privacy_requests')->get()->toJson();
        $events = DB::table('privacy_request_events')->get()->toJson();
        $unrelatedGrants = DB::table('role_permissions')->orderBy('id')->get()->toJson();
        foreach (['privacy.manage', 'privacy.handle'] as $code) {
            $permissionId = (string) Str::uuid7();
            DB::table('permissions')->insert(['id' => $permissionId, 'code' => $code, 'description' => 'Legacy permission', 'created_at' => now(), 'updated_at' => now()]);
            foreach (DB::table('platform_roles')->pluck('id') as $roleId) {
                DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
        $migration = require database_path('migrations/2026_10_29_000000_retire_privacy_request_permissions.php');
        $migration->up();
        $migration->up();
        self::assertSame(0, DB::table('permissions')->whereIn('code', ['privacy.manage', 'privacy.handle'])->count());
        self::assertSame($unrelatedGrants, DB::table('role_permissions')->orderBy('id')->get()->toJson());
        self::assertSame($requests, DB::table('privacy_requests')->get()->toJson());
        self::assertSame($events, DB::table('privacy_request_events')->get()->toJson());
    }

    public function test_audit_search_is_append_only_and_opening_sensitive_detail_is_itself_audited(): void
    {
        $super = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($super);
        $this->putJson('/api/v1/admin/platform-settings/projects.budget_warning_percent', ['value' => 85, 'expected_version' => 1, 'reason' => 'Earlier budget warning for pilot sites'])->assertOk();
        $search = $this->getJson('/api/v1/admin/audit-log?action=PLATFORM_SETTING&reason=pilot')->assertOk();
        $event = $search->json('data.0');
        self::assertSame(['PLATFORM_SETTING_CHANGED', 'ADMIN_SUPERADMIN', true], [$event['action'], $event['actor_role'], $event['succeeded']]);
        self::assertArrayNotHasKey('before', $event, 'The list is a safe projection without payloads.');
        $this->getJson('/api/v1/admin/audit-log?correlation_id='.$event['correlation_id'])->assertOk()->assertJsonPath('data.0.id', $event['id']);
        $detail = $this->getJson('/api/v1/admin/audit-log/'.$event['id'])->assertOk()->assertJsonPath('data.before.value', 90)->assertJsonPath('data.after.value', 85);
        self::assertTrue(DB::table('audit_logs')->where('action', 'AUDIT_DETAIL_VIEWED')->where('resource_id', $event['id'])->exists());
        self::assertStringContainsString('redacted', (string) $detail->json('data.redaction_note'));
        $this->putJson('/api/v1/admin/audit-log/'.$event['id'], ['reason' => 'edit'])->assertStatus(405);
        $this->deleteJson('/api/v1/admin/audit-log/'.$event['id'])->assertStatus(405);
        $this->assertThrows(static fn () => DB::transaction(static fn () => DB::table('audit_logs')->where('id', $event['id'])->update(['reason' => 'tampered'])), QueryException::class);

        foreach (['ADMIN_USER_MANAGEMENT', 'ADMIN_ORDER_DISPUTE', 'ADMIN_SUPPORT'] as $role) {
            $this->signInAdmin($this->admin($role));
            $this->getJson('/api/v1/admin/audit-log')->assertForbidden();
        }
    }

    public function test_ocr_health_reflects_local_engine_readiness_without_exposing_configuration(): void
    {
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        config()->set('materyalph.compliance_ocr.binary', '/private/ocr-engine-path');
        foreach ([['NONE', false, 'NOT_CONFIGURED'], ['TESSERACT', false, 'DEGRADED'], ['TESSERACT', true, 'HEALTHY']] as [$provider, $available, $status]) {
            $this->mock(ComplianceTextExtractor::class, function ($mock) use ($provider, $available): void {
                $mock->shouldReceive('provider')->andReturn($provider);
                $mock->shouldReceive('available')->andReturn($available);
            });
            $response = $this->getJson('/api/v1/admin/integrations')->assertOk();
            $ocr = collect($response->json('data.integrations'))->firstWhere('key', 'ocr');
            self::assertSame($status, $ocr['status']);
            self::assertStringNotContainsString('/private/ocr-engine-path', $response->getContent());
        }
    }

    public function test_job_health_shows_safe_status_and_retries_only_allowlisted_idempotent_work_with_a_reason(): void
    {
        config()->set('services.xendit.secret_key', 'xnd_development_SECRET_SHOULD_NEVER_APPEAR_123');
        $retryable = $this->deadLetter('NOTIFICATION_READY');
        $owned = $this->deadLetter('PAYMENT_REFUND_REQUESTED');
        DB::table('failed_jobs')->insert(['uuid' => (string) Str::uuid(), 'connection' => 'database', 'queue' => 'default', 'failed_at' => now(),
            'payload' => json_encode(['displayName' => ProcessOutboxEvent::class, 'data' => ['command' => serialize(new ProcessOutboxEvent($retryable)), 'token' => 'payload-token-should-not-leak']]),
            'exception' => "RuntimeException: delivery failed for buyer@example.com with token abc123\n#0 stack"]);

        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->getJson('/api/v1/admin/integrations')->assertForbidden();
        $super = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($super);
        $overview = $this->getJson('/api/v1/admin/integrations')->assertOk();
        self::assertStringNotContainsString('SECRET_SHOULD_NEVER_APPEAR', $overview->getContent());
        self::assertSame(2, $overview->json('data.queues.dead_letters'));
        $jobs = $this->getJson('/api/v1/admin/integrations/failures?kind=JOBS')->assertOk();
        self::assertSame(['ProcessOutboxEvent', 'RuntimeException', true], [$jobs->json('data.0.label'), $jobs->json('data.0.failure'), $jobs->json('data.0.retryable')]);
        foreach (['buyer@example.com', 'abc123', 'payload-token'] as $secret) {
            self::assertStringNotContainsString($secret, $jobs->getContent());
        }
        $outbox = collect($this->getJson('/api/v1/admin/integrations/failures')->assertOk()->json('data'))->keyBy('reference');
        self::assertFalse($outbox[$owned]['retryable']);

        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'OUTBOX_EVENT', 'reference' => $retryable, 'reason' => 'short'])->assertStatus(422);
        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'OUTBOX_EVENT', 'reference' => $owned, 'reason' => 'Retry the refund request again'])->assertStatus(409)->assertJsonPath('errors.0.code', 'RETRY_NOT_ALLOWED');
        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'OUTBOX_EVENT', 'reference' => $retryable, 'reason' => 'Mail server recovered after the outage'])->assertStatus(202)->assertJsonPath('data.outcome', 'QUEUED');
        self::assertLessThan(OutboxProcessor::MAX_ATTEMPTS, (int) DB::table('outbox_events')->where('id', $retryable)->value('attempts'));
        self::assertTrue(DB::table('operation_retries')->where('target_reference', $retryable)->where('actor_role', 'ADMIN_SUPERADMIN')->exists());
        self::assertTrue(DB::table('audit_logs')->where('action', 'OPERATION_RETRY_QUEUED')->exists());
        $this->assertThrows(static fn () => DB::transaction(static fn () => DB::table('operation_retries')->delete()), QueryException::class);
        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'GEO_FACTS_RUN', 'reference' => 'today', 'reason' => 'Rebuild after a PSGC activation'])->assertStatus(202);
        self::assertSame('PUBLISHED', (string) DB::table('analytics_geo_runs')->where('trigger', 'ADMIN_RETRY')->value('state'));
    }

    public function test_failed_job_retry_resets_exhaustion_and_checks_the_underlying_event_allowlist(): void
    {
        Queue::fake();
        $admin = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($admin);
        $safe = $this->deadLetter('NOTIFICATIONS_CHANGED');
        DB::table('outbox_events')->where('id', $safe)->update(['payload' => json_encode(['sealed_payload' => Crypt::encryptString(json_encode(['user_id' => (int) $admin->getKey()]))])]);
        $safeJob = $this->failedOutboxJob($safe);
        $malformedJob = $this->failedOutboxJob($safe);
        DB::table('failed_jobs')->where('uuid', $malformedJob)->update(['payload' => json_encode(['displayName' => ProcessOutboxEvent::class, 'data' => ['command' => serialize((object) ['eventId' => $safe])]])]);
        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'FAILED_JOB', 'reference' => $malformedJob, 'reason' => 'Malformed jobs must never be replayed'])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'RETRY_NOT_ALLOWED');
        foreach (['PAYMENT_REFUND_REQUESTED', 'AUTH_EMAIL_OTP_REQUESTED', 'VENDOR_INVITATION_REQUESTED'] as $type) {
            $protected = $this->deadLetter($type);
            $uuid = $this->failedOutboxJob($protected);
            $rows = collect($this->getJson('/api/v1/admin/integrations/failures?kind=JOBS')->assertOk()->json('data'))->keyBy('reference');
            self::assertFalse($rows[$uuid]['retryable']);
            $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'FAILED_JOB', 'reference' => $uuid, 'reason' => 'Attempt a protected event retry'])
                ->assertStatus(409)->assertJsonPath('errors.0.code', 'RETRY_NOT_ALLOWED');
            self::assertSame(OutboxProcessor::MAX_ATTEMPTS, (int) DB::table('outbox_events')->where('id', $protected)->value('attempts'));
        }
        $this->keyedPost('/api/v1/admin/integrations/retries', ['target_type' => 'FAILED_JOB', 'reference' => $safeJob, 'reason' => 'Worker updated after notification handler fix'])
            ->assertAccepted()->assertJsonPath('data.outcome', 'QUEUED');
        self::assertSame(0, (int) DB::table('outbox_events')->where('id', $safe)->value('attempts'));
        app(OutboxProcessor::class)->process($safe);
        self::assertNotNull(DB::table('outbox_events')->where('id', $safe)->value('processed_at'));
        self::assertTrue(DB::table('operation_retries')->where('target_reference', $safeJob)->exists());
    }

    private function failedOutboxJob(string $event): string
    {
        $uuid = (string) Str::uuid();
        DB::table('failed_jobs')->insert(['uuid' => $uuid, 'connection' => 'database', 'queue' => 'default', 'failed_at' => now(),
            'payload' => json_encode(['displayName' => ProcessOutboxEvent::class, 'data' => ['command' => serialize(new ProcessOutboxEvent($event))]]),
            'exception' => 'RuntimeException: Synthetic delivery failure']);

        return $uuid;
    }

    public function test_phase_3e_queue_shows_separate_workstreams_and_source_revision_blockers_without_a_provider_override(): void
    {
        [$store, $owner] = $this->activeStore('Workstream Store', false);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['store_activation_status' => 'NOT_READY']);
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['logo_file_id' => null, 'banner_file_id' => null]);
        $reviewer = $this->admin('ADMIN_VENDOR_VERIFICATION');
        $this->signInAdmin($reviewer);
        $detail = $this->getJson('/api/v1/admin/vendor-verification/'.$store->id)->assertOk()->json('data');
        self::assertSame(['verification', 'setup', 'provider_readiness', 'activation', 'discoverability'], array_keys($detail['workstreams']));
        self::assertSame('NOT_STARTED', $detail['workstreams']['provider_readiness']['status']);
        $restrictions = $detail['activation_restrictions'];
        self::assertFalse($restrictions['override_available']);
        $provider = collect($restrictions['blockers'])->firstWhere('category', 'PROVIDER_CAPABILITY');
        self::assertSame('PROVIDER_CONNECTION', $provider['source']['type']);
        $media = collect($restrictions['blockers'])->firstWhere('category', 'MEDIA');
        self::assertNotNull($media, 'Missing logo and banner are identified as a media blocker.');
        self::assertStringContainsString('logo missing', $media['source']['label']);
        self::assertFalse(collect($restrictions['blockers'])->contains(fn (array $blocker): bool => str_contains(strtolower($blocker['reason']), 'team') || str_contains(strtolower($blocker['reason']), 'listing')),
            'Optional teams and products never block activation.');
        $this->assertNoPrivateData(json_encode($restrictions, JSON_THROW_ON_ERROR), $owner);

        // Queue filters run on the same case list; there is no second approval engine and no provider override.
        $this->getJson('/api/v1/admin/vendor-verification?status=APPROVED&activation=NOT_ACTIVE&blocker=PROVIDER')->assertOk()->assertJsonPath('data.0.id', $store->id)->assertJsonPath('data.0.provider_status', 'NOT_STARTED');
        // Tab counts follow the other filters but never the selected status, so a tab shows what it would list.
        $counts = $this->getJson('/api/v1/admin/vendor-verification?status=REJECTED&activation=NOT_ACTIVE&blocker=PROVIDER')->assertOk()->assertJsonCount(0, 'data')->json('meta.status_counts');
        self::assertSame(['PENDING_VERIFICATION', 'CHANGES_REQUIRED', 'REJECTED', 'APPROVED', 'EXPIRED'], array_keys($counts));
        self::assertSame(1, $counts['APPROVED']);
        $this->getJson('/api/v1/admin/vendor-verification?status=APPROVED&setup_status=NOT_STARTED&activation=ACTIVE')->assertOk()->assertJsonPath('meta.status_counts.APPROVED', 0);
        $this->getJson('/api/v1/admin/vendor-verification?blocker=TEAM')->assertStatus(422);
        $this->postJson('/api/v1/admin/vendor-verification/'.$store->id.'/payment-connection', ['connection_status' => 'CONNECTED_TEST'])->assertNotFound();
        $this->postJson('/api/v1/admin/vendor-verification/'.$store->id.'/restore', ['reason' => 'Trying to restore without a provider connection.'], $this->key())->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'ACTIVATION_NOT_READY');
        self::assertNull(DB::table('vendor_payment_accounts')->where('vendor_organization_id', $store->id)->value('connection_status'));
        self::assertNotSame('ACTIVE', (string) DB::table('vendor_organizations')->where('id', $store->id)->value('store_activation_status'));
    }

    public function test_tax_adjustments_need_two_named_finance_users_and_post_a_linked_entry_and_vendor_review_status_is_owner_only(): void
    {
        [$store, $owner, , $orderId] = $this->paidPickup('Finance Store');
        $assessment = DB::table('remittance_assessments')->where('order_id', $orderId)->first();
        self::assertNotNull($assessment, 'The verified collection was assessed.');
        $adjustmentId = DB::transaction(static fn () => app(RemittanceAssessmentService::class)->openAdjustmentForRefund((string) $assessment->id, null, 100000, 'A refund was confirmed after assessment.'));
        $preparer = $this->admin('ADMIN_SUPERADMIN');
        $reviewer = $this->admin('ADMIN_SUPERADMIN');
        $this->signInAdmin($preparer);
        $this->getJson('/api/v1/admin/finance/tax-adjustments')->assertOk()->assertJsonPath('data.0.id', $adjustmentId)->assertJsonPath('data.0.allowed_actions', ['PREPARE'])
            ->assertJsonPath('meta.label', 'DEMO — No real funds or BIR filing');
        $corrected = max(0, (int) $assessment->withheld_centavos - 500);
        $this->postJson('/api/v1/admin/finance/tax-adjustments/'.$adjustmentId.'/prepare', ['corrected_withheld_centavos' => $corrected, 'reason' => 'Refund reduced the qualifying base.',
            'certificate_impact' => 'REISSUE_REQUIRED', 'evidence_reference' => 'Refund event reference'])->assertOk()->assertJsonPath('data.state', 'UNDER_REVIEW')->assertJsonPath('data.allowed_actions', []);
        $this->postJson('/api/v1/admin/finance/tax-adjustments/'.$adjustmentId.'/review', ['decision' => 'APPROVED', 'reason' => 'Self-approval must be refused.'])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'PREPARER_CANNOT_REVIEW');
        $this->signInAdmin($reviewer);
        $this->postJson('/api/v1/admin/finance/tax-adjustments/'.$adjustmentId.'/review', ['decision' => 'APPROVED', 'reason' => 'Reviewed the refund evidence and base.'])->assertOk()->assertJsonPath('data.state', 'APPROVED');
        $accumulatorBefore = DB::table('vendor_withholding_accumulators')->where('organization_id', $store->id)->value('g_accumulated_centavos');
        $this->postJson('/api/v1/admin/finance/tax-adjustments/'.$adjustmentId.'/post', [])->assertOk()->assertJsonPath('data.state', 'POSTED');
        self::assertTrue(DB::table('financial_posting_batches')->where('source_event_key', 'DEMO_FLOW:CWT_ADJUSTMENT:'.$adjustmentId)->exists() || (int) $assessment->withheld_centavos === $corrected);
        self::assertSame((int) $assessment->withheld_centavos, (int) DB::table('remittance_assessments')->where('id', $assessment->id)->value('withheld_centavos'), 'The posted assessment is never rewritten.');
        self::assertSame($accumulatorBefore, DB::table('vendor_withholding_accumulators')->where('organization_id', $store->id)->value('g_accumulated_centavos'), 'Refunds never restore FIN-04A relief.');

        $kpis = $this->getJson('/api/v1/admin/finance/kpis')->assertOk()->json('data');
        self::assertSame(['gross_gmv', 'cancelled_gmv', 'refunded_gmv', 'net_gmv', 'online_payments', 'buyer_processing_fees', 'cash_on_delivery', 'in_store', 'buyer_payments',
            'cancellation_refunds', 'dispute_refunds', 'other_refunds', 'cash_reimbursements', 'buyer_refunds', 'pending_buyer_refunds', 'net_buyer_payments'], array_column($kpis['commerce'], 'key'));
        self::assertSame([], array_intersect(array_column($kpis['commerce'], 'key'), array_column($kpis['finance'], 'key')), 'Marketplace money is reported apart from CWT, commission, revenue, platform cash and receivables.');
        self::assertContains('assessed_cwt', array_column($kpis['finance'], 'key'));
        $this->getJson('/api/v1/admin/finance/remittances')->assertOk()->assertJsonPath('data.0.order_reference', (string) DB::table('orders')->where('id', $orderId)->value('reference'));
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->getJson('/api/v1/admin/finance/tax-adjustments')->assertForbidden();
        $this->getJson('/api/v1/admin/finance/kpis')->assertForbidden();

        $this->signInStoreMember($owner);
        $reviews = $this->getJson('/api/v1/vendor/finance/reviews')->assertOk()->assertJsonPath('data.tax_adjustments.0.state', 'POSTED')->json('data');
        self::assertStringNotContainsString('taxpayer', strtolower((string) json_encode($reviews)));
        $this->signInStoreMember($this->teamMember($store, 'STORE_MANAGER'));
        $this->getJson('/api/v1/vendor/finance/reviews')->assertForbidden();
    }

    public function test_operations_home_shows_only_the_queues_each_role_may_open(): void
    {
        $this->deadLetter('NOTIFICATION_READY');
        $expectations = [
            'ADMIN_SUPERADMIN' => ['vendor_verification', 'enforcement', 'jobs', 'finance_reviews', 'disputes'],
            'ADMIN_USER_MANAGEMENT' => ['enforcement', 'review_moderation'],
            'ADMIN_ORDER_DISPUTE' => ['disputes', 'appeals', 'enforcement', 'refund_failures', 'invoices'],
            'ADMIN_VENDOR_VERIFICATION' => ['vendor_verification', 'vendor_activation', 'document_expiry'],
            'ADMIN_SUPPORT' => [],
        ];
        $forbidden = ['ADMIN_USER_MANAGEMENT' => ['jobs', 'finance_reviews', 'vendor_verification'], 'ADMIN_ORDER_DISPUTE' => ['privacy', 'jobs', 'finance_reviews'],
            'ADMIN_VENDOR_VERIFICATION' => ['enforcement', 'privacy', 'disputes', 'jobs'], 'ADMIN_SUPPORT' => ['enforcement', 'jobs', 'disputes', 'vendor_verification']];
        foreach ($expectations as $role => $expected) {
            $this->signInAdmin($this->admin($role));
            $keys = array_column($this->getJson('/api/v1/admin/dashboard')->assertOk()->json('data.queues'), 'key');
            self::assertNotContains('privacy', $keys, $role.' has no retired privacy queue');
            foreach ($expected as $key) {
                self::assertContains($key, $keys, $role.' sees '.$key);
            }
            foreach ($forbidden[$role] ?? [] as $key) {
                self::assertNotContains($key, $keys, $role.' must not see '.$key);
            }
        }
    }

    private function deadLetter(string $type): string
    {
        $id = (string) Str::uuid7();
        DB::table('outbox_events')->insert(['id' => $id, 'event_type' => $type, 'aggregate_type' => 'TEST', 'aggregate_id' => (string) Str::uuid7(),
            'payload' => json_encode(['sealed_payload' => Crypt::encryptString(json_encode(['recipient' => 'hidden@example.com']))]), 'available_at' => now(), 'attempts' => OutboxProcessor::MAX_ATTEMPTS,
            'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    private function assertNoPrivateData(string $json, User $person): void
    {
        foreach ([$person->email, '"latitude"', '"longitude"', 'tin_encrypted', 'identity_id_number', 'invitation_url', 'secret'] as $needle) {
            self::assertStringNotContainsString($needle, $json);
        }
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

    private function toPickedUp(User $owner, string $orderId): void
    {
        foreach ([['PROCESSING', []], ['READY_FOR_PICKUP', []], ['PICKED_UP', ['handover_confirmed' => '1', 'receiver_name' => 'Ana Buyer', 'receiver_kind' => 'BUYER']]] as [$milestone, $fields]) {
            $this->signInStoreMember($owner);
            $lock = (int) DB::table('orders')->where('id', $orderId)->value('lock_version');
            $this->post('/api/v1/vendor/orders/'.$orderId.'/fulfillment/milestones', array_replace(['milestone' => $milestone, 'lock_version' => (string) $lock], $fields),
                ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json'])->assertOk();
        }
    }

    private function fileCase(User $buyer, string $orderId): TestResponse
    {
        $this->signInBuyer($buyer);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');

        return $this->post('/api/v1/buyers/disputes', ['order_id' => $orderId, 'issue_type' => 'WRONG_ITEM', 'requested_remedy' => 'FULL_REFUND', 'affected_line_ids' => [$line],
            'description' => 'The delivered blocks are a different size from the order.', 'preferred_contact_channel' => 'IN_APP', 'files' => [UploadedFile::fake()->image('wrong.png')]],
            ['Idempotency-Key' => (string) Str::uuid7(), 'Accept' => 'application/json']);
    }

    /** @param array<string, mixed> $body */
    private function keyedPost(string $uri, array $body, ?string $key = null): TestResponse
    {
        return $this->postJson($uri, $body, ['Idempotency-Key' => $key ?? (string) Str::uuid7()]);
    }

    /** @return array<string, string> */
    private function key(): array
    {
        return ['Idempotency-Key' => (string) Str::uuid7()];
    }

    private function expectAppendOnly(callable $mutation): void
    {
        $this->assertThrows(static fn () => DB::transaction(static fn () => $mutation()), QueryException::class);
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE16ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInAdmin(User $user, bool $reauthenticated = true): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        if ($reauthenticated) {
            $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        }
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');
        PlatformSettings::current()->forget();
    }
}
