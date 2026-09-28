<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Catalog\EligibleOfferQuery;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * Map and list discovery. One server response feeds both surfaces with one result identifier and one order:
 * straight-line distance, then Verified Vendors before Directory Suppliers, then the stable result id.
 * Membership is ST_DWithin on geography in metres with the boundary included; route distance and saved hours
 * never affect membership or order. Tier 2 membership is the shared public projection; Tier 1 is the
 * attributed, cache-bounded Google directory. Radius expansion is only suggested, never applied.
 */
final class SupplierDiscoveryService
{
    public const MAX_PER_PAGE = 100;

    public const TIER_VERIFIED = 'VERIFIED_VENDOR';

    public const TIER_DIRECTORY = 'DIRECTORY_SUPPLIER';

    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly PublicVendorProjection $vendors,
        private readonly DirectorySupplierService $directory,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function search(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $scope = $this->scopes->forBuyer($buyerId, $input);
        $includeVerified = (bool) ($input['include_verified'] ?? true);
        $tierSpecific = (bool) ($input['favorites_only'] ?? false) || isset($input['supplier_type']) || isset($input['category_id']);
        $includeDirectory = (bool) ($input['include_directory'] ?? true) && ! $tierSpecific;

        $verified = $includeVerified ? $this->verified($scope, $buyerId, $input)->get()->all() : [];
        $eligibleVerifiedCount = $this->withinScope($this->vendors->members(), $scope)->count();
        $directory = $includeDirectory ? $this->directory->within($scope) : ['rows' => [], 'status' => $tierSpecific ? 'FILTERED_OUT' : 'HIDDEN', 'as_of' => null];

        $merged = [];
        foreach ($verified as $row) {
            $merged[] = ['tier' => self::TIER_VERIFIED, 'id' => (string) $row->id, 'distance' => (float) $row->distance_meters, 'row' => $row];
        }
        foreach ($directory['rows'] as $row) {
            $merged[] = ['tier' => self::TIER_DIRECTORY, 'id' => (string) $row->id, 'distance' => (float) $row->distance_meters, 'row' => $row];
        }
        usort($merged, static fn (array $a, array $b): int => [$a['distance'], $a['tier'] === self::TIER_VERIFIED ? 0 : 1, $a['id']] <=> [$b['distance'], $b['tier'] === self::TIER_VERIFIED ? 0 : 1, $b['id']]);

        $perPage = max(1, min(self::MAX_PER_PAGE, (int) ($input['per_page'] ?? self::MAX_PER_PAGE)));
        $page = max(1, (int) ($input['page'] ?? 1));
        $slice = array_slice($merged, ($page - 1) * $perPage, $perPage);
        $summaries = $this->vendors->summaries(array_values(array_map(static fn (array $item): string => $item['id'], array_filter($slice, static fn (array $item): bool => $item['tier'] === self::TIER_VERIFIED))));
        $favorites = DB::table('favorite_vendors')->where('buyer_profile_id', $buyerId)->pluck('vendor_organization_id')->map(static fn (mixed $id): string => (string) $id)->flip()->all();

        $items = [];
        foreach ($slice as $offset => $item) {
            $rank = ($page - 1) * $perPage + $offset + 1;
            $items[] = $item['tier'] === self::TIER_VERIFIED
                ? $this->verifiedItem($item, $summaries[$item['id']] ?? null, isset($favorites[$item['id']]), $rank)
                : $this->directoryItem($item, $rank);
        }
        $items = array_values(array_filter($items));
        $next = $eligibleVerifiedCount < RadiusPolicy::EXPANSION_THRESHOLD ? RadiusPolicy::next((int) $scope->radiusKm) : null;

        return ['items' => $items, 'meta' => [
            'scope' => $scope->summary(),
            'current_as_of' => now()->toIso8601String(),
            'eligibility_version' => EligibleOfferQuery::VERSION,
            'projection_version' => PublicVendorProjection::VERSION,
            'counts' => [
                'verified_vendors' => count($verified),
                'directory_suppliers' => count($directory['rows']),
                'favorite_suppliers' => count(array_filter($verified, static fn (object $row): bool => isset($favorites[(string) $row->id]))),
            ],
            'directory' => ['status' => $directory['status'], 'as_of' => $directory['as_of'], 'attribution' => DirectorySupplierService::ATTRIBUTION,
                'coverage_note' => 'Directory Suppliers come from Google Maps and are not a complete list of suppliers.'],
            'expansion' => [
                'eligible_verified_count' => $eligibleVerifiedCount,
                'suggested_radius_km' => $next,
                'at_maximum' => (int) $scope->radiusKm === max(RadiusPolicy::ALLOWED_KM),
                'reason' => $next === null ? null : 'FEWER_THAN_THREE_VERIFIED_VENDORS',
                'requires_confirmation' => true,
            ],
            'page' => $page, 'per_page' => $perPage, 'total' => count($merged), 'has_more' => $page * $perPage < count($merged),
        ]];
    }

    /** @param array<string, mixed> $input */
    private function verified(GeographyScope $scope, string $buyerId, array $input): Builder
    {
        $query = $this->withinScope($this->vendors->members(), $scope)
            ->selectRaw('o.id, av.latitude, av.longitude, ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography) AS distance_meters', [$scope->longitude, $scope->latitude]);
        if ((bool) ($input['favorites_only'] ?? false)) {
            $query->whereExists(fn (Builder $favorite) => $favorite->selectRaw('1')->from('favorite_vendors as f')->whereColumn('f.vendor_organization_id', 'o.id')->where('f.buyer_profile_id', $buyerId));
        }
        if (isset($input['supplier_type'])) {
            $query->whereExists(fn (Builder $classification) => $classification->selectRaw('1')->from('vendor_classifications as c')->whereColumn('c.vendor_organization_id', 'o.id')->where('c.supplier_type', $input['supplier_type']));
        }
        if (isset($input['category_id'])) {
            $query = $this->vendors->inCategory($query, (string) $input['category_id']);
        }

        return $query;
    }

    private function withinScope(Builder $members, GeographyScope $scope): Builder
    {
        return $members->whereRaw('ST_DWithin(av.location, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)', [$scope->longitude, $scope->latitude, $scope->membershipMeters()]);
    }

    /**
     * @param  array{tier: string, id: string, distance: float, row: object}  $item
     * @param  array<string, mixed>|null  $summary
     * @return array<string, mixed>|null
     */
    private function verifiedItem(array $item, ?array $summary, bool $favorite, int $rank): ?array
    {
        if ($summary === null) {
            return null;
        }
        $delivery = $summary['delivery_maximum_km'];

        return [
            'result_id' => $item['id'], 'tier' => self::TIER_VERIFIED, 'tier_label' => 'Verified Vendor', 'rank' => $rank,
            'name' => $summary['public_store_name'],
            'marker' => ['latitude' => round((float) $item['row']->latitude, 5), 'longitude' => round((float) $item['row']->longitude, 5)],
            'distance_meters' => (int) round($item['distance']),
            'score_label' => $summary['score_label'],
            'is_favorite' => $favorite,
            'vendor' => [
                'logo_url' => $summary['logo_url'],
                'supplier_type' => $summary['supplier_type'],
                'niches' => array_slice($summary['niches'], 0, 6),
                'fulfillment_method' => $summary['fulfillment_method'],
                'vacation_mode' => $summary['vacation_mode'],
                'public_phone' => $summary['public_phone'],
                'address' => $summary['address'],
                'open_status' => $summary['open_status'],
                'serviceability' => [
                    'pickup_available' => in_array($summary['fulfillment_method'], ['SELF_PICKUP', 'BOTH'], true),
                    'delivery' => $delivery === null ? 'NOT_OFFERED' : ($item['distance'] <= $delivery * 1000 ? 'WITHIN_STATED_AREA' : 'OUTSIDE_STATED_AREA'),
                    'delivery_maximum_km' => $delivery,
                    'basis' => 'STRAIGHT_LINE_ADVISORY',
                ],
            ],
            'directory' => null,
        ];
    }

    /**
     * @param  array{tier: string, id: string, distance: float, row: object}  $item
     * @return array<string, mixed>
     */
    private function directoryItem(array $item, int $rank): array
    {
        $row = $item['row'];

        return [
            'result_id' => $item['id'], 'tier' => self::TIER_DIRECTORY, 'tier_label' => 'Directory Supplier', 'rank' => $rank,
            'name' => (string) $row->name,
            'marker' => ['latitude' => round((float) $row->latitude, 5), 'longitude' => round((float) $row->longitude, 5)],
            'distance_meters' => (int) round($item['distance']),
            'score_label' => ['kind' => 'DIRECTORY', 'value' => null, 'text' => 'Directory'],
            'is_favorite' => false,
            'vendor' => null,
            'directory' => ['formatted_address' => $row->formatted_address, 'primary_type' => $row->primary_type, 'source' => 'GOOGLE',
                'refreshed_at' => Carbon::parse((string) $row->refreshed_at)->toIso8601String()],
        ];
    }
}
