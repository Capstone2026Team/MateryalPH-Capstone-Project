<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\AdminVendorVerificationService;
use App\Domain\Vendors\VendorOnboardingService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\VendorRestrictionRequest;
use App\Http\Requests\Admin\VendorVerificationDecisionRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

final class AdminVendorVerificationController extends Controller
{
    public function queue(Request $request, AdminVendorVerificationService $verification): JsonResponse
    {
        $filters = $request->validate([
            'status' => ['sometimes', 'string', 'max:32'],
            'business_type' => ['sometimes', 'string', 'max:32'],
            'page' => ['sometimes', 'integer', 'min:1'],
            'region_code' => ['sometimes', 'string', 'max:16'],
            'submitted_from' => ['sometimes', 'date_format:Y-m-d'],
            'submitted_to' => ['sometimes', 'date_format:Y-m-d', ...($request->filled('submitted_from') ? ['after_or_equal:submitted_from'] : [])],
            'sort' => ['sometimes', Rule::in(['submitted_asc', 'submitted_desc', 'location'])],
        ]);
        $result = $verification->queue($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function detail(Request $request, string $organizationId, AdminVendorVerificationService $verification): JsonResponse
    {
        return ApiResponse::success($verification->detail($request, $organizationId));
    }

    public function decide(VendorVerificationDecisionRequest $request, string $organizationId, string $requirementKey, AdminVendorVerificationService $verification): JsonResponse
    {
        return ApiResponse::success($verification->decide($request, $organizationId, $requirementKey, $request->validated()));
    }

    public function signedFile(Request $request, string $fileId, AdminVendorVerificationService $verification): JsonResponse
    {
        return ApiResponse::success($verification->download($request, $fileId));
    }

    public function restrict(VendorRestrictionRequest $request, string $organizationId, VendorOnboardingService $onboarding): JsonResponse
    {
        $onboarding->restrict($request, $organizationId, (string) $request->validated('reason'));

        return ApiResponse::success(['restricted' => true]);
    }

    public function restore(VendorRestrictionRequest $request, string $organizationId, VendorOnboardingService $onboarding): JsonResponse
    {
        $onboarding->restore($request, $organizationId, (string) $request->validated('reason'));

        return ApiResponse::success(['restored' => true]);
    }
}
