
# BuyerAnalyticsProductDetailProduct


## Properties

Name | Type
------------ | -------------
`material` | [AnalyticsMaterialRef](AnalyticsMaterialRef.md)
`category` | [AnalyticsCategoryRef](AnalyticsCategoryRef.md)
`regulated` | boolean
`unit` | [AnalyticsUnit](AnalyticsUnit.md)
`variantCount` | number
`vendorCount` | number
`price` | [AnalyticsPriceRange](AnalyticsPriceRange.md)
`description` | string

## Example

```typescript
import type { BuyerAnalyticsProductDetailProduct } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "material": null,
  "category": null,
  "regulated": null,
  "unit": null,
  "variantCount": null,
  "vendorCount": null,
  "price": null,
  "description": null,
} satisfies BuyerAnalyticsProductDetailProduct

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAnalyticsProductDetailProduct
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


