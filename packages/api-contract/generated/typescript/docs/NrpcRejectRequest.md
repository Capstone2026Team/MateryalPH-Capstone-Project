
# NrpcRejectRequest


## Properties

Name | Type
------------ | -------------
`snapshotVersion` | number
`nrpcId` | string
`reason` | string

## Example

```typescript
import type { NrpcRejectRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "snapshotVersion": null,
  "nrpcId": null,
  "reason": null,
} satisfies NrpcRejectRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcRejectRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


