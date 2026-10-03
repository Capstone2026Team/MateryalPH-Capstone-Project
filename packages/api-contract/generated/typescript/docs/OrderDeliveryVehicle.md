
# OrderDeliveryVehicle


## Properties

Name | Type
------------ | -------------
`name` | string
`vehicleCategory` | string
`vehicleType` | string
`customTypeName` | string
`brand` | string
`capacityKg` | string
`heavyClassification` | string
`configurationVersion` | number
`rateVersion` | number
`numberOfVehicles` | number
`totalVehicleTrips` | number
`perTripCentavos` | number
`tripTotalCentavos` | number

## Example

```typescript
import type { OrderDeliveryVehicle } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "name": null,
  "vehicleCategory": null,
  "vehicleType": null,
  "customTypeName": null,
  "brand": null,
  "capacityKg": null,
  "heavyClassification": null,
  "configurationVersion": null,
  "rateVersion": null,
  "numberOfVehicles": null,
  "totalVehicleTrips": null,
  "perTripCentavos": null,
  "tripTotalCentavos": null,
} satisfies OrderDeliveryVehicle

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderDeliveryVehicle
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


