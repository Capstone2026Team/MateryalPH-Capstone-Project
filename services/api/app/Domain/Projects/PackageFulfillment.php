<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Finance\Money;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Orders\OrderStates;
use App\Domain\Procurement\ListingPublicFacts;
use Illuminate\Support\Facades\DB;

/**
 * The one place that decides how much of a Work Package a quotation covers. The Work Package lines are the
 * requirement, the Vendor's priced lines are what it supplies, and the Item-Based purchases the Buyer tagged to a
 * missing line (cart or open order) are what is bought separately. Vendor card, quotation, order summary and the
 * missing-item list all read this result, so none of them keeps a separate count.
 *
 * A separate purchase closes a gap only when its product satisfies the line's brand and every stated specification;
 * a similar product stays listed as a substitute and the remaining quantity is still open. Nothing is reserved,
 * confirmed or paid by being listed here.
 */
final class PackageFulfillment
{
    public const FULFILLED = 'FULFILLED';

    public const PARTIAL = 'PARTIAL';

    public const UNFULFILLED = 'UNFULFILLED';

    /**
     * Item-Based purchases tagged to a line of this package's current version, by Work Package line id. Each carries
     * whether it satisfies the line. Saved-for-later cart lines are not purchases yet and are left out.
     *
     * @param  array{order_id: string, quantities: array<string, string>}|null  $confirmation
     * @return array<string, list<array<string, mixed>>>
     */
    public static function purchases(object $package, string $buyerId, ?array $confirmation = null): array
    {
        $lines = DB::table('work_package_lines')->where('work_package_version_id', $package->current_version_id)->get(['id', 'material_id', 'unit_id', 'specifications', 'preferred_brand'])->keyBy('id');
        if ($lines->isEmpty()) {
            return [];
        }
        $columns = ['v.id as variant_id', 'v.label as variant_label', 'v.attributes', 'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'l.vendor_organization_id',
            'pd.brand', 'pd.material_id', 'v.unit_id', 'u.code as unit_code'];
        $base = static fn (string $table) => DB::table($table)->join('listing_variants as v', 'v.id', '=', $table.'.listing_variant_id')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->join('products as pd', 'pd.id', '=', 'l.product_id')->join('units as u', 'u.id', '=', 'v.unit_id');
        $rows = $base('cart_items')->join('carts as c', 'c.id', '=', 'cart_items.cart_id')->where('c.buyer_profile_id', $buyerId)->where('c.state', 'ACTIVE')
            ->whereNull('cart_items.saved_for_later_at')->whereIn('cart_items.work_package_line_id', $lines->keys()->all())
            ->orderBy('cart_items.created_at')->orderBy('cart_items.id')
            ->get(array_merge($columns, ['cart_items.work_package_line_id as line_id', 'cart_items.quantity', 'cart_items.unit_price_centavos']))
            ->map(static fn (object $row): object => (object) ((array) $row + ['stage' => 'IN_CART', 'order_id' => null, 'order_reference' => null]));
        $ordered = $base('order_lines')->join('orders as o', 'o.id', '=', 'order_lines.order_id')->where('o.buyer_profile_id', $buyerId)
            ->where(fn ($q) => $q->where('o.procurement_type', 'ITEM_BASED')->orWhereNotNull('o.project_arrangement_id'))
            ->leftJoin('order_snapshots as confirmed', fn ($join) => $join->on('confirmed.order_id', '=', 'o.id')->on('confirmed.version', '=', 'o.current_snapshot_version'))
            ->whereNotIn('o.order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->whereIn('order_lines.work_package_line_id', $lines->keys()->all())
            ->orderBy('o.reference')->orderBy('order_lines.id')
            ->get(array_merge($columns, ['order_lines.id as order_line_id', 'order_lines.work_package_line_id as line_id', 'order_lines.quantity', 'order_lines.unit_price_centavos', 'order_lines.snapshot as purchase_snapshot',
                'confirmed.snapshot as confirmation_snapshot', 'o.id as order_id', 'o.reference as order_reference']))
            ->map(static fn (object $row): object => (object) ((array) $row + ['stage' => 'ORDERED']));
        $ordered = $ordered->flatMap(static function (object $row) use ($lines, $confirmation): array {
            $snapshot = json_decode($row->purchase_snapshot ?? '{}', true) ?: [];
            $confirmed = json_decode($row->confirmation_snapshot ?? '{}', true) ?: [];
            $quantity = (string) $row->quantity;
            $unitPrice = (int) $row->unit_price_centavos;
            foreach ($confirmed['lines'] ?? [] as $confirmedLine) {
                if (($confirmedLine['order_line_id'] ?? null) === $row->order_line_id || ($confirmedLine['variant_id'] ?? null) === $row->variant_id) {
                    $quantity = (string) ($confirmedLine['confirmed_quantity'] ?? $confirmedLine['quantity'] ?? $quantity);
                    $unitPrice = (int) ($confirmedLine['unit_price_centavos'] ?? $unitPrice);
                }
            }
            // Confirmation reconciliation runs before the order advances its snapshot pointer.
            if ($confirmation !== null && $confirmation['order_id'] === $row->order_id) {
                $quantity = $confirmation['quantities'][$row->order_line_id] ?? $quantity;
            }
            $allocated = [];
            $weights = [];
            foreach ($snapshot['work_package_allocations'] ?? [['line_id' => $row->line_id, 'quantity' => $quantity]] as $allocation) {
                if (! isset($lines[$allocation['line_id']])) {
                    continue;
                }
                $take = bccomp($quantity, $allocation['quantity'], 4) >= 0 ? (string) $allocation['quantity'] : $quantity;
                $quantity = bcsub($quantity, $take, 4);
                $allocated[$allocation['line_id']] = $take;
                $weights[$allocation['line_id']] = (int) bcmul($take, '10000', 0);
            }
            $amount = Money::lineAmount(array_reduce($allocated, static fn (string $sum, string $amount): string => bcadd($sum, $amount, 4), '0'), $unitPrice);
            foreach (($confirmation !== null && $confirmation['order_id'] === $row->order_id) || array_sum($weights) === 0 ? [] : ($confirmed['commercial']['lines'] ?? []) as $pricedLine) {
                if ($pricedLine['line_id'] === $row->order_line_id || $pricedLine['line_id'] === $row->variant_id) {
                    $amount = (int) $pricedLine['payable_centavos'];
                    break;
                }
            }
            $shares = Money::allocate($amount, $weights);
            $result = [];
            foreach ($allocated as $lineId => $amount) {
                $result[] = (object) array_merge((array) $row, ['line_id' => $lineId, 'quantity' => $amount, 'unit_price_centavos' => $unitPrice, 'allocated_total_centavos' => $shares[$lineId]]);
            }

            return $result;
        });
        $all = $rows->concat($ordered);
        $stores = app(PublicVendorProjection::class)->summaries($all->pluck('vendor_organization_id')->unique()->map(static fn (mixed $id): string => (string) $id)->values()->all());
        $images = app(ListingPublicFacts::class)->images($all->pluck('listing_id')->unique()->map(static fn (mixed $id): string => (string) $id)->values()->all());

        $result = [];
        foreach ($all as $row) {
            $line = $lines[$row->line_id];
            $required = json_decode((string) ($line->specifications ?? '{}'), true);
            $snapshot = $row->stage === 'ORDERED' ? json_decode($row->purchase_snapshot ?? '{}', true) : [];
            $snapshot = is_array($snapshot) ? $snapshot : [];
            $brand = array_key_exists('brand', $snapshot) ? $snapshot['brand'] : $row->brand;
            $attributes = $snapshot['offered_specifications'] ?? SpecificationMatch::offered($row->technical_attributes, $row->attributes);
            $exact = $line->material_id !== null && ($snapshot['material_id'] ?? $row->material_id) === $line->material_id && $row->unit_id === $line->unit_id
                && ($line->preferred_brand === null || $line->preferred_brand === $brand)
                && SpecificationMatch::satisfies(is_array($required) ? $required : [], $attributes);
            $quantity = (string) $row->quantity;
            $unitPrice = (int) $row->unit_price_centavos;
            $result[(string) $row->line_id][] = ['stage' => $row->stage, 'line_id' => (string) $row->line_id, 'variant_id' => (string) $row->variant_id, 'listing_id' => (string) $row->listing_id,
                'display_name' => (string) ($snapshot['display_name'] ?? $row->display_name), 'variant_label' => $snapshot['variant_label'] ?? $row->variant_label, 'vendor_id' => (string) $row->vendor_organization_id,
                'image' => $snapshot['image'] ?? $images[(string) $row->listing_id][0] ?? null, 'specifications' => $snapshot['specification_details'] ?? [],
                'store_name' => $stores[(string) $row->vendor_organization_id]['public_store_name'] ?? null, 'quantity' => $quantity, 'unit_code' => (string) $row->unit_code,
                'unit_price_centavos' => $unitPrice, 'line_total_centavos' => $row->allocated_total_centavos ?? Money::lineAmount($quantity, $unitPrice),
                'satisfies_requirement' => $exact, 'order_id' => $row->order_id === null ? null : (string) $row->order_id, 'order_reference' => $row->order_reference];
        }

        return $result;
    }

    /**
     * What the quotation covers once the separate purchases are counted.
     *
     * @param  list<array<string, mixed>>  $lines  the Vendor's priced lines (required, matched and missing quantity per Work Package line)
     * @param  array<string, list<array<string, mixed>>>  $purchases  from {@see purchases()}
     * @return array<string, mixed>
     */
    public static function summarize(array $lines, array $purchases, int $materialsCentavos, ?int $projectedTotalCentavos): array
    {
        $rows = [];
        $separate = [];
        $separateTotal = 0;
        $counts = [self::FULFILLED => 0, self::PARTIAL => 0, self::UNFULFILLED => 0];
        $vendorFulfilled = 0;
        foreach ($lines as $line) {
            $gap = (string) $line['missing_quantity'];
            $vendorFull = bccomp($gap, '0', 4) <= 0;
            $vendorFulfilled += $vendorFull ? 1 : 0;
            $satisfying = $substitute = '0.0000';
            foreach ($purchases[$line['line_id']] ?? [] as $purchase) {
                $separate[] = $purchase;
                $separateTotal += $purchase['line_total_centavos'];
                if ($purchase['satisfies_requirement']) {
                    $satisfying = bcadd($satisfying, $purchase['coverage_quantity'] ?? $purchase['quantity'], 4);
                } else {
                    $substitute = bcadd($substitute, $purchase['quantity'], 4);
                }
            }
            $bought = bcadd(bccomp($satisfying, $gap, 4) >= 0 ? $gap : $satisfying, '0', 4);
            $remaining = bcsub($gap, $bought, 4);
            $supplied = bcadd((string) $line['matched_quantity'], $bought, 4);
            $status = bccomp($remaining, '0', 4) <= 0 ? self::FULFILLED : (bccomp($supplied, '0', 4) > 0 ? self::PARTIAL : self::UNFULFILLED);
            $counts[$status]++;
            $rows[] = ['line_id' => $line['line_id'], 'name' => $line['name'], 'unit_code' => $line['unit_code'], 'required_quantity' => (string) $line['quantity'],
                'vendor_quantity' => (string) $line['matched_quantity'], 'separate_quantity' => $bought, 'substitute_quantity' => $substitute, 'remaining_quantity' => $remaining, 'status' => $status,
                'missing_reason' => $line['missing_reason'] ?? null];
        }
        $total = count($lines);

        return ['status' => $counts[self::FULFILLED] === $total ? 'COMPLETE' : ($counts[self::UNFULFILLED] === $total ? 'NONE' : 'PARTIAL'),
            'lines_total' => $total, 'lines_fulfilled' => $counts[self::FULFILLED], 'lines_partial' => $counts[self::PARTIAL], 'lines_unfulfilled' => $counts[self::UNFULFILLED],
            'vendor_lines_fulfilled' => $vendorFulfilled, 'lines' => $rows, 'separate_items' => $separate, 'separate_total_centavos' => $separateTotal,
            'combined_total_centavos' => ($projectedTotalCentavos ?? $materialsCentavos) + $separateTotal];
    }

    /**
     * The Work Package line's quantity still open for a Vendor snapshot, after satisfying separate purchases.
     *
     * @param  list<array<string, mixed>>  $lines
     * @param  array<string, list<array<string, mixed>>>  $purchases
     */
    public static function remaining(array $lines, array $purchases, string $lineId): ?string
    {
        foreach (self::summarize($lines, $purchases, 0, null)['lines'] as $row) {
            if ($row['line_id'] === $lineId) {
                return $row['remaining_quantity'];
            }
        }

        return null;
    }
}
