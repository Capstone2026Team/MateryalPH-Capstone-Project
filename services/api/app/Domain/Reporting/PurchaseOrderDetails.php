<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderDeliveryPlanner;
use Illuminate\Support\Facades\DB;

/** Commercial party details only: no staff contacts, account credentials, TINs or coordinates. */
final class PurchaseOrderDetails
{
    /** @return array<string, mixed> */
    public static function capture(string $orderId): array
    {
        $order = DB::table('orders')->where('id', $orderId)->first();
        if ($order === null) {
            throw new AuthenticationException('ORDER_DOCUMENT_UNAVAILABLE', 'The order record is unavailable.', 404);
        }
        $buyer = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->leftJoin('user_profiles as p', 'p.user_id', '=', 'b.user_id')
            ->where('b.id', $order->buyer_profile_id)->first(['p.full_name', 'u.name as account_name', 'u.email', 'p.mobile_e164']);
        $billing = DB::table('order_invoice_details')->where('order_id', $orderId)->first(['billing_name', 'billing_address']);
        $vendor = DB::table('vendor_organizations as v')->leftJoin('store_profiles as s', 's.vendor_organization_id', '=', 'v.id')
            ->where('v.id', $order->vendor_organization_id)->first(['v.legal_business_name', 's.public_store_name', 's.public_email', 's.public_phone']);
        $address = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')
            ->where('a.vendor_organization_id', $order->vendor_organization_id)->value('v.formatted_address');
        $address ??= DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $order->vendor_organization_id)
            ->where('is_current', true)->value('formatted_address');
        $destination = OrderDeliveryPlanner::destination($order);
        $pickup = $order->fulfillment_method === 'PICKUP';
        $point = ($destination['heavy_vehicle_restriction'] ?? '') === 'YES' ? ($destination['alternate_drop_off'] ?? []) : ($destination['intended'] ?? []);
        $deliveryAddress = self::address($point);

        return ['captured_at' => now()->toIso8601String(),
            'buyer' => ['name' => (string) ($buyer?->full_name ?: ($buyer->account_name ?? '')), 'billing_name' => (string) ($billing->billing_name ?? ''),
                'address' => (string) ($billing->billing_address ?? ($pickup ? '' : $deliveryAddress)),
                'email' => (string) ($buyer->email ?? ''), 'phone' => (string) ($buyer->mobile_e164 ?? '')],
            'vendor' => ['name' => (string) ($vendor->public_store_name ?? ''), 'legal_name' => (string) ($vendor->legal_business_name ?? ''),
                'address' => (string) ($address ?? ''), 'email' => (string) ($vendor->public_email ?? ''), 'phone' => (string) ($vendor->public_phone ?? '')],
            'payment_method' => match ($order->payment_method) {
                'ONLINE' => 'Online payment', 'COD' => 'Cash on delivery', 'IN_STORE' => 'In-store payment', default => OrderDocumentLayout::words((string) $order->payment_method)
            },
            'fulfillment_method' => $pickup ? 'Self-Pickup' : 'Site Delivery',
            'fulfillment_address' => $pickup ? self::address($destination['store_address'] ?? $address ?? '') : $deliveryAddress];
    }

    /** Add newly requested Buyer contact fields without recapturing already frozen commercial details.
     * @param array<string, mixed> $details
     * @return array<string, mixed> */
    public static function withBuyerContact(string $orderId, array $details): array
    {
        if (array_key_exists('email', $details['buyer']) && array_key_exists('phone', $details['buyer'])) {
            return $details;
        }
        $buyer = DB::table('orders as o')->join('buyer_profiles as b', 'b.id', '=', 'o.buyer_profile_id')
            ->join('users as u', 'u.id', '=', 'b.user_id')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')
            ->where('o.id', $orderId)->first(['u.email', 'p.mobile_e164']);
        $details['buyer'] += ['email' => (string) ($buyer->email ?? ''), 'phone' => (string) ($buyer->mobile_e164 ?? '')];
        $details['buyer_contact_captured_at'] = now()->toIso8601String();

        return $details;
    }

    /** @param array<string, mixed> $details */
    public static function hash(array $details): string
    {
        return hash('sha256', json_encode(self::sorted($details), JSON_THROW_ON_ERROR));
    }

    /** @param array<mixed> $values
     * @return array<mixed> */
    private static function sorted(array $values): array
    {
        if (! array_is_list($values)) {
            ksort($values);
        }
        foreach ($values as $key => $value) {
            if (is_array($value)) {
                $values[$key] = self::sorted($value);
            }
        }

        return $values;
    }

    private static function address(mixed $point): string
    {
        if (is_string($point)) {
            return $point;
        }
        if (! is_array($point)) {
            return '';
        }
        $value = $point['formatted_address'] ?? $point['address'] ?? '';

        return is_array($value) ? self::address($value) : (is_string($value) ? $value : '');
    }
}
