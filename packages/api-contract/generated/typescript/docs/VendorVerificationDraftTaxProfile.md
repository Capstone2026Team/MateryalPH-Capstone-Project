
# VendorVerificationDraftTaxProfile


## Properties

Name | Type
------------ | -------------
`taxpayerKey` | string
`tin` | string
`branchCode` | string
`branchCodeLength` | number
`headOffice` | boolean
`declarationYear` | number
`birCorReference` | string
`entityClass` | string
`registrationCategory` | string
`vatCategory` | string
`fiscalYearStartMonth` | number
`declarationType` | string
`thresholdPosition` | string
`submissionDate` | Date
`outsidePlatformAsOf` | Date
`withholdingScenario` | string
`taxReliefClaimed` | boolean
`ownerAttested` | boolean

## Example

```typescript
import type { VendorVerificationDraftTaxProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "taxpayerKey": null,
  "tin": null,
  "branchCode": null,
  "branchCodeLength": null,
  "headOffice": null,
  "declarationYear": null,
  "birCorReference": null,
  "entityClass": null,
  "registrationCategory": null,
  "vatCategory": null,
  "fiscalYearStartMonth": null,
  "declarationType": null,
  "thresholdPosition": null,
  "submissionDate": null,
  "outsidePlatformAsOf": null,
  "withholdingScenario": null,
  "taxReliefClaimed": null,
  "ownerAttested": null,
} satisfies VendorVerificationDraftTaxProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVerificationDraftTaxProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


