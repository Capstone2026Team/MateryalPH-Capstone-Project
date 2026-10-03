
# FulfillmentAssignee


## Properties

Name | Type
------------ | -------------
`userId` | number
`displayName` | string
`assigned` | boolean

## Example

```typescript
import type { FulfillmentAssignee } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "userId": null,
  "displayName": null,
  "assigned": null,
} satisfies FulfillmentAssignee

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentAssignee
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


