<?php

declare(strict_types=1);

namespace App\Domain\Orders;

/**
 * The five independent order-related state families and their allowed transitions. Order states follow the
 * System Workflow lifecycle; payment and refund follow the payment lifecycle; fulfillment mirrors the order's
 * fulfillment milestones; dispute follows the dispute state machine. No family implies another.
 */
final class OrderStates
{
    public const ORDER = 'ORDER';

    public const PAYMENT = 'PAYMENT';

    public const FULFILLMENT = 'FULFILLMENT';

    public const REFUND = 'REFUND';

    public const DISPUTE = 'DISPUTE';

    public const AWAITING_VENDOR_CONFIRMATION = 'AWAITING_VENDOR_CONFIRMATION';

    public const AWAITING_BUYER_APPROVAL = 'AWAITING_BUYER_APPROVAL';

    public const AWAITING_NRPC_ACCEPTANCE = 'AWAITING_NRPC_ACCEPTANCE';

    public const AWAITING_PAYMENT = 'AWAITING_PAYMENT';

    public const CONFIRMED = 'CONFIRMED';

    public const DECLINED = 'DECLINED';

    public const EXPIRED = 'EXPIRED';

    public const CANCELLED = 'CANCELLED';

    public const COMPLETED = 'COMPLETED';

    public const PROCESSING = 'PROCESSING';

    public const READY_FOR_PICKUP = 'READY_FOR_PICKUP';

    public const OUT_FOR_DELIVERY = 'OUT_FOR_DELIVERY';

    public const DELIVERED = 'DELIVERED';

    public const PICKED_UP = 'PICKED_UP';

    public const CANCELLATION_REQUESTED = 'CANCELLATION_REQUESTED';

    /** Buyer cancellation is unavailable here; Report a Problem, dispute and statutory remedies remain. */
    public const HANDOVER_STAGE = [self::READY_FOR_PICKUP, self::OUT_FOR_DELIVERY];

    /** Fulfillment proof recorded; Buyer receipt confirmation or the 48-hour auto-confirmation is pending. */
    public const AWAITING_RECEIPT = [self::DELIVERED, self::PICKED_UP];

    /** Orders whose commercial terms are not yet accepted by both parties. */
    public const PENDING_ACCEPTANCE = [self::AWAITING_VENDOR_CONFIRMATION, self::AWAITING_BUYER_APPROVAL, self::AWAITING_NRPC_ACCEPTANCE];

    /** Terminal states before fulfillment. */
    public const CLOSED_BEFORE_FULFILLMENT = [self::DECLINED, self::EXPIRED, self::CANCELLED];

    /** Orders that hold a hard reservation until payment, fulfillment or release. */
    public const RESERVING = [self::AWAITING_BUYER_APPROVAL, self::AWAITING_NRPC_ACCEPTANCE, self::AWAITING_PAYMENT, self::CONFIRMED, 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'CANCELLATION_REQUESTED'];

    /** @var array<string, array<string, list<string>>> from => allowed next states, per family */
    private const TRANSITIONS = [
        self::ORDER => [
            '' => [self::AWAITING_VENDOR_CONFIRMATION],
            self::AWAITING_VENDOR_CONFIRMATION => [self::AWAITING_BUYER_APPROVAL, self::AWAITING_NRPC_ACCEPTANCE, self::AWAITING_PAYMENT, self::CONFIRMED, self::DECLINED, self::EXPIRED, self::CANCELLED],
            self::AWAITING_BUYER_APPROVAL => [self::AWAITING_NRPC_ACCEPTANCE, self::AWAITING_PAYMENT, self::CONFIRMED, self::EXPIRED, self::CANCELLED],
            self::AWAITING_NRPC_ACCEPTANCE => [self::AWAITING_PAYMENT, self::EXPIRED, self::CANCELLED],
            self::AWAITING_PAYMENT => [self::CONFIRMED, self::EXPIRED, self::CANCELLED],
            self::CONFIRMED => ['PROCESSING', 'CANCELLATION_REQUESTED', self::CANCELLED, 'DISPUTED'],
            'PROCESSING' => ['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'CANCELLATION_REQUESTED', self::CANCELLED, 'DISPUTED'],
            // Only a Vendor cancellation may close an order at the handover stage; the Buyer path is blocked in the service.
            'READY_FOR_PICKUP' => ['PICKED_UP', self::CANCELLED, 'DISPUTED'],
            'OUT_FOR_DELIVERY' => ['DELIVERED', self::CANCELLED, 'DISPUTED'],
            'PICKED_UP' => [self::COMPLETED, 'DISPUTED'],
            'DELIVERED' => [self::COMPLETED, 'DISPUTED'],
            // No milestone advances while a cancellation request is open; withdrawal returns to the prior state.
            'CANCELLATION_REQUESTED' => [self::CANCELLED, self::CONFIRMED, 'PROCESSING'],
            'DISPUTED' => [self::COMPLETED, self::CANCELLED],
        ],
        self::PAYMENT => [
            'NOT_REQUIRED' => ['PENDING'],
            'PENDING' => ['PAID', 'FAILED', 'EXPIRED', 'NOT_REQUIRED'],
            'FAILED' => ['PENDING', 'EXPIRED'],
            'EXPIRED' => ['PENDING'],
        ],
        self::FULFILLMENT => [
            'NOT_STARTED' => ['PROCESSING'],
            'PROCESSING' => ['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'],
            'READY_FOR_PICKUP' => ['PICKED_UP'],
            'OUT_FOR_DELIVERY' => ['DELIVERED'],
        ],
        // The aggregate of every refund instruction of the order; only verified provider evidence leaves PENDING.
        self::REFUND => [
            'NOT_REQUESTED' => ['REFUND_PENDING'],
            'REFUND_PENDING' => ['PARTIALLY_REFUNDED', 'REFUNDED', 'REFUND_FAILED'],
            'PARTIALLY_REFUNDED' => ['REFUND_PENDING'],
            'REFUND_FAILED' => ['REFUND_PENDING'],
        ],
        self::DISPUTE => [
            'NONE' => ['OPEN_AWAITING_RESPONSE'],
            'OPEN_AWAITING_RESPONSE' => ['MUTUAL_RESOLUTION', 'ESCALATED_ADMIN_REVIEW'],
            'MUTUAL_RESOLUTION' => ['RESOLVED'],
            'ESCALATED_ADMIN_REVIEW' => ['AWAITING_CLARIFICATION', 'DECIDED', 'CLOSED_INCONCLUSIVE'],
            'AWAITING_CLARIFICATION' => ['ESCALATED_ADMIN_REVIEW', 'DECIDED', 'CLOSED_INCONCLUSIVE'],
            'DECIDED' => ['APPEAL_OPEN', 'RESOLVED'],
            'APPEAL_OPEN' => ['DECIDED', 'RESOLVED'],
        ],
    ];

    /** Column that stores each family on the orders row. */
    public const COLUMNS = [self::ORDER => 'order_state', self::PAYMENT => 'payment_state', self::FULFILLMENT => 'fulfillment_state', self::REFUND => 'refund_state', self::DISPUTE => 'dispute_state'];

    public static function allows(string $family, ?string $from, string $to): bool
    {
        return in_array($to, self::TRANSITIONS[$family][$from ?? ''] ?? [], true);
    }

    public static function isClosed(string $orderState): bool
    {
        return in_array($orderState, [...self::CLOSED_BEFORE_FULFILLMENT, self::COMPLETED], true);
    }
}
