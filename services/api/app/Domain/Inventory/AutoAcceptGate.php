<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

/**
 * Pure Item-Based auto-accept eligibility. It never applies to Project-Based procurement or to any order
 * carrying NRPC; every line must belong to one Vendor child order, carry a validated tax classification and
 * have an ACTIVE per-variant policy whose remaining allotment, unit cap and amount cap all admit the order.
 * One failed check routes the whole child order to manual review; nothing is partially accepted.
 * The later order-acceptance transaction calls this with rows it has locked through InventoryLocks.
 */
final class AutoAcceptGate
{
    public const RULE_VERSION = 'auto-accept.item-based.v1';

    /**
     * @param  array{procurement_type: string, nrpc_centavos: int, commercial_total_centavos: int, lines: list<array{listing_variant_id: string, quantity: string, tax_category: ?string}>}  $order
     * @param  array<string, array<string, mixed>>  $policies  Presented policies keyed by listing variant id.
     * @param  array<string, string>  $availableToSell  Locked available quantities keyed by listing variant id.
     * @return array{eligible: bool, reasons: list<array{code: string, listing_variant_id: ?string}>, rule_version: string}
     */
    public static function evaluate(array $order, array $policies, array $availableToSell): array
    {
        $reasons = [];
        $reason = static function (string $code, ?string $variantId = null) use (&$reasons): void {
            $reasons[] = ['code' => $code, 'listing_variant_id' => $variantId];
        };
        if ($order['procurement_type'] !== 'ITEM_BASED') {
            $reason('PROJECT_BASED_NOT_ELIGIBLE');
        }
        if ($order['nrpc_centavos'] !== 0) {
            $reason('NRPC_REQUIRES_MANUAL_REVIEW');
        }
        if ($order['lines'] === []) {
            $reason('NO_LINES');
        }
        foreach ($order['lines'] as $line) {
            $variantId = $line['listing_variant_id'];
            $policy = $policies[$variantId] ?? null;
            $quantity = StockAvailability::quantity($line['quantity']);
            if ($line['tax_category'] === null || $line['tax_category'] === '') {
                $reason('TAX_CLASSIFICATION_MISSING', $variantId);
            }
            if ($policy === null || ($policy['status'] ?? null) !== AutoAcceptPolicyService::STATUS_ACTIVE) {
                $reason('POLICY_NOT_ACTIVE', $variantId);

                continue;
            }
            if (bccomp($quantity, bcadd($quantity, '0', 0), 4) !== 0) {
                // Allotments are whole units; a fractional quantity cannot draw on one exactly.
                $reason('WHOLE_UNITS_REQUIRED', $variantId);
            }
            if (bccomp($quantity, StockAvailability::quantity($policy['remaining_allotment_quantity']), 4) > 0) {
                $reason('ALLOTMENT_INSUFFICIENT', $variantId);
            }
            if ($policy['max_unit_count'] !== null && bccomp($quantity, StockAvailability::quantity($policy['max_unit_count']), 4) > 0) {
                $reason('UNIT_CAP_EXCEEDED', $variantId);
            }
            if ($policy['max_order_amount_centavos'] !== null && $order['commercial_total_centavos'] > (int) $policy['max_order_amount_centavos']) {
                $reason('AMOUNT_CAP_EXCEEDED', $variantId);
            }
            if (! isset($availableToSell[$variantId]) || bccomp($quantity, $availableToSell[$variantId], 4) > 0) {
                $reason('STOCK_INSUFFICIENT', $variantId);
            }
        }

        return ['eligible' => $reasons === [], 'reasons' => $reasons, 'rule_version' => self::RULE_VERSION];
    }
}
