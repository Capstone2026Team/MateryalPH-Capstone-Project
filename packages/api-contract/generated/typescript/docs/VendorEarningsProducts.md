
# VendorEarningsProducts

Sales value per product for the same orders and dates as commercial sales: each product\'s share of the latest snapshot\'s line amounts (after vendor discount, VAT included). Delivery belongs to no product, so the products plus delivery equal commercial sales. Largest value first, at most 50 products; total counts all of them.

## Properties

Name | Type
------------ | -------------
`items` | [Array&lt;VendorEarningsProduct&gt;](VendorEarningsProduct.md)
`total` | number
`truncated` | boolean

## Example

```typescript
import type { VendorEarningsProducts } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "items": null,
  "total": null,
  "truncated": null,
} satisfies VendorEarningsProducts

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsProducts
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


