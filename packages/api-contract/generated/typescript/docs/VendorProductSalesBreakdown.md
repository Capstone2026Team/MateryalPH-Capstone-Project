
# VendorProductSalesBreakdown

Materials after discounts, VAT included, plus delivery less completed partial refunds reconcile to Net sales.

## Properties

Name | Type
------------ | -------------
`productSalesCentavos` | number
`deliveryCentavos` | number
`refundsCentavos` | number
`netSalesCentavos` | number

## Example

```typescript
import type { VendorProductSalesBreakdown } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "productSalesCentavos": null,
  "deliveryCentavos": null,
  "refundsCentavos": null,
  "netSalesCentavos": null,
} satisfies VendorProductSalesBreakdown

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorProductSalesBreakdown
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


