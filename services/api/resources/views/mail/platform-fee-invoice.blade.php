@extends('mail.layouts.base')
@section('preheader', 'Your monthly platform commission invoice is attached as a downloadable SAMPLE / TEST PDF.')
@section('eyebrow', 'Platform service invoice - SAMPLE / TEST')
@section('heading', 'Your commission statement is ready')
@section('content')
<p><strong>TEST/DEMO — No automatic debit, real funds or BIR filing.</strong></p>
@if(($invoice['statement_version'] ?? 1) > 1)<p><strong>Corrected statement.</strong> Review this version and its referenced charges and credits.</p>@endif
<p>Your monthly platform service invoice is attached. Use your email app's <strong>Download</strong> or <strong>Save attachment</strong> action to keep the PDF.</p>
<p><strong>{{ $invoice['heading'] ?? 'Platform service invoice' }}</strong></p>
@if(!empty($invoice['message']))<p style="white-space: pre-wrap;">{{ $invoice['message'] }}</p>@endif
<table role="presentation" style="width: 100%; border-collapse: collapse; font-size: 13px; line-height: 21px;">
@foreach(['Invoice' => $invoice['invoice_number'], 'Statement' => $invoice['statement_reference'], 'Billed to' => $invoice['billing_name'], 'Period' => $invoice['period_start'].' to '.$invoice['period_end'], 'Issued' => $invoice['issued_on'], 'Due' => $invoice['due_on'].' (end of day, Asia/Manila)', 'Platform service fee' => 'P'.number_format($invoice['total_centavos'] / 100, 2)] as $label => $value)
<tr><td style="padding: 8px 12px 8px 0; border-bottom: 1px solid #e5e7eb; vertical-align: top;">{{ $label }}</td><td style="padding: 8px 0; border-bottom: 1px solid #e5e7eb; overflow-wrap: anywhere;">{{ $value }}</td></tr>
@endforeach
</table>
<h2 style="font-size: 17px;">Commission calculation</h2>
@foreach($rates as $rate)<p>{{ $rate['rate'] }} on {{ $rate['basis_available'] ? 'P'.number_format($rate['basis_centavos'] / 100, 2) : 'the saved eligible materials basis (see statement)' }} → P{{ number_format($rate['commission_centavos'] / 100, 2) }}</p>@endforeach
<p>Before credits: <strong>P{{ number_format($invoice['charges_centavos'] / 100, 2) }}</strong><br>Credits applied: <strong>P{{ number_format($invoice['credits_centavos'] / 100, 2) }}</strong><br>After credits / amount due at issuance: <strong>P{{ number_format($invoice['total_centavos'] / 100, 2) }}</strong></p>
@if($invoice['total_centavos'] === 0)<p><strong>No payment needed.</strong> Credits fully cover this statement.</p>@endif
<p style="font-size: 12px; line-height: 20px; color: #475569;">SAMPLE / TEST only. This is not an official tax invoice or proof of payment. No real charge or BIR filing occurred. The attachment keeps the bill as issued; the statement shows the current payments, adjustments and amount due.</p>
@endsection
@section('next')
Open <strong>Finance → Commission monitoring → Commission statements</strong> to review the bill and pay any outstanding amount through the available TEST channels.
@endsection
@section('action')
@if($invoice['total_centavos'] > 0)<p><a href="{{ $financeUrl }}" style="display: inline-block; background: #C2410C; color: #FFFFFF; padding: 12px 18px; border-radius: 8px; text-decoration: none; font-weight: 700;">Pay now (TEST)</a></p>@endif
@include('mail.notification-link', ['purposeLabel' => 'View commission statement'])
<p><a href="{{ $supportUrl }}">Contact MateryalPH support</a></p>
@endsection
@section('security', 'MateryalPH will never ask you to send a password, one-time code or payment details by email.')
