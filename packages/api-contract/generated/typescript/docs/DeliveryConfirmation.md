
# DeliveryConfirmation


## Properties

Name | Type
------------ | -------------
`vehicles` | [Array&lt;DeliveryVehicleSelection&gt;](DeliveryVehicleSelection.md)
`finalFeeCentavos` | number
`fulfillmentDate` | Date
`arrangement` | string
`accessConfirmed` | boolean
`heavyVehicleAccessConfirmed` | boolean
`manualReviewNote` | string

## Example

```typescript
import type { DeliveryConfirmation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vehicles": null,
  "finalFeeCentavos": null,
  "fulfillmentDate": null,
  "arrangement": null,
  "accessConfirmed": null,
  "heavyVehicleAccessConfirmed": null,
  "manualReviewNote": null,
} satisfies DeliveryConfirmation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryConfirmation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


