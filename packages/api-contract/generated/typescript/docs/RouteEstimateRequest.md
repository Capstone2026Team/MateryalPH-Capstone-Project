
# RouteEstimateRequest


## Properties

Name | Type
------------ | -------------
`locationId` | string
`latitude` | number
`longitude` | number
`originSource` | string
`radiusKm` | number
`tier` | [SupplierTier](SupplierTier.md)
`supplierId` | string
`requestVersion` | string

## Example

```typescript
import type { RouteEstimateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "latitude": null,
  "longitude": null,
  "originSource": null,
  "radiusKm": null,
  "tier": null,
  "supplierId": null,
  "requestVersion": null,
} satisfies RouteEstimateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RouteEstimateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


