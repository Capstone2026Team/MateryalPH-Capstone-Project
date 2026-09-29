<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Catalog\ListingTaxPolicy;

/**
 * FIN-02 amount arithmetic in integer centavos. Phase 7 uses only the pre-confirmation preview; Phase 8
 * extends this service to freeze accepted snapshots with discount allocation, NRPC and version hashes, and
 * must keep these same line and VAT rules so a preview and the accepted snapshot agree.
 *
 *   L = money(quantity × unit price)            per line, half-up to the centavo (no discounts at cart time)
 *   V = Σ money(L × 12 / 112) over VAT_12 lines  other classifications carry zero included VAT
 *   M = Σ L,  E = M − V
 *   D = delivery (advisory estimate or pending), F = processing fee (pending until a channel is chosen)
 *
 * Prices are VAT-inclusive payable amounts, so VAT is never added on top. The Vendor-paid 2% commission and
 * merchant withholding are Vendor-side settlements and never appear in a Buyer total. Market averages are
 * never an input: every amount comes from the listing's own current price version.
 */
final class FinancialSnapshotService
{
    public const PREVIEW_VERSION = 'fin02.preview.v1';

    public static function lineAmountCentavos(string $quantity, int $unitPriceCentavos): int
    {
        return (int) bcadd(bcmul($quantity, (string) $unitPriceCentavos, 4), '0.5', 0);
    }

    /**
     * @param  list<array{line_id: string, quantity: string, unit_price_centavos: int, tax_category: string}>  $lines
     * @param  array{status: string, min_centavos: ?int, max_centavos: ?int}  $delivery
     * @return array<string, mixed>
     */
    public function previewChildOrder(array $lines, array $delivery): array
    {
        $allocated = [];
        $materials = 0;
        $vat = 0;
        foreach ($lines as $line) {
            $amount = self::lineAmountCentavos($line['quantity'], $line['unit_price_centavos']);
            $lineVat = ListingTaxPolicy::includedVatCentavos($amount, $line['tax_category']);
            $materials += $amount;
            $vat += $lineVat;
            $allocated[] = ['line_id' => $line['line_id'], 'payable_centavos' => $amount, 'included_vat_centavos' => $lineVat, 'tax_category' => $line['tax_category']];
        }
        $known = $delivery['min_centavos'] !== null && $delivery['max_centavos'] !== null;

        return [
            'currency' => 'PHP',
            'calculation_version' => self::PREVIEW_VERSION,
            'lines' => $allocated,
            'materials_subtotal_centavos' => $materials,
            'included_vat_centavos' => $vat,
            'vat_exclusive_materials_centavos' => $materials - $vat,
            'vat_treatment' => $vat > 0 ? 'PRICES_INCLUDE_VAT' : 'NO_INCLUDED_VAT',
            'delivery' => $delivery,
            'processing_fee' => ['status' => 'PENDING_PAYMENT_CHANNEL', 'amount_centavos' => null],
            'total_before_processing_min_centavos' => $known ? $materials + (int) $delivery['min_centavos'] : ($delivery['status'] === 'NOT_APPLICABLE' ? $materials : null),
            'total_before_processing_max_centavos' => $known ? $materials + (int) $delivery['max_centavos'] : ($delivery['status'] === 'NOT_APPLICABLE' ? $materials : null),
            'excludes' => ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'],
            'status' => 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
        ];
    }
}
