
# WorkPackageBudgetEstimateRequest


## Properties

Name | Type
------------ | -------------
`siteId` | string
`radiusKm` | number
`fulfillmentMethod` | string
`lines` | [Array&lt;WorkPackageBudgetEstimateLineInput&gt;](WorkPackageBudgetEstimateLineInput.md)

## Example

```typescript
import type { WorkPackageBudgetEstimateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "siteId": null,
  "radiusKm": null,
  "fulfillmentMethod": null,
  "lines": null,
} satisfies WorkPackageBudgetEstimateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageBudgetEstimateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


