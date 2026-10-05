<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use RuntimeException;

/**
 * Seeds a clearly labelled DEMO marketplace for Materials Analytics (approved by the project owner on 2026-10-04):
 * six "DEMO —" stores near the given origin with current listings in four comparable groups of non-regulated
 * materials (so no product compliance is fabricated), plus simulated daily history published only into the isolated
 * DEMO environment. The history leaves two deliberate missing days, changes participants over time, keeps one group
 * at two sellers and one at a single seller, and never touches the TEST capture dataset. Current offers are real demo
 * listings, so Explore → Materials Analytics → Material Price Details → Product Details works end to end.
 */
final class DemoMaterialsMarketplace
{
    public const NAME_PREFIX = 'DEMO — ';

    /** name, distance metres, bearing degrees, VAT category */
    private const STORES = [
        ['Santos Hardware', 1200, 40, 'NON_VAT'], ['Bayanihan Builders Supply', 2500, 120, 'VAT'], ['Luzon Construction Depot', 3400, 200, 'NON_VAT'],
        ['Rizal Construction Mart', 4100, 300, 'VAT'], ['Pasig Home Supply', 6500, 80, 'NON_VAT'], ['Marikina Masonry Center', 8000, 250, 'NON_VAT'],
    ];

    /** key => [material, brand, specification, unit, display name, base price centavos per pack, pack quantity, sellers (store index => [joins days ago, leaves days ago])] */
    private const GROUPS = [
        'CHB100' => ['CONCRETE_HOLLOW_BLOCK', 'DemoBlock', ['thickness_mm' => '100'], 'PC', '4-inch (100 mm) concrete hollow block — DemoBlock', 1800, '1', [0 => [90, 0], 1 => [90, 0], 2 => [90, 0], 3 => [90, 0], 5 => [20, 0]]],
        'CHB150' => ['CONCRETE_HOLLOW_BLOCK', 'DemoBlock', ['thickness_mm' => '150'], 'PC', '6-inch (150 mm) concrete hollow block — DemoBlock', 2600, '1', [2 => [90, 0]]],
        'THHN35' => ['THHN_WIRE', 'DemoWire', ['size_mm' => '3.5'], 'M', 'THHN wire 3.5 mm² — DemoWire (priced per metre)', 450000, '150', [0 => [90, 0], 1 => [90, 0], 3 => [90, 0], 4 => [90, 30]]],
        'LATEXFLAT' => ['LATEX_PAINT', 'DemoPaint', ['finish' => 'Flat'], 'GAL', 'Flat latex paint, white — DemoPaint (per gallon)', 72000, '1', [1 => [90, 0], 4 => [90, 0]]],
    ];

    /** Days ago with no published run, to show graph gaps (a missed capture is never filled in). */
    public const MISSING_DAYS_AGO = [12, 41];

    public function __construct(private readonly MaterialPriceCaptureService $capture, private readonly ComparableMappingService $mapping) {}

    /** @return array{stores: int, groups: int, runs: int, observations: int} */
    public function seed(float $latitude, float $longitude, int $days = 90, ?CarbonImmutable $today = null): array
    {
        if (app()->isProduction()) {
            throw new RuntimeException('DEMO marketplace data cannot be seeded in production.');
        }
        $today = ($today ?? CarbonImmutable::now())->setTimezone('Asia/Manila')->startOfDay();
        [$stores, $groups, $variants] = DB::transaction(fn (): array => $this->marketplace($latitude, $longitude));
        EligibleOfferQuery::invalidate();
        $runs = 0;
        $observations = 0;
        for ($ago = $days; $ago >= 1; $ago--) {
            if (in_array($ago, self::MISSING_DAYS_AGO, true)) {
                continue;
            }
            $date = $today->subDays($ago);
            if ($this->capture->publishedRun(AnalyticsDataset::DEMO_ENVIRONMENT, AnalyticsDataset::DEMO_DATASET, $date->toDateString()) !== null) {
                continue;
            }
            $rows = [];
            foreach (self::GROUPS as $key => [, , , , , $base, $pack, $sellers]) {
                foreach ($sellers as $store => [$joins, $leaves]) {
                    if ($ago > $joins || $ago <= $leaves) {
                        continue;
                    }
                    $variant = $variants[$key][$store];
                    $amount = self::simulatedPrice($base, $key, $store, $ago);
                    $rows[] = $variant + ['ordinary_payable_centavos' => $amount, 'normalized_php_price' => ComparableMappingService::roundHalfUp(bcdiv(bcdiv((string) $amount, '100', 12), $pack, 12), 8),
                        'price_effective_at' => $date->subDays(1)->setTime(9, 0)->setTimezone('UTC')->toIso8601String()];
                }
            }
            $observedAt = $date->setTime(0, 10)->setTimezone('UTC');
            DB::transaction(function () use ($date, $observedAt, $rows, &$runs, &$observations): void {
                $run = $this->capture->openRun(AnalyticsDataset::DEMO_ENVIRONMENT, AnalyticsDataset::DEMO_DATASET, $date->toDateString(), $observedAt);
                $staged = $this->capture->stage($run, $rows, $observedAt, $date->toDateString(), AnalyticsDataset::DEMO_ENVIRONMENT, AnalyticsDataset::DEMO_DATASET);
                $this->capture->publish($run, $staged);
                $runs++;
                $observations += $staged['observations'];
            });
        }
        AnalyticsDataset::select(AnalyticsDataset::DEMO_ENVIRONMENT);

        return ['stores' => count($stores), 'groups' => count($groups), 'runs' => $runs, 'observations' => $observations];
    }

    /** Deterministic simulated price walk (±6%), centavos, never zero. */
    public static function simulatedPrice(int $base, string $group, int $store, int $daysAgo): int
    {
        $storeOffset = (crc32($group.'|'.$store) % 900) - 450;
        $trend = intdiv($base * (90 - $daysAgo), 90 * 25);
        $noise = (crc32($group.'|'.$store.'|'.intdiv($daysAgo, 7)) % 200) - 100;

        return max(100, $base + intdiv($base * $storeOffset, 10000) + $trend + intdiv($base * $noise, 10000));
    }

    /** @return array{0: list<string>, 1: array<string, string>, 2: array<string, array<int, array<string, mixed>>>} */
    private function marketplace(float $latitude, float $longitude): array
    {
        $stores = [];
        foreach (self::STORES as $index => [$name, $meters, $bearing, $vat]) {
            $stores[$index] = $this->store(self::NAME_PREFIX.$name, $meters, $bearing, $vat, $latitude, $longitude);
        }
        $groups = [];
        $variants = [];
        foreach (self::GROUPS as $key => [$materialCode, $brand, $specification, $unitCode, $display, $base, $pack, $sellers]) {
            $material = DB::table('materials')->where('code', $materialCode)->first(['id', 'material_category_id', 'regulated']);
            $unitId = DB::table('units')->where('code', $unitCode)->value('id');
            if ($material === null || $unitId === null || $material->regulated) {
                throw new RuntimeException('The DEMO taxonomy material '.$materialCode.' is unavailable or regulated.');
            }
            $groups[$key] = $this->group('DEMO_'.$key, $display, (string) $material->id, (string) $material->material_category_id, $brand, $specification, (string) $unitId);
            foreach ($sellers as $store => $window) {
                [$organizationId, $ownerId, $vat] = $stores[$store];
                $variants[$key][$store] = $this->listing($organizationId, $ownerId, $vat, $material, (string) $unitId, $brand, $specification, $display, $pack, self::simulatedPrice($base, $key, $store, 0), $window[1] === 0, $key.'-'.$store);
            }
        }

        return [array_column($stores, 0), $groups, $variants];
    }

    /** @return array{0: string, 1: int, 2: string} */
    private function store(string $name, int $meters, int $bearing, string $vat, float $latitude, float $longitude): array
    {
        $existing = DB::table('vendor_organizations')->where('legal_name', $name)->first(['id']);
        if ($existing !== null) {
            $ownerId = (int) DB::table('vendor_memberships')->where('vendor_organization_id', $existing->id)->where('role', 'OWNER')->value('user_id');

            return [(string) $existing->id, $ownerId, $vat];
        }
        $organizationId = (string) Str::uuid7();
        DB::table('vendor_organizations')->insert(['id' => $organizationId, 'legal_name' => $name, 'store_name' => $name, 'account_status' => 'ACTIVE', 'store_verification_status' => 'APPROVED',
            'store_setup_status' => 'COMPLETED', 'store_activation_status' => 'ACTIVE', 'marketplace_discoverability_status' => 'DISCOVERABLE', 'created_at' => now(), 'updated_at' => now()]);
        $owner = User::query()->create(['name' => $name.' Owner', 'email' => 'demo-'.Str::slug(Str::after($name, self::NAME_PREFIX)).'@demo.materyalph.invalid',
            'password' => Hash::make(Str::random(48)), 'account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('vendor_memberships')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'user_id' => $owner->id, 'role' => 'OWNER', 'status' => 'ACTIVE', 'can_manage_staff' => false, 'created_at' => now(), 'updated_at' => now()]);
        $profileId = (string) Str::uuid7();
        DB::table('store_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organizationId, 'public_store_name' => $name, 'description' => 'Simulated demonstration store for Materials Analytics. Not a real business.',
            'status' => 'COMPLETED', 'fulfillment_method' => 'SELF_PICKUP', 'bulk_capability' => false, 'created_at' => now(), 'updated_at' => now()]);
        app(StoreOperatingSchedule::class)->replaceWeekly($profileId, array_map(static fn (int $day): array => ['day_of_week' => $day, 'status' => 'OPEN', 'opens_at' => '08:00', 'closes_at' => '17:00'], range(1, 7)));
        DB::table('vendor_classifications')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'supplier_type' => 'RETAIL_HARDWARE_STORE', 'niches' => json_encode(['Masonry']), 'custom_labels' => '[]', 'version' => 1, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $taxProfileId = (string) Str::uuid7();
        DB::table('vendor_tax_profiles')->insert(['id' => $taxProfileId, 'vendor_organization_id' => $organizationId, 'status' => 'APPROVED', 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
        $versionId = (string) Str::uuid7();
        DB::table('vendor_tax_profile_versions')->insert(['id' => $versionId, 'vendor_tax_profile_id' => $taxProfileId, 'version' => 1, 'taxpayer_key_hash' => hash('sha256', 'DEMO|'.$name), 'entity_class' => 'NON_INDIVIDUAL',
            'registration_category' => 'BIR_REGISTERED', 'vat_category' => $vat, 'vat_verified_category' => $vat, 'effective_from' => now(), 'submitted_by_user_id' => $owner->id, 'content_hash' => hash('sha256', $versionId), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $taxProfileId)->update(['current_version_id' => $versionId]);
        $point = DB::selectOne('SELECT ST_Y(p::geometry) AS latitude, ST_X(p::geometry) AS longitude, ST_AsText(p) AS wkt FROM (SELECT ST_Project(ST_SetSRID(ST_MakePoint(?::float8, ?::float8), 4326)::geography, ?::float8, radians(?::float8)) AS p) projected',
            [$longitude, $latitude, $meters, $bearing]);
        $addressId = (string) Str::uuid7();
        DB::table('vendor_addresses')->insert(['id' => $addressId, 'vendor_organization_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        $addressVersionId = (string) Str::uuid7();
        DB::statement('INSERT INTO vendor_address_versions (id, vendor_address_id, version, street, city_municipality, province, formatted_address, country_code, latitude, longitude, source, location, created_at) VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ST_GeogFromText(?), now())',
            [$addressVersionId, $addressId, 'DEMO address', 'Metro Manila (DEMO)', 'Metro Manila', 'Simulated DEMO store location', 'PH', round((float) $point->latitude, 7), round((float) $point->longitude, 7), 'MAP', 'SRID=4326;'.$point->wkt]);
        DB::table('vendor_addresses')->where('id', $addressId)->update(['current_version_id' => $addressVersionId]);

        return [$organizationId, (int) $owner->id, $vat];
    }

    /** @param array<string, string> $specification */
    private function group(string $code, string $display, string $materialId, string $categoryId, string $brand, array $specification, string $unitId): string
    {
        $existing = DB::table('material_comparable_groups')->where('code', $code)->value('id');
        if ($existing !== null) {
            return (string) $existing;
        }
        $controlled = ComparableMappingService::controlledSpecification($specification, $this->mapping->comparabilityKeys($categoryId));
        $variantKey = ComparableMappingService::variantKey($brand, null, $controlled);
        $groupId = (string) Str::uuid7();
        $versionId = (string) Str::uuid7();
        DB::table('material_comparable_groups')->insert(['id' => $groupId, 'material_id' => $materialId, 'code' => $code, 'display_name' => $display, 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('material_comparable_group_versions')->insert(['id' => $versionId, 'material_comparable_group_id' => $groupId, 'version' => 1, 'brand' => $brand, 'model' => null,
            'controlled_specification' => json_encode($controlled, JSON_THROW_ON_ERROR), 'variant_key' => $variantKey, 'canonical_unit_id' => $unitId, 'conversion_version' => ComparableMappingService::IDENTITY_CONVERSION,
            'review_state' => 'APPROVED', 'reviewed_at' => now(), 'effective_from' => now(), 'content_hash' => hash('sha256', $variantKey.'|'.$unitId.'|IDENTITY'), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('material_comparable_groups')->where('id', $groupId)->update(['current_version_id' => $versionId]);

        return $groupId;
    }

    /**
     * One published demo listing with one mapped variant and confirmed stock; returns the observation source fields.
     *
     * @param  array<string, string>  $specification
     * @return array<string, mixed>
     */
    private function listing(string $organizationId, int $ownerId, string $vat, object $material, string $unitId, string $brand, array $specification, string $display, string $pack, int $price, bool $current, string $skuKey): array
    {
        $sku = 'DEMO-'.Str::upper(Str::slug($skuKey));
        $listing = DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('vendor_sku', $sku)->first(['id']);
        if ($listing === null) {
            $productId = DB::table('products')->insertGetId(['public_id' => (string) Str::uuid7(), 'name' => $display, 'material_id' => $material->id, 'brand' => $brand, 'created_at' => now(), 'updated_at' => now()]);
            $listingId = (string) Str::uuid7();
            DB::table('vendor_listings')->insert(['id' => $listingId, 'vendor_organization_id' => $organizationId, 'product_id' => $productId, 'vendor_sku' => $sku, 'display_name' => $display,
                'description' => 'Simulated DEMO listing for Materials Analytics.', 'material_category_id' => $material->material_category_id, 'technical_attributes' => json_encode($specification, JSON_THROW_ON_ERROR),
                'material_match' => 'EXACT', 'regulated' => false, 'compliance_status' => 'NOT_REQUIRED', 'status' => $current ? 'ACTIVE' : 'INACTIVE', 'publication_version' => 1, 'published_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $variantId = (string) Str::uuid7();
            DB::table('listing_variants')->insert(['id' => $variantId, 'vendor_listing_id' => $listingId, 'sku' => $sku.'-V1', 'label' => $pack === '1' ? 'Standard' : $pack.' m roll', 'unit_id' => $unitId, 'pack_quantity' => $pack,
                'attributes' => json_encode($specification, JSON_THROW_ON_ERROR), 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
            DB::table('inventory_items')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'quantity_on_hand' => '500', 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => 1, 'amount_centavos' => $price, 'tax_category' => $vat === 'VAT' ? 'VAT_12' : 'NON_VAT',
                'price_kind' => 'ORDINARY', 'effective_at' => now(), 'created_by_user_id' => $ownerId, 'created_at' => now(), 'updated_at' => now()]);
            $this->mapping->assign($variantId);
        }
        $variant = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('listing_price_versions as pv', fn ($j) => $j->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
            ->join('vendor_addresses as va', 'va.vendor_organization_id', '=', 'l.vendor_organization_id')->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')
            ->join('listing_comparable_assignments as ca', fn ($j) => $j->on('ca.listing_variant_id', '=', 'v.id')->where('ca.mapping_state', 'APPROVED')->whereNull('ca.effective_until'))
            ->join('material_comparable_group_versions as gv', 'gv.id', '=', 'ca.material_comparable_group_version_id')
            ->where('l.vendor_organization_id', $organizationId)->where('l.vendor_sku', $sku)->first(['v.id', 'l.id as listing_id', 'pv.id as price_version_id', 'pv.tax_category', 'gv.id as group_version_id', 'gv.material_comparable_group_id', 'av.id as address_version_id', 'av.version']);
        if ($variant === null) {
            throw new RuntimeException('The DEMO listing '.$sku.' could not be mapped to its comparable group.');
        }

        return ['listing_variant_id' => (string) $variant->id, 'vendor_listing_id' => (string) $variant->listing_id, 'vendor_organization_id' => $organizationId, 'listing_price_version_id' => (string) $variant->price_version_id,
            'tax_category' => (string) $variant->tax_category, 'comparable_group_version_id' => (string) $variant->group_version_id, 'comparable_group_id' => (string) $variant->material_comparable_group_id,
            'unit_conversion_version' => ComparableMappingService::IDENTITY_CONVERSION, 'stock_confirmed_at' => now()->toIso8601String(), 'vendor_address_version_id' => (string) $variant->address_version_id,
            'address_version' => (int) $variant->version, 'psgc_region_code' => null, 'psgc_province_code' => null, 'psgc_city_code' => null];
    }
}
