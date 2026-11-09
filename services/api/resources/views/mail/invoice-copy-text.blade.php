{{-- This is the text/plain MIME part. Preserve literal business names rather than HTML entities. --}}
{!! $invoice['is_correction'] ? 'Your updated invoice is here' : 'Your invoice is here' !!}

{!! $invoice['issuer'] !!} sent an invoice for order {!! $invoice['order_reference'] !!}.
The original {{ $invoice['file_type'] }} file is attached to this email.
@if($invoice['is_demo'])
DEMO SAMPLE - TEST. No BIR filing occurred.
@endif

Document type: {{ $invoice['document_type'] }}
Invoice number: {{ $invoice['invoice_number'] }}
Issued by: {!! $invoice['issuer'] !!}
Invoice date: {{ $invoice['invoice_date'] }}
@if($invoice['billing_name'])
Bill to: {!! $invoice['billing_name'] !!}
@endif
Issued through: {{ $invoice['source'] }}
Invoicing method: {{ $invoice['method'] }}
@if($invoice['vat'] !== null)
VAT shown: {{ $invoice['vat'] }}
@endif
Invoice total: {{ $invoice['total'] }}

Attachment: {{ $invoice['filename'] }} ({{ $invoice['file_size'] }})
Use Download or Save attachment in your email app to save the original file to your device.
Sent: {{ $invoice['sent_at'] }}

To view this invoice or request a correction, open MateryalPH > Orders > {{ $invoice['order_reference'] }} > Invoices.
Your accepted order amount stays unchanged. Never share your password or one-time code.

MateryalPH - Construction materials marketplace, Philippines
