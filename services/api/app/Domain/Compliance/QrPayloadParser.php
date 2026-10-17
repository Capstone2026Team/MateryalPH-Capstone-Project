<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Parses a QR payload decoded by the Vendor's browser. The payload is untrusted
 * text — a verification URL, a bare sticker serial or labelled fields — so the
 * marking number is found by its printed shape anywhere in it. Parsed values are
 * editable suggestions only; the register lookup decides whether they exist.
 */
final class QrPayloadParser
{
    public const MAX_LENGTH = 2048;

    /** @return array{status: string, confidence: ?float, suggestions: array<string, string>, candidates: list<string>} */
    public function parse(?string $payload, ?string $markingType = null): array
    {
        $payload = $payload === null ? '' : trim(mb_substr(preg_replace('/[\x00-\x1F\x7F]+/u', ' ', $payload) ?? '', 0, self::MAX_LENGTH));
        if ($payload === '') {
            return ['status' => 'UNAVAILABLE', 'confidence' => null, 'suggestions' => [], 'candidates' => []];
        }
        $suggestions = [];
        if (filter_var($payload, FILTER_VALIDATE_URL) !== false && in_array(parse_url($payload, PHP_URL_SCHEME), ['http', 'https'], true)) {
            $suggestions['verification_reference'] = mb_substr($payload, 0, 500);
        }
        // URL-decoded so "serial=A500000001" and "A500000001" read alike; letters and digits only.
        $text = strtoupper(rawurldecode($payload));
        preg_match_all('/(?<![A-Z0-9])([A-Z]{1,2}\d{7,10})(?![A-Z0-9])/', $text, $serials);
        preg_match_all('/(?<![A-Z0-9])Q\s*-?\s*(\d{3,5})(?![A-Z0-9])/', $text, $licences);
        $serials = array_values(array_unique($serials[1]));
        $licences = array_values(array_unique(array_map(static fn (string $digits): string => 'Q-'.$digits, $licences[1])));
        $detected = $serials !== [] || str_contains($text, 'ICC') ? 'ICC_STICKER' : ($licences !== [] ? 'PS_MARK' : null);
        if ($detected !== null) {
            $suggestions['marking_type'] = $detected;
        }
        // The Vendor's chosen marking type decides which number is read; it is not itself a reading.
        $type = in_array($markingType, ['PS_MARK', 'ICC_STICKER'], true) ? $markingType : $detected;
        $numbers = $type === 'PS_MARK' ? $licences : $serials;
        if (count($numbers) === 1) {
            $suggestions['certificate_number'] = $numbers[0];
        }
        if (preg_match('/(?<!\d)(\d{6}\/\d{4})(?!\d)/', $text, $certificate) === 1) {
            $suggestions['icc_certificate_number'] = $certificate[1];
        }
        if (preg_match('/(?:MANUFACTURER|MFR)\s*[:=]\s*([^;|\n&]{2,160})/i', $payload, $manufacturer) === 1) {
            $suggestions['manufacturer_name'] = trim($manufacturer[1]);
        }
        if (preg_match('/IMPORTER\s*[:=]\s*([^;|\n&]{2,160})/i', $payload, $importer) === 1) {
            $suggestions['importer_name'] = trim($importer[1]);
        }

        return [
            'status' => $suggestions === [] ? 'FAILED' : 'EXTRACTED',
            'confidence' => isset($suggestions['certificate_number']) ? 0.9 : 0.2,
            'suggestions' => $suggestions,
            'candidates' => array_map(static fn (string $number): string => RegisterNormalizer::number($number), $numbers),
        ];
    }
}
