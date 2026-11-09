<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Payments\PhysicalPaymentService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class VendorAccountDeletionTest extends TestCase
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

    public function test_owner_deletion_anonymizes_closes_revokes_every_team_session_and_preserves_business_history(): void
    {
        [$store, $owner] = $this->activeStore('Closing store', false);
        $staff = $this->teamMember($store, 'STORE_MANAGER');
        $other = app(TokenSessionService::class)->start($owner, 'WEB', null, null, null);
        $staffSession = app(TokenSessionService::class)->start($staff, 'WEB', null, null, null);
        $photo = 'private/profile-photos/'.Str::uuid7().'.png';
        Storage::disk('local')->put($photo, 'personal-avatar');
        $owner->forceFill(['profile_photo_disk' => 'local', 'profile_photo_key' => $photo])->save();
        DB::table('user_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'full_name' => $owner->name, 'mobile_e164' => '+639170000001', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('external_identities')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'provider' => 'GOOGLE', 'provider_subject' => 'synthetic-subject', 'linked_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_invitations')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id, 'invited_by_user_id' => $owner->id, 'normalized_email' => 'staff@example.test', 'role' => 'INVENTORY', 'token_hash' => hash('sha256', 'invitation'), 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
        $taxVersion = DB::table('vendor_tax_profile_versions')->where('submitted_by_user_id', $owner->id)->first();
        $email = $owner->email;
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true)->assertJsonCount(5, 'data.retained_records');
        $response = $this->deleteVendor()->assertOk()->assertCookieExpired('mp_access')->assertCookieExpired('mp_refresh')->assertJsonPath('data.sign_in_required', true);
        self::assertMatchesRegularExpression('/^AD-\d{4}-[0-9A-F-]{36}$/', $response->json('data.reference'));
        self::assertSame('DELETED', $owner->refresh()->account_status);
        self::assertSame('Deleted Vendor', $owner->name);
        self::assertNotSame($email, $owner->email);
        self::assertNull($owner->profile_photo_key);
        $this->assertDatabaseHas('user_profiles', ['user_id' => $owner->id, 'full_name' => 'Deleted Vendor', 'mobile_e164' => null]);
        $this->assertDatabaseMissing('external_identities', ['user_id' => $owner->id]);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $store->id, 'account_status' => 'DELETED', 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
        self::assertSame(0, AuthSession::query()->whereIn('user_id', [$owner->id, $staff->id])->whereNull('revoked_at')->count());
        self::assertNotNull(AuthSession::query()->findOrFail($other->sessionId)->revoked_at);
        self::assertNotNull(AuthSession::query()->findOrFail($staffSession->sessionId)->revoked_at);
        self::assertSame('ACTIVE', $staff->refresh()->account_status);
        $this->assertDatabaseHas('vendor_memberships', ['user_id' => $staff->id, 'status' => 'DEACTIVATED']);
        self::assertNotNull(DB::table('vendor_invitations')->where('vendor_organization_id', $store->id)->value('revoked_at'));
        self::assertNotNull(DB::table('totp_factors')->where('user_id', $owner->id)->value('revoked_at'));
        self::assertEquals($taxVersion, DB::table('vendor_tax_profile_versions')->where('id', $taxVersion->id)->first());
        $this->assertDatabaseHas('audit_logs', ['action' => 'VENDOR_ACCOUNT_DELETED', 'actor_user_id' => $owner->id]);
        $this->assertDatabaseMissing('privacy_requests', ['user_id' => $owner->id]);
        $this->assertDatabaseHas('outbox_events', ['event_type' => 'ACCOUNT_SECURITY_NOTICE', 'aggregate_id' => $owner->public_id]);
        $cleanup = (string) DB::table('outbox_events')->where('event_type', 'DELETED_ACCOUNT_PHOTO_CLEANUP')->value('id');
        app(OutboxProcessor::class)->process($cleanup);
        Storage::disk('local')->assertMissing($photo);
        $this->getJson('/api/v1/vendors/account/profile')->assertUnauthorized();
        $this->withUnencryptedCookie('mp_refresh', $other->refreshToken)->postJson('/api/v1/auth/refresh')->assertUnauthorized();
        $this->getJson('/api/v1/stores/'.$store->id.'/profile')->assertNotFound();
        // Replaying the mutation cannot create another deletion/audit record.
        $this->deleteVendor()->assertUnauthorized();
        self::assertSame(1, DB::table('audit_logs')->where('action', 'VENDOR_ACCOUNT_DELETED')->count());
    }

    public function test_staff_and_other_portals_cannot_preview_or_delete_a_vendor_account(): void
    {
        [$store] = $this->activeStore('Authorization', false);
        foreach (['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $this->signInStoreMember($this->teamMember($store, $role));
            $this->getJson('/api/v1/vendors/account/deletion')->assertForbidden();
            $this->deleteVendor()->assertForbidden();
        }
        $this->buyer();
        $this->getJson('/api/v1/vendors/account/deletion')->assertForbidden();
    }

    public function test_confirmation_csrf_request_key_and_recent_mfa_are_required(): void
    {
        [, $owner] = $this->activeStore('Protected deletion', false);
        $this->signInStoreMember($owner);
        AuthSession::query()->where('user_id', $owner->id)->update(['reauthenticated_at' => null]);
        $this->deleteVendor()->assertForbidden()->assertJsonPath('errors.0.code', 'RECENT_AUTHENTICATION_REQUIRED');
        AuthSession::query()->where('user_id', $owner->id)->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD']);
        $this->deleteVendor()->assertForbidden();
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendors/account/deletion', ['confirmation' => 'delete'])->assertUnprocessable();
        $this->postJson('/api/v1/vendors/account/deletion', ['confirmation' => 'DELETE', 'vendor_id' => (string) Str::uuid7()])->assertUnprocessable();
        $this->postJson('/api/v1/vendors/account/deletion', ['confirmation' => 'DELETE'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_KEY_REQUIRED');
        self::assertSame('ACTIVE', $owner->refresh()->account_status);
    }

    public function test_csrf_is_required(): void
    {
        [, $owner] = $this->activeStore('CSRF', false);
        $this->signInStoreMember($owner);
        $this->withHeader('X-CSRF-Token', 'incorrect')->deleteVendor()->assertStatus(419);
        self::assertSame('ACTIVE', $owner->refresh()->account_status);
    }

    public function test_eligibility_is_rechecked_after_an_order_appears_and_closed_history_is_retained(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Recheck');
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true);
        [, $orderId] = $this->pickupOrder($store, $listing);
        $this->signInStoreMember($owner);
        $this->deleteVendor()->assertConflict()->assertJsonPath('errors.0.code', 'ACCOUNT_DELETION_BLOCKED')->assertJsonPath('errors.0.details.blockers.active_orders', 1);
        self::assertSame('ACTIVE', $owner->refresh()->account_status);
        $this->confirmOrder($owner, $orderId)->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'EXPIRED', 'terminal_reason_code' => 'PAYMENT_WINDOW_EXPIRED', 'closed_at' => now()]);
        $snapshot = DB::table('financial_snapshots')->where('order_id', $orderId)->first();
        $this->deleteVendor()->assertOk();
        $this->assertDatabaseHas('orders', ['id' => $orderId]);
        self::assertEquals($snapshot, DB::table('financial_snapshots')->where('id', $snapshot->id)->first());
    }

    public function test_pending_and_uncertain_payments_block_even_after_the_order_closed(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Payment blockers');
        $payment = $this->startPayment($buyer, $orderId);
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'EXPIRED', 'terminal_reason_code' => 'PAYMENT_WINDOW_EXPIRED', 'closed_at' => now()]);
        $this->signInStoreMember($owner);
        foreach (['PENDING', 'UNCERTAIN'] as $state) {
            DB::table('payments')->where('id', $payment['id'])->update(['state' => $state]);
            $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.active_orders', 0)->assertJsonPath('data.blockers.pending_payments', 1);
            $this->deleteVendor()->assertConflict();
        }
    }

    public function test_unpaid_draft_and_issued_statements_block_without_affecting_another_store(): void
    {
        [$store, $owner] = $this->activeStore('Fee blockers', false);
        [, $otherOwner] = $this->activeStore('Other store', false);
        DB::table('fee_statements')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id,
            'period_start' => '2026-10-01', 'period_end' => '2026-10-31', 'issued_on' => '2026-11-01', 'due_on' => '2026-11-15',
            'charges_centavos' => 500, 'balance_centavos' => 500, 'outstanding_centavos' => 500, 'state' => 'DRAFT', 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.outstanding_statements', 1);
        $this->deleteVendor()->assertConflict();
        $this->signInStoreMember($otherOwner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true);
    }

    public function test_refunds_disputes_and_earned_unbilled_commission_each_block_a_completed_order_account(): void
    {
        [$store, $owner, $buyer, $orderId] = $this->awaitingPayment('Completed obligations');
        $payment = $this->startPayment($buyer, $orderId);
        $this->completePayment($payment['id'])->assertOk();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.can_delete', true);
        $refundId = (string) Str::uuid7();
        DB::table('refunds')->insert(['id' => $refundId, 'order_id' => $orderId, 'source_payment_id' => $payment['id'],
            'trigger' => 'TECHNICAL_COMPENSATION', 'amount_centavos' => 100, 'source_captured_centavos' => $payment['total_centavos'],
            'state' => 'REFUND_PENDING', 'idempotency_key' => 'deletion-test-refund', 'created_at' => now(), 'updated_at' => now()]);
        foreach (['REFUND_PENDING', 'REFUND_FAILED'] as $state) {
            DB::table('refunds')->where('id', $refundId)->update(['state' => $state]);
            $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.active_orders', 0)->assertJsonPath('data.blockers.pending_refunds', 1);
            $this->deleteVendor()->assertConflict();
        }
        DB::table('refunds')->where('id', $refundId)->update(['state' => 'REFUNDED']);
        $caseId = (string) Str::uuid7();
        DB::table('dispute_cases')->insert(['id' => $caseId, 'reference' => 'CASE-DELETION-TEST', 'order_id' => $orderId,
            'vendor_organization_id' => $store->id, 'buyer_profile_id' => $this->buyerProfileId($buyer), 'status' => 'APPEAL_OPEN',
            'issue_type' => 'DEFECTIVE', 'requested_remedy' => 'REPLACEMENT', 'response_due_at' => now()->addDays(2),
            'filed_by_party' => 'BUYER', 'responding_party' => 'VENDOR', 'description' => 'Materials arrived with visible defects.', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.unresolved_disputes', 1);
        $this->deleteVendor()->assertConflict();
        DB::table('dispute_cases')->where('id', $caseId)->update(['status' => 'RESOLVED', 'concluded_at' => now()]);
        app(FeeAssessmentService::class)->earnOnCompletion($orderId, (string) Str::uuid7());
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.unbilled_commissions', 1);
        $this->deleteVendor()->assertConflict();
        self::assertSame('ACTIVE', $owner->refresh()->account_status);
    }

    public function test_physical_obligations_and_finance_reviews_block_but_cancellation_releases_do_not(): void
    {
        [$store, $owner, , $orderId] = $this->awaitingPayment('Physical obligations');
        $order = DB::table('orders')->where('id', $orderId)->first();
        $order->payment_method = 'IN_STORE';
        app(PhysicalPaymentService::class)->open($order, 0);
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'EXPIRED', 'closed_at' => now(), 'terminal_reason_code' => 'PAYMENT_WINDOW_EXPIRED']);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.uncollected_payments', 1);
        $this->deleteVendor()->assertConflict();
        DB::table('physical_payment_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId,
            'record_kind' => 'CANCELLATION_RELEASE', 'method' => 'IN_STORE', 'obligation_before_centavos' => $order->commercial_total_centavos,
            'amount_centavos' => 0, 'remaining_obligation_centavos' => $order->commercial_total_centavos, 'state' => 'CANCELLED_UNPAID',
            'idempotency_key' => 'deletion-test-release', 'recorded_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.uncollected_payments', 0);
        DB::table('finance_review_items')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id,
            'kind' => 'RECONCILIATION_EXCEPTION', 'source_type' => 'ORDER', 'source_id' => $orderId, 'reason_code' => 'TEST_REVIEW',
            'summary' => 'Reconciliation must be resolved.', 'dedupe_key' => 'deletion-test-review', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson('/api/v1/vendors/account/deletion')->assertOk()->assertJsonPath('data.blockers.finance_reviews', 1);
        $this->deleteVendor()->assertConflict();
    }

    public function test_database_prevents_restoring_a_deleted_organization(): void
    {
        [$store, $owner] = $this->activeStore('Final closure', false);
        $this->signInStoreMember($owner);
        $this->deleteVendor()->assertOk();
        $this->expectException(QueryException::class);
        DB::table('vendor_organizations')->where('id', $store->id)->update(['account_status' => 'ACTIVE']);
    }

    private function deleteVendor(): TestResponse
    {
        return $this->postJson('/api/v1/vendors/account/deletion', ['confirmation' => 'DELETE'], ['Idempotency-Key' => (string) Str::uuid7()]);
    }
}
