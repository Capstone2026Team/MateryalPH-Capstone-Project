<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Catalog\ListingTaxPolicy;

/**
 * FIN-02 integer-centavo arithmetic. money(x) rounds a nonnegative PHP amount half-up to the centavo; every
 * computation here stays in integers or bcmath decimals and never touches binary floating point.
 */
final class Money
{
    /** money(quantity × unit price) for a quantity with up to four decimals. */
    public static function lineAmount(string $quantity, int $unitPriceCentavos): int
    {
        if ($unitPriceCentavos < 0 || bccomp($quantity, '0', 4) < 0) {
            throw new \InvalidArgumentException('Line amounts are computed from nonnegative quantities and prices.');
        }

        return (int) bcadd(bcmul($quantity, (string) $unitPriceCentavos, 4), '0.5', 0);
    }

    /** Included VAT of a discounted payable line: money(L × 12 / 112) for VAT_12, otherwise zero. */
    public static function includedVat(int $payableCentavos, string $taxCategory): int
    {
        return ListingTaxPolicy::includedVatCentavos($payableCentavos, $taxCategory);
    }

    /** money(amount × numerator / denominator), half-up, for a nonnegative ratio. */
    public static function proportion(int $amountCentavos, int $numerator, int $denominator): int
    {
        if ($amountCentavos < 0 || $numerator < 0 || $denominator <= 0) {
            throw new \InvalidArgumentException('Proportions use nonnegative amounts and a positive denominator.');
        }

        return (int) bcdiv(bcadd(bcmul((string) $amountCentavos, (string) (2 * $numerator)), (string) $denominator), (string) (2 * $denominator), 0);
    }

    /** FIN-03 commission: money(E × basis points / 10,000). */
    public static function commission(int $exclusiveCentavos, int $basisPoints = 200): int
    {
        return self::proportion($exclusiveCentavos, $basisPoints, 10000);
    }

    /**
     * Largest-remainder allocation of an integer total across nonnegative weights. Each share is the floored
     * proportional amount; the leftover centavos go one at a time to the largest fractional remainders, ties
     * broken by the stable key order supplied (FIN-02 uses ascending line id). The shares always sum exactly
     * to the total and no share exceeds its weight when the total does not exceed the weight sum.
     *
     * @param  array<string, int>  $weights  key => weight, in stable tie-break order
     * @return array<string, int>
     */
    public static function allocate(int $totalCentavos, array $weights): array
    {
        $sum = array_sum($weights);
        if ($totalCentavos < 0 || $sum < 0 || ($sum === 0 && $totalCentavos > 0)) {
            throw new \InvalidArgumentException('An allocation needs a nonnegative total and positive weights.');
        }
        $shares = [];
        $remainders = [];
        $allocated = 0;
        $position = 0;
        foreach ($weights as $key => $weight) {
            if ($weight < 0) {
                throw new \InvalidArgumentException('Allocation weights cannot be negative.');
            }
            $numerator = bcmul((string) $totalCentavos, (string) $weight);
            $share = $sum === 0 ? 0 : (int) bcdiv($numerator, (string) $sum, 0);
            $shares[$key] = $share;
            $allocated += $share;
            $remainders[] = ['key' => $key, 'remainder' => $sum === 0 ? '0' : bcmod($numerator, (string) $sum), 'position' => $position++];
        }
        usort($remainders, static fn (array $a, array $b): int => bccomp($b['remainder'], $a['remainder']) ?: $a['position'] <=> $b['position']);
        for ($leftover = $totalCentavos - $allocated, $index = 0; $leftover > 0; $leftover--, $index++) {
            $shares[$remainders[$index]['key']]++;
        }

        return $shares;
    }
}
