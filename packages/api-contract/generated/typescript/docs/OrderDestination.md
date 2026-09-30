
# OrderDestination

The intended destination/Project site and the heavy-vehicle alternate drop-off stay separate; vehicle_endpoint names the actual drop-off.

## Properties

Name | Type
------------ | -------------
`type` | string
`storeAddress` | string
`intended` | [OrderPoint](OrderPoint.md)
`heavyVehicleRestriction` | string
`alternateDropOff` | [OrderPoint](OrderPoint.md)
`vehicleEndpoint` | string
`accessInstructions` | string

## Example

```typescript
import type { OrderDestination } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "type": null,
  "storeAddress": null,
  "intended": null,
  "heavyVehicleRestriction": null,
  "alternateDropOff": null,
  "vehicleEndpoint": null,
  "accessInstructions": null,
} satisfies OrderDestination

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderDestination
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


