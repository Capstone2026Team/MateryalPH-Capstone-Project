<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use Illuminate\Support\Facades\DB;

/**
 * One comparison for a Work Package line's stated technical details against a product's listing and variant
 * attributes. Values are compared normalized: numbers by value ("15.0" = "15"), text without case or repeated
 * spaces. A detail the Buyer did not state never excludes an offer, but offers that differ in it are distinct
 * specification options the Buyer chooses between (owner request 2026-10-16); nothing is substituted silently.
 */
final class SpecificationMatch
{
    public static function normalize(mixed $value): string
    {
        $text = preg_replace('/\s+/u', ' ', trim((string) $value)) ?? '';
        if (preg_match('/^\+?(\d+)(?:\.(\d+))?$/', $text, $number) === 1) {
            $whole = ltrim($number[1], '0');
            $fraction = rtrim($number[2] ?? '', '0');

            return ($whole === '' ? '0' : $whole).($fraction === '' ? '' : '.'.$fraction);
        }

        return mb_strtolower($text);
    }

    /** @param array<string, mixed> $attributes
     * @return array<string, string> */
    public static function normalizeAll(array $attributes): array
    {
        $clean = [];
        foreach ($attributes as $code => $value) {
            if ($value !== null && trim((string) $value) !== '') {
                $clean[(string) $code] = self::normalize($value);
            }
        }
        ksort($clean);

        return $clean;
    }

    /** Every stated detail is present on the offer with an equal normalized value.
     * @param array<string, mixed> $required
     * @param array<string, mixed> $offered */
    public static function satisfies(array $required, array $offered): bool
    {
        $offered = self::normalizeAll($offered);
        foreach (self::normalizeAll($required) as $code => $value) {
            if (($offered[$code] ?? null) !== $value) {
                return false;
            }
        }

        return true;
    }

    /** Listing technical attributes overlaid by the variant's own attributes.
     * @return array<string, mixed> */
    public static function offered(?string $listingAttributes, ?string $variantAttributes): array
    {
        $listing = json_decode($listingAttributes ?? '{}', true);
        $variant = json_decode($variantAttributes ?? '{}', true);

        return array_merge(is_array($listing) ? $listing : [], is_array($variant) ? $variant : []);
    }

    /** Offers with the same normalized details and option label are one specification option.
     * @param array<string, mixed> $offered */
    public static function optionId(array $offered, ?string $variantLabel): string
    {
        return substr(hash('sha256', json_encode([self::normalizeAll($offered), self::normalize($variantLabel ?? '')], JSON_THROW_ON_ERROR)), 0, 16);
    }

    /** Category attribute definitions in category order, keyed by category and code.
     * @param list<string|null> $categoryIds
     * @return array<string, array<string, object>> */
    public static function definitions(array $categoryIds): array
    {
        $ids = array_values(array_unique(array_filter($categoryIds)));
        $result = array_fill_keys($ids, []);
        if ($ids === []) {
            return $result;
        }
        foreach (DB::table('technical_attribute_definitions')->whereIn('material_category_id', $ids)->orderBy('sort_order')->orderBy('code')
            ->get(['material_category_id', 'code', 'label', 'value_type', 'allowed_values', 'unit_code']) as $row) {
            $result[(string) $row->material_category_id][(string) $row->code] = $row;
        }

        return $result;
    }

    /**
     * Details as the category names them, in category order; codes outside the category keep a readable code.
     *
     * @param  array<string, mixed>  $attributes
     * @param  array<string, object>  $known  one category's definitions from definitions()
     * @return list<array{code: string, label: string, value: string, unit_code: string|null}>
     */
    public static function labelled(array $attributes, array $known): array
    {
        /** @var list<array{code: string, label: string, value: string, unit_code: string|null}> $rows */
        $rows = [];
        foreach ($attributes as $code => $value) {
            $text = trim((string) (is_scalar($value) ? $value : ''));
            if ($text === '') {
                continue;
            }
            $code = (string) $code;
            $definition = $known[$code] ?? null;
            $unit = $definition === null ? '' : (string) ($definition->unit_code ?? '');
            $rows[] = ['code' => $code, 'label' => $definition === null ? ucfirst(str_replace('_', ' ', $code)) : (string) $definition->label, 'value' => $text, 'unit_code' => $unit === '' ? null : $unit];
        }
        $order = array_flip(array_keys($known));
        usort($rows, static fn (array $a, array $b): int => ($order[$a['code']] ?? PHP_INT_MAX) <=> ($order[$b['code']] ?? PHP_INT_MAX) ?: strcmp($a['code'], $b['code']));

        return $rows;
    }
}
