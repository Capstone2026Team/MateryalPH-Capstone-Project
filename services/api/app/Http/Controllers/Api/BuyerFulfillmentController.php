<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Fulfillment\ReceiptService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\CancellationService;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderQueries;
use App\Domain\Payments\ReimbursementService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/** Buyer fulfillment, receipt, problem reports, cancellation and reimbursement acknowledgment on the Buyer's own orders. */
final class BuyerFulfillmentController extends Controller
{
    public function __construct(private readonly OrderQueries $queries, private readonly CancellationService $cancellations, private readonly ReceiptService $receipts) {}

    public function cancellationPreview(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->cancellations->buyerPreview($request, $orderId));
    }

    public function cancel(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'reason_code' => ['sometimes', 'nullable', Rule::in(CancellationService::BUYER_REASONS)],
            'reason' => ['sometimes', 'nullable', 'string', 'max:1000'],
        ]);
        /** @var array{lock_version: int, reason_code?: ?string, reason?: ?string} $input */
        $kind = $this->cancellations->buyerCancel($request, $orderId, $input);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId), ['result' => $kind]);
    }

    public function withdrawRequest(Request $request, string $orderId): JsonResponse
    {
        $this->cancellations->buyerWithdrawRequest($request, $orderId);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function confirmReceipt(Request $request, string $orderId): JsonResponse
    {
        $this->receipts->confirm($request, $orderId);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function reportProblem(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'category' => ['required', Rule::in(ReceiptService::ISSUE_CATEGORIES)],
            'description' => ['required', 'string', 'min:10', 'max:2000'],
        ]);
        // Generated clients send one `files` part or a `files[]` array; both reach the same validated list.
        /** @var mixed $uploaded untrusted multipart shape: one file, a list, or nested arrays */
        $uploaded = $request->file('files', []);
        /** @var list<UploadedFile> $files */
        $files = array_values(array_filter($uploaded instanceof UploadedFile ? [$uploaded] : (array) $uploaded, static fn (mixed $file): bool => $file instanceof UploadedFile));
        if (count($files) > 3 || array_filter($files, static fn (UploadedFile $file): bool => $file->getSize() > 10 * 1024 * 1024) !== []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Attach up to three photos of up to 10 MB each.', 422, ['files' => ['Attach up to three photos of up to 10 MB each.']]);
        }
        $this->receipts->report($request, $orderId, ['category' => (string) $input['category'], 'description' => (string) $input['description']], $files);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId), [], 201);
    }

    public function resolveProblem(Request $request, string $orderId, string $issueId): JsonResponse
    {
        $input = $request->validate(['note' => ['sometimes', 'nullable', 'string', 'max:1000']]);
        $this->receipts->resolve($request, $orderId, $issueId, isset($input['note']) ? (string) $input['note'] : null);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function acknowledgeReimbursement(Request $request, string $orderId, string $reimbursementId, ReimbursementService $reimbursements): JsonResponse
    {
        $reimbursements->acknowledge($request, $orderId, $reimbursementId);

        return ApiResponse::success($this->queries->buyerDetail($request, $orderId));
    }

    public function file(Request $request, string $orderId, string $fileId, OrderAccess $access, OrderEvidenceFiles $files): StreamedResponse
    {
        $order = $access->buyerOrder($request, $orderId);

        return $files->stream((string) $order->id, $fileId, true);
    }
}
