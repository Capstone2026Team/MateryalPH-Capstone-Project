<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Finance\FinanceOperationsService;
use App\Domain\Finance\TaxAdjustmentService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/** FIN-10 Admin finance queues, KPIs and tax adjustments; every action is authorized in its domain service. */
final class AdminFinanceOperationsController extends Controller
{
    public function kpis(Request $request, FinanceOperationsService $finance): JsonResponse
    {
        $input = $request->validate(['from' => ['sometimes', 'date_format:Y-m-d'], 'to' => ['sometimes', 'date_format:Y-m-d']]);

        return ApiResponse::success($finance->kpis($request, $input['from'] ?? null, $input['to'] ?? null));
    }

    public function remittances(Request $request, FinanceOperationsService $finance): JsonResponse
    {
        $filters = $request->validate(['reconciliation_state' => ['sometimes', Rule::in(['PENDING', 'RECONCILED', 'RECONCILIATION_EXCEPTION'])],
            'calculation_state' => ['sometimes', Rule::in(['CALCULATED', 'POSTED', 'BASE_REVIEW_REQUIRED', 'VOIDED'])],
            'deduction_evidence_state' => ['sometimes', Rule::in(['UNCONFIRMED', 'SIMULATED_WITHHELD', 'PROVIDER_REPORTED', 'PLATFORM_EVIDENCED'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $finance->remittances($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function evidence(Request $request, FinanceOperationsService $finance): JsonResponse
    {
        $filters = $request->validate(['review_state' => ['sometimes', 'string', 'max:24', 'regex:/^[A-Z_]+$/'], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $finance->evidence($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function taxAdjustments(Request $request, TaxAdjustmentService $adjustments): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['ADJUSTMENT_REQUIRED', 'UNDER_REVIEW', 'APPROVED', 'POSTED', 'REJECTED'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $adjustments->list($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function prepareTaxAdjustment(Request $request, string $adjustmentId, TaxAdjustmentService $adjustments): JsonResponse
    {
        $input = $request->validate(['corrected_withheld_centavos' => ['required', 'integer', 'min:0'], 'reason' => ['required', 'string', 'min:10', 'max:2000'],
            'certificate_impact' => ['required', Rule::in(TaxAdjustmentService::CERTIFICATE_IMPACT)], 'evidence_reference' => ['sometimes', 'nullable', 'string', 'max:200']]);

        /** @var array{corrected_withheld_centavos: int, reason: string, certificate_impact: string, evidence_reference?: string|null} $input */
        return ApiResponse::success($adjustments->prepare($request, $adjustmentId, $input));
    }

    public function reviewTaxAdjustment(Request $request, string $adjustmentId, TaxAdjustmentService $adjustments): JsonResponse
    {
        $input = $request->validate(['decision' => ['required', Rule::in(['APPROVED', 'REJECTED'])], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success($adjustments->review($request, $adjustmentId, (string) $input['decision'], (string) $input['reason']));
    }

    public function postTaxAdjustment(Request $request, string $adjustmentId, TaxAdjustmentService $adjustments): JsonResponse
    {
        return ApiResponse::success($adjustments->post($request, $adjustmentId));
    }
}
