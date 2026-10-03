<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\VolumePricing;
use App\Domain\Finance\FinancialCalculator;
use App\Domain\Inventory\StockAvailability;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Immutable commercial versions of one child order. Version 1 is the submitted request; each Vendor
 * confirmation (manual or automatic) appends the next version. Prices always come from the line's frozen
 * submission snapshot: a confirmed quantity re-applies the frozen CAT-PRICE-01 tiers, never the listing's
 * current price, so later listing or market changes cannot rewrite a pending or accepted order.
 */
final class OrderCommercial
{
    /** @return list<object> */
    public function lines(string $orderId): array
    {
        return DB::table('order_lines')->where('order_id', $orderId)->orderBy('line_number')->get()->all();
    }

    /** @return array{unit_price_centavos: int, applied_price_version_id: ?string} */
    public static function unitPriceFor(object $line, string $quantity): array
    {
        /** @var list<array{price_version_id: string, minimum_quantity: string, amount_centavos: int}> $tiers */
        $tiers = json_decode((string) ($line->volume_tiers ?? '[]'), true) ?: [];
        $tier = VolumePricing::applicableTier($tiers, $quantity);
        if ($tier !== null) {
            return ['unit_price_centavos' => (int) $tier['amount_centavos'], 'applied_price_version_id' => (string) $tier['price_version_id']];
        }
        $ordinary = $line->ordinary_unit_price_centavos === null ? (int) $line->unit_price_centavos : (int) $line->ordinary_unit_price_centavos;

        return ['unit_price_centavos' => $ordinary, 'applied_price_version_id' => $line->listing_price_version_id === null ? null : (string) $line->listing_price_version_id];
    }

    /**
     * FIN-02 amounts for confirmed quantities (line id => quantity). Lines at zero are omitted from pricing.
     *
     * @param  list<object>  $lines
     * @param  array<string, string>  $quantities
     * @param  array{amount_centavos: int, allocations: array<string, int>}|null  $nrpc
     * @return array<string, mixed>
     */
    public function compute(array $lines, array $quantities, int $vendorDiscountCentavos, ?int $deliveryCentavos, ?array $nrpc = null): array
    {
        $priced = [];
        foreach ($lines as $line) {
            $quantity = StockAvailability::quantity($quantities[(string) $line->id] ?? $line->quantity);
            if (bccomp($quantity, '0', 4) <= 0) {
                continue;
            }
            $priced[] = ['line_id' => (string) $line->id, 'quantity' => $quantity, 'unit_price_centavos' => self::unitPriceFor($line, $quantity)['unit_price_centavos'], 'tax_category' => (string) $line->tax_category];
        }

        return FinancialCalculator::commercial($priced, $vendorDiscountCentavos, $deliveryCentavos, $nrpc);
    }

    /**
     * Appends the next commercial version. $content carries the kind-specific fields (confirmed lines, delivery,
     * pickup, NRPC, changes); the FIN-02 amounts are stored beside it so acceptance reuses them exactly.
     *
     * @param  array<string, mixed>  $content
     * @param  array<string, mixed>  $commercial
     */
    public function record(object $order, string $kind, array $content, array $commercial, OrderActor $actor): object
    {
        $version = (int) DB::table('order_snapshots')->where('order_id', $order->id)->max('version') + 1;
        $snapshot = ['kind' => $kind, 'version' => $version, 'order_id' => (string) $order->id, 'recorded_at' => now()->toIso8601String(),
            'actor' => ['source' => $actor->source, 'role' => $actor->role], 'commercial' => $commercial] + $content;
        $json = json_encode($snapshot, JSON_THROW_ON_ERROR);
        $id = (string) Str::uuid7();
        DB::table('order_snapshots')->insert([
            'id' => $id, 'order_id' => $order->id, 'version' => $version, 'kind' => $kind, 'snapshot' => $json, 'content_hash' => hash('sha256', $json),
            'created_by_user_id' => $actor->userId, 'actor_role' => $actor->role,
            'materials_centavos' => (int) $commercial['materials_payable_centavos'], 'vendor_discount_centavos' => (int) $commercial['vendor_discount_centavos'],
            'delivery_centavos' => $commercial['delivery_centavos'], 'nrpc_centavos' => (int) $commercial['nrpc_centavos'],
            'commercial_total_centavos' => $commercial['commercial_total_centavos'], 'calculation_version' => (string) $commercial['calculation_version'],
            'created_at' => now(), 'updated_at' => now(),
        ]);

        return DB::table('order_snapshots')->where('id', $id)->first();
    }

    public function version(string $orderId, int $version): ?object
    {
        return DB::table('order_snapshots')->where('order_id', $orderId)->where('version', $version)->first();
    }

    /** @return array<string, mixed> */
    public static function content(object $snapshot): array
    {
        $decoded = json_decode((string) $snapshot->snapshot, true);

        return is_array($decoded) ? $decoded : [];
    }

    /**
     * Human-readable change list between the request and a Vendor version.
     *
     * @param  list<object>  $lines
     * @param  array<string, string>  $quantities
     * @return list<array<string, mixed>>
     */
    public static function changes(array $lines, array $quantities, int $vendorDiscountCentavos): array
    {
        $changes = [];
        foreach ($lines as $line) {
            $requested = StockAvailability::quantity($line->quantity);
            $confirmed = StockAvailability::quantity($quantities[(string) $line->id] ?? $requested);
            if (bccomp($confirmed, $requested, 4) !== 0) {
                $snapshot = json_decode((string) $line->snapshot, true);
                $changes[] = ['type' => bccomp($confirmed, '0', 4) === 0 ? 'LINE_REMOVED' : 'QUANTITY_REDUCED', 'order_line_id' => (string) $line->id,
                    'label' => is_array($snapshot) ? (string) ($snapshot['display_name'] ?? '') : '', 'from' => $requested, 'to' => $confirmed];
            }
        }
        if ($vendorDiscountCentavos > 0) {
            $changes[] = ['type' => 'VENDOR_DISCOUNT', 'order_line_id' => null, 'label' => 'Vendor discount', 'from' => '0', 'to' => (string) $vendorDiscountCentavos];
        }

        return $changes;
    }
}
