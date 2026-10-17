
# WorkPackageBudgetEstimateLine


## Properties

Name | Type
------------ | -------------
`index` | number
`status` | string
`averageUnitPriceCentavos` | number
`amountCentavos` | number
`vendorCount` | number

## Example

```typescript
import type { WorkPackageBudgetEstimateLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "index": null,
  "status": null,
  "averageUnitPriceCentavos": null,
  "amountCentavos": null,
  "vendorCount": null,
} satisfies WorkPackageBudgetEstimateLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageBudgetEstimateLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


