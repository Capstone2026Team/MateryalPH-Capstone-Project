<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Finance\Money;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Procurement\ScopedOfferQuery;
use App\Domain\Vendors\VendorDeliveryEligibility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Owner decision 2026-10-12: a Work Package line a Vendor cannot supply is bought through a separate, linked
 * Item-Based order. This lists eligible Item-Based offers for the same canonical material and normalized unit
 * within the Project-Based radius of the package site (RadiusPolicy::PROJECT_BASED_KM, the same scope the cart
 * enforces for the purchase). The quantity to source is what the compared Vendor still cannot supply after the
 * separate purchases already tagged to the line, so a partly covered line asks only for the rest.
 *
 * Offers rank by: satisfies the stated specification and brand, covers the whole quantity, can serve the package's
 * fulfillment method, total price for the quantity, then distance. Stock shows only as a label and a Full/Partial
 * availability, never as a quantity. Unlisted lines have no comparable offers and are resolved by waiver.
 */
final class WorkPackageAlternatives
{
    public const PER_PAGE = 10;

    public function __construct(private readonly ProjectService $projects, private readonly ScopedOfferQuery $offers, private readonly GeographyScopeResolver $scopes,
        private readonly PublicVendorProjection $vendors, private readonly ListingPublicFacts $facts, private readonly ProjectEstimateService $estimates) {}

    /** @param array<string, string> $selections
     * @return array<string, mixed> */
    public function list(Request $request, string $packageId, string $lineId, ?string $excludeVendorId, int $page, ?string $candidateId = null, array $selections = [], ?string $method = null, ?string $arrangementId = null, bool $replace = false, bool $projectOnly = false): array
    {
        $w = $this->projects->package($request, $packageId);
        $line = DB::table('work_package_lines')->where('id', $lineId)->where('work_package_version_id', $w->current_version_id)->first();
        if ($line === null) {
            throw new AuthenticationException('WORK_PACKAGE_LINE_NOT_FOUND', 'This material is not part of the current Work Package version.', 404);
        }
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $point = $content['site']['point'];
        $radius = RadiusPolicy::PROJECT_BASED_KM;
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $unit = DB::table('units')->where('id', $line->unit_id)->first(['code', 'precision']);
        $required = StockAvailability::quantity($line->quantity);
        $needed = $required;
        $purchases = PackageFulfillment::purchases($w, $buyer);
        $lockedVendors = [];
        if ($candidateId !== null) {
            // The gap is the compared Vendor's, less what the Buyer already bought separately for it.
            $snapshot = $this->estimates->coverageSnapshot($request, $packageId, $candidateId, $selections, $method);
            $excludeVendorId = (string) $snapshot['vendor_id'];
            $purchases = ProjectProcurementDraft::purchases($w, $buyer, $excludeVendorId, (string) $snapshot['fulfillment_method']);
            $needed = PackageFulfillment::remaining($snapshot['lines'], $purchases, $lineId) ?? $required;
        }
        if ($projectOnly) {
            $eligible = DB::table('store_profiles')->where('bulk_capability', true)->pluck('vendor_organization_id')->all();
            $purchases = array_map(static fn (array $rows): array => array_values(array_filter($rows, static fn (array $row): bool => $row['stage'] !== 'IN_CART' && in_array($row['vendor_id'], $eligible, true))), $purchases);
            $needed = isset($snapshot) ? (PackageFulfillment::remaining($snapshot['lines'], $purchases, $lineId) ?? $required) : $required;
        }
        if ($arrangementId !== null) {
            $arrangement = app(ProjectArrangements::class)->show($request, $packageId, $arrangementId);
            $lockedVendors = array_column(array_filter($arrangement['vendors'], static fn (array $v): bool => $v['requested'] || $v['conversation_id'] !== null), 'vendor_id');
            foreach ($arrangement['coverage']['lines'] as $coverage) {
                if ($coverage['line_id'] === $lineId) {
                    $needed = $replace ? $required : $coverage['remaining_quantity'];
                    break;
                }
            }
            $purchases = [];
            foreach ($arrangement['vendors'] as $vendor) {
                foreach ($vendor['items'] as $item) {
                    $purchases[$item['line_id']][] = $item;
                }
            }
        }
        $view = ['line' => ['id' => $line->id, 'name' => $line->name, 'quantity' => $required, 'unit_code' => $unit->code, 'material_kind' => $line->material_kind],
            'needed_quantity' => $needed, 'location_id' => $point['location_id'] ?? null, 'radius_km' => $radius, 'page' => $page, 'excluded' => ['out_of_stock' => 0, 'cannot_serve_fulfillment' => 0]];
        if ($line->material_id === null) {
            return $view + ['status' => 'UNLISTED', 'items' => [], 'has_more' => false, 'total' => 0];
        }
        if (bccomp($needed, '0', 4) <= 0) {
            return $view + ['status' => 'COVERED', 'items' => [], 'has_more' => false, 'total' => 0];
        }
        // The package's locked site point, not the live saved location, which may have been archived or edited since activation.
        $scope = $this->scopes->forBuyer($buyer, ['latitude' => (float) $point['latitude'], 'longitude' => (float) $point['longitude'], 'origin_source' => 'MAP_PIN', 'radius_km' => $radius]);
        [$distanceSql, $distanceBindings] = ScopedOfferQuery::distanceSql($scope);
        $rows = $this->offers->within($scope)->join('products as pd', 'pd.id', '=', 'l.product_id')
            ->where('pd.material_id', $line->material_id)->where('v.unit_id', $line->unit_id)->where('p.vacation_mode', false)
            ->when($arrangementId !== null || $projectOnly, fn ($q) => $q->where('p.bulk_capability', true))
            ->when($excludeVendorId !== null, fn ($q) => $q->where('o.id', '<>', $excludeVendorId))
            ->when($lockedVendors !== [], fn ($q) => $q->whereNotIn('o.id', $lockedVendors))
            ->select(['v.id as variant_id', 'v.label as variant_label', 'v.attributes', 'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'o.id as organization_id',
                'pv.id as price_version_id', 'pv.amount_centavos', 'pd.brand', 'i.reorder_level', 'p.fulfillment_method'])
            ->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available')->selectRaw(ReadyMixedConcrete::listingSql('l').' AS ready_mixed_concrete')
            ->selectRaw($distanceSql.' AS distance', $distanceBindings)->get();
        $required_specs = json_decode($line->specifications ?? '{}', true);
        $category = (string) DB::table('materials')->where('id', $line->material_id)->value('material_category_id');
        $definitions = SpecificationMatch::definitions([$category])[$category] ?? [];
        // Concrete keeps its own delivery-only rule even when the primary order is collected.
        $concrete = DB::table('materials')->where('id', $line->material_id)->where('code', ReadyMixedConcrete::MATERIAL_CODE)->exists();
        $wanted = $concrete ? ['DELIVERY'] : ($method !== null ? [$method] : ($content['fulfillment_method'] === 'BOTH' ? ['DELIVERY', 'PICKUP'] : [(string) $content['fulfillment_method']]));
        $deliverable = in_array('DELIVERY', $wanted, true) ? array_flip(app(VendorDeliveryEligibility::class)->availableOrganizations()->pluck('vendor_organization_id')->all()) : [];
        $added = array_column($purchases[$lineId] ?? [], 'variant_id');
        $excluded = $view['excluded'];
        $items = [];
        foreach ($rows as $row) {
            $available = StockAvailability::quantity($row->available);
            if (bccomp($available, '0', 4) <= 0) {
                $excluded['out_of_stock']++;

                continue;
            }
            $methods = array_values(array_filter([
                in_array($row->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true) && isset($deliverable[$row->organization_id]) ? 'DELIVERY' : null,
                in_array($row->fulfillment_method, ['SELF_PICKUP', 'BOTH'], true) && ! $row->ready_mixed_concrete ? 'PICKUP' : null,
            ]));
            if (array_intersect($wanted, $methods) === []) {
                $excluded['cannot_serve_fulfillment']++;

                continue;
            }
            $attributes = SpecificationMatch::offered($row->technical_attributes, $row->attributes);
            $items[] = ['listing_id' => (string) $row->listing_id, 'variant_id' => (string) $row->variant_id, 'price_version_id' => (string) $row->price_version_id,
                'display_name' => (string) $row->display_name, 'variant_label' => $row->variant_label, 'brand' => $row->brand, 'vendor_id' => (string) $row->organization_id,
                'specifications' => SpecificationMatch::labelled($attributes, $definitions),
                'unit_price_centavos' => (int) $row->amount_centavos, 'estimated_total_centavos' => Money::lineAmount($needed, (int) $row->amount_centavos),
                'unit_code' => $unit->code, 'unit_precision' => (int) $unit->precision,
                'distance_meters' => (int) round((float) $row->distance), 'fulfillment_methods' => $methods,
                'availability' => bccomp($available, $needed, 4) >= 0 ? 'FULL' : 'PARTIAL',
                'stock_label' => StockAvailability::label($available, $row->reorder_level === null ? null : StockAvailability::quantity($row->reorder_level)),
                'exact_match' => ($line->preferred_brand === null || $line->preferred_brand === $row->brand) && SpecificationMatch::satisfies(is_array($required_specs) ? $required_specs : [], $attributes),
                'already_added' => in_array((string) $row->variant_id, $added, true)];
        }
        usort($items, static fn (array $a, array $b): int => ($b['exact_match'] <=> $a['exact_match']) ?: (($b['availability'] === 'FULL') <=> ($a['availability'] === 'FULL'))
            ?: ($a['estimated_total_centavos'] <=> $b['estimated_total_centavos']) ?: ($a['distance_meters'] <=> $b['distance_meters']) ?: strcmp($a['variant_id'], $b['variant_id']));
        $slice = array_slice($items, ($page - 1) * self::PER_PAGE, self::PER_PAGE);
        $stores = $this->vendors->summaries(array_values(array_unique(array_column($slice, 'vendor_id'))));
        $images = $this->facts->images(array_values(array_unique(array_column($slice, 'listing_id'))));
        foreach ($slice as &$item) {
            $item['store_name'] = $stores[$item['vendor_id']]['public_store_name'] ?? null;
            $item['image'] = $images[$item['listing_id']][0] ?? null;
        }
        unset($item);

        return ['excluded' => $excluded] + $view + ['status' => $items === [] ? 'NO_SUITABLE_ALTERNATIVE' : 'CATALOG', 'items' => $slice, 'has_more' => count($items) > $page * self::PER_PAGE, 'total' => count($items)];
    }
}
