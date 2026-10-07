<?php

declare(strict_types=1);

// Synthetic presentation fixtures only; never queries the database or reads business documents.
require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
$directory = __DIR__.'/../docs/design/evidence/phase-15';
if (! is_dir($directory)) mkdir($directory, 0755, true);
$examples = [
    'purchase-order' => ['title' => 'Purchase Order', 'rows' => [
        ['Order', 'DEMO-ORD-0001'], ['Commercial status', 'Accepted'], ['Materials payable PHP', '28,550.00'],
        ['Delivery PHP', '850.00'], ['Item', 'Portland cement Type I, 40 kg bag', 'Quantity', '100'],
        ['Unit price PHP', '285.50'], ['Source snapshot', '01995000-0000-7000-8000-000000000001', 'Version', '2'],
    ]],
    'tax-package' => ['title' => '2307 Sample Support Package', 'rows' => [
        ['Issuer', 'DEMO_PLATFORM_WITHHOLDER'], ['Period', '2026-07-01 to 2026-09-30'],
        ['Payee', 'Month', 'ATC', 'Gross basis PHP', 'Withheld PHP', 'Relief reason'],
        ['DEMO Payee A', '2026-07', 'WC820', '125000.00', '625.00', 'SUBJECT_NO_VALID_RELIEF'],
        ['DEMO Payee A', '2026-08', 'WC820', '125000.00', '625.00', 'SUBJECT_NO_VALID_RELIEF'],
        ['DEMO Payee A', '2026-09', 'WC820', '125000.00', '625.00', 'SUBJECT_NO_VALID_RELIEF'],
        ['Quarter total', '', '', '375000.00', '1875.00'], ['Nominal due', '2026-10-20', 'Actual due', '2026-10-20'],
        ['Reviewer', 'DEMO Independent Reviewer'], ['Source', 'FIN-08 non-eFPS demo v1; calendar reviewed for synthetic presentation only'],
    ]],
];
foreach ($examples as $name => $example) {
    $snapshot = $example + ['generated_at' => '2026-10-05 08:00:00', 'source_hash' => hash('sha256', json_encode($example)), 'versions' => ['fixture' => 'phase15.presentation.v1']];
    file_put_contents($directory.'/'.$name.'.pdf', app(App\Domain\Reporting\DocumentRenderer::class)->render($snapshot, 'PDF'));
}
echo "Rendered two synthetic sample reports.\n";
