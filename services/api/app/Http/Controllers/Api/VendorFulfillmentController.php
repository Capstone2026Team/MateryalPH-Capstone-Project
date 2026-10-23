<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Fulfillment\DeliveryAssignments;
use App\Domain\Fulfillment\DeliveryBuyerContact;
use App\Domain\Fulfillment\DeliveryWorkspace;
use App\Domain\Fulfillment\FulfillmentService;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\CancellationService;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderQueries;
use App\Domain\Orders\OrderStates;
use App\Domain\Payments\RefundService;
use App\Domain\Payments\ReimbursementService;
use App\Domain\Settings\PlatformSettings;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Vendor fulfillment workspace actions. Role authority and Fulfillment Staff assignment scope are enforced in the
 * domain on every request; none of these requests accepts a price, fee, vehicle configuration or commercial term.
 */
final class VendorFulfillmentController extends Controller
{
    public function __construct(private readonly OrderQueries $queries, private readonly FulfillmentService $fulfillment, private readonly CancellationService $cancellations) {}

    public function assignees(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->fulfillment->assignees($request, $orderId));
    }

    public function workspace(Request $request, DeliveryWorkspace $workspace): JsonResponse
    {
        $filters = $request->validate(['status' => ['sometimes', Rule::in(['ALL', 'PENDING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'ISSUES'])],
            'sort' => ['sometimes', Rule::in(['SCHEDULED', 'NEWEST'])], 'q' => ['sometimes', 'string', 'max:120'], 'page' => ['sometimes', 'integer', 'min:1']]);
        $page = $workspace->listing($request, $filters);

        return ApiResponse::success($page['items'], $page['meta']);
    }

    public function vehicles(Request $request, string $orderId, OrderAccess $access, DeliveryAssignments $assignments): JsonResponse
    {
        $scope = $access->vendorScope($request);
        $access->require($scope, OrderAccess::ASSIGN_FULFILLMENT, 'Only the Owner or Store Manager assigns delivery vehicles.');

        return ApiResponse::success($assignments->vehicles($access->vendorOrder($scope, $orderId)));
    }

    public function acknowledge(Request $request, string $orderId, DeliveryWorkspace $workspace): JsonResponse
    {
        $workspace->acknowledge($request, $orderId);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function route(Request $request, string $orderId, DeliveryWorkspace $workspace): JsonResponse
    {
        return ApiResponse::success($workspace->route($request, $orderId));
    }

    public function buyerPhoto(Request $request, string $orderId, DeliveryBuyerContact $contact): StreamedResponse
    {
        $input = $request->validate(['version' => ['sometimes', 'integer', 'min:1']]);

        return $contact->photo($request, $orderId, isset($input['version']) ? (int) $input['version'] : null);
    }

    public function assign(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['user_id' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:5', 'max:500'],
            'vehicle_index' => ['sometimes', 'integer', 'min:0', 'max:50'], 'lock_version' => ['required_with:vehicle_index,dispatch', 'integer', 'min:1'], 'dispatch' => ['sometimes', 'boolean']]);
        $this->fulfillment->assign($request, $orderId, (int) $input['user_id'], (string) $input['reason'], isset($input['vehicle_index']) ? (int) $input['vehicle_index'] : null,
            isset($input['lock_version']) ? (int) $input['lock_version'] : null, (bool) ($input['dispatch'] ?? false));

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function milestone(Request $request, string $orderId): JsonResponse
    {
        self::multipartBoolean($request, 'handover_confirmed');
        $input = $request->validate([
            'milestone' => ['required', Rule::in([OrderStates::PROCESSING, OrderStates::READY_FOR_PICKUP, OrderStates::OUT_FOR_DELIVERY, OrderStates::DELIVERED, OrderStates::PICKED_UP])],
            'lock_version' => ['required', 'integer', 'min:1'],
            'vehicle_index' => ['sometimes', 'nullable', 'integer', 'min:0', 'max:50'],
            'trip_number' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:500'],
            'receiver_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'receiver_kind' => ['sometimes', 'nullable', Rule::in(['BUYER', 'AUTHORIZED_RECEIVER'])],
            'handover_confirmed' => ['sometimes', 'boolean'],
            'note' => ['sometimes', 'nullable', 'string', 'max:500'],
            'cash_received_centavos' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'file' => ['sometimes', 'file', 'max:'.PlatformSettings::current()->uploadKb('case_evidence')],
            'signature' => ['sometimes', 'file', 'max:'.PlatformSettings::current()->uploadKb('case_evidence')],
        ]);
        // Multipart sends every field as text; the cash rule compares integers.
        if (isset($input['cash_received_centavos'])) {
            $input['cash_received_centavos'] = (int) $input['cash_received_centavos'];
        }
        $photo = $request->file('file');
        $signature = $request->file('signature');
        /** @var mixed $uploaded */
        $uploaded = $request->file('additional_photos', []);
        $additional = array_values(array_filter($uploaded instanceof UploadedFile ? [$uploaded] : (array) $uploaded, static fn (mixed $file): bool => $file instanceof UploadedFile));
        if (count($additional) > 3 || array_filter($additional, static fn (UploadedFile $file): bool => $file->getSize() > PlatformSettings::current()->uploadKb('case_evidence') * 1024) !== []) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Attach up to three additional photos within the evidence upload limit.', 422);
        }
        /** @var array{milestone: string, lock_version: int, vehicle_index?: int|null, trip_number?: int|null, receiver_name?: string|null, receiver_kind?: string|null, handover_confirmed?: bool|null, note?: string|null, cash_received_centavos?: int|null} $input */
        $this->fulfillment->record($request, $orderId, $input, $photo instanceof UploadedFile ? $photo : null, $signature instanceof UploadedFile ? $signature : null, $additional);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function trip(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['vehicle_index' => ['required', 'integer', 'min:0', 'max:50'], 'trip_number' => ['required', 'integer', 'min:1', 'max:500']]);
        $this->fulfillment->recordTrip($request, $orderId, ['vehicle_index' => (int) $input['vehicle_index'], 'trip_number' => (int) $input['trip_number']]);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function vehicleIssue(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['category' => ['required', Rule::in(FulfillmentService::VEHICLE_ISSUES)], 'description' => ['required', 'string', 'min:10', 'max:1000']]);
        $this->fulfillment->reportVehicleIssue($request, $orderId, ['category' => (string) $input['category'], 'description' => (string) $input['description']]);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId), [], 201);
    }

    public function respondProblem(Request $request, string $orderId, string $issueId): JsonResponse
    {
        $input = $request->validate(['response' => ['required', 'string', 'min:5', 'max:2000']]);
        $this->fulfillment->respondIssue($request, $orderId, $issueId, (string) $input['response']);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function cancellationPreview(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->cancellations->vendorPreview($request, $orderId));
    }

    public function cancel(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'reason_code' => ['required', Rule::in(CancellationService::VENDOR_REASONS)],
            'reason' => ['required', 'string', 'min:10', 'max:1000'],
        ]);
        /** @var array{lock_version: int, reason_code: string, reason: string} $input */
        $this->cancellations->vendorCancel($request, $orderId, $input);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function finalizeCancellation(Request $request, string $orderId): JsonResponse
    {
        self::multipartBoolean($request, 'retain_nrpc');
        $input = $request->validate(['retain_nrpc' => ['required', 'boolean'], 'note' => ['sometimes', 'nullable', 'string', 'max:2000'], 'file' => ['sometimes', 'file', 'max:'.PlatformSettings::current()->uploadKb('case_evidence')]]);
        $file = $request->file('file');
        $this->cancellations->vendorFinalize($request, $orderId, (bool) $input['retain_nrpc'], isset($input['note']) ? (string) $input['note'] : null, $file instanceof UploadedFile ? $file : null);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function retryRefund(Request $request, string $orderId, string $refundId, OrderAccess $access, RefundService $refunds, CatalogAccess $keys): JsonResponse
    {
        $scope = $access->vendorScope($request);
        $access->require($scope, OrderAccess::RETRY_REFUND, 'Only the store Owner can retry a failed refund after funding is resolved.');
        $key = $keys->requireIdempotencyKey($request);
        $access->vendorOrder($scope, $orderId);
        if (! $keys->replayed($request, 'REFUND_RETRY', $key, $refundId)) {
            $refunds->retry($refundId, OrderActor::vendor($request, $scope['role']), $scope['organization_id']);
            $keys->claim($request, 'REFUND_RETRY', $key, $refundId, 200);
        }

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function recordReimbursement(Request $request, string $orderId, string $reimbursementId, ReimbursementService $reimbursements): JsonResponse
    {
        $input = $request->validate(['file' => ['required', 'file', 'max:'.PlatformSettings::current()->uploadKb('case_evidence')], 'reimbursed_at' => ['sometimes', 'nullable', 'date'], 'note' => ['sometimes', 'nullable', 'string', 'max:500']]);
        $file = $request->file('file');
        if (! $file instanceof UploadedFile) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Upload the reimbursement evidence.', 422, ['file' => ['Upload a photo or PDF of the reimbursement.']]);
        }
        $reimbursements->record($request, $orderId, $reimbursementId, ['reimbursed_at' => $input['reimbursed_at'] ?? null, 'note' => $input['note'] ?? null], $file);

        return ApiResponse::success($this->queries->vendorDetail($request, $orderId));
    }

    public function file(Request $request, string $orderId, string $fileId, OrderAccess $access, OrderEvidenceFiles $files): StreamedResponse
    {
        $order = $access->vendorOrder($access->vendorScope($request), $orderId);

        return $files->stream((string) $order->id, $fileId, false);
    }

    /** Generated multipart clients send booleans as the strings true/false; normalize them before validation. */
    private static function multipartBoolean(Request $request, string $field): void
    {
        $value = $request->input($field);
        if (is_string($value) && in_array(strtolower($value), ['true', 'false'], true)) {
            $request->merge([$field => strtolower($value) === 'true' ? '1' : '0']);
        }
    }
}
