
# WorkPackageInput


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`name` | string
`description` | string
`budgetCentavos` | number
`siteId` | string
`radiusKm` | number
`fulfillmentMethod` | string
`paymentMethod` | string
`siteContact` | string
`heavyVehicleRestriction` | string
`alternateDropOffLocationId` | string
`accessInstructions` | string
`lines` | [Array&lt;WorkPackageLineInput&gt;](WorkPackageLineInput.md)

## Example

```typescript
import type { WorkPackageInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "name": null,
  "description": null,
  "budgetCentavos": null,
  "siteId": null,
  "radiusKm": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "siteContact": null,
  "heavyVehicleRestriction": null,
  "alternateDropOffLocationId": null,
  "accessInstructions": null,
  "lines": null,
} satisfies WorkPackageInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


