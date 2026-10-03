
# OrderConfirmedDelivery

The frozen Owner/Manager-confirmed arrangement. Later vehicle, rate, profile or schedule changes never alter it.

## Properties

Name | Type
------------ | -------------
`vehicles` | [Array&lt;OrderDeliveryVehicle&gt;](OrderDeliveryVehicle.md)
`distanceMeters` | number
`routeSource` | string
`basis` | string
`endpoint` | string
`heavyVehicleRestriction` | boolean
`intended` | [OrderPoint](OrderPoint.md)
`alternateDropOff` | [OrderPoint](OrderPoint.md)
`finalFeeCentavos` | number
`fulfillmentDate` | Date
`arrangement` | string
`calculationVersion` | string
`confirmedByRole` | string
`confirmedAt` | Date

## Example

```typescript
import type { OrderConfirmedDelivery } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vehicles": null,
  "distanceMeters": null,
  "routeSource": null,
  "basis": null,
  "endpoint": null,
  "heavyVehicleRestriction": null,
  "intended": null,
  "alternateDropOff": null,
  "finalFeeCentavos": null,
  "fulfillmentDate": null,
  "arrangement": null,
  "calculationVersion": null,
  "confirmedByRole": null,
  "confirmedAt": null,
} satisfies OrderConfirmedDelivery

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderConfirmedDelivery
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


