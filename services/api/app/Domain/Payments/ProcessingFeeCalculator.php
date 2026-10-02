<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Finance\Money;

/**
 * FIN-02 Buyer Payment Processing Fee from a versioned channel quote, in integer centavos, with no markup.
 *
 *   charge(T) = base(T) + vat(base),  base(T) = money(T × rate) + fixed,  vat = money(base × 12%) unless the rate includes VAT
 *
 * The provider charges on the fee-inclusive total T = P + F, so the disclosed fee is grossed up to the least F with
 * F = charge(P + F). The iteration F₀ = charge(P), Fₙ₊₁ = charge(P + Fₙ) is nondecreasing and bounded (rate < 1),
 * so it stops at that exact fixed point: the Buyer's fee covers exactly the quoted provider charge.
 */
final class ProcessingFeeCalculator
{
    public const VERSION = 'fin02.processing-fee.gross-up.v1';

    /**
     * @param  array{rate_ppm: int, fixed_centavos: int, fee_vat_basis_points: int, rate_includes_vat: bool}  $quote
     * @return array{base_centavos: int, vat_centavos: int, charge_centavos: int}
     */
    public static function charge(int $totalCentavos, array $quote): array
    {
        $base = Money::proportion($totalCentavos, $quote['rate_ppm'], 1000000) + $quote['fixed_centavos'];
        $vat = $quote['rate_includes_vat'] ? 0 : Money::proportion($base, $quote['fee_vat_basis_points'], 10000);

        return ['base_centavos' => $base, 'vat_centavos' => $vat, 'charge_centavos' => $base + $vat];
    }

    /**
     * @param  array{rate_ppm: int, fixed_centavos: int, fee_vat_basis_points: int, rate_includes_vat: bool}  $quote
     * @return array{fee_centavos: int, provider_charge_centavos: int, total_centavos: int, base_centavos: int, vat_centavos: int, iterations: int}
     */
    public static function grossUp(int $principalCentavos, array $quote): array
    {
        if ($principalCentavos <= 0) {
            throw new \InvalidArgumentException('A payment needs a positive principal.');
        }
        $fee = self::charge($principalCentavos, $quote)['charge_centavos'];
        for ($iteration = 1; $iteration <= 64; $iteration++) {
            $next = self::charge($principalCentavos + $fee, $quote);
            if ($next['charge_centavos'] === $fee) {
                return ['fee_centavos' => $fee, 'provider_charge_centavos' => $fee, 'total_centavos' => $principalCentavos + $fee,
                    'base_centavos' => $next['base_centavos'], 'vat_centavos' => $next['vat_centavos'], 'iterations' => $iteration];
            }
            $fee = $next['charge_centavos'];
        }
        throw new \LogicException('The processing-fee gross-up did not converge.');
    }
}
