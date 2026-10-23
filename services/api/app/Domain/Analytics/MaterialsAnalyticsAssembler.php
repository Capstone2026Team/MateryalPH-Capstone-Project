<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Analytics\Serializers\AdminMaterialsAnalyticsSerializer;
use App\Domain\Analytics\Serializers\BuyerMaterialsAnalyticsSerializer;
use App\Domain\Analytics\Serializers\MaterialsAnalyticsSerializer;
use App\Domain\Analytics\Serializers\VendorMaterialsAnalyticsSerializer;

/**
 * Builds internal list/detail results from MaterialsAnalyticsService and hands them to the serializer of the request's
 * audience. The audience comes from the authenticated session, so a Vendor token can only ever reach the Vendor
 * serializer (aggregate-only, own price separate) and never the Buyer offer serializer.
 */
final class MaterialsAnalyticsAssembler
{
    public function __construct(private readonly MaterialsAnalyticsService $service) {}

    /** @return array<string, mixed> */
    public function list(AnalyticsRequest $request, ?string $cursor, int $perPage): array
    {
        $serializer = $this->serializer($request);
        $page = $this->service->groups($request, $cursor, min(max($perPage, 1), MaterialsAnalyticsService::MAX_PER_PAGE));
        $ids = array_map(static fn (object $group): string => (string) $group->id, $page['groups']);
        $endpoints = array_values(array_filter([$request->window->start, $request->window->end]));
        $points = $this->service->points($request, $ids, $endpoints);
        $current = $this->service->current($request, $ids);
        $own = $request->audience === 'VENDOR' ? $this->service->ownOffers((string) $request->ownOrganizationId, $ids) : [];
        $images = $this->service->images($request, $ids, $own);
        $rows = [];
        foreach ($page['groups'] as $group) {
            $row = $this->row($request, $group, $points, $current, $own, $images);
            // A Vendor sees groups it sells or where competitor aggregates are displayable; nothing else hints at a sub-threshold count.
            if ($request->audience === 'VENDOR' && $row['own'] === null && $row['start']['status'] !== 'OK' && $row['end']['status'] !== 'OK') {
                continue;
            }
            $rows[] = $serializer->row($row);
        }

        return $serializer->envelope($request, $points['snapshot'], $current) + ['items' => $rows, 'next_cursor' => $page['next_cursor']];
    }

    /** @return array<string, mixed> */
    public function detail(AnalyticsRequest $request, string $groupId): array
    {
        $serializer = $this->serializer($request);
        $group = $this->service->group($groupId);
        $dates = $request->window->dates();
        $points = $this->service->points($request, [(string) $group->id], $dates);
        $current = $this->service->current($request, [(string) $group->id]);
        $own = $request->audience === 'VENDOR' ? $this->service->ownOffers((string) $request->ownOrganizationId, [(string) $group->id]) : [];
        $series = [];
        $previousIds = null;
        foreach ($dates as $date) {
            $published = isset($points['published'][$date]);
            $point = $points['points'][$date][(string) $group->id] ?? null;
            $status = MaterialsAnalyticsService::pointStatus($request->audience, $published, $point);
            $displayable = in_array($status, ['OK', 'LIMITED_DATA'], true);
            $ids = $displayable && $point !== null ? $point['vendor_ids'] : null;
            $series[] = ['date' => $date, 'published' => $published, 'status' => $status, 'point' => $displayable ? $point : null,
                'participants_changed' => $ids !== null && $previousIds !== null ? $ids !== $previousIds : null];
            if ($ids !== null) {
                $previousIds = $ids;
            }
        }
        $row = $this->row($request, $group, $points, $current, $own, $this->service->images($request, [(string) $group->id], $own));

        return $serializer->envelope($request, $points['snapshot'], $current) + $serializer->detail($row, $series, $this->service->siblings($group));
    }

    /**
     * @param  array{published: array<string, true>, points: array<string, array<string, array{vendors: int, average: string, vendor_ids: list<string>}>>, snapshot: ?array<string, mixed>}  $points
     * @param  array{as_of: string, groups: array<string, array{vendors: int, listings: int}>, not_yet_comparable: int}  $current
     * @param  array<string, array<string, mixed>>  $own
     * @param  array<string, array{url: string, alt_text: ?string}>  $images
     * @return array<string, mixed>
     */
    private function row(AnalyticsRequest $request, object $group, array $points, array $current, array $own, array $images): array
    {
        $endpoint = function (?string $date) use ($request, $group, $points): array {
            $published = $date !== null && isset($points['published'][$date]);
            $point = $date === null ? null : ($points['points'][$date][(string) $group->id] ?? null);

            return ['date' => $date, 'published' => $published, 'status' => MaterialsAnalyticsService::pointStatus($request->audience, $published, $point), 'point' => $point];
        };
        $start = $endpoint($request->window->start);
        $end = $endpoint($request->window->end);

        return [
            'group' => $group, 'start' => $start, 'end' => $end,
            'trend' => $request->window->start === null ? ['change_percent' => null, 'direction' => null, 'reason' => 'NO_PUBLISHED_HISTORY', 'composition_changed' => null]
                : MaterialsAnalyticsService::trend($start['point'], $end['point'], $request->minimumTrendVendors(), $start['published'], $end['published']),
            'current' => $current['groups'][(string) $group->id] ?? ['vendors' => 0, 'listings' => 0],
            'own' => $own[(string) $group->id] ?? null,
            'image' => $images[(string) $group->id] ?? null,
        ];
    }

    private function serializer(AnalyticsRequest $request): MaterialsAnalyticsSerializer
    {
        return match ($request->audience) {
            'BUYER' => new BuyerMaterialsAnalyticsSerializer,
            'VENDOR' => new VendorMaterialsAnalyticsSerializer,
            default => new AdminMaterialsAnalyticsSerializer,
        };
    }
}
