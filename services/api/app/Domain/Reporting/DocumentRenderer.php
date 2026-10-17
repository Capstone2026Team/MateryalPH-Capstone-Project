<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use Dompdf\Dompdf;
use Dompdf\Options;

final class DocumentRenderer
{
    public const WATERMARK = 'SAMPLE / DEMO — NOT A TAX INVOICE — NOT FOR BIR FILING';

    public static function cell(mixed $value): string
    {
        $text = (string) ($value ?? '');

        // Excel/Sheets may strip leading whitespace before evaluating a formula.
        return preg_match('/^[\s\x{FEFF}]*[=+@\-]/u', $text) || preg_match('/^[\t\r\n]/', $text) ? "'".$text : $text;
    }

    /** @param array<string, mixed> $snapshot */
    public function render(array $snapshot, string $format): string
    {
        if ($format === 'CSV') {
            $stream = fopen('php://temp', 'w+');
            $rows = [[self::WATERMARK], [$snapshot['title']], ['Generated (Asia/Manila)', $snapshot['generated_at']], ['Source version hash', $snapshot['source_hash']], ...$snapshot['rows']];
            if (isset($snapshot['captured_at'])) {
                array_splice($rows, 3, 0, [['Snapshot captured (Asia/Manila)', $snapshot['captured_at']]]);
            }
            foreach ($rows as $row) {
                fputcsv($stream, array_map(self::cell(...), $row), ',', '"', '', "\r\n");
            }
            rewind($stream);
            $result = stream_get_contents($stream);
            fclose($stream);

            return $result;
        }
        $options = new Options;
        $options->set('isRemoteEnabled', false);
        $options->set('isPhpEnabled', false);
        $options->set('defaultFont', 'DejaVu Sans');
        $pdf = new Dompdf($options);
        $pdf->loadHtml(view('reports.document', ['document' => $snapshot, 'watermark' => self::WATERMARK])->render());
        $columns = max(array_map(count(...), $snapshot['rows']) ?: [1]);
        $pdf->setPaper('A4', $columns > 6 ? 'landscape' : 'portrait');
        $pdf->render();

        return $pdf->output();
    }
}
