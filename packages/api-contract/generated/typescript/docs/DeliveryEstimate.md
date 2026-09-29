
# DeliveryEstimate

Advisory range across the Vendor\'s eligible vehicles. Not an offer; the Vendor confirms vehicles, trips and the final fee.

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


