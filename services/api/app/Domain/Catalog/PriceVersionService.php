<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The single writer of ordinary listing price versions. A public price change never edits an earlier
 * version: it retires the current row and appends a new immutable version that references it, so daily
 * observations and order snapshots keep their original source (MAT-03). Callers hold the variant's locks.
 */
final class PriceVersionService
{
    /** Creates a new immutable ordinary price version only when the price terms change. */
    public function saveOrdinary(int $actorId, string $variantId, int $amount, string $category, mixed $basis): bool
    {
        $basis = in_array($category, ListingTaxPolicy::BASIS_REQUIRED, true) ? trim((string) $basis) : null;
        $current = DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->lockForUpdate()->first();
        if ($current !== null && (int) $current->amount_centavos === $amount && $current->tax_category === $category && $current->tax_basis === $basis) {
            return false;
        }
        if ($current !== null) {
            DB::table('listing_price_versions')->where('id', $current->id)->update(['retired_at' => now(), 'updated_at' => now()]);
        }
        $version = (int) DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->max('version') + 1;
        DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => $version, 'amount_centavos' => $amount, 'currency' => 'PHP', 'tax_category' => $category, 'tax_basis' => $basis, 'price_kind' => 'ORDINARY', 'effective_at' => now(), 'created_by_user_id' => $actorId, 'supersedes_price_version_id' => $current?->id, 'created_at' => now(), 'updated_at' => now()]);

        return true;
    }

    /** @return list<array{minimum_quantity: string, price_centavos: int}> Current volume tiers as rule input rows. */
    public function currentTierRows(string $variantId): array
    {
        return DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'VOLUME_TIER')->whereNull('retired_at')
            ->orderBy('minimum_quantity')->get(['minimum_quantity', 'amount_centavos'])
            ->map(static fn (object $tier): array => ['minimum_quantity' => VolumePricing::normalizeQuantity((string) $tier->minimum_quantity), 'price_centavos' => (int) $tier->amount_centavos])->values()->all();
    }

    /**
     * Every price version of a variant, newest first, including retired and superseded rows.
     *
     * @return list<array<string, mixed>>
     */
    public function history(string $variantId, int $limit = 50): array
    {
        return DB::table('listing_price_versions as pv')->leftJoin('user_profiles as up', 'up.user_id', '=', 'pv.created_by_user_id')
            ->where('pv.listing_variant_id', $variantId)->orderByDesc('pv.version')->limit($limit)
            ->get(['pv.id', 'pv.version', 'pv.price_kind', 'pv.amount_centavos', 'pv.tax_category', 'pv.tax_basis', 'pv.minimum_quantity', 'pv.effective_at', 'pv.retired_at', 'pv.supersedes_price_version_id', 'up.full_name'])
            ->map(static fn (object $row): array => [
                'price_version_id' => $row->id, 'version' => (int) $row->version, 'price_kind' => $row->price_kind, 'amount_centavos' => (int) $row->amount_centavos,
                'tax_category' => $row->tax_category, 'minimum_quantity' => $row->minimum_quantity === null ? null : VolumePricing::normalizeQuantity((string) $row->minimum_quantity),
                'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos((int) $row->amount_centavos, (string) $row->tax_category),
                'effective_at' => $row->effective_at, 'retired_at' => $row->retired_at, 'supersedes_price_version_id' => $row->supersedes_price_version_id,
                'current' => $row->retired_at === null, 'created_by' => $row->full_name,
            ])->all();
    }
}
