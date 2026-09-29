<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Inventory\StockAvailability;

/**
 * Item-Based Search Relevance Score, a normalized weighted sum (never a product of scores):
 *
 *   SRS = Σ component × weight / 100, each component normalized and clamped to 0–100.
 *
 * Components (System Workflow, Ranking Algorithm):
 *   Distance       max(0, (1 − distance / selected radius) × 100), geodesic straight line
 *   Price          lowest comparable unit price / candidate comparable unit price × 100, capped at 100;
 *                  a Not Yet Comparable listing uses the internal neutral 50 (approved 2026-09-29)
 *   Normalized VPS ((VPS − 1) / 4) × 100; a new Vendor uses the internal neutral 50
 *   Stock          In Stock 100, Limited Stock 50; Out of Stock is excluded before scoring
 *   Product Rating (average / 5) × 100; an unrated listing uses the internal neutral 60, labelled New
 *
 * Arithmetic is decimal (bcmath) so identical inputs always yield identical scores and ties.
 */
final class SearchRelevanceScore
{
    public const ALGORITHM_VERSION = 'srs.normalized-weighted-sum.v1';

    public const NEUTRAL_PRICE = '50';

    public const NEUTRAL_VPS = '50';

    public const NEUTRAL_RATING = '60';

    private const SCALE = 8;

    private const LABELS = ['distance' => 'Distance', 'price' => 'Price', 'vps' => 'Vendor Performance (VPS)', 'stock' => 'Stock', 'product_rating' => 'Product Rating'];

    public static function distance(int $distanceMeters, int $radiusMeters): string
    {
        if ($radiusMeters <= 0) {
            return self::fixed('0');
        }

        return self::clamp(bcmul(bcsub('1', bcdiv((string) max(0, $distanceMeters), (string) $radiusMeters, self::SCALE), self::SCALE), '100', self::SCALE));
    }

    /** Both prices are MAT-03 normalized PHP amounts per canonical unit; null means no comparable basis. */
    public static function price(?string $lowestComparable, ?string $candidateComparable): string
    {
        if ($lowestComparable === null || $candidateComparable === null || bccomp($candidateComparable, '0', self::SCALE) <= 0) {
            return self::fixed(self::NEUTRAL_PRICE);
        }

        return self::clamp(bcmul(bcdiv($lowestComparable, $candidateComparable, self::SCALE), '100', self::SCALE));
    }

    public static function vps(?string $vps): string
    {
        if ($vps === null) {
            return self::fixed(self::NEUTRAL_VPS);
        }

        return self::clamp(bcmul(bcdiv(bcsub($vps, '1', self::SCALE), '4', self::SCALE), '100', self::SCALE));
    }

    /** Null for Out of Stock: such offers are excluded, never scored as zero. */
    public static function stock(string $label): ?string
    {
        return match ($label) {
            StockAvailability::IN_STOCK => self::fixed('100'),
            StockAvailability::LIMITED_STOCK => self::fixed('50'),
            default => null,
        };
    }

    public static function productRating(?string $average): string
    {
        if ($average === null) {
            return self::fixed(self::NEUTRAL_RATING);
        }

        return self::clamp(bcmul(bcdiv($average, '5', self::SCALE), '100', self::SCALE));
    }

    /**
     * @param  array<string, string>  $components  normalized 0–100 values keyed by component
     * @return string SRS rounded half-up to four decimals
     */
    public static function combine(array $components, RankingWeights $weights): string
    {
        $sum = '0';
        foreach (RankingWeights::COMPONENTS as $component) {
            $sum = bcadd($sum, bcmul($components[$component], (string) $weights->weight($component), self::SCALE), self::SCALE);
        }

        return self::round(bcdiv($sum, '100', self::SCALE), 4);
    }

    /**
     * Text explanation of every component: weight, normalized score, weighted contribution and basis.
     *
     * @param  array<string, string>  $components
     * @param  array<string, string>  $basis
     * @return list<array{key: string, label: string, weight_percent: int, score: string, weighted: string, basis: string}>
     */
    public static function explain(array $components, RankingWeights $weights, array $basis): array
    {
        $rows = [];
        foreach (RankingWeights::COMPONENTS as $component) {
            $rows[] = [
                'key' => $component, 'label' => self::LABELS[$component], 'weight_percent' => $weights->weight($component),
                'score' => self::round($components[$component], 2),
                'weighted' => self::round(bcdiv(bcmul($components[$component], (string) $weights->weight($component), self::SCALE), '100', self::SCALE), 2),
                'basis' => $basis[$component] ?? '',
            ];
        }

        return $rows;
    }

    /** Integer form of a four-decimal score for deterministic, exact sort keys. */
    public static function sortInteger(string $score): int
    {
        return (int) bcmul($score, '10000', 0);
    }

    public static function round(string $value, int $scale): string
    {
        return bcadd($value, '0.'.str_repeat('0', $scale).'5', $scale);
    }

    private static function clamp(string $value): string
    {
        if (bccomp($value, '0', self::SCALE) < 0) {
            return self::fixed('0');
        }

        return self::fixed(bccomp($value, '100', self::SCALE) > 0 ? '100' : $value);
    }

    private static function fixed(string $value): string
    {
        return bcadd($value, '0', self::SCALE);
    }
}
