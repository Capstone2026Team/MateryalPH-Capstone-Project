<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Analytics\Products\VendorProductAnalytics;
use App\Domain\Identity\AuthenticationException;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Support\PortalDateRange;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Read-only Vendor Product Analytics. The route fixes the Vendor audience and web transport; the domain service resolves
 * the organization and requires `catalog.manage` on every request, and only the Owner (`finance.view`) receives peso
 * values. Unknown query parameters are rejected so no request can ask for a grouping or identifier the view does not offer.
 */
final class VendorProductAnalyticsController extends Controller
{
    public function overview(Request $request, VendorProductAnalytics $analytics): JsonResponse
    {
        $this->only($request, ['days', 'from', 'to', 'sort', 'page']);
        $input = $request->validate([
            'days' => ['sometimes', 'integer', Rule::in(VendorProductAnalytics::PERIODS)],
            'sort' => ['sometimes', Rule::in(VendorProductAnalytics::SORTS)],
            'page' => ['sometimes', 'integer', 'min:1', 'max:1000'],
        ] + PortalDateRange::rules($request));

        return ApiResponse::success($analytics->overview($request, $input));
    }

    public function product(Request $request, string $listingId, VendorProductAnalytics $analytics): JsonResponse
    {
        $this->only($request, ['days', 'from', 'to']);
        $input = $request->validate(['days' => ['sometimes', 'integer', Rule::in(VendorProductAnalytics::PERIODS)]] + PortalDateRange::rules($request));

        return ApiResponse::success($analytics->product($request, $listingId, $input));
    }

    public function summaries(Request $request, VendorProductAnalytics $analytics): JsonResponse
    {
        $this->only($request, ['listing_ids', 'days']);
        $input = $request->validate([
            'listing_ids' => ['required', 'string', 'max:'.(VendorProductAnalytics::SUMMARY_LIMIT * 37)],
            'days' => ['sometimes', 'integer', Rule::in(VendorProductAnalytics::PERIODS)],
        ]);
        $ids = array_values(array_filter(array_map('trim', explode(',', (string) $input['listing_ids'])), static fn (string $id): bool => $id !== ''));

        return ApiResponse::success($analytics->summaries($request, $ids, $input));
    }

    /** @param list<string> $allowed */
    private function only(Request $request, array $allowed): void
    {
        $unknown = array_diff(array_keys($request->query()), $allowed);
        if ($unknown !== []) {
            throw new AuthenticationException('PRODUCT_ANALYTICS_FILTER_UNSUPPORTED', 'This filter is not available for product analytics.', 422, ['fields' => array_values($unknown)]);
        }
    }
}
