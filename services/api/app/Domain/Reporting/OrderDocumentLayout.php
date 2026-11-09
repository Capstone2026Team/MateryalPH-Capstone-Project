<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use Carbon\CarbonImmutable;

/** Presentation of frozen report rows only; never queries or recalculates commercial values. */
final class OrderDocumentLayout
{
    public const VERSION = 5;

    /** @param array<string, mixed> $snapshot */
    public static function kind(array $snapshot): ?string
    {
        return match (strtolower(trim((string) ($snapshot['title'] ?? '')))) {
            'materyalph purchase order', 'purchase order' => 'PURCHASE_ORDER',
            'materyalph payment confirmation', 'payment confirmation' => 'PAYMENT_CONFIRMATION',
            default => null,
        };
    }

    /** @param array<string, mixed> $snapshot
     * @return array<string, mixed> */
    public static function present(array $snapshot): array
    {
        $facts = $amounts = $items = $payments = $additional = [];
        $labels = ['nrpc php' => 'NRPC (included in order)', 'delivery php' => 'Delivery', 'materials vat php' => 'Materials VAT',
            'materials gross php' => 'Materials, VAT inclusive', 'vendor discount php' => 'Vendor discount',
            'commercial total php' => 'Accepted order total', 'materials payable php' => 'Materials payable', 'materials exclusive php' => 'Materials before VAT'];
        $rows = $snapshot['rows'];
        foreach ($rows as $index => $row) {
            $key = strtolower((string) ($row[0] ?? ''));
            if (in_array($key, ['order', 'order status', 'commercial status'], true)) {
                $facts[$key] = (string) ($row[1] ?? '');
            } elseif (isset($labels[$key])) {
                $amounts[$key] = ['label' => $labels[$key], 'value' => self::money((string) ($row[1] ?? ''))];
            } elseif ($key === 'item') {
                $quantity = $rows[$index + 1] ?? [];
                if (strtolower((string) ($quantity[0] ?? '')) !== 'quantity') {
                    $additional[] = $row;

                    continue;
                }
                $items[] = ['name' => (string) ($row[1] ?? ''), 'variant' => (string) ($row[2] ?? ''), 'unit' => (string) ($row[3] ?? ''),
                    'quantity' => self::quantity((string) ($quantity[1] ?? '')), 'price' => self::money((string) ($quantity[3] ?? ''))];
            } elseif ($key === 'quantity' && strtolower((string) ($rows[$index - 1][0] ?? '')) === 'item') {
                continue;
            } elseif ($key === 'payment') {
                $payments[] = ['physical' => false, 'reference' => (string) ($row[1] ?? ''), 'purpose' => self::words((string) ($row[2] ?? '')),
                    'amount' => self::money((string) ($row[3] ?? '')), 'date' => self::date((string) ($row[4] ?? '')),
                    'evidence' => str_contains((string) ($row[5] ?? ''), 'TEST') ? 'TEST provider record' : self::words((string) ($row[5] ?? ''))];
            } elseif ($key === 'vendor-recorded physical payment') {
                $payments[] = ['physical' => true, 'reference' => (string) ($row[1] ?? ''), 'purpose' => 'Physical payment',
                    'amount' => self::money((string) ($row[2] ?? '')), 'date' => self::date((string) ($row[3] ?? '')),
                    'evidence' => 'Vendor-recorded - '.strtolower(self::words((string) ($row[4] ?? '')))];
            } else {
                $additional[] = $row;
            }
        }

        return ['kind' => self::kind($snapshot), 'facts' => $facts, 'amounts' => $amounts, 'items' => $items, 'payments' => $payments,
            'order_details' => $snapshot['order_details'] ?? null, 'details_captured' => isset($snapshot['order_details']['captured_at']) ? self::date((string) $snapshot['order_details']['captured_at']) : null,
            'contact_captured' => isset($snapshot['order_details']['buyer_contact_captured_at']) ? self::date((string) $snapshot['order_details']['buyer_contact_captured_at']) : null,
            'additional' => $additional, 'generated' => self::date((string) $snapshot['generated_at']),
            'captured' => isset($snapshot['captured_at']) ? self::date((string) $snapshot['captured_at']) : null, 'version' => self::VERSION];
    }

    public static function words(string $value): string
    {
        return ucfirst(strtolower(str_replace('_', ' ', $value)));
    }

    public static function money(string $value): string
    {
        $plain = str_replace(',', '', $value);
        if (! preg_match('/^(-?)(\d+)(?:\.(\d{1,2}))?$/D', $plain, $parts)) {
            return $value;
        }

        return $parts[1].preg_replace('/\B(?=(\d{3})+(?!\d))/', ',', $parts[2]).'.'.str_pad($parts[3] ?? '', 2, '0');
    }

    private static function quantity(string $value): string
    {
        return preg_match('/^-?\d+\.\d+$/D', $value) ? rtrim(rtrim($value, '0'), '.') : $value;
    }

    private static function date(string $value): string
    {
        if ($value === '') {
            return 'Not recorded';
        }
        try {
            return CarbonImmutable::parse($value, 'Asia/Manila')->setTimezone('Asia/Manila')->format('d M Y, h:i A');
        } catch (\Throwable) {
            return $value;
        }
    }
}
