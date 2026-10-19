
# VendorCommissionAssessment


## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`state` | string
`commissionBasisCentavos` | number
`commissionBasisPoints` | number
`estimatedCentavos` | number
`earnedCentavos` | number
`creditedCentavos` | number
`netCentavos` | number
`disputeHold` | boolean
`earnedAt` | Date

## Example

```typescript
import type { VendorCommissionAssessment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "state": null,
  "commissionBasisCentavos": null,
  "commissionBasisPoints": null,
  "estimatedCentavos": null,
  "earnedCentavos": null,
  "creditedCentavos": null,
  "netCentavos": null,
  "disputeHold": null,
  "earnedAt": null,
} satisfies VendorCommissionAssessment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorCommissionAssessment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


