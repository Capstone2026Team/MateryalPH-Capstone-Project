<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-10 physical obligations for Cash on Delivery and In-Store Payment. The obligation opens once when the order
 * is confirmed (M + D − N, the NRPC principal counted exactly once); each Vendor-recorded collection appends a
 * record with private evidence; an approved online balance payment appends an ONLINE_BALANCE_CREDIT linked to its
 * verified payment. Records are append-only, the outstanding amount never becomes negative, and a physical record
 * never marks an online payment PAID or fabricates a provider event.
 */
final class PhysicalPaymentService
{
    public const RECORD_PERMISSION = 'payments.record_physical';

    /** The roles holding RECORD_PERMISSION, told when handover cash waits for their confirmation. */
    private const CONFIRM_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF'];

    public function __construct(
        private readonly OrderAccess $orders,
        private readonly CatalogAccess $keys,
        private readonly CatalogFileStore $files,
        private readonly AuditRecorder $audit,
        private readonly OrderNotifier $notifier,
    ) {}

    /** Opens the obligation inside the confirming transaction. Idempotent per order. */
    public function open(object $order, int $nrpcCreditedCentavos): void
    {
        if ($order->payment_method === 'ONLINE' || DB::table('physical_payment_records')->where('order_id', $order->id)->where('record_kind', 'OBLIGATION_OPENED')->exists()) {
            return;
        }
        $obligation = (int) $order->commercial_total_centavos - $nrpcCreditedCentavos;
        DB::table('physical_payment_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'recorded_by_user_id' => null, 'record_kind' => 'OBLIGATION_OPENED',
            'method' => (string) $order->payment_method, 'obligation_before_centavos' => $obligation, 'amount_centavos' => 0, 'remaining_obligation_centavos' => $obligation,
            'state' => 'UNPAID', 'idempotency_key' => 'obligation:'.$order->id, 'recorded_at' => now(), 'recorded_role' => 'SYSTEM',
            'note' => $nrpcCreditedCentavos > 0 ? 'NRPC assurance principal credited once; its processing fee is not credited.' : null, 'created_at' => now(), 'updated_at' => now()]);
    }

    /** Credits a verified ORDER_BALANCE_PAYMENT principal against the obligation, inside the settlement transaction. */
    public function creditOnline(object $order, object $payment): void
    {
        $latest = $this->latest((string) $order->id);
        if ($latest === null || DB::table('physical_payment_records')->where('online_payment_id', $payment->id)->exists()) {
            return;
        }
        $amount = min((int) $payment->principal_centavos, (int) $latest->remaining_obligation_centavos);
        if ($amount <= 0) {
            return;
        }
        $remaining = (int) $latest->remaining_obligation_centavos - $amount;
        DB::table('physical_payment_records')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'recorded_by_user_id' => null, 'record_kind' => 'ONLINE_BALANCE_CREDIT',
            'method' => 'ONLINE', 'obligation_before_centavos' => (int) $latest->remaining_obligation_centavos, 'amount_centavos' => $amount, 'remaining_obligation_centavos' => $remaining,
            'state' => $remaining === 0 ? 'PHYSICAL_PAYMENT_RECORDED' : 'PARTIALLY_RECORDED', 'online_payment_id' => $payment->id, 'idempotency_key' => 'balance-credit:'.$payment->id,
            'recorded_at' => now(), 'recorded_role' => 'SYSTEM', 'created_at' => now(), 'updated_at' => now()]);
    }

    /**
     * Vendor records cash received with private evidence (Owner, Store Manager or Store Staff). Partial collection
     * leaves an outstanding obligation; an amount above the outstanding balance is rejected.
     *
     * @param  array{amount_centavos: int, received_at?: string, note?: ?string}  $input
     * @return array<string, mixed>
     */
    public function record(Request $request, string $orderId, array $input, UploadedFile $evidence): array
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, self::RECORD_PERMISSION, 'Recording physical payments is not available to your role.');
        $key = $this->keys->requireIdempotencyKey($request);
        if ($this->keys->replayed($request, 'PHYSICAL_PAYMENT_RECORD', $key, $orderId)) {
            return $this->summary($this->orders->vendorOrder($scope, $orderId), true);
        }
        $fileId = $this->storeEvidence($request, $scope, $evidence);
        DB::transaction(function () use ($request, $scope, $orderId, $input, $fileId, $key): void {
            $order = $this->orders->vendorOrder($scope, $orderId, true);
            $remaining = $this->openBalance($order);
            $amount = (int) $input['amount_centavos'];
            if ($amount <= 0 || $amount > $remaining) {
                throw new AuthenticationException('PHYSICAL_PAYMENT_EXCEEDS_BALANCE', 'Record an amount above zero and no more than the outstanding balance.', 422, ['amount_centavos' => ['The outstanding balance is ₱'.number_format($remaining / 100, 2).'.']]);
            }
            $receivedAt = isset($input['received_at']) ? CarbonImmutable::parse($input['received_at']) : CarbonImmutable::now();
            $this->collect($request, $order, $remaining, $amount, $fileId, 'physical:'.$scope['organization_id'].':'.$key, $receivedAt->min(CarbonImmutable::now()), $scope['role'],
                isset($input['note']) ? mb_substr((string) $input['note'], 0, 500) : null);
            $this->keys->claim($request, 'PHYSICAL_PAYMENT_RECORD', $key, $orderId, 201);
        });

        return $this->summary($this->orders->vendorOrder($scope, $orderId), true);
    }

    /**
     * Cash the Buyer handed over at Delivered or Picked up, inside the milestone transaction. A recorder who holds the
     * cash permission and attached a handover photo records the collection at once, with that photo as its evidence.
     * Anyone else (Fulfillment Staff) only reports the amount: it waits in the handover proof until an authorized
     * member confirms it, because Fulfillment Staff may evidence a handover but never mark cash collected themselves.
     *
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     * @return 'RECORDED'|'PENDING_CONFIRMATION'|'NONE'
     */
    public function atHandover(Request $request, array $scope, object $order, string $milestone, int $cashCentavos, ?string $photoId): string
    {
        $remaining = $this->outstanding($order);
        if ($cashCentavos <= 0 || $remaining <= 0) {
            return 'NONE';
        }
        $place = $milestone === OrderStates::PICKED_UP ? 'pickup' : 'delivery';
        if ($photoId !== null && OrderAccess::allows($scope, self::RECORD_PERMISSION)) {
            $this->collect($request, $order, $remaining, min($cashCentavos, $remaining), $photoId, 'handover:'.$order->id.':'.$milestone, CarbonImmutable::now(), $scope['role'],
                'Cash received at '.$place.'; the handover photo is the evidence.');

            return 'RECORDED';
        }
        $this->notifier->vendor($order, 'Confirm cash received for order '.$order->reference,
            'The '.$place.' handover reported ₱'.number_format(min($cashCentavos, $remaining) / 100, 2).' received from the Buyer. Confirm it in Order Details → Payment so it counts in your physical collections.', self::CONFIRM_ROLES);

        return 'PENDING_CONFIRMATION';
    }

    /**
     * An authorized member confirms the cash reported at handover. The handover photo is the evidence unless a receipt
     * is attached; a handover without a photo needs one. The collection is recorded once per handover.
     *
     * @return array<string, mixed>
     */
    public function confirmHandover(Request $request, string $orderId, ?UploadedFile $evidence): array
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, self::RECORD_PERMISSION, 'Confirming cash received is not available to your role.');
        $key = $this->keys->requireIdempotencyKey($request);
        if ($this->keys->replayed($request, 'PHYSICAL_HANDOVER_CONFIRM', $key, $orderId)) {
            return $this->summary($this->orders->vendorOrder($scope, $orderId), true);
        }
        $fileId = $evidence === null ? null : $this->storeEvidence($request, $scope, $evidence);
        DB::transaction(function () use ($request, $scope, $orderId, $fileId, $key): void {
            $order = $this->orders->vendorOrder($scope, $orderId, true);
            $remaining = $this->openBalance($order);
            $handover = $this->pendingHandover((string) $order->id);
            if ($handover === null) {
                throw new AuthenticationException('HANDOVER_CASH_NOT_PENDING', 'No reported handover cash is waiting for confirmation on this order.', 409);
            }
            $evidenceId = $fileId ?? ($handover->photo_file_id === null ? null : (string) $handover->photo_file_id);
            if ($evidenceId === null) {
                throw new AuthenticationException('FILE_VALIDATION_FAILED', 'This handover has no photo. Attach a receipt photo to confirm the cash.', 422, ['file' => ['Attach a JPG, PNG, WebP or PDF receipt.']]);
            }
            $place = $handover->event_type === OrderStates::PICKED_UP ? 'pickup' : 'delivery';
            $this->collect($request, $order, $remaining, min($handover->cash_centavos, $remaining), $evidenceId, 'handover:'.$order->id.':'.$handover->event_type,
                CarbonImmutable::parse((string) $handover->occurred_at), $scope['role'], 'Cash reported at '.$place.' by Fulfillment Staff; confirmed by an authorized member.');
            $this->keys->claim($request, 'PHYSICAL_HANDOVER_CONFIRM', $key, $orderId, 201);
        });

        return $this->summary($this->orders->vendorOrder($scope, $orderId), true);
    }

    /** The outstanding physical balance of a handover-stage order, for validating the cash reported with the milestone. */
    public function outstanding(object $order): int
    {
        return $order->payment_method === 'ONLINE' ? 0 : (int) ($this->latest((string) $order->id)->remaining_obligation_centavos ?? 0);
    }

    /**
     * The Buyer acknowledges one Vendor-recorded collection; it is set once and never edited.
     *
     * @return array<string, mixed>
     */
    public function acknowledge(Request $request, string $orderId, string $recordId): array
    {
        $this->keys->requireIdempotencyKey($request);
        $order = $this->orders->buyerOrder($request, $orderId);
        $updated = DB::table('physical_payment_records')->where('id', Str::isUuid($recordId) ? $recordId : '00000000-0000-0000-0000-000000000000')->where('order_id', $order->id)
            ->where('record_kind', 'COLLECTION')->whereNull('buyer_acknowledged_at')->update(['buyer_acknowledged_at' => now(), 'buyer_acknowledged_by_user_id' => $request->user()->getKey(), 'updated_at' => now()]);
        if ($updated === 0 && ! DB::table('physical_payment_records')->where('id', $recordId)->where('order_id', $order->id)->whereNotNull('buyer_acknowledged_at')->exists()) {
            throw new AuthenticationException('PHYSICAL_RECORD_NOT_FOUND', 'This payment record is unavailable.', 404);
        }
        $this->audit->account($request, 'PHYSICAL_PAYMENT_ACKNOWLEDGED', 'ORDER', (string) $order->id, after: ['record_id' => $recordId]);

        return $this->summary($order);
    }

    /** Owner or Manager approves paying the uncollected physical balance online (ORDER_BALANCE_PAYMENT). */
    public function approveOnlineBalance(Request $request, string $orderId): void
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, 'orders.revise', 'Approving an online balance payment is not available to your role.');
        $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId): void {
            $order = $this->orders->vendorOrder($scope, $orderId, true);
            $latest = $this->latest($orderId);
            if ($order->payment_method === 'ONLINE' || $latest === null || (int) $latest->remaining_obligation_centavos <= 0 || OrderStates::isClosed((string) $order->order_state)) {
                throw new AuthenticationException('ONLINE_BALANCE_NOT_AVAILABLE', 'This order has no outstanding physical balance to move online.', 409);
            }
            if ($order->online_balance_approved_at !== null) {
                return;
            }
            DB::table('orders')->where('id', $orderId)->update(['online_balance_approved_at' => now(), 'online_balance_approved_by_user_id' => $request->user()->getKey(), 'lock_version' => (int) $order->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'ONLINE_BALANCE_APPROVED', 'ORDER', $orderId, after: ['remaining_centavos' => (int) $latest->remaining_obligation_centavos]);
            $this->notifier->buyer($order, 'Pay the remaining balance online for order '.$order->reference, 'The Vendor approved paying the uncollected balance of ₱'.number_format((int) $latest->remaining_obligation_centavos / 100, 2).' online. A Payment Processing Fee for that payment is shown before you pay.');
        });
    }

    /**
     * @return array<string, mixed> order-specific physical payment view (operational, not storewide finance); the cash
     *                              reported at handover and awaiting confirmation is a Vendor-only working figure
     */
    public function summary(object $order, bool $forVendor = false): array
    {
        $records = DB::table('physical_payment_records')->where('order_id', $order->id)->orderBy('recorded_at')->orderBy('id')->get();
        // The current record is the lowest remaining amount (see latest()); a back-dated collection must not hide it.
        $latest = $records->sortBy([['remaining_obligation_centavos', 'asc'], ['recorded_at', 'desc']])->first();
        $handover = $forVendor && $order->payment_method !== 'ONLINE' ? $this->pendingHandover((string) $order->id) : null;

        return [
            'applicable' => $order->payment_method !== 'ONLINE', 'method' => (string) $order->payment_method,
            'state' => $latest->state ?? 'NOT_OPEN', 'remaining_centavos' => $latest === null ? null : (int) $latest->remaining_obligation_centavos,
            'online_balance_approved' => $order->online_balance_approved_at !== null,
            'handover_cash' => $handover === null ? null : [
                'reported_centavos' => $handover->cash_centavos, 'confirmable_centavos' => min($handover->cash_centavos, (int) ($latest->remaining_obligation_centavos ?? 0)),
                'milestone' => (string) $handover->event_type, 'reported_at' => CarbonImmutable::parse((string) $handover->occurred_at)->toIso8601String(),
                'has_photo' => $handover->photo_file_id !== null,
            ],
            'records' => $records->map(static fn (object $row): array => [
                'id' => (string) $row->id, 'kind' => (string) $row->record_kind, 'method' => (string) $row->method, 'amount_centavos' => (int) $row->amount_centavos,
                'remaining_centavos' => (int) $row->remaining_obligation_centavos, 'state' => (string) $row->state, 'recorded_at' => CarbonImmutable::parse((string) $row->recorded_at)->toIso8601String(),
                'recorded_role' => $row->recorded_role, 'has_evidence' => $row->evidence_file_id !== null, 'source' => $row->record_kind === 'ONLINE_BALANCE_CREDIT' ? 'VERIFIED_ONLINE_PAYMENT' : ($row->record_kind === 'COLLECTION' ? 'VENDOR_RECORD' : 'SYSTEM'),
                'buyer_acknowledged_at' => $row->buyer_acknowledged_at === null ? null : CarbonImmutable::parse((string) $row->buyer_acknowledged_at)->toIso8601String(),
            ])->values()->all(),
            'notice' => 'Cash on Delivery and In-Store Payment are paid directly to the Vendor. A Vendor record is not an online payment confirmation.',
        ];
    }

    /**
     * The handover whose reported cash is still unconfirmed: the latest Delivered/Picked up proof that reported cash,
     * while a balance remains and no cash collection was recorded since that handover.
     */
    private function pendingHandover(string $orderId): ?object
    {
        $proof = DB::table('fulfillment_proofs')->where('order_id', $orderId)->whereIn('event_type', OrderStates::AWAITING_RECEIPT)
            ->whereRaw("COALESCE((payload->>'cash_received_centavos')::bigint, 0) > 0")->orderByDesc('occurred_at')->orderByDesc('id')->first();
        if ($proof === null || (int) ($this->latest($orderId)->remaining_obligation_centavos ?? 0) <= 0
            || DB::table('physical_payment_records')->where('order_id', $orderId)->where('record_kind', 'COLLECTION')->where('created_at', '>=', $proof->created_at)->exists()) {
            return null;
        }
        $proof->cash_centavos = (int) (json_decode((string) $proof->payload, true)['cash_received_centavos'] ?? 0);

        return $proof;
    }

    /** Locked order with an open physical balance; throws when the order cannot take a cash collection. */
    private function openBalance(object $order): int
    {
        if ($order->payment_method === 'ONLINE' || OrderStates::isClosed((string) $order->order_state) && $order->order_state !== OrderStates::COMPLETED
            || in_array($order->order_state, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT], true)) {
            throw new AuthenticationException('PHYSICAL_PAYMENT_NOT_OPEN', 'This order has no open Cash on Delivery or In-Store Payment balance.', 409);
        }
        $remaining = (int) ($this->latest((string) $order->id)->remaining_obligation_centavos ?? 0);
        if ($remaining <= 0) {
            throw new AuthenticationException('PHYSICAL_PAYMENT_NOT_OPEN', 'This order has no outstanding physical balance.', 409);
        }

        return $remaining;
    }

    /** Appends one evidenced COLLECTION, audits it and asks the Buyer to acknowledge it. Runs inside the caller's transaction. */
    private function collect(Request $request, object $order, int $remaining, int $amount, string $evidenceId, string $idempotencyKey, CarbonImmutable $receivedAt, string $role, ?string $note): void
    {
        $id = (string) Str::uuid7();
        $after = $remaining - $amount;
        DB::table('physical_payment_records')->insert(['id' => $id, 'order_id' => $order->id, 'recorded_by_user_id' => $request->user()->getKey(), 'record_kind' => 'COLLECTION',
            'method' => (string) $order->payment_method, 'obligation_before_centavos' => $remaining, 'amount_centavos' => $amount, 'remaining_obligation_centavos' => $after,
            'state' => $after === 0 ? 'PHYSICAL_PAYMENT_RECORDED' : 'PARTIALLY_RECORDED', 'evidence_file_id' => $evidenceId, 'idempotency_key' => $idempotencyKey,
            'recorded_at' => $receivedAt, 'recorded_role' => $role, 'note' => $note, 'created_at' => now(), 'updated_at' => now()]);
        $this->audit->account($request, 'PHYSICAL_PAYMENT_RECORDED', 'ORDER', (string) $order->id, after: ['record_id' => $id, 'amount_centavos' => $amount, 'remaining_centavos' => $after, 'method' => $order->payment_method]);
        $this->notifier->buyer($order, 'Payment recorded for order '.$order->reference, 'The Vendor recorded ₱'.number_format($amount / 100, 2).' received directly. Remaining balance: ₱'.number_format($after / 100, 2).'. Open the order to acknowledge the record. This is a Vendor record, not an online payment confirmation.');
    }

    /** @param array{organization_id: string} $scope */
    private function storeEvidence(Request $request, array $scope, UploadedFile $evidence): string
    {
        $contentType = (string) $evidence->getMimeType();
        if (! in_array($contentType, ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'], true) || $evidence->getSize() > 10 * 1024 * 1024) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a JPG, PNG, WebP or PDF receipt photo up to 10 MB.', 422, ['file' => ['Upload a JPG, PNG, WebP or PDF up to 10 MB.']]);
        }

        return $this->files->store($evidence, 'VENDOR_ORGANIZATION', $scope['organization_id'], 'PHYSICAL_PAYMENT_EVIDENCE', (int) $request->user()->getKey(), $contentType);
    }

    private function latest(string $orderId): ?object
    {
        // Corrections that increase a balance are not supported, so the current record is the lowest remaining amount.
        return DB::table('physical_payment_records')->where('order_id', $orderId)->orderBy('remaining_obligation_centavos')->orderByDesc('recorded_at')->first();
    }
}
