
# VendorSetupDraftVehiclesInner


## Properties

Name | Type
------------ | -------------
`id` | string
`vehicleType` | string
`name` | string
`capacityKg` | number
`numberAvailable` | number
`cargoLengthM` | number
`cargoWidthM` | number
`cargoHeightM` | number
`heavyClassification` | string
`baseFeeCentavos` | number
`perKmCentavos` | number
`maximumDistanceKm` | number

## Example

```typescript
import type { VendorSetupDraftVehiclesInner } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "vehicleType": null,
  "name": null,
  "capacityKg": null,
  "numberAvailable": null,
  "cargoLengthM": null,
  "cargoWidthM": null,
  "cargoHeightM": null,
  "heavyClassification": null,
  "baseFeeCentavos": null,
  "perKmCentavos": null,
  "maximumDistanceKm": null,
} satisfies VendorSetupDraftVehiclesInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorSetupDraftVehiclesInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


