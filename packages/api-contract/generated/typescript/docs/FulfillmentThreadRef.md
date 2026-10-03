
# FulfillmentThreadRef


## Properties

Name | Type
------------ | -------------
`available` | boolean
`conversationId` | string
`readOnly` | boolean
`readOnlyReason` | string
`notice` | string

## Example

```typescript
import type { FulfillmentThreadRef } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "available": null,
  "conversationId": null,
  "readOnly": null,
  "readOnlyReason": null,
  "notice": null,
} satisfies FulfillmentThreadRef

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentThreadRef
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


