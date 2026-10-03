<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Payments\RefundService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * One timeline per original online payment plus any Vendor cash reimbursement and released unpaid balance. A refund
 * reads QUEUED or INITIATED until verified provider evidence makes it PROCESSED; a failure reads FAILED with the
 * Buyer never asked to pay again; an uncollected balance reads No longer due, never Refunded. Provider identifiers,
 * account ids and raw payloads never leave the API.
 */
final class OrderRefundTimeline
{
    /** @return array<string, mixed> */
    public function present(object $order, bool $forVendor, string $filePrefix): array
    {
        $refunds = DB::table('refunds as r')->join('payments as p', 'p.id', '=', 'r.source_payment_id')->leftJoin('payment_channel_fee_versions as v', 'v.id', '=', 'p.channel_fee_version_id')
            ->where('r.order_id', $order->id)->where('r.target_type', 'ORDER')->orderBy('r.created_at')->orderBy('r.id')
            ->get(['r.*', 'p.purpose as payment_purpose', 'v.display_name as channel_name', 'p.channel_code']);
        $decision = DB::table('cancellation_decisions')->where('order_id', $order->id)->first();
        $released = (int) DB::table('physical_payment_records')->where('order_id', $order->id)->where('record_kind', 'CANCELLATION_RELEASE')->sum('obligation_before_centavos');

        return [
            'refunds' => $refunds->map(fn (object $refund): array => $this->refund($refund, $forVendor))->values()->all(),
            'reimbursements' => DB::table('physical_reimbursements')->where('order_id', $order->id)->orderBy('created_at')->get()->map(static fn (object $row): array => [
                'id' => (string) $row->id, 'state' => (string) $row->state, 'amount_centavos' => (int) $row->amount_centavos, 'method' => (string) $row->method,
                'reimbursed_at' => self::iso($row->reimbursed_at), 'buyer_acknowledged_at' => self::iso($row->buyer_acknowledged_at), 'has_evidence' => $row->evidence_file_id !== null,
                'evidence_path' => $row->evidence_file_id === null ? null : $filePrefix.$row->evidence_file_id, 'confirmed_by_review' => $row->confirmed_by_user_id !== null,
                'message' => $row->state === 'REIMBURSEMENT_CONFIRMED' ? 'Cash reimbursement confirmed.' : ($row->evidence_file_id === null
                    ? 'The Vendor must return the cash you paid directly and record evidence. This is separate from any online refund.'
                    : 'The Vendor recorded returning this cash. Confirm once you have received it.'),
            ])->values()->all(),
            'no_longer_due_centavos' => $released,
            'decision' => $decision === null ? null : [
                'cause' => (string) $decision->cause, 'decided_by' => (string) $decision->decided_by, 'decision_code' => (string) $decision->decision_code, 'reason_code' => $decision->reason_code,
                'reason' => $decision->reason, 'nrpc_retained_centavos' => (int) $decision->nrpc_retained_centavos, 'refund_total_centavos' => (int) $decision->refund_total_centavos,
                'cash_reimbursement_centavos' => (int) $decision->cash_reimbursement_centavos, 'released_unpaid_centavos' => (int) $decision->released_unpaid_centavos,
                'order_state_before' => (string) $decision->order_state_before, 'decided_at' => self::iso($decision->created_at), 'nrpc_evidence_on_file' => $decision->evidence_file_id !== null,
                'nrpc_evidence_path' => $forVendor && $decision->evidence_file_id !== null ? $filePrefix.$decision->evidence_file_id : null,
            ],
        ];
    }

    /** @return array<string, mixed> */
    private function refund(object $refund, bool $forVendor): array
    {
        $display = match (true) {
            $refund->state === 'REFUNDED' => 'PROCESSED',
            $refund->state === 'REFUND_FAILED' => 'FAILED',
            $refund->provider_reference === null => 'QUEUED',
            default => 'INITIATED',
        };

        return [
            'id' => (string) $refund->id, 'trigger' => (string) $refund->trigger, 'state' => (string) $refund->state, 'display_state' => $display,
            'amount_centavos' => (int) $refund->amount_centavos, 'principal_centavos' => $refund->principal_centavos === null ? null : (int) $refund->principal_centavos,
            'processing_fee_centavos' => (int) $refund->processing_fee_centavos, 'payment_purpose' => (string) $refund->payment_purpose,
            'original_method' => $refund->channel_name === null ? 'Original payment method' : (string) $refund->channel_name, 'attempt_number' => (int) $refund->attempt_number,
            'requested_at' => self::iso($refund->requested_at ?? $refund->created_at), 'completed_at' => self::iso($refund->completed_at),
            'failure_code' => $forVendor ? $refund->failure_code : null, 'evidence_origin' => $refund->evidence_origin,
            'can_retry' => false, 'arrival_note' => $display === 'PROCESSED' ? RefundService::arrivalNote($refund) : null,
            'message' => match ($display) {
                'PROCESSED' => 'Refund processed by the payment provider to your original payment method. It may take time to appear.',
                'FAILED' => $forVendor ? 'The refund failed. Resolve funding in the Xendit TEST account, then retry it from this order.' : 'The refund could not be completed yet. It stays open and will be retried. You do not need to pay again.',
                'QUEUED' => 'Refund queued for the payment provider.',
                default => 'Refund initiated with the payment provider. Waiting for the provider to confirm it.',
            },
        ];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
