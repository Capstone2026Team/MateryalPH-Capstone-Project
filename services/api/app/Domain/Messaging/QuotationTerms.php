<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\ListingTaxPolicy;
use App\Domain\Finance\FinancialCalculator;
use App\Domain\Finance\FinancialSnapshotService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Orders\NrpcTerms;
use App\Domain\Orders\OrderDeliveryPlanner;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Vendors\ConfirmedDeliverySnapshot;
use App\Domain\Vendors\DeliveryRecommendationService;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/** One FIN-02 quotation calculator for both procurement contexts. No writes to public price sources. */
final class QuotationTerms
{
    /**
     * @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function validate(array $input): array
    {
        return Validator::make($input, [
            'lines' => ['required', 'array', 'min:1', 'max:100'],
            'lines.*.variant_id' => ['required', 'uuid', 'distinct'],
            'lines.*.quantity' => ['required', 'regex:/^\d{1,10}(\.\d{1,4})?$/', 'numeric', 'gt:0'],
            'lines.*.unit_price_centavos' => ['required', 'integer', 'between:1,100000000000'],
            'lines.*.description' => ['sometimes', 'string', 'max:200'], 'lines.*.specifications' => ['sometimes', 'array', 'max:30'],
            'lines.*.specifications.*' => ['string', 'max:200'],
            'fulfillment_method' => ['required', 'in:PICKUP,DELIVERY'], 'payment_method' => ['required', 'in:ONLINE'],
            'fulfillment_date' => ['required', 'date_format:Y-m-d', 'after_or_equal:'.now('Asia/Manila')->toDateString()],
            'deadline_hours' => ['sometimes', 'integer', 'between:1,72'], 'vendor_discount_centavos' => ['sometimes', 'integer', 'min:0'],
            'delivery' => ['nullable', 'array'], 'delivery.vehicles' => ['required_if:fulfillment_method,DELIVERY', 'array', 'min:1', 'max:20'],
            'delivery.vehicles.*.vehicle_id' => ['required', 'uuid'], 'delivery.vehicles.*.number_of_vehicles' => ['required', 'integer', 'min:1'],
            'delivery.vehicles.*.total_vehicle_trips' => ['required', 'integer', 'min:1'], 'delivery.vehicles.*.group_key' => ['sometimes', 'string', 'max:40'],
            'delivery.final_fee_centavos' => ['required_if:fulfillment_method,DELIVERY', 'integer', 'min:0'],
            'delivery.arrangement' => ['required_if:fulfillment_method,DELIVERY', 'string', 'max:2000'],
            'delivery.access_confirmed' => ['required_if:fulfillment_method,DELIVERY', 'boolean'],
            'delivery.heavy_vehicle_access_confirmed' => ['sometimes', 'boolean'], 'delivery.manual_review_note' => ['nullable', 'string', 'max:2000'],
            'nrpc' => ['nullable', 'array'], 'nrpc.amount_centavos' => ['required_with:nrpc', 'integer', 'min:1'],
            'nrpc.reason' => ['required_with:nrpc', 'string', 'min:3', 'max:2000'], 'nrpc.allocations' => ['required_with:nrpc', 'array', 'min:1'],
            'nrpc.allocations.*' => ['required', 'integer', 'min:1'],
        ])->validate();
    }

    /**
     * @param array<string, mixed> $input
     * @return array<string, mixed>|null */
    public function route(object $c, array $input): ?array
    {
        if ($input['fulfillment_method'] !== 'DELIVERY') {
            return null;
        }

        $order = $this->deliveryOrder($c);
        $destination = json_decode($order->destination, true);
        if (! in_array($destination['heavy_vehicle_restriction'] ?? 'UNANSWERED', ['YES', 'NO'], true)) {
            throw new AuthenticationException('DELIVERY_ACCESS_REQUIRED', 'The Buyer must declare heavy vehicle access and the delivery destination before a delivery quotation can be published.', 422);
        }

        return app(OrderDeliveryPlanner::class)->route($order);
    }

    public function deliveryOrder(object $c): object
    {
        $reference = json_decode((string) $c->locked_reference, true);

        return (object) ['vendor_organization_id' => $c->vendor_organization_id, 'destination' => json_encode($reference['destination'] ?? [], JSON_THROW_ON_ERROR)];
    }

    /**
     * @param array<string, mixed> $input
     * @param array<string, mixed>|null $route
     * @return array<string, mixed> */
    public function freeze(User $actor, object $c, array $input, ?array $route): array
    {
        $allowed = app(ListingTaxPolicy::class)->allowedCategories((string) $c->vendor_organization_id);
        $taxVersion = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $c->vendor_organization_id)->value('current_version_id');
        $lines = [];
        foreach ($input['lines'] as $line) {
            $v = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('units as u', 'u.id', '=', 'v.unit_id')
                ->join('listing_price_versions as p', fn ($j) => $j->on('p.listing_variant_id', '=', 'v.id')->where('p.price_kind', 'ORDINARY')->whereNull('p.retired_at'))
                ->where('v.id', $line['variant_id'])->where('l.vendor_organization_id', $c->vendor_organization_id)
                ->first(['v.*', 'l.display_name', 'l.publication_version', 'p.id as price_version_id', 'p.tax_category', 'p.tax_basis', 'u.code as unit_code', 'u.precision']);
            if ($v === null) {
                throw new AuthenticationException('LINE_NOT_ELIGIBLE', 'Choose current products from this store.', 422);
            }
            if (! in_array($v->tax_category, ListingTaxPolicy::CATEGORIES, true) || ! in_array($v->tax_category, $allowed, true)) {
                throw new AuthenticationException('PAYABLE_TAX_CATEGORY_UNKNOWN', 'A verified payable tax category is required before publication.', 422);
            }
            $qty = StockAvailability::quantity($line['quantity']);
            $product = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->where('l.id', $v->vendor_listing_id)->first(['p.material_id', 'p.brand', 'l.technical_attributes']);
            if (bccomp($qty, bcadd($qty, '0', (int) $v->precision), 4) !== 0) {
                throw new AuthenticationException('INVALID_QUANTITY', 'Use the product unit precision.', 422);
            }
            $lines[] = ['line_id' => (string) $v->id, 'variant_id' => (string) $v->id, 'listing_id' => (string) $v->vendor_listing_id, 'unit_id' => (string) $v->unit_id,
                'description' => $line['description'] ?? (string) $v->display_name, 'specifications' => $line['specifications'] ?? array_merge(json_decode($product->technical_attributes ?? '{}', true), json_decode($v->attributes ?? '{}', true)),
                'material_id' => $product->material_id, 'brand' => $product->brand, 'preferred_brand' => $product->brand, 'variant_label' => (string) $v->label, 'unit_code' => $v->unit_code, 'quantity' => $qty,
                'unit_price_centavos' => (int) $line['unit_price_centavos'], 'tax_category' => (string) $v->tax_category, 'tax_basis' => $v->tax_basis,
                'source_price_version_id' => (string) $v->price_version_id, 'source_tax_version_id' => $taxVersion, 'publication_version' => (int) $v->publication_version,
                'load' => ['weight_kg' => $v->weight_kg, 'length_cm' => $v->length_cm, 'width_cm' => $v->width_cm, 'height_cm' => $v->height_cm] + $this->materialLoad($v)];
        }
        $blockers = app(OrderEligibility::class)->lineBlockers((string) $c->vendor_organization_id, array_column($lines, 'tax_category', 'variant_id'));
        if ($blockers !== []) {
            throw new AuthenticationException('LINE_NOT_ELIGIBLE', 'A product is no longer available for quotation.', 409);
        }
        $delivery = null;
        if ($input['fulfillment_method'] === 'DELIVERY') {
            if (! ($input['delivery']['access_confirmed'] ?? false)) {
                throw new AuthenticationException('DELIVERY_ACCESS_REQUIRED', 'Confirm access for the delivery vehicles.', 422);
            }
            $loadLines = array_map(static fn (array $l): object => (object) ['id' => $l['variant_id'], 'quantity' => $l['quantity'], 'snapshot' => json_encode($l, JSON_THROW_ON_ERROR)], $lines);
            $load = app(OrderDeliveryPlanner::class)->load($this->deliveryOrder($c), $loadLines, [], (array) $route, true, (bool) ($input['delivery']['heavy_vehicle_access_confirmed'] ?? false));
            $delivery = app(ConfirmedDeliverySnapshot::class)->prepare($actor, $load, $input['delivery']['vehicles'], (int) $input['delivery']['final_fee_centavos'],
                $input['delivery']['arrangement'], $input['fulfillment_date'], $input['delivery']['manual_review_note'] ?? null);
        }
        $nrpc = $input['nrpc'] ?? null;
        $terms = $nrpc === null ? null : app(NrpcTerms::class)->current();
        if ($nrpc !== null && ($terms === null || $terms['content'] === null)) {
            throw new AuthenticationException('NRPC_TERMS_UNAVAILABLE', 'NRPC Terms must be available before publication.', 503);
        }
        $commercial = FinancialCalculator::commercial($lines, (int) ($input['vendor_discount_centavos'] ?? 0), $delivery === null ? 0 : (int) $delivery['final_charge_centavos'], $nrpc);

        return ['lines' => $lines, 'commercial' => $commercial, 'fulfillment_method' => $input['fulfillment_method'], 'payment_method' => $input['payment_method'],
            'fulfillment_date' => $input['fulfillment_date'], 'delivery' => $delivery, 'destination' => json_decode($this->deliveryOrder($c)->destination, true),
            'nrpc' => $nrpc === null ? null : $nrpc + ['terms' => $terms], 'price_source' => 'PRIVATE_TRANSACTION',
            'fee_policy_version_id' => FinancialSnapshotService::currentFeePolicyId(), 'processing_fee_status' => 'PENDING_PAYMENT_CHANNEL'];
    }

    /** @return array<string, mixed> */
    private function materialLoad(object $variant): array
    {
        $code = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->join('materials as m', 'm.id', '=', 'p.material_id')->where('l.id', $variant->vendor_listing_id)->value('m.code');

        return $code === 'READY_MIXED_CONCRETE' ? ['material_kind' => DeliveryRecommendationService::READY_MIXED_CONCRETE, 'volume_m3_per_unit' => $variant->unit_code === 'M3' ? '1' : null] : [];
    }

    /** Full field-level before/after, including removals.
     * @param array<string, mixed> $before
     * @param array<string, mixed> $after
     * @return list<array<string, mixed>> */
    public static function changes(array $before, array $after, string $prefix = ''): array
    {
        $changes = [];
        foreach (array_unique([...array_keys($before), ...array_keys($after)]) as $key) {
            if (in_array($key, ['changes', 'original_changes'], true)) {
                continue;
            }
            $old = $before[$key] ?? null;
            $new = $after[$key] ?? null;
            $path = $prefix === '' ? (string) $key : $prefix.'.'.$key;
            if (is_array($old) && is_array($new)) {
                $changes = [...$changes, ...self::changes($old, $new, $path)];
            } elseif ($old !== $new) {
                $name = preg_replace_callback('/^lines\.(\d+)\./', static fn (array $match): string => 'Product '.((int) $match[1] + 1).' ', $path);
                $name = ucfirst(str_replace(['_', '.', 'centavos'], [' ', ' ', ''], (string) $name));
                $changes[] = ['path' => $path, 'before' => $old, 'after' => $new,
                    'label' => trim($name).($old === null ? ' added: '.self::describe($new, $path) : ($new === null ? ' removed: '.self::describe($old, $path) : ' changed from '.self::describe($old, $path).' to '.self::describe($new, $path))).'.'];
            }
        }

        return $changes;
    }

    /** @param array<string, mixed> $original
     * @param array<string, mixed> $proposed
     * @return list<array<string, mixed>> */
    public static function projectChanges(array $original, array $proposed): array
    {
        $before = ['lines' => array_map(static fn (array $l): array => ['description' => $l['name'], 'quantity' => $l['quantity'], 'unit_code' => $l['unit_code'],
            'specifications' => $l['specifications'], 'preferred_brand' => $l['preferred_brand']], $original['lines']),
            'fulfillment_method' => $original['fulfillment_method'], 'payment_method' => $original['payment_method'], 'destination' => $original['destination'],
            'fulfillment_date' => null, 'delivery' => null, 'nrpc' => null];
        $after = array_intersect_key($proposed, $before);
        $after['lines'] = array_map(static fn (array $l): array => array_intersect_key($l, array_flip(['description', 'quantity', 'unit_code', 'specifications', 'preferred_brand', 'variant_id', 'unit_price_centavos'])), $proposed['lines']);

        return self::changes($before, $after);
    }

    private static function describe(mixed $value, string $path): string
    {
        if (is_array($value)) {
            if (isset($value['description'], $value['quantity'], $value['unit_code'])) {
                return $value['description'].' ('.$value['quantity'].' '.$value['unit_code'].')';
            }

            return implode('; ', array_map(static fn (mixed $item, mixed $key): string => (is_string($key) ? str_replace('_', ' ', $key).': ' : '').self::describe($item, $path.'.'.$key), $value, array_keys($value)));
        }
        if (is_bool($value)) {
            return $value ? 'Yes' : 'No';
        }
        if (is_numeric($value) && str_ends_with($path, '_centavos')) {
            return '₱'.number_format((int) $value / 100, 2);
        }

        return $value === null ? 'None' : str_replace('_', ' ', (string) $value);
    }
}
