
# DeliveryVehicleProfile

Vehicle display details without private fleet availability counts. Order details preserve the accepted configuration; recommendations are advisory.

## Properties

Name | Type
------------ | -------------
`name` | string
`vehicleCategory` | string
`vehicleType` | string
`customTypeName` | string
`brand` | string
`imageFileId` | string
`capacityKg` | string
`mixerCapacityM3` | string
`cargoLengthM` | string
`cargoWidthM` | string
`cargoHeightM` | string
`heavyClassification` | string

## Example

```typescript
import type { DeliveryVehicleProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "name": null,
  "vehicleCategory": null,
  "vehicleType": null,
  "customTypeName": null,
  "brand": null,
  "imageFileId": null,
  "capacityKg": null,
  "mixerCapacityM3": null,
  "cargoLengthM": null,
  "cargoWidthM": null,
  "cargoHeightM": null,
  "heavyClassification": null,
} satisfies DeliveryVehicleProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryVehicleProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


