
# VendorEarningsTrendPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
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
import type { VendorEarningsTrendPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "commercialSalesCentavos": null,
  "onlineCollectionsCentavos": null,
  "onlineRefundsCentavos": null,
  "buyerProcessingFeesCentavos": null,
  "physicalCollectionsCentavos": null,
  "providerChargesCentavos": null,
  "simulatedCwtCentavos": null,
  "estimatedRemittanceCashCentavos": null,
  "earnedCommissionCentavos": null,
} satisfies VendorEarningsTrendPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsTrendPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


