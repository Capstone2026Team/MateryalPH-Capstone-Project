
# DeliveryPlanFormula


## Properties

Name | Type
------------ | -------------
`calculationVersion` | string
`rounding` | string
`finalFeeRule` | string

## Example

```typescript
import type { DeliveryPlanFormula } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "calculationVersion": null,
  "rounding": null,
  "finalFeeRule": null,
} satisfies DeliveryPlanFormula

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryPlanFormula
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


