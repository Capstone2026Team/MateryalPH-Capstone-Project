
# AssessedOnlinePaymentTotals

Current retained payment totals after completed refunds, with fully refunded principal omitted. Buyer fees remain a separate flow. Withholding adds the original rounded tax amounts for these retained payments across all pages and stores under the taxpayer; it does not recalculate posted tax after refunds.

## Properties

Name | Type
------------ | -------------
`assessedPayments` | number
`paymentPrincipalCentavos` | number
`buyerProcessingFeesCentavos` | number
`collectionsCentavos` | number
`withheldCentavos` | number

## Example

```typescript
import type { AssessedOnlinePaymentTotals } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "assessedPayments": null,
  "paymentPrincipalCentavos": null,
  "buyerProcessingFeesCentavos": null,
  "collectionsCentavos": null,
  "withheldCentavos": null,
} satisfies AssessedOnlinePaymentTotals

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AssessedOnlinePaymentTotals
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


