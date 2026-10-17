
# OperationRetryRequest


## Properties

Name | Type
------------ | -------------
`targetType` | string
`reference` | string
`reason` | string

## Example

```typescript
import type { OperationRetryRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "targetType": null,
  "reference": null,
  "reason": null,
} satisfies OperationRetryRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OperationRetryRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


