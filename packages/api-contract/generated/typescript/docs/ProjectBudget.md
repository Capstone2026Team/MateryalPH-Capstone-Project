
# ProjectBudget


## Properties

Name | Type
------------ | -------------
`budgetCentavos` | number
`pendingCentavos` | number
`actualCentavos` | number
`awaitingRecoveryCentavos` | number
`committedCentavos` | number
`remainingCentavos` | number
`utilizationPercent` | string
`warning` | boolean
`label` | string
`allocatedCentavos` | number
`unallocatedCentavos` | number
`pendingConfirmationCount` | number
`processingFeeStatus` | string

## Example

```typescript
import type { ProjectBudget } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "budgetCentavos": null,
  "pendingCentavos": null,
  "actualCentavos": null,
  "awaitingRecoveryCentavos": null,
  "committedCentavos": null,
  "remainingCentavos": null,
  "utilizationPercent": null,
  "warning": null,
  "label": null,
  "allocatedCentavos": null,
  "unallocatedCentavos": null,
  "pendingConfirmationCount": null,
  "processingFeeStatus": null,
} satisfies ProjectBudget

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectBudget
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


