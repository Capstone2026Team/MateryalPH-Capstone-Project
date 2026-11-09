<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Projects\ProjectArchives;
use App\Domain\Projects\ProjectService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class BuyerProjectArchiveController extends Controller
{
    public function index(Request $r, ProjectArchives $archives): JsonResponse
    {
        $input = $r->validate(['type' => ['required', 'in:PROJECT,WORK_PACKAGE'], 'page' => ['sometimes', 'integer', 'between:1,10000']]);

        return ApiResponse::success($archives->index($r, $input['type']));
    }

    public function change(Request $r, string $itemId, string $kind, string $action, ProjectArchives $archives): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $archives->change($r, $itemId, $kind === 'PROJECT', $action, $input['lock_version']);

        return ApiResponse::success(['id' => $itemId]);
    }

    /** Reuse the existing sourcing screen/algorithm, including failed-member coverage for groups. */
    public function rescan(Request $r, string $orderId, ProjectService $projects): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $order = DB::table('orders')->where('id', $orderId)->where('buyer_profile_id', app(BuyerProfiles::class)->idFor($r))->first();
        if ($order === null || $order->work_package_id === null) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This project order is unavailable.', 404);
        }
        $id = DB::transaction(function () use ($r, $order, $input, $projects): string {
            $w = $projects->package($r, $order->work_package_id, true);
            $current = DB::table('orders')->where('id', $order->id)->lockForUpdate()->first();
            ProjectService::version($current, $input['lock_version']);
            if ($current->order_state !== 'CANCELLED' || $w->current_version_id !== $current->work_package_version_id
                || in_array($w->status, ['DRAFT', 'CANCELLED', 'COMPLETED'], true)) {
                throw new AuthenticationException('ORDER_RESCAN_UNAVAILABLE', 'Only a cancelled order with the same active Work Package requirements can be rescanned.', 409);
            }
            if ($w->selected_arrangement_id === null && ProjectArchives::ongoing($w->project_id, $w->id)) {
                throw new AuthenticationException('WORK_PACKAGE_ALREADY_ASSIGNED', 'This Work Package already has an ongoing replacement order.', 409);
            }

            return $w->id;
        }, 3);

        return ApiResponse::success($projects->packageShow($r, $id));
    }
}
