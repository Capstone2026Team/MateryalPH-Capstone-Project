
# ReadyMixedConcreteDetail

Ready-Mixed Concrete (owner decision 2026-10-16). Quantity is the order volume in m³, each variant is one Required PSI class, and delivery is Site Delivery by Concrete Mixer Truck / Transit Mixer only.

## Properties

Name | Type
------------ | -------------
`quantityLabel` | string
`strengthAttribute` | string
`strengthLabel` | string
`deliveryVehicle` | string
`siteDeliveryOnly` | boolean
`siteInspection` | [ReadyMixedConcreteSiteInspection](ReadyMixedConcreteSiteInspection.md)
`notice` | string

## Example

```typescript
import type { ReadyMixedConcreteDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quantityLabel": null,
  "strengthAttribute": null,
  "strengthLabel": null,
  "deliveryVehicle": null,
  "siteDeliveryOnly": null,
  "siteInspection": null,
  "notice": null,
} satisfies ReadyMixedConcreteDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReadyMixedConcreteDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


