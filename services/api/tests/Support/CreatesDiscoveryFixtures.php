<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Laravel\Passport\AccessToken;

/**
 * Phase 6 fixtures: active Tier 2 stores whose eligible listing is published through the real Vendor catalog
 * API, store points projected an exact geodesic distance from an origin, and signed-in mobile Buyers.
 */
trait CreatesDiscoveryFixtures
{
    protected float $originLatitude = 14.5995;

    protected float $originLongitude = 120.9842;

    /** @return array{0: VendorOrganization, 1: User} */
    protected function activeStore(string $name, bool $withListing = true, bool $delivery = false): array
    {
        $organization = VendorOrganization::query()->create(['legal_name' => $name.' Legal Private Corporation', 'store_name' => $name]);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['account_status' => 'ACTIVE', 'store_activation_status' => 'ACTIVE', 'store_verification_status' => 'APPROVED', 'store_setup_status' => 'COMPLETED']);
        $profileId = (string) Str::uuid7();
        DB::table('store_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization->id, 'public_store_name' => $name, 'description' => 'Construction supplies', 'public_phone' => '+639170000000',
            'status' => 'COMPLETED', 'fulfillment_method' => $delivery ? 'BOTH' : 'SELF_PICKUP', 'bulk_capability' => false, 'created_at' => now(), 'updated_at' => now()]);
        if ($delivery) {
            DB::table('delivery_service_areas')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'area_type' => 'RADIUS', 'maximum_distance_km' => 3, 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
        }
        DB::table('vendor_classifications')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization->id, 'supplier_type' => 'RETAIL_HARDWARE_STORE', 'niches' => json_encode(['Cement']), 'custom_labels' => '[]', 'version' => 1, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        app(StoreOperatingSchedule::class)->replaceWeekly($profileId, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'OPEN', 'opens_at' => '08:00', 'closes_at' => '17:00'], range(1, 7)));
        $owner = $this->storeMember($organization, 'OWNER');
        $taxProfileId = (string) Str::uuid7();
        DB::table('vendor_tax_profiles')->insert(['id' => $taxProfileId, 'vendor_organization_id' => $organization->id, 'status' => 'APPROVED', 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
        $versionId = (string) Str::uuid7();
        DB::table('vendor_tax_profile_versions')->insert(['id' => $versionId, 'vendor_tax_profile_id' => $taxProfileId, 'version' => 1, 'taxpayer_key_hash' => hash('sha256', $name), 'entity_class' => 'NON_INDIVIDUAL', 'registration_category' => 'BIR_REGISTERED', 'vat_category' => 'NON_VAT', 'vat_verified_category' => 'NON_VAT', 'effective_from' => now(), 'submitted_by_user_id' => $owner->id, 'content_hash' => hash('sha256', $versionId), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $taxProfileId)->update(['current_version_id' => $versionId]);
        if ($withListing) {
            $this->signInStoreMember($owner);
            $listing = $this->publishableListing('P6-'.Str::upper(Str::random(6)));
            $this->postJson('/api/v1/vendor/catalog/listings/'.$listing.'/publish', ['lock_version' => (int) DB::table('vendor_listings')->where('id', $listing)->value('lock_version')], ['Idempotency-Key' => (string) Str::uuid7()])->assertOk();
        }

        return [$organization->refresh(), $owner];
    }

    /** Places the store's current verified address point exactly $meters away on a geodesic bearing. */
    protected function placeStore(string $organizationId, float $meters, float $bearingDegrees = 90): void
    {
        $point = DB::selectOne('SELECT ST_Y(p::geometry) AS latitude, ST_X(p::geometry) AS longitude, ST_AsText(p) AS wkt FROM (SELECT ST_Project(ST_SetSRID(ST_MakePoint(?::float8, ?::float8), 4326)::geography, ?::float8, radians(?::float8)) AS p) projected',
            [$this->originLongitude, $this->originLatitude, $meters, $bearingDegrees]);
        $versionId = (string) Str::uuid7();
        $aggregate = DB::table('vendor_addresses')->where('vendor_organization_id', $organizationId)->value('id');
        if ($aggregate === null) {
            $aggregate = (string) Str::uuid7();
            DB::table('vendor_addresses')->insert(['id' => $aggregate, 'vendor_organization_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        }
        $version = (int) DB::table('vendor_address_versions')->where('vendor_address_id', $aggregate)->max('version') + 1;
        DB::statement('INSERT INTO vendor_address_versions (id, vendor_address_id, version, street, barangay, city_municipality, province, formatted_address, country_code, latitude, longitude, source, location, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ST_GeogFromText(?), now())', [$versionId, $aggregate, $version, '123 Aurora Boulevard', 'Poblacion', 'Quezon City', 'Metro Manila',
            '123 Aurora Boulevard, Quezon City, Metro Manila 1109', 'PH', round((float) $point->latitude, 7), round((float) $point->longitude, 7), 'MAP', 'SRID=4326;'.$point->wkt]);
        DB::table('vendor_addresses')->where('id', $aggregate)->update(['current_version_id' => $versionId, 'updated_at' => now()]);
    }

    protected function buyer(?string $email = null): User
    {
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE', 'email_verified_at' => now()] + ($email === null ? [] : ['email' => $email]));
        DB::table('buyer_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $this->signInBuyer($user);

        return $user;
    }

    protected function signInBuyer(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['BUYER']]));
        $this->actingAs($user, 'api');
    }

    protected function buyerProfileId(User $user): string
    {
        return (string) DB::table('buyer_profiles')->where('user_id', $user->id)->value('id');
    }

    /** @param array<string, mixed> $overrides */
    protected function search(array $overrides = []): TestResponse
    {
        return $this->postJson('/api/v1/buyers/discovery/search', array_replace(['latitude' => $this->originLatitude, 'longitude' => $this->originLongitude, 'origin_source' => 'MAP_PIN', 'radius_km' => 5], $overrides));
    }

    private function publishableListing(string $sku): string
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $listing = (string) $this->postJson('/api/v1/vendor/catalog/listings', ['display_name' => 'Listing '.$sku, 'vendor_sku' => $sku], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated()->json('data.id');
        $tag = DB::table('material_tag_links')->where('material_id', $material->id)->value('material_tag_id');
        $this->patchJson('/api/v1/vendor/catalog/listings/'.$listing, [
            'lock_version' => 1, 'material_id' => $material->id, 'material_match' => 'EXACT', 'tag_ids' => [$tag], 'description' => 'Test product',
            'brand' => 'BrandCo', 'manufacturer' => 'Sample Block Corporation', 'manufacturer_address' => 'Test City', 'country_of_manufacture' => 'PH', 'technical_attributes' => ['thickness_mm' => '100'],
        ])->assertOk();
        $this->putJson('/api/v1/vendor/catalog/listings/'.$listing.'/variants', ['lock_version' => 2, 'variants' => [['sku' => $sku.'-V1', 'label' => 'Variant 1', 'unit_id' => $material->canonical_unit_id, 'pack_quantity' => '1', 'price_centavos' => 1800, 'tax_category' => 'NON_VAT', 'weight_kg' => '12', 'length_cm' => '40', 'width_cm' => '10', 'height_cm' => '20', 'quantity_on_hand' => '100']]])->assertOk();
        $this->post('/api/v1/vendor/catalog/listings/'.$listing.'/media', ['file' => UploadedFile::fake()->image($sku.'.png'), 'alt_text' => 'Product photo'])->assertCreated();

        return $listing;
    }

    private function storeMember(VendorOrganization $organization, string $role): User
    {
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $user->getKey(), 'role' => $role, 'status' => 'ACTIVE', 'can_manage_staff' => false]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE6TESTSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    protected function signInStoreMember(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api');
    }
}
