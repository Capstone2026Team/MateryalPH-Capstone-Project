<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Finance\FinancialSnapshotService;
use App\Domain\Operations\OutboxPublisher;
use Carbon\CarbonImmutable;

/**
 * Finalizes the commercial version both parties accepted: freezes the FIN-02 financial snapshot, records the
 * ESTIMATED FIN-03 fee assessment and moves the order to AWAITING_PAYMENT or CONFIRMED. Online payment and any
 * NRPC assurance payment open the 45-minute payment window on entering AWAITING_PAYMENT (approved by the
 * project owner on 2026-09-29). Physical payment without NRPC confirms at once; payment stays NOT_REQUIRED.
 */
final class OrderAcceptance
{
    public const PAYMENT_WINDOW_MINUTES = 45;

    public function __construct(
        private readonly FinancialSnapshotService $finance,
        private readonly FeeAssessmentService $fees,
        private readonly OrderTransitionService $transitions,
        private readonly OrderNotifier $notifier,
        private readonly OutboxPublisher $outbox,
    ) {}

    public static function requiresOnlinePayment(object $order, int $nrpcCentavos): bool
    {
        return $order->payment_method === 'ONLINE' || $nrpcCentavos > 0;
    }

    /** @param array<string, mixed> $commercial */
    public function accept(object $order, object $snapshot, array $commercial, ?string $nrpcRecordId, OrderActor $actor, string $reasonCode): object
    {
        $frozen = $this->finance->freeze($order, $snapshot, $commercial, $nrpcRecordId);
        $this->fees->estimate($order, $frozen['id'], $frozen['fee_policy_version_id'], $frozen['materials_exclusive_centavos'], $actor->correlationId);
        $online = self::requiresOnlinePayment($order, (int) $commercial['nrpc_centavos']);
        $expires = $online ? CarbonImmutable::now()->addMinutes(self::PAYMENT_WINDOW_MINUTES) : null;
        $changes = [OrderStates::ORDER => $online ? OrderStates::AWAITING_PAYMENT : OrderStates::CONFIRMED] + ($online ? [OrderStates::PAYMENT => 'PENDING'] : []);
        $order = $this->transitions->apply($order, $changes, $actor, $reasonCode, null, [
            'accepted_at' => now(), 'accepted_snapshot_version' => (int) $snapshot->version, 'buyer_response_due_at' => null, 'payment_expires_at' => $expires,
        ], (int) $snapshot->version);
        $this->outbox->publish('ORDER_ACCEPTED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'financial_snapshot_id' => $frozen['id'], 'snapshot_version' => (int) $snapshot->version]);
        if ($expires !== null) {
            $this->notifier->buyer($order, 'Order '.$order->reference.' is ready for payment', 'Pay by '.$expires->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Philippine time) to keep the reserved stock. After that the order expires and the stock is released.');
        } else {
            $this->notifier->buyer($order, 'Order '.$order->reference.' is confirmed', 'The Vendor confirmed your order. You pay the Vendor directly on delivery or pickup.');
        }

        return $order;
    }
}
