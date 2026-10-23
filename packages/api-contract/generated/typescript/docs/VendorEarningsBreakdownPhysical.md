
# VendorEarningsBreakdownPhysical


## Properties

Name | Type
------------ | -------------
`records` | number
`cashOnDeliveryCentavos` | number
`inStoreCentavos` | number
`unrecordedCentavos` | number
`unrecordedOrders` | number

## Example

```typescript
import type { VendorEarningsBreakdownPhysical } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "records": null,
  "cashOnDeliveryCentavos": null,
  "inStoreCentavos": null,
  "unrecordedCentavos": null,
  "unrecordedOrders": null,
} satisfies VendorEarningsBreakdownPhysical

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsBreakdownPhysical
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


