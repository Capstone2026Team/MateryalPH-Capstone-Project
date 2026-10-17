
# VendorProductAnalyticsDetailKpis


## Properties

Name | Type
------------ | -------------
`views` | [DashboardDelta](DashboardDelta.md)
`viewers` | [DashboardDelta](DashboardDelta.md)
`orders` | [DashboardDelta](DashboardDelta.md)
`buyers` | number
`conversion` | [DashboardRate](DashboardRate.md)
`storeConversion` | [DashboardRate](DashboardRate.md)
`valueCentavos` | [DashboardDelta](DashboardDelta.md)
`products` | number

## Example

```typescript
import type { VendorProductAnalyticsDetailKpis } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "views": null,
  "viewers": null,
  "orders": null,
  "buyers": null,
  "conversion": null,
  "storeConversion": null,
  "valueCentavos": null,
  "products": null,
} satisfies VendorProductAnalyticsDetailKpis

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductAnalyticsDetailKpis
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


