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
            'sort' => ['sometimes', Rule::in(['submitted_asc', 'submitted_desc', 'location', 'oldest_pending'])],
            // Phase 16 operations filters on the same queue (no second approval engine).
            'setup_status' => ['sometimes', Rule::in(['NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'CHANGES_REQUIRED'])],
            'activation' => ['sometimes', Rule::in(['ACTIVE', 'NOT_ACTIVE', 'READY', 'NOT_READY', 'RESTRICTED', 'SUSPENDED'])],
            'discoverability' => ['sometimes', Rule::in(['DISCOVERABLE', 'NOT_DISCOVERABLE'])],
            'blocker' => ['sometimes', Rule::in(['MEDIA', 'HOURS', 'DELIVERY', 'AUTHORITY', 'TERMS', 'PROVIDER'])],
            'requirement_key' => ['sometimes', 'string', 'max:64', 'regex:/^[a-z0-9_]+$/'],
            'age_days' => ['sometimes', 'integer', 'between:1,365'],
            'expiry_days' => ['sometimes', 'integer', 'between:1,365'],
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
