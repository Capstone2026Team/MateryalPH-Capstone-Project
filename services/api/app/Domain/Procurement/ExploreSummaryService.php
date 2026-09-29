<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScope;
use App\Domain\Geography\GeographyScopeResolver;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * MAT-01/MAT-02 Explore dashboard. Nearby Verified Vendors and Available Products come from ONE statement
 * over the current eligible-offer relation (GROUPING SETS gives the scope total and each category from the
 * same snapshot), so the two cards and the category counts can never disagree. Counts are distinct Vendor
 * organizations and distinct Vendor listings with at least one available variant — never variants, canonical
 * materials or registered stores — and are scoped to all categories at the selected location and radius.
 * A short-lived cached value keeps its own capture time and is invalidated by eligibility changes.
 */
final class ExploreSummaryService
{
    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly ScopedOfferQuery $offers,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function summary(Request $request, array $input): array
    {
        $scope = $this->scopes->forBuyer($this->profiles->idFor($request), $input);
        $snapshot = $this->counts($scope);
        $categories = DB::table('material_categories')->where('active', true)->orderBy('sort_order')->orderBy('name')->get(['id', 'code', 'name']);
        $test = config('finance.mode') !== 'LIVE';

        return [
            'scope' => $scope->summary(),
            'count_scope' => 'ALL_CATEGORIES_AT_LOCATION_RADIUS',
            'scope_label' => sprintf('All categories within %d km of %s', (int) $scope->radiusKm, $scope->originLabel ?? 'the selected location'),
            'current_as_of' => $snapshot['current_as_of'],
            'eligibility_version' => EligibleOfferQuery::VERSION,
            'counts' => ['verified_vendors' => $snapshot['vendors'], 'vendor_listings' => $snapshot['listings']],
            'labels' => ['verified_vendors' => 'Nearby Verified Vendors', 'vendor_listings' => 'Available Products', 'vendor_listings_unit' => 'Vendor listings'],
            'categories' => $categories->map(static fn (object $category): array => ['id' => (string) $category->id, 'code' => (string) $category->code, 'name' => (string) $category->name,
                'vendor_listings' => $snapshot['categories'][(string) $category->id] ?? 0])->all(),
            // Materials Analytics ships end to end in Phase 14; until then the entry point is explicitly unavailable.
            'materials_analytics' => ['enabled' => false, 'status' => 'NOT_YET_AVAILABLE', 'message' => 'Materials Analytics is not available yet.'],
            'dataset' => ['kind' => $test ? 'TEST' : 'LIVE', 'label' => $test ? 'DEMO — Simulated Marketplace Data' : null],
        ];
    }

    /** @return array{vendors: int, listings: int, categories: array<string, int>, current_as_of: string} */
    private function counts(GeographyScope $scope): array
    {
        $key = 'explore:counts:'.EligibleOfferQuery::generation().':'.hash('sha256', $scope->originVersion.'|'.$scope->radiusKm);

        return Cache::remember($key, EligibleOfferQuery::COUNT_TTL_SECONDS, function () use ($scope): array {
            $rows = $this->offers->within($scope)
                ->selectRaw('l.material_category_id AS category_id, GROUPING(l.material_category_id) AS is_total, COUNT(DISTINCT l.vendor_organization_id) AS vendors, COUNT(DISTINCT l.id) AS listings')
                ->groupByRaw('GROUPING SETS ((), (l.material_category_id))')->get();
            $result = ['vendors' => 0, 'listings' => 0, 'categories' => [], 'current_as_of' => now()->toIso8601String()];
            foreach ($rows as $row) {
                if ((int) $row->is_total === 1) {
                    $result['vendors'] = (int) $row->vendors;
                    $result['listings'] = (int) $row->listings;
                } elseif ($row->category_id !== null) {
                    $result['categories'][(string) $row->category_id] = (int) $row->listings;
                }
            }

            return $result;
        });
    }
}
