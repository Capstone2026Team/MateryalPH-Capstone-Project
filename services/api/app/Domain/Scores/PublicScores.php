<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Buyer-safe score and badge facts. Only published values (sample gates met) are shown; below the gates the Vendor
 * displays "New Vendor — Building Track Record" and the internal neutral ranking value is never exposed. Badges are
 * the active automatic awards minus any Admin suppression, each with text and a stable code for its icon.
 */
final class PublicScores
{
    public const BADGE_TEXT = [
        'FAST_RESPONDER' => 'Answers at least 85% of inquiries within 12 hours (last 30 days, 10+ inquiries).',
        'ON_TIME' => 'Fulfills at least 95% of orders on or before the confirmed date (last 90 days, 10+ orders).',
        'MOST_ORDERED' => 'Top 10% by completed orders in this category and province (last 90 days, 20+ orders).',
        'HIGHLY_RATED' => 'Vendor Community Score of 4.50 or higher from 10+ verified ratings (last 90 days).',
        'HIGH_QUALITY_MATERIALS' => 'Material Quality Score of 4.60 or higher from 10+ verified product ratings (last 90 days).',
        'TRUSTED_SUPPLIER' => 'Verified for 90+ days with VCS and OHS of 4.50 or higher and 25+ completed orders.',
        'BEST_PRICE' => 'Lowest active comparable unit price for this product within your selected radius.',
    ];

    /** @return array<string, mixed> */
    public function forOrganization(string $organizationId): array
    {
        return $this->forOrganizations([$organizationId])[$organizationId];
    }

    /**
     * @param  list<string>  $organizationIds
     * @return array<string, array<string, mixed>>
     */
    public function forOrganizations(array $organizationIds): array
    {
        $organizationIds = array_values(array_unique($organizationIds));
        if ($organizationIds === []) {
            return [];
        }
        $snapshots = DB::query()->fromSub(DB::table('score_snapshots')->whereIn('vendor_organization_id', $organizationIds)
            ->selectRaw('DISTINCT ON (vendor_organization_id) vendor_organization_id, window_ends_on, vcs, mqs, ohs, vps, calculated_at')->orderBy('vendor_organization_id')->orderByDesc('window_ends_on'), 's')
            ->get()->keyBy('vendor_organization_id');
        $badges = $this->badges($organizationIds);
        $result = [];
        foreach ($organizationIds as $organizationId) {
            $snapshot = $snapshots[$organizationId] ?? null;
            $vps = $snapshot?->vps === null ? null : (string) $snapshot->vps;
            $result[$organizationId] = [
                'label' => $vps === null ? ScoreRules::NEW_VENDOR_LABEL : 'VPS '.self::round($vps).' of 5',
                'new_vendor' => $vps === null,
                'vps' => $vps === null ? null : self::round($vps),
                'vcs' => $snapshot?->vcs === null ? null : self::round((string) $snapshot->vcs),
                'mqs' => $snapshot?->mqs === null ? null : self::round((string) $snapshot->mqs),
                'ohs' => $snapshot?->ohs === null ? null : self::round((string) $snapshot->ohs),
                'as_of' => $snapshot?->window_ends_on === null ? null : (string) $snapshot->window_ends_on,
                'badges' => $badges[$organizationId] ?? [],
            ];
        }

        return $result;
    }

    /**
     * @param  list<string>  $organizationIds
     * @return array<string, list<array{code: string, name: string, scope_label: ?string, description: string, earned_at: string}>>
     */
    public function badges(array $organizationIds): array
    {
        if ($organizationIds === []) {
            return [];
        }
        $rows = DB::table('vendor_badge_history as h')->join('badge_definitions as d', 'd.id', '=', 'h.badge_definition_id')->whereIn('h.vendor_organization_id', $organizationIds)->whereNull('h.revoked_at')
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('badge_suppressions as s')->whereColumn('s.vendor_organization_id', 'h.vendor_organization_id')->whereColumn('s.badge_definition_id', 'h.badge_definition_id')->whereNull('s.lifted_at'))
            ->orderBy('d.code')->orderBy('h.scope_key')->get(['h.vendor_organization_id', 'd.code', 'd.name', 'h.scope_label', 'h.earned_at']);
        $badges = [];
        foreach ($rows as $row) {
            $badges[(string) $row->vendor_organization_id][] = ['code' => (string) $row->code, 'name' => (string) $row->name, 'scope_label' => $row->scope_label,
                'description' => self::BADGE_TEXT[$row->code] ?? '', 'earned_at' => (string) CarbonImmutable::parse((string) $row->earned_at)->toIso8601String()];
        }

        return $badges;
    }

    public static function round(string $value): string
    {
        return ScoreRules::round($value, 2);
    }
}
