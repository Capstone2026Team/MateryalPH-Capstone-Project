<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Analytics\Geo\GeoAnalyticsService;
use App\Domain\Identity\AuthenticationException;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Philippine Geographic Marketplace Analytics (analytics.view_aggregates). Filters are validated against allowlists;
 * unknown parameters are rejected so no request can create an inference-friendly grouping or ask for coordinates.
 */
final class GeoAnalyticsController extends Controller
{
    private const FILTERS = ['dataset', 'area', 'from', 'to', 'granularity', 'procurement_type', 'category_id', 'material_id', 'fulfillment_method', 'payment_method', 'order_state'];

    public function dashboard(Request $request, GeoAnalyticsService $analytics): JsonResponse
    {
        return ApiResponse::success($analytics->dashboard($request, $this->filters($request)));
    }

    public function demand(Request $request, GeoAnalyticsService $analytics): JsonResponse
    {
        return ApiResponse::success($analytics->demand($request, $this->filters($request, ['measure', 'page'])));
    }

    public function filterOptions(Request $request, GeoAnalyticsService $analytics): JsonResponse
    {
        $input = $request->validate(['category_id' => ['sometimes', 'uuid'], 'page' => ['sometimes', 'integer', 'min:1']]);
        $result = $analytics->filterOptions($request, $input['category_id'] ?? null, (int) ($input['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function boundaries(Request $request, GeoAnalyticsService $analytics): JsonResponse
    {
        $input = $request->validate(['area' => ['sometimes', 'nullable', 'string', 'regex:/^[0-9]{10}$/']]);

        return ApiResponse::success($analytics->boundaries($request, $input['area'] ?? null));
    }

    /**
     * @param  list<string>  $extra
     * @return array<string, mixed>
     */
    private function filters(Request $request, array $extra = []): array
    {
        $unknown = array_diff(array_keys($request->query()), [...self::FILTERS, ...$extra]);
        if ($unknown !== []) {
            throw new AuthenticationException('ANALYTICS_FILTER_UNSUPPORTED', 'This filter is not available for geographic analytics.', 422, ['fields' => array_values($unknown)]);
        }

        return $request->validate(GeoAnalyticsService::rules($extra));
    }
}
