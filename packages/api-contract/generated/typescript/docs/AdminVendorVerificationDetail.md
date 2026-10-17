
# AdminVendorVerificationDetail

Documents the Phase 16 keys of the free-form Phase 3E case payload (AdminVendorVerificationDetailEnvelope.data): separate workstream states and source-revision activation restrictions.

## Properties

Name | Type
------------ | -------------
`workstreams` | [VendorWorkstreams](VendorWorkstreams.md)
`activationRestrictions` | [ActivationRestrictions](ActivationRestrictions.md)
`readiness` | { [key: string]: any; }

## Example

```typescript
import type { AdminVendorVerificationDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "workstreams": null,
  "activationRestrictions": null,
  "readiness": null,
} satisfies AdminVendorVerificationDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminVendorVerificationDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


