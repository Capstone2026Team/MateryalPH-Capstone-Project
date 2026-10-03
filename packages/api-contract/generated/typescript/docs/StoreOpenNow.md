
# StoreOpenNow

Informational label from the saved schedule and server time in Asia/Manila; not staff presence, stock or a response promise.

## Properties

Name | Type
------------ | -------------
`status` | string
`closesAt` | string
`nextOpening` | [StoreNextOpening](StoreNextOpening.md)
`basis` | string

## Example

```typescript
import type { StoreOpenNow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "closesAt": null,
  "nextOpening": null,
  "basis": null,
} satisfies StoreOpenNow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StoreOpenNow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


