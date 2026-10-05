<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Catalog\EligibleOfferQuery;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Daily score job (00:30 Asia/Manila). For the local day that just ended it projects new metric events, then writes
 * one immutable snapshot per Tier 2 Vendor whose window ends at that day's local midnight. VCS, MQS, CRR and FRR are
 * recalculated every day; OHS is recalculated on Mondays (or when no OHS calculation exists from the last seven
 * days) and otherwise carried forward unchanged; VPS is computed from the day's VCS and the current OHS. A replay of
 * the same day inserts nothing new, so the job is idempotent. Badges are re-evaluated after every snapshot.
 */
final class ScoreSnapshotService
{
    public function __construct(private readonly MetricEventProjector $projector, private readonly ScoreCalculator $calculator, private readonly BadgeService $badges) {}

    /** @return array{events: array<string, int>, snapshots: int, badges: array{awarded: int, removed: int}} */
    public function run(CarbonImmutable $now): array
    {
        $end = $now->setTimezone('Asia/Manila')->startOfDay();
        $events = $this->projector->project($now);
        $written = 0;
        foreach ($this->organizations($end) as $organizationId) {
            $written += $this->snapshot($organizationId, $end);
        }
        $badges = $this->badges->evaluate($end);
        if ($written > 0) {
            EligibleOfferQuery::invalidate();
        }

        return ['events' => $events, 'snapshots' => $written, 'badges' => $badges];
    }

    /** Writes the snapshot whose window ends at $end (local midnight); returns 1 when a new row was inserted. */
    public function snapshot(string $organizationId, CarbonImmutable $end): int
    {
        $windowEndsOn = $end->subDay()->toDateString();
        if (DB::table('score_snapshots')->where('vendor_organization_id', $organizationId)->where('window_ends_on', $windowEndsOn)->exists()) {
            return 0;
        }
        $utcEnd = $end->setTimezone('UTC');
        $ratings = $this->calculator->ratings($organizationId, $utcEnd);
        $badgeMetrics = $this->calculator->badgeMetrics($organizationId, $utcEnd);
        $previous = DB::table('score_snapshots')->where('vendor_organization_id', $organizationId)->where('window_ends_on', '<', $windowEndsOn)->orderByDesc('window_ends_on')->first();
        $recalculate = $end->dayOfWeekIso === ScoreRules::OHS_RECALCULATION_WEEKDAY || $previous === null || $previous->ohs_calculated_on === null
            || CarbonImmutable::parse((string) $previous->ohs_calculated_on, 'Asia/Manila')->lessThanOrEqualTo($end->subDays(7));
        if ($recalculate) {
            $operations = $this->calculator->operations($organizationId, $utcEnd);
            $ohs = $operations['ohs'];
            $ohsOn = $end->toDateString();
        } else {
            $components = json_decode((string) ($previous->components ?? '{}'), true) ?: [];
            $operations = $components['operations'] ?? null;
            $ohs = $previous->ohs === null ? null : (string) $previous->ohs;
            $ohsOn = (string) $previous->ohs_calculated_on;
        }
        $vps = $ratings['vcs'] !== null && $ohs !== null ? ScoreRules::round(ScoreRules::vps((string) $ratings['vcs_raw'], $ohs)) : null;

        return DB::table('score_snapshots')->insertOrIgnore([
            'id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'window_ends_on' => $windowEndsOn,
            'vcs' => $ratings['vcs'], 'mqs' => $ratings['mqs'], 'ohs' => $ohs, 'vps' => $vps, 'crr' => $badgeMetrics['crr'], 'frr' => $badgeMetrics['frr'], 'ohs_calculated_on' => $ohsOn,
            'sample_counts' => json_encode(['vendor_ratings' => $ratings['vendor_ratings'], 'product_ratings' => $ratings['product_ratings'], 'eligible_orders' => $operations['eligible_orders'] ?? 0,
                'inquiries' => $badgeMetrics['inquiries'], 'fulfilled_orders' => $badgeMetrics['fulfilled_orders'], 'completed_orders_90_days' => $badgeMetrics['completed_orders_90_days'],
                'completed_orders_total' => $badgeMetrics['completed_orders_total']], JSON_THROW_ON_ERROR),
            'components' => json_encode(['ratings' => array_diff_key($ratings, ['vcs_raw' => true]), 'operations' => $operations, 'badge_metrics' => $badgeMetrics, 'ohs_recalculated' => $recalculate], JSON_THROW_ON_ERROR),
            'algorithm_version' => ScoreRules::ALGORITHM_VERSION, 'environment' => 'TEST', 'calculated_at' => now(), 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    /** @return list<string> Tier 2 organizations that are active or have any score source. */
    private function organizations(CarbonImmutable $end): array
    {
        return DB::table('vendor_organizations as o')->where(fn ($q) => $q->where('o.store_activation_status', 'ACTIVE')
            ->orWhereExists(fn ($e) => $e->selectRaw('1')->from('metric_events as e')->whereColumn('e.vendor_organization_id', 'o.id')->where('e.occurred_at', '>=', $end->subDays(ScoreRules::RATING_WINDOW_DAYS))))
            ->orderBy('o.id')->pluck('o.id')->map(static fn (mixed $id): string => (string) $id)->all();
    }
}
