
# ChatDestinationUpdate


## Properties

Name | Type
------------ | -------------
`locationId` | string
`heavyVehicleRestriction` | string
`alternateDropOffLocationId` | string
`accessInstructions` | string
`lockVersion` | number

## Example

```typescript
import type { ChatDestinationUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "heavyVehicleRestriction": null,
  "alternateDropOffLocationId": null,
  "accessInstructions": null,
  "lockVersion": null,
} satisfies ChatDestinationUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatDestinationUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


