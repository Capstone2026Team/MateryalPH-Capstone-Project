<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Procurement\CartService;
use App\Domain\Procurement\CheckoutPreviewService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** Buyer cart and checkout preview. Nothing here creates an order, hold or reservation. */
final class BuyerCartController extends Controller
{
    public function show(Request $request, CartService $carts): JsonResponse
    {
        return ApiResponse::success($carts->view($request));
    }

    public function add(Request $request, CartService $carts): JsonResponse
    {
        $input = $request->validate([
            'listing_variant_id' => ['required', 'uuid'],
            'expected_price_version_id' => ['required', 'uuid'],
            'quantity' => ['required'],
            'fulfillment_method' => ['sometimes', 'nullable', Rule::in(['DELIVERY', 'PICKUP'])],
            'location_id' => ['sometimes', 'nullable', 'uuid'],
            'latitude' => ['sometimes', 'required_with:longitude', 'numeric', 'between:-90,90'],
            'longitude' => ['sometimes', 'required_with:latitude', 'numeric', 'between:-180,180'],
            'origin_source' => ['sometimes', Rule::in(['DEVICE', 'MAP_PIN', 'SEARCH'])],
            'radius_km' => ['sometimes', 'integer'],
        ]);

        return ApiResponse::success($carts->addItem($request, array_filter($input, static fn (mixed $value): bool => $value !== null)));
    }

    public function update(Request $request, string $itemId, CartService $carts): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'quantity' => ['sometimes'],
            'saved_for_later' => ['sometimes', 'boolean'],
            'accept_current_price' => ['sometimes', 'boolean'],
        ]);

        return ApiResponse::success($carts->updateItem($request, $itemId, $input));
    }

    public function remove(Request $request, string $itemId, CartService $carts): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($carts->removeItem($request, $itemId, (int) $input['lock_version']));
    }

    public function fulfillment(Request $request, string $vendorId, CartService $carts): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'fulfillment_method' => ['required', Rule::in(['DELIVERY', 'PICKUP'])],
        ]);

        return ApiResponse::success($carts->setFulfillment($request, $vendorId, $input));
    }

    public function destination(Request $request, CartService $carts): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'intended_location_id' => ['present', 'nullable', 'uuid'],
            'heavy_vehicle_restriction' => ['required', Rule::in(['UNANSWERED', 'NO', 'YES'])],
            'alternate_drop_off_location_id' => ['sometimes', 'nullable', 'uuid'],
            'access_instructions' => ['sometimes', 'nullable', 'string', 'max:1000'],
        ]);

        return ApiResponse::success($carts->setDestination($request, $input));
    }

    public function preview(Request $request, CheckoutPreviewService $preview): JsonResponse
    {
        $input = $request->validate(['request_version' => ['sometimes', 'nullable', 'string', 'regex:/^[A-Za-z0-9_.:-]{1,64}$/']]);

        return ApiResponse::success($preview->preview($request, $input));
    }
}
