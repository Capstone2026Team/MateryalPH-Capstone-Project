
# AccountReauthentication

An enrolled Vendor or Admin web account may reauthenticate with a fresh authenticator code alone. Buyer accounts continue to use password or current-email OTP. Privileged password and email OTP reauthentication also require TOTP.

## Properties

Name | Type
------------ | -------------
`password` | string
`code` | string
`emailCode` | string

## Example

```typescript
import type { AccountReauthentication } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "password": null,
  "code": null,
  "emailCode": null,
} satisfies AccountReauthentication

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountReauthentication
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


