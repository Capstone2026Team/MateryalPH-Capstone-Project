
# DirectoryVendorRow


## Properties

Name | Type
------------ | -------------
`id` | string
`storeName` | string
`ownerName` | string
`ownerEmail` | string
`status` | string
`verificationStatus` | string
`discoverabilityStatus` | string
`accountStatus` | string
`location` | string
`joinedAt` | Date

## Example

```typescript
import type { DirectoryVendorRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "storeName": null,
  "ownerName": null,
  "ownerEmail": null,
  "status": null,
  "verificationStatus": null,
  "discoverabilityStatus": null,
  "accountStatus": null,
  "location": null,
  "joinedAt": null,
} satisfies DirectoryVendorRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryVendorRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


