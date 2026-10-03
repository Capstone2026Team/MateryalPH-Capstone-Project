
# BuyerCancellationPreview


## Properties

Name | Type
------------ | -------------
`availability` | [OrderCancellation](OrderCancellation.md)
`fullRefund` | [CancellationPlan](CancellationPlan.md)
`withNrpcRetained` | [CancellationPlan](CancellationPlan.md)
`nrpcRetainableCentavos` | number
`notice` | string

## Example

```typescript
import type { BuyerCancellationPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "availability": null,
  "fullRefund": null,
  "withNrpcRetained": null,
  "nrpcRetainableCentavos": null,
  "notice": null,
} satisfies BuyerCancellationPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerCancellationPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


