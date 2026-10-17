<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Serializers;

/**
 * Buyer audience (MAT-05): daily averages including one-Vendor limited data, exact recorded Vendor counts, trends that
 * need two Vendors at both endpoints, and current offering counts. Current offers are a separate Buyer-only resource.
 * Participant identities are never serialized; exact stock and negotiated prices never exist in these inputs.
 */
final class BuyerMaterialsAnalyticsSerializer extends MaterialsAnalyticsSerializer
{
    /**
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    public function row(array $row): array
    {
        return $this->group($row['group']) + [
            'start_point' => $this->point($row['start']),
            'end_point' => $this->point($row['end']),
            'trend' => $this->trend($row['trend'], $row['start']['date'], $row['end']['date']),
            'current' => ['vendor_count' => $row['current']['vendors'], 'listing_count' => $row['current']['listings'], 'status' => $row['current']['vendors'] > 0 ? 'AVAILABLE' : 'NO_CURRENT_OFFERS'],
        ];
    }

    public function detail(array $row, array $series, array $siblings): array
    {
        return ['group' => $this->row($row) + ['description' => $row['group']->material_description],
            'variants' => array_map(fn (object $sibling): array => $this->group($sibling), $siblings),
            'series' => array_map(fn (array $entry): array => $this->point($entry) + ['participants_changed' => $entry['participants_changed']], $series)];
    }

    protected function audience(): string
    {
        return 'BUYER';
    }

    /**
     * @param  array<string, mixed>  $entry
     * @return array<string, mixed>
     */
    private function point(array $entry): array
    {
        $point = in_array($entry['status'], ['OK', 'LIMITED_DATA'], true) ? $entry['point'] : null;

        return ['date' => $entry['date'], 'status' => $entry['status'], 'label' => self::LABELS[$entry['status']] ?? null,
            'average_php' => self::money($point['average'] ?? null), 'vendor_count' => $point['vendors'] ?? ($entry['published'] ? 0 : null)];
    }
}
