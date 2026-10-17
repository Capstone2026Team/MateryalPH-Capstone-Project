
# WithholdingThresholdCalculation

Recorded components of POSTED MERCHANT_CWT assessments for the same environment and taxpayer-year accumulator. VOIDED assessments are excluded. Assessed cash is the original estimate for these assessments, before subsequent refunds; it is not a provider balance or date-filtered Earnings total.

## Properties

Name | Type
------------ | -------------
`collectionsCentavos` | number
`refundsCentavos` | number
`deliveryCentavos` | number
`materialVatCentavos` | number
`providerChargesCentavos` | number
`grossBasisCentavos` | number
`withheldCentavos` | number
`assessedCashCentavos` | number

## Example

```typescript
import type { WithholdingThresholdCalculation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "collectionsCentavos": null,
  "refundsCentavos": null,
  "deliveryCentavos": null,
  "materialVatCentavos": null,
  "providerChargesCentavos": null,
  "grossBasisCentavos": null,
  "withheldCentavos": null,
  "assessedCashCentavos": null,
} satisfies WithholdingThresholdCalculation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingThresholdCalculation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


