MateryalPH — Commission Terms — TEST/DEMO
No automatic debit, real funds or BIR filing.

@if($type === 'RATE_CANCELLED')Scheduled commission change cancelled. The replacement terms retain the rate below.
@elseif($type === 'RATE_CORRECTED')Correction: this replaces the earlier scheduled-change notice.
@endif
Commission rate: {{ $oldRate }} -> {{ $policy['rate_label'] }}
Effective: {{ $effective }}
Actual notice given: {{ intdiv((int) ($policy['notice_hours'] ?? 0), 24) }} days and {{ (int) ($policy['notice_hours'] ?? 0) % 24 }} hours.

The new rate applies when MateryalPH saves the commission policy for a new commercial transaction. Published quotations and orders with a saved policy keep their original rate, including later returns and credits.

Worked example: P10,000.00 of completed, non-refunded materials after discounts, excluding materials VAT -> {{ $example }} commission at {{ $policy['rate_label'] }}. Vendor-paid and billed monthly.
{{ $policy['vendor_message'] ?? '' }}

Terms version {{ $policy['terms_version'] }} / policy version {{ $policy['version'] }}
Commission Terms: {{ $termsUrl }}
Finance: {{ $financeUrl }}
Contact MateryalPH support: {{ $supportUrl }}
