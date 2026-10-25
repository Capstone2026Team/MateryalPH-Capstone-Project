<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Analytics\AnalyticsRequest;
use App\Domain\Analytics\AnalyticsWindow;
use App\Domain\Analytics\MaterialsAnalyticsAdminService;
use App\Domain\Analytics\MaterialsAnalyticsAssembler;
use App\Domain\Analytics\MaterialsAnalyticsProducts;
use App\Domain\Analytics\MaterialsAnalyticsService;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Identity\AuthenticationException;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Policies\MaterialsAnalyticsPolicy;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * MAT-01–MAT-07 Materials Analytics for three audiences on separate routes. Each action authorizes through the policy
 * (from the database, before any cache read), resolves the audience's own scope (Buyer origin, the Vendor's own store,
 * or an Admin PSGC area), rejects any undocumented filter, and returns that audience's serializer only.
 */
final class MaterialsAnalyticsController extends Controller
{
    private const COMMON = ['preset_days', 'start_date', 'end_date', 'category_id', 'q', 'cursor', 'per_page'];

    private const BUYER_ORIGIN = ['location_id', 'latitude', 'longitude', 'origin_source', 'radius_km'];

    public function __construct(
        private readonly MaterialsAnalyticsPolicy $policy,
        private readonly MaterialsAnalyticsAssembler $assembler,
        private readonly MaterialsAnalyticsService $service,
        private readonly MaterialsAnalyticsProducts $products,
        private readonly GeographyScopeResolver $scopes,
        private readonly BuyerProfiles $profiles,
    ) {}

    public function buyerList(Request $request): JsonResponse
    {
        $input = $this->input($request, 'viewBuyer', [...self::COMMON, ...self::BUYER_ORIGIN]);

        return ApiResponse::success($this->assembler->list($this->buyerRequest($request, $input), $input['cursor'] ?? null, (int) ($input['per_page'] ?? MaterialsAnalyticsService::PER_PAGE)));
    }

    public function buyerDetail(Request $request, string $groupId): JsonResponse
    {
        $input = $this->input($request, 'viewBuyer', ['preset_days', 'start_date', 'end_date', ...self::BUYER_ORIGIN]);

        return ApiResponse::success($this->assembler->detail($this->buyerRequest($request, $input), self::uuid($groupId)));
    }

    /** One row per canonical product in the Buyer's scope, with per-category counts for the overview tiles. */
    public function buyerProducts(Request $request): JsonResponse
    {
        $input = $this->input($request, 'viewBuyer', [...self::COMMON, ...self::BUYER_ORIGIN]);

        return ApiResponse::success($this->products->list($this->buyerRequest($request, $input), $input['cursor'] ?? null, (int) ($input['per_page'] ?? MaterialsAnalyticsService::PER_PAGE)));
    }

    /** One product's summary, its most-offered variant's average and trend, and its variants. */
    public function buyerProduct(Request $request, string $materialId): JsonResponse
    {
        $input = $this->input($request, 'viewBuyer', ['preset_days', 'start_date', 'end_date', ...self::BUYER_ORIGIN]);

        return ApiResponse::success($this->products->detail($this->buyerRequest($request, $input), self::uuid($materialId)));
    }

    public function buyerOffers(Request $request, string $groupId): JsonResponse
    {
        $input = $this->input($request, 'viewBuyer', ['cursor', 'per_page', ...self::BUYER_ORIGIN]);
        $analytics = $this->buyerRequest($request, $input);
        $group = $this->service->group(self::uuid($groupId));
        $page = $this->service->buyerOffers($analytics, (string) $group->id, $input['cursor'] ?? null, min((int) ($input['per_page'] ?? MaterialsAnalyticsService::PER_PAGE), MaterialsAnalyticsService::MAX_PER_PAGE));

        return ApiResponse::success($page['items'], ['next_cursor' => $page['next_cursor'], 'total' => $page['total'], 'current_as_of' => $page['as_of'], 'scope' => $analytics->scope->summary(),
            'note' => 'Current public offers. Opening an offer shows its Product Details; an analytics price never reserves stock or becomes a quotation.']);
    }

    public function vendorList(Request $request): JsonResponse
    {
        $input = $this->input($request, 'viewVendor', [...self::COMMON, 'radius_km']);

        return ApiResponse::success($this->assembler->list($this->vendorRequest($request, $input), $input['cursor'] ?? null, (int) ($input['per_page'] ?? MaterialsAnalyticsService::PER_PAGE)));
    }

    public function vendorDetail(Request $request, string $groupId): JsonResponse
    {
        $input = $this->input($request, 'viewVendor', ['preset_days', 'start_date', 'end_date', 'radius_km']);
        $detail = $this->assembler->detail($this->vendorRequest($request, $input), self::uuid($groupId));
        $detail['can_edit_own_listing'] = in_array('catalog.manage', (array) ($request->attributes->get('account_scope')['permissions'] ?? []), true);

        return ApiResponse::success($detail);
    }

    public function vendorExport(Request $request): StreamedResponse
    {
        $input = $this->input($request, 'viewVendor', ['preset_days', 'start_date', 'end_date', 'radius_km', 'category_id', 'q']);
        $analytics = $this->vendorRequest($request, $input);

        return $this->csv('materials-analytics-competitor-averages', ['Material', 'Comparable variant', 'Unit', 'Start date', 'Competitor average start (PHP)', 'End date', 'Competitor average end (PHP)',
            'Competitor count (end)', 'Change %', 'Direction', 'Participants changed', 'Your price per unit (PHP)', 'Dataset'],
            fn (array $row): array => [$row['material']['name'], $row['display_name'], $row['unit']['name'], $row['start_point']['date'], $row['start_point']['average_php'] ?? $row['start_point']['label'],
                $row['end_point']['date'], $row['end_point']['average_php'] ?? $row['end_point']['label'], $row['end_point']['competitor_count'], $row['trend']['change_percent'] ?? $row['trend']['label'],
                $row['trend']['direction'], $row['trend']['composition_changed'] === null ? '' : ($row['trend']['composition_changed'] ? 'Yes' : 'No'), $row['own_offer']['normalized_php'] ?? '', $analytics->dataset['label']],
            $analytics);
    }

    public function adminList(Request $request): JsonResponse
    {
        $input = $this->input($request, 'viewAdmin', [...self::COMMON, 'psgc_code', 'psgc_version_id']);

        return ApiResponse::success($this->assembler->list($this->adminRequest($request, $input), $input['cursor'] ?? null, (int) ($input['per_page'] ?? MaterialsAnalyticsService::PER_PAGE)));
    }

    public function adminDetail(Request $request, string $groupId): JsonResponse
    {
        $input = $this->input($request, 'viewAdmin', ['preset_days', 'start_date', 'end_date', 'psgc_code', 'psgc_version_id']);
        $detail = $this->assembler->detail($this->adminRequest($request, $input), self::uuid($groupId));
        $detail['can_inspect_sources'] = $this->policy->inspectSources($request->user());

        return ApiResponse::success($detail);
    }

    public function adminSources(Request $request, string $groupId, MaterialsAnalyticsAdminService $admin): JsonResponse
    {
        $this->policy->authorize($request->user(), 'inspectSources');
        $input = $request->validate(['snapshot_date' => ['required', 'date_format:Y-m-d'], 'reason' => ['required', 'string', 'min:10', 'max:500'], 'psgc_code' => ['sometimes', 'nullable', 'string', 'max:16']]);
        $this->rejectUnknown($request, ['snapshot_date', 'reason', 'psgc_code']);
        $result = $admin->sources($request, self::uuid($groupId), $input);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function adminRuns(Request $request, MaterialsAnalyticsAdminService $admin): JsonResponse
    {
        $this->policy->authorize($request->user(), 'viewAdmin');

        return ApiResponse::success($admin->runs(), ['dataset' => AnalyticsDataset::active()['label']]);
    }

    public function adminCorrect(Request $request, string $runId, MaterialsAnalyticsAdminService $admin): JsonResponse
    {
        $this->policy->authorize($request->user(), 'inspectSources');
        $input = $request->validate(['excluded_observation_ids' => ['required', 'array', 'min:1', 'max:200'], 'excluded_observation_ids.*' => ['uuid'], 'reason' => ['required', 'string', 'min:10', 'max:1000']]);

        return ApiResponse::success($admin->correct($request, self::uuid($runId), $input));
    }

    public function adminExport(Request $request): StreamedResponse
    {
        $input = $this->input($request, 'exportAdmin', ['preset_days', 'start_date', 'end_date', 'psgc_code', 'psgc_version_id', 'category_id', 'q']);
        $analytics = $this->adminRequest($request, $input);

        return $this->csv('materials-analytics-aggregates', ['Material', 'Comparable variant', 'Unit', 'Start date', 'Start average (PHP)', 'Start Vendors', 'End date', 'End average (PHP)', 'End Vendors',
            'Change %', 'Direction', 'Participants changed', 'Current Vendors', 'Current listings', 'Dataset'],
            fn (array $row): array => [$row['material']['name'], $row['display_name'], $row['unit']['name'], $row['start_point']['date'], $row['start_point']['average_php'] ?? $row['start_point']['label'],
                $row['start_point']['vendor_count'], $row['end_point']['date'], $row['end_point']['average_php'] ?? $row['end_point']['label'], $row['end_point']['vendor_count'],
                $row['trend']['change_percent'] ?? $row['trend']['label'], $row['trend']['direction'], $row['trend']['composition_changed'] === null ? '' : ($row['trend']['composition_changed'] ? 'Yes' : 'No'),
                $row['current']['vendor_count'], $row['current']['listing_count'], $analytics->dataset['label']],
            $analytics);
    }

    /**
     * @param  list<string>  $allowed
     * @return array<string, mixed>
     */
    private function input(Request $request, string $ability, array $allowed): array
    {
        $this->policy->authorize($request->user(), $ability);
        $this->rejectUnknown($request, $allowed);
        $rules = [
            'preset_days' => ['sometimes', 'integer', Rule::in(AnalyticsWindow::PRESETS)],
            'start_date' => ['sometimes', 'nullable', 'date_format:Y-m-d'], 'end_date' => ['sometimes', 'nullable', 'date_format:Y-m-d'],
            'category_id' => ['sometimes', 'nullable', 'uuid'], 'q' => ['sometimes', 'nullable', 'string', 'max:100'],
            'cursor' => ['sometimes', 'nullable', 'string', 'max:64'], 'per_page' => ['sometimes', 'integer', 'between:1,'.MaterialsAnalyticsService::MAX_PER_PAGE],
            'location_id' => ['sometimes', 'nullable', 'uuid'], 'latitude' => ['sometimes', 'required_with:longitude', 'numeric', 'between:-90,90'],
            'longitude' => ['sometimes', 'required_with:latitude', 'numeric', 'between:-180,180'], 'origin_source' => ['sometimes', Rule::in(['DEVICE', 'MAP_PIN', 'SEARCH'])],
            'radius_km' => ['sometimes', 'integer'], 'psgc_code' => ['sometimes', 'nullable', 'string', 'max:16'], 'psgc_version_id' => ['sometimes', 'nullable', 'uuid'],
        ];

        return array_filter($request->validate(array_intersect_key($rules, array_flip($allowed))), static fn (mixed $value): bool => $value !== null && $value !== '');
    }

    /** Undocumented filters (competitor ids, arbitrary groupings, role or include flags) are refused, not ignored. */
    /** @param list<string> $allowed */
    private function rejectUnknown(Request $request, array $allowed): void
    {
        $unknown = array_values(array_diff(array_keys($request->all()), $allowed));
        if ($unknown !== []) {
            if (in_array($unknown[0], GeographyScopeResolver::VENDOR_FORBIDDEN_ORIGIN_KEYS, true)) {
                throw new AuthenticationException('ORIGIN_NOT_PERMITTED', 'Vendor market scope always uses your own verified store location.', 422, ['field' => $unknown[0]]);
            }
            throw new AuthenticationException('ANALYTICS_FILTER_UNSUPPORTED', 'This filter is not supported for Materials Analytics.', 422, ['fields' => $unknown]);
        }
    }

    /** @param array<string, mixed> $input */
    private function buyerRequest(Request $request, array $input): AnalyticsRequest
    {
        $scope = $this->scopes->forBuyer($this->profiles->idFor($request), array_intersect_key($input, array_flip(self::BUYER_ORIGIN)));
        $dataset = AnalyticsDataset::active();

        return new AnalyticsRequest('BUYER', $scope, null, $dataset, AnalyticsWindow::resolve($input, $dataset), self::filters($input));
    }

    /** @param array<string, mixed> $input */
    private function vendorRequest(Request $request, array $input): AnalyticsRequest
    {
        $organizationId = (string) ($request->attributes->get('account_scope')['organization_id'] ?? '');
        $scope = $this->scopes->forVendor($organizationId, array_intersect_key($input, ['radius_km' => true]));
        $dataset = AnalyticsDataset::active();

        return new AnalyticsRequest('VENDOR', $scope, $organizationId, $dataset, AnalyticsWindow::resolve($input, $dataset), self::filters($input));
    }

    /** @param array<string, mixed> $input */
    private function adminRequest(Request $request, array $input): AnalyticsRequest
    {
        $scope = $this->scopes->forAdmin($input['psgc_code'] ?? null, $input['psgc_version_id'] ?? null);
        $dataset = AnalyticsDataset::active();

        return new AnalyticsRequest('ADMIN', $scope, null, $dataset, AnalyticsWindow::resolve($input, $dataset), self::filters($input), $this->policy->inspectSources($request->user()));
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private static function filters(array $input): array
    {
        return array_intersect_key($input, ['category_id' => true, 'q' => true]);
    }

    /**
     * @param  list<string>  $header
     * @param  callable(array<string, mixed>): list<mixed>  $map
     */
    private function csv(string $name, array $header, callable $map, AnalyticsRequest $analytics): StreamedResponse
    {
        $rows = [];
        $cursor = null;
        do {
            $page = $this->assembler->list($analytics, $cursor, MaterialsAnalyticsService::MAX_PER_PAGE);
            array_push($rows, ...$page['items']);
            $cursor = $page['next_cursor'];
        } while ($cursor !== null && count($rows) < 1000);

        return response()->streamDownload(static function () use ($header, $rows, $map): void {
            $out = fopen('php://output', 'wb');
            fputcsv($out, $header);
            foreach ($rows as $row) {
                // Neutralize spreadsheet formulas in any text cell.
                fputcsv($out, array_map(static fn (mixed $cell): string => preg_match('/^[=+\-@]/', (string) $cell) === 1 && ! is_numeric($cell) ? "'".$cell : (string) $cell, $map($row)));
            }
            fclose($out);
        }, $name.'-'.now('Asia/Manila')->format('Ymd').'.csv', ['Content-Type' => 'text/csv; charset=UTF-8', 'Cache-Control' => 'private, no-store']);
    }

    private static function uuid(string $id): string
    {
        return Str::isUuid($id) ? $id : '00000000-0000-0000-0000-000000000000';
    }
}
