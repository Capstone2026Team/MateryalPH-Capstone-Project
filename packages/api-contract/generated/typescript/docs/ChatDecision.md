
# ChatDecision


## Properties

Name | Type
------------ | -------------
`versionId` | string
`contentHash` | string
`reason` | string
`nrpcAcknowledged` | boolean
`nrpcTermsVersionId` | string

## Example

```typescript
import type { ChatDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "versionId": null,
  "contentHash": null,
  "reason": null,
  "nrpcAcknowledged": null,
  "nrpcTermsVersionId": null,
} satisfies ChatDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


