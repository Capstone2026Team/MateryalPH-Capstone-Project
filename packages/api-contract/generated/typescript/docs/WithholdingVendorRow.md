
# WithholdingVendorRow


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`vendorName` | string
`withholdingEntity` | string
`assessmentCount` | number
`withheldCentavos` | number
`reviewRequired` | number
`calculation` | [WithholdingCalculation](WithholdingCalculation.md)
`filingIssues` | Set&lt;string&gt;

## Example

```typescript
import type { WithholdingVendorRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "vendorName": null,
  "withholdingEntity": null,
  "assessmentCount": null,
  "withheldCentavos": null,
  "reviewRequired": null,
  "calculation": null,
  "filingIssues": null,
} satisfies WithholdingVendorRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingVendorRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


