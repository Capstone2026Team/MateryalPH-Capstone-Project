<?php

declare(strict_types=1);

namespace App\Domain\Payments;

/** Converts between integer centavos and the provider's decimal PHP amount without binary rounding drift. */
final class ProviderAmount
{
    public static function toProvider(int $centavos): float|int
    {
        return $centavos % 100 === 0 ? intdiv($centavos, 100) : (float) bcdiv((string) $centavos, '100', 2);
    }

    /** Returns null for anything that is not an exact amount with at most two decimals. */
    public static function toCentavos(mixed $amount): ?int
    {
        if (is_int($amount)) {
            return $amount >= 0 ? $amount * 100 : null;
        }
        if (is_float($amount) && is_finite($amount) && $amount >= 0) {
            $text = rtrim(rtrim(number_format($amount, 6, '.', ''), '0'), '.');
        } elseif (is_string($amount)) {
            $text = $amount;
        } else {
            return null;
        }
        if (preg_match('/^\d{1,12}(?:\.\d{1,2})?$/', $text) !== 1) {
            return null;
        }

        return (int) bcmul($text, '100', 0);
    }
}
