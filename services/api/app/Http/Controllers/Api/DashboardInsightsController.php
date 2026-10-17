<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Analytics\Dashboard\AdminDashboardInsights;
use App\Domain\Analytics\Dashboard\VendorDashboardInsights;
use App\Domain\Identity\AuthenticationException;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Support\PortalDateRange;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Read-only dashboard insights for the Vendor and Admin portals. The prefix fixes the audience and transport; the domain
 * service authorizes every section again and returns a section as null when the role holds no grant for it. Unknown query
 * parameters are rejected so no request can ask for a grouping or an identifier the dashboard does not offer.
 */
final class DashboardInsightsController extends Controller
{
    public function vendor(Request $request, VendorDashboardInsights $insights): JsonResponse
    {
        $this->only($request, ['days', 'from', 'to']);
        $input = $request->validate(['days' => ['sometimes', 'integer', Rule::in(VendorDashboardInsights::PERIODS)]] + PortalDateRange::rules($request));

        return ApiResponse::success($insights->build($request, isset($input['days']) ? (int) $input['days'] : null, $input));
    }

    public function admin(Request $request, AdminDashboardInsights $insights): JsonResponse
    {
        $this->only($request, ['days', 'dataset', 'area', 'from', 'to']);
        $input = $request->validate([
            'days' => ['sometimes', 'integer', Rule::in(AdminDashboardInsights::PERIODS)],
            'dataset' => ['sometimes', Rule::in(['TEST', 'DEMO'])],
            'area' => ['sometimes', 'nullable', 'string', 'regex:/^[0-9]{10}$/'],
        ] + PortalDateRange::rules($request));

        return ApiResponse::success($insights->build($request, $input));
    }

    /** @param list<string> $allowed */
    private function only(Request $request, array $allowed): void
    {
        $unknown = array_diff(array_keys($request->query()), $allowed);
        if ($unknown !== []) {
            throw new AuthenticationException('DASHBOARD_FILTER_UNSUPPORTED', 'This filter is not available for dashboard insights.', 422, ['fields' => array_values($unknown)]);
        }
    }
}
