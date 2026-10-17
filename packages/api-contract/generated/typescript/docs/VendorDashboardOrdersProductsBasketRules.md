
# VendorDashboardOrdersProductsBasketRules

Co-ordered materials in the last 90 days across at least two distinct Buyers.

## Properties

Name | Type
------------ | -------------
`baskets` | number
`rules` | [Array&lt;DashboardRule&gt;](DashboardRule.md)
`windowDays` | number

## Example

```typescript
import type { VendorDashboardOrdersProductsBasketRules } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "baskets": null,
  "rules": null,
  "windowDays": null,
} satisfies VendorDashboardOrdersProductsBasketRules

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersProductsBasketRules
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


