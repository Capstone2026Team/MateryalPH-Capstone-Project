
# VendorTeamInvitationRecord


## Properties

Name | Type
------------ | -------------
`id` | string
`inviteeName` | string
`email` | string
`inviteeMobile` | string
`vendorOrganizationId` | string
`role` | string
`canManageStaff` | boolean
`status` | string
`invitedById` | string
`invitedByName` | string
`createdAt` | Date
`expiresAt` | Date
`acceptedAt` | Date

## Example

```typescript
import type { VendorTeamInvitationRecord } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "inviteeName": null,
  "email": null,
  "inviteeMobile": null,
  "vendorOrganizationId": null,
  "role": null,
  "canManageStaff": null,
  "status": null,
  "invitedById": null,
  "invitedByName": null,
  "createdAt": null,
  "expiresAt": null,
  "acceptedAt": null,
} satisfies VendorTeamInvitationRecord

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamInvitationRecord
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


