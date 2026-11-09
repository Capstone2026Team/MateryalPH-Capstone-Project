@extends('mail.layouts.base')
@section('preheader', 'Review your updated commission rate, effective date and versioned Commission Terms.')
@section('eyebrow', 'Commission Terms — TEST/DEMO')
@section('heading', $type === 'RATE_CANCELLED' ? 'Scheduled commission change cancelled' : ($type === 'RATE_CORRECTED' ? 'Correction to your commission update' : 'Your commission rate update'))
@section('content')
<p><strong>TEST/DEMO — No automatic debit, real funds or BIR filing.</strong></p>
<p>Commission rate: <strong>{{ $oldRate }} → {{ $policy['rate_label'] }}</strong><br>Effective: <strong>{{ $effective }}</strong></p>
@if($type === 'RATE_CANCELLED')<p>The previously scheduled change is cancelled. The replacement terms retain the rate shown above.</p>@endif
@if($type === 'RATE_CORRECTED')<p>This replaces the earlier scheduled-change notice. Please use this effective date and terms version.</p>@endif
<p>Actual notice given: {{ intdiv((int) ($policy['notice_hours'] ?? 0), 24) }} days and {{ (int) ($policy['notice_hours'] ?? 0) % 24 }} hours. @if(($policy['notice_hours'] ?? 0) === 0)This change takes effect immediately.@endif</p>
<p>The new rate applies when MateryalPH saves the commission policy for a new commercial transaction. Published quotations and orders with a saved policy keep their original rate, including later returns and credits.</p>
<p>Worked example: <strong>P10,000.00</strong> of completed, non-refunded materials after discounts, excluding materials VAT, produces <strong>{{ $example }}</strong> commission at {{ $policy['rate_label'] }}. Commission is Vendor-paid and billed monthly.</p>
@if(!empty($policy['vendor_message']))<p style="white-space: pre-wrap;">{{ $policy['vendor_message'] }}</p>@endif
<p>Terms version {{ $policy['terms_version'] }} · Policy version {{ $policy['version'] }}</p>
@endsection
@section('action')
<p><a href="{{ $termsUrl }}" style="display: inline-block; padding: 12px 18px; border-radius: 8px; background: #C2410C; color: #FFFFFF; font-weight: 700; text-decoration: none;">Review Commission Terms</a></p>
<p><a href="{{ $financeUrl }}">View your finance page</a> · <a href="{{ $supportUrl }}">Contact MateryalPH support</a></p>
@endsection
