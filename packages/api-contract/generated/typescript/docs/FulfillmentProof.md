
# FulfillmentProof

Proof attached to the Delivered or Picked up milestone. File paths are authorized, order-scoped API paths relative to /api/v1, never public URLs.

## Properties

Name | Type
------------ | -------------
`milestone` | string
`recordedAt` | Date
`receiverName` | string
`receiverKind` | string
`handoverConfirmed` | boolean
`photoPath` | string
`signaturePath` | string
`vehicle` | { [key: string]: any; }

## Example

```typescript
import type { FulfillmentProof } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "milestone": null,
  "recordedAt": null,
  "receiverName": null,
  "receiverKind": null,
  "handoverConfirmed": null,
  "photoPath": null,
  "signaturePath": null,
  "vehicle": null,
} satisfies FulfillmentProof

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentProof
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


