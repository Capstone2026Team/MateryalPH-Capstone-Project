
# VendorDashboardOrdersProductsSegments

K-Means demand groups of the store’s own products.

## Properties

Name | Type
------------ | -------------
`state` | string
`reason` | string
`k` | number
`silhouette` | number
`features` | Array&lt;string&gt;
`segments` | [Array&lt;VendorDashboardSegment&gt;](VendorDashboardSegment.md)
`points` | [Array&lt;VendorDashboardOrdersProductsSegmentsPointsInner&gt;](VendorDashboardOrdersProductsSegmentsPointsInner.md)

## Example

```typescript
import type { VendorDashboardOrdersProductsSegments } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "reason": null,
  "k": null,
  "silhouette": null,
  "features": null,
  "segments": null,
  "points": null,
} satisfies VendorDashboardOrdersProductsSegments

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersProductsSegments
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


