
# CartDestination


## Properties

Name | Type
------------ | -------------
`intended` | [CartLocationRef](CartLocationRef.md)
`heavyVehicleRestriction` | string
`alternateDropOff` | [CartLocationRef](CartLocationRef.md)
`vehicleEndpoint` | string
`accessInstructions` | string
`labels` | [CartDestinationLabels](CartDestinationLabels.md)

## Example

```typescript
import type { CartDestination } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "intended": null,
  "heavyVehicleRestriction": null,
  "alternateDropOff": null,
  "vehicleEndpoint": null,
  "accessInstructions": null,
  "labels": null,
} satisfies CartDestination

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartDestination
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


