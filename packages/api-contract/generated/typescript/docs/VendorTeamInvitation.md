
# VendorTeamInvitation


## Properties

Name | Type
------------ | -------------
`id` | string
`fullName` | string
`normalizedEmail` | string
`role` | string
`canManageStaff` | boolean
`expiresAt` | string
`acceptedAt` | string
`revokedAt` | string
`lockVersion` | number

## Example

```typescript
import type { VendorTeamInvitation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "fullName": null,
  "normalizedEmail": null,
  "role": null,
  "canManageStaff": null,
  "expiresAt": null,
  "acceptedAt": null,
  "revokedAt": null,
  "lockVersion": null,
} satisfies VendorTeamInvitation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamInvitation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


