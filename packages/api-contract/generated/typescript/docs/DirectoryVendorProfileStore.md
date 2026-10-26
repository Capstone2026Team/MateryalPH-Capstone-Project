
# DirectoryVendorProfileStore


## Properties

Name | Type
------------ | -------------
`legalName` | string
`registeredName` | string
`businessType` | string
`description` | string
`logoUrl` | string
`bannerUrl` | string
`contactEmail` | string
`contactPhone` | string
`address` | string
`location` | string
`verificationStatus` | string
`setupStatus` | string
`activationStatus` | string
`discoverabilityStatus` | string
`accountStatus` | string
`activationHoldCode` | string
`vacationMode` | boolean
`bulkCapability` | boolean
`joinedAt` | Date

## Example

```typescript
import type { DirectoryVendorProfileStore } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "legalName": null,
  "registeredName": null,
  "businessType": null,
  "description": null,
  "logoUrl": null,
  "bannerUrl": null,
  "contactEmail": null,
  "contactPhone": null,
  "address": null,
  "location": null,
  "verificationStatus": null,
  "setupStatus": null,
  "activationStatus": null,
  "discoverabilityStatus": null,
  "accountStatus": null,
  "activationHoldCode": null,
  "vacationMode": null,
  "bulkCapability": null,
  "joinedAt": null,
} satisfies DirectoryVendorProfileStore

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryVendorProfileStore
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


