<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Inventory\AutoAcceptGate;
use App\Domain\Inventory\AutoAcceptPolicyService;
use App\Domain\Inventory\InventoryLocks;
use App\Domain\Vendors\ConfirmedDeliverySnapshot;
use App\Domain\Vendors\DeliveryRecommendationService;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseFiveInventoryDeliveryTest extends TestCase
{
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
    }

    public function test_vendors_see_exact_private_quantities_while_public_surfaces_only_get_three_labels(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-100', variants: 2);
        $this->publish($listing)->assertOk()->assertJsonPath('data.status', 'ACTIVE');

        $ledger = $this->getJson('/api/v1/vendor/inventory/items')->assertOk();
        $ledger->assertJsonPath('meta.summary.variants', 2)->assertJsonPath('meta.permissions.can_adjust', true)->assertJsonCount(2, 'data');
        $row = $ledger->json('data.0');
        self::assertSame('100.0000', $row['inventory']['quantity_on_hand']);
        self::assertSame('100.0000', $row['inventory']['available_to_sell']);
        self::assertSame('IN_STOCK', $row['public_label']);
        self::assertSame('DISABLED', $row['auto_accept']['status']);

        // Limited Stock applies at or below the Vendor's reorder level; soft holds never reduce availability.
        DB::table('inventory_items')->where('listing_variant_id', $row['listing_variant_id'])->update(['soft_held_quantity' => '90']);
        $this->patchJson('/api/v1/vendor/inventory/items/'.$row['listing_variant_id'], ['lock_version' => $row['lock_version'], 'reorder_level' => '100'])->assertOk()
            ->assertJsonPath('data.public_label', 'LIMITED_STOCK')->assertJsonPath('data.inventory.available_to_sell', '100.0000');
        $this->getJson('/api/v1/vendor/catalog/listings/'.$listing)->assertOk()->assertJsonPath('data.variants.0.public_availability', 'LIMITED_STOCK');
        $this->getJson('/api/v1/vendor/inventory/items?stock=LIMITED_STOCK')->assertOk()->assertJsonCount(1, 'data');

        // MAT-02: two variants count once; current offers carry source versions but never quantities.
        $counts = app(EligibleOfferQuery::class)->currentCounts([$organization->id]);
        self::assertSame(1, $counts['vendors']);
        self::assertSame(1, $counts['listings']);
        self::assertSame(EligibleOfferQuery::VERSION, $counts['eligibility_version']);
        $offers = app(EligibleOfferQuery::class)->currentOffers([$organization->id]);
        self::assertCount(2, $offers);
        foreach ($offers as $offer) {
            self::assertArrayNotHasKey('quantity_on_hand', $offer);
            self::assertArrayNotHasKey('available_to_sell', $offer);
            self::assertNotNull($offer['listing_price_version_id']);
            self::assertNotNull($offer['price_effective_at']);
        }
        $public = $this->getJson('/api/v1/stores/'.$organization->id.'/profile')->assertOk()->getContent();
        foreach (['quantity_on_hand', 'hard_reserved_quantity', 'soft_held_quantity', 'available_to_sell', 'reorder_level'] as $private) {
            self::assertStringNotContainsString($private, (string) $public);
        }
    }

    public function test_manual_edits_use_optimistic_versions_and_record_append_only_movements(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-OPT');
        $variant = $this->variantIds($listing)[0];
        $version = $this->rowVersion($variant);

        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $version, 'quantity_on_hand' => '140', 'reason_code' => 'RECEIVED', 'note' => 'Delivery from plant'])->assertOk()
            ->assertJsonPath('data.inventory.quantity_on_hand', '140.0000');
        // A second editor still holding the old version gets the current row instead of silently overwriting it.
        $conflict = $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $version, 'quantity_on_hand' => '90', 'reason_code' => 'COUNT'])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'STALE_VERSION');
        self::assertSame('140.0000', $conflict->json('errors.0.details.current.inventory.quantity_on_hand'));

        $current = $this->rowVersion($variant);
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $current, 'quantity_on_hand' => '150', 'reason_code' => 'DAMAGED'])->assertUnprocessable()
            ->assertJsonPath('errors.0.details.quantity_on_hand.0', 'Damaged or lost stock must decrease the quantity on hand.');
        DB::table('inventory_items')->where('listing_variant_id', $variant)->update(['hard_reserved_quantity' => '30']);
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $current, 'quantity_on_hand' => '20', 'reason_code' => 'COUNT'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'STOCK_BELOW_RESERVED');
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $current, 'quantity_on_hand' => '-1'])->assertUnprocessable();

        $movements = $this->getJson('/api/v1/vendor/inventory/items/'.$variant.'/movements')->assertOk();
        $movements->assertJsonPath('data.0.movement_type', 'RECEIVED')->assertJsonPath('data.0.quantity_delta', '40.0000')->assertJsonPath('data.0.quantity_on_hand_before', '100.0000')->assertJsonPath('data.0.note', 'Delivery from plant');
        $movementId = $movements->json('data.0.id');
        foreach (['update' => fn () => DB::table('inventory_movements')->where('id', $movementId)->update(['quantity' => 1]), 'delete' => fn () => DB::table('inventory_movements')->where('id', $movementId)->delete(), 'confirmation' => fn () => DB::table('stock_confirmation_events')->limit(1)->delete()] as $operation => $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Inventory history must be append-only: '.$operation);
            } catch (QueryException $exception) {
                self::assertStringContainsString('append-only', $exception->getMessage());
            }
        }
        // Physical stock can never go negative or below hard reservations at the database level either.
        $this->expectException(QueryException::class);
        DB::transaction(fn () => DB::table('inventory_items')->where('listing_variant_id', $variant)->update(['quantity_on_hand' => '10']));
    }

    public function test_acceptance_locks_every_affected_row_in_deterministic_order(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $variants = $this->variantIds($this->publishableListing('CHB-LOCK', variants: 3));
        $reversed = array_reverse($variants);
        $locked = DB::transaction(fn (): array => app(InventoryLocks::class)->lockForAcceptance([...$reversed, $reversed[0]]));
        self::assertCount(3, $locked['inventory']);
        $ids = array_map(static fn (object $row): string => (string) $row->id, array_values($locked['inventory']));
        $sorted = $ids;
        sort($sorted);
        self::assertSame($sorted, $ids, 'Rows are locked in ascending id order whatever order the order lines use.');
        self::assertSame([], $locked['policies']);
    }

    public function test_price_changes_append_versions_republish_and_reject_stale_versions(): void
    {
        [, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-PRICE');
        $this->publish($listing)->assertOk();
        $variant = $this->variantIds($listing)[0];
        $row = $this->getJson('/api/v1/vendor/inventory/items?listing_id='.$listing)->json('data.0');
        $original = $row['price']['price_version_id'];
        $publication = (int) DB::table('vendor_listings')->where('id', $listing)->value('publication_version');

        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $row['lock_version'], 'price' => ['expected_price_version_id' => $original, 'amount_centavos' => 1950]])->assertOk()
            ->assertJsonPath('data.price.amount_centavos', 1950)->assertJsonPath('data.price.version', 2);
        $this->assertDatabaseHas('listing_price_versions', ['id' => $original, 'amount_centavos' => 1800]);
        self::assertNotNull(DB::table('listing_price_versions')->where('id', $original)->value('retired_at'));
        self::assertSame($publication + 1, (int) DB::table('vendor_listings')->where('id', $listing)->value('publication_version'));
        $history = $this->getJson('/api/v1/vendor/inventory/items/'.$variant.'/prices')->assertOk()->assertJsonCount(2, 'data');
        $history->assertJsonPath('data.0.current', true)->assertJsonPath('data.1.amount_centavos', 1800)->assertJsonPath('data.1.current', false);

        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $this->rowVersion($variant), 'price' => ['expected_price_version_id' => $original, 'amount_centavos' => 2000]])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'PRICE_VERSION_CONFLICT');
        // Historical price rows are immutable; corrections always append.
        $this->expectException(QueryException::class);
        DB::transaction(fn () => DB::table('listing_price_versions')->where('id', $original)->update(['amount_centavos' => 1]));
    }

    public function test_each_fixed_role_has_only_its_inventory_price_auto_accept_and_vehicle_authority(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-ROLE');
        $this->publish($listing)->assertOk();
        $variant = $this->variantIds($listing)[0];
        $policy = ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '5'];

        $this->signInVendor($this->member($organization, 'CUSTOMER_SERVICE'));
        $this->getJson('/api/v1/vendor/inventory/items')->assertOk()->assertJsonPath('meta.permissions.can_adjust', false);
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $this->rowVersion($variant), 'quantity_on_hand' => '5'])->assertForbidden();
        $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->assertOk()->assertJsonPath('data.permissions.can_configure', false);
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, $policy)->assertForbidden();
        $this->getJson('/api/v1/vendor/fleet/vehicles')->assertForbidden();

        $this->signInVendor($this->member($organization, 'FULFILLMENT'));
        $this->getJson('/api/v1/vendor/inventory/items')->assertForbidden();
        $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->assertForbidden();
        $this->getJson('/api/v1/vendor/fleet/vehicles')->assertOk()->assertJsonPath('meta.scope', 'ASSIGNED_ONLY')->assertJsonCount(0, 'data');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle(null)]])->assertForbidden();

        $this->signInVendor($this->member($organization, 'STORE_STAFF'));
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $this->rowVersion($variant), 'quantity_on_hand' => '120'])->assertOk();
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, $policy)->assertForbidden();
        $this->patchJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/allotment', ['lock_version' => 0, 'allotment_quantity' => '5'])->assertForbidden();
        $this->putJson('/api/v1/vendor/inventory/settings', ['lock_version' => 0, 'reminder_local_time' => '09:00', 'email_reminders' => true])->assertForbidden();
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle(null)]])->assertForbidden();

        $inventory = $this->member($organization, 'INVENTORY');
        $this->signInVendor($inventory);
        $row = $this->getJson('/api/v1/vendor/inventory/items')->json('data.0');
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $row['lock_version'], 'price' => ['expected_price_version_id' => $row['price']['price_version_id'], 'amount_centavos' => 1750]])->assertOk();
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, $policy)->assertForbidden();
        $this->patchJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/allotment', ['lock_version' => 0, 'allotment_quantity' => '5'])->assertOk()
            ->assertJsonPath('data.policy.status', 'DISABLED')->assertJsonPath('data.policy.remaining_allotment_quantity', '5');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle(null)]])->assertForbidden();

        $manager = $this->member($organization, 'STORE_MANAGER');
        $this->signInVendor($manager);
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 1] + $policy)->assertOk()->assertJsonPath('data.policy.status', 'ACTIVE');
        $this->putJson('/api/v1/vendor/inventory/settings', ['lock_version' => 0, 'reminder_local_time' => '07:30', 'email_reminders' => false])->assertOk()
            ->assertJsonPath('data.reminder_local_time', '07:30')->assertJsonPath('data.email_reminders', false);
        $this->putJson('/api/v1/vendor/inventory/settings', ['lock_version' => 0, 'reminder_local_time' => '09:00', 'email_reminders' => true])->assertStatus(409);
    }

    public function test_auto_accept_is_disabled_by_default_pauses_at_zero_and_resumes_only_deliberately(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-AUTO');
        $variant = $this->variantIds($listing)[0];
        $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->assertOk()->assertJsonPath('data.policy.status', 'DISABLED')
            ->assertJsonPath('data.scope.project_based_excluded', true)->assertJsonPath('data.scope.nrpc_excluded', true);
        // A draft listing cannot auto-accept.
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '5'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'AUTO_ACCEPT_NOT_ELIGIBLE');
        $this->publish($listing)->assertOk();
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '0'])->assertUnprocessable();
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '2.5'])->assertUnprocessable();
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '6', 'max_unit_count' => '4', 'max_order_amount_centavos' => 500000])->assertOk()
            ->assertJsonPath('data.policy.status', 'ACTIVE')->assertJsonPath('data.policy.max_unit_count', '4.0000')->assertJsonPath('data.policy.max_order_amount_centavos', 500000);

        // Inventory Staff sets the allotment to zero: the policy pauses and permitted users are notified.
        $inventory = $this->member($organization, 'INVENTORY');
        $manager = $this->member($organization, 'STORE_MANAGER');
        $staff = $this->member($organization, 'STORE_STAFF');
        $this->signInVendor($inventory);
        $this->patchJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/allotment', ['lock_version' => 1, 'allotment_quantity' => '0'])->assertOk()
            ->assertJsonPath('data.policy.status', 'PAUSED')->assertJsonPath('data.policy.pause_reason', 'ALLOTMENT_EXHAUSTED');
        foreach ([$owner, $manager, $inventory] as $recipient) {
            $this->assertDatabaseHas('notifications', ['user_id' => $recipient->id, 'category' => 'AUTO_ACCEPT', 'title' => 'Auto-accept paused']);
        }
        $this->assertDatabaseMissing('notifications', ['user_id' => $staff->id, 'category' => 'AUTO_ACCEPT']);
        self::assertSame(3, DB::table('outbox_events')->where('event_type', 'VENDOR_INVENTORY_NOTICE')->count());

        // Replenishing the allotment never resumes it.
        $this->patchJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/allotment', ['lock_version' => 2, 'allotment_quantity' => '10'])->assertOk()->assertJsonPath('data.policy.status', 'PAUSED');
        $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/resume', ['lock_version' => 3, 'confirmed_allotment_quantity' => '10'], ['Idempotency-Key' => (string) Str::uuid7()])->assertForbidden();

        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/resume', ['lock_version' => 3, 'confirmed_allotment_quantity' => '10'])->assertUnprocessable()->assertJsonPath('errors.0.code', 'IDEMPOTENCY_KEY_REQUIRED');
        $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/resume', ['lock_version' => 3, 'confirmed_allotment_quantity' => '8'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'AUTO_ACCEPT_ALLOTMENT_CHANGED');
        $key = (string) Str::uuid7();
        $resumed = $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/resume', ['lock_version' => 3, 'confirmed_allotment_quantity' => '10'], ['Idempotency-Key' => $key])->assertOk()
            ->assertJsonPath('data.policy.status', 'ACTIVE')->assertJsonPath('data.policy.remaining_allotment_quantity', '10');
        $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/resume', ['lock_version' => 3, 'confirmed_allotment_quantity' => '10'], ['Idempotency-Key' => $key])->assertOk()->assertJsonPath('data.policy.current_version', $resumed->json('data.policy.current_version'));
        self::assertSame(['CONFIGURED', 'EXHAUSTED', 'ALLOTMENT_UPDATED', 'RESUMED'], DB::table('auto_accept_policy_versions')->orderBy('version')->pluck('change_kind')->all());
        $this->postJson('/api/v1/vendor/auto-accept/policies/'.$variant.'/pause', ['lock_version' => 4])->assertOk()->assertJsonPath('data.policy.pause_reason', 'MANUAL');
        $this->expectException(QueryException::class);
        DB::transaction(fn () => DB::table('auto_accept_policy_versions')->update(['allotment_quantity' => 99]));
    }

    public function test_consumed_allotment_pauses_at_zero_restoration_stays_paused_and_project_or_nrpc_orders_never_auto_accept(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-CONSUME');
        $this->publish($listing)->assertOk();
        $variant = $this->variantIds($listing)[0];
        $this->putJson('/api/v1/vendor/auto-accept/policies/'.$variant, ['lock_version' => 0, 'enabled' => true, 'allotment_quantity' => '3', 'max_unit_count' => '3'])->assertOk();
        $service = app(AutoAcceptPolicyService::class);

        $item = ['procurement_type' => 'ITEM_BASED', 'nrpc_centavos' => 0, 'commercial_total_centavos' => 5400, 'lines' => [['listing_variant_id' => $variant, 'quantity' => '3', 'tax_category' => 'NON_VAT']]];
        DB::transaction(function () use ($service, $variant, $item, $organization): void {
            $locked = app(InventoryLocks::class)->lockForAcceptance([$variant]);
            $policies = array_map(static fn (object $policy): array => AutoAcceptPolicyService::present($policy), $locked['policies']);
            $available = array_map(static fn (object $row): string => bcsub((string) $row->quantity_on_hand, (string) $row->hard_reserved_quantity, 4), $locked['inventory']);
            self::assertTrue(AutoAcceptGate::evaluate($item, $policies, $available)['eligible']);
            foreach ([['procurement_type' => 'PROJECT_BASED'], ['nrpc_centavos' => 100]] as $change) {
                self::assertFalse(AutoAcceptGate::evaluate(array_replace($item, $change), $policies, $available)['eligible']);
            }
            $service->consume($locked['policies'][$variant], '3', $organization->id, 'Listing');
        });
        $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->assertJsonPath('data.policy.status', 'PAUSED')->assertJsonPath('data.policy.remaining_allotment_quantity', '0');
        DB::transaction(fn () => $service->restore(DB::table('auto_accept_policies')->where('listing_variant_id', $variant)->lockForUpdate()->first(), '2'));
        $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->assertJsonPath('data.policy.status', 'PAUSED')->assertJsonPath('data.policy.remaining_allotment_quantity', '2');
        $versions = $this->getJson('/api/v1/vendor/auto-accept/policies/'.$variant)->json('data.versions');
        self::assertSame(['ALLOTMENT_UPDATED', 'EXHAUSTED', 'CONFIGURED'], array_column($versions, 'change_kind'));
        self::assertSame(['Automated policy', 'Automated policy'], array_slice(array_column($versions, 'actor'), 0, 2));
        self::assertFalse($versions[2]['automated']);

        // Database guard: an auto-accept confirmation cannot exist for Project-Based or NRPC orders.
        $versionId = (string) DB::table('auto_accept_policy_versions')->orderByDesc('version')->value('id');
        foreach (['PROJECT_BASED' => 0, 'ITEM_BASED' => 5000] as $type => $nrpc) {
            $orderId = $this->order($organization, $type);
            if ($nrpc > 0) {
                DB::table('nrpc_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'amount_centavos' => $nrpc, 'state' => 'PROPOSED', 'reason' => 'Custom cutting for this order', 'created_at' => now(), 'updated_at' => now()]);
            }
            try {
                DB::transaction(fn () => DB::table('vendor_confirmations')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'source' => 'AUTO_ACCEPT', 'auto_accept_policy_version_id' => $versionId, 'created_at' => now(), 'updated_at' => now()]));
                self::fail('Auto-accept must never confirm a '.$type.' order'.($nrpc > 0 ? ' with NRPC' : ''));
            } catch (QueryException $exception) {
                self::assertMatchesRegularExpression('/Item-Based|NRPC/', $exception->getMessage());
            }
        }
        $itemOrder = $this->order($organization, 'ITEM_BASED');
        DB::table('vendor_confirmations')->insert(['id' => (string) Str::uuid7(), 'order_id' => $itemOrder, 'source' => 'AUTO_ACCEPT', 'auto_accept_policy_version_id' => $versionId, 'created_at' => now(), 'updated_at' => now()]);
        $this->expectException(QueryException::class);
        DB::transaction(fn () => DB::table('nrpc_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $itemOrder, 'amount_centavos' => 100, 'state' => 'PROPOSED', 'reason' => 'Custom cutting for this order', 'created_at' => now(), 'updated_at' => now()]));
    }

    public function test_day_7_and_12_reminders_day_15_hide_and_confirmation_restores_the_listing(): void
    {
        $this->travelTo(CarbonImmutable::parse('2026-10-01 06:00:00', 'Asia/Manila'));
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-STALE', variants: 2);
        $this->publish($listing)->assertOk();
        [$first, $second] = $this->variantIds($listing);

        // Day 7 is due at 06:00 but the reminder waits for the configured 08:00 Asia/Manila time.
        $this->travelTo(CarbonImmutable::parse('2026-10-08 07:00:00', 'Asia/Manila'));
        $this->artisan('materyalph:stock-confirmation-sweep')->assertSuccessful();
        self::assertSame(0, DB::table('notifications')->where('category', 'STOCK_CONFIRMATION')->count());
        $this->travelTo(CarbonImmutable::parse('2026-10-08 10:30:00', 'Asia/Manila'));
        $this->artisan('materyalph:stock-confirmation-sweep')->assertSuccessful();
        $this->artisan('materyalph:stock-confirmation-sweep')->assertSuccessful();
        $this->assertDatabaseHas('notifications', ['user_id' => $owner->id, 'category' => 'STOCK_CONFIRMATION', 'title' => 'Confirm stock']);
        self::assertSame(1, DB::table('stock_confirmation_reminders')->where('stage', 'DAY_7')->count());
        $this->signInVendor($owner);
        $band = $this->getJson('/api/v1/vendor/inventory/items')->assertOk()->json('meta.stale_listings');
        self::assertSame(1, $band['count']);
        self::assertSame('REMINDER', $band['items'][0]['confirmation']['state']);
        self::assertSame('2026-10-15T22:00:00+00:00', $band['items'][0]['confirmation']['hide_at']);

        // Confirming only one variant leaves the listing's oldest active variant in charge of the schedule.
        $this->travelTo(CarbonImmutable::parse('2026-10-11 10:00:00', 'Asia/Manila'));
        $this->signInVendor($owner);
        $this->postJson('/api/v1/vendor/inventory/confirmations', ['items' => [['listing_variant_id' => $first, 'lock_version' => $this->rowVersion($first)]]])->assertOk();
        $this->travelTo(CarbonImmutable::parse('2026-10-13 10:00:00', 'Asia/Manila'));
        $this->artisan('materyalph:stock-confirmation-sweep')->assertSuccessful();
        $this->assertDatabaseHas('notifications', ['user_id' => $owner->id, 'title' => 'Final reminder: confirm stock']);

        $this->travelTo(CarbonImmutable::parse('2026-10-16 10:00:00', 'Asia/Manila'));
        $this->artisan('materyalph:stock-confirmation-sweep')->assertSuccessful();
        $this->signInVendor($owner);
        $this->assertDatabaseHas('vendor_listings', ['id' => $listing, 'status' => 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED']);
        $this->assertDatabaseHas('listing_status_history', ['vendor_listing_id' => $listing, 'to_status' => 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'reason_code' => 'STOCK_NOT_CONFIRMED', 'source' => 'SYSTEM']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'store_activation_status' => 'ACTIVE']);
        $this->assertDatabaseHas('notifications', ['user_id' => $owner->id, 'title' => 'Listing temporarily hidden']);

        $this->postJson('/api/v1/vendor/inventory/confirmations', ['items' => [['listing_variant_id' => $first, 'lock_version' => $this->rowVersion($first)], ['listing_variant_id' => $second, 'lock_version' => 99]]])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'STALE_VERSION');
        $this->assertDatabaseHas('vendor_listings', ['id' => $listing, 'status' => 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED']);
        $this->postJson('/api/v1/vendor/inventory/confirmations', ['items' => [['listing_variant_id' => $first, 'lock_version' => $this->rowVersion($first)], ['listing_variant_id' => $second, 'lock_version' => $this->rowVersion($second)]]])->assertOk();
        $this->assertDatabaseHas('vendor_listings', ['id' => $listing, 'status' => 'ACTIVE']);
        $this->assertDatabaseHas('listing_status_history', ['vendor_listing_id' => $listing, 'to_status' => 'ACTIVE', 'reason_code' => 'STOCK_CONFIRMED']);
        $this->assertDatabaseHas('vendor_organizations', ['id' => $organization->id, 'marketplace_discoverability_status' => 'DISCOVERABLE']);
        $this->travelBack();
    }

    public function test_eligibility_changes_publish_one_bounded_outbox_event_that_invalidates_current_counts(): void
    {
        [$organization, $owner] = $this->activeStore();
        $this->signInVendor($owner);
        $listing = $this->publishableListing('CHB-CACHE');
        $this->publish($listing)->assertOk();
        self::assertSame(1, app(EligibleOfferQuery::class)->currentCounts()['listings']);
        $generation = EligibleOfferQuery::generation();
        $variant = $this->variantIds($listing)[0];
        $this->patchJson('/api/v1/vendor/inventory/items/'.$variant, ['lock_version' => $this->rowVersion($variant), 'quantity_on_hand' => '0', 'reason_code' => 'COUNT'])->assertOk()->assertJsonPath('data.public_label', 'OUT_OF_STOCK');
        $events = DB::table('outbox_events')->where('event_type', 'MARKETPLACE_ELIGIBILITY_CHANGED')->where('aggregate_id', $organization->id)->get();
        self::assertNotEmpty($events);
        self::assertNotNull($events->last()->processed_at);
        self::assertGreaterThan($generation, EligibleOfferQuery::generation());
        self::assertSame(0, app(EligibleOfferQuery::class)->currentCounts()['listings']);
        self::assertStringNotContainsString('quantity', (string) Crypt::decryptString(json_decode((string) $events->last()->payload, true)['sealed_payload']));
    }

    public function test_owner_and_manager_manage_typed_vehicles_while_staff_cannot_change_commercial_configuration(): void
    {
        [$organization, $owner] = $this->activeStore(delivery: true);
        $manager = $this->member($organization, 'STORE_MANAGER');
        $this->signInVendor($manager);
        $image = $this->vehicleImage();
        $this->getJson('/api/v1/vendor/fleet/vehicle-images/'.$image)->assertOk()->assertJsonStructure(['data' => ['url', 'expires_at']]);

        $mixer = $this->vehicle($image, ['vehicle_type' => 'CONCRETE_MIXER', 'name' => 'Mixer', 'mixer_capacity_m3' => 6, 'capacity_kg' => 24000, 'cargo_length_m' => null, 'cargo_width_m' => null, 'cargo_height_m' => null]);
        $invalid = $this->vehicle($image, ['capacity_kg' => 0, 'number_available' => 0, 'base_fee_centavos' => -1]);
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image), $invalid]])->assertUnprocessable()
            ->assertJsonPath('errors.0.details', fn (array $details): bool => isset($details['vehicles.1.capacity_kg'], $details['vehicles.1.number_available'], $details['vehicles.1.base_fee_centavos']) && ! isset($details['vehicles.0.capacity_kg']));
        $saved = $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image), $mixer, $this->vehicle($image, ['name' => 'Spare van', 'vehicle_category' => 'VAN', 'vehicle_type' => 'MID_SIZE_CARGO_VAN', 'available' => false])]])->assertOk()->assertJsonCount(3, 'data');
        [$box, $mixerRow, $van] = $saved->json('data');
        self::assertTrue($box['eligibility']['eligible']);
        self::assertNull($mixerRow['cargo_length_m']);
        self::assertSame(['VEHICLE_UNAVAILABLE'], $van['eligibility']['reasons']);
        self::assertCount(2, app(DeliveryRecommendationService::class)->eligibleVehicles($organization->id));

        // Stale edits conflict; foreign vehicles are indistinguishable from missing ones.
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image, ['id' => $box['id'], 'lock_version' => $box['lock_version'] + 5])]])->assertStatus(409)->assertJsonPath('errors.0.code', 'STALE_VERSION');
        [$other] = $this->activeStore('Other Store', delivery: true);
        $foreign = (string) Str::uuid7();
        DB::table('vendor_vehicles')->insert(['id' => $foreign, 'vendor_organization_id' => $other->id, 'vehicle_type' => 'BOX_TRUCK', 'vehicle_category' => 'TRUCK', 'name' => 'Foreign', 'capacity_kg' => 1000, 'number_available' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image, ['id' => $foreign, 'lock_version' => 1])]])->assertNotFound();

        // Disable, then remove: removed configurations disappear from future proposals but keep their versions.
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image, ['id' => $box['id'], 'lock_version' => $box['lock_version'], 'active' => false])]])->assertOk()
            ->assertJsonPath('data.0.eligibility.reasons', ['VEHICLE_DISABLED']);
        $current = (int) DB::table('vendor_vehicles')->where('id', $box['id'])->value('lock_version');
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [['id' => $box['id'], 'lock_version' => $current, 'removed' => true]]])->assertOk()->assertJsonCount(2, 'data');
        self::assertSame(3, DB::table('vendor_vehicle_versions')->where('vendor_vehicle_id', $box['id'])->count());
        self::assertCount(1, app(DeliveryRecommendationService::class)->eligibleVehicles($organization->id));

        foreach (['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $this->signInVendor($this->member($organization, $role));
            $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image, ['id' => $mixerRow['id'], 'lock_version' => $mixerRow['lock_version'], 'base_fee_centavos' => 1])]])->assertForbidden();
            $this->post('/api/v1/vendor/fleet/vehicle-images', ['file' => UploadedFile::fake()->image('staff.png')])->assertForbidden();
        }
        $this->signInVendor($owner);
        $this->getJson('/api/v1/vendor/fleet/vehicles')->assertOk()->assertJsonPath('meta.delivery.delivery_enabled', true)->assertJsonPath('meta.delivery.service_radius_km', 50);
    }

    public function test_confirmed_delivery_snapshot_freezes_rates_vehicles_and_addresses_and_supports_manual_review(): void
    {
        [$organization, $owner] = $this->activeStore(delivery: true);
        $this->signInVendor($owner);
        $image = $this->vehicleImage();
        $box = $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image)]])->assertOk()->json('data.0');
        $orderId = $this->order($organization, 'ITEM_BASED');
        $intended = ['latitude' => 14.55, 'longitude' => 121.02];
        $alternative = ['latitude' => 14.56, 'longitude' => 121.03];
        $load = ['groups' => [['material_kind' => 'CARGO', 'weight_kg' => 1600, 'unit_count' => 40, 'length_m' => 0.6, 'width_m' => 0.4, 'height_m' => 0.15]], 'distance_meters' => 12000, 'heavy_vehicle_restriction' => true, 'intended_location' => $intended, 'alternative_drop_off' => $alternative, 'route_destination' => $alternative, 'route_source' => 'GOOGLE_ROUTES', 'site_access_confirmed' => true, 'heavy_vehicle_access_confirmed' => true];
        $advice = app(DeliveryRecommendationService::class)->recommend($organization->id, $load);
        self::assertSame('CANDIDATES_AVAILABLE', $advice['status']);
        self::assertSame('ALTERNATIVE_DROP_OFF', $advice['endpoint']);
        self::assertFalse($advice['dispatch']);
        $trips = $advice['candidates'][0]['total_vehicle_trips'];
        self::assertSame(2, $trips, 'Payload of 1,000 kg carries 25 bags of 40 kg per trip.');
        $fee = (50000 + intdiv(2500 * 12000 + 500, 1000)) * $trips;
        $today = now('Asia/Manila')->toDateString();
        $snapshot = app(ConfirmedDeliverySnapshot::class);

        $this->expectedDomainError(fn () => $snapshot->record($owner, $orderId, $load, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => $trips]], $fee + 100, 'Undisclosed extra', $today), 'DELIVERY_FEE_CHANGED');
        $this->expectedDomainError(fn () => $snapshot->record($owner, $orderId, $load, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], $fee / 2, 'Too few trips', $today), 'DELIVERY_CAPACITY_INSUFFICIENT');
        $this->expectedDomainError(fn () => $snapshot->record($owner, $orderId, $load, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 5, 'total_vehicle_trips' => 5]], $fee, 'More vehicles than configured', $today), 'DELIVERY_VEHICLE_INELIGIBLE');
        $staff = $this->member($organization, 'STORE_STAFF');
        $this->expectedDomainError(fn () => $snapshot->record($staff, $orderId, $load, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => $trips]], $fee, 'Staff attempt', $today), 'PERMISSION_DENIED');

        $id = $snapshot->record($owner, $orderId, $load, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => $trips]], $fee, 'Two trips to the guarded gate.', $today);
        $frozen = DB::table('order_delivery_snapshots')->where('id', $id)->first();
        $data = json_decode((string) $frozen->snapshot, true);
        self::assertSame($intended, $data['intended_location']);
        self::assertSame($alternative, $data['drop_off']);
        self::assertSame('ALTERNATIVE_DROP_OFF', $data['endpoint']);
        self::assertSame('ADVISORY_CONFIRMED', $frozen->basis);
        self::assertSame($today, (string) $frozen->fulfillment_date);
        $rateVersion = $data['vehicles'][0]['rate_version_id'];
        self::assertNotNull($data['vehicles'][0]['vehicle_version_id']);
        self::assertSame('1000.0000', $data['vehicles'][0]['configuration']['capacity_kg']);

        // Later rate and capacity edits affect future proposals only.
        $this->putJson('/api/v1/vendor/fleet/vehicles', ['vehicles' => [$this->vehicle($image, ['id' => $box['id'], 'lock_version' => $box['lock_version'], 'capacity_kg' => 2000, 'base_fee_centavos' => 99000])]])->assertOk();
        self::assertSame($frozen->snapshot, DB::table('order_delivery_snapshots')->where('id', $id)->value('snapshot'));
        $this->assertDatabaseHas('vehicle_rate_versions', ['id' => $rateVersion, 'base_fee_centavos' => 50000]);
        try {
            DB::transaction(fn () => DB::table('vehicle_rate_versions')->where('id', $rateVersion)->update(['base_fee_centavos' => 1]));
            self::fail('Rate versions are immutable.');
        } catch (QueryException $exception) {
            self::assertStringContainsString('append-only', $exception->getMessage());
        }

        // Unknown measurements need a named manual review, never a zero load or fee.
        $unknown = array_replace($load, ['groups' => [['material_kind' => 'CARGO', 'unit_count' => 10]]]);
        $review = app(DeliveryRecommendationService::class)->recommend($organization->id, $unknown);
        self::assertSame('MANUAL_REVIEW_REQUIRED', $review['status']);
        self::assertSame(['WEIGHT_UNKNOWN', 'UNIT_DIMENSIONS_UNKNOWN'], $review['groups'][0]['manual_review_reasons']);
        $second = $this->order($organization, 'ITEM_BASED');
        $newFee = 99000 + intdiv(2500 * 12000 + 500, 1000);
        $this->expectedDomainError(fn () => $snapshot->record($owner, $second, $unknown, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], $newFee, 'Manual', $today), 'DELIVERY_MANUAL_REVIEW_REQUIRED');
        $manual = $snapshot->record($owner, $second, $unknown, [['vehicle_id' => $box['id'], 'number_of_vehicles' => 1, 'total_vehicle_trips' => 1]], $newFee, 'One trip', $today, 'Weighed ten bundles at the yard: about 300 kg total.');
        self::assertSame('MANUAL_REVIEW', DB::table('order_delivery_snapshots')->where('id', $manual)->value('basis'));
    }

    /** @return array{VendorOrganization, User} */
    private function activeStore(string $name = 'Phase Five Store', bool $delivery = false): array
    {
        $organization = VendorOrganization::query()->create(['legal_name' => $name.' Legal', 'store_name' => $name]);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['account_status' => 'ACTIVE', 'store_activation_status' => 'ACTIVE', 'store_verification_status' => 'APPROVED', 'store_setup_status' => 'COMPLETED']);
        $storeProfileId = (string) Str::uuid7();
        DB::table('store_profiles')->insert(['id' => $storeProfileId, 'vendor_organization_id' => $organization->id, 'public_store_name' => $name, 'status' => 'COMPLETED', 'fulfillment_method' => $delivery ? 'BOTH' : 'SELF_PICKUP', 'created_at' => now(), 'updated_at' => now()]);
        if ($delivery) {
            DB::table('delivery_service_areas')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'area_type' => 'RADIUS', 'maximum_distance_km' => 50, 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
        }
        app(StoreOperatingSchedule::class)->replaceWeekly($storeProfileId, array_map(fn (int $day): array => ['day_of_week' => $day, 'status' => 'OPEN', 'opens_at' => '08:00', 'closes_at' => '17:00'], range(1, 7)));
        $owner = $this->member($organization, 'OWNER');
        $profileId = (string) Str::uuid7();
        DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization->id, 'status' => 'APPROVED', 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
        $versionId = (string) Str::uuid7();
        DB::table('vendor_tax_profile_versions')->insert(['id' => $versionId, 'vendor_tax_profile_id' => $profileId, 'version' => 1, 'taxpayer_key_hash' => hash('sha256', $name), 'entity_class' => 'NON_INDIVIDUAL', 'registration_category' => 'BIR_REGISTERED', 'vat_category' => 'NON_VAT', 'vat_verified_category' => 'NON_VAT', 'effective_from' => now(), 'submitted_by_user_id' => $owner->id, 'content_hash' => hash('sha256', $versionId), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $versionId]);
        $organization->refresh();

        return [$organization, $owner];
    }

    private function publishableListing(string $sku, int $variants = 1): string
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Listing '.$sku, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, [
            'lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => 'BrandCo', 'manufacturer' => 'Sample Block Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => ['thickness_mm' => '100'],
        ])->assertOk();
        $rows = [];
        for ($index = 1; $index <= $variants; $index++) {
            $rows[] = ['sku' => $sku.'-V'.$index, 'label' => 'Variant '.$index, 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => '1', 'price_centavos' => 1800, 'tax_category' => 'NON_VAT', 'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => '100'];
        }
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => $rows])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Product photo'])->assertCreated();

        return $listing;
    }

    private function publish(string $listing): TestResponse
    {
        return $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    /** @return list<string> */
    private function variantIds(string $listing): array
    {
        return DB::table('listing_variants')->where('vendor_listing_id', $listing)->where('active', true)->orderBy('sort_order')->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
    }

    private function rowVersion(string $variantId): int
    {
        return (int) DB::table('inventory_items')->where('listing_variant_id', $variantId)->value('lock_version');
    }

    private function vehicleImage(): string
    {
        return (string) $this->post('/api/v1/vendor/fleet/vehicle-images', ['file' => UploadedFile::fake()->image('truck.png')])->assertCreated()->json('data.file_id');
    }

    /**
     * @param  array<string, mixed>  $changes
     * @return array<string, mixed>
     */
    private function vehicle(?string $image, array $changes = []): array
    {
        return array_replace(['vehicle_category' => 'TRUCK', 'vehicle_type' => 'BOX_TRUCK', 'name' => 'Box truck', 'brand' => 'Isuzu', 'image_file_id' => $image, 'number_available' => 2, 'capacity_kg' => 1000, 'cargo_length_m' => 4, 'cargo_width_m' => 2, 'cargo_height_m' => 2, 'heavy_classification' => 'HEAVY', 'base_fee_centavos' => 50000, 'per_km_centavos' => 2500, 'maximum_distance_km' => 40, 'active' => true, 'available' => true], $changes);
    }

    private function order(VendorOrganization $organization, string $type): string
    {
        $buyer = User::factory()->create(['account_type' => 'BUYER']);
        $buyerId = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $buyerId, 'user_id' => $buyer->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $orderId = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $orderId, 'reference' => 'P5-'.Str::upper(Str::random(8)), 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $organization->id, 'procurement_type' => $type, 'order_state' => 'CONFIRMED', 'fulfillment_method' => 'DELIVERY', 'payment_method' => 'CASH_ON_DELIVERY', 'materials_centavos' => 100000, 'commercial_total_centavos' => 100000, 'created_at' => now(), 'updated_at' => now()]);

        return $orderId;
    }

    private function expectedDomainError(callable $action, string $code): void
    {
        try {
            DB::transaction($action);
            self::fail('Expected '.$code.'.');
        } catch (AuthenticationException $exception) {
            self::assertSame($code, $exception->errorCode);
        }
    }

    private function member(VendorOrganization $organization, string $role): User
    {
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $user->getKey(), 'role' => $role, 'status' => 'ACTIVE', 'can_manage_staff' => false]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE5TESTSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInVendor(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api');
    }
}
