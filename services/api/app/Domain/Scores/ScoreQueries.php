<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Reviews\ReviewAccess;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Store Performance (Vendor Owner and Store Manager) and Score & Badge Monitoring (Admin). Both read the same
 * immutable daily snapshots and source events; the portal never keeps a second formula or threshold set. Vendor
 * payloads contain no Buyer identity, order amounts or protected finance; Admin source events show references only.
 */
final class ScoreQueries
{
    public const PER_PAGE = 20;

    public const VIEW_STORE = 'scores.view_store';

    public const ADMIN_VIEW = 'scores.view';

    public function __construct(private readonly ReviewAccess $reviews, private readonly PublicScores $public) {}

    /** @return array<string, mixed> */
    public function vendorPerformance(Request $request): array
    {
        $scope = $this->reviews->vendorScope($request, self::VIEW_STORE);

        return $this->performance($scope['organization_id']) + ['badges' => $this->badgeStates($scope['organization_id'], false)];
    }

    /**
     * @param  array{q?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function adminList(Request $request, array $filters): array
    {
        $this->reviews->admin($request, self::ADMIN_VIEW);
        $query = DB::table('vendor_organizations as o')->where('o.store_activation_status', 'ACTIVE');
        $term = trim((string) ($filters['q'] ?? ''));
        if ($term !== '') {
            $query->where('o.store_name', 'ilike', '%'.str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $term).'%');
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $query)->count();
        $organizations = $query->orderBy('o.store_name')->orderBy('o.id')->forPage($page, self::PER_PAGE)->get(['o.id', 'o.store_name']);
        $ids = $organizations->pluck('id')->map(static fn (mixed $id): string => (string) $id)->all();
        $scores = $this->public->forOrganizations($ids);
        $samples = DB::query()->fromSub(DB::table('score_snapshots')->whereIn('vendor_organization_id', $ids)
            ->selectRaw('DISTINCT ON (vendor_organization_id) vendor_organization_id, sample_counts, crr, frr')->orderBy('vendor_organization_id')->orderByDesc('window_ends_on'), 's')->get()->keyBy('vendor_organization_id');
        $suppressed = DB::table('badge_suppressions')->whereIn('vendor_organization_id', $ids)->whereNull('lifted_at')->groupBy('vendor_organization_id')->selectRaw('vendor_organization_id, count(*) AS total')->pluck('total', 'vendor_organization_id');
        $excluded = DB::table('score_exclusions')->whereIn('vendor_organization_id', $ids)->whereNull('revoked_at')->groupBy('vendor_organization_id')->selectRaw('vendor_organization_id, count(*) AS total')->pluck('total', 'vendor_organization_id');

        return ['items' => $organizations->map(static fn (object $organization): array => [
            'vendor_id' => (string) $organization->id, 'store_name' => (string) $organization->store_name, 'scores' => $scores[(string) $organization->id],
            'crr' => isset($samples[$organization->id]) && $samples[$organization->id]->crr !== null ? (string) $samples[$organization->id]->crr : null,
            'frr' => isset($samples[$organization->id]) && $samples[$organization->id]->frr !== null ? (string) $samples[$organization->id]->frr : null,
            'sample_counts' => isset($samples[$organization->id]) ? (json_decode((string) $samples[$organization->id]->sample_counts, true) ?: []) : (object) [],
            'active_suppressions' => (int) ($suppressed[$organization->id] ?? 0), 'active_exclusions' => (int) ($excluded[$organization->id] ?? 0),
        ])->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total]];
    }

    /**
     * @param  array{metric?: string, page?: int}  $filters
     * @return array<string, mixed>
     */
    public function adminDetail(Request $request, string $vendorId, array $filters): array
    {
        $scope = $this->reviews->admin($request, self::ADMIN_VIEW);
        $organization = DB::table('vendor_organizations')->where('id', ReviewAccess::uuid($vendorId))->first(['id', 'store_name']);
        if ($organization === null) {
            throw new AuthenticationException('VENDOR_NOT_FOUND', 'This Vendor is unavailable.', 404);
        }
        $events = DB::table('metric_events as e')->leftJoin('orders as o', 'o.id', '=', 'e.order_id')->where('e.vendor_organization_id', $organization->id);
        if (isset($filters['metric'])) {
            $events->where('e.metric', $filters['metric']);
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $events)->count();
        $exclusions = DB::table('score_exclusions as x')->join('orders as o', 'o.id', '=', 'x.order_id')->where('x.vendor_organization_id', $organization->id)->orderByDesc('x.created_at')->get(['x.*', 'o.reference']);
        $excludedOrders = $exclusions->whereNull('revoked_at')->pluck('order_id')->map(static fn (mixed $id): string => (string) $id)->all();

        return $this->performance((string) $organization->id) + [
            'vendor_id' => (string) $organization->id, 'store_name' => (string) $organization->store_name,
            'badges' => $this->badgeStates((string) $organization->id, true),
            'badge_history' => DB::table('vendor_badge_history as h')->join('badge_definitions as d', 'd.id', '=', 'h.badge_definition_id')->where('h.vendor_organization_id', $organization->id)
                ->orderByDesc('h.earned_at')->limit(100)->get(['h.id', 'd.code', 'd.name', 'h.scope_label', 'h.earned_at', 'h.revoked_at', 'h.revocation_reason', 'h.evidence'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'code' => $row->code, 'name' => $row->name, 'scope_label' => $row->scope_label, 'earned_at' => self::iso($row->earned_at),
                    'revoked_at' => self::iso($row->revoked_at), 'revocation_reason' => $row->revocation_reason, 'evidence' => json_decode((string) $row->evidence, true)])->all(),
            'suppressions' => DB::table('badge_suppressions as s')->join('badge_definitions as d', 'd.id', '=', 's.badge_definition_id')->where('s.vendor_organization_id', $organization->id)->orderByDesc('s.created_at')
                ->get(['s.id', 'd.code', 'd.name', 's.reason_code', 's.case_reference', 's.note', 's.created_role', 's.created_at', 's.lifted_at', 's.lift_reason'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'badge_code' => $row->code, 'badge_name' => $row->name, 'reason_code' => $row->reason_code, 'case_reference' => $row->case_reference,
                    'note' => $row->note, 'created_role' => $row->created_role, 'created_at' => self::iso($row->created_at), 'lifted_at' => self::iso($row->lifted_at), 'lift_reason' => $row->lift_reason])->all(),
            'exclusions' => $exclusions->map(static fn (object $row): array => ['id' => (string) $row->id, 'order_id' => (string) $row->order_id, 'order_reference' => (string) $row->reference, 'reason_code' => $row->reason_code,
                'note' => $row->note, 'created_role' => $row->created_role, 'created_at' => self::iso($row->created_at), 'revoked_at' => self::iso($row->revoked_at), 'revoke_reason' => $row->revoke_reason])->values()->all(),
            'source_events' => ['items' => $events->orderByDesc('e.occurred_at')->orderByDesc('e.id')->forPage($page, self::PER_PAGE)->get(['e.id', 'e.metric', 'e.value', 'e.occurred_at', 'e.order_id', 'e.source_kind', 'e.details', 'o.reference'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'metric' => $row->metric, 'value' => (string) $row->value, 'occurred_at' => self::iso($row->occurred_at), 'source_kind' => $row->source_kind,
                    'order_id' => $row->order_id === null ? null : (string) $row->order_id, 'order_reference' => $row->reference, 'excluded' => $row->order_id !== null && in_array((string) $row->order_id, $excludedOrders, true),
                    'details' => json_decode((string) $row->details, true)])->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total]],
            'can_investigate' => in_array(ScoreInvestigationService::INVESTIGATE, $scope['permissions'], true),
        ];
    }

    /** @return array<string, mixed> */
    private function performance(string $organizationId): array
    {
        $latest = DB::table('score_snapshots')->where('vendor_organization_id', $organizationId)->orderByDesc('window_ends_on')->first();
        $components = $latest === null ? [] : (json_decode((string) $latest->components, true) ?: []);
        $counts = $latest === null ? [] : (json_decode((string) $latest->sample_counts, true) ?: []);
        $ratings = $components['ratings'] ?? [];
        $operations = $components['operations'] ?? null;
        $metric = static fn (string $key, ?string $value, int $count, int $minimum, string $window, string $reason): array => [
            'key' => $key, 'value' => $value === null ? null : PublicScores::round($value), 'published' => $value !== null, 'sample_count' => $count, 'minimum_sample' => $minimum, 'window' => $window,
            'status_text' => $value === null ? ScoreRules::NEW_VENDOR_LABEL.' — '.$reason : 'Published',
        ];
        $nextMonday = CarbonImmutable::now('Asia/Manila')->startOfDay();
        while ($nextMonday->dayOfWeekIso !== ScoreRules::OHS_RECALCULATION_WEEKDAY || $nextMonday->lessThanOrEqualTo(CarbonImmutable::now('Asia/Manila'))) {
            $nextMonday = $nextMonday->addDay();
        }

        return [
            'calculated' => $latest !== null,
            'as_of' => $latest?->window_ends_on === null ? null : (string) $latest->window_ends_on,
            'calculated_at' => self::iso($latest?->calculated_at),
            'label' => $latest?->vps === null ? ScoreRules::NEW_VENDOR_LABEL : 'VPS '.PublicScores::round((string) $latest->vps).' of 5',
            'scores' => [
                $metric('VPS', $latest?->vps === null ? null : (string) $latest->vps, 0, 0, 'Daily: VCS 50% + OHS 50%', 'published only when both VCS and OHS are eligible'),
                $metric('VCS', $latest?->vcs === null ? null : (string) $latest->vcs, (int) ($counts['vendor_ratings'] ?? 0), ScoreRules::MIN_VENDOR_RATINGS, 'Rolling 90 days', 'needs 5 eligible Vendor ratings and an eligible MQS'),
                $metric('MQS', $latest?->mqs === null ? null : (string) $latest->mqs, (int) ($counts['product_ratings'] ?? 0), ScoreRules::MIN_PRODUCT_RATINGS, 'Rolling 90 days', 'needs 5 eligible product ratings'),
                $metric('OHS', $latest?->ohs === null ? null : (string) $latest->ohs, (int) ($counts['eligible_orders'] ?? 0), ScoreRules::MIN_OHS_ORDERS, 'Trailing 30 days, recalculated weekly', 'needs 10 eligible orders'),
            ],
            'rating_components' => ['service_quality' => isset($ratings['service_quality']) ? PublicScores::round((string) $ratings['service_quality']) : null,
                'speed' => isset($ratings['speed']) ? PublicScores::round((string) $ratings['speed']) : null],
            'operations' => $operations === null ? null : [
                'rates' => $operations['rates'], 'penalties' => $operations['penalties'], 'numerators' => $operations['numerators'],
                'denominators' => ['NFR' => $operations['eligible_orders'], 'LSR' => $operations['dispatched_orders'], 'RR' => $operations['fulfilled_orders'], 'ODR' => $operations['eligible_orders']],
                'listing_violations' => $operations['listing_violations'],
            ],
            'ohs_calculated_on' => $latest?->ohs_calculated_on === null ? null : (string) $latest->ohs_calculated_on,
            'next_ohs_recalculation_on' => $nextMonday->toDateString(),
            'badge_metrics' => [
                ['key' => 'CRR', 'value' => $latest?->crr === null ? null : (string) $latest->crr, 'sample_count' => (int) ($counts['inquiries'] ?? 0), 'window' => 'Trailing 30 days', 'definition' => 'Eligible inquiries answered by a person within 12 hours ÷ eligible inquiries × 100'],
                ['key' => 'FRR', 'value' => $latest?->frr === null ? null : (string) $latest->frr, 'sample_count' => (int) ($counts['fulfilled_orders'] ?? 0), 'window' => 'Trailing 90 days', 'definition' => 'Orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100'],
            ],
            'completed_orders' => ['last_90_days' => (int) ($counts['completed_orders_90_days'] ?? 0), 'total' => (int) ($counts['completed_orders_total'] ?? 0)],
            'history' => DB::table('score_snapshots')->where('vendor_organization_id', $organizationId)->orderByDesc('window_ends_on')->limit(30)->get(['window_ends_on', 'vps', 'vcs', 'mqs', 'ohs'])->reverse()->values()
                ->map(static fn (object $row): array => ['date' => (string) $row->window_ends_on, 'vps' => $row->vps === null ? null : (string) $row->vps, 'vcs' => $row->vcs === null ? null : (string) $row->vcs,
                    'mqs' => $row->mqs === null ? null : (string) $row->mqs, 'ohs' => $row->ohs === null ? null : (string) $row->ohs])->all(),
        ];
    }

    /** @return list<array<string, mixed>> */
    private function badgeStates(string $organizationId, bool $admin): array
    {
        $active = DB::table('vendor_badge_history as h')->join('badge_definitions as d', 'd.id', '=', 'h.badge_definition_id')->where('h.vendor_organization_id', $organizationId)->whereNull('h.revoked_at')
            ->get(['d.code', 'h.scope_label', 'h.earned_at'])->groupBy('code');
        $suppressed = DB::table('badge_suppressions as s')->join('badge_definitions as d', 'd.id', '=', 's.badge_definition_id')->where('s.vendor_organization_id', $organizationId)->whereNull('s.lifted_at')
            ->get(['d.code', 's.reason_code', 's.case_reference'])->keyBy('code');

        return DB::table('badge_definitions')->whereIn('code', BadgeService::STORED)->orderBy('code')->get(['code', 'name'])->map(static function (object $definition) use ($active, $suppressed, $admin): array {
            $awards = $active->get($definition->code);
            $suppression = $suppressed->get($definition->code);

            return [
                'code' => $definition->code, 'name' => $definition->name, 'description' => PublicScores::BADGE_TEXT[$definition->code] ?? '',
                'status' => $suppression !== null ? 'SUPPRESSED' : ($awards === null ? 'NOT_EARNED' : 'EARNED'),
                'scopes' => $awards === null ? [] : $awards->map(static fn (object $award): array => ['scope_label' => $award->scope_label, 'earned_at' => self::iso($award->earned_at)])->values()->all(),
                'suppression' => $suppression === null ? null : ($admin ? ['reason_code' => $suppression->reason_code, 'case_reference' => $suppression->case_reference] : ['reason_code' => $suppression->reason_code]),
            ];
        })->all();
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
