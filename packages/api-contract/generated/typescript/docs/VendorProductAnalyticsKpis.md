
# VendorProductAnalyticsKpis


## Properties

Name | Type
------------ | -------------
`views` | [DashboardDelta](DashboardDelta.md)
`viewers` | [DashboardDelta](DashboardDelta.md)
`productsViewed` | [VendorProductAnalyticsKpisProductsViewed](VendorProductAnalyticsKpisProductsViewed.md)
`orders` | [DashboardDelta](DashboardDelta.md)
`conversion` | [DashboardRate](DashboardRate.md)
`valueCentavos` | [DashboardDelta](DashboardDelta.md)

## Example

```typescript
import type { VendorProductAnalyticsKpis } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "views": null,
  "viewers": null,
  "productsViewed": null,
  "orders": null,
  "conversion": null,
  "valueCentavos": null,
} satisfies VendorProductAnalyticsKpis

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductAnalyticsKpis
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


