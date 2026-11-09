<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Orders\AdminOrderAudit;
use App\Domain\Orders\OrderStates;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Support\PortalDateRange;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class AdminOrderAuditController extends Controller
{
    public function __construct(private readonly AdminOrderAudit $audit) {}

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'q' => ['sometimes', 'string', 'max:120'], 'page' => ['sometimes', 'integer', 'between:1,1000'],
            'order_state' => ['sometimes', Rule::in([OrderStates::AWAITING_VENDOR_CONFIRMATION, OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, OrderStates::CONFIRMED, OrderStates::PROCESSING, OrderStates::READY_FOR_PICKUP, OrderStates::OUT_FOR_DELIVERY, OrderStates::DELIVERED, OrderStates::PICKED_UP, OrderStates::COMPLETED, OrderStates::CANCELLATION_REQUESTED, OrderStates::DECLINED, OrderStates::EXPIRED, OrderStates::CANCELLED, 'DISPUTED'])],
            'payment_state' => ['sometimes', Rule::in(['NOT_REQUIRED', 'PENDING', 'PAID', 'FAILED', 'EXPIRED'])],
            'refund_state' => ['sometimes', Rule::in(['NOT_REQUESTED', 'REFUND_PENDING', 'PARTIALLY_REFUNDED', 'REFUNDED', 'REFUND_FAILED'])],
            'payment_method' => ['sometimes', Rule::in(['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'])],
        ] + PortalDateRange::rules($request));
        $result = $this->audit->search($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->audit->detail($request, $orderId, $this->caseId($request)));
    }

    public function file(Request $request, string $orderId, string $fileId, OrderEvidenceFiles $files, AuditRecorder $recorder): StreamedResponse
    {
        $this->audit->authorize($request, $orderId, $this->caseId($request));
        $response = $files->stream($orderId, $fileId, false);
        $recorder->account($request, 'ORDER_AUDIT_EVIDENCE_VIEWED', 'ORDER', $orderId, after: ['file_id' => $fileId]);

        return $response;
    }

    private function caseId(Request $request): ?string
    {
        $input = $request->validate(['case_id' => ['sometimes', 'uuid']]);

        return $input['case_id'] ?? null;
    }
}
