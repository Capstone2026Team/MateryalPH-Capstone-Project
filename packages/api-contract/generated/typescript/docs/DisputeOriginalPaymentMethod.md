
# DisputeOriginalPaymentMethod

Information only. No request anywhere accepts a different refund destination.

## Properties

Name | Type
------------ | -------------
`label` | string
`physical` | boolean
`notice` | string

## Example

```typescript
import type { DisputeOriginalPaymentMethod } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "physical": null,
  "notice": null,
} satisfies DisputeOriginalPaymentMethod

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeOriginalPaymentMethod
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


