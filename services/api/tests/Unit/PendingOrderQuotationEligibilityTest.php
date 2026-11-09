<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Messaging\PendingOrderQuotationService;
use PHPUnit\Framework\TestCase;

final class PendingOrderQuotationEligibilityTest extends TestCase
{
    public function test_only_a_pending_unconfirmed_unpaid_request_is_eligible(): void
    {
        $pending = (object) ['order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'accepted_at' => null, 'accepted_snapshot_version' => null, 'payment_state' => 'NOT_REQUIRED'];
        self::assertTrue(PendingOrderQuotationService::eligible($pending));
        foreach (['AWAITING_PAYMENT', 'CONFIRMED', 'PROCESSING', 'CANCELLED', 'COMPLETED'] as $state) {
            self::assertFalse(PendingOrderQuotationService::eligible((object) array_replace((array) $pending, ['order_state' => $state])));
        }
        foreach (['accepted_at' => '2026-11-05T00:00:00Z', 'accepted_snapshot_version' => 1, 'payment_state' => 'PAID'] as $field => $value) {
            self::assertFalse(PendingOrderQuotationService::eligible((object) array_replace((array) $pending, [$field => $value])));
        }
        self::assertFalse(PendingOrderQuotationService::eligible(null));
    }
}
