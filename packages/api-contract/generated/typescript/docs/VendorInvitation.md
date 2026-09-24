
# VendorInvitation


## Properties

Name | Type
------------ | -------------
`queued` | boolean
`invitationId` | string
`role` | string
`expiresAt` | Date

## Example

```typescript
import type { VendorInvitation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "queued": null,
  "invitationId": null,
  "role": null,
  "expiresAt": null,
} satisfies VendorInvitation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorInvitation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


