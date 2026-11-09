<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ $document['title'] }}</title>
    <style>
        /* Print equivalents of the shared MateryalPH semantic color tokens. */
        @page { margin: 36pt 38pt 54pt; }
        body { margin: 0; font-family: 'DejaVu Sans', sans-serif; font-size: 9pt; line-height: 1.5; color: #1F2937; }
        table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        td, th { vertical-align: top; word-wrap: break-word; }
        .header { border-bottom: 2pt solid #C2410C; margin-bottom: 15pt; }
        .header td { padding: 0 0 14pt; }
        .brand { color: #C2410C; font-size: 15pt; font-weight: bold; letter-spacing: .2pt; }
        .eyebrow { color: #475569; font-size: 7.5pt; letter-spacing: .7pt; text-transform: uppercase; }
        h1 { margin: 14pt 0 0; font-size: 25pt; line-height: 1.15; letter-spacing: -.5pt; }
        .reference { text-align: right; padding-top: 3pt !important; width: 39%; }
        .reference strong { display: block; margin: 4pt 0 3pt; font-size: 10pt; }
        .muted { color: #475569; }
        .small { font-size: 8pt; }
        .facts { margin-bottom: 20pt; }
        .facts td { width: 33.33%; padding-right: 12pt; }
        .label { color: #475569; font-size: 7.5pt; margin-bottom: 3pt; }
        .fact { font-weight: bold; font-size: 9pt; }
        h2 { font-size: 11pt; margin: 0 0 8pt; }
        .section { margin-bottom: 19pt; }
        .items thead { display: table-header-group; }
        .items th { background: #F8FAFC; color: #475569; font-size: 7.5pt; font-weight: bold; padding: 8pt 9pt; border-top: 1pt solid #E5E7EB; border-bottom: 1pt solid #E5E7EB; text-align: left; }
        .items td { padding: 10pt 9pt; border-bottom: 1pt solid #E5E7EB; }
        .items tr, .payment, .summary, .record-note { page-break-inside: avoid; }
        .numeric { text-align: right !important; }
        .item-name { font-weight: bold; }
        .variant { color: #475569; font-size: 8pt; margin-top: 3pt; }
        .summary { margin-top: 3pt; }
        .summary > tbody > tr > td:first-child { width: 45%; padding-right: 26pt; }
        .summary > tbody > tr > td:last-child { width: 55%; }
        .amounts td { padding: 5pt 0; font-size: 8.5pt; }
        .amounts td:last-child { text-align: right; width: 30%; }
        .amounts .total td { padding-top: 9pt; border-top: 1pt solid #1F2937; font-weight: bold; font-size: 11pt; }
        .amounts .total td:last-child { color: #C2410C; }
        .tax-details { border-top: 1pt solid #E5E7EB; padding-top: 9pt; margin-top: 12pt; font-size: 7.5pt; }
        .tax-details td { padding: 3pt 0; }
        .tax-details td:last-child { text-align: right; }
        .payment { border: 1pt solid #E5E7EB; margin-bottom: 9pt; }
        .payment-top td { padding: 9pt 11pt 7pt; background: #F8FAFC; }
        .payment-top .payment-value { text-align: right; font-size: 15pt; font-weight: bold; color: #1F2937; }
        .payment-detail { padding: 9pt 11pt 10pt; font-size: 8pt; }
        .payment-detail table td { padding: 0 8pt 7pt 0; }
        .payment-detail .id { font-family: 'DejaVu Sans Mono', monospace; font-size: 7.2pt; }
        .record-note { margin-top: 20pt; padding-top: 11pt; border-top: 1pt solid #E5E7EB; font-size: 7pt; color: #475569; }
        .hash { margin-top: 7pt; font-family: 'DejaVu Sans Mono', monospace; font-size: 6.5pt; word-wrap: break-word; }
        .additional td { padding: 5pt 8pt; border-bottom: 1pt solid #E5E7EB; font-size: 8pt; }
        footer { position: fixed; bottom: -34pt; left: 0; right: 0; border-top: .7pt solid #E5E7EB; padding-top: 7pt; color: #475569; font-size: 7pt; }
        .compact .header { margin-bottom: 12pt; }
        .compact .header td { padding-bottom: 10pt; }
        .compact h1 { font-size: 23pt; margin-top: 8pt; }
        .compact .facts { margin-bottom: 13pt; }
        .compact .section { margin-bottom: 12pt; }
        .compact .items td { padding-top: 8pt; padding-bottom: 8pt; }
        .compact .payment-top td { padding: 7pt 11pt 5pt; }
        .compact .payment-detail { padding: 7pt 11pt 8pt; }
        .compact .amounts td { padding-top: 3pt; padding-bottom: 3pt; }
        .compact .amounts .total td { padding-top: 8pt; }
        .compact .tax-details { margin-top: 9pt; padding-top: 7pt; }
        .compact .tax-details td { padding-top: 2pt; padding-bottom: 2pt; }
        .compact .record-note { margin-top: 12pt; padding-top: 8pt; }
        .parties { margin: 0 0 13pt; page-break-inside: avoid; }
        .parties td { width: 50%; padding-right: 22pt; font-size: 8pt; line-height: 1.45; }
        .party-name { font-size: 10pt; font-weight: bold; margin: 3pt 0 4pt; }
        .party-line { margin-top: 3pt; }
        .methods { margin: 0 0 14pt; padding: 8pt 0; border-top: .7pt solid #E5E7EB; border-bottom: .7pt solid #E5E7EB; page-break-inside: avoid; }
        .methods td { width: 50%; }
    </style>
</head>
<body class="compact">
    <table class="header"><tr>
        <td><div class="brand">MateryalPH</div><div class="eyebrow">Order documents</div><h1>{{ $layout['kind'] === 'PURCHASE_ORDER' ? 'Purchase Order' : 'Payment confirmation' }}</h1></td>
        <td class="reference"><div class="eyebrow">Order reference</div><strong>{{ $layout['facts']['order'] ?? 'Not recorded' }}</strong><div class="muted small">Private authorized copy</div></td>
    </tr></table>

    @if($layout['order_details'])
        <table class="parties"><tr>
            <td><div class="eyebrow">Vendor</div><div class="party-name">{{ $layout['order_details']['vendor']['name'] ?: 'Not provided' }}</div>
                @if($layout['order_details']['vendor']['legal_name'] && $layout['order_details']['vendor']['legal_name'] !== $layout['order_details']['vendor']['name'])<div>{{ $layout['order_details']['vendor']['legal_name'] }}</div>@endif
                <div class="party-line">{{ $layout['order_details']['vendor']['address'] ?: 'Address not provided' }}</div>
                @if($layout['order_details']['vendor']['email'])<div class="party-line">{{ $layout['order_details']['vendor']['email'] }}</div>@endif
                @if($layout['order_details']['vendor']['phone'])<div>{{ $layout['order_details']['vendor']['phone'] }}</div>@endif
            </td>
            <td><div class="eyebrow">Buyer</div><div class="party-name">{{ $layout['order_details']['buyer']['name'] ?: 'Not provided' }}</div>
                @if($layout['order_details']['buyer']['billing_name'] && $layout['order_details']['buyer']['billing_name'] !== $layout['order_details']['buyer']['name'])<div>{{ $layout['order_details']['buyer']['billing_name'] }}</div>@endif
                <div class="party-line">{{ $layout['order_details']['buyer']['address'] ?: 'Address not provided' }}</div>
                <div class="party-line">{{ ($layout['order_details']['buyer']['email'] ?? '') ?: 'Email not provided' }}</div>
                <div>{{ ($layout['order_details']['buyer']['phone'] ?? '') ?: 'Mobile number not provided' }}</div>
            </td>
        </tr></table>
        <div class="methods"><table><tr>
            <td><div class="label">Payment method</div><strong>{{ $layout['order_details']['payment_method'] }}</strong></td>
            <td><div class="label">Fulfillment method</div><strong>{{ $layout['order_details']['fulfillment_method'] }}</strong></td>
        </tr></table>@if($layout['order_details']['fulfillment_method'] === 'Site Delivery' && $layout['order_details']['fulfillment_address'])<div class="small muted" style="margin-top: 7pt">Deliver to: {{ $layout['order_details']['fulfillment_address'] }}</div>@endif</div>
    @endif

    <table class="facts"><tr>
        <td><div class="label">Order status at capture</div><div class="fact">{{ \App\Domain\Reporting\OrderDocumentLayout::words($layout['facts']['order status'] ?? 'Not recorded') }}</div></td>
        <td><div class="label">Commercial status</div><div class="fact">{{ $layout['facts']['commercial status'] ?? 'Not recorded' }}</div></td>
        <td><div class="label">Record issued (Asia/Manila)</div><div class="fact">{{ $layout['generated'] }}</div></td>
    </tr></table>

    @if($layout['kind'] === 'PAYMENT_CONFIRMATION' && $layout['payments'])
        <div class="section">
            <h2>Recorded payment details</h2>
            @foreach($layout['payments'] as $payment)
                <div class="payment">
                    <table class="payment-top"><tr><td><div class="label">{{ $payment['physical'] ? 'Vendor-recorded payment' : 'Recorded payment amount' }}</div><strong>{{ $payment['purpose'] }}</strong></td><td class="payment-value"><span class="small">PHP</span> {{ $payment['amount'] }}</td></tr></table>
                    <div class="payment-detail"><table><tr><td style="width: 50%"><div class="label">Recorded (Asia/Manila)</div>{{ $payment['date'] }}</td><td><div class="label">Evidence</div>{{ $payment['evidence'] }}</td></tr></table><div class="label">Payment reference</div><div class="id">{{ $payment['reference'] }}</div></div>
                </div>
            @endforeach
        </div>
    @endif

    @if($layout['items'])
        <div class="section">
            <h2>Accepted order items</h2>
            <table class="items">
                <thead><tr><th style="width: 48%">Material / specification</th><th class="numeric" style="width: 12%">Quantity</th><th style="width: 16%">Unit</th><th class="numeric" style="width: 24%">Unit price (PHP)</th></tr></thead>
                <tbody>@foreach($layout['items'] as $item)<tr><td><div class="item-name">{{ $item['name'] }}</div>@if($item['variant'] !== '')<div class="variant">{{ $item['variant'] }}</div>@endif</td><td class="numeric">{{ $item['quantity'] }}</td><td>{{ $item['unit'] }}</td><td class="numeric">{{ $item['price'] }}</td></tr>@endforeach</tbody>
            </table>
        </div>
    @endif

    <table class="summary"><tr>
        <td><h2>About this document</h2><p class="muted small">This document preserves the agreed order. Vendor, platform and payment-processor invoices remain separate documents.</p><p class="muted small">All amounts are in Philippine pesos (PHP), reproduced from the frozen source record.</p>
            <div class="record-note"><strong>Record details</strong>@if($layout['details_captured'])<br>Party details recorded {{ $layout['details_captured'] }} (Asia/Manila).@endif @if($layout['contact_captured'])<br>Buyer contacts recorded {{ $layout['contact_captured'] }} (Asia/Manila).@endif @if($layout['captured'])<br>Source captured {{ $layout['captured'] }} (Asia/Manila).@endif<div class="hash">Source SHA-256:<br>{{ $document['source_hash'] }}</div></div>
        </td>
        <td>
            <h2>Accepted amounts <span class="muted small">PHP</span></h2>
            <table class="amounts">
                @foreach(['materials gross php', 'vendor discount php', 'delivery php'] as $key)
                    @if(isset($layout['amounts'][$key]))<tr><td>{{ $layout['amounts'][$key]['label'] }}</td><td>{{ $layout['amounts'][$key]['value'] }}</td></tr>@endif
                @endforeach
                @if(isset($layout['amounts']['commercial total php']))<tr class="total"><td>Accepted order total</td><td>{{ $layout['amounts']['commercial total php']['value'] }}</td></tr>@endif
            </table>
            <div class="tax-details"><table>
                @foreach(['materials exclusive php', 'materials vat php', 'materials payable php', 'nrpc php'] as $key)
                    @if(isset($layout['amounts'][$key]))<tr><td>{{ $layout['amounts'][$key]['label'] }}</td><td>{{ $layout['amounts'][$key]['value'] }}</td></tr>@endif
                @endforeach
            </table></div>
        </td>
    </tr></table>

    @if($layout['additional'])<div class="section"><h2>Additional record details</h2><table class="additional">@foreach($layout['additional'] as $row)<tr>@foreach($row as $value)<td>{{ $value }}</td>@endforeach</tr>@endforeach</table></div>@endif

    <footer>MateryalPH &nbsp; | &nbsp; SAMPLE / DEMO - NOT A TAX INVOICE - NOT FOR BIR FILING<br>{{ $layout['facts']['order'] ?? 'Private authorized copy' }}</footer>
</body>
</html>
