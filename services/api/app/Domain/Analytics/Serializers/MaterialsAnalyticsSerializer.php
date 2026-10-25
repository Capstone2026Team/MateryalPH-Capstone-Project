<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Serializers;

use App\Domain\Analytics\AnalyticsRequest;
use App\Domain\Catalog\ComparableMappingService;

/**
 * Shared, identity-free parts of every audience payload: the comparable group description, the scope/dataset/window
 * envelope and the plain-language status labels. Each audience subclass decides which numbers it may serialize.
 */
abstract class MaterialsAnalyticsSerializer
{
    public const EXPLANATION = 'Listed-price movement from public Tier 2 ordinary prices (VAT-inclusive where applicable), equal weight per Vendor. Not an official inflation index or a quotation.';

    public const LABELS = [
        'OK' => null,
        'LIMITED_DATA' => 'Limited Local Data — 1 Vendor',
        'NO_LOCAL_OBSERVATIONS' => 'Insufficient Local Data',
        'SUPPRESSED' => 'Insufficient Competitor Data',
        'MISSING_DAY' => 'No snapshot recorded for this date',
    ];

    public const TREND_LABELS = [
        'INSUFFICIENT_LOCAL_DATA' => 'Insufficient Local Data',
        'INSUFFICIENT_COMPETITOR_DATA' => 'Insufficient Competitor Data',
        'MISSING_ENDPOINT_SNAPSHOT' => 'Insufficient Local Data — no snapshot on an endpoint date',
        'ZERO_BASELINE' => 'Insufficient Local Data — no positive starting average',
        'NO_PUBLISHED_HISTORY' => 'No daily history has been published yet',
    ];

    /**
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    abstract public function row(array $row): array;

    /**
     * @param  array<string, mixed>  $row
     * @param  list<array<string, mixed>>  $series
     * @param  list<object>  $siblings
     * @return array<string, mixed>
     */
    abstract public function detail(array $row, array $series, array $siblings): array;

    abstract protected function audience(): string;

    /**
     * @param  array<string, mixed>|null  $snapshot
     * @param  array{as_of: string, groups: array<string, mixed>, not_yet_comparable: int}  $current
     * @return array<string, mixed>
     */
    public function envelope(AnalyticsRequest $request, ?array $snapshot, array $current): array
    {
        return [
            'audience' => $this->audience(),
            'scope' => $request->scope->summary(),
            'source_kind' => 'PUBLIC_LISTING',
            'dataset' => ['kind' => $request->dataset['kind'], 'label' => $request->dataset['label']],
            'window' => $request->window->summary(),
            'current_as_of' => $current['as_of'],
            'snapshot' => $snapshot,
            'update_schedule' => 'Updated daily at 00:10 Asia/Manila',
            'explanation' => self::EXPLANATION,
        ];
    }

    /**
     * The identity-free description of one comparable group (name, material, category, specification, unit).
     *
     * @return array<string, mixed>
     */
    public function describe(object $group): array
    {
        return $this->group($group);
    }

    /** @return array<string, mixed> */
    protected function group(object $group): array
    {
        $specification = json_decode((string) $group->controlled_specification, true) ?: [];

        return [
            'group_id' => (string) $group->id, 'display_name' => (string) $group->display_name,
            'material' => ['id' => (string) $group->material_id, 'name' => (string) $group->material_name],
            'category' => ['id' => (string) $group->category_id, 'code' => (string) $group->category_code, 'name' => (string) $group->category_name],
            'specification' => ['brand' => $group->brand, 'model' => $group->model, 'attributes' => array_map(static fn (string $key, mixed $value): array => ['key' => $key, 'value' => (string) $value], array_keys($specification), $specification)],
            'unit' => ['code' => (string) $group->unit_code, 'name' => (string) $group->unit_name],
        ];
    }

    /**
     * @param  array{change_percent: ?string, direction: ?string, reason: ?string, composition_changed: ?bool}  $trend
     * @return array<string, mixed>
     */
    protected function trend(array $trend, ?string $start, ?string $end): array
    {
        return $trend + ['start_date' => $start, 'end_date' => $end, 'label' => $trend['reason'] === null ? null : (self::TREND_LABELS[$trend['reason']] ?? null),
            'composition_note' => $trend['composition_changed'] === true ? 'The set of participating Vendors changed between the two dates, which may affect this result.' : null];
    }

    protected static function money(?string $average): ?string
    {
        return $average === null ? null : ComparableMappingService::roundHalfUp($average, 2);
    }
}
