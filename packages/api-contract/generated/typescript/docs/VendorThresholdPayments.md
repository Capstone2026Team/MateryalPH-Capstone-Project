
# VendorThresholdPayments


## Properties

Name | Type
------------ | -------------
`taxableYear` | number
`payments` | [Array&lt;AssessedOnlinePayment&gt;](AssessedOnlinePayment.md)
`totals` | [AssessedOnlinePaymentTotals](AssessedOnlinePaymentTotals.md)
`otherStoreTotals` | [AssessedOnlinePaymentTotals](AssessedOnlinePaymentTotals.md)

## Example

```typescript
import type { VendorThresholdPayments } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "taxableYear": null,
  "payments": null,
  "totals": null,
  "otherStoreTotals": null,
} satisfies VendorThresholdPayments

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorThresholdPayments
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


