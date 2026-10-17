
# VendorEarningsTrendChange

Percent change of each figure against the previous period, one decimal; null when the previous total is zero.

## Properties

Name | Type
------------ | -------------
`commercialSalesCentavos` | number
`onlineCollectionsCentavos` | number
`onlineRefundsCentavos` | number
`buyerProcessingFeesCentavos` | number
`physicalCollectionsCentavos` | number
`providerChargesCentavos` | number
`simulatedCwtCentavos` | number
`estimatedRemittanceCashCentavos` | number
`earnedCommissionCentavos` | number

## Example

```typescript
import type { VendorEarningsTrendChange } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "commercialSalesCentavos": null,
  "onlineCollectionsCentavos": null,
  "onlineRefundsCentavos": null,
  "buyerProcessingFeesCentavos": null,
  "physicalCollectionsCentavos": null,
  "providerChargesCentavos": null,
  "simulatedCwtCentavos": null,
  "estimatedRemittanceCashCentavos": null,
  "earnedCommissionCentavos": null,
} satisfies VendorEarningsTrendChange

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsTrendChange
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


