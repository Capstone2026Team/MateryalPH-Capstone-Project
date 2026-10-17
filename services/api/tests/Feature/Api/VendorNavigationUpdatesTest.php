<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Orders\OrderQueries;
use App\Models\User;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\TestCase;

final class VendorNavigationUpdatesTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    private function notice(User $user, string $category = 'SECURITY', string $type = 'ACCOUNT', ?string $resource = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $id, 'user_id' => $user->id, 'category' => $category,
            'title' => 'Synthetic update', 'body' => 'Review the update.', 'resource_type' => $type,
            'resource_id' => $resource ?? $user->public_id, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** @return array{string, User, string} */
    private function conversation(VendorOrganization $store, User $handler): array
    {
        $buyer = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        $profile = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $profile, 'user_id' => $buyer->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $id = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $profile, 'vendor_organization_id' => $store->id,
            'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'handler_user_id' => $handler->id, 'created_at' => now(), 'updated_at' => now()]);
        $message = (string) Str::uuid7();
        DB::table('messages')->insert(['id' => $message, 'conversation_id' => $id, 'sender_user_id' => $buyer->id,
            'client_message_id' => (string) Str::uuid7(), 'body' => 'Synthetic message', 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return [$id, $buyer, $message];
    }

    private function order(VendorOrganization $store, User $buyer, string $state): string
    {
        $id = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $id, 'reference' => 'NAV-'.$id,
            'buyer_profile_id' => DB::table('buyer_profiles')->where('user_id', $buyer->id)->value('id'),
            'vendor_organization_id' => $store->id, 'procurement_type' => 'ITEM_BASED', 'order_state' => $state,
            'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'commercial_total_centavos' => 0,
            'closed_at' => in_array($state, OrderQueries::VENDOR_GROUPS['CLOSED'], true) ? now() : null,
            'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    public function test_orders_count_current_active_orders_instead_of_historical_notification_events(): void
    {
        [$store, $owner] = $this->activeStore('Order navigation', false);
        [$otherStore] = $this->activeStore('Foreign order navigation', false);
        $buyer = $this->buyer();
        foreach (OrderQueries::VENDOR_GROUPS['CLOSED'] as $state) {
            $id = $this->order($store, $buyer, $state);
            for ($i = 0; $i < 5; $i++) {
                $this->notice($owner, 'ORDERS', 'ORDER', $id);
            }
        }
        $this->order($otherStore, $buyer, 'CONFIRMED');
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()
            ->assertJsonPath('data.sections./orders', 0)->assertJsonPath('data.sections./notifications', 20);
        $active = [];
        for ($i = 0; $i < 26; $i++) {
            $active[] = $this->order($store, $buyer, $i === 0 ? 'AWAITING_VENDOR_CONFIRMATION' : 'CONFIRMED');
        }
        for ($i = 0; $i < 5; $i++) {
            $this->notice($owner, 'ORDERS', 'ORDER', $active[0]);
        }
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()
            ->assertJsonPath('data.sections./orders', 26)->assertJsonPath('data.sections./notifications', 25);
        DB::table('orders')->whereIn('id', $active)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./orders', 0);
    }

    public function test_fulfillment_active_order_count_requires_a_current_assignment_and_visible_state(): void
    {
        [$store, $owner] = $this->activeStore('Fulfillment navigation', false);
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $buyer = $this->buyer();
        $assigned = $this->order($store, $buyer, 'CONFIRMED');
        $pending = $this->order($store, $buyer, 'AWAITING_VENDOR_CONFIRMATION');
        $closed = $this->order($store, $buyer, 'COMPLETED');
        $this->order($store, $buyer, 'PROCESSING');
        foreach ([$assigned, $pending, $closed] as $id) {
            DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $id,
                'user_id' => $staff->id, 'assigned_by_user_id' => $owner->id, 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./orders', 1);
        DB::table('order_fulfillment_assignments')->where('order_id', $assigned)->update(['ended_at' => now()]);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./orders', 0);
    }

    public function test_counts_all_authorized_unread_notices_respects_preferences_and_updates_after_read(): void
    {
        [$store, $owner] = $this->activeStore('Navigation', false);
        [$otherStore, $otherOwner] = $this->activeStore('Other navigation', false);
        $read = '';
        for ($i = 0; $i < 55; $i++) {
            $read = $this->notice($owner);
        }
        $this->notice($owner, 'TEAM', 'VENDOR_ORGANIZATION', $store->id);
        $this->notice($owner, 'PRODUCT_COMPLIANCE', 'VENDOR_ORGANIZATION', $store->id);
        $this->notice($owner, 'VENDOR_VERIFICATION', 'VENDOR_ORGANIZATION', $store->id);
        $this->notice($owner, 'INVENTORY', 'VENDOR_ORGANIZATION', $store->id);
        $this->notice($owner, 'TEAM', 'VENDOR_ORGANIZATION', $otherStore->id);
        $this->notice($owner, 'ORDERS', 'ORDER', (string) Str::uuid7());
        $this->notice($otherOwner);
        DB::table('notification_preferences')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id,
            'category' => 'INVENTORY', 'in_app' => false, 'email' => true, 'push' => true, 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($owner);
        $response = $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()
            ->assertJsonPath('data.sections./notifications', 58)->assertJsonPath('data.sections./messages', 0)
            ->assertJsonPath('data.sections./products', 1)->assertJsonPath('data.sections./team', 0)
            ->assertJsonPath('data.sections./orders', 0)->assertJsonMissingPath('data.sections./store-profile');
        self::assertSame(['sections'], array_keys($response->json('data')));
        self::assertStringNotContainsString($owner->public_id, $response->getContent());
        $this->postJson('/api/v1/vendor/notifications/'.$read.'/read')->assertOk();
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 57);
    }

    public function test_team_counts_active_members_instead_of_notifications_and_excludes_inactive_accounts(): void
    {
        [$store, $owner] = $this->activeStore('Team navigation', false);
        [$otherStore] = $this->activeStore('Foreign team navigation', false);
        $this->teamMember($otherStore, 'STORE_STAFF');
        $this->notice($owner, 'TEAM', 'VENDOR_ORGANIZATION', $store->id);
        $this->notice($owner, 'TEAM', 'VENDOR_ORGANIZATION', $store->id);
        DB::table('vendor_invitations')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $store->id,
            'invited_by_user_id' => $owner->id, 'normalized_email' => 'pending@example.test', 'role' => 'STORE_STAFF',
            'token_hash' => hash('sha256', (string) Str::uuid7()), 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/memberships')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()
            ->assertJsonPath('data.sections./team', 0)->assertJsonPath('data.sections./notifications', 2);

        foreach (['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $this->teamMember($store, $role);
        }
        for ($i = 0; $i < 21; $i++) {
            $this->teamMember($store, 'STORE_STAFF');
        }
        $this->getJson('/api/v1/vendors/account/memberships')->assertOk()->assertJsonCount(20, 'data')->assertJsonPath('meta.last_page', 2);
        foreach (['SUSPENDED', 'DEACTIVATED'] as $status) {
            $staff = $this->teamMember($store, 'STORE_STAFF');
            DB::table('vendor_memberships')->where('user_id', $staff->id)->update(['status' => $status]);
        }
        $deleted = $this->teamMember($store, 'STORE_STAFF');
        DB::table('vendor_memberships')->where('user_id', $deleted->id)->update(['status' => 'DEACTIVATED', 'deleted_at' => now()]);
        $suspended = $this->teamMember($store, 'STORE_STAFF');
        $suspended->update(['account_status' => 'SUSPENDED']);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()
            ->assertJsonPath('data.sections./team', 26)->assertJsonPath('data.sections./notifications', 2);
        DB::table('vendor_memberships')->where('vendor_organization_id', $store->id)->where('role', '!=', 'OWNER')
            ->whereNull('deleted_at')->update(['status' => 'DEACTIVATED']);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./team', 0);
    }

    public function test_team_counts_follow_current_manager_delegation_and_member_list_scope(): void
    {
        [$store, $owner] = $this->activeStore('Delegated team navigation', false);
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        $this->teamMember($store, 'STORE_MANAGER');
        foreach (['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $staff = $this->teamMember($store, $role);
        }
        DB::table('vendor_memberships')->where('user_id', $manager->id)->update(['can_manage_staff' => true]);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendors/account/memberships')->assertOk()->assertJsonCount(6, 'data');
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./team', 6);
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendors/account/memberships')->assertOk()->assertJsonCount(4, 'data');
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./team', 4);
        DB::table('vendor_memberships')->where('user_id', $manager->id)->update(['can_manage_staff' => false]);
        $this->getJson('/api/v1/vendors/account/memberships')->assertForbidden();
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./team', 0);
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendors/account/memberships')->assertForbidden();
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./team', 0);
    }

    public function test_finance_counts_are_owner_only_and_reauthorize_after_role_change(): void
    {
        [$store, $owner] = $this->activeStore('Finance navigation', false);
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        foreach ([$owner, $manager] as $user) {
            $id = $this->notice($user, 'FINANCE_MANDATORY');
            DB::table('notifications')->where('id', $id)->update(['vendor_organization_id' => $store->id]);
        }
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./finance', 1);
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 0);
        $this->signInStoreMember($owner);
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['role' => 'STORE_MANAGER']);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./notifications', 0);
    }

    public function test_unread_messages_cover_all_inbox_pages_and_exclude_sent_read_foreign_and_legacy_messages(): void
    {
        [$store, $owner] = $this->activeStore('Message navigation', false);
        [$otherStore, $otherOwner] = $this->activeStore('Other messages', false);
        $first = '';
        $read = '';
        for ($i = 0; $i < 26; $i++) {
            [$id, , $read] = $this->conversation($store, $owner);
            $first = $first ?: $id;
        }
        DB::table('messages')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $first, 'sender_user_id' => $owner->id,
            'client_message_id' => (string) Str::uuid7(), 'body' => 'Sent by the viewer', 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('message_read_receipts')->insert(['id' => (string) Str::uuid7(), 'message_id' => $read, 'user_id' => $owner->id,
            'read_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $this->conversation($otherStore, $otherOwner);
        [$legacy] = $this->conversation($store, $owner);
        DB::table('conversations')->where('id', $legacy)->update(['canonical_conversation_id' => $first]);
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 25);
    }

    public function test_staff_counts_drop_after_handler_transfer_or_participant_revocation(): void
    {
        [$store, $owner] = $this->activeStore('Staff navigation', false);
        $staff = $this->teamMember($store, 'STORE_STAFF');
        [$id] = $this->conversation($store, $staff);
        $this->conversation($store, $owner);
        DB::table('conversation_participants')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id,
            'user_id' => $staff->id, 'participant_role' => 'STORE_STAFF', 'created_at' => now(), 'updated_at' => now()]);
        $this->signInStoreMember($staff);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 1);
        DB::table('conversation_participants')->where('conversation_id', $id)->update(['revoked_at' => now()]);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
        DB::table('conversation_participants')->where('conversation_id', $id)->update(['revoked_at' => null]);
        DB::table('conversations')->where('id', $id)->update(['handler_user_id' => $owner->id]);
        $this->getJson('/api/v1/vendor/navigation-updates')->assertOk()->assertJsonPath('data.sections./messages', 0);
    }

    public function test_navigation_counts_require_an_authenticated_vendor(): void
    {
        $this->getJson('/api/v1/vendor/navigation-updates')->assertUnauthorized();
        $this->buyer();
        $this->getJson('/api/v1/vendor/navigation-updates')->assertForbidden();
    }
}
