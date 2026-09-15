
# AccountProfile


## Properties

Name | Type
------------ | -------------
`id` | string
`fullName` | string
`email` | string
`accountType` | string
`accountStatus` | string
`lockVersion` | number
`createdAt` | string
`buyerType` | string
`companyName` | string
`organizationName` | string
`role` | string
`organizationId` | string
`membershipId` | string
`canManageStaff` | boolean
`permissions` | Array&lt;string&gt;

## Example

```typescript
import type { AccountProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "fullName": null,
  "email": null,
  "accountType": null,
  "accountStatus": null,
  "lockVersion": null,
  "createdAt": null,
  "buyerType": null,
  "companyName": null,
  "organizationName": null,
  "role": null,
  "organizationId": null,
  "membershipId": null,
  "canManageStaff": null,
  "permissions": null,
} satisfies AccountProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


