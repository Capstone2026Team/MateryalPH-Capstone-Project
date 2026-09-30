
# DeliveryPlanGroup


## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`status` | string
`manualReviewReasons` | Array&lt;string&gt;
`candidates` | [Array&lt;DeliveryPlanVehicle&gt;](DeliveryPlanVehicle.md)

## Example

```typescript
import type { DeliveryPlanGroup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "status": null,
  "manualReviewReasons": null,
  "candidates": null,
} satisfies DeliveryPlanGroup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPlanGroup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


