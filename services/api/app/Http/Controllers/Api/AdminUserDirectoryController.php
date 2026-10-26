<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Reviews\ReviewRules;
use App\Domain\UserManagement\UserDirectoryService as Directory;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Support\PortalDateRange;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Admin Buyer and Vendor user directories (Buyer Management and Vendor Management → Users). Read-only: each action
 * validates transport and hands one query to the directory service, which authorizes user_directory.view itself.
 */
final class AdminUserDirectoryController extends Controller
{
    public function buyers(Request $request, Directory $directory): JsonResponse
    {
        $filters = $request->validate([
            'q' => ['sometimes', 'string', 'min:2', 'max:120'], 'status' => ['sometimes', Rule::in(Directory::BUYER_STATUSES)], 'buyer_type' => ['sometimes', Rule::in(['INDIVIDUAL', 'BUSINESS'])],
            'sort' => ['sometimes', Rule::in(Directory::SORTS)], 'page' => ['sometimes', 'integer', 'between:1,1000'],
        ] + PortalDateRange::rules($request));
        $result = $directory->buyers($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function buyer(Request $request, string $buyerId, Directory $directory): JsonResponse
    {
        return ApiResponse::success($directory->buyer($request, $buyerId));
    }

    public function buyerPhoto(Request $request, string $buyerId, Directory $directory): StreamedResponse
    {
        return $directory->buyerPhoto($request, $buyerId);
    }

    public function buyerReviews(Request $request, string $buyerId, Directory $directory): JsonResponse
    {
        $filters = $request->validate(['direction' => ['sometimes', Rule::in(['RECEIVED', 'WRITTEN'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $directory->buyerReviews($request, $buyerId, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendors(Request $request, Directory $directory): JsonResponse
    {
        $filters = $request->validate([
            'q' => ['sometimes', 'string', 'min:2', 'max:120'], 'status' => ['sometimes', Rule::in(Directory::VENDOR_ACTIVATION)], 'verification' => ['sometimes', Rule::in(Directory::VENDOR_VERIFICATION)],
            'discoverability' => ['sometimes', Rule::in(['DISCOVERABLE', 'NOT_DISCOVERABLE'])], 'sort' => ['sometimes', Rule::in(Directory::SORTS)], 'page' => ['sometimes', 'integer', 'between:1,1000'],
        ] + PortalDateRange::rules($request));
        $result = $directory->vendors($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendor(Request $request, string $vendorId, Directory $directory): JsonResponse
    {
        return ApiResponse::success($directory->vendor($request, $vendorId));
    }

    public function vendorReviews(Request $request, string $vendorId, Directory $directory): JsonResponse
    {
        $filters = $request->validate(['type' => ['sometimes', Rule::in([ReviewRules::VENDOR, ReviewRules::PRODUCT])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $directory->vendorReviews($request, $vendorId, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendorListings(Request $request, string $vendorId, Directory $directory): JsonResponse
    {
        $filters = $request->validate(['q' => ['sometimes', 'string', 'min:2', 'max:120'], 'status' => ['sometimes', 'string', 'regex:/^[A-Z_]{3,64}$/'], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $directory->vendorListings($request, $vendorId, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }
}
