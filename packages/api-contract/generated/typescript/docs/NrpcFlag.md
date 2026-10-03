
# NrpcFlag


## Properties

Name | Type
------------ | -------------
`reviewState` | string
`reason` | string
`flaggedAt` | Date

## Example

```typescript
import type { NrpcFlag } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reviewState": null,
  "reason": null,
  "flaggedAt": null,
} satisfies NrpcFlag

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcFlag
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


