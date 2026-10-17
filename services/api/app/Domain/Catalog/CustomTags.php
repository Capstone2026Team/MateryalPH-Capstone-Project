<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Vendor-typed search tags (approved by the project owner on 2026-10-17). They sit beside the up-to-three
 * approved platform tags, belong to one listing, and never enter Admin Taxonomy Management. A listing needs at
 * least one tag of either kind before it can be published.
 */
final class CustomTags
{
    public const MIN_LENGTH = 2;

    public const MAX_LENGTH = 40;

    /** A safety ceiling, not a product limit: Vendors add as many as they need within it. */
    public const MAX = 50;

    /**
     * Cleaned labels in the order typed, without repeats (compared ignoring case and spacing).
     *
     * @param  list<mixed>  $labels
     * @return array<string, string> normalized label => display label
     */
    public static function clean(array $labels): array
    {
        $clean = [];
        foreach ($labels as $label) {
            if (! is_string($label)) {
                continue;
            }
            $display = trim((string) preg_replace('/\s+/u', ' ', $label));
            $normalized = mb_strtolower($display);
            if (mb_strlen($display) < self::MIN_LENGTH || mb_strlen($display) > self::MAX_LENGTH || ! preg_match('/^[\p{L}\p{N}][\p{L}\p{N} \-.&\/+\']*$/u', $display)) {
                continue;
            }
            $clean[$normalized] ??= $display;
        }

        return $clean;
    }

    /**
     * Entries that cleaning would reject, so the Vendor is told instead of the tag vanishing.
     *
     * @param  list<mixed>  $labels
     * @return list<string>
     */
    public static function invalid(array $labels): array
    {
        return array_values(array_filter(array_map(static fn (mixed $label): string => is_string($label) ? trim($label) : '', $labels),
            static fn (string $label): bool => $label !== '' && self::clean([$label]) === []));
    }

    /**
     * Replaces the listing's custom tags with the given labels.
     *
     * @param  list<mixed>  $labels
     */
    public static function replace(string $listingId, array $labels): void
    {
        DB::table('listing_custom_tags')->where('vendor_listing_id', $listingId)->delete();
        foreach (self::clean($labels) as $normalized => $display) {
            DB::table('listing_custom_tags')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'label' => $display, 'normalized_label' => $normalized, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /** @return list<string> */
    public static function forListing(string $listingId): array
    {
        return DB::table('listing_custom_tags')->where('vendor_listing_id', $listingId)->orderBy('created_at')->orderBy('id')->pluck('label')->all();
    }

    public static function count(string $listingId): int
    {
        return DB::table('listing_custom_tags')->where('vendor_listing_id', $listingId)->count();
    }
}
