<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\VolumePricing;
use Illuminate\Support\Facades\DB;

/**
 * Batch loaders for the public, Buyer-safe facts shown on result cards, Product Details and the cart. Each
 * loader runs one query for a whole page so result lists never issue per-row queries. Exact inventory,
 * private files and staff data are never read here.
 */
final class ListingPublicFacts
{
    /** Product Review ratings count only after reveal; Phase 14 owns review eligibility and moderation. */
    public const PRODUCT_REVIEW = 'PRODUCT';

    /**
     * @param  list<string>  $listingIds
     * @return array<string, array{average: ?string, count: int}>
     */
    public function productRatings(array $listingIds): array
    {
        if ($listingIds === []) {
            return [];
        }
        $rows = DB::table('reviews as r')->join('order_lines as ol', 'ol.id', '=', 'r.order_line_id')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')
            ->whereIn('v.vendor_listing_id', $listingIds)->where('r.review_type', self::PRODUCT_REVIEW)->whereNotNull('r.revealed_at')->whereNotNull('r.rating')
            ->groupBy('v.vendor_listing_id')->selectRaw('v.vendor_listing_id, round(avg(r.rating)::numeric, 2) AS average, count(*) AS total')->get();
        $ratings = [];
        foreach ($rows as $row) {
            $ratings[(string) $row->vendor_listing_id] = ['average' => (string) $row->average, 'count' => (int) $row->total];
        }

        return $ratings;
    }

    /**
     * Latest published VPS per organization; null means a new Vendor without an earned public score.
     *
     * @param  list<string>  $organizationIds
     * @return array<string, string>
     */
    public function vps(array $organizationIds): array
    {
        if ($organizationIds === []) {
            return [];
        }

        return DB::query()->fromSub(DB::table('score_snapshots')->whereIn('vendor_organization_id', $organizationIds)->whereNotNull('vps')
            ->selectRaw('DISTINCT ON (vendor_organization_id) vendor_organization_id, vps')->orderBy('vendor_organization_id')->orderByDesc('window_ends_on'), 's')
            ->pluck('vps', 'vendor_organization_id')->map(static fn (mixed $vps): string => (string) $vps)->all();
    }

    /**
     * Quantities on COMPLETED orders only, in each line's sale unit.
     *
     * @param  list<string>  $listingIds
     * @return array<string, string>
     */
    public function unitsSold(array $listingIds): array
    {
        if ($listingIds === []) {
            return [];
        }

        return DB::table('order_lines as ol')->join('orders as o', 'o.id', '=', 'ol.order_id')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')
            ->whereIn('v.vendor_listing_id', $listingIds)->where('o.order_state', 'COMPLETED')
            ->groupBy('v.vendor_listing_id')->selectRaw('v.vendor_listing_id, sum(ol.quantity) AS sold')->pluck('sold', 'vendor_listing_id')
            ->map(static fn (mixed $sold): string => bcadd((string) $sold, '0', 4))->all();
    }

    /**
     * Public listing images: READY media whose file is PUBLIC, CLEAN and has an https delivery URL.
     *
     * @param  list<string>  $listingIds
     * @return array<string, list<array{url: string, alt_text: ?string}>>
     */
    public function images(array $listingIds): array
    {
        if ($listingIds === []) {
            return [];
        }
        $images = [];
        $rows = DB::table('listing_media as m')->join('files as f', 'f.id', '=', 'm.file_id')->whereIn('m.vendor_listing_id', $listingIds)->where('m.status', 'READY')
            ->where('f.visibility', 'PUBLIC')->where('f.scan_state', 'CLEAN')->orderBy('m.sort_order')->orderBy('m.id')->get(['m.vendor_listing_id', 'm.alt_text', 'f.metadata']);
        foreach ($rows as $row) {
            $metadata = json_decode((string) $row->metadata, true);
            $url = is_array($metadata) ? ($metadata['public_url'] ?? null) : null;
            if (is_string($url) && preg_match('~^https://~i', $url) === 1) {
                $images[(string) $row->vendor_listing_id][] = ['url' => $url, 'alt_text' => $row->alt_text === null ? null : (string) $row->alt_text];
            }
        }

        return $images;
    }

    /** @return array<string, bool> */
    public function favoriteOrganizations(string $buyerProfileId): array
    {
        return DB::table('favorite_vendors')->where('buyer_profile_id', $buyerProfileId)->pluck('vendor_organization_id')
            ->mapWithKeys(static fn (mixed $id): array => [(string) $id => true])->all();
    }

    /**
     * Current CAT-PRICE-01 volume tiers per variant, ascending by minimum quantity.
     *
     * @param  list<string>  $variantIds
     * @return array<string, list<array{price_version_id: string, minimum_quantity: string, amount_centavos: int}>>
     */
    public function volumeTiers(array $variantIds): array
    {
        if ($variantIds === []) {
            return [];
        }
        $tiers = [];
        foreach (DB::table('listing_price_versions')->whereIn('listing_variant_id', $variantIds)->where('price_kind', 'VOLUME_TIER')->whereNull('retired_at')
            ->where('effective_at', '<=', now())->orderBy('minimum_quantity')->get(['id', 'listing_variant_id', 'minimum_quantity', 'amount_centavos']) as $tier) {
            $tiers[(string) $tier->listing_variant_id][] = ['price_version_id' => (string) $tier->id, 'minimum_quantity' => VolumePricing::normalizeQuantity((string) $tier->minimum_quantity), 'amount_centavos' => (int) $tier->amount_centavos];
        }

        return $tiers;
    }

    public static function vatLabel(string $taxCategory): string
    {
        return match ($taxCategory) {
            'VAT_12' => 'VAT inclusive',
            'VAT_ZERO' => 'VAT zero-rated',
            'VAT_EXEMPT' => 'VAT-exempt',
            default => 'Non-VAT seller',
        };
    }
}
