
# OperationFailure


## Properties

Name | Type
------------ | -------------
`kind` | string
`reference` | string
`label` | string
`queue` | string
`failure` | string
`attempts` | number
`failedAt` | Date
`retryable` | boolean
`retryNote` | string

## Example

```typescript
import type { OperationFailure } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "reference": null,
  "label": null,
  "queue": null,
  "failure": null,
  "attempts": null,
  "failedAt": null,
  "retryable": null,
  "retryNote": null,
} satisfies OperationFailure

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OperationFailure
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


