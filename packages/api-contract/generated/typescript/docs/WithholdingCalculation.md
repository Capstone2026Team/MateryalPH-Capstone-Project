
# WithholdingCalculation

Sums of immutable POSTED assessment components for one Vendor and withholding entity in the collection month. Non-posted assessments and later tax corrections are excluded. Tax is rounded per collection, so multiplying the monthly taxable basis can differ from the recorded withholding sum.

## Properties

Name | Type
------------ | -------------
`collectionsCentavos` | number
`refundsCentavos` | number
`deliveryCentavos` | number
`vatCentavos` | number
`providerChargeCentavos` | number
`grossBasisCentavos` | number
`taxableBasisCentavos` | number
`relievedBasisCentavos` | number

## Example

```typescript
import type { WithholdingCalculation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "collectionsCentavos": null,
  "refundsCentavos": null,
  "deliveryCentavos": null,
  "vatCentavos": null,
  "providerChargeCentavos": null,
  "grossBasisCentavos": null,
  "taxableBasisCentavos": null,
  "relievedBasisCentavos": null,
} satisfies WithholdingCalculation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingCalculation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


