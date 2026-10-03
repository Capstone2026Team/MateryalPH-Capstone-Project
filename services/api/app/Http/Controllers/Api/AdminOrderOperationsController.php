<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Orders\AdminOrderOperationsService;
use App\Domain\Payments\ReimbursementService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** Admin refund exceptions, authorized retries, cash reimbursements and open cancellation requests. */
final class AdminOrderOperationsController extends Controller
{
    public function __construct(private readonly AdminOrderOperationsService $operations) {}

    public function summary(Request $request): JsonResponse
    {
        return ApiResponse::success($this->operations->summary($request));
    }

    public function refunds(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'state' => ['sometimes', Rule::in(['REFUND_PENDING', 'REFUNDED', 'REFUND_FAILED'])],
            'trigger' => ['sometimes', Rule::in(['CANCELLATION', 'DISPUTE_CONCLUSION', 'TECHNICAL_COMPENSATION', 'FEE_CREDIT'])],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->operations->refunds($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function retryRefund(Request $request, string $refundId): JsonResponse
    {
        $this->operations->retry($request, $refundId);

        return ApiResponse::success(['refund_id' => $refundId, 'state' => 'REFUND_PENDING']);
    }

    public function reimbursements(Request $request): JsonResponse
    {
        return ApiResponse::success($this->operations->reimbursements($request));
    }

    public function decideReimbursement(Request $request, string $reimbursementId, ReimbursementService $reimbursements): JsonResponse
    {
        $input = $request->validate(['reason' => ['required', 'string', 'min:10', 'max:2000']]);
        $reimbursements->decide($request, $reimbursementId, (string) $input['reason']);

        return ApiResponse::success(['reimbursement_id' => $reimbursementId, 'state' => 'REIMBURSEMENT_CONFIRMED']);
    }

    public function cancellationRequests(Request $request): JsonResponse
    {
        return ApiResponse::success($this->operations->cancellationRequests($request));
    }
}
