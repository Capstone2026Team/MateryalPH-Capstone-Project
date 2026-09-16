<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\AddressProviderUnavailable;
use App\Domain\Vendors\VendorOnboardingService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Vendor\VendorAddressGeocodeRequest;
use App\Http\Requests\Vendor\VendorDocumentUploadRequest;
use App\Http\Requests\Vendor\VendorMediaUploadRequest;
use App\Http\Requests\Vendor\VendorPaymentConnectionRequest;
use App\Http\Requests\Vendor\VendorSetupCompleteRequest;
use App\Http\Requests\Vendor\VendorSetupDraftRequest;
use App\Http\Requests\Vendor\VendorStoreEmailRequest;
use App\Http\Requests\Vendor\VendorVerificationDraftRequest;
use App\Http\Requests\Vendor\VendorVerificationSubmitRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;

final class VendorOnboardingController extends Controller
{
    public function snapshot(Request $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->snapshot($request));
    }

    public function draftVerification(VendorVerificationDraftRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->draftVerification($request, $request->validated()));
    }

    public function submitVerification(VendorVerificationSubmitRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->submitVerification($request, $request->validated()), status: 202);
    }

    public function draftSetup(VendorSetupDraftRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->draftSetup($request, $request->validated()));
    }

    public function completeSetup(VendorSetupCompleteRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->completeSetup($request, $request->validated()), status: 202);
    }

    public function dismissWelcome(Request $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->dismissWelcome($request));
    }

    public function geocode(VendorAddressGeocodeRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        try {
            $result = $onboarding->geocode((float) $request->validated('latitude'), (float) $request->validated('longitude'));
        } catch (AddressProviderUnavailable) {
            $result = ['available' => false, 'fallback_required' => true, 'message' => 'Map address lookup is unavailable. Complete the structured address fields manually.'];
        }

        return ApiResponse::success($result);
    }

    public function requestStoreEmailVerification(VendorStoreEmailRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->requestStoreEmailVerification($request, (string) $request->validated('email')), status: 202);
    }

    public function confirmStoreEmailVerification(VendorStoreEmailRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->confirmStoreEmailVerification($request, (string) $request->validated('email'), (string) $request->validated('code')));
    }

    public function uploadDocument(VendorDocumentUploadRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        $file = $request->file('file');
        if (! $file instanceof UploadedFile) {
            return ApiResponse::error('FILE_VALIDATION_FAILED', 'A supported evidence file is required.', 422);
        }

        return ApiResponse::success($onboarding->uploadDocument($request, $file, (string) $request->validated('requirement_key'), (array) ($request->validated('metadata') ?? [])), status: 201);
    }

    public function uploadMedia(VendorMediaUploadRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        $file = $request->file('file');
        if (! $file instanceof UploadedFile) {
            return ApiResponse::error('FILE_VALIDATION_FAILED', 'A supported store-media file is required.', 422);
        }

        return ApiResponse::success($onboarding->uploadMedia($request, $file, (string) $request->validated('kind'), $request->validated('alt_text')), status: 201);
    }

    public function signedFile(Request $request, string $fileId, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->signedFile($request, $fileId));
    }

    public function streamFile(Request $request, string $fileId, VendorOnboardingService $onboarding): mixed
    {
        return $onboarding->streamFile($request, $fileId);
    }

    public function capturePaymentConnection(VendorPaymentConnectionRequest $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->capturePaymentConnection($request, $request->validated()));
    }

    public function reconcilePaymentConnection(Request $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->reconcilePaymentConnection($request));
    }

    public function activate(Request $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->activate($request), status: 202);
    }
}
