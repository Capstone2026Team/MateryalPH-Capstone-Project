MateryalPH - Platform service invoice (SAMPLE / TEST)

Your commission statement is ready. Your platform service invoice is attached as a PDF.
Use your email app's Download or Save attachment action to keep the document.

{{ $invoice['heading'] ?? 'Platform service invoice' }}
@if(!empty($invoice['message']))
{{ $invoice['message'] }}
@endif

Invoice: {{ $invoice['invoice_number'] }}
Statement: {{ $invoice['statement_reference'] }}
Billed to: {{ $invoice['billing_name'] }}
Period: {{ $invoice['period_start'] }} to {{ $invoice['period_end'] }}
Issued: {{ $invoice['issued_on'] }}
Due: {{ $invoice['due_on'] }} (end of day, Asia/Manila)
Platform service fee: P{{ number_format($invoice['total_centavos'] / 100, 2) }}

Commission before credits: P{{ number_format($invoice['charges_centavos'] / 100, 2) }}
Credits applied: P{{ number_format($invoice['credits_centavos'] / 100, 2) }}
Commission after credits / amount due at issuance: P{{ number_format($invoice['total_centavos'] / 100, 2) }}
@foreach($rates as $rate)
{{ $rate['rate'] }} on {{ $rate['basis_available'] ? 'P'.number_format($rate['basis_centavos'] / 100, 2) : 'saved eligible materials basis (see statement)' }} -> P{{ number_format($rate['commission_centavos'] / 100, 2) }}
@endforeach
@if($invoice['total_centavos'] === 0)
No payment needed. Credits fully cover this statement.
@else
Pay now (TEST): {{ $financeUrl }}
@endif
@if(($invoice['statement_version'] ?? 1) > 1)
Corrected statement. Review this version and its referenced charges and credits.
@endif
Contact MateryalPH support: {{ $supportUrl }}

SAMPLE / TEST only. Not an official tax invoice or proof of payment. No real charge or BIR filing occurred.
The attachment preserves the bill as issued. Open Commission monitoring to review current payments, later adjustments and the amount due.
@if(!empty($noticeUrl))
View commission statement: {{ $noticeUrl }}
@endif
