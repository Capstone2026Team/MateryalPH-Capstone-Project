
# OrderDeliveryEstimate


## Properties

Name | Type
------------ | -------------
`options` | [Array&lt;DeliveryEstimateOption&gt;](DeliveryEstimateOption.md)
`feeMinCentavos` | number
`feeMaxCentavos` | number
`tripsMin` | number
`tripsMax` | number

## Example

```typescript
import type { OrderDeliveryEstimate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "options": null,
  "feeMinCentavos": null,
  "feeMaxCentavos": null,
  "tripsMin": null,
  "tripsMax": null,
} satisfies OrderDeliveryEstimate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderDeliveryEstimate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


