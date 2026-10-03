
# DeliveryEstimateOption


## Properties

Name | Type
------------ | -------------
`loadKey` | string
`vehicleName` | string
`vehicleType` | string
`vehicles` | number
`trips` | number
`feeCentavos` | number
`feePerTripCentavos` | number

## Example

```typescript
import type { DeliveryEstimateOption } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "loadKey": null,
  "vehicleName": null,
  "vehicleType": null,
  "vehicles": null,
  "trips": null,
  "feeCentavos": null,
  "feePerTripCentavos": null,
} satisfies DeliveryEstimateOption

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryEstimateOption
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


