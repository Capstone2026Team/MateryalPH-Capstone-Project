
# OrderDelivery


## Properties

Name | Type
------------ | -------------
`status` | string
`estimate` | [OrderDeliveryEstimate](OrderDeliveryEstimate.md)
`confirmed` | [OrderConfirmedDelivery](OrderConfirmedDelivery.md)

## Example

```typescript
import type { OrderDelivery } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "estimate": null,
  "confirmed": null,
} satisfies OrderDelivery

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderDelivery
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


