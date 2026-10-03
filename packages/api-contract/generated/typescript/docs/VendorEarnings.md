
# VendorEarnings


## Properties

Name | Type
------------ | -------------
`demo` | boolean
`environment` | string
`notice` | string
`commercialSalesCentavos` | number
`includedVatCentavos` | number
`onlineCollectionsCentavos` | number
`buyerProcessingFeesCentavos` | number
`physicalCollectionsCentavos` | number
`providerChargesCentavos` | number
`simulatedCwtCentavos` | number
`estimatedRemittanceCashCentavos` | number
`earnedCommissionCentavos` | number
`estimatedCommissionCentavos` | number
`unpaidStatementsCentavos` | number

## Example

```typescript
import type { VendorEarnings } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "demo": null,
  "environment": null,
  "notice": null,
  "commercialSalesCentavos": null,
  "includedVatCentavos": null,
  "onlineCollectionsCentavos": null,
  "buyerProcessingFeesCentavos": null,
  "physicalCollectionsCentavos": null,
  "providerChargesCentavos": null,
  "simulatedCwtCentavos": null,
  "estimatedRemittanceCashCentavos": null,
  "earnedCommissionCentavos": null,
  "estimatedCommissionCentavos": null,
  "unpaidStatementsCentavos": null,
} satisfies VendorEarnings

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarnings
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


