<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Finance\FinancialLedgerService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The only path that marks a payment PAID: an authoritative provider session (fetched by the selected adapter
 * after a verified webhook, or by scheduled reconciliation) whose identifier, reference, amount, currency and
 * account all match the stored attempt. A redirect, a Vendor cash record or an unverified callback never reaches
 * this class. Orders and statements are locked before the payment row; there is no network call under any lock.
 *
 * A capture proven after the attempt or order had already closed (late capture) is still recorded as PAID evidence
 * but confirms nothing: it creates one idempotent TECHNICAL_COMPENSATION refund for an order payment, or an audited
 * overpayment item for a platform-fee payment.
 */
final class PaymentSettlement
{
    public const OPEN_STATES = ['CREATING', 'PENDING', 'UNCERTAIN'];

    public function __construct(
        private readonly OrderTransitionService $transitions,
        private readonly OrderNotifier $notifier,
        private readonly PhysicalPaymentService $physical,
        private readonly FinancialLedgerService $ledger,
        private readonly WithholdingThresholdService $review,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** @return string APPLIED | DUPLICATE | LATE_CAPTURE_COMPENSATED | CLOSED | PENDING | MISMATCH */
    public function apply(string $paymentId, ProviderSession $session, string $source, ?string $webhookEventId, string $correlationId): string
    {
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        if ($payment === null) {
            return 'MISMATCH';
        }
        $mismatch = $this->mismatch($payment, $session);
        if ($mismatch !== null) {
            $this->exception($payment, $session, $mismatch, $source);

            return 'MISMATCH';
        }
        if ($session->completed()) {
            return $this->captured($paymentId, $session, $source, $webhookEventId, $correlationId);
        }
        if ($session->closedWithoutPayment()) {
            return $this->closed($paymentId, $session, $source, $webhookEventId, $correlationId);
        }

        return 'PENDING';
    }

    /** Field checks before any state change. Returns a reason code, or null when everything matches. */
    public function mismatch(object $payment, ProviderSession $session): ?string
    {
        return match (true) {
            $session->referenceId !== (string) $payment->id => 'REFERENCE_MISMATCH',
            $payment->provider_session_id !== null && $session->sessionId !== $payment->provider_session_id => 'SESSION_ID_MISMATCH',
            $session->currency !== (string) $payment->currency => 'CURRENCY_MISMATCH',
            $session->amountCentavos !== null && $session->amountCentavos !== (int) $payment->total_centavos => 'AMOUNT_MISMATCH',
            $session->completed() && $session->amountCentavos === null => 'AMOUNT_MISSING',
            $session->businessId !== null && $this->expectedBusiness($payment) !== null && $session->businessId !== $this->expectedBusiness($payment) => 'ACCOUNT_MISMATCH',
            default => null,
        };
    }

    private function captured(string $paymentId, ProviderSession $session, string $source, ?string $webhookEventId, string $correlationId): string
    {
        // A compensation refund leaves through the outbox after commit, never under these locks.
        return DB::transaction(function () use ($paymentId, $session, $source, $webhookEventId, $correlationId): string {
            $payment = DB::table('payments')->where('id', $paymentId)->first();
            $order = $payment->order_id === null ? null : DB::table('orders')->where('id', $payment->order_id)->lockForUpdate()->first();
            $statement = $payment->fee_statement_id === null ? null : DB::table('fee_statements')->where('id', $payment->fee_statement_id)->lockForUpdate()->first();
            $payment = DB::table('payments')->where('id', $paymentId)->lockForUpdate()->first();
            if ($payment->state === 'PAID') {
                return 'DUPLICATE';
            }
            $late = ! in_array($payment->state, self::OPEN_STATES, true) || $this->purposeClosed($payment, $order, $statement);
            DB::table('payments')->where('id', $paymentId)->update([
                'state' => 'PAID', 'paid_at' => now(), 'provider_session_id' => $session->sessionId, 'provider_reference' => $session->sessionId,
                'provider_payment_id' => $session->paymentId, 'provider_payment_request_id' => $session->paymentRequestId, 'late_capture' => $late,
                'reconciliation_state' => $late ? 'EXCEPTION' : 'RECONCILED', 'last_reconciled_at' => now(), 'lock_version' => (int) $payment->lock_version + 1, 'updated_at' => now(),
            ]);
            $this->event($paymentId, (string) $payment->state, 'PAID', $source, $webhookEventId, $session, $correlationId);
            $payment = DB::table('payments')->where('id', $paymentId)->first();
            if ($late) {
                $this->compensate($payment, $order, $correlationId);

                return 'LATE_CAPTURE_COMPENSATED';
            }
            if ($order !== null) {
                $this->confirmOrder($order, $payment, $correlationId);
            } elseif ($statement !== null) {
                $this->allocateStatement($statement, $payment, $correlationId);
            }
            $this->outbox->publish('PAYMENT_CAPTURED', 'PAYMENT', $paymentId, ['payment_id' => $paymentId, 'purpose' => (string) $payment->purpose, 'evidence_origin' => (string) $payment->evidence_origin, 'correlation_id' => $correlationId]);

            return 'APPLIED';
        });
    }

    private function closed(string $paymentId, ProviderSession $session, string $source, ?string $webhookEventId, string $correlationId): string
    {
        return DB::transaction(function () use ($paymentId, $session, $source, $webhookEventId, $correlationId): string {
            $payment = DB::table('payments')->where('id', $paymentId)->lockForUpdate()->first();
            if (! in_array($payment->state, self::OPEN_STATES, true)) {
                return 'DUPLICATE';
            }
            $state = $session->status === 'CANCELED' ? 'CANCELLED' : 'EXPIRED';
            DB::table('payments')->where('id', $paymentId)->update(['state' => $state, $state === 'CANCELLED' ? 'cancelled_at' : 'expired_at' => now(), 'provider_session_id' => $session->sessionId,
                'reconciliation_state' => 'RECONCILED', 'last_reconciled_at' => now(), 'lock_version' => (int) $payment->lock_version + 1, 'updated_at' => now()]);
            $this->event($paymentId, (string) $payment->state, $state, $source, $webhookEventId, $session, $correlationId);

            return 'CLOSED';
        });
    }

    private function confirmOrder(object $order, object $payment, string $correlationId): void
    {
        $actor = OrderActor::system($correlationId);
        if (in_array($payment->purpose, ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT'], true)) {
            $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::CONFIRMED, OrderStates::PAYMENT => 'PAID'], $actor, 'PAYMENT_VERIFIED', null, ['payment_expires_at' => null]);
            if ($payment->purpose === 'NRPC_ASSURANCE_PAYMENT') {
                // The NRPC principal is credited once against the physical balance; its processing fee is not.
                $this->physical->open($order, (int) $payment->principal_centavos);
            }
            $this->notifier->buyer($order, 'Payment verified for order '.$order->reference, 'Your '.self::label((string) $payment->purpose).' of ₱'.number_format((int) $payment->total_centavos / 100, 2)
                .' was verified by the payment provider (TEST — no real charge). The order is confirmed.');
            $this->notifier->vendor($order, 'Payment verified for order '.$order->reference, 'The Buyer\'s online payment was verified. The order is confirmed and ready for preparation.');
        } elseif ($payment->purpose === 'ORDER_BALANCE_PAYMENT') {
            $this->physical->creditOnline($order, $payment);
            $this->notifier->buyer($order, 'Balance payment verified for order '.$order->reference, 'Your online balance payment was verified (TEST — no real charge).');
            $this->notifier->vendor($order, 'Balance payment verified for order '.$order->reference, 'The Buyer paid the remaining balance online and the provider verified it.');
        }
    }

    /** FIN-03: allocate a verified platform-fee payment to its statement; the platform absorbs its own charge. */
    private function allocateStatement(object $statement, object $payment, string $correlationId): void
    {
        $outstanding = (int) $statement->outstanding_centavos;
        $amount = min((int) $payment->principal_centavos, $outstanding);
        if ($amount > 0) {
            DB::table('fee_payment_allocations')->insertOrIgnore(['id' => (string) Str::uuid7(), 'fee_statement_id' => $statement->id, 'payment_id' => $payment->id, 'amount_centavos' => $amount,
                'statement_outstanding_before_centavos' => $outstanding, 'payment_unallocated_before_centavos' => (int) $payment->principal_centavos, 'allocated_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $paid = (int) $statement->paid_centavos + $amount;
            $balance = (int) $statement->charges_centavos - (int) $statement->credits_centavos - $paid;
            DB::table('fee_statements')->where('id', $statement->id)->update(['paid_centavos' => $paid, 'balance_centavos' => $balance, 'outstanding_centavos' => $balance,
                'state' => $balance === 0 ? 'PAID' : 'PARTIALLY_PAID', 'lock_version' => (int) $statement->lock_version + 1, 'updated_at' => now()]);
            $source = ['FEE_PAYMENT', (string) $payment->id];
            $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_PAYMENT', 'PLATFORM_FEE:PAYMENT:'.$payment->id, [
                FinancialLedgerService::debit('PROVIDER_COLLECTION_CONTROL', $amount, ...$source), FinancialLedgerService::credit('FEE_RECEIVABLE', $amount, ...$source),
            ], $correlationId);
            $charge = (int) ($payment->provider_charge_centavos ?? 0);
            $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_PAYMENT_CHARGE', 'PLATFORM_FEE:PAYMENT_CHARGE:'.$payment->id, [
                FinancialLedgerService::debit('PLATFORM_PROCESSING_EXPENSE', $charge, ...$source), FinancialLedgerService::credit('PROVIDER_COLLECTION_CONTROL', $charge, ...$source),
            ], $correlationId);
        }
        if ((int) $payment->principal_centavos > $amount) {
            $this->review->reviewItem('TEST', (string) $statement->vendor_organization_id, 'FEE_OVERPAYMENT', (string) $payment->id, 'PAYMENT_EXCEEDS_OUTSTANDING',
                'A verified platform-fee payment exceeded the statement outstanding amount. Record an audited payable; no automatic charge or balance is created.',
                ['outstanding_centavos' => $outstanding], ['paid_centavos' => (int) $payment->principal_centavos], 'PAYMENT');
        }
    }

    /** A proven capture after the attempt or order closed: one idempotent compensation, never a confirmed order. */
    private function compensate(object $payment, ?object $order, string $correlationId): void
    {
        if ($payment->purpose === 'PLATFORM_FEE_PAYMENT' || $order === null) {
            $this->review->reviewItem('TEST', (string) $payment->vendor_organization_id ?: null, 'FEE_OVERPAYMENT', (string) $payment->id, 'LATE_CAPTURE',
                'A platform-fee payment was captured after its attempt closed or its statement was settled. Record an audited payable or a refund through the original payment.',
                ['state_before_capture' => 'CLOSED'], ['captured_centavos' => (int) $payment->total_centavos], 'PAYMENT');

            return;
        }
        $refundId = (string) Str::uuid7();
        $inserted = DB::table('refunds')->insertOrIgnore(['id' => $refundId, 'target_type' => 'ORDER', 'order_id' => $order->id, 'source_payment_id' => $payment->id, 'trigger' => 'TECHNICAL_COMPENSATION',
            'amount_centavos' => (int) $payment->total_centavos, 'source_captured_centavos' => (int) $payment->total_centavos, 'prior_allocated_centavos' => 0, 'state' => 'REFUND_PENDING',
            'idempotency_key' => 'technical-compensation:'.$payment->id, 'environment' => 'TEST', 'evidence_origin' => $payment->evidence_origin, 'reason_code' => 'CAPTURE_AFTER_ATTEMPT_CLOSED',
            'requested_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        if ($inserted === 0) {
            return;
        }
        if (in_array($order->refund_state, ['NOT_REQUESTED', 'PARTIALLY_REFUNDED', 'REFUND_FAILED'], true)) {
            $this->transitions->apply($order, [OrderStates::REFUND => 'REFUND_PENDING'], OrderActor::system($correlationId), 'TECHNICAL_COMPENSATION');
        }
        $this->review->reviewItem('TEST', (string) $order->vendor_organization_id, 'LATE_CAPTURE_COMPENSATION', (string) $payment->id, 'CAPTURE_AFTER_ATTEMPT_CLOSED',
            'A payment was captured after its attempt or order had closed. A technical-compensation refund of the full captured amount was queued; the order was not confirmed.',
            ['order_state' => (string) $order->order_state], ['captured_centavos' => (int) $payment->total_centavos], 'PAYMENT');
        $this->notifier->buyer($order, 'Late payment will be refunded for order '.$order->reference, 'A payment for this order arrived after its payment window closed. MateryalPH queued a full refund to the original payment method (TEST — no real charge). The order was not confirmed by this payment.');
        // RefundService sends it after commit; success waits for a verified provider event or reconciliation.
        $this->outbox->publish('PAYMENT_REFUND_REQUESTED', 'REFUND', $refundId, ['refund_id' => $refundId, 'correlation_id' => $correlationId]);
    }

    private function purposeClosed(object $payment, ?object $order, ?object $statement): bool
    {
        if ($payment->purpose === 'PLATFORM_FEE_PAYMENT') {
            return $statement === null || ! in_array($statement->state, ['ISSUED', 'PARTIALLY_PAID'], true) || (int) $statement->outstanding_centavos <= 0;
        }
        if ($order === null) {
            return true;
        }
        if (in_array($payment->purpose, ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT'], true)) {
            return $order->order_state !== OrderStates::AWAITING_PAYMENT || $order->payment_state !== 'PENDING'
                || DB::table('payments')->where('order_id', $order->id)->where('purpose', $payment->purpose)->where('state', 'PAID')->where('late_capture', false)->where('id', '<>', $payment->id)->exists();
        }

        return OrderStates::isClosed((string) $order->order_state) || app(PayableAmounts::class)->remainingObligation((string) $order->id) < (int) $payment->principal_centavos;
    }

    private function expectedBusiness(object $payment): ?string
    {
        return $payment->account_scope === 'PLATFORM_ACCOUNT' ? self::platformAccount() : (string) $payment->provider_account_id;
    }

    public static function platformAccount(): ?string
    {
        $id = config('services.xendit.platform_account_id');

        return is_string($id) && trim($id) !== '' ? trim($id) : null;
    }

    private function exception(object $payment, ProviderSession $session, string $reason, string $source): void
    {
        DB::transaction(function () use ($payment, $session, $reason, $source): void {
            DB::table('payments')->where('id', $payment->id)->update(['reconciliation_state' => 'EXCEPTION', 'last_reconciled_at' => now(), 'updated_at' => now()]);
            $this->review->reviewItem('TEST', $payment->vendor_organization_id === null ? null : (string) $payment->vendor_organization_id, 'PAYMENT_MISMATCH', (string) $payment->id, $reason,
                'A provider '.strtolower($source).' did not match the stored payment attempt; nothing was marked paid.',
                ['session_id' => $payment->provider_session_id, 'total_centavos' => (int) $payment->total_centavos, 'currency' => (string) $payment->currency],
                ['session_id' => $session->sessionId, 'amount_centavos' => $session->amountCentavos, 'currency' => $session->currency, 'status' => $session->status], 'PAYMENT');
        });
    }

    private function event(string $paymentId, string $from, string $to, string $source, ?string $webhookEventId, ProviderSession $session, string $correlationId): void
    {
        DB::table('payment_events')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $paymentId, 'provider_event_id' => null, 'state' => $to, 'from_state' => $from, 'source' => $source,
            'webhook_event_id' => $webhookEventId, 'correlation_id' => mb_substr($correlationId, 0, 64), 'safe_payload' => json_encode(['session_status' => $session->status,
                'amount_centavos' => $session->amountCentavos, 'currency' => $session->currency, 'has_payment_id' => $session->paymentId !== null], JSON_THROW_ON_ERROR),
            'created_at' => now(), 'updated_at' => now()]);
    }

    public static function label(string $purpose): string
    {
        return match ($purpose) {
            'FULL_ORDER_PAYMENT' => 'full order payment', 'NRPC_ASSURANCE_PAYMENT' => 'NRPC assurance payment',
            'ORDER_BALANCE_PAYMENT' => 'balance payment', default => 'platform fee payment',
        };
    }
}
