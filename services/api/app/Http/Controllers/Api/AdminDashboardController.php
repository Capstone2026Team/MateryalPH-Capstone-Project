<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\AdminDashboardService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class AdminDashboardController extends Controller
{
    public function summary(Request $request, AdminDashboardService $dashboard): JsonResponse
    {
        return ApiResponse::success($dashboard->summary($request));
    }

    public function audit(Request $request, AdminDashboardService $dashboard): JsonResponse
    {
        $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $result = $dashboard->audit($request);

        return ApiResponse::success($result['items'], $result['meta']);
    }
}
