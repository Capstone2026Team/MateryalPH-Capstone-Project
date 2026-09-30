
# MoneyBreakdown

FIN-02 Buyer amounts in integer centavos. Prices include any Vendor VAT; E = M − V. Online pays M + D + F; COD/In-Store without NRPC pays M + D directly; with NRPC pays N + F online and M + D − N directly. Vendor commission and merchant withholding are never Buyer charges.

## Properties

Name | Type
------------ | -------------
`currency` | string
`calculationVersion` | string
`status` | string
`materialsGrossCentavos` | number
`vendorDiscountCentavos` | number
`materialsSubtotalCentavos` | number
`includedVatCentavos` | number
`vatExclusiveCentavos` | number
`vatTreatment` | string
`delivery` | [MoneyDelivery](MoneyDelivery.md)
`nrpc` | [MoneyNrpc](MoneyNrpc.md)
`processingFee` | [ProcessingFee](ProcessingFee.md)
`commercialTotalCentavos` | number
`amountDueOnlineCentavos` | number
`onlinePrincipalCentavos` | number
`physicalBalanceCentavos` | number
`paymentPurpose` | string
`excludes` | Array&lt;string&gt;

## Example

```typescript
import type { MoneyBreakdown } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currency": null,
  "calculationVersion": null,
  "status": null,
  "materialsGrossCentavos": null,
  "vendorDiscountCentavos": null,
  "materialsSubtotalCentavos": null,
  "includedVatCentavos": null,
  "vatExclusiveCentavos": null,
  "vatTreatment": null,
  "delivery": null,
  "nrpc": null,
  "processingFee": null,
  "commercialTotalCentavos": null,
  "amountDueOnlineCentavos": null,
  "onlinePrincipalCentavos": null,
  "physicalBalanceCentavos": null,
  "paymentPurpose": null,
  "excludes": null,
} satisfies MoneyBreakdown

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MoneyBreakdown
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


