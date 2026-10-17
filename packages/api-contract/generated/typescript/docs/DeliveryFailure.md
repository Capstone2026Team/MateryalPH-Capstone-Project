
# DeliveryFailure


## Properties

Name | Type
------------ | -------------
`id` | string
`channel` | string
`state` | string
`attemptCount` | number
`failureCode` | string
`updatedAt` | string

## Example

```typescript
import type { DeliveryFailure } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "channel": null,
  "state": null,
  "attemptCount": null,
  "failureCode": null,
  "updatedAt": null,
} satisfies DeliveryFailure

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryFailure
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


