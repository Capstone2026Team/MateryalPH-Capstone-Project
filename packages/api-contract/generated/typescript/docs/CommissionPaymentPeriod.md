
# CommissionPaymentPeriod

Confirmed commission statement allocations less completed fee refunds by each event\'s Asia/Manila calendar period. A refund-only period may have a negative net. Does not include Buyer payments, estimates, unpaid bills or approved credits without a completed cash refund.

## Properties

Name | Type
------------ | -------------
`label` | string
`startsOn` | Date
`endsOn` | Date
`resetsAt` | Date
`collectedCentavos` | number
`refundedCentavos` | number
`netCollectedCentavos` | number

## Example

```typescript
import type { CommissionPaymentPeriod } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "startsOn": null,
  "endsOn": null,
  "resetsAt": null,
  "collectedCentavos": null,
  "refundedCentavos": null,
  "netCollectedCentavos": null,
} satisfies CommissionPaymentPeriod

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CommissionPaymentPeriod
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


