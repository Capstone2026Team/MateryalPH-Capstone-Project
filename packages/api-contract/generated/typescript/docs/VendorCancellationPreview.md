
# VendorCancellationPreview


## Properties

Name | Type
------------ | -------------
`vendorCancellation` | [CancellationPlan](CancellationPlan.md)
`fullRefund` | [CancellationPlan](CancellationPlan.md)
`withNrpcRetained` | [CancellationPlan](CancellationPlan.md)
`nrpcRetainableCentavos` | number
`notice` | string

## Example

```typescript
import type { VendorCancellationPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorCancellation": null,
  "fullRefund": null,
  "withNrpcRetained": null,
  "nrpcRetainableCentavos": null,
  "notice": null,
} satisfies VendorCancellationPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorCancellationPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


