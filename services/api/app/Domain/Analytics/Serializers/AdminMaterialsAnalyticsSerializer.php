<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Serializers;

/**
 * Admin aggregate audience (analytics.view_aggregates): the same averages as Buyers within a PSGC scope, plus the
 * exact 8-dp means and current listing counts for market-quality review. Source listing identities are never part of
 * this payload; they require materials_analytics.inspect_sources through the separate audited sources resource. A row
 * image (a bare public photo URL and alt text, without its listing or store) is present only for that permission.
 */
final class AdminMaterialsAnalyticsSerializer extends MaterialsAnalyticsSerializer
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
            'image' => $row['image'],
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
        return 'ADMIN';
    }

    /**
     * @param  array<string, mixed>  $entry
     * @return array<string, mixed>
     */
    private function point(array $entry): array
    {
        $point = in_array($entry['status'], ['OK', 'LIMITED_DATA'], true) ? $entry['point'] : null;

        return ['date' => $entry['date'], 'status' => $entry['status'], 'label' => self::LABELS[$entry['status']] ?? null,
            'average_php' => self::money($point['average'] ?? null), 'average_php_exact' => $point['average'] ?? null, 'vendor_count' => $point['vendors'] ?? ($entry['published'] ? 0 : null)];
    }
}
