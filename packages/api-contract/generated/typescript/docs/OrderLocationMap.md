
# OrderLocationMap

Vendor order-detail-only map points. The destination is the saved intended site or alternate drop-off selected by the heavy-vehicle declaration, never device GPS. Pickup has no Buyer destination.

## Properties

Name | Type
------------ | -------------
`store` | [DeliveryNavigationRoutePoint](DeliveryNavigationRoutePoint.md)
`destination` | [DeliveryNavigationRoutePoint](DeliveryNavigationRoutePoint.md)

## Example

```typescript
import type { OrderLocationMap } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "store": null,
  "destination": null,
} satisfies OrderLocationMap

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderLocationMap
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


