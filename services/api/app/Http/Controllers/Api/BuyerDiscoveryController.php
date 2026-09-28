<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Geography\DirectorySupplierService;
use App\Domain\Geography\FavoriteSupplierService;
use App\Domain\Geography\RouteEstimateService;
use App\Domain\Geography\SupplierDiscoveryService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Buyer map/list discovery. Origins travel in request bodies (never query strings) so precise Buyer
 * coordinates stay out of URLs and access logs.
 */
final class BuyerDiscoveryController extends Controller
{
    public function search(Request $request, SupplierDiscoveryService $discovery): JsonResponse
    {
        $input = $request->validate($this->originRules() + [
            'include_verified' => ['sometimes', 'boolean'],
            'include_directory' => ['sometimes', 'boolean'],
            'favorites_only' => ['sometimes', 'boolean'],
            'supplier_type' => ['sometimes', 'nullable', Rule::in(['WHOLESALER_DISTRIBUTOR', 'RETAIL_HARDWARE_STORE', 'SPECIALIZED_SUPPLIER', 'OTHER'])],
            'category_id' => ['sometimes', 'nullable', 'uuid'],
            'page' => ['sometimes', 'integer', 'between:1,50'],
            'per_page' => ['sometimes', 'integer', 'between:1,'.SupplierDiscoveryService::MAX_PER_PAGE],
        ]);
        $result = $discovery->search($request, array_filter($input, static fn (mixed $value): bool => $value !== null));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function directorySupplier(string $supplierId, DirectorySupplierService $directory): JsonResponse
    {
        return ApiResponse::success($directory->details($supplierId));
    }

    public function route(Request $request, RouteEstimateService $routes): JsonResponse
    {
        $input = $request->validate($this->originRules() + [
            'tier' => ['required', Rule::in([SupplierDiscoveryService::TIER_VERIFIED, SupplierDiscoveryService::TIER_DIRECTORY])],
            'supplier_id' => ['required', 'uuid'],
            'request_version' => ['required', 'string', 'regex:/^[A-Za-z0-9_.:-]{1,64}$/'],
        ]);

        return ApiResponse::success($routes->estimate($request, array_filter($input, static fn (mixed $value): bool => $value !== null)));
    }

    public function favorites(Request $request, FavoriteSupplierService $favorites): JsonResponse
    {
        $input = $request->validate(['page' => ['sometimes', 'integer', 'between:1,500']]);
        $result = $favorites->list($request, (int) ($input['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function addFavorite(Request $request, string $vendorId, FavoriteSupplierService $favorites): JsonResponse
    {
        $favorites->add($request, $vendorId);

        return ApiResponse::success(['vendor_id' => $vendorId, 'is_favorite' => true]);
    }

    public function removeFavorite(Request $request, string $vendorId, FavoriteSupplierService $favorites): JsonResponse
    {
        $favorites->remove($request, $vendorId);

        return ApiResponse::success(['vendor_id' => $vendorId, 'is_favorite' => false]);
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
