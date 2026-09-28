<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Favorite Supplier is a personal Buyer relationship with a Tier 2 Verified Vendor. It is never the
 * system-awarded Trusted Supplier badge, never changes ranking by itself, and is unavailable for Tier 1
 * Directory Suppliers. A saved Favorite outside the radius stays listed but is not shown as eligible.
 */
final class FavoriteSupplierService
{
    public function __construct(private readonly BuyerProfiles $profiles, private readonly PublicVendorProjection $vendors) {}

    public function add(Request $request, string $vendorId): void
    {
        $buyerId = $this->profiles->idFor($request);
        $vendor = Str::isUuid($vendorId) ? DB::table('vendor_organizations')->where('id', $vendorId)->where('account_status', 'ACTIVE')->where('store_activation_status', 'ACTIVE')->exists() : false;
        if (! $vendor) {
            if (Str::isUuid($vendorId) && DB::table('directory_suppliers')->where('id', $vendorId)->exists()) {
                throw new AuthenticationException('FAVORITE_REQUIRES_VERIFIED_VENDOR', 'Only Verified Vendors can be saved as Favorite Suppliers.', 422);
            }
            throw new AuthenticationException('VENDOR_NOT_FOUND', 'This Verified Vendor is unavailable.', 404);
        }
        DB::table('favorite_vendors')->insertOrIgnore(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $vendorId, 'created_at' => now(), 'updated_at' => now()]);
    }

    public function remove(Request $request, string $vendorId): void
    {
        $buyerId = $this->profiles->idFor($request);
        if (Str::isUuid($vendorId)) {
            DB::table('favorite_vendors')->where('buyer_profile_id', $buyerId)->where('vendor_organization_id', $vendorId)->delete();
        }
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function list(Request $request, int $page): array
    {
        $buyerId = $this->profiles->idFor($request);
        $favorites = DB::table('favorite_vendors')->where('buyer_profile_id', $buyerId)->orderByDesc('created_at')->orderBy('id')->paginate(20, ['vendor_organization_id', 'created_at'], 'page', $page);
        $ids = collect($favorites->items())->pluck('vendor_organization_id')->map(static fn (mixed $id): string => (string) $id)->all();
        $discoverable = $ids === [] ? [] : $this->vendors->members()->whereIn('o.id', $ids)->pluck('o.id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();
        $summaries = $this->vendors->summaries($ids);
        $items = [];
        foreach ($favorites->items() as $favorite) {
            $summary = $summaries[(string) $favorite->vendor_organization_id] ?? null;
            if ($summary === null) {
                continue;
            }
            $items[] = ['vendor_id' => $summary['id'], 'name' => $summary['public_store_name'], 'logo_url' => $summary['logo_url'], 'score_label' => $summary['score_label'],
                'currently_discoverable' => isset($discoverable[$summary['id']]), 'saved_at' => Carbon::parse((string) $favorite->created_at)->toIso8601String()];
        }

        return ['items' => $items, 'meta' => ['current_page' => $favorites->currentPage(), 'last_page' => $favorites->lastPage(), 'total' => $favorites->total()]];
    }
}
