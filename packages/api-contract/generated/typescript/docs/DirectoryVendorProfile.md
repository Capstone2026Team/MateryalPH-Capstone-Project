
# DirectoryVendorProfile


## Properties

Name | Type
------------ | -------------
`id` | string
`subjectType` | string
`storeName` | string
`status` | string
`store` | [DirectoryVendorProfileStore](DirectoryVendorProfileStore.md)
`owner` | [DirectoryVendorProfileOwner](DirectoryVendorProfileOwner.md)
`ratings` | [DirectoryVendorProfileRatings](DirectoryVendorProfileRatings.md)
`activity` | [DirectoryVendorProfileActivity](DirectoryVendorProfileActivity.md)
`sanctions` | [Array&lt;DirectorySanction&gt;](DirectorySanction.md)
`canViewEnforcement` | boolean
`canViewVerification` | boolean

## Example

```typescript
import type { DirectoryVendorProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "subjectType": null,
  "storeName": null,
  "status": null,
  "store": null,
  "owner": null,
  "ratings": null,
  "activity": null,
  "sanctions": null,
  "canViewEnforcement": null,
  "canViewVerification": null,
} satisfies DirectoryVendorProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryVendorProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


