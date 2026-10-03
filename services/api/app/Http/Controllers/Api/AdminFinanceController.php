<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Finance\AdminFinanceService;
use App\Domain\Finance\WithholdingThresholdEngine;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** Admin finance on the existing finance.* permissions; each action is authorized in AdminFinanceService. */
final class AdminFinanceController extends Controller
{
    private const KINDS = ['RECONCILIATION_EXCEPTION', 'PAYMENT_MISMATCH', 'LATE_CAPTURE_COMPENSATION', 'OVERLAP_UNRESOLVED', 'THRESHOLD_ADJUSTMENT_REQUIRED', 'BASE_REVIEW_REQUIRED', 'FEE_OVERPAYMENT', 'STATEMENT_OVERDUE', 'FEE_CREDIT_PROPOSAL', 'PAID_FEE_CREDIT_PAYABLE'];

    public function __construct(private readonly AdminFinanceService $finance) {}

    public function payments(Request $request): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['CREATING', 'PENDING', 'UNCERTAIN', 'PAID', 'FAILED', 'EXPIRED', 'CANCELLED'])],
            'purpose' => ['sometimes', Rule::in(['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT', 'PLATFORM_FEE_PAYMENT'])],
            'evidence_origin' => ['sometimes', Rule::in(['XENDIT_TEST', 'SIMULATED'])], 'reconciliation_state' => ['sometimes', Rule::in(['NOT_REQUIRED', 'PENDING', 'RECONCILED', 'EXCEPTION'])],
            'page' => ['sometimes', 'integer', 'between:1,1000']]);

        return $this->paged($this->finance->payments($request, $filters));
    }

    public function reviewItems(Request $request): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['OPEN', 'RESOLVED'])], 'kind' => ['sometimes', Rule::in(self::KINDS)], 'page' => ['sometimes', 'integer', 'between:1,1000']]);

        return $this->paged($this->finance->reviewItems($request, $filters));
    }

    public function resolveItem(Request $request, string $itemId): JsonResponse
    {
        $input = $request->validate(['resolution' => ['required', 'string', 'min:10', 'max:2000']]);
        $this->finance->resolveItem($request, $itemId, (string) $input['resolution']);

        return ApiResponse::success(['resolved' => true]);
    }

    public function accumulators(Request $request): JsonResponse
    {
        $filters = $request->validate(['status' => ['sometimes', Rule::in(WithholdingThresholdEngine::STATUSES)], 'taxable_year' => ['sometimes', 'integer', 'between:2000,2100'], 'page' => ['sometimes', 'integer', 'between:1,1000']]);

        return $this->paged($this->finance->accumulators($request, $filters));
    }

    public function accumulator(Request $request, string $accumulatorId): JsonResponse
    {
        return ApiResponse::success($this->finance->accumulator($request, $accumulatorId));
    }

    public function resolveOverlap(Request $request, string $accumulatorId): JsonResponse
    {
        $input = $request->validate(['overlap_centavos' => ['required', 'integer', 'min:0'], 'lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        /** @var array{overlap_centavos: int, lock_version: int, reason: string} $input */
        return ApiResponse::success($this->finance->resolveOverlap($request, $accumulatorId, $input));
    }

    public function statements(Request $request): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['DRAFT', 'ISSUED', 'PARTIALLY_PAID', 'PAID', 'VOIDED'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);

        return $this->paged($this->finance->statementsList($request, $filters));
    }

    public function draftStatements(Request $request): JsonResponse
    {
        return ApiResponse::success(['drafted' => $this->finance->draftStatements($request)]);
    }

    public function approveStatement(Request $request, string $statementId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($this->finance->approveStatement($request, $statementId, (int) $input['lock_version']));
    }

    public function proposeFeeCredit(Request $request): JsonResponse
    {
        $input = $request->validate(['fee_assessment_id' => ['required', 'uuid'], 'returned_exclusive_centavos' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        /** @var array{fee_assessment_id: string, returned_exclusive_centavos: int, reason: string} $input */
        return ApiResponse::success(['proposal_id' => $this->finance->proposeFeeCredit($request, $input)], status: 201);
    }

    public function approveFeeCredit(Request $request, string $proposalId): JsonResponse
    {
        return ApiResponse::success(['fee_adjustment_id' => $this->finance->approveFeeCredit($request, $proposalId)]);
    }

    public function channelFees(Request $request): JsonResponse
    {
        return ApiResponse::success($this->finance->channelFees($request));
    }

    public function reconcile(Request $request): JsonResponse
    {
        return ApiResponse::success($this->finance->runReconciliation($request));
    }

    /** @param array{items: list<array<string, mixed>>, meta: array<string, mixed>} $result */
    private function paged(array $result): JsonResponse
    {
        return ApiResponse::success($result['items'], $result['meta']);
    }
}
