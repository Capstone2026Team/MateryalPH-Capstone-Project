
# VendorVerificationDraft

Store contact information uses store_email and store_phone. The retired contacts field is rejected and is not returned in current Vendor or Admin snapshots.

## Properties

Name | Type
------------ | -------------
`formState` | string
`draftLockVersion` | number
`lockVersion` | number
`businessType` | string
`registeredName` | string
`legalBusinessName` | string
`storeName` | string
`dateEstablished` | Date
`storeEmail` | string
`storePhone` | string
`classification` | [VendorVerificationDraftClassification](VendorVerificationDraftClassification.md)
`address` | { [key: string]: any; }
`representative` | [VendorVerificationDraftRepresentative](VendorVerificationDraftRepresentative.md)
`legalIdentity` | [VendorVerificationDraftLegalIdentity](VendorVerificationDraftLegalIdentity.md)
`taxProfile` | [VendorVerificationDraftTaxProfile](VendorVerificationDraftTaxProfile.md)

## Example

```typescript
import type { VendorVerificationDraft } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "formState": null,
  "draftLockVersion": null,
  "lockVersion": null,
  "businessType": null,
  "registeredName": null,
  "legalBusinessName": null,
  "storeName": null,
  "dateEstablished": null,
  "storeEmail": null,
  "storePhone": null,
  "classification": null,
  "address": null,
  "representative": null,
  "legalIdentity": null,
  "taxProfile": null,
} satisfies VendorVerificationDraft

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVerificationDraft
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


