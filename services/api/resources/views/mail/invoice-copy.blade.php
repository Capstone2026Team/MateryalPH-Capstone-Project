@extends('mail.layouts.base')

@section('preheader', $invoice['issuer'].' sent invoice '.$invoice['invoice_number'].'. Your '.$invoice['file_type'].' copy is attached.')
@section('eyebrow', 'Your order documents')
@section('heading', $invoice['is_correction'] ? 'Your updated invoice is here' : 'Your invoice is here')

@section('content')
<p style="margin: 0 0 24px; color: #475569;">{{ $invoice['issuer'] }} sent {{ $invoice['is_correction'] ? 'an updated invoice' : 'an invoice' }} for order <strong style="color: #1E293B;">{{ $invoice['order_reference'] }}</strong>. The original file is attached to this email for your records.</p>

<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid #E2E8F0; border-radius: 10px;">
<tr><td style="padding: 22px 24px; border-bottom: 1px solid #E2E8F0;">
<p style="margin: 0 0 6px; font-size: 12px; line-height: 18px; color: #64748B;">{{ $invoice['document_type'] }}</p>
<p style="margin: 0; font-size: 23px; line-height: 30px; font-weight: 700; color: #1E293B; overflow-wrap: anywhere;">{{ $invoice['invoice_number'] }}</p>
@if($invoice['is_demo'])
<p style="margin: 10px 0 0; font-size: 11px; line-height: 18px; font-weight: 700; color: #9A3412;">DEMO SAMPLE · TEST</p>
@endif
</td></tr>
<tr><td style="padding: 22px 24px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
<tr>
<td class="mp-column" width="55%" valign="top" style="padding: 0 16px 20px 0;">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Issued by</p>
<p style="margin: 0; font-size: 14px; line-height: 22px; font-weight: 600;">{{ $invoice['issuer'] }}</p>
</td>
<td class="mp-column" width="45%" valign="top" style="padding: 0 0 20px;">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Invoice date</p>
<p style="margin: 0; font-size: 14px; line-height: 22px;">{{ $invoice['invoice_date'] }}</p>
</td>
</tr>
@if($invoice['billing_name'])
<tr><td colspan="2" style="padding: 0 0 20px;">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Bill to</p>
<p style="margin: 0; font-size: 14px; line-height: 22px;">{{ $invoice['billing_name'] }}</p>
</td></tr>
@endif
<tr>
<td class="mp-column" width="55%" valign="top" style="padding: 0 16px 0 0;">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Issued through</p>
<p style="margin: 0; font-size: 14px; line-height: 22px;">{{ $invoice['source'] }}</p>
</td>
<td class="mp-column" width="45%" valign="top">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Invoicing method</p>
<p style="margin: 0; font-size: 14px; line-height: 22px;">{{ $invoice['method'] }}</p>
</td>
</tr>
</table>
</td></tr>
<tr><td style="padding: 18px 24px; background-color: #FFF7ED; border-top: 1px solid #FFEDD5;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
@if($invoice['vat'] !== null)
<tr><td style="padding: 0 0 10px; font-size: 13px; color: #475569;">VAT shown</td><td align="right" style="padding: 0 0 10px; font-size: 13px; color: #475569;">{{ $invoice['vat'] }}</td></tr>
@endif
<tr><td class="mp-total-label" style="font-size: 14px; font-weight: 600;">Invoice total</td><td class="mp-total-value {{ mb_strlen($invoice['total']) > 14 ? 'mp-total-long' : '' }}" align="right" style="font-size: 24px; line-height: 32px; font-weight: 700; color: #9A3412; white-space: nowrap;">{{ $invoice['total'] }}</td></tr>
</table>
</td></tr>
</table>

<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 22px 0 0; background-color: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 8px;">
<tr><td style="padding: 18px 20px;">
<h2 style="margin: 0 0 8px; font-size: 16px; line-height: 24px; color: #1E293B;">Download your invoice</h2>
<p style="margin: 0 0 6px; font-size: 13px; line-height: 20px; font-weight: 700; color: #166534;">&#10003; Invoice copy attached</p>
<p style="margin: 0 0 4px; font-size: 14px; line-height: 22px; font-weight: 600; overflow-wrap: anywhere;">{{ $invoice['filename'] }}</p>
<p style="margin: 0; font-size: 12px; line-height: 18px; color: #64748B;">{{ $invoice['file_type'] }} &middot; {{ $invoice['file_size'] }} &middot; Sent {{ $invoice['sent_at'] }}</p>
<p style="margin: 12px 0 0; font-size: 13px; line-height: 21px; color: #475569;">Use <strong>Download</strong> or <strong>Save attachment</strong> in your email app to keep the original file on your device.</p>
</td></tr>
</table>
<p style="margin: 18px 0 0; font-size: 13px; line-height: 21px; color: #64748B;">This summary reflects the Vendor's sent document. Your accepted order amount stays unchanged. {{ $invoice['is_demo'] ? 'This is a TEST/DEMO sample, not evidence of a BIR filing.' : 'The Vendor is responsible for issuing its invoice through its registered process.' }}</p>
@endsection

@section('next')
To view this invoice or request a correction, open <strong>MateryalPH → Orders → {{ $invoice['order_reference'] }} → Invoices</strong>.
@endsection

@section('reason', 'You received this invoice because you are the Buyer for this order.')
@section('security', 'Never share your password or one-time code. For invoice questions, contact the store through your order in MateryalPH.')
