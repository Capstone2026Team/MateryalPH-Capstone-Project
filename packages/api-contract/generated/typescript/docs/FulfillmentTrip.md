
# FulfillmentTrip


## Properties

Name | Type
------------ | -------------
`vehicleIndex` | number
`tripNumber` | number
`name` | string
`totalVehicleTrips` | number
`dispatchedAt` | Date

## Example

```typescript
import type { FulfillmentTrip } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vehicleIndex": null,
  "tripNumber": null,
  "name": null,
  "totalVehicleTrips": null,
  "dispatchedAt": null,
} satisfies FulfillmentTrip

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentTrip
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


