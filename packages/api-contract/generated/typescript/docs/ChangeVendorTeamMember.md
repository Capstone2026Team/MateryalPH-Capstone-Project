
# ChangeVendorTeamMember

Exactly one of role, status, or can_manage_staff is required. Delegation is Owner-only; Managers may manage only the four non-manager staff roles.

## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`role` | string
`status` | string
`canManageStaff` | boolean

## Example

```typescript
import type { ChangeVendorTeamMember } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "role": null,
  "status": null,
  "canManageStaff": null,
} satisfies ChangeVendorTeamMember

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChangeVendorTeamMember
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


