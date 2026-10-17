
# SiteInspectionCreate


## Properties

Name | Type
------------ | -------------
`listingId` | string
`listingVariantId` | string
`locationId` | string
`heavyVehicleRestriction` | string
`alternateDropOffLocationId` | string
`accessInstructions` | string
`preferredDate` | Date
`notes` | string

## Example

```typescript
import type { SiteInspectionCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "listingVariantId": null,
  "locationId": null,
  "heavyVehicleRestriction": null,
  "alternateDropOffLocationId": null,
  "accessInstructions": null,
  "preferredDate": null,
  "notes": null,
} satisfies SiteInspectionCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SiteInspectionCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


