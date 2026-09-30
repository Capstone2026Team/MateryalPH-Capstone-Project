
# DeliveryPlan


## Properties

Name | Type
------------ | -------------
`advisory` | boolean
`status` | string
`reason` | string
`route` | [DeliveryPlanRoute](DeliveryPlanRoute.md)
`endpoint` | [DeliveryPlanEndpoint](DeliveryPlanEndpoint.md)
`groups` | [Array&lt;DeliveryPlanGroup&gt;](DeliveryPlanGroup.md)
`eligibleVehicles` | [Array&lt;DeliveryPlanVehicle&gt;](DeliveryPlanVehicle.md)
`feeFormula` | [DeliveryPlanFormula](DeliveryPlanFormula.md)
`notice` | string

## Example

```typescript
import type { DeliveryPlan } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "advisory": null,
  "status": null,
  "reason": null,
  "route": null,
  "endpoint": null,
  "groups": null,
  "eligibleVehicles": null,
  "feeFormula": null,
  "notice": null,
} satisfies DeliveryPlan

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPlan
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


