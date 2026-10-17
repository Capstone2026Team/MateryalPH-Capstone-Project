
# BuyerMobileMfaRecoveryRequest


## Properties

Name | Type
------------ | -------------
`challengeToken` | string
`recoveryCode` | string

## Example

```typescript
import type { BuyerMobileMfaRecoveryRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "challengeToken": null,
  "recoveryCode": null,
} satisfies BuyerMobileMfaRecoveryRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerMobileMfaRecoveryRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


