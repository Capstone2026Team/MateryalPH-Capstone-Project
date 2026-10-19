<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Geography\RadiusPolicy;
use App\Domain\Procurement\SearchRelevanceScore;

/** Score the actual allocation, never an average of whole-package Vendor FMS values. */
final class ArrangementMatchScore
{
    public const VERSION = 'fms.arrangement-material-share.v1';

    /** @param array<string, mixed> $coverage
     * @param list<array<string, mixed>> $vendors
     * @param array<string, int> $weights
     * @return array<string, mixed> */
    public static function calculate(array $coverage, array $vendors, ?int $total, int $budget, array $weights): array
    {
        $matched = '0';
        foreach ($coverage['lines'] as $line) {
            // Each requirement contributes one share; PC and CUM quantities are never added together.
            $supplied = bcadd((string) $line['vendor_quantity'], (string) $line['separate_quantity'], 8);
            $matched = bcadd($matched, bccomp((string) $line['required_quantity'], '0', 4) > 0
                ? bcdiv($supplied, (string) $line['required_quantity'], 8) : '0', 8);
        }
        $base = FulfillmentMatchScore::calculate($matched, (string) count($coverage['lines']), $total, $budget, 0, RadiusPolicy::PROJECT_BASED_KM, null, $weights);
        $amount = array_sum(array_column($vendors, 'materials_centavos'));
        $distance = $performance = '0';
        $knownDistance = true;
        $shares = [];
        foreach ($vendors as $vendor) {
            $cost = (int) $vendor['materials_centavos'];
            $knownDistance = $knownDistance && $vendor['distance_meters'] !== null;
            $distance = bcadd($distance, bcmul(SearchRelevanceScore::distance((int) ($vendor['distance_meters'] ?? 0), RadiusPolicy::PROJECT_BASED_KM * 1000), (string) $cost, 8), 8);
            $performance = bcadd($performance, bcmul(SearchRelevanceScore::vps($vendor['vps']), (string) $cost, 8), 8);
            $shares[] = ['vendor_id' => $vendor['vendor_id'], 'material_share_percent' => $amount > 0 ? bcdiv((string) ($cost * 100), (string) $amount, 4) : '0',
                'distance_meters' => $vendor['distance_meters'], 'new_vendor' => $vendor['vps'] === null];
        }
        $components = $base['components'];
        $components['distance'] = $amount > 0 && $knownDistance ? bcdiv($distance, (string) $amount, 8) : null;
        $components['vps'] = $amount > 0 ? bcdiv($performance, (string) $amount, 8) : null;

        return FulfillmentMatchScore::fromComponents($components, $weights, self::VERSION) + ['vendor_shares' => $shares,
            'basis' => 'Exact quantity coverage per requirement; combined materials and delivery against the Work Package budget. Supplier distance and normalized VPS are weighted by their share of material cost. New Vendors retain the existing neutral scoring treatment.'];
    }

    /** @param array<string, mixed> $a
     * @param array<string, mixed> $b */
    public static function compare(array $a, array $b): int
    {
        $completeA = $a['coverage']['lines_fulfilled'] === $a['coverage']['lines_total'];
        $completeB = $b['coverage']['lines_fulfilled'] === $b['coverage']['lines_total'];
        $readyA = $a['total_centavos'] !== null && $a['fms']['score'] !== null && $a['issues'] === [] && ! ($a['stale'] ?? false);
        $readyB = $b['total_centavos'] !== null && $b['fms']['score'] !== null && $b['issues'] === [] && ! ($b['stale'] ?? false);

        return ($completeB <=> $completeA) ?: ($readyB <=> $readyA)
            ?: (($b['fms']['score'] !== null) <=> ($a['fms']['score'] !== null))
            ?: bccomp($b['fms']['score'] ?? '0', $a['fms']['score'] ?? '0', 2)
            ?: ($a['vendor_count'] <=> $b['vendor_count'])
            ?: (($a['total_centavos'] === null) <=> ($b['total_centavos'] === null))
            ?: ($a['total_centavos'] <=> $b['total_centavos']) ?: strcmp($a['id'], $b['id']);
    }
}
