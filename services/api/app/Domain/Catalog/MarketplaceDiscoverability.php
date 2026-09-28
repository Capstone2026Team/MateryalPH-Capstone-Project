<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Marketplace Discoverability is evaluated separately from Store Activation.
 * An active store with no eligible listing stays NOT_DISCOVERABLE. Eligibility
 * is the shared MAT-02 predicate (EligibleOfferQuery): an ACTIVE, compliant
 * listing with an available variant carrying a current ordinary public price,
 * a permitted tax classification and a non-stale stock confirmation.
 */
final class MarketplaceDiscoverability
{
    public const RULE_VERSION = 'phase5.discoverability.v2';

    public function __construct(private readonly EligibleOfferQuery $offers, private readonly EligibilityInvalidation $invalidation) {}

    /** Constrains a vendor_listings query (alias l) to currently eligible offers. */
    public function eligibleListings(Builder $query, string $organizationId): Builder
    {
        return $this->offers->constrainListings($query->where('l.vendor_organization_id', $organizationId));
    }

    /** @return array{status: string, reason: ?string, eligible_listings: int} */
    public function current(string $organizationId): array
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first(['account_status', 'store_activation_status', 'activation_hold_code']);
        if ($organization === null || $organization->account_status !== 'ACTIVE' || $organization->store_activation_status !== 'ACTIVE' || $organization->activation_hold_code !== null) {
            return ['status' => 'NOT_DISCOVERABLE', 'reason' => 'STORE_NOT_ACTIVE', 'eligible_listings' => 0];
        }
        $count = $this->eligibleListings(DB::table('vendor_listings as l'), $organizationId)->count();

        return $count > 0
            ? ['status' => 'DISCOVERABLE', 'reason' => null, 'eligible_listings' => $count]
            : ['status' => 'NOT_DISCOVERABLE', 'reason' => 'NO_ELIGIBLE_LISTINGS', 'eligible_listings' => 0];
    }

    /**
     * Persists the current state and appends any transition to vendor_activation_history.
     *
     * @return array{status: string, reason: ?string, eligible_listings: int}
     */
    public function evaluate(string $organizationId, ?int $actorId = null, string $source = 'SYSTEM'): array
    {
        return DB::transaction(function () use ($organizationId, $actorId, $source): array {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first(['marketplace_discoverability_status', 'marketplace_discoverability_reason']);
            if ($organization === null) {
                return ['status' => 'NOT_DISCOVERABLE', 'reason' => 'STORE_NOT_ACTIVE', 'eligible_listings' => 0];
            }
            $state = $this->current($organizationId);
            if ($organization->marketplace_discoverability_status !== $state['status'] || $organization->marketplace_discoverability_reason !== $state['reason']) {
                DB::table('vendor_organizations')->where('id', $organizationId)->update(['marketplace_discoverability_status' => $state['status'], 'marketplace_discoverability_reason' => $state['reason'], 'discoverability_evaluated_at' => now(), 'updated_at' => now()]);
                if ($organization->marketplace_discoverability_status !== $state['status']) {
                    DB::table('vendor_activation_history')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'state_before' => $organization->marketplace_discoverability_status, 'state_after' => $state['status'], 'result' => $state['status'], 'reason' => $state['reason'], 'blockers' => json_encode($state['reason'] === null ? [] : [['key' => $state['reason']]], JSON_THROW_ON_ERROR), 'readiness_snapshot' => json_encode($state + ['rule_version' => self::RULE_VERSION], JSON_THROW_ON_ERROR), 'actor_user_id' => $actorId, 'source' => $source, 'rule_version' => self::RULE_VERSION, 'recorded_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                }
            } else {
                DB::table('vendor_organizations')->where('id', $organizationId)->update(['discoverability_evaluated_at' => now()]);
            }
            // Scheduled re-evaluation only ages confirmations, which the short count TTL already covers.
            if ($source !== 'SYSTEM' || $organization->marketplace_discoverability_status !== $state['status']) {
                $this->invalidation->changed($organizationId, $source);
            }

            return $state;
        });
    }
}
