
# AdminVendorVerificationDecision


## Properties

Name | Type
------------ | -------------
`authorityEvidenceVersionId` | string
`authorityScopes` | Array&lt;string&gt;
`decision` | string
`lockVersion` | number
`reason` | string
`verifiedDocumentNumber` | string
`verifiedIssueDate` | Date
`expirationKind` | string
`verifiedExpirationDate` | Date
`evidenceSource` | string
`verifiedVatCategory` | string
`remarks` | string

## Example

```typescript
import type { AdminVendorVerificationDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "authorityEvidenceVersionId": null,
  "authorityScopes": null,
  "decision": null,
  "lockVersion": null,
  "reason": null,
  "verifiedDocumentNumber": null,
  "verifiedIssueDate": null,
  "expirationKind": null,
  "verifiedExpirationDate": null,
  "evidenceSource": null,
  "verifiedVatCategory": null,
  "remarks": null,
} satisfies AdminVendorVerificationDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminVendorVerificationDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


