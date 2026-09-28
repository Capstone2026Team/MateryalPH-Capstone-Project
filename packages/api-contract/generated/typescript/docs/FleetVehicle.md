
# FleetVehicle


## Properties

Name | Type
------------ | -------------
`id` | string
`lockVersion` | number
`configurationVersion` | number
`vehicleCategory` | string
`vehicleType` | string
`customTypeName` | string
`name` | string
`brand` | string
`imageFileId` | string
`numberAvailable` | number
`capacityKg` | number
`cargoLengthM` | number
`cargoWidthM` | number
`cargoHeightM` | number
`mixerCapacityM3` | number
`heavyClassification` | string
`active` | boolean
`available` | boolean
`rateVersion` | number
`baseFeeCentavos` | number
`perKmCentavos` | number
`maximumDistanceKm` | number
`eligibility` | [FleetVehicleEligibility](FleetVehicleEligibility.md)
`updatedAt` | string

## Example

```typescript
import type { FleetVehicle } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "lockVersion": null,
  "configurationVersion": null,
  "vehicleCategory": null,
  "vehicleType": null,
  "customTypeName": null,
  "name": null,
  "brand": null,
  "imageFileId": null,
  "numberAvailable": null,
  "capacityKg": null,
  "cargoLengthM": null,
  "cargoWidthM": null,
  "cargoHeightM": null,
  "mixerCapacityM3": null,
  "heavyClassification": null,
  "active": null,
  "available": null,
  "rateVersion": null,
  "baseFeeCentavos": null,
  "perKmCentavos": null,
  "maximumDistanceKm": null,
  "eligibility": null,
  "updatedAt": null,
} satisfies FleetVehicle

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FleetVehicle
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


