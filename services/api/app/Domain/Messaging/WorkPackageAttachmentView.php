<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use Illuminate\Support\Facades\DB;

/** Bounded read projections; the complete locked Buyer original is never rewritten. */
final class WorkPackageAttachmentView
{
    /** @param array<string, mixed> $reference
     * @return array<string, mixed> */
    public function inquiry(array $reference): array
    {
        if (! isset($reference['work_package'])) {
            return $reference;
        }
        $originals = array_column($reference['work_package']['lines'] ?? [], null, 'id');
        $allocations = $reference['vendor_allocations'] ?? $reference['system_estimate']['lines'] ?? [];
        $lines = [];
        foreach ($allocations as $allocation) {
            $quantity = (string) ($allocation['matched_quantity'] ?? $allocation['quantity'] ?? '0');
            if (bccomp($quantity, '0', 4) <= 0 || ($allocation['variant_id'] ?? null) === null) {
                continue;
            }
            $id = $allocation['line_id'] ?? null;
            $original = $originals[$id] ?? [];
            $lines[] = array_replace($original, array_intersect_key($allocation, array_flip(['unit_code', 'unit_id', 'variant_id'])),
                ['id' => $id, 'name' => $original['name'] ?? $allocation['name'] ?? 'Material', 'quantity' => $quantity]);
        }
        $view = $this->base($reference);
        $view['material_scope'] = 'VENDOR_ALLOCATION';
        $view['work_package']['lines'] = $lines;
        $view['lines'] = $lines;
        // This saved duplicate belongs to this inquiry's Vendor, including explicitly proposed substitutions.
        if (isset($reference['working_duplicate'])) {
            $view['working_duplicate'] = $reference['working_duplicate'];
        }

        return $view;
    }

    /** @param array<string, mixed> $reference
     * @param array<string, mixed> $terms
     * @return array<string, mixed> */
    public function order(array $reference, array $terms): array
    {
        $view = $this->base($reference);
        $view['material_scope'] = 'VENDOR_ORDER';
        $view['order'] = array_intersect_key($terms, array_flip(['id', 'reference', 'accepted']));
        $view['work_package'] = array_replace($view['work_package'], array_intersect_key($terms, array_flip(['lines', 'fulfillment_method', 'payment_method', 'fulfillment_date'])));
        $view['lines'] = $terms['lines'];

        return $view;
    }

    /** @param list<object> $orders
     * @return array<string, array<string, mixed>> */
    public function orderTerms(array $orders): array
    {
        if ($orders === []) {
            return [];
        }
        $ids = array_column($orders, 'id');
        $lines = DB::table('order_lines as l')->join('units as u', 'u.id', '=', 'l.unit_id')->whereIn('l.order_id', $ids)
            ->orderBy('l.line_number')->get(['l.*', 'u.code as unit_code'])->groupBy('order_id');
        $snapshots = DB::table('order_snapshots as s')->join('orders as o', 'o.id', '=', 's.order_id')->whereIn('o.id', $ids)
            ->whereRaw('s.version = COALESCE(o.accepted_snapshot_version, o.current_snapshot_version)')->get(['s.*'])->keyBy('order_id');
        $result = [];
        foreach ($orders as $order) {
            $snapshot = $snapshots->get($order->id);
            $content = $snapshot === null ? [] : json_decode($snapshot->snapshot, true);
            $confirmed = array_column($content['commercial']['lines'] ?? [], null, 'line_id');
            $items = [];
            foreach ($lines->get($order->id, collect()) as $line) {
                $amount = $confirmed[$line->id] ?? null;
                // A commercial snapshot explicitly omits removed/zero-quantity lines.
                if ($snapshot !== null && $amount === null) {
                    continue;
                }
                $quantity = (string) ($amount['quantity'] ?? $line->quantity);
                if (bccomp($quantity, '0', 4) <= 0) {
                    continue;
                }
                $saved = json_decode($line->snapshot, true);
                $items[] = ['id' => $line->id, 'name' => $saved['display_name'] ?? $saved['name'] ?? $saved['description'] ?? 'Material',
                    'quantity' => $quantity, 'unit_code' => $line->unit_code, 'specifications' => $saved['specifications'] ?? [],
                    'unit_price_centavos' => (int) ($amount['unit_price_centavos'] ?? $line->unit_price_centavos)];
            }
            $result[$order->id] = ['id' => $order->id, 'reference' => $order->reference, 'accepted' => $order->accepted_snapshot_version !== null,
                'lines' => $items, 'fulfillment_method' => $content['fulfillment_method'] ?? $order->fulfillment_method,
                'payment_method' => $content['payment_method'] ?? $order->payment_method, 'fulfillment_date' => $content['fulfillment_date'] ?? $order->expected_fulfillment_date];
        }

        return $result;
    }

    /** @param array<string, mixed> $reference
     * @return array<string, mixed> */
    private function base(array $reference): array
    {
        $view = array_intersect_key($reference, array_flip(['version_id', 'version', 'content_hash', 'destination', 'arrangement_id', 'arrangement_vendor_id']));
        // Package-wide budgets, missing materials and other suppliers' allocations are not Vendor work instructions.
        $view['work_package'] = array_intersect_key($reference['work_package'] ?? [], array_flip(['name', 'site', 'destination', 'fulfillment_method', 'payment_method', 'fulfillment_date', 'site_contact', 'access_instructions', 'note', 'notes']));

        return $view;
    }
}
