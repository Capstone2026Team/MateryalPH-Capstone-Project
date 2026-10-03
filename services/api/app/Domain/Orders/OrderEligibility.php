<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\ListingTaxPolicy;
use Illuminate\Support\Facades\DB;

/**
 * Current-eligibility checks made at confirmation or acceptance, after the organization row is locked, so a
 * concurrent restriction, activation hold or public-media invalidation either commits first and blocks the
 * confirmation or waits until the confirmation commits. Existing accepted orders are never re-checked here:
 * a later restriction keeps their authorized fulfillment and remedies.
 */
final class OrderEligibility
{
    public function __construct(private readonly ListingTaxPolicy $tax) {}

    /** @return list<string> Store-level blocker codes for new commercial acceptance. */
    public function storeBlockers(object $lockedOrganization): array
    {
        $blockers = [];
        if ($lockedOrganization->account_status !== 'ACTIVE' || $lockedOrganization->store_activation_status !== 'ACTIVE') {
            $blockers[] = 'STORE_NOT_ACTIVE';
        }
        if ($lockedOrganization->activation_hold_code !== null) {
            $blockers[] = 'STORE_RESTRICTED';
        }
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $lockedOrganization->id)->first(['status']);
        if ($profile === null || $profile->status !== 'COMPLETED') {
            // A removed required logo/banner returns the public profile to an incomplete state.
            $blockers[] = 'STORE_PROFILE_INCOMPLETE';
        }

        return $blockers;
    }

    public function onlinePaymentReady(string $organizationId): bool
    {
        return DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->where('connection_status', 'CONNECTED_TEST')->exists();
    }

    /**
     * Line-level blockers keyed by listing variant id: the listing must still be ACTIVE and not removed, meet any
     * required product compliance, the variant must be active, and the line's frozen tax classification must
     * still be permitted by the Vendor's reviewed VAT profile. The line keeps its submitted price snapshot.
     *
     * @param  array<string, string>  $taxCategories  listing variant id => snapshot tax category
     * @return array<string, string>
     */
    public function lineBlockers(string $organizationId, array $taxCategories): array
    {
        if ($taxCategories === []) {
            return [];
        }
        $allowed = $this->tax->allowedCategories($organizationId);
        $rows = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->whereIn('v.id', array_keys($taxCategories))
            ->where('l.vendor_organization_id', $organizationId)->get(['v.id', 'v.active', 'l.status', 'l.removed_at', 'l.regulated', 'l.compliance_status'])->keyBy('id');
        $blockers = [];
        foreach ($taxCategories as $variantId => $category) {
            $row = $rows->get($variantId);
            $blockers[$variantId] = match (true) {
                $row === null, $row->removed_at !== null, $row->status !== 'ACTIVE' => 'LISTING_NOT_ACTIVE',
                (bool) $row->regulated && $row->compliance_status !== 'VERIFIED' => 'COMPLIANCE_NOT_VERIFIED',
                ! (bool) $row->active => 'VARIANT_INACTIVE',
                ! in_array($category, $allowed, true) => 'TAX_CLASSIFICATION_CHANGED',
                default => '',
            };
        }

        return array_filter($blockers, static fn (string $code): bool => $code !== '');
    }
}
