<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\VendorOnboardingService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class XenditAccountVerificationWebhookController extends Controller
{
    public function __invoke(Request $request, VendorOnboardingService $onboarding): JsonResponse
    {
        return ApiResponse::success($onboarding->handleXenditWebhook($request->json()->all(), $request->header('x-callback-token')), status: 202);
    }
}
