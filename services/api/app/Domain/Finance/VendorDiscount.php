<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;

/** Percentage discounts apply to exactly one commercial component in orders and quotations. */
final class VendorDiscount
{
    public const PERCENT_PATTERN = '/^(?:100(?:\.0{1,2})?|0?\d{1,2}(?:\.\d{1,2})?)$/';

    /**
     * @param  array{scope: string, percent: string}  $input
     * @return array{scope: string, percent: string, basis_centavos: int, deduction_centavos: int}
     */
    public static function assess(array $input, int $materialsCentavos, int $deliveryCentavos, bool $delivery): array
    {
        $scope = $input['scope'];
        $percent = $input['percent'];
        if (! in_array($scope, ['MATERIALS', 'DELIVERY'], true) || ! preg_match(self::PERCENT_PATTERN, $percent) || bccomp($percent, '100', 2) > 0 || ($scope === 'DELIVERY' && ! $delivery)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose materials or Site Delivery and enter a percentage from 0 to 100.', 422);
        }
        $basis = $scope === 'MATERIALS' ? $materialsCentavos : $deliveryCentavos;
        $deduction = Money::proportion($basis, (int) bcmul($percent, '100', 0), 10000);
        if ($scope === 'MATERIALS' && $deduction >= $materialsCentavos) {
            throw new AuthenticationException('VALIDATION_FAILED', 'The materials discount must leave a positive materials subtotal.', 422);
        }

        return ['scope' => $scope, 'percent' => bcadd($percent, '0', 2), 'basis_centavos' => $basis, 'deduction_centavos' => $deduction];
    }

    /** Freeze the net fee only after the configured gross delivery fee has been verified.
     * @param  array<string, mixed>  $snapshot
     * @param  array{scope: string, percent: string, basis_centavos: int, deduction_centavos: int}  $discount
     * @return array<string, mixed>
     */
    public static function deliverySnapshot(array $snapshot, array $discount): array
    {
        $gross = (int) $snapshot['final_charge_centavos'];
        $verified = self::assess(['scope' => $discount['scope'], 'percent' => $discount['percent']], 0, $gross, true);
        if ($verified !== $discount) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the delivery discount against the confirmed fee.', 422);
        }

        return [...$snapshot, 'gross_charge_centavos' => $gross, 'discount' => $verified, 'final_charge_centavos' => $gross - $verified['deduction_centavos']];
    }
}
