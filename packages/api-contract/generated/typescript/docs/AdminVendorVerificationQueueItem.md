
# AdminVendorVerificationQueueItem


## Properties

Name | Type
------------ | -------------
`id` | string
`storeName` | string
`registeredName` | string
`businessType` | string
`verificationStatus` | string
`setupStatus` | string
`activationStatus` | string
`submittedAt` | Date
`progress` | { [key: string]: any; }

## Example

```typescript
import type { AdminVendorVerificationQueueItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "storeName": null,
  "registeredName": null,
  "businessType": null,
  "verificationStatus": null,
  "setupStatus": null,
  "activationStatus": null,
  "submittedAt": null,
  "progress": null,
} satisfies AdminVendorVerificationQueueItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminVendorVerificationQueueItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


