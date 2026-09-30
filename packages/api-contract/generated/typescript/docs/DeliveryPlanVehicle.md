
# DeliveryPlanVehicle


## Properties

Name | Type
------------ | -------------
`vehicleId` | string
`name` | string
`vehicleCategory` | string
`vehicleType` | string
`customTypeName` | string
`brand` | string
`numberAvailable` | number
`capacityKg` | string
`mixerCapacityM3` | string
`heavyClassification` | string
`maximumDistanceKm` | number
`baseFeeCentavos` | number
`perKmCentavos` | number
`perTripCentavos` | number
`withinRange` | boolean
`rateVersion` | number
`configurationVersion` | number
`numberOfVehicles` | number
`totalVehicleTrips` | number
`estimatedChargeCentavos` | number
`limitingFactor` | string

## Example

```typescript
import type { DeliveryPlanVehicle } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vehicleId": null,
  "name": null,
  "vehicleCategory": null,
  "vehicleType": null,
  "customTypeName": null,
  "brand": null,
  "numberAvailable": null,
  "capacityKg": null,
  "mixerCapacityM3": null,
  "heavyClassification": null,
  "maximumDistanceKm": null,
  "baseFeeCentavos": null,
  "perKmCentavos": null,
  "perTripCentavos": null,
  "withinRange": null,
  "rateVersion": null,
  "configurationVersion": null,
  "numberOfVehicles": null,
  "totalVehicleTrips": null,
  "estimatedChargeCentavos": null,
  "limitingFactor": null,
} satisfies DeliveryPlanVehicle

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPlanVehicle
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


