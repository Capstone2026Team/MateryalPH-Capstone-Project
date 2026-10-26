<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;

/** Selling quantities, independent of pack contents, prices and delivery measurements. */
final readonly class QuantityPolicy
{
    private const LEGACY = [
        'PC' => ['COUNT', 0], 'SHEET' => ['COUNT', 0],
        'BAG' => ['PACK', 0], 'BOX' => ['PACK', 0], 'ROLL' => ['PACK', 0],
        'GAL' => ['PACK', 0], 'COIL' => ['PACK', 0],
        'KG' => ['MASS', 3], 'M' => ['LENGTH', 3], 'SQM' => ['AREA', 3],
        'CUM' => ['VOLUME', 3], 'L' => ['VOLUME', 3], 'US_GAL' => ['VOLUME', 3],
    ];

    public function __construct(public string $dimension, public int $precision) {}

    /** @param object|array<string, mixed> $unit */
    public static function fromUnit(object|array $unit): self
    {
        $unit = (array) $unit;
        $legacy = self::LEGACY[$unit['code'] ?? $unit['unit_code'] ?? ''] ?? null;
        $dimension = (string) ($unit['dimension'] ?? $legacy[0] ?? '');
        $precision = in_array($dimension, ['COUNT', 'PACK'], true) ? 0 : max(0, min(4, (int) ($unit['precision'] ?? $unit['unit_precision'] ?? $legacy[1] ?? 4)));

        return new self($dimension, $precision);
    }

    public static function forUnit(string $unitId): self
    {
        $unit = DB::table('units')->where('id', $unitId)->first();
        if ($unit === null) {
            throw new \InvalidArgumentException('Unknown selling unit.');
        }

        return self::fromUnit($unit);
    }

    public static function forVariant(string $variantId): self
    {
        $unit = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->where('v.id', $variantId)->first(['u.code', 'u.dimension', 'u.precision']);
        if ($unit === null) {
            throw new \InvalidArgumentException('Unknown product variant.');
        }

        return self::fromUnit($unit);
    }

    /** Historical interpretation never consults a mutable listing or overwrites a record.
     * @param  array<string, mixed>  $snapshot
     */
    public static function historical(array $snapshot): ?self
    {
        $policy = $snapshot['quantity_policy'] ?? null;
        if (is_array($policy) && isset($policy['dimension'], $policy['precision'])) {
            return self::recorded((string) $policy['dimension'], (int) $policy['precision']);
        }
        $code = $snapshot['unit_code'] ?? $snapshot['code'] ?? '';
        if (! isset(self::LEGACY[$code]) && ! isset($snapshot['unit_precision'], $snapshot['dimension'])) {
            return null;
        }
        $basis = self::fromUnit($snapshot + ['code' => $code]);
        if (isset($snapshot['unit_precision']) || isset($snapshot['precision'])) {
            return self::recorded($basis->dimension, (int) ($snapshot['unit_precision'] ?? $snapshot['precision']));
        }
        if (isset($snapshot['quantity_step'])) {
            if ($snapshot['quantity_step'] === '1') {
                return self::recorded($basis->dimension, 0);
            }
            if (preg_match('/^0\.(0*)1$/', (string) $snapshot['quantity_step'], $matches)) {
                return self::recorded($basis->dimension, strlen($matches[1]) + 1);
            }

            return null;
        }

        return $basis;
    }

    private static function recorded(string $dimension, int $precision): ?self
    {
        if ($precision < 0 || $precision > 4 || (in_array($dimension, ['COUNT', 'PACK'], true) && $precision !== 0)) {
            // Contradictory history needs review, never a guessed precision or rounding.
            return null;
        }

        return new self($dimension, $precision);
    }

    public function step(): string
    {
        return $this->precision === 0 ? '1' : '0.'.str_repeat('0', $this->precision - 1).'1';
    }

    public function valid(string $quantity, bool $allowZero = false): bool
    {
        return preg_match('/^\d{1,14}(\.\d{1,4})?$/', $quantity) === 1
            && bccomp($quantity, '0', 4) >= ($allowZero ? 0 : 1)
            && bccomp($quantity, bcadd($quantity, '0', $this->precision), 4) === 0;
    }

    public function message(): string
    {
        return $this->precision === 0 ? 'This selling unit requires a whole number.' : 'This selling unit allows up to '.$this->precision.' decimal places.';
    }

    /** @return array{mode: string, dimension: string, precision: int, step: string} */
    public function toArray(): array
    {
        return ['mode' => in_array($this->dimension, ['COUNT', 'PACK'], true) ? $this->dimension : 'MEASURED',
            'dimension' => $this->dimension, 'precision' => $this->precision, 'step' => $this->step()];
    }

    /** @param object|array<string, mixed> $unit
     * @return array<string, mixed>
     */
    public static function present(object|array $unit): array
    {
        $row = (array) $unit;
        $policy = self::fromUnit($row);

        return array_replace($row, ['precision' => $policy->precision, 'quantity_policy' => $policy->toArray()]);
    }
}
