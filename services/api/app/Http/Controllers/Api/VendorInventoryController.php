<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Inventory\AutoAcceptPolicyService;
use App\Domain\Inventory\InventoryLedgerService;
use App\Domain\Inventory\StockAvailability;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Inventory\AutoAcceptPolicyRequest;
use App\Http\Requests\Inventory\InventoryRowUpdateRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

final class VendorInventoryController extends Controller
{
    public function __construct(private readonly InventoryLedgerService $ledger, private readonly AutoAcceptPolicyService $autoAccept) {}

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'q' => ['sometimes', 'string', 'max:120'],
            'listing_id' => ['sometimes', 'uuid'],
            'stock' => ['sometimes', Rule::in(StockAvailability::LABELS)],
            'confirmation' => ['sometimes', Rule::in(['DUE', 'STALE'])],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->ledger->ledger($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function update(InventoryRowUpdateRequest $request, string $variantId): JsonResponse
    {
        return ApiResponse::success($this->ledger->adjust($request, $variantId, $request->validated()));
    }

    public function confirm(Request $request): JsonResponse
    {
        $input = $request->validate([
            'items' => ['required', 'array', 'min:1', 'max:'.InventoryLedgerService::MAX_CONFIRMATIONS],
            'items.*.listing_variant_id' => ['required', 'uuid', 'distinct'],
            'items.*.lock_version' => ['required', 'integer', 'min:1'],
        ]);

        /** @var list<array{listing_variant_id: string, lock_version: int}> $items */
        $items = $input['items'];

        return ApiResponse::success($this->ledger->confirm($request, $items));
    }

    public function movements(Request $request, string $variantId): JsonResponse
    {
        $input = $request->validate(['page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $this->ledger->movements($request, $variantId, (int) ($input['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function prices(Request $request, string $variantId): JsonResponse
    {
        return ApiResponse::success($this->ledger->priceHistory($request, $variantId));
    }

    public function settings(Request $request): JsonResponse
    {
        return ApiResponse::success($this->ledger->settings($request));
    }

    public function saveSettings(Request $request): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:0'],
            'reminder_local_time' => ['required', 'date_format:H:i'],
            'email_reminders' => ['required', 'boolean'],
            'auto_accept_ready_lead_days' => ['sometimes', 'nullable', 'integer', 'between:0,30'],
        ]);

        /** @var array{lock_version: int, reminder_local_time: string, email_reminders: bool, auto_accept_ready_lead_days?: int|null} $input */
        return ApiResponse::success($this->ledger->saveSettings($request, $input));
    }

    public function autoAccept(Request $request, string $variantId): JsonResponse
    {
        return ApiResponse::success($this->autoAccept->show($request, $variantId));
    }

    public function configureAutoAccept(AutoAcceptPolicyRequest $request, string $variantId): JsonResponse
    {
        /** @var array{lock_version: int, enabled: bool, allotment_quantity: int|string, max_unit_count?: string|int|null, max_order_amount_centavos?: int|null} $input */
        $input = $request->validated();

        return ApiResponse::success($this->autoAccept->configure($request, $variantId, $input));
    }

    public function autoAcceptAllotment(Request $request, string $variantId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:0'], 'allotment_quantity' => ['required', 'regex:/^\d{1,14}$/']]);

        /** @var array{lock_version: int, allotment_quantity: int|string} $input */
        return ApiResponse::success($this->autoAccept->updateAllotment($request, $variantId, $input));
    }

    public function pauseAutoAccept(Request $request, string $variantId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($this->autoAccept->pause($request, $variantId, (int) $input['lock_version']));
    }

    public function resumeAutoAccept(Request $request, string $variantId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'confirmed_allotment_quantity' => ['required', 'regex:/^\d{1,14}$/']]);

        return ApiResponse::success($this->autoAccept->resume($request, $variantId, (int) $input['lock_version'], (string) $input['confirmed_allotment_quantity']));
    }
}
