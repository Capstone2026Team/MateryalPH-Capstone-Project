
# InviteVendorTeam


## Properties

Name | Type
------------ | -------------
`fullName` | string
`email` | string
`telephoneE164` | string
`role` | string
`canManageStaff` | boolean
`expiresAt` | Date

## Example

```typescript
import type { InviteVendorTeam } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fullName": null,
  "email": null,
  "telephoneE164": null,
  "role": null,
  "canManageStaff": null,
  "expiresAt": null,
} satisfies InviteVendorTeam

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InviteVendorTeam
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


