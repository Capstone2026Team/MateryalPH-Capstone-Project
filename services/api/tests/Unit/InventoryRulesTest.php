<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Inventory\AutoAcceptGate;
use App\Domain\Inventory\AutoAcceptPolicyService;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Inventory\StockConfirmationPolicy;
use Carbon\CarbonImmutable;
use PHPUnit\Framework\TestCase;

final class InventoryRulesTest extends TestCase
{
    public function test_public_label_uses_available_to_sell_and_the_reorder_level_only(): void
    {
        self::assertSame('70.0000', StockAvailability::availableToSell('100', '30'));
        self::assertSame('OUT_OF_STOCK', StockAvailability::label(null, null));
        self::assertSame('OUT_OF_STOCK', StockAvailability::label('0.0000', null));
        self::assertSame('OUT_OF_STOCK', StockAvailability::label('-1.0000', '5'));
        self::assertSame('IN_STOCK', StockAvailability::label('0.0001', null));
        self::assertSame('LIMITED_STOCK', StockAvailability::label('5.0000', '5.0000'));
        self::assertSame('LIMITED_STOCK', StockAvailability::label('0.5000', '0.9'));
        self::assertSame('IN_STOCK', StockAvailability::label('5.0001', '5'));
        self::assertSame(['IN_STOCK', 'LIMITED_STOCK', 'OUT_OF_STOCK'], StockAvailability::LABELS);
    }

    public function test_stale_stock_schedule_uses_exact_instants_for_day_7_12_and_15(): void
    {
        $confirmed = '2026-10-01T06:00:00+08:00';
        $at = static fn (string $local): CarbonImmutable => CarbonImmutable::parse($local, 'Asia/Manila');
        self::assertSame('CONFIRMED', StockConfirmationPolicy::schedule($confirmed, $at('2026-10-08 05:59:59'))['state']);
        self::assertSame('REMINDER', StockConfirmationPolicy::schedule($confirmed, $at('2026-10-08 06:00:00'))['state']);
        self::assertSame('FINAL_REMINDER', StockConfirmationPolicy::schedule($confirmed, $at('2026-10-13 06:00:00'))['state']);
        self::assertSame('FINAL_REMINDER', StockConfirmationPolicy::schedule($confirmed, $at('2026-10-16 05:59:59'))['state']);
        $overdue = StockConfirmationPolicy::schedule($confirmed, $at('2026-10-16 06:00:00'));
        self::assertSame('OVERDUE', $overdue['state']);
        self::assertSame('2026-10-15T22:00:00+00:00', $overdue['hide_at']);
        self::assertSame(15, $overdue['days_since_confirmation']);
        self::assertSame('NOT_CONFIRMED', StockConfirmationPolicy::schedule(null)['state']);
        self::assertTrue(StockConfirmationPolicy::isStale(null));
    }

    public function test_auto_accept_gate_admits_only_complete_item_based_orders_without_nrpc(): void
    {
        $policy = ['status' => AutoAcceptPolicyService::STATUS_ACTIVE, 'remaining_allotment_quantity' => '10', 'max_unit_count' => '5.0000', 'max_order_amount_centavos' => 100000];
        $order = ['procurement_type' => 'ITEM_BASED', 'nrpc_centavos' => 0, 'commercial_total_centavos' => 90000, 'lines' => [['listing_variant_id' => 'a', 'quantity' => '5', 'tax_category' => 'VAT_12']]];
        self::assertTrue(AutoAcceptGate::evaluate($order, ['a' => $policy], ['a' => '50'])['eligible']);
        $codes = static fn (array $result): array => array_column($result['reasons'], 'code');

        self::assertSame(['PROJECT_BASED_NOT_ELIGIBLE'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['procurement_type' => 'PROJECT_BASED']), ['a' => $policy], ['a' => '50'])));
        self::assertSame(['NRPC_REQUIRES_MANUAL_REVIEW'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['nrpc_centavos' => 1]), ['a' => $policy], ['a' => '50'])));
        self::assertSame(['AMOUNT_CAP_EXCEEDED'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['commercial_total_centavos' => 100001]), ['a' => $policy], ['a' => '50'])));
        self::assertSame(['UNIT_CAP_EXCEEDED'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['lines' => [['listing_variant_id' => 'a', 'quantity' => '6', 'tax_category' => 'VAT_12']]]), ['a' => $policy], ['a' => '50'])));
        self::assertSame(['ALLOTMENT_INSUFFICIENT'], $codes(AutoAcceptGate::evaluate($order, ['a' => ['remaining_allotment_quantity' => '4'] + $policy], ['a' => '50'])));
        self::assertSame(['STOCK_INSUFFICIENT'], $codes(AutoAcceptGate::evaluate($order, ['a' => $policy], ['a' => '4.9999'])));
        self::assertSame(['WHOLE_UNITS_REQUIRED'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['lines' => [['listing_variant_id' => 'a', 'quantity' => '2.5', 'tax_category' => 'VAT_12']]]), ['a' => $policy], ['a' => '50'])));
        self::assertSame(['TAX_CLASSIFICATION_MISSING'], $codes(AutoAcceptGate::evaluate(array_replace($order, ['lines' => [['listing_variant_id' => 'a', 'quantity' => '5', 'tax_category' => null]]]), ['a' => $policy], ['a' => '50'])));
        foreach ([AutoAcceptPolicyService::STATUS_PAUSED, AutoAcceptPolicyService::STATUS_DISABLED] as $status) {
            self::assertSame(['POLICY_NOT_ACTIVE'], $codes(AutoAcceptGate::evaluate($order, ['a' => ['status' => $status] + $policy], ['a' => '50'])));
        }
        // One ineligible line routes the whole child order to manual review.
        $mixed = array_replace($order, ['lines' => [...$order['lines'], ['listing_variant_id' => 'b', 'quantity' => '1', 'tax_category' => 'VAT_12']]]);
        $result = AutoAcceptGate::evaluate($mixed, ['a' => $policy], ['a' => '50', 'b' => '50']);
        self::assertFalse($result['eligible']);
        self::assertSame([['code' => 'POLICY_NOT_ACTIVE', 'listing_variant_id' => 'b']], $result['reasons']);
        self::assertSame('DISABLED', AutoAcceptPolicyService::present(null)['status']);
    }
}
