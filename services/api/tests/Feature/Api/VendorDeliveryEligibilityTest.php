<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Procurement\CartService;
use App\Domain\Vendors\VendorDeliveryEligibility;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\TestCase;

final class VendorDeliveryEligibilityTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
    }

    public function test_incomplete_delivery_is_saved_as_a_draft_but_direct_activation_is_rejected(): void
    {
        [$store, $owner] = $this->activeStore('Delivery draft', false);
        $this->signInStoreMember($owner);
        foreach (['VENDOR_DELIVERY', 'BOTH'] as $method) {
            $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
                'fulfillment_method' => $method, 'vendor_delivery_enabled' => false])->assertOk()
                ->assertJsonPath('data.setup.delivery_setup.staff_ready', false)
                ->assertJsonPath('data.setup.delivery_setup.vehicle_ready', false)
                ->assertJsonPath('data.setup.delivery_setup.available', false);
            $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
                'vendor_delivery_enabled' => true])->assertStatus(422)->assertJsonPath('errors.0.code', 'VENDOR_DELIVERY_SETUP_REQUIRED');
            self::assertFalse((bool) DB::table('store_profiles')->where('vendor_organization_id', $store->id)->value('vendor_delivery_enabled'));
            self::assertSame($method === 'BOTH' ? ['PICKUP'] : [], CartService::fulfillmentOptions($method, $store->id));
        }
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
            'fulfillment_method' => 'SELF_PICKUP'])->assertOk();
        self::assertSame(['PICKUP'], CartService::fulfillmentOptions('SELF_PICKUP', $store->id));
    }

    public function test_live_delivery_eligibility_revokes_and_restores_without_changing_activation_intent(): void
    {
        [$store, $owner] = $this->activeStore('Delivery ready', false);
        $this->placeStore($store->id, 1000);
        $this->signInStoreMember($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
            'fulfillment_method' => 'BOTH'])->assertOk();
        $vehicle = $this->addVehicle($store->id);
        $other = $this->activeStore('Other store', false)[0];
        $this->teamMember($other, 'FULFILLMENT');
        self::assertFalse(app(VendorDeliveryEligibility::class)->snapshot($store->id)['staff_ready'], 'Foreign staff cannot qualify.');
        $manager = $this->teamMember($store, 'STORE_MANAGER');
        self::assertFalse(app(VendorDeliveryEligibility::class)->snapshot($store->id)['staff_ready'], 'Managers cannot replace Fulfillment Staff.');
        $this->signInStoreMember($manager);
        $this->getJson('/api/v1/vendor/fleet/vehicles')->assertOk()->assertJsonPath('meta.delivery_setup.staff_ready', false);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version, 'vendor_delivery_enabled' => true])->assertForbidden();
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $this->signInStoreMember($owner);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
            'vendor_delivery_enabled' => true])->assertOk()->assertJsonPath('data.setup.delivery_setup.available', true);
        self::assertSame(['DELIVERY', 'PICKUP'], CartService::fulfillmentOptions('BOTH', $store->id));
        self::assertSame('BOTH', app(PublicVendorProjection::class)->summaries([$store->id])[$store->id]['fulfillment_method']);

        foreach ([['vendor_memberships', 'user_id', $staff->id, 'status', 'INACTIVE', 'ACTIVE'],
            ['users', 'id', $staff->id, 'account_status', 'SUSPENDED', 'ACTIVE'],
            ['vendor_vehicles', 'id', $vehicle, 'active', false, true],
            ['vendor_vehicles', 'id', $vehicle, 'available', false, true]] as [$table, $key, $id, $field, $off, $on]) {
            DB::table($table)->where($key, $id)->update([$field => $off]);
            self::assertFalse(app(VendorDeliveryEligibility::class)->available($store->id));
            self::assertSame(['PICKUP'], CartService::fulfillmentOptions('BOTH', $store->id));
            self::assertSame('SELF_PICKUP', app(PublicVendorProjection::class)->summaries([$store->id])[$store->id]['fulfillment_method']);
            DB::table($table)->where($key, $id)->update([$field => $on]);
            self::assertTrue(app(VendorDeliveryEligibility::class)->available($store->id));
        }
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
            'vendor_delivery_enabled' => false])->assertOk()->assertJsonPath('data.setup.delivery_setup.available', false);
        self::assertSame(['PICKUP'], CartService::fulfillmentOptions('BOTH', $store->id));
    }

    public function test_staff_cannot_bypass_owner_fulfillment_settings_permissions(): void
    {
        [$store] = $this->activeStore('Scoped delivery', false);
        $staff = $this->teamMember($store, 'FULFILLMENT');
        $this->signInStoreMember($staff);
        $this->patchJson('/api/v1/vendors/onboarding/setup', ['organization_lock_version' => $store->refresh()->lock_version,
            'fulfillment_method' => 'BOTH', 'vendor_delivery_enabled' => true])->assertForbidden();
    }
}
