<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Orders\BuyAgainService;
use App\Domain\Orders\BuyerOrderDecisionService;
use App\Domain\Orders\OrderQueries;
use App\Domain\Orders\OrderSubmissionService;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** Buyer order submission, order hub and decisions. Every action is scoped to the Buyer's own profile. */
final class BuyerOrderController extends Controller
{
    public function __construct(private readonly OrderQueries $queries, private readonly BuyerOrderDecisionService $decisions) {}

    public function submit(Request $request, OrderSubmissionService $submission): JsonResponse
    {
        $input = $request->validate([
            'cart_lock_version' => ['required', 'integer', 'min:1'],
            'vendor_ids' => ['required', 'array', 'min:1', 'max:'.OrderSubmissionService::MAX_GROUPS],
            'vendor_ids.*' => ['required', 'uuid', 'distinct'],
            'split_confirmed' => ['sometimes', 'boolean'],
            'payment_methods' => ['sometimes', 'array', 'max:'.OrderSubmissionService::MAX_GROUPS],
            'payment_methods.*' => ['required', Rule::in(PaymentMethodPolicy::METHODS)],
            'work_package_id' => ['sometimes', 'nullable', 'uuid', 'required_with:work_package_lock_version'],
            'work_package_lock_version' => ['required_with:work_package_id', 'integer', 'min:1'],
            'budget_override_reason' => ['sometimes', 'nullable', 'string', 'min:10', 'max:2000'],
            'invoice_details' => ['sometimes', 'nullable', 'array:billing_name,billing_address,tin', 'min:1'],
            'invoice_details.billing_name' => ['required_with:invoice_details', 'string', 'min:2', 'max:180'],
            'invoice_details.billing_address' => ['required_with:invoice_details', 'string', 'min:10', 'max:500'],
            'invoice_details.tin' => ['sometimes', 'nullable', 'string', 'max:20'],
        ]);
        /** @var array{cart_lock_version: int, vendor_ids: list<string>, split_confirmed?: bool, payment_methods?: array<string, string>, work_package_id?: string|null, work_package_lock_version?: int, budget_override_reason?: string|null, invoice_details?: array{billing_name: string, billing_address: string, tin?: string|null}|null} $input */
        $result = $submission->submit($request, $input);

        return ApiResponse::success($result['checkout'], ['replayed' => $result['replayed']], $result['replayed'] ? 200 : 201);
    }

    public function checkout(Request $request, string $checkoutId, OrderSubmissionService $submission): JsonResponse
    {
        return ApiResponse::success($submission->show($request, $checkoutId));
    }

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'group' => ['sometimes', Rule::in(['ALL', ...array_keys(OrderQueries::BUYER_GROUPS), OrderQueries::BUYER_HISTORY_GROUP])],
            'procurement_type' => ['sometimes', Rule::in(OrderQueries::PROCUREMENT_TYPES)],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->queries->buyerList($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function buyAgain(Request $request, string $orderId, BuyAgainService $buyAgain): JsonResponse
    {
        $result = $buyAgain->run($request, $orderId);

        return ApiResponse::success(['cart' => $result['cart'], 'added' => $result['added'], 'skipped' => $result['skipped']], ['replayed' => $result['replayed']]);
    }

    public function fulfillmentConversation(Request $request, string $orderId, FulfillmentThreadService $threads): JsonResponse
    {
        return ApiResponse::success($threads->openForBuyer($request, $orderId));
    }

    public function show(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function approveRevision(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['snapshot_version' => ['required', 'integer', 'min:1'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);
        $this->decisions->approveRevision($request, $orderId, $input);

        return $this->show($request, $orderId);
    }

    public function rejectRevision(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['snapshot_version' => ['required', 'integer', 'min:1'], 'reason' => ['sometimes', 'nullable', 'string', 'max:1000']]);
        $this->decisions->rejectRevision($request, $orderId, $input);

        return $this->show($request, $orderId);
    }

    public function acceptNrpc(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'snapshot_version' => ['required', 'integer', 'min:1'],
            'nrpc_id' => ['required', 'uuid'],
            'terms_version_id' => ['required', 'uuid'],
            'acknowledged' => ['required', 'accepted'],
            'budget_override_reason' => ['sometimes', 'nullable', 'string', 'min:10', 'max:2000'],
        ]);
        $this->decisions->acceptNrpc($request, $orderId, ['acknowledged' => true] + $input);

        return $this->show($request, $orderId);
    }

    public function rejectNrpc(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['snapshot_version' => ['required', 'integer', 'min:1'], 'nrpc_id' => ['required', 'uuid'], 'reason' => ['sometimes', 'nullable', 'string', 'max:1000']]);
        $this->decisions->rejectNrpc($request, $orderId, $input);

        return $this->show($request, $orderId);
    }

    public function flagNrpc(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['nrpc_id' => ['required', 'uuid'], 'reason' => ['required', 'string', 'min:10', 'max:1000']]);
        $this->decisions->flagNrpc($request, $orderId, $input);

        return $this->show($request, $orderId);
    }
}
