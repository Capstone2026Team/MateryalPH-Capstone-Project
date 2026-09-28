
# RouteEstimate


## Properties

Name | Type
------------ | -------------
`requestVersion` | string
`originVersion` | string
`tier` | [SupplierTier](SupplierTier.md)
`supplierId` | string
`straightLineMeters` | number
`distanceMeters` | number
`durationSeconds` | number
`durationBasis` | string
`encodedPolyline` | string
`computedAt` | Date
`cached` | boolean

## Example

```typescript
import type { RouteEstimate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "requestVersion": null,
  "originVersion": null,
  "tier": null,
  "supplierId": null,
  "straightLineMeters": null,
  "distanceMeters": null,
  "durationSeconds": null,
  "durationBasis": null,
  "encodedPolyline": null,
  "computedAt": null,
  "cached": null,
} satisfies RouteEstimate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RouteEstimate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


