<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * Online channels come from the versioned TEST fee schedule intersected with what the selected adapter can route.
 * A channel is offered only when its version is enabled, refund-capable and supported by a configured adapter;
 * every other channel stays listed with the reason it is unavailable (approved by the project owner 2026-10-02:
 * cards plus GCash, Maya, GrabPay and ShopeePay; QR Ph, over-the-counter, direct debit and bank transfer disabled).
 */
final class PaymentChannelCatalog
{
    public function __construct(private readonly PaymentGateway $gateway) {}

    /** @return list<object> current version per channel */
    public function versions(): array
    {
        return DB::table('payment_channel_fee_versions')->where('environment', 'TEST')->where('effective_from', '<=', now())
            ->where(fn ($query) => $query->whereNull('effective_until')->orWhere('effective_until', '>', now()))
            ->orderByRaw("CASE channel_kind WHEN 'EWALLET' THEN 1 WHEN 'CARD' THEN 2 ELSE 3 END")->orderBy('display_name')->get()->all();
    }

    /**
     * Channel options for one principal. $bearer BUYER grosses the fee up into the Buyer total; PLATFORM means the
     * platform absorbs its own bill charge, so the payer's fee is zero and the charge is an expense.
     *
     * @return list<array<string, mixed>>
     */
    public function options(int $principalCentavos, string $bearer = 'BUYER'): array
    {
        $descriptor = $this->gateway->descriptor();

        return array_map(function (object $version) use ($principalCentavos, $bearer, $descriptor): array {
            $reason = $this->unavailableReason($version, $descriptor, $principalCentavos);
            $quote = $reason === null ? $this->quote($version, $principalCentavos, $bearer) : null;

            return [
                'code' => (string) $version->channel_code, 'display_name' => (string) $version->display_name, 'kind' => (string) $version->channel_kind,
                'available' => $reason === null, 'unavailable_reason' => $reason, 'refund_supported' => (bool) $version->refund_supported,
                'fee_version' => (int) $version->version, 'rate_label' => self::rateLabel($version),
                'fee_centavos' => $quote['fee_centavos'] ?? null, 'total_centavos' => $quote['total_centavos'] ?? null,
                'fee_bearer' => $bearer, 'rate_source' => 'DEMO_PUBLISHED_RATE',
            ];
        }, $this->versions());
    }

    /** @return array{version: object, fee_centavos: int, provider_charge_centavos: int, total_centavos: int, calculation: array<string, mixed>} */
    public function select(string $channelCode, int $principalCentavos, string $bearer = 'BUYER'): array
    {
        $descriptor = $this->gateway->descriptor();
        foreach ($this->versions() as $version) {
            if ($version->channel_code !== $channelCode) {
                continue;
            }
            $reason = $this->unavailableReason($version, $descriptor, $principalCentavos);
            if ($reason !== null) {
                throw new AuthenticationException('PAYMENT_CHANNEL_UNAVAILABLE', self::reasonMessage($reason), $reason === 'PROVIDER_NOT_CONFIGURED' ? 503 : 422, ['channel_code' => [$reason]]);
            }

            return ['version' => $version] + $this->quote($version, $principalCentavos, $bearer);
        }
        throw new AuthenticationException('PAYMENT_CHANNEL_UNAVAILABLE', 'Choose one of the listed payment channels.', 422, ['channel_code' => ['UNKNOWN_CHANNEL']]);
    }

    /** @return array{fee_centavos: int, provider_charge_centavos: int, total_centavos: int, calculation: array<string, mixed>} */
    private function quote(object $version, int $principalCentavos, string $bearer): array
    {
        $terms = ['rate_ppm' => (int) $version->rate_ppm, 'fixed_centavos' => (int) $version->fixed_centavos, 'fee_vat_basis_points' => (int) $version->fee_vat_basis_points, 'rate_includes_vat' => (bool) $version->rate_includes_vat];
        if ($bearer === 'PLATFORM') {
            $charge = ProcessingFeeCalculator::charge($principalCentavos, $terms);

            return ['fee_centavos' => 0, 'provider_charge_centavos' => $charge['charge_centavos'], 'total_centavos' => $principalCentavos,
                'calculation' => ['version' => ProcessingFeeCalculator::VERSION, 'bearer' => 'PLATFORM', 'terms' => $terms] + $charge];
        }
        $grossUp = ProcessingFeeCalculator::grossUp($principalCentavos, $terms);

        return ['fee_centavos' => $grossUp['fee_centavos'], 'provider_charge_centavos' => $grossUp['provider_charge_centavos'], 'total_centavos' => $grossUp['total_centavos'],
            'calculation' => ['version' => ProcessingFeeCalculator::VERSION, 'bearer' => 'BUYER', 'terms' => $terms] + $grossUp];
    }

    private function unavailableReason(object $version, GatewayDescriptor $descriptor, int $principalCentavos): ?string
    {
        return match (true) {
            ! (bool) $version->enabled => (string) $version->disabled_reason,
            ! (bool) $version->refund_supported => 'REFUND_ROUTE_UNAVAILABLE',
            ! $descriptor->configured => 'PROVIDER_NOT_CONFIGURED',
            ! in_array($version->provider_channel_code, $descriptor->supportedProviderChannels, true) => 'ADAPTER_UNSUPPORTED',
            $version->minimum_amount_centavos !== null && $principalCentavos < (int) $version->minimum_amount_centavos => 'BELOW_CHANNEL_MINIMUM',
            $version->maximum_amount_centavos !== null && $principalCentavos > (int) $version->maximum_amount_centavos => 'ABOVE_CHANNEL_MAXIMUM',
            default => null,
        };
    }

    public static function reasonMessage(string $reason): string
    {
        return match ($reason) {
            'REFUND_ROUTE_UNAVAILABLE' => 'This channel is not offered because it has no approved refund route.',
            'PROVIDER_NOT_CONFIGURED' => 'Online payment is temporarily unavailable. Try again later.',
            'ADAPTER_UNSUPPORTED' => 'This channel is not supported by the payment provider configuration.',
            'BELOW_CHANNEL_MINIMUM', 'ABOVE_CHANNEL_MAXIMUM' => 'This amount is outside the channel limits. Choose another channel.',
            default => 'This payment channel is unavailable.',
        };
    }

    private static function rateLabel(object $version): string
    {
        $percent = rtrim(rtrim(bcdiv((string) $version->rate_ppm, '10000', 2), '0'), '.');
        $fixed = (int) $version->fixed_centavos > 0 ? ' + ₱'.number_format((int) $version->fixed_centavos / 100, 2) : '';

        return $percent.'%'.$fixed.((bool) $version->rate_includes_vat ? ' (VAT inclusive)' : ' + 12% VAT on the fee');
    }
}
