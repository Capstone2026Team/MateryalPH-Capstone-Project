
# PasswordRecoveryEnvelopeAllOfData


## Properties

Name | Type
------------ | -------------
`message` | string
`resendAfterSeconds` | number
`expiresIn` | number

## Example

```typescript
import type { PasswordRecoveryEnvelopeAllOfData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "message": null,
  "resendAfterSeconds": null,
  "expiresIn": null,
} satisfies PasswordRecoveryEnvelopeAllOfData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PasswordRecoveryEnvelopeAllOfData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


