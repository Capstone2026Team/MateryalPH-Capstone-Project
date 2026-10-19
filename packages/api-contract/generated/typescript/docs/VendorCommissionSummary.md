
# VendorCommissionSummary


## Properties

Name | Type
------------ | -------------
`estimatedCentavos` | number
`earnedCentavos` | number
`creditedCentavos` | number
`netEarnedCentavos` | number
`unbilledCentavos` | number
`draftCentavos` | number
`outstandingCentavos` | number
`overdueCentavos` | number
`collectedCentavos` | number
`refundedCentavos` | number
`netCollectedCentavos` | number

## Example

```typescript
import type { VendorCommissionSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "estimatedCentavos": null,
  "earnedCentavos": null,
  "creditedCentavos": null,
  "netEarnedCentavos": null,
  "unbilledCentavos": null,
  "draftCentavos": null,
  "outstandingCentavos": null,
  "overdueCentavos": null,
  "collectedCentavos": null,
  "refundedCentavos": null,
  "netCollectedCentavos": null,
} satisfies VendorCommissionSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorCommissionSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


