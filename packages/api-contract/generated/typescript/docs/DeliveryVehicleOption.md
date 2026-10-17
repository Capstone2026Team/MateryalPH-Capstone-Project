
# DeliveryVehicleOption


## Properties

Name | Type
------------ | -------------
`vehicleIndex` | number
`vehicleId` | string
`name` | string
`vehicleType` | string
`numberOfVehicles` | number
`totalVehicleTrips` | number
`available` | boolean
`unavailableReason` | string

## Example

```typescript
import type { DeliveryVehicleOption } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vehicleIndex": null,
  "vehicleId": null,
  "name": null,
  "vehicleType": null,
  "numberOfVehicles": null,
  "totalVehicleTrips": null,
  "available": null,
  "unavailableReason": null,
} satisfies DeliveryVehicleOption

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryVehicleOption
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


