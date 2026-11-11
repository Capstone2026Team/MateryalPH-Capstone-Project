<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Identity\TutorialProgress;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\TutorialRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class TutorialController extends Controller
{
    public function index(Request $request, TutorialProgress $progress): JsonResponse
    {
        return ApiResponse::success($progress->read($request->user()));
    }

    public function update(TutorialRequest $request, string $tutorialKey, TutorialProgress $progress): JsonResponse
    {
        return ApiResponse::success($progress->acknowledge($request, $tutorialKey, $request->validated('status')));
    }
}
