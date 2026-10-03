<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Fulfillment\FulfillmentRecords;
use App\Domain\Orders\CancellationService;
use App\Domain\Orders\OrderStates;
use App\Domain\Payments\ProviderRefund;
use App\Domain\Payments\RefundRequest;
use PHPUnit\Framework\TestCase;

/** Phase 12 state, timer and refund-status rules that must not drift from the workflows and owner decisions. */
final class PhaseTwelveRulesTest extends TestCase
{
    public function test_fulfillment_milestones_follow_the_shared_order_lifecycle(): void
    {
        foreach ([['CONFIRMED', 'PROCESSING'], ['PROCESSING', 'READY_FOR_PICKUP'], ['PROCESSING', 'OUT_FOR_DELIVERY'], ['READY_FOR_PICKUP', 'PICKED_UP'], ['OUT_FOR_DELIVERY', 'DELIVERED'],
            ['PICKED_UP', 'COMPLETED'], ['DELIVERED', 'COMPLETED']] as [$from, $to]) {
            self::assertTrue(OrderStates::allows(OrderStates::ORDER, $from, $to), $from.' → '.$to);
        }
        foreach ([['CONFIRMED', 'READY_FOR_PICKUP'], ['PROCESSING', 'PICKED_UP'], ['READY_FOR_PICKUP', 'DELIVERED'], ['OUT_FOR_DELIVERY', 'PICKED_UP'], ['PICKED_UP', 'CANCELLED'],
            ['DELIVERED', 'CANCELLED'], ['COMPLETED', 'CANCELLED'], ['CANCELLATION_REQUESTED', 'OUT_FOR_DELIVERY'], ['CANCELLED', 'PROCESSING']] as [$from, $to]) {
            self::assertFalse(OrderStates::allows(OrderStates::ORDER, $from, $to), $from.' → '.$to.' must be rejected');
        }
        self::assertSame(['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'], OrderStates::HANDOVER_STAGE);
        self::assertSame(['DELIVERED', 'PICKED_UP'], OrderStates::AWAITING_RECEIPT);
    }

    public function test_refund_family_leaves_pending_only_through_provider_outcomes_and_retries_from_failure(): void
    {
        self::assertTrue(OrderStates::allows(OrderStates::REFUND, 'NOT_REQUESTED', 'REFUND_PENDING'));
        self::assertTrue(OrderStates::allows(OrderStates::REFUND, 'REFUND_PENDING', 'REFUNDED'));
        self::assertTrue(OrderStates::allows(OrderStates::REFUND, 'REFUND_PENDING', 'REFUND_FAILED'));
        self::assertTrue(OrderStates::allows(OrderStates::REFUND, 'REFUND_FAILED', 'REFUND_PENDING'));
        self::assertFalse(OrderStates::allows(OrderStates::REFUND, 'NOT_REQUESTED', 'REFUNDED'), 'Initiation is never success.');
        self::assertFalse(OrderStates::allows(OrderStates::REFUND, 'REFUNDED', 'REFUND_FAILED'), 'A refunded order never fails afterwards.');
    }

    public function test_provider_refund_status_mapping_and_per_attempt_idempotency(): void
    {
        self::assertTrue((new ProviderRefund('rfd-1', 'ref', 'pr', 'SUCCEEDED', 100, 'PHP'))->succeeded());
        self::assertTrue((new ProviderRefund('rfd-1', 'ref', 'pr', 'FAILED', 100, 'PHP'))->failed());
        self::assertTrue((new ProviderRefund('rfd-1', 'ref', 'pr', 'CANCELLED', 100, 'PHP'))->failed());
        $pending = new ProviderRefund('rfd-1', 'ref', 'pr', 'PENDING', 100, 'PHP');
        self::assertFalse($pending->succeeded() || $pending->failed(), 'PENDING is neither success nor failure.');
        self::assertSame('refund-id', (new RefundRequest('refund-id', 'pr', 100, 'PHP', null, 'Cancellation refund'))->idempotencyKey);
        self::assertSame('refund-id:2', (new RefundRequest('refund-id', 'pr', 100, 'PHP', null, 'Cancellation refund', 'refund-id:2'))->idempotencyKey);
    }

    public function test_owner_approved_timers_and_workflow_reason_codes(): void
    {
        self::assertSame(48, FulfillmentRecords::RECEIPT_WINDOW_HOURS, 'Approved by the project owner on 2026-10-02.');
        self::assertSame(24, CancellationService::RESPONSE_HOURS, 'Approved by the project owner on 2026-10-02.');
        self::assertSame(['CHANGE_OF_REQUIREMENT', 'DUPLICATE_ORDER', 'BUDGET_CHANGE', 'PROJECT_DELAY', 'SCHEDULE_CONFLICT', 'VENDOR_AGREEMENT', 'OTHER'], CancellationService::BUYER_REASONS);
        self::assertSame(['STOCK_FAILURE', 'OPERATIONAL_INABILITY', 'DELIVERY_INABILITY', 'COMPLIANCE_RESTRICTION', 'ACCOUNT_RESTRICTION', 'BUYER_AGREEMENT', 'OTHER'], CancellationService::VENDOR_REASONS);
        self::assertSame(['REPORT_PROBLEM', 'DISPUTE', 'RETURN', 'WARRANTY', 'STATUTORY_REMEDIES'], CancellationService::REMEDIES);
    }
}
