<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

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

    /** FIN-02 included VAT for a discounted payable VAT_12 amount: money(L × 12 / 112), half-up. */
    public static function includedVatCentavos(int $payableCentavos, string $category): int
    {
        if ($category !== 'VAT_12') {
            return 0;
        }

        return intdiv($payableCentavos * 12 + 56, 112);
    }
}
