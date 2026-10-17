<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\CustomTags;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Demo\DemoVendorMarketplace;
use App\Domain\Identity\ProfilePhotoScanner;
use App\Domain\Vendors\StoreActivationGate;
use App\Domain\Vendors\VendorDeliveryEligibility;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

final class DemoVendorSeedTest extends TestCase
{
    use RefreshDatabase;

    private string $credentials;

    private string $photos;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        config()->set('materyalph.demo.email_base', 'owner@example.test');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->mock(ProfilePhotoScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->credentials = sys_get_temp_dir().DIRECTORY_SEPARATOR.'demo-vendor-credentials-'.bin2hex(random_bytes(4)).'.json';
        $this->photos = $this->placeholderPhotos();
        config()->set('materyalph.demo.photo_directory', $this->photos);
    }

    protected function tearDown(): void
    {
        if (is_file($this->credentials)) {
            unlink($this->credentials);
        }
        File::deleteDirectory($this->photos);
        parent::tearDown();
    }

    /** The real photos are third-party images kept out of git, so tests use one generated JPEG per manifest entry. */
    private function placeholderPhotos(): string
    {
        $directory = sys_get_temp_dir().DIRECTORY_SEPARATOR.'demo-vendor-photos-'.bin2hex(random_bytes(4));
        $image = imagecreatetruecolor(400, 400);
        imagefill($image, 0, 0, (int) imagecolorallocate($image, 200, 210, 220));
        ob_start();
        imagejpeg($image, null, 80);
        $jpeg = (string) ob_get_clean();
        $manifest = $this->manifest();
        foreach ($manifest['products'] as $key => $photos) {
            foreach (array_keys($photos) as $index) {
                File::ensureDirectoryExists($directory.'/products/'.dirname($key));
                file_put_contents($directory.'/products/'.$key.'-'.($index + 1).'.jpg', $jpeg);
            }
        }
        foreach ($manifest['vendors'] as $slug => $kinds) {
            File::ensureDirectoryExists($directory.'/vendors/'.$slug);
            foreach (array_keys($kinds) as $kind) {
                file_put_contents($directory.'/vendors/'.$slug.'/'.$kind.'.jpg', $jpeg);
            }
        }

        return $directory;
    }

    /** @return array<string, mixed> */
    private function manifest(): array
    {
        return json_decode((string) file_get_contents(base_path('database/demo-assets/photo-sources.json')), true, flags: JSON_THROW_ON_ERROR);
    }

    private function seedTwo(): void
    {
        $code = Artisan::call('materyalph:demo-vendors-seed', ['--only' => ['bahay-toro-electrical', 'palanan-paint'], '--payments' => 'simulate', '--credentials' => $this->credentials]);
        self::assertSame(0, $code, Artisan::output());
    }

    public function test_every_catalog_product_has_attributed_photos_tags_and_stays_clear_of_regulated_materials(): void
    {
        $blueprint = app(DemoVendorMarketplace::class)->blueprint();
        $manifest = $this->manifest();
        self::assertCount(10, $blueprint['vendors']);
        $regulated = DB::table('materials')->where('regulated', true)->pluck('code')->all();
        foreach ($blueprint['vendors'] as $vendor) {
            self::assertCount(12, $vendor['products'], $vendor['slug']);
            $assets = ['logo.png', 'owner.jpg', 'staff.jpg', 'doc-registration.jpg', 'doc-lgu-permit.jpg', 'doc-bir-cor.jpg', 'doc-identity.jpg'];
            if ($vendor['delivery'] !== null) {
                $assets[] = 'fulfillment.jpg';
                self::assertArrayHasKey('vehicle', $manifest['vendors'][$vendor['slug']]);
            }
            foreach ($assets as $asset) {
                self::assertFileExists(base_path('database/demo-assets/vendors/'.$vendor['slug'].'/'.$asset));
            }
            self::assertArrayHasKey('banner', $manifest['vendors'][$vendor['slug']]);
            foreach ($vendor['products'] as $product) {
                self::assertNotContains($product['mat'], $regulated, $product['sku'].' must not use a regulated material.');
                self::assertLessThanOrEqual(3, count($product['tags']), $product['sku']);
                self::assertNotEmpty($product['custom_tags'], $product['sku']);
                self::assertSame([], CustomTags::invalid($product['custom_tags']), $product['sku']);
                $photos = $manifest['products'][$vendor['slug'].'/'.$product['sku']] ?? [];
                self::assertNotEmpty($photos, $product['sku'].' needs a photo.');
                foreach ($photos as $photo) {
                    self::assertStringStartsWith('https://', $photo['url']);
                    self::assertNotEmpty($photo['source']);
                    self::assertNotEmpty($photo['license'], $product['sku'].' photos record their license.');
                }
            }
        }
        self::assertCount(120, $manifest['products']);
    }

    public function test_seeds_fully_onboarded_discoverable_vendors_with_delivery_media_and_listings(): void
    {
        $this->seedTwo();
        $manifest = $this->manifest();

        $organizations = DB::table('vendor_organizations')->whereIn('store_name', ['Bahay Toro Electrical Trading', 'Palanan Paint & Coatings Center'])->get();
        self::assertCount(2, $organizations);
        foreach ($organizations as $organization) {
            $slug = $organization->store_name === 'Bahay Toro Electrical Trading' ? 'bahay-toro-electrical' : 'palanan-paint';
            $expectedPhotos = array_sum(array_map(count(...), array_filter($manifest['products'], fn (string $key): bool => str_starts_with($key, $slug.'/'), ARRAY_FILTER_USE_KEY)));
            self::assertSame('APPROVED', $organization->store_verification_status);
            self::assertSame('COMPLETED', $organization->store_setup_status);
            self::assertSame('ACTIVE', $organization->store_activation_status);
            self::assertSame('DISCOVERABLE', $organization->marketplace_discoverability_status);
            self::assertTrue(app(StoreActivationGate::class)->evaluate((string) $organization->id)['ready'], 'The real activation gate must pass.');
            $profile = DB::table('store_profiles')->where('vendor_organization_id', $organization->id)->first();
            self::assertNotNull($profile->logo_file_id);
            self::assertNotNull($profile->banner_file_id);
            self::assertSame(2, DB::table('store_media')->where('store_profile_id', $profile->id)->where('status', 'READY')->count());
            self::assertSame(7, DB::table('operating_hours')->where('store_profile_id', $profile->id)->count());
            self::assertSame(12, DB::table('vendor_listings')->where('vendor_organization_id', $organization->id)->where('status', 'ACTIVE')->count());
            self::assertSame($expectedPhotos, DB::table('listing_media as m')->join('vendor_listings as l', 'l.id', '=', 'm.vendor_listing_id')->where('l.vendor_organization_id', $organization->id)->where('m.status', 'READY')->count());
            self::assertSame(0, DB::table('vendor_listings')->where('vendor_organization_id', $organization->id)->where('regulated', true)->count());
            foreach (DB::table('vendor_listings')->where('vendor_organization_id', $organization->id)->pluck('id') as $listingId) {
                self::assertNotEmpty(CustomTags::forListing((string) $listingId), 'Each listing carries Vendor-typed search tags.');
            }
            foreach (DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization->id)->get(['u.id', 'u.profile_photo_key', 'm.role']) as $member) {
                self::assertNotNull($member->profile_photo_key, $member->role.' needs a profile photo.');
                self::assertTrue(DB::table('totp_factors')->where('user_id', $member->id)->whereNotNull('confirmed_at')->exists(), $member->role.' needs an authenticator factor.');
            }
            self::assertSame('CONNECTED_TEST', DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->value('connection_status'));
        }

        $electrical = (string) DB::table('vendor_organizations')->where('store_name', 'Bahay Toro Electrical Trading')->value('id');
        $paint = (string) DB::table('vendor_organizations')->where('store_name', 'Palanan Paint & Coatings Center')->value('id');
        self::assertTrue(app(VendorDeliveryEligibility::class)->available($electrical), 'The delivery Vendor needs staff, a vehicle, a pickup point and a service distance.');
        self::assertFalse(app(VendorDeliveryEligibility::class)->available($paint), 'The Self-Pickup Vendor does not offer delivery.');
        self::assertSame('FULFILLMENT', DB::table('vendor_memberships')->where('vendor_organization_id', $electrical)->where('role', 'FULFILLMENT')->value('role'));
        self::assertSame(2, (int) app(EligibleOfferQuery::class)->currentCounts()['vendors']);
        self::assertGreaterThanOrEqual(24, (int) app(EligibleOfferQuery::class)->currentCounts()['listings']);
        self::assertGreaterThan(0, DB::table('listing_price_versions')->where('price_kind', 'VOLUME_TIER')->count(), 'Bulk pricing tiers are seeded.');
    }

    public function test_all_ten_vendors_publish_every_listing_and_cover_both_fulfillment_modes(): void
    {
        $code = Artisan::call('materyalph:demo-vendors-seed', ['--payments' => 'simulate', '--credentials' => $this->credentials]);
        self::assertSame(0, $code, Artisan::output());

        self::assertSame(10, DB::table('vendor_organizations')->where('store_activation_status', 'ACTIVE')->where('marketplace_discoverability_status', 'DISCOVERABLE')->count());
        self::assertSame(120, DB::table('vendor_listings')->where('status', 'ACTIVE')->count(), Artisan::output());
        self::assertSame(10, (int) app(EligibleOfferQuery::class)->currentCounts()['vendors']);
        self::assertSame(120, (int) app(EligibleOfferQuery::class)->currentCounts()['listings']);
        self::assertSame(7, DB::table('store_profiles')->whereIn('fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])->count());
        self::assertSame(3, DB::table('store_profiles')->where('fulfillment_method', 'SELF_PICKUP')->count());
        foreach (DB::table('vendor_organizations')->pluck('id') as $id) {
            self::assertTrue(app(StoreActivationGate::class)->evaluate((string) $id)['ready']);
        }
        foreach (DB::table('store_profiles')->whereIn('fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])->pluck('vendor_organization_id') as $id) {
            self::assertTrue(app(VendorDeliveryEligibility::class)->available((string) $id));
        }
    }

    public function test_rerunning_is_idempotent_and_never_prints_or_commits_secrets(): void
    {
        $this->seedTwo();
        $counts = fn (): array => [DB::table('users')->count(), DB::table('vendor_organizations')->count(), DB::table('vendor_listings')->count(), DB::table('listing_media')->count(), DB::table('files')->count(), DB::table('vendor_vehicles')->count()];
        $before = $counts();
        DB::table('inventory_items')->update(['confirmed_at' => now()->subDays(30)]);

        $this->artisan('materyalph:demo-vendors-seed', ['--only' => ['bahay-toro-electrical', 'palanan-paint'], '--payments' => 'simulate', '--credentials' => $this->credentials])->assertSuccessful();

        self::assertSame($before, $counts());
        self::assertSame(0, DB::table('inventory_items')->where('confirmed_at', '<', now()->subDay())->count(), 'A re-run refreshes stale stock confirmations.');
        $file = json_decode((string) file_get_contents($this->credentials), true);
        self::assertNotEmpty($file['password']);
        self::assertCount(2, $file['vendors']);
        foreach ($file['vendors'] as $vendor) {
            foreach ($vendor['accounts'] as $account) {
                self::assertMatchesRegularExpression('/^[A-Z2-7]{32}$/', $account['totp_secret']);
            }
        }
        // Passwords are stored only as Argon2id hashes, never as the shared demo password.
        foreach (DB::table('users')->where('account_type', 'VENDOR')->pluck('password') as $hash) {
            self::assertStringStartsWith('$argon2id$', (string) $hash);
            self::assertFalse(password_verify('wrong', (string) $hash));
            self::assertTrue(password_verify((string) $file['password'], (string) $hash));
        }
    }

    public function test_it_refuses_to_run_in_production(): void
    {
        $this->app['env'] = 'production';

        $this->artisan('materyalph:demo-vendors-seed', ['--payments' => 'simulate', '--credentials' => $this->credentials])->assertFailed();
        self::assertSame(0, DB::table('vendor_organizations')->count());
    }
}
