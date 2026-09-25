<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\StoreOperatingSchedule;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

final class PublicStoreProfileController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $input = $request->validate(['page' => ['sometimes', 'integer', 'between:1,2000']]);
        $page = (int) ($input['page'] ?? 1);
        $stores = DB::table('vendor_organizations as o')->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->where('o.store_activation_status', 'ACTIVE')->where('o.marketplace_discoverability_status', 'DISCOVERABLE')
            ->where('p.status', 'COMPLETED')
            ->whereRaw('(SELECT COUNT(*) FROM operating_hours h WHERE h.store_profile_id = p.id) = 7')
            ->whereRaw('NOT EXISTS (SELECT 1 FROM operating_hours h WHERE h.store_profile_id = p.id AND (h.day_of_week NOT BETWEEN 1 AND 7 OR NOT ((h.is_closed AND h.opens_at IS NULL AND h.closes_at IS NULL) OR (NOT h.is_closed AND h.opens_at IS NOT NULL AND h.closes_at IS NOT NULL AND h.closes_at > h.opens_at))))')
            ->orderBy('p.public_store_name')->orderBy('o.id')
            ->paginate(20, ['o.id', 'p.public_store_name', 'p.description'], 'page', $page);

        return ApiResponse::success($stores->items(), ['current_page' => $stores->currentPage(), 'last_page' => $stores->lastPage(), 'total' => $stores->total()]);
    }

    public function __invoke(string $storeId, StoreOperatingSchedule $schedule): JsonResponse
    {
        $store = DB::table('vendor_organizations as o')
            ->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->where('o.id', $storeId)->where('o.store_activation_status', 'ACTIVE')
            ->where('o.marketplace_discoverability_status', 'DISCOVERABLE')
            ->where('p.status', 'COMPLETED')
            ->first(['o.id', 'p.id as profile_id', 'p.public_store_name', 'p.description', 'p.public_email', 'p.public_phone']);
        if ($store === null) {
            return ApiResponse::error('STORE_NOT_FOUND', 'Store Profile is unavailable.', 404);
        }

        $weekly = $schedule->weekly((string) $store->profile_id);
        if (! $schedule->valid($weekly)) {
            return ApiResponse::error('STORE_NOT_FOUND', 'Store Profile is unavailable.', 404);
        }
        $localNow = Carbon::now('Asia/Manila');
        $today = $localNow->toDateString();
        $override = DB::table('store_operation_date_overrides')->where('store_profile_id', $store->profile_id)->where('specific_date', $today)->first();
        $effective = $override === null
            ? collect($weekly)->firstWhere('day_of_week', $localNow->isoWeekday())
            : ['day_of_week' => $localNow->isoWeekday(), 'status' => $override->is_closed ? 'CLOSED' : 'OPEN', 'opens_at' => $override->is_closed ? null : substr((string) $override->opens_at, 0, 5), 'closes_at' => $override->is_closed ? null : substr((string) $override->closes_at, 0, 5)];

        return ApiResponse::success([
            'id' => $store->id,
            'public_store_name' => $store->public_store_name,
            'description' => $store->description,
            'public_email' => $store->public_email,
            'public_phone' => $store->public_phone,
            'operating_schedule' => $weekly,
            'effective_today' => $effective,
            'effective_date' => $today,
            'effective_source' => $override === null ? 'WEEKLY' : 'DATE_OVERRIDE',
            'time_zone' => 'Asia/Manila',
        ]);
    }
}
