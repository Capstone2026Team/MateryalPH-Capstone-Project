
# ChatCreate


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`listingVariantId` | string
`locationId` | string
`heavyVehicleRestriction` | string
`alternateDropOffLocationId` | string
`accessInstructions` | string
`contextType` | string

## Example

```typescript
import type { ChatCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "listingVariantId": null,
  "locationId": null,
  "heavyVehicleRestriction": null,
  "alternateDropOffLocationId": null,
  "accessInstructions": null,
  "contextType": null,
} satisfies ChatCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


