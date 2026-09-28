<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/**
 * FIN-02 line classification. Displayed prices are payable amounts inclusive of
 * any applicable Vendor VAT. The four classifications stay distinct; zero-rated
 * and exempt lines need a recorded basis, and the Vendor's reviewed VAT profile
 * limits which classifications a line may carry. Staff never infer VAT status.
 */
final class ListingTaxPolicy
{
    public const CATEGORIES = ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT', 'NON_VAT'];

    public const BASIS_REQUIRED = ['VAT_ZERO', 'VAT_EXEMPT'];

    /** @return list<string> An empty list means the payable classification is unknown. */
    public function allowedCategories(string $organizationId): array
    {
        $verified = DB::table('vendor_tax_profiles as p')
            ->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')
            ->where('p.vendor_organization_id', $organizationId)
            ->where('p.status', 'APPROVED')
            ->value('v.vat_verified_category');

        return match ($verified) {
            'NON_VAT' => ['NON_VAT'],
            'VAT', 'VAT_ZERO', 'VAT_EXEMPT' => ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT'],
            default => [],
        };
    }

    /**
     * The same mapping as allowedCategories() as a correlated SQL predicate, for queries that span
     * several Vendors. Price alias columns are qualified by the caller.
     */
    public static function constrainAllowed(Builder $query, string $priceCategoryColumn, string $organizationColumn): Builder
    {
        return $query->whereExists(fn (Builder $profile) => $profile->selectRaw('1')->from('vendor_tax_profiles as tp')
            ->join('vendor_tax_profile_versions as tv', 'tv.id', '=', 'tp.current_version_id')
            ->whereColumn('tp.vendor_organization_id', $organizationColumn)->where('tp.status', 'APPROVED')
            ->where(fn (Builder $match) => $match
                ->where(fn (Builder $nonVat) => $nonVat->where('tv.vat_verified_category', 'NON_VAT')->where($priceCategoryColumn, 'NON_VAT'))
                ->orWhere(fn (Builder $vat) => $vat->whereIn('tv.vat_verified_category', ['VAT', 'VAT_ZERO', 'VAT_EXEMPT'])->whereIn($priceCategoryColumn, ['VAT_12', 'VAT_ZERO', 'VAT_EXEMPT']))));
    }

    /** FIN-02 included VAT for a discounted payable VAT_12 amount: money(L × 12 / 112), half-up. */
    public static function includedVatCentavos(int $payableCentavos, string $category): int
    {
        if ($category !== 'VAT_12') {
            return 0;
        }

        return intdiv($payableCentavos * 12 + 56, 112);
    }
}
