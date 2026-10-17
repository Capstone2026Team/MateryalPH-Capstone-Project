
# BuyerAccountDeletionResult


## Properties

Name | Type
------------ | -------------
`reference` | string
`deletedAt` | Date
`signInRequired` | boolean

## Example

```typescript
import type { BuyerAccountDeletionResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reference": null,
  "deletedAt": null,
  "signInRequired": null,
} satisfies BuyerAccountDeletionResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAccountDeletionResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


