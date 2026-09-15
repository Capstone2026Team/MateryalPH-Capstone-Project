
# VendorVehicle


## Properties

Name | Type
------------ | -------------
`id` | string
`vehicleType` | string
`vehicleSubtype` | string
`customVehicleType` | string
`name` | string
`numberAvailable` | number
`capacityKg` | number
`cargoLengthM` | number
`cargoWidthM` | number
`cargoHeightM` | number
`heavyVehicleClassification` | string
`baseFeeCentavos` | number
`perKmCentavos` | number
`maximumDistanceKm` | number

## Example

```typescript
import type { VendorVehicle } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "vehicleType": null,
  "vehicleSubtype": null,
  "customVehicleType": null,
  "name": null,
  "numberAvailable": null,
  "capacityKg": null,
  "cargoLengthM": null,
  "cargoWidthM": null,
  "cargoHeightM": null,
  "heavyVehicleClassification": null,
  "baseFeeCentavos": null,
  "perKmCentavos": null,
  "maximumDistanceKm": null,
} satisfies VendorVehicle

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorVehicle
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


