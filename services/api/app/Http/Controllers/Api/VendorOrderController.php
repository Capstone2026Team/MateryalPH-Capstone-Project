<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Orders\OrderConfirmationService;
use App\Domain\Orders\OrderQueries;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** Vendor order workspace: status-filtered list, job-order detail, confirmation, revision, NRPC and decline. */
final class VendorOrderController extends Controller
{
    public function __construct(private readonly OrderQueries $queries, private readonly OrderConfirmationService $confirmations) {}

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'group' => ['sometimes', Rule::in(['ALL', ...array_keys(OrderQueries::VENDOR_GROUPS)])],
            'q' => ['sometimes', 'string', 'max:120'],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->queries->vendorList($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function deliveryPlan(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'lines' => ['sometimes', 'array', 'max:100'],
            'lines.*.order_line_id' => ['required', 'uuid'],
            'lines.*.confirmed_quantity' => ['required'],
        ]);

        return ApiResponse::success($this->confirmations->deliveryPlan($request, $orderId, $input));
    }

    public function confirm(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'lines' => ['required', 'array', 'min:1', 'max:100'],
            'lines.*.order_line_id' => ['required', 'uuid', 'distinct'],
            'lines.*.confirmed_quantity' => ['required'],
            'vendor_discount_centavos' => ['sometimes', 'integer', 'min:0', 'max:100000000000'],
            'nrpc' => ['sometimes', 'nullable', 'array'],
            'nrpc.amount_centavos' => ['required_with:nrpc', 'integer', 'min:1', 'max:100000000000'],
            'nrpc.reason' => ['required_with:nrpc', 'string', 'min:10', 'max:1000'],
            'nrpc.lines' => ['required_with:nrpc', 'array', 'min:1', 'max:100'],
            'nrpc.lines.*.order_line_id' => ['required', 'uuid', 'distinct'],
            'nrpc.lines.*.principal_centavos' => ['required', 'integer', 'min:1'],
            'pickup' => ['sometimes', 'nullable', 'array'],
            'pickup.ready_date' => ['required_with:pickup', 'date_format:Y-m-d'],
            'delivery' => ['sometimes', 'nullable', 'array'],
            'delivery.vehicles' => ['required_with:delivery', 'array', 'min:1', 'max:20'],
            'delivery.vehicles.*.vehicle_id' => ['required', 'uuid'],
            'delivery.vehicles.*.number_of_vehicles' => ['required', 'integer', 'min:1'],
            'delivery.vehicles.*.total_vehicle_trips' => ['required', 'integer', 'min:1'],
            'delivery.vehicles.*.group_key' => ['sometimes', 'string', 'max:40'],
            'delivery.final_fee_centavos' => ['required_with:delivery', 'integer', 'min:0'],
            'delivery.fulfillment_date' => ['required_with:delivery', 'date_format:Y-m-d'],
            'delivery.arrangement' => ['required_with:delivery', 'string', 'min:5', 'max:2000'],
            'delivery.access_confirmed' => ['required_with:delivery', 'boolean'],
            'delivery.heavy_vehicle_access_confirmed' => ['sometimes', 'boolean'],
            'delivery.manual_review_note' => ['sometimes', 'nullable', 'string', 'min:10', 'max:2000'],
        ]);
        $this->confirmations->confirm($request, $orderId, $input);

        return $this->show($request, $orderId);
    }

    public function decline(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'reason_code' => ['required', Rule::in(OrderConfirmationService::DECLINE_REASONS)],
            'reason' => ['required', 'string', 'min:5', 'max:1000'],
        ]);
        /** @var array{lock_version: int, reason_code: string, reason: string} $input */
        $this->confirmations->decline($request, $orderId, $input);

        return $this->show($request, $orderId);
    }
}
