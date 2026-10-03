<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\PaymentReconciliationService;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Cancellation eligibility and requests (System Workflow cancellation table; owner decisions of 2026-10-02):
 *
 *   Buyer, AWAITING_VENDOR_CONFIRMATION   withdraw immediately; nothing captured, nothing refunded
 *   Buyer, AWAITING_PAYMENT               cancel immediately after a reconciliation rules out a capture
 *   Buyer, CONFIRMED                      reasoned cancellation, final at once, full refund of every paid amount
 *   Buyer, PROCESSING                     reasoned request → CANCELLATION_REQUESTED; the Vendor finalizes within 24 h
 *                                         (retaining the accepted NRPC only with preparation evidence) and cannot
 *                                         refuse; a timeout finalizes with a full refund; the Buyer may withdraw it
 *   Buyer, READY_FOR_PICKUP onward        unavailable: Report a Problem, dispute, return, warranty and statutory
 *                                         remedies stay available and the reason is explained in text
 *   Vendor (Owner, Manager, Store Staff)  reasoned cancellation before DELIVERED/PICKED_UP: NRPC forfeited, every
 *                                         Buyer-paid amount refunded, reservation released, NFR event
 *
 * Every mutation needs an Idempotency-Key; a duplicate cancellation is a replay or a 409, never a second refund.
 */
final class CancellationService
{
    public const BUYER_REASONS = ['CHANGE_OF_REQUIREMENT', 'DUPLICATE_ORDER', 'BUDGET_CHANGE', 'PROJECT_DELAY', 'SCHEDULE_CONFLICT', 'VENDOR_AGREEMENT', 'OTHER'];

    public const VENDOR_REASONS = ['STOCK_FAILURE', 'OPERATIONAL_INABILITY', 'DELIVERY_INABILITY', 'COMPLIANCE_RESTRICTION', 'ACCOUNT_RESTRICTION', 'BUYER_AGREEMENT', 'OTHER'];

    /** Vendor response window for a Buyer request during PROCESSING (approved by the project owner on 2026-10-02). */
    public const RESPONSE_HOURS = 24;

    public const REMEDIES = ['REPORT_PROBLEM', 'DISPUTE', 'RETURN', 'WARRANTY', 'STATUTORY_REMEDIES'];

    /** States in which a Vendor may cancel with a reason. */
    private const VENDOR_CANCELLABLE = [OrderStates::AWAITING_PAYMENT, OrderStates::CONFIRMED, OrderStates::PROCESSING, OrderStates::CANCELLATION_REQUESTED, OrderStates::READY_FOR_PICKUP, OrderStates::OUT_FOR_DELIVERY];

    public function __construct(
        private readonly OrderAccess $access,
        private readonly CatalogAccess $keys,
        private readonly OrderTransitionService $transitions,
        private readonly CancellationFinalizer $finalizer,
        private readonly CancellationRefundPlanner $planner,
        private readonly OrderEvidenceFiles $files,
        private readonly OrderNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> server-computed preview; never trusted from the client */
    public function buyerPreview(Request $request, string $orderId): array
    {
        $order = $this->access->buyerOrder($request, $orderId);

        return ['availability' => $this->buyerAvailability($order)] + $this->previewPlans($order, 'BUYER');
    }

    /** @return array<string, mixed> */
    public function vendorPreview(Request $request, string $orderId): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CANCEL, 'Only the Owner, Store Manager or Store Staff can cancel orders or finalize cancellation requests.');
        $order = $this->access->vendorOrder($scope, $orderId);
        $open = DB::table('cancellation_requests')->where('order_id', $order->id)->where('state', 'REQUESTED')->first();

        return ['vendor_cancellation' => $this->planner->plan($order, 'VENDOR', false)] + ($open === null ? [] : $this->previewPlans($order, 'BUYER'));
    }

    /** @return array<string, mixed> */
    private function previewPlans(object $order, string $cause): array
    {
        $full = $this->planner->plan($order, $cause, false);
        $retainable = $this->retainableNrpc($order);

        return ['full_refund' => $full, 'with_nrpc_retained' => $retainable > 0 ? $this->planner->plan($order, $cause, true) : null, 'nrpc_retainable_centavos' => $retainable,
            'notice' => 'Calculated by MateryalPH from your original payment amounts and allocations. Vendor withholding tax, commission and provider deductions never reduce your refund.'];
    }

    /** @param array{reason_code?: ?string, reason?: ?string, lock_version: int} $input */
    public function buyerCancel(Request $request, string $orderId, array $input): string
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $preview = $this->access->buyerOrder($request, $orderId);
        if ($preview->order_state === OrderStates::AWAITING_PAYMENT) {
            // Rule out a verified capture first, outside any lock; a payment that arrived confirms the order instead.
            app(PaymentReconciliationService::class)->reconcileOrder((string) $preview->id);
        }

        return DB::transaction(function () use ($request, $orderId, $input, $key): string {
            if ($this->keys->replayed($request, 'ORDER_BUYER_CANCEL', $key, $orderId)) {
                return (string) $this->access->buyerOrder($request, $orderId)->order_state;
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            if ((int) $input['lock_version'] !== (int) $order->lock_version) {
                throw new AuthenticationException('STALE_VERSION', 'This order changed since you opened it. Review its current state before cancelling.', 409, ['lock_version' => (int) $order->lock_version, 'current_state' => $order->order_state]);
            }
            $availability = $this->buyerAvailability($order);
            if (! $availability['available']) {
                throw new AuthenticationException('CANCELLATION_UNAVAILABLE', (string) $availability['explanation'], 409, ['current_state' => $order->order_state, 'remedies' => $availability['remedies']]);
            }
            $actor = OrderActor::buyer($request);
            $mode = (string) $availability['mode'];
            $reasonCode = $mode === 'WITHDRAW' || $mode === 'CANCEL_BEFORE_PAYMENT' ? null : $this->reason(self::BUYER_REASONS, $input);
            $reason = isset($input['reason']) ? trim((string) $input['reason']) : null;
            $kind = match ($mode) {
                'WITHDRAW' => 'WITHDRAWAL', 'CANCEL_BEFORE_PAYMENT' => 'UNPAID_CANCELLATION', 'CANCEL_NOW' => 'BUYER_CANCELLATION', default => 'BUYER_REQUEST',
            };
            $requestId = (string) Str::uuid7();
            DB::table('cancellation_requests')->insert(['id' => $requestId, 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'state' => $kind === 'BUYER_REQUEST' ? 'REQUESTED' : 'FINALIZED',
                'reason' => $reason === '' ? null : $reason, 'payload' => json_encode(['mode' => $mode], JSON_THROW_ON_ERROR), 'kind' => $kind, 'source' => 'BUYER', 'actor_role' => 'BUYER',
                'reason_code' => $reasonCode, 'order_state_at_request' => $order->order_state, 'response_due_at' => $kind === 'BUYER_REQUEST' ? now()->addHours(self::RESPONSE_HOURS) : null,
                'resolved_at' => $kind === 'BUYER_REQUEST' ? null : now(), 'created_at' => now(), 'updated_at' => now()]);
            if ($kind === 'BUYER_REQUEST') {
                $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::CANCELLATION_REQUESTED], $actor, $reasonCode, $reason);
                $due = CarbonImmutable::now()->addHours(self::RESPONSE_HOURS)->setTimezone('Asia/Manila')->format('M j, Y g:i A');
                $this->notifier->vendor($order, 'Cancellation requested for order '.$order->reference, 'The Buyer asked to cancel during preparation ('.strtolower(str_replace('_', ' ', (string) $reasonCode)).'). Finalize it by '.$due
                    .' (Asia/Manila). You may keep the accepted NRPC only by uploading evidence of the actual preparation. Without a response it is finalized automatically with a full refund. Milestones are paused until then.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
                $this->notifier->assignee($order, 'Cancellation requested for order '.$order->reference, 'Pause preparation: the Buyer asked to cancel. Milestones are paused until the request is finalized or withdrawn.');
                $this->notifier->buyer($order, 'Cancellation requested for order '.$order->reference, 'The Vendor has until '.$due.' (Asia/Manila) to finalize it. If they do not respond, it is finalized automatically with a full refund.');
            } else {
                $this->finalizer->finalize($order, $actor, ['cause' => 'BUYER', 'decided_by' => 'BUYER', 'decision_code' => $kind === 'BUYER_CANCELLATION' ? 'BUYER_CANCELLED_BEFORE_PREPARATION' : $kind,
                    'reason_code' => $reasonCode, 'reason' => $reason, 'request_id' => $requestId, 'retain_nrpc' => false, 'evidence_file_id' => null]);
            }
            $this->keys->claim($request, 'ORDER_BUYER_CANCEL', $key, $orderId, 200);
            $this->audit->account($request, $kind === 'BUYER_REQUEST' ? 'ORDER_CANCELLATION_REQUESTED' : 'ORDER_CANCELLED_BY_BUYER', 'ORDER', $orderId, after: ['kind' => $kind, 'reason_code' => $reasonCode]);

            return $kind;
        });
    }

    public function buyerWithdrawRequest(Request $request, string $orderId): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $orderId, $key): void {
            if ($this->keys->replayed($request, 'ORDER_CANCELLATION_WITHDRAW', $key, $orderId)) {
                return;
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            $open = DB::table('cancellation_requests')->where('order_id', $order->id)->where('state', 'REQUESTED')->lockForUpdate()->first();
            if ($open === null || $order->order_state !== OrderStates::CANCELLATION_REQUESTED) {
                throw new AuthenticationException('CANCELLATION_REQUEST_NOT_OPEN', 'There is no open cancellation request to withdraw.', 409);
            }
            DB::table('cancellation_requests')->where('id', $open->id)->update(['state' => 'WITHDRAWN', 'resolved_at' => now(), 'updated_at' => now()]);
            $order = $this->transitions->apply($order, [OrderStates::ORDER => (string) $open->order_state_at_request], OrderActor::buyer($request), 'CANCELLATION_REQUEST_WITHDRAWN');
            $this->keys->claim($request, 'ORDER_CANCELLATION_WITHDRAW', $key, $orderId, 200);
            $this->audit->account($request, 'ORDER_CANCELLATION_REQUEST_WITHDRAWN', 'ORDER', $orderId);
            $this->notifier->vendor($order, 'Cancellation request withdrawn for order '.$order->reference, 'The Buyer withdrew the cancellation request. Continue preparation and record the next milestone.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
            $this->notifier->assignee($order, 'Order '.$order->reference.' continues', 'The Buyer withdrew the cancellation request. Continue preparation.');
        });
    }

    /** Vendor finalizes an open Buyer request; it may retain the accepted NRPC only with preparation evidence. */
    public function vendorFinalize(Request $request, string $orderId, bool $retainNrpc, ?string $note, ?UploadedFile $evidence): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CANCEL, 'Only the Owner, Store Manager or Store Staff can finalize a cancellation request.');
        $key = $this->keys->requireIdempotencyKey($request);
        $preview = $this->access->vendorOrder($scope, $orderId);
        if ($retainNrpc && $evidence === null) {
            throw new AuthenticationException('NRPC_EVIDENCE_REQUIRED', 'Upload evidence of the actual irreversible preparation to retain the NRPC.', 422, ['file' => ['Upload a photo or PDF of the preparation.']]);
        }
        if ($retainNrpc && mb_strlen(trim((string) $note)) < 10) {
            throw new AuthenticationException('NRPC_EVIDENCE_REQUIRED', 'Describe the preparation in at least 10 characters.', 422, ['note' => ['Describe the irreversible preparation.']]);
        }
        $fileId = $evidence === null ? null : $this->files->store($evidence, (string) $preview->id, OrderEvidenceFiles::NRPC, (int) $request->user()->getKey(), false);
        try {
            DB::transaction(function () use ($request, $scope, $orderId, $retainNrpc, $note, $key, $fileId): void {
                if ($this->keys->replayed($request, 'ORDER_CANCELLATION_FINALIZE', $key, $orderId)) {
                    return;
                }
                $order = $this->access->vendorOrder($scope, $orderId, true);
                $open = DB::table('cancellation_requests')->where('order_id', $order->id)->where('state', 'REQUESTED')->lockForUpdate()->first();
                if ($open === null || $order->order_state !== OrderStates::CANCELLATION_REQUESTED) {
                    throw new AuthenticationException('CANCELLATION_REQUEST_NOT_OPEN', 'There is no open cancellation request on this order.', 409);
                }
                if ($retainNrpc && $this->retainableNrpc($order) <= 0) {
                    throw new AuthenticationException('NRPC_NOT_RETAINABLE', 'This order has no accepted NRPC that can be retained.', 422);
                }
                DB::table('cancellation_requests')->where('id', $open->id)->update(['state' => 'FINALIZED', 'resolved_at' => now(), 'updated_at' => now()]);
                $this->finalizer->finalize($order, OrderActor::vendor($request, $scope['role']), ['cause' => 'BUYER', 'decided_by' => 'VENDOR',
                    'decision_code' => $retainNrpc ? 'VENDOR_FINALIZED_NRPC_RETAINED' : 'VENDOR_FINALIZED_FULL_REFUND', 'reason_code' => (string) $open->reason_code,
                    'reason' => $note === null || trim($note) === '' ? $open->reason : trim($note), 'request_id' => (string) $open->id, 'retain_nrpc' => $retainNrpc, 'evidence_file_id' => $fileId]);
                $this->keys->claim($request, 'ORDER_CANCELLATION_FINALIZE', $key, $orderId, 200);
                $this->audit->account($request, 'ORDER_CANCELLATION_FINALIZED', 'ORDER', $orderId, after: ['retain_nrpc' => $retainNrpc]);
            });
        } catch (Throwable $exception) {
            $this->files->discard([$fileId]);
            throw $exception;
        }
    }

    /** @param array{reason_code: string, reason: string, lock_version: int} $input */
    public function vendorCancel(Request $request, string $orderId, array $input): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::CANCEL, 'Only the Owner, Store Manager or Store Staff can cancel an order.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $input, $key): void {
            if ($this->keys->replayed($request, 'ORDER_VENDOR_CANCEL', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            if (! in_array($order->order_state, self::VENDOR_CANCELLABLE, true)) {
                throw new AuthenticationException('CANCELLATION_UNAVAILABLE', $this->vendorExplanation($order), 409, ['current_state' => $order->order_state]);
            }
            if ((int) $input['lock_version'] !== (int) $order->lock_version) {
                throw new AuthenticationException('STALE_VERSION', 'This order changed since you opened it. Refresh and review it before cancelling.', 409, ['lock_version' => (int) $order->lock_version]);
            }
            $reasonCode = $this->reason(self::VENDOR_REASONS, $input);
            if (mb_strlen(trim($input['reason'])) < 10) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Explain the cancellation to the Buyer in at least 10 characters.', 422, ['reason' => ['Explain the cancellation to the Buyer.']]);
            }
            $open = DB::table('cancellation_requests')->where('order_id', $order->id)->where('state', 'REQUESTED')->lockForUpdate()->first();
            if ($open !== null) {
                DB::table('cancellation_requests')->where('id', $open->id)->update(['state' => 'SUPERSEDED', 'resolved_at' => now(), 'updated_at' => now()]);
            }
            $actor = OrderActor::vendor($request, $scope['role']);
            $requestId = (string) Str::uuid7();
            DB::table('cancellation_requests')->insert(['id' => $requestId, 'order_id' => $order->id, 'actor_user_id' => $actor->userId, 'state' => 'FINALIZED', 'reason' => trim($input['reason']),
                'payload' => json_encode(['superseded_request_id' => $open?->id], JSON_THROW_ON_ERROR), 'kind' => 'VENDOR_CANCELLATION', 'source' => 'VENDOR', 'actor_role' => $scope['role'],
                'reason_code' => $reasonCode, 'order_state_at_request' => $order->order_state, 'resolved_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $this->finalizer->finalize($order, $actor, ['cause' => 'VENDOR', 'decided_by' => 'VENDOR', 'decision_code' => 'VENDOR_CANCELLED', 'reason_code' => $reasonCode,
                'reason' => trim($input['reason']), 'request_id' => $requestId, 'retain_nrpc' => false, 'evidence_file_id' => null]);
            $this->keys->claim($request, 'ORDER_VENDOR_CANCEL', $key, $orderId, 200);
            $this->audit->account($request, 'ORDER_CANCELLED_BY_VENDOR', 'ORDER', $orderId, after: ['reason_code' => $reasonCode, 'order_state_before' => $order->order_state]);
        });
    }

    /** Finalizes Buyer requests the Vendor did not answer within 24 hours, with a full refund. @return int finalized */
    public function sweep(int $limit = 100): int
    {
        $count = 0;
        foreach (DB::table('cancellation_requests')->where('state', 'REQUESTED')->where('response_due_at', '<=', now())->orderBy('response_due_at')->limit($limit)->pluck('order_id') as $orderId) {
            try {
                $count += DB::transaction(function () use ($orderId): int {
                    $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
                    $open = DB::table('cancellation_requests')->where('order_id', $orderId)->where('state', 'REQUESTED')->lockForUpdate()->first();
                    if ($order === null || $open === null || $order->order_state !== OrderStates::CANCELLATION_REQUESTED || CarbonImmutable::parse((string) $open->response_due_at)->isFuture()) {
                        return 0;
                    }
                    DB::table('cancellation_requests')->where('id', $open->id)->update(['state' => 'FINALIZED', 'resolved_at' => now(), 'updated_at' => now()]);
                    $this->finalizer->finalize($order, OrderActor::system(), ['cause' => 'BUYER', 'decided_by' => 'SYSTEM', 'decision_code' => 'VENDOR_RESPONSE_TIMEOUT_FULL_REFUND',
                        'reason_code' => (string) $open->reason_code, 'reason' => $open->reason, 'request_id' => (string) $open->id, 'retain_nrpc' => false, 'evidence_file_id' => null]);

                    return 1;
                });
            } catch (Throwable $exception) {
                report($exception);
            }
        }

        return $count;
    }

    /** Accepted NRPC that a Buyer cancellation during preparation may retain; 0 when none was accepted. */
    public function retainableNrpc(object $order): int
    {
        $record = DB::table('nrpc_records')->where('order_id', $order->id)->orderByDesc('order_snapshot_version')->first();
        if ($record === null || ! DB::table('nrpc_acceptances')->where('nrpc_record_id', $record->id)->where('decision', 'ACCEPTED')->exists()) {
            return 0;
        }

        return (int) $order->nrpc_centavos;
    }

    /** @return array<string, mixed> Buyer availability explained in text at every state */
    public function buyerAvailability(object $order): array
    {
        $state = (string) $order->order_state;
        $nrpc = $this->retainableNrpc($order);
        $open = $state === OrderStates::CANCELLATION_REQUESTED ? DB::table('cancellation_requests')->where('order_id', $order->id)->where('state', 'REQUESTED')->first() : null;
        $remedies = static fn (bool $problem): array => array_map(static fn (string $code): array => ['code' => $code, 'available' => $code === 'REPORT_PROBLEM' ? $problem : true,
            'note' => match ($code) {
                'REPORT_PROBLEM' => $problem ? 'Tell the Vendor what is wrong; automatic receipt confirmation pauses while it is open.' : 'Available from Ready for Pickup or Out for Delivery until receipt is confirmed.',
                'DISPUTE' => 'You keep the right to open a dispute through MateryalPH support while the formal case form is being added.',
                'RETURN' => 'Returns for wrong, defective or incomplete items remain available within the return period.',
                'WARRANTY' => 'Any manufacturer or Vendor warranty still applies.',
                default => 'Non-waivable remedies under Philippine consumer law are never limited by this order or its NRPC.',
            }], self::REMEDIES);
        [$mode, $available, $explanation, $remedy] = match (true) {
            $state === OrderStates::AWAITING_VENDOR_CONFIRMATION => ['WITHDRAW', true, 'You can withdraw this request now. Nothing was charged.', null],
            in_array($state, [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE], true) => ['USE_REJECT', false, 'Reject the Vendor\'s proposal to cancel this request. Nothing was charged.', null],
            $state === OrderStates::AWAITING_PAYMENT => ['CANCEL_BEFORE_PAYMENT', true, 'You can cancel before paying. The reserved stock is released and nothing is charged.', null],
            $state === OrderStates::CONFIRMED => ['CANCEL_NOW', true, 'The Vendor has not started preparing. Give a reason and the cancellation is final right away; every amount you paid is refunded to your original payment method.', null],
            $state === OrderStates::PROCESSING => ['REQUEST', true, 'The Vendor is preparing your order. Request cancellation with a reason; the Vendor has 24 hours to finalize it and cannot refuse. '
                .($nrpc > 0 ? 'If they substantiate the preparation they may keep the accepted NRPC of ₱'.WithholdingThresholdService::pesos($nrpc).'; everything else is refunded.' : 'Everything you paid is refunded.'), null],
            $state === OrderStates::CANCELLATION_REQUESTED => ['REQUEST_OPEN', false, 'Your cancellation request is with the Vendor until '.($open === null ? 'the deadline' : CarbonImmutable::parse((string) $open->response_due_at)->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila)')
                .'. Without a response it is finalized automatically with a full refund. You can withdraw the request.', null],
            in_array($state, OrderStates::HANDOVER_STAGE, true) => ['UNAVAILABLE', false, 'Cancellation is no longer available because the order is '.($state === OrderStates::READY_FOR_PICKUP ? 'ready for pickup' : 'out for delivery')
                .'. You can still report a problem, and dispute, return, warranty and statutory remedies remain available.', true],
            in_array($state, OrderStates::AWAITING_RECEIPT, true) => ['UNAVAILABLE', false, 'Cancellation is not available after delivery or pickup. Confirm receipt or report a problem; dispute, return, warranty and statutory remedies remain available.', true],
            $state === OrderStates::COMPLETED || $state === 'DISPUTED' => ['UNAVAILABLE', false, 'This order is complete. Dispute, return, warranty and statutory remedies remain available within their deadlines.', false],
            default => ['CLOSED', false, 'This order is closed.', null],
        };

        return ['mode' => $mode, 'available' => $available, 'explanation' => $explanation, 'requires_reason' => in_array($mode, ['CANCEL_NOW', 'REQUEST'], true),
            'reason_codes' => in_array($mode, ['CANCEL_NOW', 'REQUEST'], true) ? self::BUYER_REASONS : [], 'nrpc_retainable_centavos' => $mode === 'REQUEST' || $mode === 'REQUEST_OPEN' ? $nrpc : 0,
            'can_withdraw_request' => $open !== null, 'response_due_at' => $open?->response_due_at === null ? null : CarbonImmutable::parse((string) $open->response_due_at)->toIso8601String(),
            'remedies' => $remedy === null ? [] : $remedies($remedy)];
    }

    public function vendorExplanation(object $order): string
    {
        return match (true) {
            in_array($order->order_state, self::VENDOR_CANCELLABLE, true) => 'You can cancel with a reason. Every Buyer-paid amount is refunded to the original payment method, any NRPC is forfeited, the stock is released and the cancellation counts toward your Non-Fulfillment Rate.',
            $order->order_state === OrderStates::AWAITING_VENDOR_CONFIRMATION => 'Decline the request instead; nothing is reserved or charged yet.',
            in_array($order->order_state, [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE], true) => 'The Buyer is reviewing your confirmed version; it expires if they do not accept it.',
            in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true) => 'Cancellation is not available after delivery or pickup is recorded. Respond to any reported problem on the order.',
            default => 'This order is closed.',
        };
    }

    /**
     * @param  list<string>  $allowed
     * @param  array<string, mixed>  $input
     */
    private function reason(array $allowed, array $input): string
    {
        $code = (string) ($input['reason_code'] ?? '');
        if (! in_array($code, $allowed, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a cancellation reason.', 422, ['reason_code' => ['Choose a cancellation reason.']]);
        }
        if ($code === 'OTHER' && mb_strlen(trim((string) ($input['reason'] ?? ''))) < 5) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Explain the reason when you choose Other.', 422, ['reason' => ['Explain the reason in at least 5 characters.']]);
        }

        return $code;
    }
}
