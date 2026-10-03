
# FulfillmentReceipt


## Properties

Name | Type
------------ | -------------
`dueAt` | Date
`paused` | boolean
`remainingSeconds` | number
`confirmedAt` | Date
`confirmationSource` | string
`windowHours` | number

## Example

```typescript
import type { FulfillmentReceipt } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "dueAt": null,
  "paused": null,
  "remainingSeconds": null,
  "confirmedAt": null,
  "confirmationSource": null,
  "windowHours": null,
} satisfies FulfillmentReceipt

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentReceipt
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


