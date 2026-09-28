<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

/**
 * The only public stock vocabulary. Exact quantities stay private to authorized Vendor users;
 * Buyers only ever receive one of these three labels (approved by the project owner on 2026-09-28):
 * Out of Stock when nothing is available to sell, Limited Stock when the available quantity is at
 * or below the Vendor's reorder level, and In Stock otherwise (including when no reorder level is set).
 */
final class StockAvailability
{
    public const IN_STOCK = 'IN_STOCK';

    public const LIMITED_STOCK = 'LIMITED_STOCK';

    public const OUT_OF_STOCK = 'OUT_OF_STOCK';

    public const LABELS = [self::IN_STOCK, self::LIMITED_STOCK, self::OUT_OF_STOCK];

    public const RULE_VERSION = 'stock-label.reorder-level.v1';

    /** available_to_sell = quantity_on_hand − hard_reserved_quantity. Soft holds never reduce it. */
    public static function availableToSell(string $quantityOnHand, string $hardReserved): string
    {
        return bcsub($quantityOnHand, $hardReserved, 4);
    }

    public static function label(?string $availableToSell, ?string $reorderLevel): string
    {
        if ($availableToSell === null || bccomp($availableToSell, '0', 4) <= 0) {
            return self::OUT_OF_STOCK;
        }
        if ($reorderLevel !== null && bccomp($availableToSell, $reorderLevel, 4) <= 0) {
            return self::LIMITED_STOCK;
        }

        return self::IN_STOCK;
    }

    /** Normalizes a stored NUMERIC(18,4) value to a canonical decimal string. */
    public static function quantity(mixed $value): string
    {
        return bcadd((string) $value, '0', 4);
    }
}
