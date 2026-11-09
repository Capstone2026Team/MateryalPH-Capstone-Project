<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Dompdf\Dompdf;
use Dompdf\Options;

final class PlatformFeeInvoiceRenderer
{
    /** @param array<string, mixed> $invoice */
    public function render(array $invoice): string
    {
        $options = new Options;
        $options->set('isRemoteEnabled', false);
        $options->set('isPhpEnabled', false);
        $options->set('defaultFont', 'DejaVu Sans');
        $pdf = new Dompdf($options);
        $pdf->loadHtml(view('reports.platform-fee-invoice', ['invoice' => $invoice])->render());
        $pdf->setPaper('A4');
        $pdf->render();
        $pdf->getCanvas()->page_text(490, 810, '{PAGE_NUM} / {PAGE_COUNT}', $pdf->getFontMetrics()->getFont('DejaVu Sans'), 8, [0.28, 0.33, 0.41]);

        return $pdf->output();
    }
}
