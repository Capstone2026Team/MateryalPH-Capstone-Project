<?php

declare(strict_types=1);

namespace App\Domain\Invoices;

use Illuminate\Support\Facades\DB;

/** Accepted commercial facts for invoice context; never invents invoice line prices from an uploaded file. */
final class InvoiceOrderSummary
{
    /** @return array<string, mixed> */
    public static function forOrder(string $orderId): array
    {
        $snapshot = DB::table('financial_snapshots')->where('order_id', $orderId)->orderByDesc('version')->first();
        $amounts = $snapshot === null ? collect() : DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->get()->keyBy('order_line_id');
        $lines = DB::table('order_lines')->where('order_id', $orderId)->orderBy('line_number')->get()->map(static function (object $line) use ($amounts): array {
            $facts = json_decode((string) $line->snapshot, true) ?: [];
            $money = $amounts->get($line->id);

            return ['order_line_id' => (string) $line->id, 'display_name' => (string) ($facts['display_name'] ?? 'Material'),
                'category' => $facts['category'] ?? null, 'quantity' => (string) ($money->source_quantity ?? $line->quantity), 'unit_name' => (string) ($facts['unit_name'] ?? ''),
                'unit_price_centavos' => (int) ($money->source_unit_price_centavos ?? $line->unit_price_centavos),
                'line_total_centavos' => $money === null ? null : (int) $money->ordinary_payable_centavos];
        })->all();

        $billing = DB::table('order_invoice_details')->where('order_id', $orderId)->first();

        return ['lines' => $lines, 'billing_details' => $billing === null ? null : ['billing_name' => (string) $billing->billing_name,
            'billing_address' => (string) $billing->billing_address, 'tin_masked' => $billing->tin_last4 === null ? null : '•••• '.$billing->tin_last4],
            'materials_subtotal_centavos' => $snapshot === null ? null : (int) $snapshot->materials_payable_centavos,
            'discount_centavos' => $snapshot === null ? null : (int) $snapshot->vendor_discount_centavos,
            'delivery_centavos' => $snapshot === null ? null : (int) $snapshot->delivery_centavos,
            'included_vat_centavos' => $snapshot === null ? null : (int) $snapshot->materials_vat_centavos + (int) $snapshot->delivery_vat_centavos,
            'total_centavos' => $snapshot === null ? null : (int) $snapshot->materials_payable_centavos + (int) $snapshot->delivery_centavos];
    }
}
