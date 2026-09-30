<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Orders\BuyerOrderDecisionService;
use App\Domain\Orders\OrderQueries;
use App\Domain\Orders\OrderSubmissionService;
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
        ]);
        /** @var array{cart_lock_version: int, vendor_ids: list<string>, split_confirmed?: bool} $input */
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
            'group' => ['sometimes', Rule::in(['ALL', ...array_keys(OrderQueries::BUYER_GROUPS)])],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->queries->buyerList($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function approveRevision(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['snapshot_version' => ['required', 'integer', 'min:1']]);
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
