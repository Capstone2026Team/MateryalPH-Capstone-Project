<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use Illuminate\Support\Str;

/** Deterministic normalization shared by register import, lookup and matching. */
final class RegisterNormalizer
{
    /** Characters OCR commonly reads in place of a digit, with every digit each may stand for. */
    private const DIGIT_LOOKALIKES = [
        'O' => ['0'], 'D' => ['0'], 'Q' => ['0'], 'U' => ['0'], 'I' => ['1'], 'L' => ['1'], 'J' => ['1'], 'T' => ['7'],
        'Z' => ['2'], 'S' => ['5'], 'G' => ['6', '0'], 'B' => ['8'], 'E' => ['8'], 'A' => ['4'],
    ];

    private const MAX_VARIANTS = 16;

    public static function number(string $value): string
    {
        return (string) preg_replace('/[^A-Z0-9]/', '', strtoupper(Str::ascii($value)));
    }

    public static function company(string $value): string
    {
        $value = strtoupper(Str::ascii($value));
        $value = str_replace('&', ' AND ', $value);
        $value = (string) preg_replace('/[^A-Z0-9 ]+/', ' ', $value);

        return trim((string) preg_replace('/\s+/', ' ', $value));
    }

    /**
     * PNS designations without their edition year or adopted-standard body, e.g.
     * "PNS 07:2018" → "PNS07", "PNS ISO 13006:2019" and "PNS 13006:2019" → "PNS13006",
     * "PNS ASTM C1693:2019" → "PNSC1693".
     *
     * @return list<string>
     */
    public static function standards(?string $value): array
    {
        if ($value === null || trim($value) === '') {
            return [];
        }
        preg_match_all('/PNS\s*(?:(?:ISO|IEC|ASTM|EN|BS|JIS|ANSI)\s*[\/-]?\s*)*([A-Z]?\d+)/i', $value, $matches);

        return array_values(array_unique(array_map(static fn (string $number): string => 'PNS'.strtoupper($number), $matches[1])));
    }

    /**
     * Normalized PS licence numbers to look up for a typed value: "Q-0894", "q 894",
     * "PS License No. Q-894" and "0894" all reach "Q0894" and "Q894".
     *
     * @return list<string>
     */
    public static function psLicenceCandidates(string $value): array
    {
        $number = self::number($value);
        $number = (string) preg_replace('/^(?:PS)?(?:LICEN[CS]E|LIC)?(?:NO|NUMBER)?/', '', $number);
        if (preg_match('/^\d{1,6}$/', $number) === 1) {
            $number = 'Q'.$number;
        }
        if (preg_match('/^([A-Z]{1,2})(\d{1,6})$/', $number, $parts) !== 1) {
            return $number === '' ? [] : [$number];
        }
        $digits = ltrim($parts[2], '0') ?: '0';

        return array_values(array_unique([$number, $parts[1].$digits, $parts[1].str_pad($digits, 4, '0', STR_PAD_LEFT)]));
    }

    /**
     * An ICC sticker serial: one or two letters followed by the printed digits
     * (A500000001, B012717015). Leading zeros are significant to the printed
     * value but not to its position in a register range.
     *
     * @return array{prefix: string, number: int, digits: int, display: string}|null
     */
    public static function serial(string $value): ?array
    {
        $normalized = self::number($value);
        if (preg_match('/^([A-Z]{1,2})(\d{6,12})$/', $normalized, $parts) !== 1) {
            return null;
        }

        return ['prefix' => $parts[1], 'number' => (int) $parts[2], 'digits' => strlen($parts[2]), 'display' => $normalized];
    }

    /**
     * Readings of an OCR token with digit look-alikes replaced. The leading
     * letters stay letters; ambiguous characters fan out to a bounded set.
     *
     * @return list<string>
     */
    public static function ocrVariants(string $prefix, string $digits): array
    {
        $variants = [''];
        foreach (str_split(strtoupper($digits)) as $character) {
            $options = ctype_digit($character) ? [$character] : (self::DIGIT_LOOKALIKES[$character] ?? []);
            if ($options === []) {
                return [];
            }
            $next = [];
            foreach ($variants as $variant) {
                foreach ($options as $option) {
                    $next[] = $variant.$option;
                }
            }
            $variants = array_slice($next, 0, self::MAX_VARIANTS);
        }

        return array_map(static fn (string $variant): string => $prefix.$variant, $variants);
    }

    /**
     * Significant words for product relevance: upper-case, punctuation removed,
     * simple plurals folded, connectives dropped.
     *
     * @return list<string>
     */
    public static function productWords(?string $value): array
    {
        if ($value === null) {
            return [];
        }
        $words = preg_split('/\s+/', self::company((string) preg_replace('/\(.*?\)/', ' ', $value))) ?: [];
        $stop = ['AND', 'OR', 'OF', 'FOR', 'THE', 'WITH', 'IN', 'A', 'AN', 'TO', 'TYPE', 'SUPPLY', 'GENERAL', 'USE'];
        $folded = [];
        foreach ($words as $word) {
            if ($word === '' || in_array($word, $stop, true) || strlen($word) < 2) {
                continue;
            }
            $folded[] = strlen($word) > 3 && str_ends_with($word, 'S') && ! str_ends_with($word, 'SS') ? substr($word, 0, -1) : $word;
        }

        return array_values(array_unique($folded));
    }
}
