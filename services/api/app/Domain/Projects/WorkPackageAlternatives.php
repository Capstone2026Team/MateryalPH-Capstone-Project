<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Procurement\ScopedOfferQuery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Owner decision 2026-10-12: a Work Package line a Vendor cannot supply is bought through a separate, linked
 * Item-Based order. This lists eligible Item-Based offers for the same canonical material and normalized unit
 * within the package's confirmed radius of its site, the same scope the cart enforces. Exact matches (brand when
 * set and every stated specification) come first; stock shows only as a label, never as a quantity. Unlisted
 * lines have no comparable offers and are resolved by waiver.
 */
final class WorkPackageAlternatives
{
    public const PER_PAGE = 10;

    public function __construct(private readonly ProjectService $projects, private readonly ScopedOfferQuery $offers, private readonly GeographyScopeResolver $scopes,
        private readonly PublicVendorProjection $vendors, private readonly ListingPublicFacts $facts) {}

    /** @return array<string, mixed> */
    public function list(Request $request, string $packageId, string $lineId, ?string $excludeVendorId, int $page): array
    {
        $w = $this->projects->package($request, $packageId);
        $line = DB::table('work_package_lines')->where('id', $lineId)->where('work_package_version_id', $w->current_version_id)->first();
        if ($line === null) {
            throw new AuthenticationException('WORK_PACKAGE_LINE_NOT_FOUND', 'This material is not part of the current Work Package version.', 404);
        }
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $point = $content['site']['point'];
        $radius = (int) $content['radius_km'];
        $unit = DB::table('units')->where('id', $line->unit_id)->first(['code', 'precision']);
        $view = ['line' => ['id' => $line->id, 'name' => $line->name, 'quantity' => StockAvailability::quantity($line->quantity), 'unit_code' => $unit->code,
            'material_kind' => $line->material_kind], 'location_id' => $point['location_id'] ?? null, 'radius_km' => $radius, 'page' => $page];
        if ($line->material_id === null) {
            return $view + ['status' => 'UNLISTED', 'items' => [], 'has_more' => false, 'total' => 0];
        }
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $scope = $this->scopes->forBuyer($buyer, ['location_id' => $point['location_id'], 'radius_km' => $radius]);
        [$distanceSql, $distanceBindings] = ScopedOfferQuery::distanceSql($scope);
        $rows = $this->offers->within($scope)->join('products as pd', 'pd.id', '=', 'l.product_id')
            ->where('pd.material_id', $line->material_id)->where('v.unit_id', $line->unit_id)->where('p.vacation_mode', false)
            ->when($excludeVendorId !== null, fn ($q) => $q->where('o.id', '<>', $excludeVendorId))
            ->select(['v.id as variant_id', 'v.label as variant_label', 'v.attributes', 'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'o.id as organization_id',
                'pv.id as price_version_id', 'pv.amount_centavos', 'pd.brand', 'i.reorder_level'])
            ->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available')->selectRaw($distanceSql.' AS distance', $distanceBindings)->get();
        $required = json_decode($line->specifications ?? '{}', true);
        $category = (string) DB::table('materials')->where('id', $line->material_id)->value('material_category_id');
        $definitions = SpecificationMatch::definitions([$category])[$category] ?? [];
        $items = [];
        foreach ($rows as $row) {
            $available = StockAvailability::quantity($row->available);
            if (bccomp($available, '0', 4) <= 0) {
                continue;
            }
            $attributes = SpecificationMatch::offered($row->technical_attributes, $row->attributes);
            $items[] = ['listing_id' => (string) $row->listing_id, 'variant_id' => (string) $row->variant_id, 'price_version_id' => (string) $row->price_version_id,
                'display_name' => (string) $row->display_name, 'variant_label' => $row->variant_label, 'brand' => $row->brand, 'vendor_id' => (string) $row->organization_id,
                'specifications' => SpecificationMatch::labelled($attributes, $definitions),
                'unit_price_centavos' => (int) $row->amount_centavos, 'unit_code' => $unit->code, 'unit_precision' => (int) $unit->precision,
                'distance_meters' => (int) round((float) $row->distance),
                'stock_label' => StockAvailability::label($available, $row->reorder_level === null ? null : StockAvailability::quantity($row->reorder_level)),
                'exact_match' => ($line->preferred_brand === null || $line->preferred_brand === $row->brand) && SpecificationMatch::satisfies(is_array($required) ? $required : [], $attributes)];
        }
        usort($items, static fn (array $a, array $b): int => ($b['exact_match'] <=> $a['exact_match']) ?: ($a['unit_price_centavos'] <=> $b['unit_price_centavos'])
            ?: ($a['distance_meters'] <=> $b['distance_meters']) ?: strcmp($a['variant_id'], $b['variant_id']));
        $slice = array_slice($items, ($page - 1) * self::PER_PAGE, self::PER_PAGE);
        $stores = $this->vendors->summaries(array_values(array_unique(array_column($slice, 'vendor_id'))));
        $images = $this->facts->images(array_values(array_unique(array_column($slice, 'listing_id'))));
        foreach ($slice as &$item) {
            $item['store_name'] = $stores[$item['vendor_id']]['public_store_name'] ?? null;
            $item['image'] = $images[$item['listing_id']][0] ?? null;
        }
        unset($item);

        return $view + ['status' => 'CATALOG', 'items' => $slice, 'has_more' => count($items) > $page * self::PER_PAGE, 'total' => count($items)];
    }
}
