
# CancellationPlan

FIN-07 amounts from the original frozen allocations. Vendor withholding, commission and provider deductions never reduce a Buyer refund.

## Properties

Name | Type
------------ | -------------
`cause` | string
`nrpcRetainedCentavos` | number
`nrpcAcceptedCentavos` | number
`online` | [Array&lt;CancellationPlanPayment&gt;](CancellationPlanPayment.md)
`onlineRefundTotalCentavos` | number
`cashReimbursementCentavos` | number
`releasedUnpaidCentavos` | number
`paidTotalCentavos` | number
`excludes` | Array&lt;string&gt;

## Example

```typescript
import type { CancellationPlan } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "cause": null,
  "nrpcRetainedCentavos": null,
  "nrpcAcceptedCentavos": null,
  "online": null,
  "onlineRefundTotalCentavos": null,
  "cashReimbursementCentavos": null,
  "releasedUnpaidCentavos": null,
  "paidTotalCentavos": null,
  "excludes": null,
} satisfies CancellationPlan

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CancellationPlan
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


