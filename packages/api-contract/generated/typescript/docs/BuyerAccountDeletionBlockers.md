
# BuyerAccountDeletionBlockers


## Properties

Name | Type
------------ | -------------
`activeOrders` | number
`activeDisputes` | number
`pendingRefunds` | number

## Example

```typescript
import type { BuyerAccountDeletionBlockers } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "activeOrders": null,
  "activeDisputes": null,
  "pendingRefunds": null,
} satisfies BuyerAccountDeletionBlockers

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAccountDeletionBlockers
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


