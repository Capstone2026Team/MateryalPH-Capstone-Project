<?php

declare(strict_types=1);

namespace App\Domain\Scores;

/**
 * System Workflow computation rules, verbatim. All arithmetic is decimal (bcmath) and rounding is half-up.
 *
 *   VCS = (Service Quality + Delivery/Processing Speed + MQS) / 3      90 days, ≥5 eligible Vendor ratings and MQS eligible
 *   MQS = average eligible Product Quality rating                       90 days, ≥5 eligible product ratings
 *   OHS = clamp(5.00 − NFR − LSR − RR − ODR − LVD, 1.00, 5.00)          30 days (LVD 90 days), ≥10 eligible orders, weekly
 *   VPS = VCS × 0.50 + OHS × 0.50                                        only when VCS and OHS are both eligible
 *   FRR = on-time fulfilled ÷ eligible fulfilled × 100;  CRR = inquiries answered within 12 h ÷ eligible inquiries × 100
 *
 * Penalty-band rates are percentages rounded half-up to two decimals and compared with the published bands, so
 * 2.00% carries no NFR penalty and 2.01% carries the Low penalty. The neutral new-Vendor ranking value is never stored.
 */
final class ScoreRules
{
    public const ALGORITHM_VERSION = 'scores.v1';

    public const RATING_WINDOW_DAYS = 90;

    public const OHS_WINDOW_DAYS = 30;

    public const LVD_WINDOW_DAYS = 90;

    public const MIN_VENDOR_RATINGS = 5;

    public const MIN_PRODUCT_RATINGS = 5;

    public const MIN_OHS_ORDERS = 10;

    public const RESPONSE_HOURS = 12;

    public const CRR_WINDOW_DAYS = 30;

    public const FRR_WINDOW_DAYS = 90;

    /** The weekday (ISO, Monday = 1) on which OHS is recalculated (approved by the project owner on 2026-10-04). */
    public const OHS_RECALCULATION_WEEKDAY = 1;

    public const NEW_VENDOR_LABEL = 'New Vendor — Building Track Record';

    private const SCALE = 8;

    /** @var array<string, list<array{0: string, 1: string}>> upper bound (inclusive, %) => penalty */
    private const BANDS = [
        'NFR' => [['2.00', '0.00'], ['5.00', '0.25'], ['10.00', '0.75']],
        'LSR' => [['3.00', '0.00'], ['8.00', '0.25'], ['15.00', '0.75']],
        'RR' => [['2.00', '0.00'], ['5.00', '0.25'], ['10.00', '0.50']],
        'ODR' => [['1.00', '0.00'], ['3.00', '0.25'], ['6.00', '0.75']],
    ];

    private const HIGH = ['NFR' => '1.50', 'LSR' => '1.25', 'RR' => '1.00', 'ODR' => '1.25'];

    /** numerator ÷ denominator × 100, rounded half-up to two decimals; a zero denominator is a 0.00% rate. */
    public static function percent(int $numerator, int $denominator): string
    {
        if ($denominator <= 0) {
            return '0.00';
        }

        return self::round(bcmul(bcdiv((string) $numerator, (string) $denominator, self::SCALE + 2), '100', self::SCALE), 2);
    }

    public static function penalty(string $metric, string $ratePercent): string
    {
        foreach (self::BANDS[$metric] as [$upper, $penalty]) {
            if (bccomp($ratePercent, $upper, 2) <= 0) {
                return $penalty;
            }
        }

        return self::HIGH[$metric];
    }

    /** 0.10 for one violation, 0.30 for two to three, 0.60 for four to five, 1.00 for six or more. */
    public static function lvdPenalty(int $violations): string
    {
        return match (true) {
            $violations <= 0 => '0.00',
            $violations === 1 => '0.10',
            $violations <= 3 => '0.30',
            $violations <= 5 => '0.60',
            default => '1.00',
        };
    }

    /** @param array{NFR: string, LSR: string, RR: string, ODR: string, LVD: string} $penalties */
    public static function ohs(array $penalties): string
    {
        $value = '5.00';
        foreach ($penalties as $penalty) {
            $value = bcsub($value, $penalty, 2);
        }

        return self::clamp($value);
    }

    /** Average of a list of 1–5 integer ratings at full decimal precision; null for an empty list. */
    public static function average(int $sum, int $count): ?string
    {
        return $count <= 0 ? null : bcdiv((string) $sum, (string) $count, self::SCALE);
    }

    public static function vcs(string $service, string $speed, string $mqs): string
    {
        return self::clamp(bcdiv(bcadd(bcadd($service, $speed, self::SCALE), $mqs, self::SCALE), '3', self::SCALE), self::SCALE);
    }

    public static function vps(string $vcs, string $ohs): string
    {
        return self::clamp(bcadd(bcmul($vcs, '0.50', self::SCALE), bcmul($ohs, '0.50', self::SCALE), self::SCALE), self::SCALE);
    }

    public static function clamp(string $value, int $scale = 2): string
    {
        if (bccomp($value, '1', $scale) < 0) {
            return bcadd('1', '0', $scale);
        }
        if (bccomp($value, '5', $scale) > 0) {
            return bcadd('5', '0', $scale);
        }

        return bcadd($value, '0', $scale);
    }

    public static function round(string $value, int $scale = 2): string
    {
        $offset = '0.'.str_repeat('0', $scale).'5';

        return bcadd($value, str_starts_with($value, '-') ? '-'.$offset : $offset, $scale);
    }

    /**
     * Most Ordered: within one (canonical category, registered province) group of Vendors with completed orders, a
     * Vendor qualifies when it has at least the minimum completed orders and fewer than ceil(10% × group size) Vendors
     * have strictly more completed orders (so ties at the cutoff are all included).
     *
     * @param  array<string, int>  $counts  organization id => completed-order count in the window
     * @return list<string>
     */
    public static function mostOrdered(array $counts, int $minimum = 20, int $topPercent = 10): array
    {
        $eligible = array_filter($counts, static fn (int $count): bool => $count > 0);
        $cutoff = (int) ceil(count($eligible) * $topPercent / 100);
        $winners = [];
        foreach ($eligible as $organizationId => $count) {
            $higher = count(array_filter($eligible, static fn (int $other): bool => $other > $count));
            if ($count >= $minimum && $higher < $cutoff) {
                $winners[] = (string) $organizationId;
            }
        }
        sort($winners);

        return $winners;
    }
}
