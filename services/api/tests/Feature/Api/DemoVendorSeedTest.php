<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Catalog\CustomTags;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Compliance\RegisterNormalizer;
use App\Domain\Demo\DemoVendorMarketplace;
use App\Domain\Identity\ProfilePhotoScanner;
use App\Domain\Vendors\StoreActivationGate;
use App\Domain\Vendors\VendorDeliveryEligibility;
use App\Domain\Vendors\VendorFileScanner;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Sleep;
use Illuminate\Support\Str;
use Tests\TestCase;

final class DemoVendorSeedTest extends TestCase
{
    use RefreshDatabase;

    private string $credentials;

    private string $photos;

    private string $registers;

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
        $this->registers = $this->registerExtracts();
        config()->set('materyalph.demo.register_directory', $this->registers);
        // Register snapshots are imported and activated by an Admin; reviews of the SAMPLE documents name one too.
        $admin = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $admin->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_COMPLIANCE')->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
    }

    protected function tearDown(): void
    {
        if (is_file($this->credentials)) {
            unlink($this->credentials);
        }
        File::deleteDirectory($this->photos);
        File::deleteDirectory($this->registers);
        parent::tearDown();
    }

    /**
     * The real DTI-BPS register copies in materials/ hold tens of thousands of rows, so tests import only the rows the
     * demo catalog cites, copied verbatim with the official header. A cited number missing from the copies fails here.
     */
    private function registerExtracts(): string
    {
        $directory = sys_get_temp_dir().DIRECTORY_SEPARATOR.'demo-vendor-registers-'.bin2hex(random_bytes(4));
        File::ensureDirectoryExists($directory);
        foreach ($this->registerRows() as $file => $rows) {
            $handle = fopen($directory.DIRECTORY_SEPARATOR.$file, 'w');
            foreach ($rows as $row) {
                fputcsv($handle, $row, escape: '');
            }
            fclose($handle);
        }

        return $directory;
    }

    /** @return array<string, list<list<string>>> Header plus every row matching a cited PS License No. or ICC sticker serial. */
    private function registerRows(): array
    {
        $cited = ['PS_MARK' => [], 'ICC_STICKER' => []];
        foreach (app(DemoVendorMarketplace::class)->blueprint()['vendors'] as $vendor) {
            foreach ($vendor['products'] as $product) {
                if (isset($product['compliance'])) {
                    $cited[$product['compliance']['marking']][] = RegisterNormalizer::number($product['compliance']['number']);
                }
            }
        }
        $materials = dirname(base_path(), 2).'/materials/';
        $read = static function (string $path, callable $keep): array {
            $handle = fopen($path, 'r');
            $header = fgetcsv($handle, escape: '');
            $header[0] = preg_replace('/^\xEF\xBB\xBF/', '', (string) $header[0]);
            $rows = [$header];
            while (($row = fgetcsv($handle, escape: '')) !== false) {
                if ($row !== [null] && $keep(array_combine($header, array_pad($row, count($header), '')))) {
                    $rows[] = $row;
                }
            }
            fclose($handle);

            return $rows;
        };
        $serials = array_map(RegisterNormalizer::serial(...), array_unique($cited['ICC_STICKER']));

        return [
            'List_of_PS_Licensee_MASTERLIST.csv' => $read($materials.'List_of_PS_Licensee_MASTERLIST.csv', fn (array $row): bool => in_array(RegisterNormalizer::number((string) $row['License No.']), $cited['PS_MARK'], true)),
            'List_of_ICC_Certificate_Holders.csv' => $read($materials.'List_of_ICC_Certificate_Holders.csv', function (array $row) use ($serials): bool {
                $from = RegisterNormalizer::serial((string) $row['ICC Sticker Serial No. (From)']);
                $to = RegisterNormalizer::serial((string) $row['ICC Sticker Serial No. (To)']);
                foreach ($serials as $serial) {
                    if ($from !== null && $to !== null && $serial !== null && $from['prefix'] === $serial['prefix'] && $from['number'] <= $serial['number'] && $serial['number'] <= $to['number']) {
                        return true;
                    }
                }

                return false;
            }),
        ];
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

    public function test_every_catalog_product_has_attributed_photos_tags_and_cites_a_register_number_only_when_regulated(): void
    {
        $blueprint = app(DemoVendorMarketplace::class)->blueprint();
        $manifest = $this->manifest();
        self::assertCount(22, $blueprint['vendors']);
        $regulated = DB::table('materials')->where('regulated', true)->pluck('code')->all();
        foreach ($blueprint['vendors'] as $vendor) {
            self::assertCount(in_array($vendor['n'], [11, 12], true) ? 10 : 12, $vendor['products'], $vendor['slug']);
            $assets = ['logo.png', 'owner.jpg', 'staff.jpg', 'doc-registration.jpg', 'doc-lgu-permit.jpg', 'doc-bir-cor.jpg', 'doc-identity.jpg'];
            if ($vendor['delivery'] !== null) {
                $assets[] = 'fulfillment.jpg';
                foreach ($vendor['delivery']['vehicles'] ?? [['photo' => 'vehicle']] as $vehicle) {
                    self::assertArrayHasKey($vehicle['photo'], $manifest['vendors'][$vendor['slug']]);
                }
            }
            foreach ($assets as $asset) {
                self::assertFileExists(base_path('database/demo-assets/vendors/'.$vendor['slug'].'/'.$asset));
            }
            self::assertArrayHasKey('banner', $manifest['vendors'][$vendor['slug']]);
            foreach ($vendor['products'] as $product) {
                // A regulated product cites its PS License No. or ICC sticker serial; nothing else claims a marking.
                self::assertSame(in_array($product['mat'], $regulated, true), isset($product['compliance']), $product['sku']);
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
        self::assertCount(260, $manifest['products']);
        $rows = $this->registerRows();
        $listed = array_map(static fn (array $row): string => RegisterNormalizer::number((string) $row[0]), array_slice($rows['List_of_PS_Licensee_MASTERLIST.csv'], 1));
        foreach ($blueprint['vendors'] as $vendor) {
            foreach ($vendor['products'] as $product) {
                if (($product['compliance']['marking'] ?? null) === 'PS_MARK') {
                    self::assertContains(RegisterNormalizer::number($product['compliance']['number']), $listed, $product['sku'].' cites a PS License No. in materials/.');
                }
            }
        }
        self::assertGreaterThanOrEqual(3, count($rows['List_of_ICC_Certificate_Holders.csv']) - 1, 'Each cited ICC sticker serial lies in a listed range.');
    }

    public function test_ps_and_icc_stores_verify_every_regulated_listing_through_the_register_and_sell_ready_mixed_concrete(): void
    {
        $code = Artisan::call('materyalph:demo-vendors-seed', ['--only' => ['sucat-cement-steel', 'potrero-pipes-tiles'], '--payments' => 'simulate', '--credentials' => $this->credentials]);
        self::assertSame(0, $code, Artisan::output());

        // No snapshot was active, so the register copies were imported and activated by the Admin.
        self::assertSame(['ICC_CERTIFICATE', 'PS_LICENSE'], DB::table('compliance_reference_registers')->where('status', 'ACTIVE')->where('source_channel', 'UPLOAD')->orderBy('register_kind')->pluck('register_kind')->all());
        foreach (['Sucat Cement, Steel & Ready-Mix Supply' => 10, 'Potrero Pipes, Tiles & Sanitary Center' => 10] as $store => $count) {
            $organizationId = (string) DB::table('vendor_organizations')->where('store_name', $store)->value('id');
            self::assertSame('DISCOVERABLE', DB::table('vendor_organizations')->where('id', $organizationId)->value('marketplace_discoverability_status'));
            self::assertSame($count, DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('status', 'ACTIVE')->count(), Artisan::output());
        }
        $regulated = DB::table('vendor_listings')->where('regulated', true)->get(['id', 'compliance_status', 'current_compliance_submission_id']);
        self::assertCount(19, $regulated, 'Every listing except ready-mixed concrete is a regulated PS/ICC product.');
        foreach ($regulated as $listing) {
            self::assertSame('VERIFIED', $listing->compliance_status);
            $submission = DB::table('compliance_submissions')->where('id', $listing->current_compliance_submission_id)->first();
            self::assertSame(['MANUAL', 'AUTOMATIC', 'VERIFIED'], [$submission->path, $submission->review_mode, $submission->status]);
            self::assertSame('MATCHED', DB::table('compliance_reference_matches')->where('compliance_submission_id', $submission->id)->value('result'));
            // Verified by the system register match, never by a written Admin decision.
            self::assertNull(DB::table('compliance_reviews')->where('compliance_submission_id', $submission->id)->value('reviewer_user_id'));
            self::assertSame(1, DB::table('compliance_evidence')->where('compliance_submission_id', $submission->id)->where('evidence_kind', 'MARKING_PHOTO')->count());
        }
        self::assertSame(3, DB::table('compliance_submissions')->where('marking_type', 'ICC_STICKER')->where('status', 'VERIFIED')->count());
        $importer = json_decode((string) DB::table('compliance_submissions as s')->join('vendor_listings as l', 'l.id', '=', 's.vendor_listing_id')->where('l.vendor_sku', 'JBN-6060-IMPORT')->value('s.declared'), true);
        self::assertSame('TA & J GALLERIA CERAMICA', $importer['importer_name'], 'The ICC register record supplies the importer.');
        $maker = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->where('l.vendor_sku', 'HCG-CS4510')->first(['p.manufacturer', 'p.country_of_manufacture']);
        self::assertSame(['HOCHENG PHILIPPINES CORPORATION', 'PH'], [$maker->manufacturer, $maker->country_of_manufacture], 'The PS register record supplies the manufacturer and local origin.');

        $sucat = (string) DB::table('vendor_organizations')->where('store_name', 'Sucat Cement, Steel & Ready-Mix Supply')->value('id');
        $rmc = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->join('materials as m', 'm.id', '=', 'p.material_id')->where('l.vendor_organization_id', $sucat)->where('m.code', 'READY_MIXED_CONCRETE')->first(['l.id', 'l.status', 'l.regulated']);
        self::assertSame(['ACTIVE', false], [$rmc->status, (bool) $rmc->regulated]);
        self::assertSame(['2500', '3000', '3500', '4000'], DB::table('listing_variants')->where('vendor_listing_id', $rmc->id)->orderBy('sku')->pluck('attributes')->map(fn (mixed $attributes): string => (string) json_decode((string) $attributes, true)['compressive_strength_psi'])->all());
        $mixer = DB::table('vendor_vehicles')->where('vendor_organization_id', $sucat)->where('vehicle_type', 'CONCRETE_MIXER')->first(['id', 'mixer_capacity_m3']);
        self::assertSame(6.0, (float) $mixer->mixer_capacity_m3);
        $rate = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $mixer->id)->orderByDesc('version')->first(['mobilization_fee_centavos', 'mobilization_basis']);
        self::assertSame([150000, 'PER_TRUCK'], [(int) $rate->mobilization_fee_centavos, $rate->mobilization_basis]);
        self::assertTrue(app(VendorDeliveryEligibility::class)->mixerOrganizations()->where('delivery_profile.vendor_organization_id', $sucat)->exists(), 'Ready-mixed concrete offers need a delivering store with a mixer.');
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
            // The Admin verification queue reads the region and city from the current Registered business address.
            $business = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organization->id)->where('is_current', true)->sole();
            self::assertSame('National Capital Region (NCR)', $business->province);
            self::assertNotEmpty($business->city_municipality);
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

    public function test_every_vendor_publishes_every_listing_and_covers_both_fulfillment_modes(): void
    {
        $code = Artisan::call('materyalph:demo-vendors-seed', ['--payments' => 'simulate', '--credentials' => $this->credentials]);
        self::assertSame(0, $code, Artisan::output());

        self::assertSame(22, DB::table('vendor_organizations')->where('store_activation_status', 'ACTIVE')->where('marketplace_discoverability_status', 'DISCOVERABLE')->count());
        self::assertSame(260, DB::table('vendor_listings')->where('status', 'ACTIVE')->count(), Artisan::output());
        self::assertSame(22, (int) app(EligibleOfferQuery::class)->currentCounts()['vendors']);
        self::assertSame(260, (int) app(EligibleOfferQuery::class)->currentCounts()['listings']);
        self::assertSame(16, DB::table('store_profiles')->whereIn('fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])->count());
        self::assertSame(6, DB::table('store_profiles')->where('fulfillment_method', 'SELF_PICKUP')->count());
        foreach (DB::table('vendor_organizations')->pluck('id') as $id) {
            self::assertTrue(app(StoreActivationGate::class)->evaluate((string) $id)['ready']);
        }
        foreach (DB::table('store_profiles')->whereIn('fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])->pluck('vendor_organization_id') as $id) {
            self::assertTrue(app(VendorDeliveryEligibility::class)->available((string) $id));
        }

        // Listings that state a reference material's full exact key are price-compared (MAT-03); "Other" listings are not.
        $comparable = DB::table('listing_comparable_assignments as ca')->join('listing_variants as v', 'v.id', '=', 'ca.listing_variant_id')
            ->whereNull('ca.effective_until')->where('ca.mapping_state', 'APPROVED')->distinct()->count('v.vendor_listing_id');
        self::assertGreaterThanOrEqual(75, $comparable, "Only {$comparable} listings are comparable.");
        $tapes = DB::table('material_comparable_groups as g')->join('materials as m', 'm.id', '=', 'g.material_id')->where('m.code', 'TAPE_MEASURE')->pluck('g.display_name')->sort()->values()->all();
        self::assertSame(['Tape measure · Stanley · Size 3 m', 'Tape measure · Stanley · Size 5 m', 'Tape measure · Stanley · Size 8 m'], $tapes, 'Each size is its own variant of one product.');
        // Stores deliberately overlap, so the same exact variant is offered by several Vendors.
        $sellers = DB::table('listing_comparable_assignments as ca')->join('material_comparable_group_versions as gv', 'gv.id', '=', 'ca.material_comparable_group_version_id')
            ->join('material_comparable_groups as g', 'g.id', '=', 'gv.material_comparable_group_id')->join('listing_variants as v', 'v.id', '=', 'ca.listing_variant_id')
            ->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->where('g.display_name', 'Tape measure · Stanley · Size 5 m')->whereNull('ca.effective_until')
            ->distinct()->count('l.vendor_organization_id');
        self::assertSame(3, $sellers, 'Industrial Valley, Avenida and Kapitolyo all sell the Stanley 5 m tape.');
        self::assertSame(0, DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->whereNull('p.material_id')
            ->whereIn('l.other_label', ['LED bulb', 'Plug-in circuit breaker', 'Extension cord'])->where('l.regulated', true)->count(), 'Regulated electrical goods stay unclassified "Other".');
    }

    public function test_rerunning_links_an_already_published_listing_to_its_reference_material_without_touching_prices_or_stock(): void
    {
        $seed = fn () => $this->artisan('materyalph:demo-vendors-seed', ['--only' => ['industrial-valley-tools'], '--payments' => 'simulate', '--credentials' => $this->credentials])->assertSuccessful();
        $seed();
        $listing = DB::table('vendor_listings')->where('vendor_sku', 'ST-TAPE')->first(['id', 'product_id']);
        $variants = DB::table('listing_variants')->where('vendor_listing_id', $listing->id)->pluck('id')->all();
        // The state a store seeded before 2026-10-25 is in: an "Other" listing whose variants state no size.
        DB::table('listing_comparable_assignments')->whereIn('listing_variant_id', $variants)->update(['mapping_state' => 'RETIRED', 'effective_until' => DB::raw("effective_from + interval '1 second'")]);
        DB::table('products')->where('id', $listing->product_id)->update(['material_id' => null]);
        DB::table('vendor_listings')->where('id', $listing->id)->update(['other_label' => 'Tape measure', 'material_match' => 'UNMATCHED']);
        DB::table('listing_variants')->whereIn('id', $variants)->update(['attributes' => '{}']);
        $snapshot = fn (): array => [DB::table('vendor_listings')->count(), DB::table('listing_price_versions')->count(), DB::table('inventory_items')->sum('quantity_on_hand'), DB::table('listing_media')->count()];
        $before = $snapshot();

        $seed();

        self::assertSame('TAPE_MEASURE', DB::table('products as p')->join('materials as m', 'm.id', '=', 'p.material_id')->where('p.id', $listing->product_id)->value('m.code'));
        self::assertSame('ACTIVE', DB::table('vendor_listings')->where('id', $listing->id)->value('status'));
        self::assertSame(['3 m', '5 m', '8 m'], DB::table('listing_variants')->whereIn('id', $variants)->orderBy('sort_order')->pluck('attributes')
            ->map(static fn (string $attributes): string => json_decode($attributes, true)['size'])->all());
        self::assertSame(3, DB::table('listing_comparable_assignments')->whereIn('listing_variant_id', $variants)->whereNull('effective_until')->where('mapping_state', 'APPROVED')->count());
        self::assertEquals($before, $snapshot(), 'No listing, price version, stock count or photo is added or changed.');

        $lock = DB::table('vendor_listings')->where('id', $listing->id)->value('lock_version');
        $seed();
        self::assertSame($lock, DB::table('vendor_listings')->where('id', $listing->id)->value('lock_version'), 'A listing already in sync is not saved again.');
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

    public function test_a_new_xendit_sub_account_is_awaited_until_live_and_its_store_finished_in_the_same_run(): void
    {
        Sleep::fake();
        $xendit = new class implements XenditAccountVerificationGateway
        {
            public int $reconciles = 0;

            public function initiate(string $email, string $businessName): array
            {
                return ['provider_account_id' => 'acct_demo_palanan', 'status' => 'REGISTERED', 'provider_created_at' => '2026-10-17T09:00:00Z'];
            }

            public function reconcile(string $providerAccountId): array
            {
                // REGISTERED for the first pass and the first poll, LIVE afterwards, as Xendit does a few minutes after creation.
                return ['provider_account_id' => $providerAccountId, 'status' => ++$this->reconciles <= 2 ? 'REGISTERED' : 'LIVE', 'capabilities' => []];
            }
        };
        $this->app->instance(XenditAccountVerificationGateway::class, $xendit);

        $this->artisan('materyalph:demo-vendors-seed', ['--only' => ['palanan-paint'], '--credentials' => $this->credentials])->assertSuccessful();

        Sleep::assertSleptTimes(2);
        $organization = DB::table('vendor_organizations')->where('store_name', 'Palanan Paint & Coatings Center')->first(['id', 'store_activation_status']);
        self::assertSame('ACTIVE', $organization->store_activation_status);
        self::assertSame('CONNECTED_TEST', DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->value('connection_status'));
        self::assertSame(12, DB::table('vendor_listings')->where('vendor_organization_id', $organization->id)->where('status', 'ACTIVE')->count());
    }

    public function test_it_refuses_to_run_in_production(): void
    {
        $this->app['env'] = 'production';

        $this->artisan('materyalph:demo-vendors-seed', ['--payments' => 'simulate', '--credentials' => $this->credentials])->assertFailed();
        self::assertSame(0, DB::table('vendor_organizations')->count());
    }
}
