
# OrderCancellation

Buyer responses carry mode, availability, reason codes and remedies; Vendor responses carry the explanation, Vendor reason codes and any open Buyer request. Unavailability is always explained in text.

## Properties

Name | Type
------------ | -------------
`mode` | string
`available` | boolean
`explanation` | string
`requiresReason` | boolean
`reasonCodes` | Array&lt;string&gt;
`nrpcRetainableCentavos` | number
`canWithdrawRequest` | boolean
`responseDueAt` | Date
`remedies` | [Array&lt;CancellationRemedy&gt;](CancellationRemedy.md)
`openRequest` | [VendorCancellationRequestRef](VendorCancellationRequestRef.md)

## Example

```typescript
import type { OrderCancellation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "mode": null,
  "available": null,
  "explanation": null,
  "requiresReason": null,
  "reasonCodes": null,
  "nrpcRetainableCentavos": null,
  "canWithdrawRequest": null,
  "responseDueAt": null,
  "remedies": null,
  "openRequest": null,
} satisfies OrderCancellation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderCancellation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


