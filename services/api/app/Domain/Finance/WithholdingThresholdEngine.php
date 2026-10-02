<?php

declare(strict_types=1);

namespace App\Domain\Finance;

/**
 * FIN-04A evaluation for one canonical remittance group (Technical Design delta §4), as a pure function so the
 * exact centavo fixtures can be proven without a database. The caller holds the accumulator row lock.
 *
 *   g_after = g_before + G                          the whole group, never split
 *   UNDER_REVIEW, SUBJECT_STANDARD, SUBJECT_THRESHOLD_BREACHED, SUBJECT_PRIOR_YEAR are sticky inside the year;
 *       no document restores relief (an Admin-reviewed relief basis moves a status through its own event)
 *   RELIEF_ACTIVE and g_after > threshold (≥ 50,000,001)  → SUBJECT_THRESHOLD_BREACHED, the whole remittance taxed
 *   RELIEF_ACTIVE whose relief basis no longer applies    → SUBJECT_STANDARD
 *   W = 0 only in RELIEF_ACTIVE, otherwise money(G × rate)
 *
 * Exactly at the limit (g_after = 50,000,000) is not a breach.
 */
final class WithholdingThresholdEngine
{
    public const RELIEF_ACTIVE = 'RELIEF_ACTIVE';

    public const SUBJECT_STANDARD = 'SUBJECT_STANDARD';

    public const SUBJECT_THRESHOLD_BREACHED = 'SUBJECT_THRESHOLD_BREACHED';

    public const SUBJECT_PRIOR_YEAR = 'SUBJECT_PRIOR_YEAR';

    public const UNDER_REVIEW = 'UNDER_REVIEW';

    public const STATUSES = [self::RELIEF_ACTIVE, self::SUBJECT_STANDARD, self::SUBJECT_THRESHOLD_BREACHED, self::SUBJECT_PRIOR_YEAR, self::UNDER_REVIEW];

    public const DEFAULT_THRESHOLD_CENTAVOS = 50000000;

    /** 0.5% of gross remittance (RR No. 5-2025), in basis points. */
    public const STANDARD_RATE_BASIS_POINTS = 50;

    /**
     * @return array{status_after: string, reason_code: string, changed: bool, crossed: bool, g_before_centavos: int, g_after_centavos: int, withheld_centavos: int, rate_basis_points: int}
     */
    public static function decide(string $statusBefore, string $reasonBefore, int $gBeforeCentavos, int $groupCentavos, int $thresholdCentavos, bool $reliefStillValid, int $rateBasisPoints = self::STANDARD_RATE_BASIS_POINTS): array
    {
        if (! in_array($statusBefore, self::STATUSES, true)) {
            throw new \InvalidArgumentException('Unknown withholding status.');
        }
        if ($groupCentavos < 0 || $gBeforeCentavos < 0 || $thresholdCentavos <= 0) {
            throw new \InvalidArgumentException('Threshold inputs are nonnegative centavos.');
        }
        $gAfter = $gBeforeCentavos + $groupCentavos;
        $statusAfter = $statusBefore;
        $reason = $reasonBefore;
        $crossed = false;
        if ($statusBefore === self::RELIEF_ACTIVE) {
            if ($gAfter > $thresholdCentavos) {
                $statusAfter = self::SUBJECT_THRESHOLD_BREACHED;
                // A declared outside-platform total that already exceeded the limit is an external breach.
                $reason = $gBeforeCentavos > $thresholdCentavos ? 'EXTERNAL_BREACH_REPORTED' : 'THRESHOLD_CROSSED';
                $crossed = true;
            } elseif (! $reliefStillValid) {
                $statusAfter = self::SUBJECT_STANDARD;
                $reason = 'RELIEF_NOT_IN_PERIOD';
            }
        }
        $withheld = $statusAfter === self::RELIEF_ACTIVE ? 0 : Money::proportion($groupCentavos, $rateBasisPoints, 10000);

        return [
            'status_after' => $statusAfter, 'reason_code' => $reason, 'changed' => $statusAfter !== $statusBefore, 'crossed' => $crossed,
            'g_before_centavos' => $gBeforeCentavos, 'g_after_centavos' => $gAfter, 'withheld_centavos' => $withheld,
            'rate_basis_points' => $statusAfter === self::RELIEF_ACTIVE ? 0 : $rateBasisPoints,
        ];
    }

    /**
     * FIN-05 step 4 base. Components are mutually exclusive; a negative base is BASE_REVIEW_REQUIRED, never clamped.
     *
     * @return array{gross_basis_centavos: ?int, base_review_required: bool, expected_vendor_cash_centavos: ?int}
     */
    public static function base(int $collected, int $refunds, int $deliveryRemitted, int $vatRemitted, int $providerCharge): array
    {
        foreach ([$collected, $refunds, $deliveryRemitted, $vatRemitted, $providerCharge] as $component) {
            if ($component < 0) {
                return ['gross_basis_centavos' => null, 'base_review_required' => true, 'expected_vendor_cash_centavos' => null];
            }
        }
        $gross = $collected - $refunds - $deliveryRemitted - $vatRemitted - $providerCharge;

        return ['gross_basis_centavos' => $gross < 0 ? null : $gross, 'base_review_required' => $gross < 0, 'expected_vendor_cash_centavos' => null];
    }

    /** FIN-05 step 6: expected Vendor remittance cash C − R − P − W; the monthly commission is never deducted here. */
    public static function expectedVendorCash(int $collected, int $refunds, int $providerCharge, int $withheld): int
    {
        return $collected - $refunds - $providerCharge - $withheld;
    }
}
