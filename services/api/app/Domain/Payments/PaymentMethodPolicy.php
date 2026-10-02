<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * The single payment-method rule for Item checkout, quotations and Project packages (approved by the project
 * owner on 2026-10-02). Online needs the reconciled TEST sub-account. Cash on Delivery pairs only with Site
 * Delivery and In-Store Payment only with Self-Pickup, and each is offered only after the Vendor Owner enables it;
 * both default off. Physical balances are later recorded as obligations, never as online successes.
 */
final class PaymentMethodPolicy
{
    public const METHODS = ['ONLINE', 'CASH_ON_DELIVERY', 'IN_STORE'];

    /** @return array{cod_enabled: bool, in_store_enabled: bool, lock_version: int, updated_at: ?string} */
    public function settings(string $organizationId): array
    {
        $row = DB::table('vendor_payment_settings')->where('vendor_organization_id', $organizationId)->first();

        return ['cod_enabled' => (bool) ($row->cod_enabled ?? false), 'in_store_enabled' => (bool) ($row->in_store_enabled ?? false),
            'lock_version' => (int) ($row->lock_version ?? 0), 'updated_at' => $row?->updated_at === null ? null : (string) $row->updated_at];
    }

    public function onlineReady(string $organizationId): bool
    {
        return DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->where('environment', 'TEST')
            ->where('connection_status', 'CONNECTED_TEST')->whereNotNull('provider_associated_at')->whereNotNull('provider_account_id')->exists();
    }

    /** @return list<array{method: string, available: bool, reason: ?string}> */
    public function options(string $organizationId, ?string $fulfillmentMethod, ?bool $onlineReady = null): array
    {
        $settings = $this->settings($organizationId);
        $online = $onlineReady ?? $this->onlineReady($organizationId);

        return [
            ['method' => 'ONLINE', 'available' => $online, 'reason' => $online ? null : 'VENDOR_ONLINE_PAYMENT_NOT_READY'],
            ['method' => 'CASH_ON_DELIVERY', 'available' => $fulfillmentMethod === 'DELIVERY' && $settings['cod_enabled'],
                'reason' => $fulfillmentMethod !== 'DELIVERY' ? 'SITE_DELIVERY_ONLY' : ($settings['cod_enabled'] ? null : 'NOT_OFFERED_BY_VENDOR')],
            ['method' => 'IN_STORE', 'available' => $fulfillmentMethod === 'PICKUP' && $settings['in_store_enabled'],
                'reason' => $fulfillmentMethod !== 'PICKUP' ? 'SELF_PICKUP_ONLY' : ($settings['in_store_enabled'] ? null : 'NOT_OFFERED_BY_VENDOR')],
        ];
    }

    public function assertAllowed(string $organizationId, string $fulfillmentMethod, string $paymentMethod, ?bool $onlineReady = null): void
    {
        foreach ($this->options($organizationId, $fulfillmentMethod, $onlineReady) as $option) {
            if ($option['method'] === $paymentMethod) {
                if (! $option['available']) {
                    throw new AuthenticationException('PAYMENT_METHOD_UNAVAILABLE', match ($option['reason']) {
                        'SITE_DELIVERY_ONLY' => 'Cash on Delivery is available only with Site Delivery.',
                        'SELF_PICKUP_ONLY' => 'In-Store Payment is available only with Self-Pickup.',
                        'VENDOR_ONLINE_PAYMENT_NOT_READY' => 'This store cannot accept online payment yet.',
                        default => 'This store does not offer that payment method.',
                    }, 422, ['payment_method' => [(string) $option['reason']]]);
                }

                return;
            }
        }
        throw new AuthenticationException('PAYMENT_METHOD_UNAVAILABLE', 'Choose Online, Cash on Delivery or In-Store Payment.', 422, ['payment_method' => ['UNKNOWN_METHOD']]);
    }
}
