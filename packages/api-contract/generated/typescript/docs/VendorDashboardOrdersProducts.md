
# VendorDashboardOrdersProducts


## Properties

Name | Type
------------ | -------------
`top` | [Array&lt;VendorDashboardProduct&gt;](VendorDashboardProduct.md)
`categories` | [Array&lt;VendorDashboardOrdersProductsCategoriesInner&gt;](VendorDashboardOrdersProductsCategoriesInner.md)
`segments` | [VendorDashboardOrdersProductsSegments](VendorDashboardOrdersProductsSegments.md)
`basketRules` | [VendorDashboardOrdersProductsBasketRules](VendorDashboardOrdersProductsBasketRules.md)

## Example

```typescript
import type { VendorDashboardOrdersProducts } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "top": null,
  "categories": null,
  "segments": null,
  "basketRules": null,
} satisfies VendorDashboardOrdersProducts

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersProducts
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


