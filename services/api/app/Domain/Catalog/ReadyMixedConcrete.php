<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Vendors\DeliveryRecommendationService;
use Illuminate\Support\Facades\DB;

/**
 * Ready-Mixed Concrete (approved by the project owner on 2026-10-16). A listing is ready-mixed concrete only when
 * its canonical material is READY_MIXED_CONCRETE; an Other-label product is never treated as one, and bagged cement
 * stays ordinary cargo. Ready-mixed concrete is sold per cubic meter, one variant per compressive-strength class,
 * and is delivered only by Site Delivery with a Concrete Mixer Truck / Transit Mixer, so every quantity is the
 * mixer volume the advisory service compares with Mixer Capacity (m³).
 */
final class ReadyMixedConcrete
{
    public const MATERIAL_CODE = 'READY_MIXED_CONCRETE';

    public const CATEGORY_CODE = 'READY_MIXED_CONCRETE';

    public const VOLUME_UNIT_CODE = 'CUM';

    public const STRENGTH_ATTRIBUTE = 'compressive_strength_psi';

    public const MIXER_TYPE = 'CONCRETE_MIXER';

    public const SITE_DELIVERY_MESSAGE = 'Ready-mixed concrete is delivered only by a Concrete Mixer Truck / Transit Mixer. Choose Site Delivery for this store.';

    /**
     * Delivery-load fields added to a variant's weight and dimensions. One sale unit is one cubic meter; a variant
     * in another unit has no known volume, so the advisory service asks for manual review instead of guessing.
     *
     * @return array{material_kind?: string, volume_m3_per_unit?: ?string}
     */
    public static function load(?string $materialCode, ?string $unitCode): array
    {
        if ($materialCode !== self::MATERIAL_CODE) {
            return [];
        }

        return ['material_kind' => DeliveryRecommendationService::READY_MIXED_CONCRETE, 'volume_m3_per_unit' => $unitCode === self::VOLUME_UNIT_CODE ? '1' : null];
    }

    public static function listing(string $listingId): bool
    {
        return DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->join('materials as m', 'm.id', '=', 'p.material_id')
            ->where('l.id', $listingId)->where('m.code', self::MATERIAL_CODE)->exists();
    }

    /** SQL predicate: the vendor_listings row under the alias sells ready-mixed concrete. */
    public static function listingSql(string $listingAlias = 'l'): string
    {
        return 'EXISTS (SELECT 1 FROM products rmc_product JOIN materials rmc_material ON rmc_material.id = rmc_product.material_id'
            ." WHERE rmc_product.id = {$listingAlias}.product_id AND rmc_material.code = '".self::MATERIAL_CODE."')";
    }
}
