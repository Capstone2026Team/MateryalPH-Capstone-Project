
# FinanceTransactionListEnvelope

Owner-only paginated transaction rows. PAYMENTS lists online payment attempts (kind ONLINE) and Cash on Delivery / In-Store obligations (kind PHYSICAL, one per order) together, newest first. A PHYSICAL row has purpose CASH_ON_DELIVERY or IN_STORE_PAYMENT, a PHYSICAL_* status, gross = the cash owed at opening, no Buyer fee, collected_centavos = cash recorded, refunded_centavos = confirmed cash reimbursements, remaining_centavos and evidence_origin VENDOR_RECORD; an online balance credit appears as its own ONLINE row. ONLINE rows preserve the original payment status and gross/Buyer-fee amounts and additionally return refund_state (NOT_REQUESTED, REFUND_PENDING, REFUND_FAILED, PARTIALLY_REFUNDED or REFUNDED), refunded_centavos (confirmed refunds only) and net_collected_centavos (verified gross less confirmed refunds; zero for unpaid attempts). Refunds are aggregated per original payment, never inferred from order cancellation. REMITTANCES rows additionally return calculation_state; VOIDED marks a collection whose whole payment was confirmed refunded, which is no remittance and no longer counts toward the FIN-04A threshold (a crossed taxable year is never lowered).

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


