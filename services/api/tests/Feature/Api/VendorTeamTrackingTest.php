<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\VendorTeamActivityBroadcast;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Operations\OutboxProcessor;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Contracts\Broadcasting\Broadcaster;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class VendorTeamTrackingTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_totals_cover_all_pages_and_filters_preserve_historical_roles_and_safe_fields(): void
    {
        $org = $this->organization();
        [$owner] = $this->member($org, 'OWNER');
        [$staff, $membership] = $this->member($org, 'INVENTORY');
        for ($i = 0; $i < 25; $i++) {
            $this->event($org, $staff, 'INVENTORY', 'INVENTORY_ROW_UPDATED', $i !== 0);
        }
        $this->event($org, $staff, 'STORE_STAFF', 'ORDER_CONFIRMED');
        $this->event($org, $staff, 'INVENTORY', 'INVENTORY_ROW_UPDATED', daysAgo: 40);
        $other = $this->organization();
        $this->event($other, $staff, 'INVENTORY', 'INVENTORY_ROW_UPDATED');
        $this->signIn($owner);
        $url = '/api/v1/vendors/account/activity?member_id='.$membership->id;
        $response = $this->getJson($url)->assertOk()->assertJsonCount(20, 'data')
            ->assertJsonPath('meta.total_events', 26)->assertJsonPath('meta.succeeded_events', 25)
            ->assertJsonPath('meta.failed_events', 1)->assertJsonPath('meta.last_page', 2);
        self::assertStringNotContainsString('private-test-value', $response->getContent());
        $this->getJson($url.'&page=2')->assertOk()->assertJsonCount(6, 'data')->assertJsonPath('meta.total_events', 26);
        $this->getJson($url.'&role=STORE_STAFF')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.actor_role', 'STORE_STAFF');
        $this->getJson($url.'&category=SALES')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('meta.total_events', 26);
        $this->getJson($url.'&days=90')->assertOk()->assertJsonPath('meta.total_events', 27);
        $this->getJson($url.'&days=365')->assertUnprocessable();
    }

    public function test_delegated_managers_cannot_monitor_other_managers_or_other_organizations(): void
    {
        $org = $this->organization();
        [$owner, $ownerMembership] = $this->member($org, 'OWNER');
        [$manager] = $this->member($org, 'STORE_MANAGER', true);
        [$otherManager, $managerMembership] = $this->member($org, 'STORE_MANAGER');
        [$staff, $staffMembership] = $this->member($org, 'FULFILLMENT');
        [, $foreignMembership] = $this->member($this->organization(), 'STORE_STAFF');
        $this->event($org, $owner, 'OWNER', 'VENDOR_STAFF_UPDATED');
        $this->event($org, $otherManager, 'STORE_MANAGER', 'ORDER_CONFIRMED');
        $this->event($org, $staff, 'FULFILLMENT', 'ORDER_MILESTONE_RECORDED');
        $this->signIn($manager);
        $this->getJson('/api/v1/vendors/account/activity')->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.category', 'FULFILLMENT')->assertJsonPath('meta.total_events', 1);
        foreach ([$ownerMembership, $managerMembership, $foreignMembership] as $membership) {
            $this->getJson('/api/v1/vendors/account/activity?member_id='.$membership->id)->assertNotFound();
        }
        $this->getJson('/api/v1/vendors/account/memberships?role=FULFILLMENT')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $staffMembership->id);
        $this->getJson('/api/v1/vendors/account/memberships?search=no-match')->assertOk()->assertJsonCount(0, 'data');
        $this->signIn($otherManager);
        $this->getJson('/api/v1/vendors/account/activity')->assertForbidden();
        $this->signIn($staff);
        $this->getJson('/api/v1/vendors/account/activity')->assertForbidden();
    }

    public function test_staff_messages_and_quotation_events_are_counted_without_content_or_system_attribution(): void
    {
        $org = $this->organization();
        [$owner] = $this->member($org, 'OWNER');
        [$staff, $membership] = $this->member($org, 'CUSTOMER_SERVICE');
        $buyer = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $buyerId = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $buyerId, 'user_id' => $buyer->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $conversation = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $conversation, 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $org->id, 'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'created_at' => now(), 'updated_at' => now()]);
        foreach (['CUSTOMER_SERVICE', 'SYSTEM', 'BUYER'] as $role) {
            DB::table('messages')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $conversation, 'sender_user_id' => $role === 'BUYER' ? $buyer->id : $staff->id, 'client_message_id' => (string) Str::uuid7(), 'body' => 'private-test-value', 'kind' => $role === 'SYSTEM' ? 'SYSTEM' : 'TEXT', 'public_sender' => json_encode(['role' => $role]), 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $quotation = (string) Str::uuid7();
        DB::table('quotations')->insert(['id' => $quotation, 'conversation_id' => $conversation, 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $org->id, 'procurement_type' => 'ITEM_BASED', 'state' => 'DRAFT', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('quotation_events')->insert(['id' => (string) Str::uuid7(), 'quotation_id' => $quotation, 'actor_user_id' => $staff->id, 'event_type' => 'DRAFT_SAVED', 'payload' => json_encode(['actor_role' => 'CUSTOMER_SERVICE', 'correlation_id' => 'tracking-test', 'private' => 'private-test-value']), 'created_at' => now(), 'updated_at' => now()]);
        $this->signIn($owner);
        $response = $this->getJson('/api/v1/vendors/account/activity?member_id='.$membership->id)->assertOk()->assertJsonCount(2, 'data')->assertJsonPath('meta.total_events', 2);
        self::assertEqualsCanonicalizing(['MESSAGE_SENT', 'QUOTATION_DRAFT_SAVED'], array_column($response->json('data'), 'action'));
        self::assertStringNotContainsString('private-test-value', $response->getContent());
    }

    public function test_audit_invalidation_is_sealed_and_rolls_back_with_the_recorded_action(): void
    {
        Queue::fake();
        $org = $this->organization();
        [$staff] = $this->member($org, 'INVENTORY');
        $request = Request::create('/api/v1/vendor/inventory', 'PUT');
        $request->setUserResolver(fn () => $staff);
        $request->attributes->set('account_scope', app(AccountAccess::class)->resolve($staff));
        $request->attributes->set('correlation_id', 'tracking-invalidation-test');
        $audit = app(AuditRecorder::class);
        DB::beginTransaction();
        $audit->account($request, 'INVENTORY_ROW_UPDATED', 'LISTING_VARIANT', (string) Str::uuid7());
        self::assertSame(1, DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->count());
        DB::rollBack();
        self::assertSame(0, DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->count());
        self::assertSame(0, DB::table('audit_logs')->where('correlation_id', 'tracking-invalidation-test')->count());

        $audit->account($request, 'INVENTORY_ROW_UPDATED', 'LISTING_VARIANT', (string) Str::uuid7());
        $event = DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->sole();
        self::assertNull($event->processed_at);
        $envelope = json_decode($event->payload, true, flags: JSON_THROW_ON_ERROR);
        self::assertSame(['sealed_payload'], array_keys($envelope));
        self::assertSame(['vendor_organization_id' => $org->id, 'actor_role' => 'INVENTORY'], json_decode(Crypt::decryptString($envelope['sealed_payload']), true, flags: JSON_THROW_ON_ERROR));
    }

    public function test_realtime_delivery_rechecks_organization_delegation_and_historical_actor_scope(): void
    {
        Queue::fake();
        $org = $this->organization();
        [$owner] = $this->member($org, 'OWNER');
        [$manager, $managerMembership] = $this->member($org, 'STORE_MANAGER', true);
        $this->member($org, 'STORE_MANAGER');
        $this->member($org, 'INVENTORY');
        [$inactive, $inactiveMembership] = $this->member($org, 'STORE_MANAGER', true);
        $inactiveMembership->update(['status' => 'SUSPENDED']);
        $inactive->update(['account_status' => 'SUSPENDED']);
        $this->member($this->organization(), 'OWNER');
        config()->set('broadcasting.default', 'reverb');
        $broadcast = \Mockery::mock(Broadcaster::class);
        Broadcast::shouldReceive('connection')->with('reverb')->andReturn($broadcast);
        $broadcast->shouldReceive('broadcast')->times(3)->with(['private-'.app(BuyerInboxChannel::class)->name($owner)], 'team.activity.changed', []);
        $broadcast->shouldReceive('broadcast')->once()->with(['private-'.app(BuyerInboxChannel::class)->name($manager)], 'team.activity.changed', []);
        $events = app(VendorTeamActivityBroadcast::class);
        $processor = app(OutboxProcessor::class);
        foreach (['INVENTORY', 'OWNER'] as $role) {
            $events->publish($org->id, $role);
            $id = DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->whereNull('processed_at')->sole()->id;
            $processor->process($id);
            $processor->process($id); // Retries of completed events do not duplicate delivery.
        }
        $events->publish($org->id, 'FULFILLMENT');
        $id = DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->whereNull('processed_at')->sole()->id;
        $managerMembership->update(['can_manage_staff' => false]);
        $processor->process($id); // Revocation between publication and delivery removes the viewer.
        self::assertSame(3, DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->whereNotNull('processed_at')->count());
    }

    public function test_vendor_messages_and_quotation_actions_publish_invalidations_without_content(): void
    {
        Queue::fake();
        $org = $this->organization();
        [$staff] = $this->member($org, 'CUSTOMER_SERVICE');
        $buyer = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $buyerId = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $buyerId, 'user_id' => $buyer->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $conversationId = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $conversationId, 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $org->id, 'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'created_at' => now(), 'updated_at' => now()]);
        $conversation = DB::table('conversations')->where('id', $conversationId)->sole();
        $messages = app(ConversationService::class);
        $messages->append($conversation, $staff, 'private-message-value', 'TEXT');
        $messages->append($conversation, $staff, 'private-system-value');
        $messages->append($conversation, $buyer, 'private-buyer-value', 'TEXT');
        self::assertSame(1, DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->count());
        $quotationId = (string) Str::uuid7();
        DB::table('quotations')->insert(['id' => $quotationId, 'conversation_id' => $conversationId, 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $org->id, 'procurement_type' => 'ITEM_BASED', 'state' => 'DRAFT', 'created_at' => now(), 'updated_at' => now()]);
        $quotation = DB::table('quotations')->where('id', $quotationId)->sole();
        app(QuotationService::class)->event($quotation, $staff, 'DRAFT_SAVED', ['private' => 'private-quotation-value']);
        app(QuotationService::class)->event($quotation, $buyer, 'VIEWED');
        $events = DB::table('outbox_events')->where('event_type', VendorTeamActivityBroadcast::EVENT)->get();
        self::assertCount(2, $events);
        foreach ($events as $event) {
            $payload = Crypt::decryptString(json_decode($event->payload, true, flags: JSON_THROW_ON_ERROR)['sealed_payload']);
            self::assertSame(['vendor_organization_id' => $org->id, 'actor_role' => 'CUSTOMER_SERVICE'], json_decode($payload, true, flags: JSON_THROW_ON_ERROR));
            self::assertStringNotContainsString('private-', $payload);
        }
    }

    private function organization(): VendorOrganization
    {
        return VendorOrganization::query()->create(['legal_name' => 'Tracking test organization', 'store_name' => 'Tracking test store', 'account_status' => 'ACTIVE']);
    }

    /** @return array{User, VendorMembership} */
    private function member(VendorOrganization $org, string $role, bool $delegated = false): array
    {
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        $membership = VendorMembership::query()->create(['vendor_organization_id' => $org->id, 'user_id' => $user->id, 'role' => $role, 'status' => 'ACTIVE', 'can_manage_staff' => $delegated]);

        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString(Str::random(32)), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return [$user, $membership];
    }

    private function event(VendorOrganization $org, User $actor, string $role, string $action, bool $succeeded = true, int $daysAgo = 0): void
    {
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $actor->id, 'actor_role' => $role, 'vendor_organization_id' => $org->id, 'action' => $action, 'resource_type' => str_starts_with($action, 'ORDER_') ? 'ORDER' : 'LISTING_VARIANT', 'resource_id' => (string) Str::uuid7(), 'succeeded' => $succeeded, 'before' => '{}', 'after' => json_encode(['status' => 'ACTIVE', 'private' => 'private-test-value']), 'correlation_id' => 'tracking-test', 'created_at' => now()->subDays($daysAgo), 'updated_at' => now()]);
    }

    private function signIn(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api');
    }
}
