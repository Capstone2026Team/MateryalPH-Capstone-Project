
# VendorTaxProfile


## Properties

Name | Type
------------ | -------------
`reviewReason` | string
`lockVersion` | number
`evidenceVersions` | [Array&lt;VendorTaxProfileEvidenceVersionsInner&gt;](VendorTaxProfileEvidenceVersionsInner.md)
`profileId` | string
`versionId` | string
`version` | number
`status` | string
`environment` | string
`evidenceOrigin` | string
`data` | { [key: string]: any; }
`ownerAttestedAt` | string
`withholdingTreatment` | string
`history` | [Array&lt;VendorTaxVersionHistory&gt;](VendorTaxVersionHistory.md)
`legalEffect` | string

## Example

```typescript
import type { VendorTaxProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reviewReason": null,
  "lockVersion": null,
  "evidenceVersions": null,
  "profileId": null,
  "versionId": null,
  "version": null,
  "status": null,
  "environment": null,
  "evidenceOrigin": null,
  "data": null,
  "ownerAttestedAt": null,
  "withholdingTreatment": null,
  "history": null,
  "legalEffect": null,
} satisfies VendorTaxProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTaxProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


