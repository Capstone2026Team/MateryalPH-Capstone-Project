
# CartDestinationUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`intendedLocationId` | string
`heavyVehicleRestriction` | string
`alternateDropOffLocationId` | string
`accessInstructions` | string

## Example

```typescript
import type { CartDestinationUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "intendedLocationId": null,
  "heavyVehicleRestriction": null,
  "alternateDropOffLocationId": null,
  "accessInstructions": null,
} satisfies CartDestinationUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartDestinationUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


