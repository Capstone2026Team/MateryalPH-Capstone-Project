
# WorkPackageBudgetEstimate


## Properties

Name | Type
------------ | -------------
`deliveryCentavos` | number
`estimatedTotalCentavos` | number
`deliveryStatus` | string
`deliveryIssues` | Array&lt;string&gt;
`fulfillmentMethod` | string
`lines` | [Array&lt;WorkPackageBudgetEstimateLine&gt;](WorkPackageBudgetEstimateLine.md)
`materialsTotalCentavos` | number
`pricedLineCount` | number
`unpricedLineCount` | number
`radiusKm` | number
`basis` | string
`excludes` | Array&lt;string&gt;
`computedAt` | string

## Example

```typescript
import type { WorkPackageBudgetEstimate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "deliveryCentavos": null,
  "estimatedTotalCentavos": null,
  "deliveryStatus": null,
  "deliveryIssues": null,
  "fulfillmentMethod": null,
  "lines": null,
  "materialsTotalCentavos": null,
  "pricedLineCount": null,
  "unpricedLineCount": null,
  "radiusKm": null,
  "basis": null,
  "excludes": null,
  "computedAt": null,
} satisfies WorkPackageBudgetEstimate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageBudgetEstimate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


