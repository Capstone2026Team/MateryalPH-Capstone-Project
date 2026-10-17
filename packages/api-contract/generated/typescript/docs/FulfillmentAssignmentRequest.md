
# FulfillmentAssignmentRequest


## Properties

Name | Type
------------ | -------------
`userId` | number
`reason` | string
`vehicleIndex` | number
`lockVersion` | number
`dispatch` | boolean

## Example

```typescript
import type { FulfillmentAssignmentRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "userId": null,
  "reason": null,
  "vehicleIndex": null,
  "lockVersion": null,
  "dispatch": null,
} satisfies FulfillmentAssignmentRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentAssignmentRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


