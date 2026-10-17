
# VendorEarningsBreakdownSales


## Properties

Name | Type
------------ | -------------
`orders` | number
`materialsBeforeDiscountCentavos` | number
`vendorDiscountsCentavos` | number
`materialsAfterDiscountCentavos` | number
`deliveryCentavos` | number

## Example

```typescript
import type { VendorEarningsBreakdownSales } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orders": null,
  "materialsBeforeDiscountCentavos": null,
  "vendorDiscountsCentavos": null,
  "materialsAfterDiscountCentavos": null,
  "deliveryCentavos": null,
} satisfies VendorEarningsBreakdownSales

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsBreakdownSales
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


