
# VendorTeamMember


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`role` | string
`status` | string
`canManageStaff` | boolean
`lockVersion` | number
`createdAt` | string

## Example

```typescript
import type { VendorTeamMember } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "role": null,
  "status": null,
  "canManageStaff": null,
  "lockVersion": null,
  "createdAt": null,
} satisfies VendorTeamMember

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamMember
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


