<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Reads PS/ICC marking text produced by OCR. Labelled values are proposed only
 * when unambiguous. The marking number (PS License No. or ICC sticker serial)
 * is also read from its printed shape, because OCR rarely reproduces the label
 * exactly ("Licensa Mo, Q-1234", "AS00000001"); every reading is returned as a
 * ranked candidate so the register lookup can confirm which one exists.
 */
final class MarkingTextParser
{
    /** Q-1234 with tolerated OCR noise between the prefix and the digits. */
    private const PS_NUMBER = '/(?<![A-Z0-9])(?:[QG]|[O0](?=\s*[-–—]))\s*[-–—~.]?\s*([0-9OILSZGBDT]{3,5})(?![A-Z0-9])/u';

    /** One letter followed by seven to ten printed digits, e.g. A500000001. */
    private const ICC_SERIAL = '/(?<![A-Z0-9])([A-Z])\s?([0-9OILSZGBDT]{7,11})(?![A-Z0-9])/u';

    private const SERIAL_DIGITS = 9;

    /** @return array<string, string> */
    public function parse(string $text, ?string $markingType = null): array
    {
        return $this->read($text, $markingType)['suggestions'];
    }

    /**
     * @return array{suggestions: array<string, string>, candidates: list<string>}
     */
    public function read(string $text, ?string $markingType = null): array
    {
        $text = str_replace(["\r\n", "\r"], "\n", $text);
        $ps = (bool) preg_match('/\bPS\b|\bPHILIPPINE\s+STANDARDS?\b|\bBPS\b|\bPRODUCT\s+(?:SAFETY|QUALITY)\b/i', $text);
        $icc = (bool) preg_match('/\bICC\b|\bIMPORT\s+COMMODITY\s+CLEARANCE\b/i', $text);
        $detected = $ps !== $icc ? ($ps ? 'PS_MARK' : 'ICC_STICKER') : null;
        $suggestions = $detected === null ? [] : ['marking_type' => $detected];
        $type = in_array($markingType, ['PS_MARK', 'ICC_STICKER'], true) ? $markingType : $detected;

        $labelled = $this->labelled($text);
        $certificate = $labelled['certificate_number'] ?? null;
        $serial = $labelled['serial_number'] ?? null;
        unset($labelled['certificate_number'], $labelled['serial_number']);
        $suggestions += $labelled;

        if ($type === null) {
            // Without a known marking type a lone labelled number is still proposed as typed.
            if ($certificate !== null) {
                $suggestions['certificate_number'] = $certificate;
            }

            return ['suggestions' => $suggestions, 'candidates' => []];
        }
        if ($type === 'ICC_STICKER' && $certificate !== null) {
            $suggestions['icc_certificate_number'] = $certificate;
        }
        $readings = $type === 'PS_MARK'
            ? $this->psReadings(($certificate === null ? '' : $certificate."\n").$text)
            : $this->serialReadings(($serial === null ? '' : $serial."\n").$text);
        if (count($readings) === 1) {
            $suggestions['certificate_number'] = array_key_first($readings);
        } elseif ($readings === [] && $type === 'PS_MARK' && $certificate !== null) {
            $suggestions['certificate_number'] = $certificate;
        }

        return ['suggestions' => $suggestions, 'candidates' => array_values(array_unique(array_merge(...array_values($readings ?: [[]]))))];
    }

    /**
     * Distinct printed PS licence numbers, each with its look-alike readings.
     *
     * @return array<string, list<string>>
     */
    private function psReadings(string $text): array
    {
        preg_match_all(self::PS_NUMBER, strtoupper($text), $matches);
        $readings = [];
        foreach ($matches[1] as $digits) {
            if (preg_match_all('/\d/', $digits) < 2) {
                continue;
            }
            $variants = RegisterNormalizer::ocrVariants('Q', $digits);
            if ($variants !== []) {
                $readings['Q-'.substr($variants[0], 1)] ??= $variants;
            }
        }

        return $readings;
    }

    /**
     * Distinct ICC sticker serials, each with its look-alike readings.
     *
     * @return array<string, list<string>>
     */
    private function serialReadings(string $text): array
    {
        preg_match_all(self::ICC_SERIAL, strtoupper($text), $matches, PREG_SET_ORDER);
        $readings = [];
        foreach ($matches as [, $letter, $digits]) {
            if (preg_match_all('/\d/', $digits) < 5) {
                continue;
            }
            $variants = RegisterNormalizer::ocrVariants($letter, $digits);
            // Current stickers print nine digits; OCR on an enlarged photo sometimes doubles one.
            if (strlen($digits) > self::SERIAL_DIGITS) {
                foreach (range(1, strlen($digits) - 1) as $position) {
                    if ($digits[$position] === $digits[$position - 1]) {
                        $variants = [...$variants, ...RegisterNormalizer::ocrVariants($letter, substr($digits, 0, $position).substr($digits, $position + 1))];
                    }
                }
            }
            if ($variants !== []) {
                $readings[$variants[0]] ??= [];
                $readings[$variants[0]] = array_values(array_unique([...$readings[$variants[0]], ...$variants]));
            }
        }
        // When another pass read the same serial without the doubled digit, keep that reading.
        foreach ($readings as $key => $variants) {
            foreach (array_keys($readings) as $other) {
                if ($other !== $key && strlen($key) > strlen($other) && in_array($other, $variants, true)) {
                    $readings[$other] = array_values(array_unique([...$readings[$other], ...$variants]));
                    unset($readings[$key]);
                    break;
                }
            }
        }

        return $readings;
    }

    /** @return array<string, string> */
    private function labelled(string $text): array
    {
        $numberLabel = '(?:\s*(?:NO\.?|NUMBER|#))?';
        $labels = [
            'certificate_number' => ['(?:(?:PS|ICC)\s+)?(?:LICEN[CS]E|CERTIFICATE)'.$numberLabel.'|(?:PS|ICC)\s+(?:NO\.?|NUMBER)', 60],
            'serial_number' => ['(?:ICC\s+)?(?:STICKER\s+)?SERIAL'.$numberLabel, 40],
            'manufacturer_name' => ['MANUFACTURER(?:\s+NAME)?(?!\s+ADDRESS\b)|MANUFACTURED\s+BY', 200],
            'manufacturer_address' => ['MANUFACTURER\s+ADDRESS', 500],
            'importer_name' => ['IMPORTER(?:\s+NAME)?(?!\s+ADDRESS\b)|IMPORTED\s+BY', 200],
            'importer_address' => ['IMPORTER\s+ADDRESS', 500],
            'country_of_manufacture' => ['COUNTRY\s+OF\s+(?:MANUFACTURE|ORIGIN)|MADE\s+IN', 60],
            'brand' => ['BRAND(?:\s+NAME)?', 180],
            'batch_number' => ['(?:BATCH|LOT)'.$numberLabel, 60],
        ];
        $suggestions = [];
        foreach ($labels as $field => [$label, $limit]) {
            preg_match_all('/^(?:'.$label.')(?=[\t :#-]|$)[\t ]*[:#-]?[\t ]*(.*)$/im', $text, $matches, PREG_OFFSET_CAPTURE);
            $values = [];
            foreach ($matches[1] as [$raw, $offset]) {
                // A label may occupy its own line; never consume another labelled field.
                if (trim($raw) === '') {
                    $raw = strtok(substr($text, $offset + strlen($raw) + 1), "\n") ?: '';
                    $otherLabels = implode('|', array_column($labels, 0));
                    if (preg_match('/^(?:'.$otherLabels.')\b/i', trim($raw))) {
                        continue;
                    }
                }
                $value = trim((string) preg_replace('/[\t ]+/', ' ', $raw));
                if ($value === '' || mb_strlen($value) > $limit || preg_match('/[\x00-\x1F]/', $value)) {
                    continue;
                }
                if (in_array($field, ['certificate_number', 'serial_number'], true) && (! preg_match('/^[A-Za-z0-9][A-Za-z0-9 .\/-]*$/', $value) || ! preg_match('/\d/', $value) || strlen($value) < 3 || preg_match('/^(?:PNS|ISO|IEC)\b/i', $value))) {
                    continue;
                }
                $values[$value] = $value;
            }
            if (count($values) === 1) {
                $suggestions[$field] = array_values($values)[0];
            }
        }

        return $suggestions;
    }
}
