
# VendorVerificationRow


## Properties

Name | Type
------------ | -------------
`id` | string
`storeName` | string
`onboardingStatus` | string
`storeVerificationStatus` | string
`storeSetupStatus` | string
`activationStatus` | string
`discoverabilityStatus` | string
`marketplaceStatus` | string
`lockVersion` | number
`submittedAt` | string

## Example

```typescript
import type { VendorVerificationRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "storeName": null,
  "onboardingStatus": null,
  "storeVerificationStatus": null,
  "storeSetupStatus": null,
  "activationStatus": null,
  "discoverabilityStatus": null,
  "marketplaceStatus": null,
  "lockVersion": null,
  "submittedAt": null,
} satisfies VendorVerificationRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVerificationRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


