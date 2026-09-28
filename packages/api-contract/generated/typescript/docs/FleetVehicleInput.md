
# FleetVehicleInput


## Properties

Name | Type
------------ | -------------
`id` | string
`lockVersion` | number
`removed` | boolean
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
`baseFeeCentavos` | number
`perKmCentavos` | number
`maximumDistanceKm` | number

## Example

```typescript
import type { FleetVehicleInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "lockVersion": null,
  "removed": null,
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
  "baseFeeCentavos": null,
  "perKmCentavos": null,
  "maximumDistanceKm": null,
} satisfies FleetVehicleInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FleetVehicleInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


