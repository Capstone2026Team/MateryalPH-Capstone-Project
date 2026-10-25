<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Favorite Supplier is a personal Buyer relationship with a Tier 2 Verified Vendor or a Tier 1 Directory Supplier.
 * It is never the system-awarded Trusted Supplier badge and never changes ranking by itself. A Directory Favorite
 * stores only the Google Place ID, so it outlives the bounded Directory cache; it stays informational and never
 * makes the place transactional. A saved Favorite outside the radius stays listed but is not shown as eligible.
 */
final class FavoriteSupplierService
{
    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly PublicVendorProjection $vendors,
        private readonly DirectorySupplierService $directory,
    ) {}

    public function add(Request $request, string $supplierId): void
    {
        $buyerId = $this->profiles->idFor($request);
        $vendor = Str::isUuid($supplierId) && DB::table('vendor_organizations')->where('id', $supplierId)->where('account_status', 'ACTIVE')->where('store_activation_status', 'ACTIVE')->exists();
        if ($vendor) {
            DB::table('favorite_vendors')->insertOrIgnore(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $supplierId, 'created_at' => now(), 'updated_at' => now()]);

            return;
        }
        $placeId = Str::isUuid($supplierId) ? $this->directory->visible()->where('d.id', $supplierId)->value('d.google_place_id') : null;
        if ($placeId === null) {
            if (Str::isUuid($supplierId) && DB::table('directory_suppliers')->where('id', $supplierId)->exists()) {
                throw new AuthenticationException('DIRECTORY_SUPPLIER_NOT_FOUND', 'This Directory Supplier is no longer available. Refresh the map.', 404);
            }
            throw new AuthenticationException('VENDOR_NOT_FOUND', 'This supplier is unavailable.', 404);
        }
        DB::table('favorite_directory_suppliers')->insertOrIgnore(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'google_place_id' => (string) $placeId, 'created_at' => now(), 'updated_at' => now()]);
    }

    /** Accepts a Verified Vendor id, a Directory Supplier result id (even after its cache expired) or a saved Directory Favorite id. */
    public function remove(Request $request, string $supplierId): void
    {
        $buyerId = $this->profiles->idFor($request);
        if (! Str::isUuid($supplierId)) {
            return;
        }
        DB::table('favorite_vendors')->where('buyer_profile_id', $buyerId)->where('vendor_organization_id', $supplierId)->delete();
        $placeId = DB::table('directory_suppliers')->where('id', $supplierId)->value('google_place_id');
        DB::table('favorite_directory_suppliers')->where('buyer_profile_id', $buyerId)
            ->where(fn (Builder $match) => $match->where('id', $supplierId)->when($placeId !== null, fn (Builder $place) => $place->orWhere('google_place_id', (string) $placeId)))
            ->delete();
    }

    /**
     * Saved Google Place IDs of the Buyer's Directory Favorites, keyed for lookup.
     *
     * @return array<string, int>
     */
    public function directoryPlaceIds(string $buyerId): array
    {
        return DB::table('favorite_directory_suppliers')->where('buyer_profile_id', $buyerId)->pluck('google_place_id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function list(Request $request, int $page): array
    {
        $buyerId = $this->profiles->idFor($request);
        $saved = DB::table('favorite_vendors')->where('buyer_profile_id', $buyerId)
            ->selectRaw("id, 'VERIFIED_VENDOR' AS tier, vendor_organization_id::text AS target, created_at")
            ->unionAll(DB::table('favorite_directory_suppliers')->where('buyer_profile_id', $buyerId)->selectRaw("id, 'DIRECTORY_SUPPLIER' AS tier, google_place_id AS target, created_at"));
        $favorites = DB::query()->fromSub($saved, 'f')->orderByDesc('created_at')->orderBy('id')->paginate(20, ['id', 'tier', 'target', 'created_at'], 'page', $page);
        $rows = collect($favorites->items());
        $ids = $rows->where('tier', SupplierDiscoveryService::TIER_VERIFIED)->pluck('target')->map(static fn (mixed $id): string => (string) $id)->values()->all();
        $placeIds = $rows->where('tier', SupplierDiscoveryService::TIER_DIRECTORY)->pluck('target')->map(static fn (mixed $id): string => (string) $id)->values()->all();
        $discoverable = $ids === [] ? [] : $this->vendors->members()->whereIn('o.id', $ids)->pluck('o.id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();
        $summaries = $this->vendors->summaries($ids);
        $places = $placeIds === [] ? collect() : $this->directory->visible()->whereIn('d.google_place_id', $placeIds)->get(['d.id', 'd.google_place_id', 'd.name'])->keyBy('google_place_id');
        $items = [];
        foreach ($favorites->items() as $favorite) {
            $savedAt = Carbon::parse((string) $favorite->created_at)->toIso8601String();
            if ($favorite->tier === SupplierDiscoveryService::TIER_DIRECTORY) {
                $place = $places->get((string) $favorite->target);
                // Without a current cache row there is no name to show (provider content is never stored with the
                // Favorite); the saved row id still lets the Buyer remove it.
                $items[] = ['vendor_id' => $place === null ? (string) $favorite->id : (string) $place->id, 'tier' => SupplierDiscoveryService::TIER_DIRECTORY,
                    'name' => $place === null ? 'Saved Directory Supplier' : (string) $place->name, 'logo_url' => null,
                    'score_label' => ['kind' => 'DIRECTORY', 'value' => null, 'text' => 'Directory'],
                    'currently_discoverable' => $place !== null, 'saved_at' => $savedAt];

                continue;
            }
            $summary = $summaries[(string) $favorite->target] ?? null;
            if ($summary === null) {
                continue;
            }
            $items[] = ['vendor_id' => $summary['id'], 'tier' => SupplierDiscoveryService::TIER_VERIFIED, 'name' => $summary['public_store_name'], 'logo_url' => $summary['logo_url'], 'score_label' => $summary['score_label'],
                'currently_discoverable' => isset($discoverable[$summary['id']]), 'saved_at' => $savedAt];
        }

        return ['items' => $items, 'meta' => ['current_page' => $favorites->currentPage(), 'last_page' => $favorites->lastPage(), 'total' => $favorites->total()]];
    }
}
