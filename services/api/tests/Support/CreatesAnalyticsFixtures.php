<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Analytics\MaterialPriceCaptureService;
use App\Domain\Catalog\ComparableMappingService;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Testing\TestResponse;

/**
 * Phase 14 analytics fixtures on top of the order fixtures: one approved MAT-03 comparable group for the fixture
 * concrete hollow block (BrandCo, 100 mm, PC), stores whose published listing is mapped to it at an exact geodesic
 * distance, and simulated published runs in the TEST capture dataset built from those real variants.
 */
trait CreatesAnalyticsFixtures
{
    protected function comparableGroup(string $thickness = '100', string $code = 'CHB_BRANDCO_100'): string
    {
        $material = DB::table('materials')->where('code', 'CONCRETE_HOLLOW_BLOCK')->first();
        $admin = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);

        return app(ComparableMappingService::class)->createGroup(['material_id' => $material->id, 'code' => $code, 'display_name' => 'CHB '.$thickness.' mm BrandCo',
            'brand' => 'BrandCo', 'specification' => ['thickness_mm' => $thickness], 'canonical_unit_id' => $material->canonical_unit_id], (int) $admin->id)['group_id'];
    }

    /** @return array{0: VendorOrganization, 1: User, 2: string, 3: string} store, owner, listing id, variant id */
    protected function analyticsStore(string $name, int $priceCentavos, float $meters = 1000, float $bearing = 90, string $tax = 'NON_VAT'): array
    {
        [$store, $owner, $listing] = $this->pickupStore($name, [['price' => $priceCentavos, 'qty' => '50', 'tax' => $tax]], $meters);
        $this->placeStore($store->id, $meters, $bearing);
        $variant = $this->variantIds($listing)[0];
        app(ComparableMappingService::class)->assign($variant);

        return [$store, $owner, $listing, $variant];
    }

    /**
     * Publishes a TEST-dataset run for a date from real variants with simulated normalized prices.
     *
     * @param  array<string, string>  $prices  variant id => normalized PHP price
     */
    protected function publishRun(string $date, array $prices): string
    {
        $capture = app(MaterialPriceCaptureService::class);
        $observedAt = CarbonImmutable::parse($date.' 00:10', 'Asia/Manila')->setTimezone('UTC');
        $rows = [];
        foreach ($prices as $variantId => $price) {
            $source = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                ->join('listing_price_versions as pv', fn ($j) => $j->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
                ->join('vendor_addresses as va', 'va.vendor_organization_id', '=', 'l.vendor_organization_id')->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')
                ->join('listing_comparable_assignments as ca', fn ($j) => $j->on('ca.listing_variant_id', '=', 'v.id')->where('ca.mapping_state', 'APPROVED')->whereNull('ca.effective_until'))
                ->join('material_comparable_group_versions as gv', 'gv.id', '=', 'ca.material_comparable_group_version_id')
                ->where('v.id', $variantId)->first(['v.id', 'l.id as listing_id', 'l.vendor_organization_id', 'pv.id as price_version_id', 'pv.tax_category', 'gv.id as group_version_id', 'gv.material_comparable_group_id', 'av.id as address_version_id', 'av.version']);
            $rows[] = ['listing_variant_id' => (string) $source->id, 'vendor_listing_id' => (string) $source->listing_id, 'vendor_organization_id' => (string) $source->vendor_organization_id,
                'listing_price_version_id' => (string) $source->price_version_id, 'price_effective_at' => $observedAt->subDay()->toIso8601String(), 'ordinary_payable_centavos' => (int) round((float) $price * 100),
                'normalized_php_price' => bcadd($price, '0', 8), 'tax_category' => (string) $source->tax_category, 'comparable_group_version_id' => (string) $source->group_version_id,
                'comparable_group_id' => (string) $source->material_comparable_group_id, 'unit_conversion_version' => 'IDENTITY', 'stock_confirmed_at' => now()->toIso8601String(),
                'vendor_address_version_id' => (string) $source->address_version_id, 'address_version' => (int) $source->version, 'psgc_region_code' => null, 'psgc_province_code' => null, 'psgc_city_code' => null];
        }

        return DB::transaction(function () use ($capture, $date, $observedAt, $rows): string {
            $run = $capture->openRun(AnalyticsDataset::CAPTURE_ENVIRONMENT, AnalyticsDataset::CAPTURE_DATASET, $date, $observedAt);
            $capture->publish($run, $capture->stage($run, $rows, $observedAt, $date, AnalyticsDataset::CAPTURE_ENVIRONMENT, AnalyticsDataset::CAPTURE_DATASET));
            AnalyticsDataset::bump();

            return (string) $run->id;
        });
    }

    /** @param array<string, mixed> $extra */
    protected function buyerAnalytics(array $extra = [], ?string $groupId = null): TestResponse
    {
        return $this->postJson('/api/v1/buyers/materials-analytics'.($groupId === null ? '' : '/'.$groupId), $this->origin() + $extra);
    }
}
