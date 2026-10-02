<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Finance\Money;
use App\Domain\Orders\OrderStates;
use Illuminate\Support\Facades\DB;

/**
 * Server-side payable principal per purpose, from the immutable accepted financial snapshot only — never from a
 * client amount or a current listing price (FIN-02):
 *
 *   FULL_ORDER_PAYMENT      M + D of the accepted snapshot (the Buyer fee F is added per attempt)
 *   NRPC_ASSURANCE_PAYMENT  N, allocated to its affected material lines; never added on top of M
 *   ORDER_BALANCE_PAYMENT   the uncollected physical balance M + D − N − recorded collections, after Vendor approval
 *
 * A purpose that already has a verified PAID collection is never charged again.
 */
final class PayableAmounts
{
    /** @return array{purpose: string, principal_centavos: int, financial_snapshot_id: string, breakdown: array<string, int|string|null>}|null */
    public function resolve(object $order): ?array
    {
        $snapshot = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->first();
        if ($snapshot === null) {
            return null;
        }
        if ($order->order_state === OrderStates::AWAITING_PAYMENT && $order->payment_state === 'PENDING') {
            $nrpc = (int) $snapshot->nrpc_centavos;
            $purpose = $order->payment_method === 'ONLINE' ? 'FULL_ORDER_PAYMENT' : ($nrpc > 0 ? 'NRPC_ASSURANCE_PAYMENT' : null);
            if ($purpose === null || $this->paid((string) $order->id, $purpose)) {
                return null;
            }
            $principal = $purpose === 'FULL_ORDER_PAYMENT' ? (int) $snapshot->buyer_total_centavos : $nrpc;

            return ['purpose' => $purpose, 'principal_centavos' => $principal, 'financial_snapshot_id' => (string) $snapshot->id, 'breakdown' => $purpose === 'FULL_ORDER_PAYMENT'
                ? ['materials_centavos' => (int) $snapshot->materials_payable_centavos, 'included_vat_centavos' => (int) $snapshot->materials_vat_centavos,
                    'delivery_centavos' => (int) $snapshot->delivery_centavos, 'nrpc_included_centavos' => $nrpc]
                : ['nrpc_centavos' => $nrpc, 'physical_balance_after_centavos' => (int) $snapshot->buyer_total_centavos - $nrpc]];
        }
        if ($order->online_balance_approved_at !== null && $order->payment_method !== 'ONLINE' && ! OrderStates::isClosed((string) $order->order_state)
            && ! in_array($order->order_state, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, 'CANCELLATION_REQUESTED', 'DISPUTED'], true)) {
            $remaining = $this->remainingObligation((string) $order->id);
            if ($remaining <= 0) {
                return null;
            }

            return ['purpose' => 'ORDER_BALANCE_PAYMENT', 'principal_centavos' => $remaining, 'financial_snapshot_id' => (string) $snapshot->id,
                'breakdown' => ['remaining_balance_centavos' => $remaining] + $this->balanceAllocation($snapshot, (string) $order->id, $remaining)];
        }

        return null;
    }

    public function paid(string $orderId, string $purpose): bool
    {
        return DB::table('payments')->where('order_id', $orderId)->where('purpose', $purpose)->where('state', 'PAID')->where('late_capture', false)->exists();
    }

    /** The current physical obligation: the latest record's remaining amount, or null before it opens. */
    public function remainingObligation(string $orderId): int
    {
        $latest = DB::table('physical_payment_records')->where('order_id', $orderId)->orderBy('remaining_obligation_centavos')->first(['remaining_obligation_centavos']);

        return $latest === null ? 0 : (int) $latest->remaining_obligation_centavos;
    }

    /**
     * Allocates a balance collection between remaining materials and remaining delivery by largest remainder, after
     * prior collections were allocated the same way, so delivery and VAT are excluded from the CWT base exactly once.
     *
     * @return array{delivery_allocated_centavos: int, materials_allocated_centavos: int, vat_allocated_centavos: int}
     */
    public function balanceAllocation(object $snapshot, string $orderId, int $amount): array
    {
        $nrpc = (int) $snapshot->nrpc_centavos;
        $nrpcVat = (int) DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->sum('nrpc_vat_centavos');
        $materials = (int) $snapshot->materials_payable_centavos - $nrpc;
        $delivery = (int) $snapshot->delivery_centavos;
        $vat = (int) $snapshot->materials_vat_centavos - $nrpcVat;
        $obligation = $materials + $delivery;
        $collected = max(0, $obligation - $this->remainingObligation($orderId));
        $prior = $collected === 0 ? ['materials' => 0, 'delivery' => 0] : Money::allocate($collected, ['materials' => $materials, 'delivery' => $delivery]);
        $remainingMaterials = $materials - $prior['materials'];
        $remainingDelivery = $delivery - $prior['delivery'];
        $share = Money::allocate($amount, ['materials' => $remainingMaterials, 'delivery' => $remainingDelivery]);
        $priorVat = $materials === 0 ? 0 : Money::proportion($vat, $prior['materials'], $materials);
        $remainingVat = $vat - $priorVat;
        // The final principal collection takes every remaining VAT centavo so allocations sum to the original VAT.
        $shareVat = $share['materials'] === $remainingMaterials ? $remainingVat : ($remainingMaterials === 0 ? 0 : Money::proportion($remainingVat, $share['materials'], $remainingMaterials));

        return ['delivery_allocated_centavos' => $share['delivery'], 'materials_allocated_centavos' => $share['materials'], 'vat_allocated_centavos' => $shareVat];
    }
}
