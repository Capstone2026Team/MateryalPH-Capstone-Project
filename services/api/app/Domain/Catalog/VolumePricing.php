<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

/**
 * CAT-PRICE-01 volume tier pricing. A tier is a minimum line quantity, in the variant's
 * sale unit, with a lower VAT-inclusive unit price. The highest tier whose minimum the
 * line quantity reaches applies; below the first tier the ordinary price applies.
 * Tiers never combine across variants or order lines.
 */
final class VolumePricing
{
    public const MAX_TIERS = 5;

    public const QUANTITY_PATTERN = '/^\d{1,14}(\.\d{1,4})?$/';

    /**
     * @param  list<array<string, mixed>>  $tiers  Vendor input rows: minimum_quantity (decimal string), price_centavos (int).
     * @return array<string, list<string>> Errors keyed by `<index>.<field>` or `tiers`.
     */
    public static function errors(array $tiers, ?int $ordinaryCentavos): array
    {
        $errors = [];
        if (count($tiers) > self::MAX_TIERS) {
            $errors['tiers'][] = 'A variant can have up to '.self::MAX_TIERS.' volume tiers.';
        }
        $previousMinimum = null;
        $previousPrice = null;
        foreach ($tiers as $index => $tier) {
            $minimum = is_scalar($tier['minimum_quantity'] ?? null) ? (string) $tier['minimum_quantity'] : '';
            $price = $tier['price_centavos'] ?? null;
            $minimumValid = preg_match(self::QUANTITY_PATTERN, $minimum) === 1 && bccomp($minimum, '1', 4) > 0;
            if (! $minimumValid) {
                $errors[$index.'.minimum_quantity'][] = 'Enter a minimum quantity greater than 1, with up to four decimals.';
            } elseif ($previousMinimum !== null && bccomp($minimum, $previousMinimum, 4) <= 0) {
                $errors[$index.'.minimum_quantity'][] = 'Each tier needs a higher minimum quantity than the tier before it.';
            }
            if (! is_int($price) || $price <= 0) {
                $errors[$index.'.price_centavos'][] = 'Enter a tier price greater than zero.';
            } elseif ($ordinaryCentavos !== null && $price >= $ordinaryCentavos) {
                $errors[$index.'.price_centavos'][] = 'A tier price must be lower than the ordinary price.';
            } elseif ($previousPrice !== null && $price >= $previousPrice) {
                $errors[$index.'.price_centavos'][] = 'Each tier needs a lower price than the tier before it.';
            }
            if ($minimumValid) {
                $previousMinimum = $minimum;
            }
            if (is_int($price)) {
                $previousPrice = $price;
            }
        }

        return $errors;
    }

    /**
     * The tier that applies to one order-line quantity, or null when the ordinary price applies.
     *
     * @template T of array{minimum_quantity: string, amount_centavos: int}
     *
     * @param  list<T>  $tiers
     * @return T|null
     */
    public static function applicableTier(array $tiers, string $quantity): ?array
    {
        $applicable = null;
        foreach ($tiers as $tier) {
            if (bccomp($quantity, $tier['minimum_quantity'], 4) >= 0 && ($applicable === null || bccomp($tier['minimum_quantity'], $applicable['minimum_quantity'], 4) > 0)) {
                $applicable = $tier;
            }
        }

        return $applicable;
    }

    /** @param  list<array{minimum_quantity: string, amount_centavos: int}>  $tiers */
    public static function unitPriceCentavos(int $ordinaryCentavos, array $tiers, string $quantity): int
    {
        return self::applicableTier($tiers, $quantity)['amount_centavos'] ?? $ordinaryCentavos;
    }

    /** Canonical four-decimal quantity so equal minimums compare and store identically. */
    public static function normalizeQuantity(string $quantity): string
    {
        return bcadd($quantity, '0', 4);
    }
}
