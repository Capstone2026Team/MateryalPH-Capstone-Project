
# DirectoryBuyerProfileProfile


## Properties

Name | Type
------------ | -------------
`avatarUrl` | string
`email` | string
`emailVerified` | boolean
`mobile` | string
`buyerType` | string
`companyName` | string
`positionTitle` | string
`industry` | string
`area` | string
`onboardingStatus` | string
`joinedAt` | Date
`deletedAt` | Date
`commerceRestrictedUntil` | Date

## Example

```typescript
import type { DirectoryBuyerProfileProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "avatarUrl": null,
  "email": null,
  "emailVerified": null,
  "mobile": null,
  "buyerType": null,
  "companyName": null,
  "positionTitle": null,
  "industry": null,
  "area": null,
  "onboardingStatus": null,
  "joinedAt": null,
  "deletedAt": null,
  "commerceRestrictedUntil": null,
} satisfies DirectoryBuyerProfileProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryBuyerProfileProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


