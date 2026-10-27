<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use Dompdf\Adapter\CPDF;
use Dompdf\Dompdf;
use Dompdf\FontMetrics;
use Dompdf\Options;

/** Draw paginated rows directly using Dompdf's PDF canvas, without an unbounded HTML layout tree. */
final class TabularDocumentRenderer
{
    /** @param array<string, mixed> $snapshot */
    public function render(array $snapshot): string
    {
        $options = new Options;
        $options->set('isRemoteEnabled', false);
        $options->set('isPhpEnabled', false);
        $pdf = new Dompdf($options);
        $columns = max(array_map(count(...), $snapshot['rows']) ?: [1]);
        $canvas = new CPDF('a4', $columns > 6 ? 'landscape' : 'portrait', $pdf);
        $metrics = new FontMetrics($canvas, $options);
        $font = $metrics->getFont('DejaVu Sans');
        $bold = $metrics->getFont('DejaVu Sans', 'bold');
        $width = $canvas->get_width() - 76;
        $cellWidth = $width / $columns;
        $bottom = $canvas->get_height() - 50;
        $page = function () use ($canvas, $snapshot, $font, $bold, $width): float {
            $canvas->text(38, 24, 'MateryalPH', $bold, 12, [0.6, 0.2, 0.07]);
            $canvas->text(38, 44, $snapshot['title'], $bold, 16);
            $canvas->text(38, 69, DocumentRenderer::WATERMARK, $bold, 7);
            $canvas->text(38, 83, 'Generated (Asia/Manila): '.$snapshot['generated_at'], $font, 7);
            $canvas->text(38, 95, 'Source version hash: '.$snapshot['source_hash'], $font, 7);
            $canvas->text(38, 107, 'Snapshot captured (Asia/Manila): '.($snapshot['captured_at'] ?? $snapshot['generated_at']), $font, 7);
            $canvas->text(38, 119, 'Immutable snapshot. This report does not replace Vendor goods, platform fee or processor invoices.', $font, 7);
            $canvas->line(38, 136, 38 + $width, 136, [0.76, 0.25, 0.05], 1);

            return 144;
        };
        $y = $page();
        foreach ($snapshot['rows'] as $rowIndex => $row) {
            $rowFont = $rowIndex === 0 ? $bold : $font;
            $lines = array_map(fn (mixed $value): array => $this->wrap((string) ($value ?? ''), $cellWidth - 10, $metrics, $rowFont), $row);
            $lineCount = max(array_map(count(...), $lines) ?: [1]);
            // Keep ordinary rows together; unusually long cells continue onto the next page.
            if ($y + $lineCount * 10 + 10 > $bottom && $lineCount * 10 + 10 <= $bottom - 144) {
                $canvas->new_page();
                $y = $page();
            }
            for ($line = 0; $line < $lineCount; $line++) {
                if ($y + 10 > $bottom) {
                    $canvas->new_page();
                    $y = $page();
                }
                foreach ($lines as $column => $cell) {
                    if (isset($cell[$line])) {
                        $canvas->text(43 + $column * $cellWidth, $y, $cell[$line], $rowFont, 7);
                    }
                }
                $y += 10;
            }
            $y += 5;
            $canvas->line(38, $y, 38 + $width, $y, [0.8, 0.84, 0.88], 0.4);
            $y += 5;
        }
        $canvas->page_text(38, $canvas->get_height() - 28, 'Private authorized copy | {PAGE_NUM} / {PAGE_COUNT}', $font, 7);

        return $canvas->output();
    }

    /** @return list<string> */
    private function wrap(string $value, float $width, FontMetrics $metrics, string $font): array
    {
        $lines = [];
        foreach (preg_split('/\R/u', $value) ?: [''] as $text) {
            do {
                $length = mb_strlen($text);
                $low = 1;
                $high = $length;
                while ($low < $high) {
                    $middle = (int) ceil(($low + $high) / 2);
                    if ($metrics->getTextWidth(mb_substr($text, 0, $middle), $font, 7) <= $width) {
                        $low = $middle;
                    } else {
                        $high = $middle - 1;
                    }
                }
                $lines[] = mb_substr($text, 0, $low);
                $text = mb_substr($text, $low);
            } while ($text !== '');
        }

        return $lines;
    }
}
