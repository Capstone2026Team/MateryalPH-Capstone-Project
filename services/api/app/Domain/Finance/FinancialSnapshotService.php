<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Catalog\ListingTaxPolicy;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-02 amount arithmetic in integer centavos. The Phase 7 preview and the Phase 8 accepted snapshot share the
 * same line and VAT rules (Money / FinancialCalculator), so a preview and the frozen snapshot agree.
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

    public const FEE_POLICY_CODE = 'MONTHLY_VENDOR_COMMISSION';

    public const ENVIRONMENT = 'TEST';

    public static function lineAmountCentavos(string $quantity, int $unitPriceCentavos): int
    {
        return Money::lineAmount($quantity, $unitPriceCentavos);
    }

    /** The fee policy version in force now for this environment; commission never uses a silent new price. */
    public static function currentFeePolicyId(): ?string
    {
        $id = DB::table('fee_policy_versions')->where('environment', self::ENVIRONMENT)->where('code', self::FEE_POLICY_CODE)->where('effective_from', '<=', now())
            ->where(fn ($query) => $query->whereNull('effective_until')->orWhere('effective_until', '>', now()))->orderByDesc('version')->value('id');

        return $id === null ? null : (string) $id;
    }

    /**
     * Freezes the Buyer-accepted commercial version as a new immutable financial snapshot version with its
     * lines, largest-remainder discount allocation, NRPC principal/VAT allocation and a calculation hash. The
     * Buyer processing fee belongs to each later payment attempt (processing_fee_snapshots), so the order
     * snapshot records the commercial total M + D and a payment matrix whose fee is pending until then.
     * Called only inside the acceptance transaction.
     *
     * @param  array<string, mixed>  $commercial  FinancialCalculator::commercial() with a known delivery amount
     * @return array{id: string, version: int, fee_policy_version_id: ?string, materials_exclusive_centavos: int}
     */
    public function freeze(object $order, object $orderSnapshot, array $commercial, ?string $nrpcRecordId): array
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Financial snapshots are frozen only inside the acceptance transaction.');
        }
        $version = (int) DB::table('financial_snapshots')->where('order_id', $order->id)->max('version') + 1;
        $acceptedContent = json_decode((string) $orderSnapshot->snapshot, true);
        $feePolicyId = array_key_exists('fee_policy_version_id', $acceptedContent) ? $acceptedContent['fee_policy_version_id'] : self::currentFeePolicyId();
        $matrix = FinancialCalculator::paymentMatrix($commercial, (string) $order->payment_method, null);
        $canonical = json_encode(['order_id' => (string) $order->id, 'version' => $version, 'order_snapshot_version' => (int) $orderSnapshot->version,
            'commercial' => $commercial, 'payment_matrix' => $matrix, 'fee_policy_version_id' => $feePolicyId, 'nrpc_record_id' => $nrpcRecordId], JSON_THROW_ON_ERROR);
        $id = (string) Str::uuid7();
        DB::table('financial_snapshots')->insert([
            'id' => $id, 'order_id' => $order->id, 'version' => $version, 'order_snapshot_id' => $orderSnapshot->id, 'quotation_version_id' => $order->quotation_version_id, 'environment' => self::ENVIRONMENT,
            'materials_gross_centavos' => $commercial['materials_gross_centavos'], 'vendor_discount_centavos' => $commercial['vendor_discount_centavos'],
            'materials_payable_centavos' => $commercial['materials_payable_centavos'], 'materials_vat_centavos' => $commercial['materials_vat_centavos'],
            'materials_exclusive_centavos' => $commercial['materials_exclusive_centavos'], 'delivery_centavos' => (int) $commercial['delivery_centavos'], 'delivery_vat_centavos' => 0,
            'processing_fee_centavos' => 0, 'nrpc_centavos' => $commercial['nrpc_centavos'], 'buyer_total_centavos' => (int) $commercial['commercial_total_centavos'],
            'currency' => 'PHP', 'fee_policy_version_id' => $feePolicyId, 'calculation_version' => FinancialCalculator::VERSION, 'payment_method' => $order->payment_method,
            'payment_matrix' => json_encode($matrix, JSON_THROW_ON_ERROR), 'rounding_allocation' => json_encode($commercial['rounding'], JSON_THROW_ON_ERROR),
            'calculation_hash' => hash('sha256', $canonical), 'published_at' => now(), 'created_at' => now(), 'updated_at' => now(),
        ]);
        foreach ($commercial['lines'] as $line) {
            DB::table('financial_snapshot_lines')->insert([
                'id' => (string) Str::uuid7(), 'financial_snapshot_id' => $id, 'order_line_id' => $line['line_id'], 'source_quantity' => $line['quantity'],
                'source_unit_price_centavos' => $line['unit_price_centavos'], 'gross_centavos' => $line['gross_centavos'], 'discount_centavos' => $line['discount_centavos'],
                'vat_centavos' => $line['vat_centavos'], 'ordinary_payable_centavos' => $line['payable_centavos'], 'tax_category' => $line['tax_category'],
                'nrpc_principal_centavos' => $line['nrpc_principal_centavos'], 'nrpc_vat_centavos' => $line['nrpc_vat_centavos'], 'created_at' => now(), 'updated_at' => now(),
            ]);
            if ($line['discount_centavos'] > 0) {
                $this->allocation($id, 'VENDOR_DISCOUNT', 'ORDER', (string) $order->id, $line['line_id'], $line['discount_centavos'], ['gross_centavos' => $line['gross_centavos'], 'method' => 'largest-remainder']);
            }
            if ($nrpcRecordId !== null && $line['nrpc_principal_centavos'] > 0) {
                $this->allocation($id, 'NRPC_PRINCIPAL', 'NRPC_RECORD', $nrpcRecordId, $line['line_id'], $line['nrpc_principal_centavos'], ['vat_centavos' => $line['nrpc_vat_centavos'], 'line_payable_centavos' => $line['payable_centavos']]);
            }
        }

        return ['id' => $id, 'version' => $version, 'fee_policy_version_id' => $feePolicyId, 'materials_exclusive_centavos' => (int) $commercial['materials_exclusive_centavos']];
    }

    /** @param array<string, mixed> $basis */
    private function allocation(string $snapshotId, string $type, string $sourceType, string $sourceId, string $lineId, int $amount, array $basis): void
    {
        DB::table('financial_allocations')->insert(['id' => (string) Str::uuid7(), 'financial_snapshot_id' => $snapshotId, 'allocation_type' => $type, 'source_type' => $sourceType, 'source_id' => $sourceId,
            'target_type' => 'ORDER_LINE', 'target_id' => $lineId, 'amount_centavos' => $amount, 'basis' => json_encode($basis, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
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
