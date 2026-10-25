
# CompleteWebPasswordRecoveryRequest

Vendor passwords require at least 12 characters; Admin passwords require at least 14. Both require mixed case and a number.

## Properties

Name | Type
------------ | -------------
`email` | string
`portal` | [WebPasswordRecoveryPortal](WebPasswordRecoveryPortal.md)
`password` | string
`passwordConfirmation` | string

## Example

```typescript
import type { CompleteWebPasswordRecoveryRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "email": null,
  "portal": null,
  "password": null,
  "passwordConfirmation": null,
} satisfies CompleteWebPasswordRecoveryRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CompleteWebPasswordRecoveryRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


