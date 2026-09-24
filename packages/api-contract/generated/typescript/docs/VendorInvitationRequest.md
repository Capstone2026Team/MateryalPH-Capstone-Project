
# VendorInvitationRequest


## Properties

Name | Type
------------ | -------------
`email` | string
`inviteeName` | string
`inviteeMobile` | string
`role` | string

## Example

```typescript
import type { VendorInvitationRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "email": null,
  "inviteeName": null,
  "inviteeMobile": null,
  "role": null,
} satisfies VendorInvitationRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorInvitationRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


