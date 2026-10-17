<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Serializers;

use App\Domain\Procurement\ListingPublicFacts;

/**
 * Vendor Owner / Store Manager audience (MAT-05), built only from competitor aggregates that already exclude the
 * requesting organization. The only competitor outputs are the comparable group, the rounded average, a sample count
 * when at least three competitors exist, the trend, dates and quality flags. Below three competitors every value and
 * count is null with "Insufficient Competitor Data" — the sub-threshold count (including zero) is never serialized.
 * No competitor offer rows, ids, names, links, coordinates, per-offer timestamps or min/max single-offer prices exist
 * here. The Vendor's own price is a separate DTO and never contributes to the competitor average.
 */
final class VendorMaterialsAnalyticsSerializer extends MaterialsAnalyticsSerializer
{
    /**
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    public function row(array $row): array
    {
        $current = $row['current']['vendors'];

        return $this->group($row['group']) + [
            'start_point' => $this->point($row['start']),
            'end_point' => $this->point($row['end']),
            'trend' => $this->trend($row['trend'], $row['start']['date'], $row['end']['date']),
            'current_competitors' => ['competitor_count' => $current >= 3 ? $current : null, 'status' => $current >= 3 ? 'AVAILABLE' : 'SUPPRESSED', 'label' => $current >= 3 ? null : self::LABELS['SUPPRESSED']],
            'own_offer' => $row['own'] === null ? null : [
                'listing_id' => $row['own']['listing_id'], 'variant_id' => $row['own']['variant_id'], 'display_name' => $row['own']['display_name'], 'variant_label' => $row['own']['variant_label'],
                'price_centavos' => $row['own']['price_centavos'], 'normalized_php' => self::money($row['own']['normalized_php']),
                'tax_label' => ListingPublicFacts::vatLabel($row['own']['tax_category']), 'price_as_of' => $row['own']['price_as_of'],
            ],
        ];
    }

    public function detail(array $row, array $series, array $siblings): array
    {
        return ['group' => $this->row($row) + ['description' => $row['group']->material_description],
            'variants' => array_map(fn (object $sibling): array => $this->group($sibling), $siblings),
            'series' => array_map(fn (array $entry): array => $this->point($entry) + ['participants_changed' => $entry['status'] === 'OK' ? $entry['participants_changed'] : null], $series)];
    }

    protected function audience(): string
    {
        return 'VENDOR';
    }

    /**
     * @param  array<string, mixed>  $entry
     * @return array<string, mixed>
     */
    private function point(array $entry): array
    {
        $ok = $entry['status'] === 'OK';

        return ['date' => $entry['date'], 'status' => $entry['status'], 'label' => self::LABELS[$entry['status']] ?? null,
            'average_php' => $ok ? self::money($entry['point']['average']) : null, 'competitor_count' => $ok ? $entry['point']['vendors'] : null];
    }
}
