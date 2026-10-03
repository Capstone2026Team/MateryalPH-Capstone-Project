
# CheckoutSubmission


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`submittedAt` | Date
`derivedStatus` | string
`orders` | [Array&lt;CheckoutChildOrder&gt;](CheckoutChildOrder.md)
`notice` | string

## Example

```typescript
import type { CheckoutSubmission } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "submittedAt": null,
  "derivedStatus": null,
  "orders": null,
  "notice": null,
} satisfies CheckoutSubmission

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutSubmission
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


