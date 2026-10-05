<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Scores\BadgeService;
use App\Domain\Scores\ScoreInvestigationService;
use App\Domain\Scores\ScoreQueries;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Store Performance (Owner/Manager) and Score & Badge Monitoring (Admin). Admin commands exclude/restore a score source
 * order and suppress/lift a badge display; there is deliberately no command that sets a score or awards a badge.
 */
final class ScoreController extends Controller
{
    private const METRICS = ['ORDER_CONFIRMED', 'FULFILLMENT_DISPATCHED', 'ORDER_FULFILLED', 'ORDER_COMPLETED', 'VENDOR_NON_FULFILLMENT', 'VALIDATED_DEFECT_RETURN', 'ORDER_DEFECT', 'MISREPRESENTED_LISTING', 'INQUIRY'];

    public function __construct(private readonly ScoreQueries $queries, private readonly ScoreInvestigationService $investigation) {}

    public function vendorPerformance(Request $request): JsonResponse
    {
        return ApiResponse::success($this->queries->vendorPerformance($request));
    }

    public function adminIndex(Request $request): JsonResponse
    {
        $result = $this->queries->adminList($request, $request->validate(['q' => ['sometimes', 'string', 'max:120'], 'page' => ['sometimes', 'integer', 'between:1,500']]));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function adminShow(Request $request, string $vendorId): JsonResponse
    {
        return ApiResponse::success($this->queries->adminDetail($request, $vendorId, $request->validate(['metric' => ['sometimes', Rule::in(self::METRICS)], 'page' => ['sometimes', 'integer', 'between:1,500']])));
    }

    public function exclude(Request $request, string $vendorId): JsonResponse
    {
        $this->investigation->exclude($request, $vendorId, $request->validate(['order_id' => ['required', 'uuid'], 'reason_code' => ['required', Rule::in(ScoreInvestigationService::EXCLUSION_REASONS)],
            'note' => ['required', 'string', 'min:10', 'max:2000']]));

        return ApiResponse::success($this->queries->adminDetail($request, $vendorId, []), status: 201);
    }

    public function revokeExclusion(Request $request, string $exclusionId): JsonResponse
    {
        $this->investigation->revokeExclusion($request, $exclusionId, (string) $request->validate(['reason' => ['required', 'string', 'min:10', 'max:2000']])['reason']);

        return ApiResponse::success(['revoked' => true]);
    }

    public function suppress(Request $request, string $vendorId): JsonResponse
    {
        $this->investigation->suppress($request, $vendorId, $request->validate(['badge_code' => ['required', Rule::in(BadgeService::STORED)], 'reason_code' => ['required', Rule::in(ScoreInvestigationService::SUPPRESSION_REASONS)],
            'case_reference' => ['required', 'string', 'min:3', 'max:120'], 'note' => ['required', 'string', 'min:10', 'max:2000']]));

        return ApiResponse::success($this->queries->adminDetail($request, $vendorId, []), status: 201);
    }

    public function lift(Request $request, string $suppressionId): JsonResponse
    {
        $this->investigation->lift($request, $suppressionId, (string) $request->validate(['reason' => ['required', 'string', 'min:10', 'max:2000']])['reason']);

        return ApiResponse::success(['lifted' => true]);
    }
}
