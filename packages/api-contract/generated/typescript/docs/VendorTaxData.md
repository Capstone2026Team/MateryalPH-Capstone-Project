
# VendorTaxData


## Properties

Name | Type
------------ | -------------
`taxpayerKey` | string
`legalName` | string
`tradeName` | string
`tin` | string
`branchCode` | string
`entityClass` | string
`registrationCategory` | string
`vatCategory` | string
`fiscalYearStartMonth` | number
`effectiveFrom` | string
`effectiveUntil` | string
`birCorVersionId` | string
`invoiceMethod` | string
`invoiceCoverage` | string
`priorYearAmountCentavos` | number
`priorYearPosition` | string
`declarationYear` | number
`declarationReceipt` | string
`declarationValidFrom` | string
`declarationValidUntil` | string
`outsidePlatformAmountCentavos` | number
`outsidePlatformAsOf` | string
`overlapScope` | string
`evidenceVersionIds` | Array&lt;string&gt;

## Example

```typescript
import type { VendorTaxData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "taxpayerKey": null,
  "legalName": null,
  "tradeName": null,
  "tin": null,
  "branchCode": null,
  "entityClass": null,
  "registrationCategory": null,
  "vatCategory": null,
  "fiscalYearStartMonth": null,
  "effectiveFrom": null,
  "effectiveUntil": null,
  "birCorVersionId": null,
  "invoiceMethod": null,
  "invoiceCoverage": null,
  "priorYearAmountCentavos": null,
  "priorYearPosition": null,
  "declarationYear": null,
  "declarationReceipt": null,
  "declarationValidFrom": null,
  "declarationValidUntil": null,
  "outsidePlatformAmountCentavos": null,
  "outsidePlatformAsOf": null,
  "overlapScope": null,
  "evidenceVersionIds": null,
} satisfies VendorTaxData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTaxData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


