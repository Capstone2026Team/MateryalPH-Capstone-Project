<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Payments\PaymentAttemptService;
use App\Domain\Payments\PhysicalPaymentService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** Buyer payment options, attempt creation and status. A client amount is never trusted; it is only compared. */
final class BuyerPaymentController extends Controller
{
    public function __construct(private readonly PaymentAttemptService $payments) {}

    public function options(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->payments->buyerOptions($request, $orderId));
    }

    public function create(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['channel_code' => ['required', 'string', 'max:32'], 'expected_total_centavos' => ['required', 'integer', 'min:1']]);
        /** @var array{channel_code: string, expected_total_centavos: int} $input */
        $result = $this->payments->createForOrder($request, $orderId, $input);

        return ApiResponse::success($result['attempt'], ['replayed' => $result['replayed']], $result['replayed'] ? 200 : 201);
    }

    public function show(Request $request, string $paymentId): JsonResponse
    {
        return ApiResponse::success($this->payments->buyerAttempt($request, $paymentId));
    }

    public function refresh(Request $request, string $paymentId): JsonResponse
    {
        return ApiResponse::success($this->payments->buyerRefresh($request, $paymentId));
    }

    public function acknowledgePhysical(Request $request, string $orderId, string $recordId, PhysicalPaymentService $physical): JsonResponse
    {
        return ApiResponse::success($physical->acknowledge($request, $orderId, $recordId));
    }
}
