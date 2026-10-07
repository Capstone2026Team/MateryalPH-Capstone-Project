<!doctype html>
<html lang="en"><head><meta charset="UTF-8"><title>{{ $document['title'] }}</title>
<style>
@page { margin: 48px 38px 58px; } body { font-family: 'DejaVu Sans', sans-serif; font-size: 9px; color: #20252b; }
h1 { font-size: 21px; margin: 18px 0 8px; } .brand { font-size: 15px; font-weight: bold; color: #9a3412; }
.note { border-top: 3px solid #c2410c; padding: 10px 0; font-weight: bold; } .meta { color: #475569; overflow-wrap: anywhere; }
table { width: 100%; border-collapse: collapse; margin: 0; table-layout: fixed; page-break-inside: avoid; }
.details { margin-top: 20px; } td { padding: 8px 5px; border-bottom: 1px solid #cbd5e1; vertical-align: top; word-wrap: break-word; }
td:first-child { font-weight: bold; } footer { position: fixed; bottom: -34px; font-size: 7px; color: #475569; }
</style></head><body><div class="brand">MateryalPH</div><h1>{{ $document['title'] }}</h1>
<p class="note">{{ $watermark }}</p><p class="meta">Generated: {{ $document['generated_at'] }} (Asia/Manila)<br>Source version hash: {{ $document['source_hash'] }}</p>
@if(isset($document['captured_at']))<p class="meta">Snapshot captured: {{ $document['captured_at'] }} (Asia/Manila)</p>@endif
<p>Immutable snapshot for the stated purpose. Vendor goods invoices, platform fee invoices and processor documents are separate documents. This report does not replace any of them.</p>
<div class="details" aria-label="Report details">@foreach ($document['rows'] as $row)<table><tbody><tr>@foreach ($row as $value)<td style="width: {{ 100 / max(1, count($row)) }}%">{{ $value }}</td>@endforeach</tr></tbody></table>@endforeach</div>
<footer>{{ $watermark }} · Generated {{ $document['generated_at'] }} · Private authorized copy</footer></body></html>
