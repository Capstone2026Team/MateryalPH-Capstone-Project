
# OrderReservation


## Properties

Name | Type
------------ | -------------
`orderLineId` | string
`quantity` | string
`state` | string
`releaseReason` | string
`reservedAt` | Date
`releasedAt` | Date

## Example

```typescript
import type { OrderReservation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderLineId": null,
  "quantity": null,
  "state": null,
  "releaseReason": null,
  "reservedAt": null,
  "releasedAt": null,
} satisfies OrderReservation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderReservation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


