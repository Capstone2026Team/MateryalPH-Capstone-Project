<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * Deterministic row locking. Single-variant Vendor edits lock organization → listing → variant →
 * inventory/policy. Multi-line acceptance locks every affected inventory row in ascending id order and then
 * every auto-accept policy row in ascending id order, so two concurrent acceptances can never deadlock
 * on the same rows; the caller validates all lines before changing any of them.
 */
final class InventoryLocks
{
    public function __construct(private readonly CatalogAccess $catalog) {}

    /**
     * @return array{organization: object, listing: object, variant: object}
     */
    public function variantForUpdate(string $organizationId, string $variantId, bool $requireActiveStore = true): array
    {
        $this->assertTransaction();
        $organization = $requireActiveStore ? $this->catalog->lockActiveStore($organizationId) : DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
        $listingId = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->where('v.id', $variantId)->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->value('l.id');
        if ($organization === null || $listingId === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The product variant is unavailable.', 404);
        }
        $listing = DB::table('vendor_listings')->where('id', $listingId)->lockForUpdate()->first();
        $variant = DB::table('listing_variants')->where('id', $variantId)->lockForUpdate()->first();

        return ['organization' => $organization, 'listing' => $listing, 'variant' => $variant];
    }

    /**
     * Locks the inventory and auto-accept rows of every affected variant for one acceptance transaction.
     *
     * @param  list<string>  $variantIds
     * @return array{inventory: array<string, object>, policies: array<string, object>}
     */
    public function lockForAcceptance(array $variantIds): array
    {
        $this->assertTransaction();
        $variantIds = array_values(array_unique($variantIds));
        sort($variantIds);
        if ($variantIds === []) {
            return ['inventory' => [], 'policies' => []];
        }
        $inventory = DB::table('inventory_items')->whereIn('listing_variant_id', $variantIds)->orderBy('id')->lockForUpdate()->get();
        $policies = DB::table('auto_accept_policies')->whereIn('listing_variant_id', $variantIds)->orderBy('id')->lockForUpdate()->get();

        return [
            'inventory' => $inventory->keyBy('listing_variant_id')->all(),
            'policies' => $policies->keyBy('listing_variant_id')->all(),
        ];
    }

    private function assertTransaction(): void
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Inventory rows are locked only inside a database transaction.');
        }
    }
}
