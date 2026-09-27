<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Parses a QR payload decoded by the Vendor's browser. The payload is untrusted
 * text; parsed values are editable suggestions only.
 */
final class QrPayloadParser
{
    public const MAX_LENGTH = 2048;

    /** @return array{status: string, confidence: ?float, suggestions: array<string, string>} */
    public function parse(?string $payload): array
    {
        $payload = $payload === null ? '' : trim(mb_substr(preg_replace('/[\x00-\x1F\x7F]+/u', ' ', $payload) ?? '', 0, self::MAX_LENGTH));
        if ($payload === '') {
            return ['status' => 'UNAVAILABLE', 'confidence' => null, 'suggestions' => []];
        }
        $suggestions = [];
        if (filter_var($payload, FILTER_VALIDATE_URL) !== false && in_array(parse_url($payload, PHP_URL_SCHEME), ['http', 'https'], true)) {
            $suggestions['verification_reference'] = mb_substr($payload, 0, 500);
        }
        if (preg_match('/\bICC\b[^A-Z0-9]{0,24}(?:(?:CERT(?:IFICATE)?|NO|NUMBER)[^A-Z0-9]{0,6})*([A-Z0-9][A-Z0-9\/-]{2,39})/i', $payload, $icc) === 1) {
            $suggestions['marking_type'] = 'ICC_STICKER';
            $suggestions['certificate_number'] = strtoupper($icc[1]);
        } elseif (preg_match('/\bPS\b[^A-Z0-9]{0,24}(?:(?:LICEN[CS]E|LIC|NO|NUMBER)[^A-Z0-9]{0,6})*([A-Z0-9][A-Z0-9\/-]{2,39})/i', $payload, $ps) === 1) {
            $suggestions['marking_type'] = 'PS_MARK';
            $suggestions['certificate_number'] = strtoupper($ps[1]);
        }
        if (preg_match('/(?:MANUFACTURER|MFR)\s*[:=]\s*([^;|\n]{2,160})/i', $payload, $manufacturer) === 1) {
            $suggestions['manufacturer_name'] = trim($manufacturer[1]);
        }
        if (preg_match('/IMPORTER\s*[:=]\s*([^;|\n]{2,160})/i', $payload, $importer) === 1) {
            $suggestions['importer_name'] = trim($importer[1]);
        }

        return ['status' => $suggestions === [] ? 'FAILED' : 'EXTRACTED', 'confidence' => isset($suggestions['certificate_number']) ? 0.6 : 0.2, 'suggestions' => $suggestions];
    }
}
