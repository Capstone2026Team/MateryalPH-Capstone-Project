<!doctype html>
<html lang="en"><head><meta charset="UTF-8"><title>Platform service invoice</title>
<style>
@page { margin: 36px 38px 55px; }
body { font-family: 'DejaVu Sans', sans-serif; color: #1f2937; font-size: 9px; line-height: 1.5; }
h1 { font-size: 21px; margin: 8px 0; word-wrap: break-word; } h2 { font-size: 11px; margin: 18px 0 4px; }
.brand { color: #c2410c; font-size: 16px; font-weight: bold; } .muted { color: #475569; }
.notice { padding: 9px 12px; border: 1px solid #f59e0b; background: #fffbeb; font-size: 9px; }
table { width: 100%; border-collapse: collapse; table-layout: fixed; } thead { display: table-header-group; }
th, td { text-align: left; padding: 8px; border-bottom: 1px solid #e5e7eb; word-wrap: break-word; vertical-align: top; }
th { background: #f8fafc; } tr { page-break-inside: avoid; } .amount { text-align: right; white-space: nowrap; }
.facts td { border: 0; padding: 4px 0; } .totals { margin-top: 16px; page-break-inside: avoid; }
.total td { font-size: 12px; font-weight: bold; border-top: 2px solid #1f2937; }
footer { position: fixed; bottom: -30px; color: #475569; font-size: 7px; }
</style></head><body>
@php($money = static fn ($amount) => 'PHP '.number_format(((int) $amount) / 100, 2, '.', ','))
<div class="brand">MateryalPH</div><h1>{{ $invoice['heading'] ?? 'Platform service invoice' }}</h1>
<p class="notice"><strong>SAMPLE / TEST - NOT AN OFFICIAL TAX INVOICE - NOT FOR BIR FILING</strong></p>
<table class="facts"><tr><td><strong>{{ $invoice['invoice_number'] }}</strong><br>Statement: {{ $invoice['statement_reference'] }}</td><td>Issued: {{ $invoice['issued_on'] }}<br>Due: {{ $invoice['due_on'] }} (end of day, Asia/Manila)</td></tr>
<tr><td><h2>Issuer</h2>{{ $invoice['issuer'] }}</td><td><h2>Billed to</h2>{{ $invoice['billing_name'] }}</td></tr></table>
<h2>Monthly commission: {{ $invoice['period_start'] }} to {{ $invoice['period_end'] }}</h2>
<p class="muted">Vendor-paid platform service fees. Each completed order retains its original commission rate. This document records the bill as issued; later payments and adjustments appear in the statement.</p>
@if(!empty($invoice['message']))<p style="white-space: pre-wrap; word-wrap: break-word;">{{ $invoice['message'] }}</p>@endif
<table><thead><tr><th style="width: 64%">Order / service description</th><th style="width: 12%" class="amount">Rate</th><th style="width: 24%" class="amount">Amount</th></tr></thead><tbody>
@foreach($invoice['lines'] as $line)
<tr><td>@if($line['order_reference'])<strong>{{ $line['order_reference'] }}</strong>@if($line['type'] !== 'EARNED_COMMISSION')<br>{{ $line['description'] }}@endif @else{{ $line['description'] }}@endif</td>
<td class="amount">{{ $line['rate_basis_points'] === null ? '-' : number_format($line['rate_basis_points'] / 100, 2).'%' }}</td>
<td class="amount">{{ $money(in_array($line['type'], ['CREDIT', 'CREDIT_TRANSFER'], true) ? -$line['amount_centavos'] : $line['amount_centavos']) }}</td></tr>
@endforeach
</tbody></table>
<table class="totals"><tr><td>Commission charged</td><td class="amount">{{ $money($invoice['charges_centavos']) }}</td></tr>
<tr><td>Approved fee reductions</td><td class="amount">{{ $money(-$invoice['credits_centavos']) }}</td></tr>
<tr class="total"><td>Total platform service fee</td><td class="amount">{{ $money($invoice['total_centavos']) }}</td></tr></table>
<p class="muted">Pay an outstanding issued statement through Commission monitoring using the available TEST payment channels. The current statement shows payments, later credits and the remaining amount due. No automatic debit is made.</p>
<footer>SAMPLE / TEST platform service invoice. Separate from Vendor goods invoices and processor documents.</footer>
</body></html>
