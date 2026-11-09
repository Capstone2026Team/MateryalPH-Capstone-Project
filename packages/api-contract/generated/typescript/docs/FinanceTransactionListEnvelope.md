
# FinanceTransactionListEnvelope

Owner-only paginated transaction rows. PAYMENTS lists online payment attempts (kind ONLINE) and Cash on Delivery / In-Store obligations (kind PHYSICAL, one per order) together, newest first. A PHYSICAL row has purpose CASH_ON_DELIVERY or IN_STORE_PAYMENT, a PHYSICAL_* status, gross = the cash owed at opening, no Buyer fee, collected_centavos = cash recorded, refunded_centavos = confirmed cash reimbursements, remaining_centavos = the current collectible balance (zero for PHYSICAL_RELEASED), and evidence_origin VENDOR_RECORD; cancellation releases retain their historical recorded amounts without creating debt or a refund. An online balance credit appears as its own ONLINE row. ONLINE rows preserve the original payment status and additionally return refund_state (NOT_REQUESTED, REFUND_PENDING, REFUND_FAILED, PARTIALLY_REFUNDED or REFUNDED). For ONLINE rows, gross_centavos and collected_centavos use order principal only (collection is zero for unpaid attempts); refunded_centavos uses completed principal refunds only and net_collected_centavos is verified order principal less completed principal refunds, floored at zero (zero for unpaid attempts). Buyer-paid fees and their refunds are excluded from all of these order-payment amounts. buyer_processing_fee_centavos remains separately identified provider-flow information and is never added to order gross or deducted from order principal. Original fee-inclusive provider collections/charges remain only in the recorded assessment reconciliation. Standalone REMITTANCE gross uses its recorded principal. Refunds are aggregated per original payment, never inferred from order cancellation. PAYMENTS additionally returns nullable order_after_refunds_centavos (the linked assessment principal, falling back to original payment principal, less completed principal refunds, floored at zero; null for unpaid, physical and standalone assessment rows) and net_remittance_centavos (for paid ONLINE rows with a POSTED assessment and a known assessed cash result, order_after_refunds_centavos minus recorded withholding, or zero when fully refunded; otherwise null). This retained order amount uses the same principal/refund basis as the annual threshold-payments list, excludes Buyer-paid fees and does not rewrite immutable assessment amounts. PAYMENTS rows additionally return nullable assessment_id, assessment_collected_centavos, assessment_refunds_centavos, assessment_delivery_centavos, assessment_vat_centavos, assessment_rate_basis_points, provider_charge_centavos, gross_basis_centavos, withheld_centavos, expected_cash_centavos, calculation_state, threshold_status_after, deduction_evidence_state, reconciliation_state and assessment_at. These are original MERCHANT_CWT assessment values matched by payment, order, environment and current Vendor; absent assessments and physical payments return null. assessment_delivery_centavos and assessment_vat_centavos are the original separately billed delivery and included material VAT allocated to this assessment, never current order totals. For POSTED assessments, the tax basis equals assessment_collected_centavos minus assessment_refunds_centavos minus assessment_delivery_centavos minus assessment_vat_centavos minus provider_charge_centavos. Buyer-paid processing fees are included in the recorded collection and must not be deducted again. assessment_rate_basis_points is the original effective withholding rate (50 means 0.5%, 0 means zero). Voided values remain historical and must not be displayed as current deductions or cash. Historical merchant assessments with no payment_id remain kind REMITTANCE, purpose REMITTANCE_ASSESSMENT, status ASSESSED rows in the same date-ordered, paginated list; their refunded_centavos and net_collected_centavos are null because current payment collection is not inferred. Payment-status filters exclude these standalone assessments. CSV and PDF PAYMENTS exports use the same projection. The legacy REMITTANCES API remains available. REMITTANCES rows additionally return calculation_state; VOIDED marks a collection whose whole payment was confirmed refunded, which is no remittance and no longer counts toward the FIN-04A threshold (a crossed taxable year is never lowered).

## Properties

Name | Type
------------ | -------------
`data` | Array&lt;{ [key: string]: any; }&gt;
`meta` | { [key: string]: any; }
`errors` | [Array&lt;ApiError&gt;](ApiError.md)

## Example

```typescript
import type { FinanceTransactionListEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies FinanceTransactionListEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinanceTransactionListEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


