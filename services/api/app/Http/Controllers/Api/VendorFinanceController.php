<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Finance\FinanceAccess;
use App\Domain\Finance\VendorFinanceService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\PaymentAttemptService;
use App\Domain\Payments\PaymentPresenter;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Payments\PhysicalPaymentService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Vendor finance. Store-wide finance routes are Owner-only in the domain (FinanceAccess); order-scoped physical
 * payment recording and online-balance approval follow the operational order permissions instead.
 */
final class VendorFinanceController extends Controller
{
    public function __construct(private readonly VendorFinanceService $finance, private readonly FinanceAccess $access) {}

    public function overview(Request $request): JsonResponse
    {
        return ApiResponse::success($this->finance->overview($request));
    }

    public function updatePhysicalPayments(Request $request): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:0'], 'cod_enabled' => ['required', 'boolean'], 'in_store_enabled' => ['required', 'boolean']]);

        /** @var array{lock_version: int, cod_enabled: bool, in_store_enabled: bool} $input */
        return ApiResponse::success($this->finance->updatePhysicalPayments($request, $input));
    }

    public function transactions(Request $request): JsonResponse
    {
        $filters = $request->validate(['tab' => ['sometimes', Rule::in(VendorFinanceService::TABS)], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $this->finance->transactions($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function export(Request $request): StreamedResponse
    {
        $input = $request->validate(['tab' => ['required', Rule::in(VendorFinanceService::TABS)]]);

        return $this->finance->export($request, (string) $input['tab']);
    }

    public function earnings(Request $request): JsonResponse
    {
        return ApiResponse::success($this->finance->earnings($request));
    }

    public function statement(Request $request, string $statementId): JsonResponse
    {
        return ApiResponse::success($this->finance->statement($request, $statementId));
    }

    public function payStatement(Request $request, string $statementId, PaymentAttemptService $payments): JsonResponse
    {
        $scope = $this->access->owner($request, 'finance.pay');
        $input = $request->validate(['channel_code' => ['required', 'string', 'max:32'], 'amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1']]);
        /** @var array{channel_code: string, amount_centavos?: int|null} $input */
        $result = $payments->createForStatement($request, $scope['organization_id'], $statementId, $input);

        return ApiResponse::success($result['attempt'], ['replayed' => $result['replayed']], $result['replayed'] ? 200 : 201);
    }

    public function payment(Request $request, string $paymentId, PaymentPresenter $presenter): JsonResponse
    {
        return ApiResponse::success($presenter->attempt($this->ownedPayment($request, $paymentId), true));
    }

    public function refreshPayment(Request $request, string $paymentId, PaymentPresenter $presenter, PaymentReconciliationService $reconciliation): JsonResponse
    {
        $payment = $this->ownedPayment($request, $paymentId);
        if (in_array($payment->state, ['CREATING', 'PENDING', 'UNCERTAIN'], true)) {
            $reconciliation->reconcile((string) $payment->id);
        }

        return ApiResponse::success($presenter->attempt(DB::table('payments')->where('id', $payment->id)->first(), true));
    }

    public function recordPhysical(Request $request, string $orderId, PhysicalPaymentService $physical): JsonResponse
    {
        $input = $request->validate(['amount_centavos' => ['required', 'integer', 'min:1'], 'received_at' => ['sometimes', 'date'], 'note' => ['sometimes', 'nullable', 'string', 'max:500'],
            'file' => ['required', 'file', 'max:10240']]);
        $file = $request->file('file');
        if (! $file instanceof UploadedFile) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Attach the receipt evidence.', 422);
        }

        /** @var array{amount_centavos: int, received_at?: string, note?: ?string} $input */
        return ApiResponse::success($physical->record($request, $orderId, $input, $file), status: 201);
    }

    public function approveOnlineBalance(Request $request, string $orderId, PhysicalPaymentService $physical): JsonResponse
    {
        $physical->approveOnlineBalance($request, $orderId);

        return ApiResponse::success(['approved' => true]);
    }

    private function ownedPayment(Request $request, string $paymentId): object
    {
        $scope = $this->access->owner($request);
        $payment = Str::isUuid($paymentId) ? DB::table('payments')->where('id', $paymentId)->where('vendor_organization_id', $scope['organization_id'])->where('purpose', 'PLATFORM_FEE_PAYMENT')->first() : null;

        return $payment ?? throw new AuthenticationException('PAYMENT_NOT_FOUND', 'This payment is unavailable.', 404);
    }
}
