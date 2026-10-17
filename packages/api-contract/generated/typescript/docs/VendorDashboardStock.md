
# VendorDashboardStock

inventory.view. The store’s own stock only.

## Properties

Name | Type
------------ | -------------
`variants` | number
`inStock` | number
`limitedStock` | number
`outOfStock` | number
`attention` | [Array&lt;VendorDashboardStockAttentionInner&gt;](VendorDashboardStockAttentionInner.md)

## Example

```typescript
import type { VendorDashboardStock } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "variants": null,
  "inStock": null,
  "limitedStock": null,
  "outOfStock": null,
  "attention": null,
} satisfies VendorDashboardStock

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardStock
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


