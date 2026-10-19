<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

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
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Admin Users sections under Buyer Management and Vendor Management: deny-by-default access, filters and pagination,
 * contact-detail and review-text privacy, audited profile openings, and the basic listing facts that never include
 * exact inventory.
 */
final class AdminUserDirectoryTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
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
    }

    public function test_roles_without_the_directory_grant_are_denied_every_route(): void
    {
        $buyer = $this->directoryBuyer('Denied Buyer', 'denied@example.com');
        [$store] = $this->pickupStore('Denied Store');
        $profile = $this->buyerProfileId($buyer);
        $routes = ['/buyers', '/buyers/'.$profile, '/buyers/'.$profile.'/reviews', '/vendors', '/vendors/'.$store->id, '/vendors/'.$store->id.'/reviews', '/vendors/'.$store->id.'/listings'];

        foreach (['ADMIN_ORDER_DISPUTE', 'ADMIN_VENDOR_VERIFICATION', 'ADMIN_FINANCE'] as $role) {
            $this->signInAdmin($this->admin($role));
            foreach ($routes as $route) {
                $this->getJson('/api/v1/admin'.$route)->assertForbidden()->assertJsonPath('errors.0.code', 'PERMISSION_DENIED');
            }
        }
        foreach (['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT', 'ADMIN_SUPPORT'] as $role) {
            $this->signInAdmin($this->admin($role));
            foreach ($routes as $route) {
                $this->getJson('/api/v1/admin'.$route)->assertOk();
            }
        }
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/admin/buyers')->assertForbidden();
        $this->signInStoreMember(User::query()->findOrFail(DB::table('vendor_memberships')->where('vendor_organization_id', $store->id)->where('role', 'OWNER')->value('user_id')));
        $this->getJson('/api/v1/admin/vendors')->assertForbidden();
        $this->flushSession();
        $this->app['auth']->forgetGuards();
        $this->getJson('/api/v1/admin/vendors')->assertUnauthorized();
        self::assertSame(0, DB::table('audit_logs')->where('action', 'USER_DIRECTORY_VIEWED')->where('actor_role', 'ADMIN_ORDER_DISPUTE')->count(), 'A denied request leaves no profile-opening audit.');
    }

    public function test_buyer_list_searches_filters_counts_and_paginates(): void
    {
        $this->directoryBuyer('Maria Santos', 'maria@example.com', ['company_name' => 'Santos Builders'], '2026-09-01 08:00:00');
        $this->directoryBuyer('Jose Reyes', 'jose@example.com', [], '2026-09-10 08:00:00');
        $suspended = $this->directoryBuyer('Ana Cruz', 'ana@example.com', [], '2026-09-20 08:00:00');
        $suspended->forceFill(['account_status' => 'SUSPENDED'])->save();
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));

        $all = $this->getJson('/api/v1/admin/buyers')->assertOk();
        self::assertSame(['Ana Cruz', 'Jose Reyes', 'Maria Santos'], array_column($all->json('data'), 'name'), 'Newest joined first by default.');
        $all->assertJsonPath('data.2.email', 'maria@example.com')->assertJsonPath('data.2.company_name', 'Santos Builders')->assertJsonPath('meta.total', 3)->assertJsonPath('meta.last_page', 1)
            ->assertJsonPath('meta.status_counts.ACTIVE', 2)->assertJsonPath('meta.status_counts.SUSPENDED', 1);
        self::assertSame(['maria@example.com'], array_column($this->getJson('/api/v1/admin/buyers?q=SANTOS')->assertOk()->json('data'), 'email'), 'Search matches company name, case-insensitively.');
        self::assertSame(['jose@example.com'], array_column($this->getJson('/api/v1/admin/buyers?q=jose@')->assertOk()->json('data'), 'email'));
        self::assertSame([], $this->getJson('/api/v1/admin/buyers?q=100%25')->assertOk()->json('data'), 'LIKE wildcards are literal.');
        $filtered = $this->getJson('/api/v1/admin/buyers?status=SUSPENDED')->assertOk();
        self::assertSame(['ana@example.com'], array_column($filtered->json('data'), 'email'));
        $filtered->assertJsonPath('meta.status_counts.ACTIVE', 2);
        self::assertSame(['jose@example.com'], array_column($this->getJson('/api/v1/admin/buyers?from=2026-09-05&to=2026-09-15')->assertOk()->json('data'), 'email'), 'Inclusive Manila calendar range on the join date.');
        self::assertSame(['Ana Cruz', 'Jose Reyes', 'Maria Santos'], array_column($this->getJson('/api/v1/admin/buyers?sort=name_asc')->assertOk()->json('data'), 'name'));
        $this->getJson('/api/v1/admin/buyers?status=BOGUS')->assertUnprocessable();
        $this->getJson('/api/v1/admin/buyers?sort=password')->assertUnprocessable();

        foreach (range(1, 21) as $number) {
            $this->directoryBuyer('Bulk Buyer '.$number, 'bulk'.$number.'@example.com');
        }
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $first = $this->getJson('/api/v1/admin/buyers?sort=name_asc')->assertOk()->assertJsonPath('meta.total', 24)->assertJsonPath('meta.last_page', 2)->assertJsonPath('meta.per_page', 20);
        self::assertCount(20, $first->json('data'));
        self::assertCount(4, $this->getJson('/api/v1/admin/buyers?sort=name_asc&page=2')->assertOk()->json('data'));
    }

    public function test_buyer_profile_shows_contact_ratings_activity_and_audits_the_opening(): void
    {
        [$store, , $listing] = $this->pickupStore('Rated Store');
        $buyer = $this->directoryBuyer('Maria Santos', 'maria@example.com', ['company_name' => 'Santos Builders', 'position_title' => 'Site Engineer'], '2026-09-01 08:00:00', '+639171234567');
        [, $orderId] = $this->pickupOrder($store, $listing, buyer: $buyer);
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        $profile = $this->buyerProfileId($buyer);
        $this->review($store->id, $profile, $buyer->id, $orderId, 'BUYER', ['inquiry_seriousness' => 5, 'communication_quality' => 4, 'payment_reliability' => 5], 'Pays on time.');
        $this->review($store->id, $profile, $buyer->id, $orderId, 'VENDOR', ['service_quality' => 4, 'speed_rating' => 5, 'speed_kind' => 'PROCESSING_SPEED'], 'Quick replies.');
        $buyer->forceFill(['last_authenticated_at' => CarbonImmutable::parse('2026-10-01 02:00:00')])->save();
        $admin = $this->admin('ADMIN_SUPPORT');
        $this->signInAdmin($admin);

        $detail = $this->getJson('/api/v1/admin/buyers/'.$profile)->assertOk()->assertJsonPath('data.name', 'Maria Santos')->assertJsonPath('data.profile.email', 'maria@example.com')
            ->assertJsonPath('data.profile.mobile', '+639171234567')->assertJsonPath('data.profile.company_name', 'Santos Builders')->assertJsonPath('data.profile.position_title', 'Site Engineer')
            ->assertJsonPath('data.ratings.received.count', 1)->assertJsonPath('data.ratings.received.payment_reliability', '5.00')->assertJsonPath('data.ratings.written.count', 1)
            ->assertJsonPath('data.activity.orders_total', 1)->assertJsonPath('data.activity.orders_completed', 1)->assertJsonPath('data.activity.orders_open', 0)
            ->assertJsonPath('data.activity.last_active_at', '2026-10-01T02:00:00+00:00')->assertJsonPath('data.recent_orders.0.store_name', 'Rated Store')
            ->assertJsonPath('data.can_view_enforcement', false)->assertJsonPath('data.sanctions', []);
        self::assertStringNotContainsString('latitude', (string) json_encode($detail->json()), 'Coordinates are never part of a directory profile.');
        $audit = DB::table('audit_logs')->where('action', 'USER_DIRECTORY_VIEWED')->first();
        self::assertSame($profile, $audit->resource_id);
        self::assertSame($admin->id, (int) $audit->actor_user_id);
        self::assertStringNotContainsString('maria@example.com', (string) $audit->after, 'The audit event records that contact details were opened, never their values.');

        $received = $this->getJson('/api/v1/admin/buyers/'.$profile.'/reviews')->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.type', 'BUYER')->assertJsonPath('data.0.store_name', 'Rated Store')
            ->assertJsonPath('data.0.ratings.payment_reliability', 5)->assertJsonPath('data.0.comment', 'Pays on time.');
        self::assertSame('Pays on time.', $received->json('data.0.comment'));
        $this->getJson('/api/v1/admin/buyers/'.$profile.'/reviews?direction=WRITTEN')->assertOk()->assertJsonPath('data.0.type', 'VENDOR')->assertJsonPath('data.0.ratings.service_quality', 4);
        $this->getJson('/api/v1/admin/buyers/'.$profile.'/reviews?direction=SIDEWAYS')->assertUnprocessable();
        $this->getJson('/api/v1/admin/buyers/'.Str::uuid7())->assertNotFound()->assertJsonPath('errors.0.code', 'USER_NOT_FOUND');
        $this->getJson('/api/v1/admin/buyers/not-a-uuid')->assertNotFound();
    }

    public function test_deleted_buyers_keep_only_a_masked_address_and_user_management_sees_sanctions(): void
    {
        $buyer = $this->directoryBuyer('Gone Buyer', 'gone@example.com', [], '2026-09-01 08:00:00', '+639170000000');
        $profile = $this->buyerProfileId($buyer);
        $buyer->forceFill(['account_status' => 'DELETED', 'account_deleted_at' => now()])->save();
        DB::table('enforcement_actions')->insert(['id' => (string) Str::uuid7(), 'subject_type' => 'BUYER', 'subject_id' => $profile, 'action' => 'WARNING', 'state' => 'EFFECTIVE', 'reason' => 'Repeated pickup no-shows.',
            'scope' => 'Marketplace activity', 'effective_at' => now(), 'issued_role' => 'ADMIN_USER_MANAGEMENT', 'environment' => 'TEST', 'source' => 'DIRECT', 'correlation_id' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()]);

        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->getJson('/api/v1/admin/buyers')->assertOk()->assertJsonPath('data.0.email', 'g•••@example.com');
        $this->getJson('/api/v1/admin/buyers/'.$profile)->assertOk()->assertJsonPath('data.profile.email', 'g•••@example.com')->assertJsonPath('data.profile.mobile', null)
            ->assertJsonPath('data.can_view_enforcement', true)->assertJsonPath('data.sanctions.0.action_label', 'Warning');
    }

    public function test_vendor_list_filters_by_status_verification_and_owner_and_paginates(): void
    {
        [$alpha, $alphaOwner] = $this->pickupStore('Alpha Hardware');
        [$beta] = $this->pickupStore('Beta Lumber');
        $alphaOwner->forceFill(['name' => 'Rosa Alpha'])->save();
        DB::table('vendor_organizations')->where('id', $beta->id)->update(['store_activation_status' => 'SUSPENDED', 'store_verification_status' => 'EXPIRED', 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE', 'created_at' => '2026-01-01 00:00:00']);
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));

        $all = $this->getJson('/api/v1/admin/vendors')->assertOk()->assertJsonPath('meta.total', 2)->assertJsonPath('meta.status_counts.ACTIVE', 1)->assertJsonPath('meta.status_counts.SUSPENDED', 1);
        self::assertSame(['Alpha Hardware', 'Beta Lumber'], array_column($all->json('data'), 'store_name'));
        $all->assertJsonPath('data.0.owner_name', 'Rosa Alpha')->assertJsonPath('data.0.owner_email', $alphaOwner->email)->assertJsonPath('data.0.status', 'ACTIVE')->assertJsonPath('data.1.verification_status', 'EXPIRED');
        self::assertSame(['Alpha Hardware'], array_column($this->getJson('/api/v1/admin/vendors?q=rosa')->assertOk()->json('data'), 'store_name'), 'Search matches the Owner name.');
        self::assertSame(['Beta Lumber'], array_column($this->getJson('/api/v1/admin/vendors?status=SUSPENDED')->assertOk()->json('data'), 'store_name'));
        self::assertSame(['Beta Lumber'], array_column($this->getJson('/api/v1/admin/vendors?verification=EXPIRED')->assertOk()->json('data'), 'store_name'));
        self::assertSame(['Beta Lumber'], array_column($this->getJson('/api/v1/admin/vendors?discoverability=NOT_DISCOVERABLE')->assertOk()->json('data'), 'store_name'));
        self::assertSame(['Beta Lumber', 'Alpha Hardware'], array_column($this->getJson('/api/v1/admin/vendors?sort=joined_asc')->assertOk()->json('data'), 'store_name'));
        self::assertSame(['Beta Lumber'], array_column($this->getJson('/api/v1/admin/vendors?to=2026-02-01')->assertOk()->json('data'), 'store_name'));
        $this->getJson('/api/v1/admin/vendors?status=NOPE')->assertUnprocessable();
        self::assertSame($alpha->id, $all->json('data.0.id'));
    }

    public function test_vendor_profile_reports_store_ratings_activity_and_basic_listings_without_exact_stock(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Detail Hardware', [['price' => 1800, 'qty' => '20'], ['price' => 2600, 'qty' => '20']]);
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['description' => 'Quality hollow blocks since 1998.', 'public_phone' => '+639175550000', 'public_email' => 'sales@detail.example']);
        $owner->forceFill(['last_authenticated_at' => CarbonImmutable::parse('2026-10-05 01:00:00')])->save();
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'closed_at' => now()]);
        $profile = $this->buyerProfileId($buyer);
        $review = $this->review($store->id, $profile, $buyer->id, $orderId, 'VENDOR', ['service_quality' => 4, 'speed_rating' => 5, 'speed_kind' => 'PROCESSING_SPEED'], 'Fast and helpful.', ['public_display_name' => 'Maria S.']);
        $hidden = $this->review($store->id, $profile, $buyer->id, $orderId, 'PRODUCT', ['rating' => 1], 'Contains an unsafe link.', ['moderation_state' => 'HIDDEN_PENDING_REVIEW', 'vendor_listing_id' => $listing]);
        $this->signInAdmin($this->admin('ADMIN_SUPPORT'));

        $detail = $this->getJson('/api/v1/admin/vendors/'.$store->id)->assertOk()->assertJsonPath('data.store_name', 'Detail Hardware')->assertJsonPath('data.store.description', 'Quality hollow blocks since 1998.')
            ->assertJsonPath('data.store.contact_phone', '+639175550000')->assertJsonPath('data.store.contact_email', 'sales@detail.example')->assertJsonPath('data.store.activation_status', 'ACTIVE')
            ->assertJsonPath('data.owner.email', $owner->email)->assertJsonPath('data.ratings.store.count', 1)->assertJsonPath('data.ratings.store.service_quality', '4.00')
            ->assertJsonPath('data.ratings.product.count', 0)->assertJsonPath('data.activity.orders_fulfilled', 1)->assertJsonPath('data.activity.orders_total', 1)->assertJsonPath('data.activity.quotes_sent', 0)
            ->assertJsonPath('data.activity.listings_active', 1)->assertJsonPath('data.activity.last_login_at', '2026-10-05T01:00:00+00:00')->assertJsonPath('data.can_view_verification', false);
        self::assertSame($store->id, DB::table('audit_logs')->where('action', 'USER_DIRECTORY_VIEWED')->value('resource_id'));
        self::assertStringNotContainsString('quantity', strtolower((string) json_encode($detail->json())));

        $listings = $this->getJson('/api/v1/admin/vendors/'.$store->id.'/listings')->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('meta.status_counts.ACTIVE', 1)
            ->assertJsonPath('data.0.status', 'ACTIVE')->assertJsonPath('data.0.stock', 'IN_STOCK')->assertJsonPath('data.0.min_price_centavos', 1800)->assertJsonPath('data.0.max_price_centavos', 2600)->assertJsonPath('data.0.variant_count', 2);
        self::assertNotNull($listings->json('data.0.image_url'));
        self::assertSame(['id', 'name', 'sku', 'status', 'updated_at', 'variant_count', 'min_price_centavos', 'max_price_centavos', 'unit_code', 'stock', 'image_url', 'image_alt'], array_keys($listings->json('data.0')), 'Basic info only.');
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/listings?q=zzzz')->assertOk()->assertJsonPath('meta.total', 0);
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/listings?status=DRAFT')->assertOk()->assertJsonPath('meta.total', 0);
        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variantIds($listing))->update(['hard_reserved_quantity' => DB::raw('quantity_on_hand')]);
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/listings')->assertOk()->assertJsonPath('data.0.stock', 'OUT_OF_STOCK');
        DB::table('inventory_items')->whereIn('listing_variant_id', $this->variantIds($listing))->update(['hard_reserved_quantity' => 0, 'reorder_level' => 50]);
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/listings')->assertOk()->assertJsonPath('data.0.stock', 'LIMITED_STOCK');

        $reviews = $this->getJson('/api/v1/admin/vendors/'.$store->id.'/reviews')->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.author_name', 'Maria S.')->assertJsonPath('data.0.comment', 'Fast and helpful.')
            ->assertJsonPath('data.0.ratings.service_quality', 4)->assertJsonPath('meta.can_moderate', false);
        self::assertSame($review, $reviews->json('data.0.id'));
        $support = $this->getJson('/api/v1/admin/vendors/'.$store->id.'/reviews?type=PRODUCT')->assertOk()->assertJsonPath('data.0.moderation_state', 'HIDDEN_PENDING_REVIEW')->assertJsonPath('data.0.visibility', 'HIDDEN_BY_MODERATION');
        self::assertNull($support->json('data.0.comment'), 'Hidden review text is withheld from roles that cannot moderate.');
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/reviews?type=PRODUCT')->assertOk()->assertJsonPath('data.0.comment', 'Contains an unsafe link.')->assertJsonPath('meta.can_moderate', true);
        $this->getJson('/api/v1/admin/vendors/'.$store->id.'/reviews?type=BUYER')->assertUnprocessable();
        self::assertSame($hidden, $this->getJson('/api/v1/admin/vendors/'.$store->id.'/reviews?type=PRODUCT')->json('data.0.id'));
        $this->signInAdmin($this->admin('ADMIN_SUPERADMIN'));
        $this->getJson('/api/v1/admin/vendors/'.$store->id)->assertOk()->assertJsonPath('data.can_view_verification', true);
        $this->getJson('/api/v1/admin/vendors/'.Str::uuid7().'/listings')->assertNotFound()->assertJsonPath('errors.0.code', 'USER_NOT_FOUND');
    }

    /**
     * @param  array<string, mixed>  $profile
     */
    private function directoryBuyer(string $name, string $email, array $profile = [], ?string $joined = null, ?string $mobile = null): User
    {
        $user = $this->buyer($email);
        $user->forceFill(['name' => $name] + ($joined === null ? [] : ['created_at' => $joined]))->save();
        DB::table('buyer_profiles')->where('user_id', $user->id)->update($profile + ['updated_at' => now()]);
        DB::table('user_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'full_name' => $name, 'mobile_e164' => $mobile, 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    /**
     * @param  array<string, mixed>  $ratings
     * @param  array<string, mixed>  $extra
     */
    private function review(string $storeId, string $buyerProfileId, int $buyerUserId, string $orderId, string $type, array $ratings, string $comment, array $extra = []): string
    {
        $id = (string) Str::uuid7();
        $buyerSide = $type === 'BUYER';
        $at = now();
        $row = ['id' => $id, 'order_id' => $orderId, 'reviewer_user_id' => $buyerUserId, 'review_type' => $type, 'reviewer_party' => $buyerSide ? 'VENDOR' : 'BUYER', 'reviewer_role' => $buyerSide ? 'OWNER' : 'BUYER',
            'vendor_organization_id' => $storeId, 'buyer_profile_id' => $buyerProfileId, 'comment' => $comment, 'public_display_name' => $buyerSide ? 'Rated Store' : 'Verified Buyer', 'submitted_at' => $at, 'revealed_at' => $at,
            'editable_until' => $at->copy()->addDay(), 'revision' => 1, 'moderation_state' => 'NONE', 'environment' => 'TEST', 'lock_version' => 1, 'created_at' => $at, 'updated_at' => $at];
        if ($type === 'PRODUCT') {
            $row += ['order_line_id' => (string) DB::table('order_lines')->where('order_id', $orderId)->value('id')];
        }
        DB::table('reviews')->insert($ratings + $extra + $row);

        return $id;
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('DIRECTORYADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

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
