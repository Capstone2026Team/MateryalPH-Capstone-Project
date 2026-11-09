
# WithholdingRegister


## Properties

Name | Type
------------ | -------------
`month` | string
`periodStart` | string
`periodEnd` | string
`environment` | string
`assignmentStatus` | string
`platformWithheldCentavos` | number
`providerWithheldCentavos` | number
`vendorCount` | number
`assessmentCount` | number
`reviewRequired` | number
`vendors` | [Array&lt;WithholdingVendorRow&gt;](WithholdingVendorRow.md)

## Example

```typescript
import type { WithholdingRegister } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "month": null,
  "periodStart": null,
  "periodEnd": null,
  "environment": null,
  "assignmentStatus": null,
  "platformWithheldCentavos": null,
  "providerWithheldCentavos": null,
  "vendorCount": null,
  "assessmentCount": null,
  "reviewRequired": null,
  "vendors": null,
} satisfies WithholdingRegister

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingRegister
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


