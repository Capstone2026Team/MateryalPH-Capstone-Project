<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Procurement\ExploreSummaryService;
use App\Domain\Procurement\ListingDetailService;
use App\Domain\Procurement\MarketplaceSearchService;
use App\Domain\Procurement\RankingPreferenceService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Buyer Item-Based discovery: Explore dashboard, marketplace search, Product Details and ranking preferences.
 * Origins travel in request bodies (never query strings) so precise Buyer coordinates stay out of URLs.
 */
final class BuyerProcurementController extends Controller
{
    public function explore(Request $request, ExploreSummaryService $explore): JsonResponse
    {
        $input = $request->validate($this->originRules());

        return ApiResponse::success($explore->summary($request, $this->present($input)));
    }

    public function search(Request $request, MarketplaceSearchService $search): JsonResponse
    {
        $input = $request->validate($this->originRules() + [
            'query' => ['sometimes', 'nullable', 'string', 'max:100'],
            'sort' => ['sometimes', 'nullable', Rule::in(MarketplaceSearchService::SORTS)],
            'category_id' => ['sometimes', 'nullable', 'uuid'],
            'brand' => ['sometimes', 'nullable', 'string', 'max:80'],
            'variant' => ['sometimes', 'nullable', 'string', 'max:80'],
            'availability' => ['sometimes', 'nullable', Rule::in(['ANY', 'IN_STOCK'])],
            'fulfillment' => ['sometimes', 'nullable', Rule::in(['ANY', 'DELIVERY', 'PICKUP'])],
            'favorites_only' => ['sometimes', 'boolean'],
            'compliance' => ['sometimes', 'nullable', Rule::in(['ANY', 'PS_ICC_VERIFIED'])],
            'min_price_centavos' => ['sometimes', 'nullable', 'integer', 'min:0', 'max:100000000000'],
            'max_price_centavos' => ['sometimes', 'nullable', 'integer', 'min:0', 'max:100000000000', 'gte:min_price_centavos'],
            'vendor_id' => ['sometimes', 'nullable', 'uuid'],
            'cursor' => ['sometimes', 'nullable', 'string', 'max:1024'],
            'per_page' => ['sometimes', 'integer', 'between:1,'.MarketplaceSearchService::MAX_PER_PAGE],
        ]);
        $result = $search->search($request, $this->present($input));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function listing(Request $request, string $listingId, ListingDetailService $details): JsonResponse
    {
        $input = $request->validate($this->originRules());

        return ApiResponse::success($details->show($request, $listingId, $this->present($input)));
    }

    public function preferences(Request $request, RankingPreferenceService $preferences): JsonResponse
    {
        return ApiResponse::success($preferences->show($request));
    }

    public function savePreferences(Request $request, RankingPreferenceService $preferences): JsonResponse
    {
        $input = $request->validate([
            'weights' => ['required', 'array'],
            'version' => ['required', 'integer', 'min:0'],
        ]);

        return ApiResponse::success($preferences->save($request, $input['weights'], (int) $input['version']));
    }

    public function resetPreferences(Request $request, RankingPreferenceService $preferences): JsonResponse
    {
        $input = $request->validate(['version' => ['required', 'integer', 'min:0']]);

        return ApiResponse::success($preferences->reset($request, (int) $input['version']));
    }

    /**
     * Drops nulls and the neutral ANY filter values so services only see active filters.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private function present(array $input): array
    {
        return array_filter($input, static fn (mixed $value): bool => $value !== null && $value !== 'ANY');
    }

    /** @return array<string, list<mixed>> */
    private function originRules(): array
    {
        return [
            'location_id' => ['sometimes', 'nullable', 'uuid'],
            'latitude' => ['sometimes', 'required_with:longitude', 'numeric', 'between:-90,90'],
            'longitude' => ['sometimes', 'required_with:latitude', 'numeric', 'between:-180,180'],
            'origin_source' => ['sometimes', Rule::in(['DEVICE', 'MAP_PIN', 'SEARCH'])],
            // The allowlist itself is enforced by RadiusPolicy so every rejection carries RADIUS_UNSUPPORTED.
            'radius_km' => ['sometimes', 'integer'],
        ];
    }
}
