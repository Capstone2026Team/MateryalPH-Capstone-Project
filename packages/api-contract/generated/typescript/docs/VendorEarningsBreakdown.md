
# VendorEarningsBreakdown

The components behind the headline Earnings cards, in the same scope and dates as each card\'s own total: sales (materials before discounts less vendor discounts plus delivery equals commercial sales), online (verified principal less confirmed refunded principal equals online collections) and physical (Cash on Delivery plus In-Store Payment equals physical collections). Records only; no derived income figure.

## Properties

Name | Type
------------ | -------------
`sales` | [VendorEarningsBreakdownSales](VendorEarningsBreakdownSales.md)
`online` | [VendorEarningsBreakdownOnline](VendorEarningsBreakdownOnline.md)
`physical` | [VendorEarningsBreakdownPhysical](VendorEarningsBreakdownPhysical.md)

## Example

```typescript
import type { VendorEarningsBreakdown } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "sales": null,
  "online": null,
  "physical": null,
} satisfies VendorEarningsBreakdown

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsBreakdown
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


