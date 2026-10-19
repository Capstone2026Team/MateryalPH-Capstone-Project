
# DirectoryBuyerProfile


## Properties

Name | Type
------------ | -------------
`id` | string
`subjectType` | string
`name` | string
`status` | string
`profile` | [DirectoryBuyerProfileProfile](DirectoryBuyerProfileProfile.md)
`ratings` | [DirectoryBuyerProfileRatings](DirectoryBuyerProfileRatings.md)
`activity` | [DirectoryBuyerProfileActivity](DirectoryBuyerProfileActivity.md)
`recentOrders` | [Array&lt;DirectoryBuyerProfileRecentOrdersInner&gt;](DirectoryBuyerProfileRecentOrdersInner.md)
`sanctions` | [Array&lt;DirectorySanction&gt;](DirectorySanction.md)
`canViewEnforcement` | boolean

## Example

```typescript
import type { DirectoryBuyerProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "subjectType": null,
  "name": null,
  "status": null,
  "profile": null,
  "ratings": null,
  "activity": null,
  "recentOrders": null,
  "sanctions": null,
  "canViewEnforcement": null,
} satisfies DirectoryBuyerProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryBuyerProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


