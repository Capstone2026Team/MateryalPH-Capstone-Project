<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Disputes\DisputeRules;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Automatic badge award and removal from the day's snapshot, using the System Workflow triggers exactly. A badge is
 * awarded when its criteria hold and removed (CRITERIA_NOT_MET) when they stop holding; history rows are never
 * deleted. There is no manual award path: an Admin may only suppress a badge's display for a documented fraud or
 * compliance case (BadgeSuppression), which does not change the evaluation. Best Price is evaluated at query time
 * per listing and radius and is never stored here.
 */
final class BadgeService
{
    public const STORED = ['FAST_RESPONDER', 'ON_TIME', 'MOST_ORDERED', 'HIGHLY_RATED', 'HIGH_QUALITY_MATERIALS', 'TRUSTED_SUPPLIER'];

    /** Case states treated as an unresolved severe dispute for Trusted Supplier. */
    public const SEVERE_DISPUTE_STATES = [DisputeRules::ESCALATED_ADMIN_REVIEW, DisputeRules::AWAITING_CLARIFICATION, DisputeRules::DECIDED, DisputeRules::APPEAL_OPEN];

    /** @return array{awarded: int, removed: int} */
    public function evaluate(CarbonImmutable $end): array
    {
        $windowEndsOn = $end->subDay()->toDateString();
        $utcEnd = $end->setTimezone('UTC');
        $definitions = DB::table('badge_definitions')->whereIn('code', self::STORED)->pluck('id', 'code');
        $snapshots = DB::table('score_snapshots')->where('window_ends_on', $windowEndsOn)->get()->keyBy('vendor_organization_id');
        $earned = [];
        foreach ($snapshots as $organizationId => $snapshot) {
            $counts = json_decode((string) $snapshot->sample_counts, true) ?: [];
            $organizationId = (string) $organizationId;
            $add = static function (string $code, array $evidence) use (&$earned, $organizationId): void {
                $earned[$organizationId.'|'.$code.'|'] = ['organization_id' => $organizationId, 'code' => $code, 'scope_key' => '', 'scope_label' => null, 'evidence' => $evidence];
            };
            if ($snapshot->crr !== null && bccomp((string) $snapshot->crr, '85.00', 2) >= 0 && ($counts['inquiries'] ?? 0) >= 10) {
                $add('FAST_RESPONDER', ['crr' => (string) $snapshot->crr, 'inquiries' => $counts['inquiries']]);
            }
            if ($snapshot->frr !== null && bccomp((string) $snapshot->frr, '95.00', 2) >= 0 && ($counts['fulfilled_orders'] ?? 0) >= 10) {
                $add('ON_TIME', ['frr' => (string) $snapshot->frr, 'fulfilled_orders' => $counts['fulfilled_orders']]);
            }
            if ($snapshot->vcs !== null && bccomp((string) $snapshot->vcs, '4.50', 2) >= 0 && ($counts['vendor_ratings'] ?? 0) >= 10) {
                $add('HIGHLY_RATED', ['vcs' => (string) $snapshot->vcs, 'vendor_ratings' => $counts['vendor_ratings']]);
            }
            if ($snapshot->mqs !== null && bccomp((string) $snapshot->mqs, '4.60', 2) >= 0 && ($counts['product_ratings'] ?? 0) >= 10) {
                $add('HIGH_QUALITY_MATERIALS', ['mqs' => (string) $snapshot->mqs, 'product_ratings' => $counts['product_ratings']]);
            }
            if ($this->trusted($organizationId, $snapshot, $counts, $utcEnd)) {
                $add('TRUSTED_SUPPLIER', ['vcs' => (string) $snapshot->vcs, 'ohs' => (string) $snapshot->ohs, 'completed_orders' => $counts['completed_orders_total'] ?? 0]);
            }
        }
        foreach ($this->mostOrdered(array_keys($snapshots->all()), $utcEnd) as $award) {
            $earned[$award['organization_id'].'|MOST_ORDERED|'.$award['scope_key']] = $award + ['code' => 'MOST_ORDERED'];
        }

        $counts = ['awarded' => 0, 'removed' => 0];
        DB::transaction(function () use ($earned, $definitions, $snapshots, &$counts): void {
            $active = DB::table('vendor_badge_history')->whereIn('vendor_organization_id', $snapshots->keys())->whereIn('badge_definition_id', $definitions->values())->whereNull('revoked_at')->lockForUpdate()->get();
            $codes = $definitions->flip();
            $current = [];
            foreach ($active as $award) {
                $key = $award->vendor_organization_id.'|'.$codes[$award->badge_definition_id].'|'.$award->scope_key;
                $current[$key] = true;
                if (! isset($earned[$key])) {
                    $counts['removed'] += DB::table('vendor_badge_history')->where('id', $award->id)->update(['revoked_at' => now(), 'revocation_reason' => 'CRITERIA_NOT_MET', 'updated_at' => now()]);
                }
            }
            foreach ($earned as $key => $award) {
                if (isset($current[$key])) {
                    continue;
                }
                $counts['awarded'] += DB::table('vendor_badge_history')->insertOrIgnore(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $award['organization_id'], 'badge_definition_id' => $definitions[$award['code']],
                    'scope_key' => $award['scope_key'], 'scope_label' => $award['scope_label'], 'earned_at' => now(), 'evidence' => json_encode($award['evidence'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
        });

        return $counts;
    }

    /** @param array<string, mixed> $counts */
    private function trusted(string $organizationId, object $snapshot, array $counts, CarbonImmutable $end): bool
    {
        if ($snapshot->vcs === null || $snapshot->ohs === null || bccomp((string) $snapshot->vcs, '4.50', 2) < 0 || bccomp((string) $snapshot->ohs, '4.50', 2) < 0 || ($counts['completed_orders_total'] ?? 0) < 25) {
            return false;
        }
        $verifiedSince = DB::table('vendor_activation_history')->where('vendor_organization_id', $organizationId)->where('state_after', 'ACTIVE')->min('recorded_at');
        if ($verifiedSince === null || CarbonImmutable::parse((string) $verifiedSince)->greaterThan($end->subDays(90))) {
            return false;
        }
        $hold = DB::table('vendor_organizations')->where('id', $organizationId)->value('activation_hold_code');
        $violation = DB::table('metric_events')->where('vendor_organization_id', $organizationId)->where('metric', 'MISREPRESENTED_LISTING')->where('occurred_at', '>=', $end->subDays(ScoreRules::LVD_WINDOW_DAYS))->exists();
        $severe = DB::table('dispute_cases')->where('vendor_organization_id', $organizationId)->whereIn('status', self::SEVERE_DISPUTE_STATES)->exists();

        return $hold === null && ! $violation && ! $severe;
    }

    /**
     * @param  list<string>  $organizationIds
     * @return list<array{organization_id: string, scope_key: string, scope_label: string, evidence: array<string, mixed>}>
     */
    private function mostOrdered(array $organizationIds, CarbonImmutable $end): array
    {
        if ($organizationIds === []) {
            return [];
        }
        $provinces = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')->whereIn('a.vendor_organization_id', $organizationIds)
            ->get(['a.vendor_organization_id', 'v.province_code', 'v.province'])->mapWithKeys(static fn (object $row): array => [(string) $row->vendor_organization_id => [
                'key' => (string) ($row->province_code ?? mb_strtoupper(trim((string) $row->province))), 'label' => (string) ($row->province ?? $row->province_code ?? '')]]);
        $rows = DB::table('metric_events as e')->where('e.metric', 'ORDER_COMPLETED')->whereIn('e.vendor_organization_id', $organizationIds)
            ->where('e.occurred_at', '>=', $end->subDays(90))->where('e.occurred_at', '<', $end)
            ->whereNotExists(fn ($x) => $x->selectRaw('1')->from('score_exclusions as x')->whereColumn('x.order_id', 'e.order_id')->whereNull('x.revoked_at'))
            ->get(['e.vendor_organization_id', 'e.order_id', 'e.details']);
        $groups = [];
        foreach ($rows as $row) {
            $province = $provinces[(string) $row->vendor_organization_id] ?? null;
            if ($province === null || $province['key'] === '') {
                continue;
            }
            foreach ((json_decode((string) $row->details, true) ?: [])['category_ids'] ?? [] as $categoryId) {
                $groups[$categoryId.':'.$province['key']][(string) $row->vendor_organization_id][(string) $row->order_id] = true;
            }
        }
        $categories = DB::table('material_categories')->pluck('name', 'id');
        $awards = [];
        foreach ($groups as $scopeKey => $organizations) {
            $counts = array_map('count', $organizations);
            [$categoryId] = explode(':', $scopeKey, 2);
            foreach (ScoreRules::mostOrdered($counts) as $organizationId) {
                $awards[] = ['organization_id' => $organizationId, 'scope_key' => $scopeKey, 'scope_label' => ($categories[$categoryId] ?? 'Category').' · '.$provinces[$organizationId]['label'],
                    'evidence' => ['completed_orders' => $counts[$organizationId], 'vendors_in_group' => count($counts)]];
            }
        }

        return $awards;
    }
}
