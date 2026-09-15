<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\DB;

final class ListingPrerequisite
{
    public function satisfied(string $organization): bool
    {
        $rows = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->where('l.vendor_organization_id', $organization)->where('l.status', 'ACTIVE')->where('l.ordinary_public_price_available', true)->whereNotNull('p.material_id')->select(['l.id', 'p.material_id'])->orderBy('l.id')->cursor();
        foreach ($rows as $listing) {
            $priced = DB::table('listing_variants as v')->join('listing_price_versions as p', 'p.listing_variant_id', '=', 'v.id')->where('v.vendor_listing_id', $listing->id)->where('v.active', true)->where('p.amount_centavos', '>', 0)->where('p.currency', 'PHP')->whereNull('p.retired_at')->where('p.effective_at', '<=', now())->exists();
            if (! $priced) {
                continue;
            }
            $regulated = DB::table('regulated_material_rules')->where('material_id', $listing->material_id)->where('effective_from', '<=', now()->toDateString())->where(fn ($q) => $q->whereNull('effective_to')->orWhere('effective_to', '>=', now()->toDateString()))->exists();
            if ($regulated) {
                $submission = DB::table('compliance_submissions')->where('vendor_listing_id', $listing->id)->orderByDesc('version')->first();
                if ($submission === null || ! in_array($submission->status, ['VERIFIED', 'APPROVED'], true)) {
                    continue;
                }
            }

            return true;
        }

        return false;
    }
}
