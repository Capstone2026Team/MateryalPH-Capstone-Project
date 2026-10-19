
# VendorCommissionMonitoring


## Properties

Name | Type
------------ | -------------
`termsAccepted` | boolean
`currentPolicy` | [CommissionPolicy](CommissionPolicy.md)
`nextPolicy` | [CommissionPolicy](CommissionPolicy.md)
`summary` | [VendorCommissionSummary](VendorCommissionSummary.md)
`assessments` | [Array&lt;VendorCommissionAssessment&gt;](VendorCommissionAssessment.md)

## Example

```typescript
import type { VendorCommissionMonitoring } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "termsAccepted": null,
  "currentPolicy": null,
  "nextPolicy": null,
  "summary": null,
  "assessments": null,
} satisfies VendorCommissionMonitoring

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorCommissionMonitoring
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


