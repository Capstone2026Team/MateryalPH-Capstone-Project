
# DeliveryPlanEndpoint


## Properties

Name | Type
------------ | -------------
`kind` | string
`heavyVehicleRestriction` | string
`intended` | [OrderPoint](OrderPoint.md)
`alternateDropOff` | [OrderPoint](OrderPoint.md)

## Example

```typescript
import type { DeliveryPlanEndpoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "heavyVehicleRestriction": null,
  "intended": null,
  "alternateDropOff": null,
} satisfies DeliveryPlanEndpoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPlanEndpoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


