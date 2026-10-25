
# WebPasswordRecoveryEnvelopeAllOfData


## Properties

Name | Type
------------ | -------------
`verified` | boolean
`expiresIn` | number
`recoveryCodes` | Array&lt;string&gt;

## Example

```typescript
import type { WebPasswordRecoveryEnvelopeAllOfData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "verified": null,
  "expiresIn": null,
  "recoveryCodes": null,
} satisfies WebPasswordRecoveryEnvelopeAllOfData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WebPasswordRecoveryEnvelopeAllOfData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


