<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderNotifier;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * FIN-07 physical remedy for cash the Buyer already paid the Vendor directly on a cancelled order:
 * VENDOR_REIMBURSEMENT_PENDING → REIMBURSEMENT_CONFIRMED. The Vendor records the reimbursement with private evidence;
 * it is confirmed only by the Buyer's acknowledgment or an authorized Admin's reasoned decision. It is never a Xendit
 * refund, never waits for a provider webhook, and never returns cash through an unrelated online payment.
 */
final class ReimbursementService
{
    public const DECIDE_PERMISSION = 'reimbursements.decide';

    public function __construct(
        private readonly OrderAccess $orders,
        private readonly CatalogAccess $keys,
        private readonly OrderEvidenceFiles $files,
        private readonly OrderNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /** @param array{reimbursed_at?: ?string, note?: ?string} $input */
    public function record(Request $request, string $orderId, string $reimbursementId, array $input, UploadedFile $evidence): void
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, PhysicalPaymentService::RECORD_PERMISSION, 'Recording a cash reimbursement is not available to your role.');
        $key = $this->keys->requireIdempotencyKey($request);
        $order = $this->orders->vendorOrder($scope, $orderId);
        $fileId = $this->files->store($evidence, (string) $order->id, OrderEvidenceFiles::REIMBURSEMENT, (int) $request->user()->getKey(), false);
        try {
            DB::transaction(function () use ($request, $scope, $orderId, $reimbursementId, $input, $key, $fileId): void {
                if ($this->keys->replayed($request, 'REIMBURSEMENT_RECORD', $key, $orderId)) {
                    return;
                }
                $order = $this->orders->vendorOrder($scope, $orderId, true);
                $row = DB::table('physical_reimbursements')->where('id', Str::isUuid($reimbursementId) ? $reimbursementId : '00000000-0000-0000-0000-000000000000')->where('order_id', $order->id)->lockForUpdate()->first();
                if ($row === null) {
                    throw new AuthenticationException('REIMBURSEMENT_NOT_FOUND', 'This reimbursement is unavailable.', 404);
                }
                if ($row->state !== 'VENDOR_REIMBURSEMENT_PENDING' || $row->evidence_file_id !== null) {
                    throw new AuthenticationException('REIMBURSEMENT_ALREADY_RECORDED', 'This reimbursement already has evidence recorded.', 409);
                }
                $at = isset($input['reimbursed_at']) ? CarbonImmutable::parse((string) $input['reimbursed_at'])->min(CarbonImmutable::now()) : CarbonImmutable::now();
                DB::table('physical_reimbursements')->where('id', $row->id)->update(['evidence_file_id' => $fileId, 'reimbursed_at' => $at, 'recorded_by_user_id' => $request->user()->getKey(),
                    'recorded_role' => $scope['role'], 'vendor_note' => isset($input['note']) ? mb_substr(trim((string) $input['note']), 0, 500) : null, 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
                $this->keys->claim($request, 'REIMBURSEMENT_RECORD', $key, $orderId, 200);
                $this->audit->account($request, 'CASH_REIMBURSEMENT_RECORDED', 'ORDER', $orderId, after: ['reimbursement_id' => (string) $row->id, 'amount_centavos' => (int) $row->amount_centavos]);
                $this->notifier->buyer($order, 'Confirm your cash reimbursement for order '.$order->reference, 'The Vendor recorded returning ₱'.number_format((int) $row->amount_centavos / 100, 2)
                    .' that you paid directly. Confirm it on the order once you have received it. This is a Vendor record, not a payment-provider refund.');
            });
        } catch (Throwable $exception) {
            $this->files->discard([$fileId]);
            throw $exception;
        }
    }

    public function acknowledge(Request $request, string $orderId, string $reimbursementId): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $orderId, $reimbursementId, $key): void {
            if ($this->keys->replayed($request, 'REIMBURSEMENT_ACKNOWLEDGE', $key, $orderId)) {
                return;
            }
            $order = $this->orders->buyerOrder($request, $orderId, true);
            $row = DB::table('physical_reimbursements')->where('id', Str::isUuid($reimbursementId) ? $reimbursementId : '00000000-0000-0000-0000-000000000000')->where('order_id', $order->id)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('REIMBURSEMENT_NOT_FOUND', 'This reimbursement is unavailable.', 404);
            }
            if ($row->state !== 'VENDOR_REIMBURSEMENT_PENDING' || $row->evidence_file_id === null) {
                throw new AuthenticationException('REIMBURSEMENT_NOT_READY', 'You can confirm after the Vendor records the reimbursement.', 409);
            }
            DB::table('physical_reimbursements')->where('id', $row->id)->update(['state' => 'REIMBURSEMENT_CONFIRMED', 'buyer_acknowledged_at' => now(), 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            $this->keys->claim($request, 'REIMBURSEMENT_ACKNOWLEDGE', $key, $orderId, 200);
            $this->audit->account($request, 'CASH_REIMBURSEMENT_ACKNOWLEDGED', 'ORDER', $orderId, after: ['reimbursement_id' => (string) $row->id]);
            $this->notifier->vendor($order, 'Cash reimbursement confirmed for order '.$order->reference, 'The Buyer confirmed receiving the cash reimbursement.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
        });
    }

    /** An authorized Admin records a reasoned confirmation when the Buyer cannot or does not acknowledge. */
    public function decide(Request $request, string $reimbursementId, string $reason): void
    {
        $this->keys->requireAdmin($request, self::DECIDE_PERMISSION);
        DB::transaction(function () use ($request, $reimbursementId, $reason): void {
            $row = DB::table('physical_reimbursements')->where('id', Str::isUuid($reimbursementId) ? $reimbursementId : '00000000-0000-0000-0000-000000000000')->lockForUpdate()->first();
            if ($row === null || $row->order_id === null) {
                throw new AuthenticationException('REIMBURSEMENT_NOT_FOUND', 'This reimbursement is unavailable.', 404);
            }
            if ($row->state !== 'VENDOR_REIMBURSEMENT_PENDING' || $row->evidence_file_id === null) {
                throw new AuthenticationException('REIMBURSEMENT_NOT_READY', 'Only a pending reimbursement with Vendor evidence can be confirmed.', 409);
            }
            DB::table('physical_reimbursements')->where('id', $row->id)->update(['state' => 'REIMBURSEMENT_CONFIRMED', 'confirmed_by_user_id' => $request->user()->getKey(),
                'confirmation_reason' => mb_substr(trim($reason), 0, 2000), 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'CASH_REIMBURSEMENT_CONFIRMED_BY_ADMIN', 'ORDER', (string) $row->order_id, after: ['reimbursement_id' => (string) $row->id], reason: $reason);
            $order = DB::table('orders')->where('id', $row->order_id)->first();
            $this->notifier->buyer($order, 'Cash reimbursement confirmed for order '.$order->reference, 'MateryalPH reviewed the Vendor\'s evidence and recorded the cash reimbursement as completed.');
        });
    }
}
