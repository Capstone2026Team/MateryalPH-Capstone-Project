
# DeliveryEstimate

Estimate for the system-recommended vehicle per separate load group. Lowest eligible formula fee, then fewer trips and vehicles, with stable vehicle-ID ties. Historical estimates may contain alternative ranges. Vendor confirmation and Buyer approval precede payment.

## Properties

Name | Type
------------ | -------------
`feeMinCentavos` | number
`feeMaxCentavos` | number
`tripsMin` | number
`tripsMax` | number
`vehiclesMin` | number
`vehiclesMax` | number
`options` | [Array&lt;DeliveryEstimateOption&gt;](DeliveryEstimateOption.md)

## Example

```typescript
import type { DeliveryEstimate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "feeMinCentavos": null,
  "feeMaxCentavos": null,
  "tripsMin": null,
  "tripsMax": null,
  "vehiclesMin": null,
  "vehiclesMax": null,
  "options": null,
} satisfies DeliveryEstimate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryEstimate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


