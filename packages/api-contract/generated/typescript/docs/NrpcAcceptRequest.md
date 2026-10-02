
# NrpcAcceptRequest


## Properties

Name | Type
------------ | -------------
`budgetOverrideReason` | string
`snapshotVersion` | number
`nrpcId` | string
`termsVersionId` | string
`acknowledged` | boolean

## Example

```typescript
import type { NrpcAcceptRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "budgetOverrideReason": null,
  "snapshotVersion": null,
  "nrpcId": null,
  "termsVersionId": null,
  "acknowledged": null,
} satisfies NrpcAcceptRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcAcceptRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


