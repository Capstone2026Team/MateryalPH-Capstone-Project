
# FinancialPreview

FIN-02 preview. M = Σ line payable amounts, V = included VAT, E = M − V; D estimate or pending; F pending until a payment channel. Never includes Vendor commission or merchant withholding.

## Properties

Name | Type
------------ | -------------
`currency` | string
`calculationVersion` | string
`lines` | [Array&lt;FinancialPreviewLine&gt;](FinancialPreviewLine.md)
`materialsSubtotalCentavos` | number
`includedVatCentavos` | number
`vatExclusiveMaterialsCentavos` | number
`vatTreatment` | string
`delivery` | [DeliveryAmount](DeliveryAmount.md)
`processingFee` | [ProcessingFeeAmount](ProcessingFeeAmount.md)
`totalBeforeProcessingMinCentavos` | number
`totalBeforeProcessingMaxCentavos` | number
`excludes` | Array&lt;string&gt;
`status` | string

## Example

```typescript
import type { FinancialPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currency": null,
  "calculationVersion": null,
  "lines": null,
  "materialsSubtotalCentavos": null,
  "includedVatCentavos": null,
  "vatExclusiveMaterialsCentavos": null,
  "vatTreatment": null,
  "delivery": null,
  "processingFee": null,
  "totalBeforeProcessingMinCentavos": null,
  "totalBeforeProcessingMaxCentavos": null,
  "excludes": null,
  "status": null,
} satisfies FinancialPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinancialPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


