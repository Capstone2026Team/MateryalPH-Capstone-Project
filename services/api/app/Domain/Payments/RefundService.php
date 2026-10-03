<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Finance\FinanceNotifier;
use App\Domain\Finance\FinancialLedgerService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Provider refunds for every target and trigger (FIN-07): ORDER refunds triggered by CANCELLATION or
 * TECHNICAL_COMPENSATION (DISPUTE_CONCLUSION arrives in Phase 13) and PLATFORM_FEE refunds triggered by FEE_CREDIT.
 *
 *   initiation  the instruction is committed REFUND_PENDING with its outbox event; the provider call runs after
 *               commit, outside every lock, to the original payment request and sub-account only
 *   success     only a verified refund event re-read authoritatively, or reconciliation, sets REFUNDED
 *   failure     a definitive rejection or a verified failed event sets REFUND_FAILED, opens a visible exception
 *               and notifies the Owner; an authorized retry reuses the instruction with the next attempt's key
 *   timeout     the instruction stays REFUND_PENDING; reconciliation resends with the same idempotency key
 *
 * The order's REFUND family is the aggregate of its ORDER instructions and moves only through the shared
 * transition service. Refund targets never exceed the capture less successful and in-flight refunds.
 */
final class RefundService
{
    public function __construct(
        private readonly PaymentGateway $gateway,
        private readonly OrderTransitionService $transitions,
        private readonly OrderNotifier $notifier,
        private readonly FinanceNotifier $finance,
        private readonly FinancialLedgerService $ledger,
        private readonly WithholdingThresholdService $review,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** Publishes the post-commit provider request for a committed instruction. */
    public function queue(string $refundId, string $correlationId): void
    {
        $this->outbox->publish('PAYMENT_REFUND_REQUESTED', 'REFUND', $refundId, ['refund_id' => $refundId, 'correlation_id' => $correlationId]);
    }

    /**
     * Capture less successful and in-flight refunds of one payment, read under the payment row lock so two
     * concurrent instructions can never over-refund it.
     */
    public function refundableBalance(object $lockedPayment): int
    {
        $allocated = (int) DB::table('refunds')->where('source_payment_id', $lockedPayment->id)->whereIn('state', ['REFUND_PENDING', 'REFUNDED'])->sum('amount_centavos');

        return max(0, (int) $lockedPayment->total_centavos - $allocated);
    }

    /** @return string INITIATED | PENDING | FAILED | SKIPPED */
    public function send(string $refundId, string $correlationId): string
    {
        $refund = DB::table('refunds')->where('id', $refundId)->first();
        if ($refund === null || $refund->state !== 'REFUND_PENDING' || $refund->provider_reference !== null) {
            return 'SKIPPED';
        }
        $payment = DB::table('payments')->where('id', $refund->source_payment_id)->first();
        if ($payment === null || $payment->state !== 'PAID' || $payment->provider_payment_request_id === null) {
            // No supported route to the original payment: never redirect a refund elsewhere.
            $this->fail((string) $refund->id, (int) $refund->attempt_number, 'REFUND_ROUTE_UNAVAILABLE', 'SYSTEM', null, $correlationId);

            return 'FAILED';
        }
        $attempt = (int) $refund->attempt_number;
        try {
            $result = $this->gateway->refund(new RefundRequest((string) $refund->id, (string) $payment->provider_payment_request_id, (int) $refund->amount_centavos, 'PHP',
                PaymentReconciliationService::forUserId($payment), self::reason((string) $refund->trigger), $refund->id.':'.$attempt));
        } catch (PaymentProviderException $exception) {
            $this->attempt((string) $refund->id, $attempt, 'CREATE', $exception->kind, $exception->httpStatus, null, ['code' => $exception->safeCode], $correlationId);
            if ($exception->kind === PaymentProviderException::REJECTED) {
                $this->fail((string) $refund->id, $attempt, $exception->safeCode, 'PROVIDER_RESPONSE', null, $correlationId);

                return 'FAILED';
            }
            // Unknown outcome: stay pending; reconciliation resends with the same key, so no second refund is created.
            DB::table('refunds')->where('id', $refund->id)->where('state', 'REFUND_PENDING')->update(['provider_status' => 'UNCERTAIN', 'last_reconciled_at' => now(), 'updated_at' => now()]);

            return 'PENDING';
        }
        $this->attempt((string) $refund->id, $attempt, 'CREATE', 'ACCEPTED', 200, $result->providerRefundId, ['status' => strtoupper($result->status)], $correlationId);
        DB::table('refunds')->where('id', $refund->id)->where('state', 'REFUND_PENDING')->whereNull('provider_reference')
            ->update(['provider_reference' => $result->providerRefundId, 'provider_status' => mb_substr(strtoupper($result->status), 0, 32), 'last_reconciled_at' => now(), 'updated_at' => now()]);

        // Initiation only: REFUNDED or REFUND_FAILED waits for a verified provider event or reconciliation.
        return 'INITIATED';
    }

    /** Authoritative status read for one pending instruction. @return string result code */
    public function reconcile(string $refundId): string
    {
        $refund = DB::table('refunds')->where('id', $refundId)->first();
        if ($refund === null || $refund->state !== 'REFUND_PENDING') {
            return 'SKIPPED';
        }
        $correlation = (string) Str::uuid7();
        if ($refund->provider_reference === null) {
            return $this->send($refundId, $correlation);
        }
        $payment = DB::table('payments')->where('id', $refund->source_payment_id)->first();
        try {
            $provider = $this->gateway->retrieveRefund((string) $refund->provider_reference, PaymentReconciliationService::forUserId($payment));
        } catch (PaymentProviderException $exception) {
            $this->attempt((string) $refund->id, (int) $refund->attempt_number, 'RETRIEVE', 'UNAVAILABLE', $exception->httpStatus, null, ['code' => $exception->safeCode], $correlation);
            DB::table('refunds')->where('id', $refund->id)->where('state', 'REFUND_PENDING')->update(['last_reconciled_at' => now(), 'updated_at' => now()]);

            return 'UNAVAILABLE';
        }

        return $this->apply($refundId, $provider, 'RECONCILIATION', null, $correlation);
    }

    /**
     * Applies an authoritative provider view after checking reference, provider id, original payment, amount and
     * currency. A mismatch changes nothing and opens an exception. Terminal states are final, so duplicate or
     * reordered events are no-ops.
     *
     * @return string REFUNDED | FAILED | PENDING | DUPLICATE | MISMATCH
     */
    public function apply(string $refundId, ProviderRefund $provider, string $source, ?string $webhookEventId, string $correlationId): string
    {
        $refund = DB::table('refunds')->where('id', $refundId)->first();
        if ($refund === null) {
            return 'MISMATCH';
        }
        if (DB::table('refund_attempts')->where('refund_id', $refund->id)->where('provider_refund_id', $provider->providerRefundId)->where('attempt_number', '<', (int) $refund->attempt_number)->exists()) {
            // An event about an earlier, already failed attempt never touches the retried instruction.
            return 'DUPLICATE';
        }
        $payment = DB::table('payments')->where('id', $refund->source_payment_id)->first();
        $mismatch = match (true) {
            $provider->referenceId !== (string) $refund->id => 'REFERENCE_MISMATCH',
            $refund->provider_reference !== null && $provider->providerRefundId !== $refund->provider_reference => 'PROVIDER_ID_MISMATCH',
            $provider->paymentRequestId !== null && $provider->paymentRequestId !== $payment?->provider_payment_request_id => 'PAYMENT_MISMATCH',
            $provider->amountCentavos !== (int) $refund->amount_centavos => 'AMOUNT_MISMATCH',
            $provider->currency !== 'PHP' => 'CURRENCY_MISMATCH',
            default => null,
        };
        if ($mismatch !== null) {
            DB::transaction(fn () => $this->review->reviewItem('TEST', self::organizationOf($refund, $payment), 'REFUND_MISMATCH', (string) $refund->id, $mismatch,
                'A provider refund '.strtolower($source).' did not match the stored refund instruction; nothing changed.',
                ['amount_centavos' => (int) $refund->amount_centavos, 'currency' => 'PHP'], ['amount_centavos' => $provider->amountCentavos, 'currency' => $provider->currency, 'status' => $provider->status], 'REFUND'));

            return 'MISMATCH';
        }
        if ($refund->provider_reference === null) {
            // A timeout-created refund learns its provider id only from an authoritative read that matched above.
            DB::table('refunds')->where('id', $refund->id)->whereNull('provider_reference')->update(['provider_reference' => $provider->providerRefundId, 'updated_at' => now()]);
        }
        if ($provider->succeeded()) {
            return $this->succeed($refundId, $source, $webhookEventId, $correlationId);
        }
        if ($provider->failed()) {
            return $this->fail($refundId, (int) $refund->attempt_number, $provider->failureCode ?? 'PROVIDER_REFUND_FAILED', $source, $webhookEventId, $correlationId) ? 'FAILED' : 'DUPLICATE';
        }
        DB::table('refunds')->where('id', $refund->id)->where('state', 'REFUND_PENDING')->update(['provider_status' => mb_substr($provider->status, 0, 32), 'last_reconciled_at' => now(), 'updated_at' => now()]);

        return 'PENDING';
    }

    private function succeed(string $refundId, string $source, ?string $webhookEventId, string $correlationId): string
    {
        return DB::transaction(function () use ($refundId, $source, $webhookEventId, $correlationId): string {
            $peek = DB::table('refunds')->where('id', $refundId)->first();
            $order = $peek->order_id === null ? null : DB::table('orders')->where('id', $peek->order_id)->lockForUpdate()->first();
            $refund = DB::table('refunds')->where('id', $refundId)->lockForUpdate()->first();
            if ($refund->state !== 'REFUND_PENDING') {
                return 'DUPLICATE';
            }
            DB::table('refunds')->where('id', $refundId)->update(['state' => 'REFUNDED', 'provider_status' => 'SUCCEEDED', 'completed_at' => now(), 'last_reconciled_at' => now(),
                'lock_version' => (int) $refund->lock_version + 1, 'updated_at' => now()]);
            $this->event($refund, 'REFUNDED', $source, $webhookEventId, $correlationId);
            if ($refund->target_type === 'PLATFORM_FEE') {
                $ledgerSource = ['REFUND', (string) $refund->id];
                $this->ledger->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_CREDIT_REFUND', 'PLATFORM_FEE:FEE_CREDIT_REFUND:'.$refund->id, [
                    FinancialLedgerService::debit('FEE_REFUND_PAYABLE', (int) $refund->amount_centavos, ...$ledgerSource),
                    FinancialLedgerService::credit('PROVIDER_COLLECTION_CONTROL', (int) $refund->amount_centavos, ...$ledgerSource),
                ], $correlationId);
                $organization = DB::table('fee_statements')->where('id', $refund->fee_statement_id)->value('vendor_organization_id');
                if ($organization !== null) {
                    $this->finance->owner((string) $organization, 'Platform fee credit refunded', 'The payment provider processed the refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos)
                        .' to the original platform-fee payment method (TEST — no real money moved). Arrival time depends on the payment channel.', true, 'FEE_STATEMENT', (string) $refund->fee_statement_id);
                }

                return 'REFUNDED';
            }
            if ($order !== null) {
                $order = $this->syncOrder($order, OrderActor::system($correlationId), (string) $refund->trigger);
                $this->notifier->buyer($order, 'Refund processed for order '.$order->reference, 'The payment provider processed your refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos)
                    .' to your original payment method (TEST — no real money moved). '.self::arrivalNote($refund));
                $this->notifier->vendor($order, 'Refund processed for order '.$order->reference, 'The payment provider processed the Buyer refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos).'.', ['OWNER', 'STORE_MANAGER']);
            }

            return 'REFUNDED';
        });
    }

    /** @return bool true when the instruction moved to REFUND_FAILED */
    private function fail(string $refundId, int $attempt, string $code, string $source, ?string $webhookEventId, string $correlationId): bool
    {
        return DB::transaction(function () use ($refundId, $attempt, $code, $source, $webhookEventId, $correlationId): bool {
            $peek = DB::table('refunds')->where('id', $refundId)->first();
            $order = $peek->order_id === null ? null : DB::table('orders')->where('id', $peek->order_id)->lockForUpdate()->first();
            $refund = DB::table('refunds')->where('id', $refundId)->lockForUpdate()->first();
            if ($refund->state !== 'REFUND_PENDING' || (int) $refund->attempt_number !== $attempt) {
                return false;
            }
            $safe = mb_substr(preg_replace('/[^A-Z0-9_]/', '_', strtoupper($code)) ?: 'PROVIDER_REFUND_FAILED', 0, 64);
            DB::table('refunds')->where('id', $refundId)->update(['state' => 'REFUND_FAILED', 'failure_code' => $safe, 'provider_status' => 'FAILED', 'last_reconciled_at' => now(),
                'lock_version' => (int) $refund->lock_version + 1, 'updated_at' => now()]);
            $this->event($refund, 'REFUND_FAILED', $source, $webhookEventId, $correlationId);
            $payment = DB::table('payments')->where('id', $refund->source_payment_id)->first();
            $organization = self::organizationOf($refund, $payment);
            $this->review->reviewItem('TEST', $organization, 'REFUND_EXCEPTION', (string) $refund->id, $safe.':ATTEMPT_'.$attempt,
                'A '.strtolower(str_replace('_', ' ', (string) $refund->trigger)).' refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos).' failed ('.$safe.'). It stays visible until an authorized retry after funding or capability is resolved; it was never treated as completed.',
                ['amount_centavos' => (int) $refund->amount_centavos, 'attempt' => $attempt], ['failure_code' => $safe], 'REFUND');
            if ($organization !== null) {
                $this->finance->owner($organization, 'Refund failed — action required', 'A refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos).' could not be completed ('.$safe.'). '
                    .'Resolve funding in your Xendit TEST account, then retry the refund from the order. The Buyer is not asked to pay again.', true, $refund->order_id === null ? 'FEE_STATEMENT' : 'ORDER',
                    (string) ($refund->order_id ?? $refund->fee_statement_id));
            }
            if ($order !== null) {
                $order = $this->syncOrder($order, OrderActor::system($correlationId), 'REFUND_FAILED');
                $this->notifier->buyer($order, 'Refund delayed for order '.$order->reference, 'Your refund of ₱'.WithholdingThresholdService::pesos((int) $refund->amount_centavos)
                    .' could not be completed yet. It stays open and will be retried to your original payment method. You do not need to pay again.');
            }

            return true;
        });
    }

    /**
     * Authorized retry of a failed instruction (Vendor Owner for its own order refunds, or an Admin with
     * refunds.retry). Same instruction, trigger and business key; the next attempt gets a new provider key.
     */
    public function retry(string $refundId, OrderActor $actor, ?string $organizationScope = null): void
    {
        DB::transaction(function () use ($refundId, $actor, $organizationScope): void {
            $peek = DB::table('refunds')->where('id', $refundId)->first();
            if ($peek === null) {
                throw new AuthenticationException('REFUND_NOT_FOUND', 'This refund is unavailable.', 404);
            }
            $order = $peek->order_id === null ? null : DB::table('orders')->where('id', $peek->order_id)->lockForUpdate()->first();
            if ($organizationScope !== null && ($order === null || $order->vendor_organization_id !== $organizationScope)) {
                throw new AuthenticationException('REFUND_NOT_FOUND', 'This refund is unavailable.', 404);
            }
            $refund = DB::table('refunds')->where('id', $refundId)->lockForUpdate()->first();
            if ($refund->state !== 'REFUND_FAILED') {
                throw new AuthenticationException('REFUND_NOT_RETRYABLE', 'Only a failed refund can be retried.', 409, ['state' => $refund->state]);
            }
            $next = (int) $refund->attempt_number + 1;
            DB::table('refunds')->where('id', $refundId)->update(['state' => 'REFUND_PENDING', 'attempt_number' => $next, 'provider_reference' => null, 'provider_status' => null, 'failure_code' => null,
                'lock_version' => (int) $refund->lock_version + 1, 'updated_at' => now()]);
            $this->event((object) ['id' => $refund->id, 'attempt_number' => $next, 'state' => 'REFUND_FAILED'], 'REFUND_PENDING', 'SYSTEM', null, $actor->correlationId);
            DB::table('finance_review_items')->where('kind', 'REFUND_EXCEPTION')->where('source_id', $refundId)->where('state', 'OPEN')
                ->update(['state' => 'RESOLVED', 'resolution' => 'Retried as attempt '.$next.' by '.($actor->role ?? 'SYSTEM').'.', 'resolved_by_user_id' => $actor->userId, 'resolved_at' => now(), 'updated_at' => now()]);
            if ($order !== null) {
                $this->syncOrder($order, $actor, 'REFUND_RETRIED');
            }
            $this->queue($refundId, $actor->correlationId);
        });
    }

    /**
     * Moves the order REFUND family to the aggregate of its ORDER instructions: any pending → REFUND_PENDING; any
     * failed → REFUND_FAILED; all refunded → REFUNDED when every captured order payment is fully returned, otherwise
     * PARTIALLY_REFUNDED. The caller holds the order row lock.
     */
    public function syncOrder(object $order, OrderActor $actor, string $reasonCode): object
    {
        $refunds = DB::table('refunds')->where('order_id', $order->id)->where('target_type', 'ORDER')->get(['state', 'amount_centavos']);
        if ($refunds->isEmpty()) {
            return $order;
        }
        $states = $refunds->pluck('state')->all();
        $target = match (true) {
            in_array('REFUND_PENDING', $states, true) => 'REFUND_PENDING',
            in_array('REFUND_FAILED', $states, true) => 'REFUND_FAILED',
            default => (int) $refunds->sum('amount_centavos') >= (int) DB::table('payments')->where('order_id', $order->id)->where('state', 'PAID')
                ->whereIn('purpose', ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT'])->sum('total_centavos') ? 'REFUNDED' : 'PARTIALLY_REFUNDED',
        };
        if ($order->refund_state === $target || ! OrderStates::allows(OrderStates::REFUND, (string) $order->refund_state, $target)) {
            return $order;
        }

        return $this->transitions->apply($order, [OrderStates::REFUND => $target], $actor, $reasonCode);
    }

    /**
     * FIN-03/FIN-07 own-platform target: an approved credit on an already paid statement is refunded through the
     * original PLATFORM_FEE_PAYMENT captures allocated to that statement, newest first, never above each capture's
     * refundable balance and never from any Buyer payment. Any uncovered remainder stays an audited payable.
     *
     * @return int credit amount covered by refund instructions
     */
    public function createFeeCreditRefunds(object $adjustment, object $assessment, string $correlationId): int
    {
        $remaining = (int) $adjustment->amount_centavos;
        $statements = DB::table('fee_statement_lines as l')->join('fee_statements as s', 's.id', '=', 'l.fee_statement_id')->where('l.fee_assessment_id', $assessment->id)
            ->where('s.state', 'PAID')->orderBy('s.id')->pluck('s.id');
        $covered = 0;
        foreach ($statements as $statementId) {
            $allocations = DB::table('fee_payment_allocations as a')->join('payments as p', 'p.id', '=', 'a.payment_id')->where('a.fee_statement_id', $statementId)
                ->where('p.state', 'PAID')->where('p.purpose', 'PLATFORM_FEE_PAYMENT')->orderByDesc('a.allocated_at')->orderByDesc('p.id')->get(['p.id', 'a.amount_centavos']);
            foreach ($allocations as $allocation) {
                if ($remaining <= 0) {
                    break;
                }
                $payment = DB::table('payments')->where('id', $allocation->id)->lockForUpdate()->first();
                $amount = min($remaining, (int) $allocation->amount_centavos, $this->refundableBalance($payment));
                if ($amount <= 0) {
                    continue;
                }
                $refundId = (string) Str::uuid7();
                $inserted = DB::table('refunds')->insertOrIgnore(['id' => $refundId, 'target_type' => 'PLATFORM_FEE', 'order_id' => null, 'fee_statement_id' => $statementId, 'fee_adjustment_id' => $adjustment->id,
                    'source_payment_id' => $payment->id, 'trigger' => 'FEE_CREDIT', 'amount_centavos' => $amount, 'principal_centavos' => $amount, 'processing_fee_centavos' => 0,
                    'source_captured_centavos' => (int) $payment->total_centavos, 'prior_allocated_centavos' => (int) $payment->total_centavos - $this->refundableBalance($payment),
                    'state' => 'REFUND_PENDING', 'idempotency_key' => 'fee-credit:'.$adjustment->id.':'.$payment->id, 'environment' => 'TEST', 'evidence_origin' => $payment->evidence_origin,
                    'reason_code' => 'APPROVED_FEE_CREDIT', 'requested_at' => now(), 'allocation' => json_encode(['fee_assessment_id' => (string) $assessment->id], JSON_THROW_ON_ERROR),
                    'created_at' => now(), 'updated_at' => now()]);
                if ($inserted === 0) {
                    continue;
                }
                $this->event((object) ['id' => $refundId, 'attempt_number' => 1, 'state' => null], 'REFUND_PENDING', 'SYSTEM', null, $correlationId);
                $this->queue($refundId, $correlationId);
                $remaining -= $amount;
                $covered += $amount;
            }
        }

        return $covered;
    }

    /** @return array<string, int> */
    public function sweep(int $limit = 100): array
    {
        $counts = ['sent' => 0, 'reconciled' => 0];
        $due = DB::table('refunds')->where('state', 'REFUND_PENDING')->where(fn ($query) => $query->whereNull('last_reconciled_at')->orWhere('last_reconciled_at', '<', now()->subMinute()))
            ->where('created_at', '<', now()->subSeconds((int) config('payments.reconcile_after_seconds', 120)))->orderBy('created_at')->limit($limit)->get(['id', 'provider_reference']);
        foreach ($due as $row) {
            try {
                $this->reconcile((string) $row->id);
                $counts[$row->provider_reference === null ? 'sent' : 'reconciled']++;
            } catch (Throwable $exception) {
                report($exception);
            }
        }

        return $counts;
    }

    /** Channel-dependent expectation without promising that funds already arrived. */
    public static function arrivalNote(object $refund): string
    {
        $kind = DB::table('payments as p')->join('payment_channel_fee_versions as v', 'v.id', '=', 'p.channel_fee_version_id')->where('p.id', $refund->source_payment_id)->value('v.channel_kind');

        return match ($kind) {
            'CARD' => 'Card refunds can take several banking days to appear, depending on your card issuer.',
            'EWALLET' => 'E-wallet refunds appear after the e-wallet completes them; timing depends on the e-wallet.',
            default => 'Timing depends on the original payment channel.',
        };
    }

    public static function reason(string $trigger): string
    {
        return match ($trigger) {
            'CANCELLATION' => 'Cancellation refund for a cancelled order',
            'TECHNICAL_COMPENSATION' => 'Technical compensation: capture after the payment attempt closed',
            'FEE_CREDIT' => 'Approved platform fee credit',
            default => 'Refund',
        };
    }

    private static function organizationOf(object $refund, ?object $payment): ?string
    {
        if ($refund->order_id !== null) {
            return (string) DB::table('orders')->where('id', $refund->order_id)->value('vendor_organization_id');
        }

        return $payment?->vendor_organization_id === null ? null : (string) $payment->vendor_organization_id;
    }

    /** @param array<string, mixed> $safe */
    private function attempt(string $refundId, int $attempt, string $operation, string $state, ?int $httpStatus, ?string $providerRefundId, array $safe, string $correlationId): void
    {
        DB::table('refund_attempts')->insert(['id' => (string) Str::uuid7(), 'refund_id' => $refundId, 'provider_event_id' => null, 'state' => mb_substr($state, 0, 24),
            'safe_payload' => json_encode($safe, JSON_THROW_ON_ERROR), 'attempt_number' => $attempt, 'operation' => $operation, 'http_status' => $httpStatus,
            'provider_refund_id' => $providerRefundId, 'correlation_id' => mb_substr($correlationId, 0, 64), 'created_at' => now(), 'updated_at' => now()]);
    }

    /** One event per instruction, attempt and state: a duplicate provider event is a no-op. */
    public function event(object $refund, string $to, string $source, ?string $webhookEventId, string $correlationId): void
    {
        DB::table('refund_events')->insertOrIgnore(['id' => (string) Str::uuid7(), 'refund_id' => $refund->id, 'provider_event_id' => null, 'state' => $to, 'from_state' => $refund->state ?? null,
            'attempt_number' => (int) ($refund->attempt_number ?? 1), 'source' => $source, 'webhook_event_id' => $webhookEventId, 'correlation_id' => mb_substr($correlationId, 0, 64),
            'safe_payload' => json_encode(['state' => $to], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
    }
}
