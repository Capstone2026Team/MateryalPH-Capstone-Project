<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\ListingTaxPolicy;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Product Details for one Tier 2 listing. The listing is shown only while it has at least one MAT-02
 * eligible variant; an old card that became unavailable returns LISTING_UNAVAILABLE instead of stale data.
 * A listing outside the selected radius is described but marked not purchasable. Variants that are not
 * currently offered carry no price or stock label. Exact quantities, private files and legal identity never
 * appear; a PS/ICC badge describes MateryalPH evidence review, not a government certification.
 */
final class ListingDetailService
{
    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly ScopedOfferQuery $offers,
        private readonly MarketplaceSearchService $search,
        private readonly ListingPublicFacts $facts,
        private readonly PublicVendorProjection $vendors,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function show(Request $request, string $listingId, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $scope = $this->scopes->forBuyer($buyerId, $input);
        if (! Str::isUuid($listingId)) {
            throw $this->unavailable();
        }
        [$distanceSql, $distanceBindings] = ScopedOfferQuery::distanceSql($scope);
        $eligible = ComparableMappingService::joinComparable($this->offers->anywhere())->where('l.id', $listingId)
            ->select(['v.id as variant_id', 'pv.id as price_version_id', 'pv.version as price_version', 'pv.amount_centavos', 'pv.tax_category', 'pv.effective_at', 'i.reorder_level', 'i.confirmed_at',
                'ca.material_comparable_group_version_id as group_version_id', 'cu.code as canonical_unit_code'])
            ->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available')
            ->selectRaw(ComparableMappingService::NORMALIZED_PRICE_SQL.' AS normalized_price')
            ->selectRaw($distanceSql.' AS distance_meters', $distanceBindings)
            ->get()->keyBy('variant_id');
        if ($eligible->isEmpty()) {
            throw $this->unavailable();
        }
        $listing = DB::table('vendor_listings as l')->join('products as pr', 'pr.id', '=', 'l.product_id')->leftJoin('material_categories as mc', 'mc.id', '=', 'l.material_category_id')
            ->leftJoin('regulated_material_rules as r', 'r.id', '=', 'l.regulated_material_rule_id')
            ->where('l.id', $listingId)->first(['l.id', 'l.vendor_organization_id', 'l.display_name', 'l.description', 'l.technical_attributes', 'l.material_category_id', 'mc.name as category_name',
                'l.regulated', 'l.compliance_status', 'l.publication_version', 'l.published_at', 'pr.brand', 'pr.model', 'pr.manufacturer', 'pr.country_of_manufacture', 'r.required_marking']);
        $organizationId = (string) $listing->vendor_organization_id;
        $distance = (int) round((float) $eligible->first()->distance_meters);
        $withinRadius = (float) $eligible->first()->distance_meters <= $scope->membershipMeters();
        $minima = $withinRadius ? $this->search->comparableMinima($scope) : [];
        $tiers = $this->facts->volumeTiers($eligible->keys()->map(static fn (mixed $id): string => (string) $id)->all());
        $favorites = $this->facts->favoriteOrganizations($buyerId);
        $vendor = $this->vendors->summaries([$organizationId])[$organizationId] ?? null;
        if ($vendor === null) {
            throw $this->unavailable();
        }
        $rating = $this->facts->productRatings([$listingId])[$listingId] ?? ['average' => null, 'count' => 0];
        $variants = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->where('v.vendor_listing_id', $listingId)->where('v.active', true)
            ->orderBy('v.sort_order')->orderBy('v.id')->get(['v.id', 'v.sku', 'v.label', 'v.attributes', 'v.pack_quantity', 'u.code as unit_code', 'u.name as unit_name', 'u.precision as unit_precision', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm']);
        $deliveryMaximum = $vendor['delivery_maximum_km'];

        return [
            'listing_id' => $listingId,
            'publication_version' => (int) $listing->publication_version,
            'display_name' => (string) $listing->display_name,
            'description' => $listing->description,
            'brand' => $listing->brand, 'model' => $listing->model, 'manufacturer' => $listing->manufacturer, 'country_of_manufacture' => $listing->country_of_manufacture,
            'category' => $listing->material_category_id === null ? null : ['id' => (string) $listing->material_category_id, 'name' => $listing->category_name],
            'technical_attributes' => ComparableMappingService::decode($listing->technical_attributes),
            'images' => $this->facts->images([$listingId])[$listingId] ?? [],
            'compliance' => [
                'regulated' => (bool) $listing->regulated,
                'status' => $listing->regulated ? (string) $listing->compliance_status : 'NOT_REQUIRED',
                'badge' => $listing->regulated && $listing->compliance_status === 'VERIFIED' ? 'PS_ICC_VERIFIED' : null,
                'required_marking' => $listing->required_marking,
                'notice' => 'A PS/ICC badge means MateryalPH matched or reviewed the submitted evidence. It is not a new government certification.',
            ],
            'product_rating' => ['average' => $rating['average'], 'count' => $rating['count'], 'label' => $rating['average'] === null ? 'New' : $rating['average'].' of 5'],
            'units_sold' => $this->facts->unitsSold([$listingId])[$listingId] ?? '0.0000',
            'is_favorite' => isset($favorites[$organizationId]),
            'purchasable' => $withinRadius && ! $vendor['vacation_mode'],
            'not_purchasable_reason' => ! $withinRadius ? 'OUTSIDE_SELECTED_RADIUS' : ($vendor['vacation_mode'] ? 'STORE_PAUSED' : null),
            'distance_meters' => $distance,
            'vendor' => [
                'id' => $vendor['id'], 'name' => $vendor['public_store_name'], 'logo_url' => $vendor['logo_url'], 'score_label' => $vendor['score_label'],
                'address' => $vendor['address'], 'open_status' => $vendor['open_status'], 'vacation_mode' => $vendor['vacation_mode'], 'supplier_type' => $vendor['supplier_type'],
            ],
            'fulfillment' => [
                'pickup_available' => in_array($vendor['fulfillment_method'], ['SELF_PICKUP', 'BOTH'], true),
                'delivery' => $deliveryMaximum === null ? 'NOT_OFFERED' : ($distance <= $deliveryMaximum * 1000 ? 'WITHIN_STATED_AREA' : 'OUTSIDE_STATED_AREA'),
                'delivery_maximum_km' => $deliveryMaximum,
                'basis' => 'STRAIGHT_LINE_ADVISORY',
                'notice' => 'Delivery vehicles, trips and the fee are confirmed by the Vendor before you pay. Estimates are advisory.',
            ],
            'variants' => $variants->map(function (object $variant) use ($eligible, $minima, $tiers): array {
                $offer = $eligible->get($variant->id);
                $base = ['variant_id' => (string) $variant->id, 'sku' => (string) $variant->sku, 'label' => $variant->label, 'attributes' => ComparableMappingService::decode($variant->attributes),
                    'unit_code' => (string) $variant->unit_code, 'unit_name' => (string) $variant->unit_name, 'pack_quantity' => StockAvailability::quantity($variant->pack_quantity),
                    'quantity_step' => CartService::quantityStep((int) $variant->unit_precision)];
                if ($offer === null) {
                    return $base + ['available' => false, 'availability_note' => 'Not currently offered', 'stock_label' => null, 'stock_confirmed_at' => null, 'price' => null, 'volume_tiers' => [], 'best_price' => false, 'comparable' => null];
                }
                $normalized = $offer->normalized_price === null ? null : bcadd((string) $offer->normalized_price, '0', 8);
                $group = $offer->group_version_id === null ? null : ($minima[(string) $offer->group_version_id] ?? null);
                $label = StockAvailability::label(StockAvailability::quantity($offer->available), $offer->reorder_level === null ? null : StockAvailability::quantity($offer->reorder_level));

                return $base + [
                    'available' => true, 'availability_note' => null, 'stock_label' => $label,
                    'stock_confirmed_at' => Carbon::parse((string) $offer->confirmed_at)->toIso8601String(),
                    'price' => ['price_version_id' => (string) $offer->price_version_id, 'unit_price_centavos' => (int) $offer->amount_centavos, 'currency' => 'PHP',
                        'tax_category' => (string) $offer->tax_category, 'vat_label' => ListingPublicFacts::vatLabel((string) $offer->tax_category),
                        'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos((int) $offer->amount_centavos, (string) $offer->tax_category),
                        'effective_at' => Carbon::parse((string) $offer->effective_at)->toIso8601String()],
                    'volume_tiers' => $tiers[(string) $variant->id] ?? [],
                    'best_price' => $normalized !== null && $group !== null && $group['vendors'] >= MarketplaceSearchService::BEST_PRICE_MIN_VENDORS && bccomp($normalized, $group['lowest'], 8) === 0,
                    'comparable' => $normalized === null || $group === null
                        ? ['status' => 'NOT_YET_COMPARABLE', 'normalized_unit_price' => null, 'canonical_unit_code' => null]
                        : ['status' => 'COMPARABLE', 'normalized_unit_price' => $normalized, 'canonical_unit_code' => (string) $offer->canonical_unit_code],
                ];
            })->values()->all(),
            'scope' => $scope->summary(),
            'current_as_of' => now()->toIso8601String(),
            'eligibility_version' => EligibleOfferQuery::VERSION,
        ];
    }

    private function unavailable(): AuthenticationException
    {
        return new AuthenticationException('LISTING_UNAVAILABLE', 'This product is no longer available. Refresh the results to see current offers.', 404);
    }
}
