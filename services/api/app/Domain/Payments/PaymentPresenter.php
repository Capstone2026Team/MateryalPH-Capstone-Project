<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

/**
 * Client view of one payment attempt. Provider identifiers, account IDs and raw payloads never leave the API; the
 * hosted checkout link is returned only to its payer while the attempt is open. Status text is always explicit:
 * everything before verified capture reads Pending, never success.
 */
final class PaymentPresenter
{
    /** @return array<string, mixed> */
    public function attempt(object $payment, bool $includeCheckoutUrl): array
    {
        $open = in_array($payment->state, PaymentSettlement::OPEN_STATES, true);
        $expired = $payment->expires_at !== null && CarbonImmutable::parse((string) $payment->expires_at)->isPast();
        $channel = $payment->channel_fee_version_id === null ? null : DB::table('payment_channel_fee_versions')->where('id', $payment->channel_fee_version_id)->value('display_name');
        $status = match (true) {
            $payment->state === 'PAID' && (bool) $payment->late_capture => 'CAPTURED_LATE_REFUND_PENDING',
            $payment->state === 'PAID' => 'PAID',
            $payment->state === 'FAILED' => 'FAILED',
            in_array($payment->state, ['EXPIRED', 'CANCELLED'], true) => 'EXPIRED',
            default => 'PENDING',
        };

        return [
            'id' => (string) $payment->id, 'purpose' => (string) $payment->purpose, 'status' => $status, 'attempt_number' => (int) $payment->attempt_number,
            'order_id' => $payment->order_id === null ? null : (string) $payment->order_id, 'statement_id' => $payment->fee_statement_id === null ? null : (string) $payment->fee_statement_id,
            'channel_code' => $payment->channel_code, 'channel_name' => $channel === null ? null : (string) $channel,
            'principal_centavos' => (int) $payment->principal_centavos, 'processing_fee_centavos' => (int) $payment->processing_fee_centavos, 'total_centavos' => (int) $payment->total_centavos,
            'fee_bearer' => $payment->purpose === 'PLATFORM_FEE_PAYMENT' ? 'PLATFORM' : 'BUYER',
            'expires_at' => self::iso($payment->expires_at), 'paid_at' => self::iso($payment->paid_at), 'created_at' => self::iso($payment->created_at),
            'environment' => (string) $payment->environment, 'evidence_origin' => (string) $payment->evidence_origin,
            'checkout_url' => $includeCheckoutUrl && $payment->state === 'PENDING' && ! $expired && $payment->checkout_url_encrypted !== null ? Crypt::decryptString((string) $payment->checkout_url_encrypted) : null,
            'can_check_status' => $open,
            'message' => match ($status) {
                'PAID' => 'Payment verified by the provider'.($payment->evidence_origin === 'SIMULATED' ? ' (SIMULATED — no provider call)' : ' (TEST — no real charge)').'.',
                'CAPTURED_LATE_REFUND_PENDING' => 'This payment arrived after its window closed. A full refund to the original payment method was queued; it did not confirm the order.',
                'FAILED' => 'The provider could not start this payment. Choose another channel or try again.',
                'EXPIRED' => 'This payment attempt expired without a verified payment.',
                default => $payment->state === 'UNCERTAIN'
                    ? 'Pending: the provider has not confirmed whether this payment started. MateryalPH is checking before another payment can begin.'
                    : 'Pending: waiting for the payment provider to verify this payment. Returning from the payment page does not confirm it.',
            },
        ];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
