<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Vendors\PublicStoreHours;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
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
            ->orderBy('p.public_store_name')->orderBy('o.id')
            ->paginate(20, ['o.id', 'p.public_store_name', 'p.description', 'p.vacation_mode'], 'page', $page);

        return ApiResponse::success($stores->items(), ['current_page' => $stores->currentPage(), 'last_page' => $stores->lastPage(), 'total' => $stores->total()]);
    }

    /**
     * Public Store Profile built from the shared public projection so the name, media, contacts and address
     * match map markers, list rows and the preview sheet. Saved hours are descriptive: an unusable schedule
     * shows Hours Unavailable instead of hiding the store or fabricating hours.
     */
    public function __invoke(string $storeId, PublicStoreHours $hours, PublicVendorProjection $projection): JsonResponse
    {
        $store = DB::table('vendor_organizations as o')
            ->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->where('o.id', $storeId)->where('o.store_activation_status', 'ACTIVE')
            ->where('o.marketplace_discoverability_status', 'DISCOVERABLE')
            ->where('p.status', 'COMPLETED')
            ->first(['o.id', 'p.id as profile_id']);
        $summary = $store === null ? null : ($projection->summaries([(string) $store->id])[(string) $store->id] ?? null);
        if ($store === null || $summary === null) {
            return ApiResponse::error('STORE_NOT_FOUND', 'Store Profile is unavailable.', 404);
        }

        $schedule = $hours->describe((string) $store->profile_id);
        $valid = $schedule['status'] === 'AVAILABLE';
        $today = $schedule['today'];
        $effective = $today === null ? null : ['day_of_week' => $today['day_of_week'], 'status' => $today['status'], 'opens_at' => $today['opens_at'], 'closes_at' => $today['closes_at']];

        return ApiResponse::success([
            'id' => $summary['id'],
            'public_store_name' => $summary['public_store_name'],
            'description' => $summary['description'],
            'public_email' => $summary['public_email'],
            'public_phone' => $summary['public_phone'],
            'vacation_mode' => $summary['vacation_mode'],
            'logo_url' => $summary['logo_url'],
            'banner_url' => $summary['banner_url'],
            'address' => $summary['address'],
            'supplier_type' => $summary['supplier_type'],
            'niches' => $summary['niches'],
            'fulfillment_method' => $summary['fulfillment_method'],
            'score_label' => $summary['score_label'],
            'hours_status' => $schedule['status'],
            'operating_schedule' => $schedule['weekly'],
            'effective_today' => $effective,
            'effective_date' => substr((string) $schedule['as_of'], 0, 10),
            'effective_source' => ($today['source'] ?? 'WEEKLY') === 'DATE_OVERRIDE' ? 'DATE_OVERRIDE' : 'WEEKLY',
            'time_zone' => PublicStoreHours::TIME_ZONE,
            // Today plus the next six dates with any dated override already applied; explicit Closed days kept.
            'week' => $schedule['week'],
            'open_now' => $schedule['open_now'],
            'all_closed' => $schedule['all_closed'],
            'hours_as_of' => $schedule['as_of'],
            'hours_notice' => 'Hours are informational only. They do not guarantee staff availability, stock or response time, and they do not change order deadlines.',
        ] + ($valid ? [] : ['hours_unavailable_reason' => 'SCHEDULE_NOT_AVAILABLE']));
    }
}
