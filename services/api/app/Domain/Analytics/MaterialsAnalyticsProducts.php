<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Analytics\Serializers\BuyerMaterialsAnalyticsSerializer;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use Illuminate\Support\Facades\DB;

/**
 * Buyer Materials Analytics by canonical product (owner decision 2026-10-25): one row per material in scope with its
 * comparable variant count, distinct current Vendor count and min / median / max current price per canonical unit,
 * then a product view whose variants each carry their own range, Vendor count and best stock label.
 *
 * Every number comes from the same MAT-02 current offers as the variant list. Each Vendor counts once per variant at
 * its lowest normalized price. Product-level ranges only use variants priced in the material's canonical unit and are
 * never presented as like-for-like; the average and trend stay per variant (MAT-03 no blending), so the product view
 * features the most-offered variant by name.
 */
final class MaterialsAnalyticsProducts
{
    public function __construct(private readonly MaterialsAnalyticsService $service, private readonly MaterialsAnalyticsAssembler $assembler) {}

    /** @return array<string, mixed> */
    public function list(AnalyticsRequest $request, ?string $cursor, int $perPage): array
    {
        $groups = $this->service->groupsWithMaterial($this->service->candidates($request));
        $offers = $this->service->vendorOffers($request, array_map(static fn (object $group): string => (string) $group->id, $groups));
        $products = $this->products($groups, $offers['offers']);
        $categories = [];
        foreach ($products as $product) {
            $id = $product['row']['category']['id'];
            $categories[$id] ??= ['category' => $product['row']['category'], 'product_count' => 0, 'variant_count' => 0];
            $categories[$id]['product_count']++;
            $categories[$id]['variant_count'] += $product['row']['variant_count'];
        }
        $categoryId = $request->filters['category_id'] ?? null;
        $term = mb_strtolower(trim((string) ($request->filters['q'] ?? '')));
        $matching = array_values(array_filter($products, static fn (array $product): bool => ($categoryId === null || $product['row']['category']['id'] === $categoryId)
            && ($term === '' || array_filter($product['search'], static fn (string $text): bool => str_contains($text, $term)) !== [])));
        $offset = MaterialsAnalyticsService::decodeCursor($cursor);
        $perPage = min(max($perPage, 1), MaterialsAnalyticsService::MAX_PER_PAGE);

        return $this->envelope($request, $groups, $offers['as_of']) + [
            'categories' => array_values($categories),
            'items' => array_map(static fn (array $product): array => $product['row'], array_slice($matching, $offset, $perPage)),
            'next_cursor' => $offset + $perPage < count($matching) ? base64_encode((string) ($offset + $perPage)) : null,
            'not_yet_comparable_listings' => $this->service->current($request, [])['not_yet_comparable'],
        ];
    }

    /** @return array<string, mixed> */
    public function detail(AnalyticsRequest $request, string $materialId): array
    {
        $material = DB::table('materials as m')->join('material_categories as mc', 'mc.id', '=', 'm.material_category_id')->join('units as u', 'u.id', '=', 'm.canonical_unit_id')
            ->where('m.id', $materialId)->where('m.active', true)
            ->first(['m.id', 'm.name', 'm.description', 'm.regulated', 'mc.id as category_id', 'mc.code as category_code', 'mc.name as category_name', 'u.code as unit_code', 'u.name as unit_name']);
        if ($material === null) {
            throw new AuthenticationException('MATERIAL_NOT_FOUND', 'This material is unavailable.', 404);
        }
        $groups = array_values(array_filter($this->service->groupsWithMaterial($this->service->candidates($request)), static fn (object $group): bool => (string) $group->material_id === (string) $material->id));
        $ids = array_map(static fn (object $group): string => (string) $group->id, $groups);
        $offers = $this->service->vendorOffers($request, $ids);
        $product = $this->products($groups, $offers['offers'])[0]['row'] ?? [
            'material' => ['id' => (string) $material->id, 'name' => (string) $material->name],
            'category' => ['id' => (string) $material->category_id, 'code' => (string) $material->category_code, 'name' => (string) $material->category_name],
            'regulated' => (bool) $material->regulated, 'unit' => ['code' => (string) $material->unit_code, 'name' => (string) $material->unit_name],
            'variant_count' => 0, 'vendor_count' => 0, 'price' => self::range([]),
        ];
        $byGroup = [];
        foreach ($offers['offers'] as $offer) {
            $byGroup[$offer['group_id']][] = $offer;
        }
        $images = $this->service->images($request, $ids);
        $serializer = new BuyerMaterialsAnalyticsSerializer;
        $variants = [];
        foreach ($groups as $group) {
            $entries = $byGroup[(string) $group->id] ?? [];
            $labels = array_column($entries, 'availability');
            $variants[] = $serializer->describe($group) + [
                'vendor_count' => count($entries),
                'listing_count' => array_sum(array_column($entries, 'listings')),
                'price' => self::range(array_column($entries, 'normalized')),
                'availability' => match (true) {
                    in_array(StockAvailability::IN_STOCK, $labels, true) => StockAvailability::IN_STOCK,
                    in_array(StockAvailability::LIMITED_STOCK, $labels, true) => StockAvailability::LIMITED_STOCK,
                    default => 'NO_CURRENT_OFFERS',
                },
                'image' => $images[(string) $group->id] ?? null,
            ];
        }
        // The most-offered variant (then most listings, then name) carries the product's average and trend.
        $ranked = $variants;
        usort($ranked, static fn (array $a, array $b): int => [$b['vendor_count'], $b['listing_count'], $a['display_name']] <=> [$a['vendor_count'], $a['listing_count'], $b['display_name']]);
        $featured = null;
        if ($ranked !== []) {
            $detail = $this->assembler->detail($request, $ranked[0]['group_id']);
            $featured = ['group' => $detail['group'], 'series' => $detail['series']];
        }

        return $this->envelope($request, $groups, $offers['as_of']) + [
            'product' => $product + ['description' => $material->description],
            'featured' => $featured,
            'variants' => $variants,
        ];
    }

    /**
     * @param  list<object>  $groups  in display order
     * @param  list<array{group_id: string, vendor_id: string, listings: int, normalized: string, availability: string}>  $offers
     * @return list<array{row: array<string, mixed>, search: list<string>}>
     */
    private function products(array $groups, array $offers): array
    {
        $byGroup = [];
        foreach ($offers as $offer) {
            $byGroup[$offer['group_id']][] = $offer;
        }
        $products = [];
        foreach ($groups as $group) {
            $id = (string) $group->material_id;
            $products[$id] ??= ['group' => $group, 'variants' => 0, 'vendors' => [], 'prices' => [], 'search' => [mb_strtolower((string) $group->material_name)]];
            $products[$id]['variants']++;
            $products[$id]['search'][] = mb_strtolower((string) $group->display_name);
            if ($group->brand !== null) {
                $products[$id]['search'][] = mb_strtolower((string) $group->brand);
            }
            $sameUnit = (string) $group->group_unit_id === (string) $group->material_unit_id;
            foreach ($byGroup[(string) $group->id] ?? [] as $offer) {
                $products[$id]['vendors'][$offer['vendor_id']] = true;
                if ($sameUnit) {
                    $products[$id]['prices'][] = $offer['normalized'];
                }
            }
        }

        return array_values(array_map(static fn (array $product): array => [
            'row' => [
                'material' => ['id' => (string) $product['group']->material_id, 'name' => (string) $product['group']->material_name],
                'category' => ['id' => (string) $product['group']->category_id, 'code' => (string) $product['group']->category_code, 'name' => (string) $product['group']->category_name],
                'regulated' => (bool) $product['group']->regulated,
                'unit' => ['code' => (string) $product['group']->material_unit_code, 'name' => (string) $product['group']->material_unit_name],
                'variant_count' => $product['variants'],
                'vendor_count' => count($product['vendors']),
                'price' => self::range($product['prices']),
            ],
            'search' => $product['search'],
        ], $products));
    }

    /**
     * @param  list<object>  $groups
     * @return array<string, mixed>
     */
    private function envelope(AnalyticsRequest $request, array $groups, string $asOf): array
    {
        $ids = array_map(static fn (object $group): string => (string) $group->id, $groups);
        $snapshot = $this->service->points($request, $ids, $request->window->end === null ? [] : [$request->window->end])['snapshot'];

        return (new BuyerMaterialsAnalyticsSerializer)->envelope($request, $snapshot, ['as_of' => $asOf, 'groups' => [], 'not_yet_comparable' => 0]);
    }

    /**
     * Min / median / max of per-Vendor normalized prices, half-up at 2 dp; an even count takes the mean of the middle two.
     *
     * @param  list<string>  $prices
     * @return array{min_php: ?string, median_php: ?string, max_php: ?string}
     */
    public static function range(array $prices): array
    {
        if ($prices === []) {
            return ['min_php' => null, 'median_php' => null, 'max_php' => null];
        }
        usort($prices, static fn (string $a, string $b): int => bccomp($a, $b, 8));
        $count = count($prices);
        $middle = intdiv($count, 2);
        $median = $count % 2 === 1 ? $prices[$middle] : bcdiv(bcadd($prices[$middle - 1], $prices[$middle], 8), '2', 8);

        return ['min_php' => MaterialsAnalyticsService::display($prices[0]), 'median_php' => MaterialsAnalyticsService::display($median), 'max_php' => MaterialsAnalyticsService::display($prices[$count - 1])];
    }
}
